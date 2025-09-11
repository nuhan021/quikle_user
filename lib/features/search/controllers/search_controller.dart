// features/search/controllers/search_controller.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/services/home_services.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';

class ProductSearchController extends GetxController {
  final HomeService _homeService = HomeService();
  late final CartController _cartController;

  final TextEditingController searchController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();

  static ProductSearchController? get currentInstance {
    try {
      return Get.find<ProductSearchController>();
    } catch (e) {
      return null;
    }
  }

  final _searchQuery = ''.obs;
  final _searchResults = <ProductModel>[].obs;
  final _recentSearches = <String>[].obs;
  final _isLoading = false.obs;
  final _isListening = false.obs;
  final _currentPlaceholder = "Search for 'biryani'".obs;

  final RxDouble soundLevel = 0.0.obs;

  late Timer _placeholderTimer;
  Timer? _debounceTimer;

  final List<String> _placeholderItems = [
    'biryani',
    'pizza',
    'burger',
    'ice cream',
    'pasta',
    'sushi',
    'tacos',
    'noodles',
    'sandwich',
    'salad',
    'coffee',
    'juice',
    'medicine',
    'vitamins',
    'groceries',
    'milk',
    'bread',
    'fruits',
    'vegetables',
    'snacks',
  ];

  final List<String> popularSearches = [
    'Pizza',
    'Burger',
    'Ice Cream',
    'Pasta',
    'Biryani',
    'Coffee',
    'Medicine',
    'Groceries',
  ];

  String get searchQuery => _searchQuery.value;
  List<ProductModel> get searchResults => _searchResults;
  List<String> get recentSearches => _recentSearches;
  bool get isLoading => _isLoading.value;
  bool get isListening => _isListening.value;
  RxString get currentPlaceholder => _currentPlaceholder;

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();
    _loadRecentSearches();
    _initSpeechToText();
    _startPlaceholderRotation();
  }

  @override
  void onClose() {
    searchController.dispose();
    _placeholderTimer.cancel();
    _debounceTimer?.cancel();
    super.onClose();
  }

  void _startPlaceholderRotation() {
    _placeholderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final randomIndex = Random().nextInt(_placeholderItems.length);
      final randomItem = _placeholderItems[randomIndex];
      _currentPlaceholder.value = "Search for '$randomItem'";
    });
  }

  Future<void> _initSpeechToText() async {
    try {
      final permissionStatus = await Permission.microphone.request();
      if (permissionStatus == PermissionStatus.granted) {
        await _speechToText.initialize(
          onStatus: (status) {
            _isListening.value =
                status == 'listening' || _speechToText.isListening;
          },
          onError: (errorNotification) {
            _isListening.value = false;
            soundLevel.value = 0.0;
            Get.snackbar(
              'Voice Recognition Error',
              'Could not recognize speech. Please try again.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
          },
        );
      } else {
        Get.snackbar(
          'Permission Denied',
          'Microphone permission is required for voice search.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint('Error initializing speech to text: $e');
    }
  }

  Future<void> toggleVoiceRecognition() async {
    if (!_speechToText.isAvailable) {
      Get.snackbar(
        'Voice Search Unavailable',
        'Speech recognition is not available on this device.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (_isListening.value) {
      await _speechToText.stop();
      _isListening.value = false;
      soundLevel.value = 0.0;
      _currentPlaceholder.value = "Search for 'biryani'";
    } else {
      _isListening.value = true;
      _currentPlaceholder.value = 'Speak now';
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            searchController.text = result.recognizedWords;
            onSearchChanged(result.recognizedWords);
            _isListening.value = false;
            soundLevel.value = 0.0;
            _currentPlaceholder.value = "Search for 'biryani'";
          }
        },
        onSoundLevelChange: (level) {
          final norm = level.clamp(0.0, 60.0) / 60.0;
          soundLevel.value = norm;
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'en_US',
      );
    }
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searches = prefs.getStringList('recent_searches') ?? [];
      _recentSearches.value = searches;
    } catch (e) {
      debugPrint('Error loading recent searches: $e');
    }
  }

  Future<void> _saveRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_searches', _recentSearches);
    } catch (e) {
      debugPrint('Error saving recent searches: $e');
    }
  }

  void onSearchChanged(String query) {
    _searchQuery.value = query;
    if (query.isEmpty) {
      _searchResults.clear();
      return;
    }
    _debounceSearch(query);
  }

  void _debounceSearch(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;
    _isLoading.value = true;

    try {
      final allProducts = await _homeService.fetchAllProducts();
      final filteredProducts = allProducts.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase());
      }).toList();

      _searchResults.value = filteredProducts;
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches.removeRange(10, _recentSearches.length);
        }
        await _saveRecentSearches();
      }
    } catch (e) {
      debugPrint('Error performing search: $e');
      Get.snackbar(
        'Search Error',
        'Unable to search products. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void selectSuggestion(String suggestion) {
    searchController.text = suggestion;
    onSearchChanged(suggestion);
  }

  void clearRecentSearches() {
    _recentSearches.clear();
    _saveRecentSearches();
  }

  void onProductPressed(ProductModel product) {
    Get.toNamed(AppRoute.getProductDetails(), arguments: product);
  }

  void onAddToCartPressed(ProductModel product) {
    _cartController.addToCart(product);
  }

  void onFavoriteToggle(ProductModel product) {
    if (FavoritesController.isProductFavorite(product.id)) {
      FavoritesController.removeFromGlobalFavorites(product.id);
    } else {
      FavoritesController.addToGlobalFavorites(product.id);
    }
    final index = _searchResults.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      final isFavorite = FavoritesController.isProductFavorite(product.id);
      final updatedProduct = product.copyWith(isFavorite: isFavorite);
      _searchResults[index] = updatedProduct;
    }

    Get.snackbar(
      FavoritesController.isProductFavorite(product.id)
          ? 'Added to Favorites'
          : 'Removed from Favorites',
      FavoritesController.isProductFavorite(product.id)
          ? '${product.title} has been added to your favorites.'
          : '${product.title} has been removed from your favorites.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}

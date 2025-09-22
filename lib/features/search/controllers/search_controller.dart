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
import 'package:quikle_user/core/services/whatsapp_service.dart';

class ProductSearchController extends GetxController {
  final HomeService _homeService = HomeService();
  late final CartController _cartController;

  final TextEditingController searchController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();

  // Optional callback when voice search completes
  Function(String)? onVoiceSearchCompleted;

  static ProductSearchController? get currentInstance {
    try {
      return Get.find<ProductSearchController>();
    } catch (_) {
      return null;
    }
  }

  final _searchQuery = ''.obs;
  final _searchResults = <ProductModel>[].obs;
  final _recentSearches = <String>[].obs;
  final _isLoading = false.obs;

  final _isListening = false.obs;
  bool get isListening => _isListening.value;

  final _currentPlaceholder = "Search for 'biryani'".obs;
  RxString get currentPlaceholder => _currentPlaceholder;

  final RxDouble soundLevel = 0.0.obs;

  late Timer _placeholderTimer;
  Timer? _debounceTimer;

  // NEW: lazy init guard
  bool _speechInitialized = false;

  final List<String> placeholderItems = [
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

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();
    _loadRecentSearches();
    _startPlaceholderRotation();

    // IMPORTANT: do NOT ask for mic here (lazy on first tap)
    // do not call _initSpeechToText() here anymore
  }

  @override
  void onClose() {
    searchController.dispose();
    _placeholderTimer.cancel();
    _debounceTimer?.cancel();
    super.onClose();
  }

  void _startPlaceholderRotation() {
    _placeholderTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      final randomIndex = Random().nextInt(placeholderItems.length);
      final randomItem = placeholderItems[randomIndex];
      _currentPlaceholder.value = "Search for '$randomItem'";
    });
  }

  /// NEW: ask for permissions & initialize speech lazily
  Future<bool> _ensureMicAndSpeechThenInit() async {
    // Request microphone
    final mic = await Permission.microphone.request();

    // On iOS also request speech
    PermissionStatus speech = PermissionStatus.granted;
    if (GetPlatform.isIOS) {
      speech = await Permission.speech.request();
    }

    // Handle permanently denied
    if (mic.isPermanentlyDenied || speech.isPermanentlyDenied) {
      Get.snackbar(
        'Permission Needed',
        'Please enable Microphone${GetPlatform.isIOS ? " & Speech" : ""} access in Settings.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      openAppSettings();
      return false;
    }

    // If not granted -> explain and bail
    if (!mic.isGranted || (GetPlatform.isIOS && !speech.isGranted)) {
      Get.snackbar(
        'Permission Denied',
        'Microphone${GetPlatform.isIOS ? " & Speech" : ""} permission is required for voice search.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    // Init speech_to_text once
    if (!_speechInitialized) {
      final ok = await _speechToText.initialize(
        onStatus: (s) => _isListening.value = _speechToText.isListening,
        onError: (_) {
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
      _speechInitialized = ok;
      if (!ok) {
        Get.snackbar(
          'Voice Search Unavailable',
          'Speech recognition is not available on this device.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
      return ok;
    }

    return true;
  }

  Future<void> toggleVoiceRecognition() async {
    // Ensure permissions + init only when needed
    if (!_speechInitialized) {
      final ok = await _ensureMicAndSpeechThenInit();
      if (!ok) return;
    }

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
            final words = result.recognizedWords;
            searchController.text = words;
            onSearchChanged(words);
            _isListening.value = false;
            soundLevel.value = 0.0;
            _currentPlaceholder.value = "Search for 'biryani'";

            if (onVoiceSearchCompleted != null && words.isNotEmpty) {
              onVoiceSearchCompleted!(words);
            }
          }
        },
        onSoundLevelChange: (level) {
          final norm = level.clamp(0.0, 60.0) / 60.0;
          soundLevel.value = norm;
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
        listenOptions: SpeechListenOptions(partialResults: true),
      );
    }
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _recentSearches.value = prefs.getStringList('recent_searches') ?? [];
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
      final filtered = allProducts.where((p) {
        return p.title.toLowerCase().contains(query.toLowerCase()) ||
            p.description.toLowerCase().contains(query.toLowerCase());
      }).toList();

      _searchResults.value = filtered;

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
      final isFav = FavoritesController.isProductFavorite(product.id);
      _searchResults[index] = product.copyWith(isFavorite: isFav);
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

  Future<void> onRequestCustomOrder() async {
    if (_searchQuery.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a search query first',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      await WhatsAppService.requestCustomOrder(
        searchQuery: _searchQuery.value,
        userName: null,
      );
    } catch (e) {
      debugPrint('Error opening WhatsApp: $e');
      Get.snackbar(
        'Error',
        'Failed to open WhatsApp. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }
}

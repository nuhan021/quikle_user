import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/search/data/services/search_service.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';
import 'package:quikle_user/core/services/whatsapp_service.dart';

class ProductSearchController extends GetxController {
  final SearchService _searchService = SearchService();
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
  final _isLoadingMore = false.obs;
  final _hasSearched = false.obs; // Track if user has performed a search

  // Pagination
  final _currentOffset = 0.obs;
  final _totalResults = 0.obs;
  final _hasMoreResults = true.obs;
  static const int _pageSize = 20;

  final _isListening = false.obs;
  bool get isListening => _isListening.value;

  final _currentPlaceholder = "Search for 'biryani'".obs;
  RxString get currentPlaceholder => _currentPlaceholder;

  final RxDouble soundLevel = 0.0.obs;

  late Timer _placeholderTimer;

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
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasMoreResults => _hasMoreResults.value;
  bool get hasSearched => _hasSearched.value; // Getter for search state

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
    super.onClose();
  }

  // Clear search when screen is disposed (going back)
  void clearSearch() {
    searchController.clear();
    _searchQuery.value = '';
    _searchResults.clear();
    _hasSearched.value = false;
    _currentOffset.value = 0;
    _hasMoreResults.value = true;
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
            _isListening.value = false;
            soundLevel.value = 0.0;
            _currentPlaceholder.value = "Search for 'biryani'";

            // Trigger the search immediately when voice input is complete
            if (words.isNotEmpty) {
              performSearchNow(words);
            }

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
    // Don't auto-search on every keystroke, wait for user to hit enter
  }

  // New method to perform search immediately (called when user hits enter)
  void performSearchNow(String query) {
    if (query.isNotEmpty) {
      // Reset pagination when starting new search
      _currentOffset.value = 0;
      _searchResults.clear();
      _hasMoreResults.value = true;
      _hasSearched.value = true; // Mark that user has searched
      _performSearch(query);
    }
  }

  // Load more results (pagination)
  Future<void> loadMoreResults() async {
    if (_isLoadingMore.value ||
        !_hasMoreResults.value ||
        _searchQuery.value.isEmpty) {
      return;
    }

    _isLoadingMore.value = true;
    _currentOffset.value += _pageSize;

    try {
      await _performSearch(_searchQuery.value, append: true);
    } finally {
      _isLoadingMore.value = false;
    }
  }

  Future<void> _performSearch(String query, {bool append = false}) async {
    if (query.isEmpty) return;

    if (!append) {
      _isLoading.value = true;
    }

    try {
      final result = await _searchService.searchProducts(
        query: query,
        offset: _currentOffset.value,
        limit: _pageSize,
      );

      List<ProductModel> products = result['products'] as List<ProductModel>;

      // Filter to show only OTC medicines
      products = products.where((product) {
        // If it's a medicine (assuming category_id 2 is medicine based on API response),
        // only show if isOTC is true
        if (product.categoryId == 2) {
          return product.isOTC == true;
        }
        // For non-medicine items, show all
        return true;
      }).toList();

      if (append) {
        _searchResults.addAll(products);
      } else {
        _searchResults.value = products;
      }

      _totalResults.value = result['total'] ?? 0;

      // Check if there are more results
      final currentTotal = _currentOffset.value + products.length;
      _hasMoreResults.value = currentTotal < _totalResults.value;

      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches.removeRange(10, _recentSearches.length);
        }
        await _saveRecentSearches();
      }
    } catch (e) {
      debugPrint('Error performing search: $e');
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Unable to search products. Please try again.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void selectSuggestion(String suggestion) {
    searchController.text = suggestion;
    performSearchNow(suggestion);
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
    Get.find<FavoritesController>().toggleFavorite(product);
    final index = _searchResults.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      final isFav = FavoritesController.isProductFavorite(product.id);
      _searchResults[index] = product.copyWith(isFavorite: isFav);
    }

    // Get.snackbar(
    //   FavoritesController.isProductFavorite(product.id)
    //       ? 'Added to Favorites'
    //       : 'Removed from Favorites',
    //   FavoritesController.isProductFavorite(product.id)
    //       ? '${product.title} has been added to your favorites.'
    //       : '${product.title} has been removed from your favorites.',
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: const Duration(seconds: 2),
    // );
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

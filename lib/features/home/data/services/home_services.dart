import 'dart:async';
import 'package:get/get.dart';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/notification/controllers/notification_controller.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';
import 'package:quikle_user/core/data/services/category_cache_service.dart';

class HomeService {
  final ProductDataService _productService = ProductDataService();
  final NetworkCaller _networkCaller = NetworkCaller();
  final CategoryCacheService _cacheService = CategoryCacheService();

  /// Fetches the FCM token from [NotificationController] and saves it to the
  /// backend/DB if available.
  Future<void> saveFCMToken() async {
    try {
      final notificationController = Get.find<NotificationController>();
      final token = await notificationController.getFCMToken();
      if (token != null && token.isNotEmpty) {
        await notificationController.saveFCMToken(token);
      }
    } catch (e) {
      // Avoid crashing the flow if token saving fails. Keep logging for
      // basic diagnostics.
      print('Could not save FCM token on welcome screen: $e');
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final ResponseData response = await _networkCaller.getRequest(
      ApiConstants.getAllCategories,
    );

    if (response.isSuccess) {
      final List data = response.responseData as List;

      final categories = data
          .map((json) => CategoryModel.fromJson(json))
          .toList();

      categories.insert(
        0,
        const CategoryModel(
          id: '0',
          title: 'All',
          type: 'All',
          iconPath: ImagePath.allIcon,
        ),
      );

      return categories;
    } else {
      throw Exception("Failed to load categories: ${response.errorMessage}");
    }
  }

  Future<List<ProductSectionModel>> fetchProductSections() async {
    // Try to load from cache first
    final cachedSections = await _cacheService.getCachedHomeProductSections();

    if (cachedSections != null && cachedSections.isNotEmpty) {
      print('📦 Loaded ${cachedSections.length} product sections from cache');

      // Return cached data immediately, then fetch fresh data in background
      _fetchAndCacheProductSections();

      return cachedSections;
    }

    // No cache available, fetch from API
    print('🌐 Fetching product sections from API');
    return await _fetchAndCacheProductSections();
  }

  /// Internal method to fetch and cache product sections
  Future<List<ProductSectionModel>> _fetchAndCacheProductSections() async {
    final List<Future<List<ProductModel>>> productFutures = [
      _productService.getProductsByCategory('1', limit: 6),
      _productService.getProductsByCategory('2', limit: 6),
      _productService.getProductsByCategory('3', limit: 6),
      _productService.getProductsByCategory('4', limit: 6),
      _productService.getProductsByCategory('5', limit: 6),
      _productService.getProductsByCategory('6', limit: 6),
    ];

    final List<List<ProductModel>> results = await Future.wait(productFutures);

    final sections = [
      ProductSectionModel(
        id: 'section_1',
        viewAllText: 'View all',
        products: results[0],
        categoryId: '1',
      ),
      ProductSectionModel(
        id: 'section_2',
        viewAllText: 'View all',
        products: results[1],
        categoryId: '2',
      ),
      ProductSectionModel(
        id: 'section_3',
        viewAllText: 'View all',
        products: results[2],
        categoryId: '3',
      ),
      ProductSectionModel(
        id: 'section_4',
        viewAllText: 'View all',
        products: results[3],
        categoryId: '4',
      ),
      ProductSectionModel(
        id: 'section_5',
        viewAllText: 'View all',
        products: results[4],
        categoryId: '5',
      ),
      ProductSectionModel(
        id: 'section_6',
        viewAllText: 'View all',
        products: results[5],
        categoryId: '6',
      ),
    ];

    // Cache the sections
    await _cacheService.cacheHomeProductSections(sections);
    print('💾 Cached ${sections.length} product sections');

    return sections;
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    return [];
  }
}

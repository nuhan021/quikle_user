import 'package:quikle_user/core/data/services/product_data_service.dart';
import 'package:quikle_user/features/restaurants/data/services/restaurant_service.dart';

/// Helper class to show restaurant-product mappings for testing
class RestaurantProductMappingHelper {
  static final ProductDataService _productService = ProductDataService();
  static final RestaurantService _restaurantService = RestaurantService();

  /// Get all products grouped by restaurant
  static Future<Map<String, List<Map<String, dynamic>>>>
  getRestaurantProductMapping() async {
    final restaurants = await _restaurantService.getAllRestaurants();
    final products = _productService.allProducts;

    Map<String, List<Map<String, dynamic>>> mapping = {};

    for (var restaurant in restaurants) {
      final restaurantProducts = products
          .where((product) => product.shopId == restaurant.id)
          .map(
            (product) => {
              'name': product.title,
              'type': product.productType ?? 'unknown',
              'subcategory': product.subcategoryId ?? 'unknown',
              'price': product.price,
            },
          )
          .toList();

      if (restaurantProducts.isNotEmpty) {
        mapping[restaurant.name] = restaurantProducts;
      }
    }

    return mapping;
  }

  /// Get products by type for a specific restaurant
  static Map<String, List<String>> getProductTypesByRestaurant(
    String restaurantId,
  ) {
    final products = _productService.allProducts
        .where((product) => product.shopId == restaurantId)
        .toList();

    Map<String, List<String>> typeMapping = {};

    for (var product in products) {
      final type = product.productType ?? 'unknown';
      if (!typeMapping.containsKey(type)) {
        typeMapping[type] = [];
      }
      typeMapping[type]!.add(product.title);
    }

    return typeMapping;
  }

  /// Print restaurant-product mapping for debugging
  static Future<void> printRestaurantMapping() async {
    final mapping = await getRestaurantProductMapping();

    print('=== RESTAURANT-PRODUCT MAPPING ===');
    mapping.forEach((restaurantName, products) {
      print('\n🏪 $restaurantName:');

      // Group by product type
      Map<String, List<Map<String, dynamic>>> typeGroups = {};
      for (var product in products) {
        final type = product['type'] as String;
        if (!typeGroups.containsKey(type)) {
          typeGroups[type] = [];
        }
        typeGroups[type]!.add(product);
      }

      typeGroups.forEach((type, items) {
        print('  📋 ${type.toUpperCase()}:');
        for (var item in items) {
          print('    • ${item['name']} (${item['price']})');
        }
      });
    });
  }
}

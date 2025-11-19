/// Helper class to show restaurant-product mappings for testing
/// Note: Static data removed - restaurant products should come from API
class RestaurantProductMappingHelper {
  /// Get all products grouped by restaurant
  static Future<Map<String, List<Map<String, dynamic>>>>
  getRestaurantProductMapping() async {
    // Static data removed - use API calls instead
    return {};
  }

  /// Get products by type for a specific restaurant
  static Map<String, List<String>> getProductTypesByRestaurant(
    String restaurantId,
  ) {
    // Static data removed - use API calls instead
    return {};
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

import 'package:quikle_user/features/restaurants/data/models/restaurant_model.dart';
import 'package:quikle_user/features/restaurants/data/services/restaurant_api_service.dart';

class RestaurantService {
  final RestaurantApiService _apiService = RestaurantApiService();

  Future<List<RestaurantModel>> getAllRestaurants() async {
    return await _apiService.getRestaurants();
  }

  Future<List<RestaurantModel>> getTopRestaurants({int limit = 25}) async {
    return await _apiService.getTopRestaurants(limit: limit);
  }

  Future<List<RestaurantModel>> getRestaurantsByCategory(
    String categoryId,
  ) async {
    final restaurants = await getAllRestaurants();
    return restaurants
        .where((restaurant) => restaurant.servesCategory(categoryId))
        .toList();
  }

  Future<RestaurantModel?> getRestaurantById(String restaurantId) async {
    try {
      final restaurants = await getAllRestaurants();
      return restaurants.firstWhere(
        (restaurant) => restaurant.id == restaurantId,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<RestaurantModel>> getTopRatedRestaurants({int limit = 10}) async {
    final restaurants = await getAllRestaurants();
    final topRated = restaurants
        .where((restaurant) => restaurant.isTopRated)
        .toList();
    topRated.sort((a, b) => b.rating.compareTo(a.rating));
    return topRated.take(limit).toList();
  }

  Future<List<RestaurantModel>> searchRestaurants(String query) async {
    final restaurants = await getAllRestaurants();
    final lowercaseQuery = query.toLowerCase();
    return restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(lowercaseQuery) ||
          restaurant.cuisines.any(
            (cuisine) => cuisine.name.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }
}

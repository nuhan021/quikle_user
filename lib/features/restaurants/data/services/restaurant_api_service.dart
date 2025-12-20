import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/restaurants/data/models/restaurant_model.dart';

/// Restaurant API Service
///
/// Handles fetching restaurants from the backend API.
class RestaurantApiService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Get all restaurants from API
  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      AppLoggerHelper.debug('Fetching restaurants from API');

      final ResponseData response = await _networkCaller.getRequest(
        ApiConstants.getRestaurants,
      );

      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData as Map<String, dynamic>;

        if (data['success'] == true && data['data'] != null) {
          final restaurantsList = data['data'] as List<dynamic>;

          final restaurants = restaurantsList
              .map(
                (json) =>
                    RestaurantModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();

          AppLoggerHelper.debug(
            '✅ Fetched ${restaurants.length} restaurants from API',
          );
          return restaurants;
        }
      }

      AppLoggerHelper.warning('No restaurants found or API call failed');
      return [];
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching restaurants', e);
      throw Exception('Failed to fetch restaurants: $e');
    }
  }

  /// Get top restaurants (sorted by rating and popularity)
  Future<List<RestaurantModel>> getTopRestaurants({int limit = 25}) async {
    try {
      final restaurants = await getRestaurants();

      // Sort by: has signature dishes first, then by number of cuisines
      restaurants.sort((a, b) {
        // Restaurants with signature dishes come first
        if (a.signatureDishes.isNotEmpty && b.signatureDishes.isEmpty) {
          return -1;
        }
        if (a.signatureDishes.isEmpty && b.signatureDishes.isNotEmpty) {
          return 1;
        }

        // Then by number of cuisines (more is better)
        final cuisineCompare = b.cuisines.length.compareTo(a.cuisines.length);
        if (cuisineCompare != 0) return cuisineCompare;

        // Then alphabetically by name
        return a.name.compareTo(b.name);
      });

      return restaurants.take(limit).toList();
    } catch (e) {
      AppLoggerHelper.error('❌ Error fetching top restaurants', e);
      return [];
    }
  }
}

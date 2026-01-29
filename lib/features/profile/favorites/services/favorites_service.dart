import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';

class FavoritesService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<Map<String, dynamic>?> addToFavorites(int itemId) async {
    final token = StorageService.token;
    final refreshToken = StorageService.refreshToken;

    AppLoggerHelper.debug('Adding to favorites: itemId=$itemId');

    if (token == null || refreshToken == null) {
      print('No token found');
      return null;
    }

    try {
      final ResponseData response = await _networkCaller.postRequest(
        ApiConstants.favorites,
        body: {'item_id': itemId},
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': refreshToken,
        },
      );

      if (response.isSuccess && response.responseData != null) {
        AppLoggerHelper.debug('Favorite added successfully');
        return response.responseData as Map<String, dynamic>;
      } else {
        print('Failed to add favorite: ${response.errorMessage}');
        return null;
      }
    } catch (e) {
      print('Error adding favorite: $e');
      return null;
    }
  }

  Future<List<ProductModel>> getFavoriteProducts() async {
    final token = StorageService.token;
    final refreshToken = StorageService.refreshToken;

    if (token == null || refreshToken == null) {
      print('No token found');
      return [];
    }

    try {
      final ResponseData response = await _networkCaller.getRequest(
        ApiConstants.favorites,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': refreshToken,
        },
      );

      if (response.isSuccess && response.responseData != null) {
        final List data = response.responseData;

        return data.map((favItem) {
          final productJson = favItem['item'] as Map<String, dynamic>;

          // Inject needed fields so ProductModel works correctly
          productJson['category_id'] =
              productJson['category']?['id']?.toString() ?? '';

          productJson['subcategory_id'] =
              productJson['subcategory']?['id']?.toString() ?? '';

          productJson['isFavorite'] = true;

          return ProductModel.fromJson(productJson);
        }).toList();
      } else {
        print('Failed to get favorites: ${response.errorMessage}');
        return [];
      }
    } catch (e) {
      print('Error getting favorites: $e');
      return [];
    }
  }

  Future<bool> removeFromFavorites(int itemId) async {
    final token = StorageService.token;
    final refreshToken = StorageService.refreshToken;

    AppLoggerHelper.debug('Removing from favorites: itemId=$itemId');

    if (token == null || refreshToken == null) {
      print('No token found');
      return false;
    }

    try {
      final ResponseData response = await _networkCaller.deleteRequest(
        '${ApiConstants.favorites}$itemId',
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': refreshToken,
        },
      );

      if (response.isSuccess) {
        AppLoggerHelper.debug('Favorite removed successfully');
        return true;
      } else {
        print('Failed to remove favorite: ${response.errorMessage}');
        return false;
      }
    } catch (e) {
      print('Error removing favorite: $e');
      return false;
    }
  }
}

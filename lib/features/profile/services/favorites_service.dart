import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';

class FavoritesService {
  static const String baseUrl = 'https://quikle-u4dv.onrender.com';
  static const String favoritesEndpoint = '/favourites/favorites/';

  Future<Map<String, dynamic>?> addToFavorites(int itemId) async {
    final token = StorageService.token;
    final refreshToken = StorageService.refreshToken;

    AppLoggerHelper.debug('Adding to favorites: itemId=$itemId');

    if (token == null || refreshToken == null) {
      print('No token found');
      return null;
    }

    try {
      final url = Uri.parse('$baseUrl$favoritesEndpoint');
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'refresh-token': refreshToken,
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'item_id': itemId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLoggerHelper.debug('Favorite added successfully');
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        print(
          'Failed to add favorite: ${response.statusCode} ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('Error adding favorite: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final token = StorageService.token;
    final refreshToken = StorageService.refreshToken;

    AppLoggerHelper.debug('Getting favorites');

    if (token == null || refreshToken == null) {
      print('No token found');
      return [];
    }

    try {
      final url = Uri.parse('$baseUrl$favoritesEndpoint');
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'refresh-token': refreshToken,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        AppLoggerHelper.debug('Favorites retrieved successfully');
        final data = jsonDecode(response.body) as List;
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        print(
          'Failed to get favorites: ${response.statusCode} ${response.body}',
        );
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
      final url = Uri.parse('$baseUrl$favoritesEndpoint$itemId');
      final response = await http.delete(
        url,
        headers: {
          'accept': 'application/json',
          'refresh-token': refreshToken,
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        AppLoggerHelper.debug('Favorite removed successfully');
        return true;
      } else {
        print(
          'Failed to remove favorite: ${response.statusCode} ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Error removing favorite: $e');
      return false;
    }
  }
}

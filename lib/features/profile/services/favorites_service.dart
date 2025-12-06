import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';

class FavoritesService {
  static const String baseUrl = 'https://quikle-u4dv.onrender.com';
  static const String favoritesEndpoint = '/favourites/favorites/';

  Future<bool> addToFavorites(int itemId) async {
    final token = StorageService.token;
    final refreshToken = StorageService.refreshToken;

    AppLoggerHelper.debug('Adding to favorites: itemId=$itemId');

    if (token == null || refreshToken == null) {
      print('No token found');
      return false;
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
        // Assuming success
        return true;
      } else {
        print(
          'Failed to add favorite: ${response.statusCode} ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Error adding favorite: $e');
      return false;
    }
  }
}

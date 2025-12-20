import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';

class NotificationService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<ResponseData> saveFCMToken(String fcmToken) async {
    try {
      final userId = StorageService.userId;
      final authToken = StorageService.token;

      String platform = '';
      if (kIsWeb) {
        platform = 'web';
      } else if (Platform.isAndroid) {
        platform = 'android';
      } else if (Platform.isIOS) {
        platform = 'ios';
      } else {
        platform = 'unknown';
      }

      final response = await _networkCaller.postRequest(
        ApiConstants.saveFcmToken,
        headers: {'Authorization': 'Bearer $authToken'},
        body: {'user_id': userId, 'token': fcmToken, 'platform': platform},
      );

      AppLoggerHelper.debug('saveFCMToken response: ${response.responseData}');
      AppLoggerHelper.debug('saveFCMToken statusCode: ${response.statusCode}');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

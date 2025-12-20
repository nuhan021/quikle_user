import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quikle_user/core/notification/services/notification_service.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';

class NotificationController extends GetxController {
  //Call the saveFCMToken from NotificationService here when needed
  Future<void> saveFCMToken(String token) async {
    final notificationService = Get.find<NotificationService>();
    try {
      final response = await notificationService.saveFCMToken(token);
      AppLoggerHelper.debug('saveFCMToken response: ${response.responseData}');
      AppLoggerHelper.debug('saveFCMToken statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        // Token saved successfully
        AppLoggerHelper.debug('FCM Token saved successfully.');
      } else {
        // Handle failure
        AppLoggerHelper.debug(
          'Failed to save FCM Token: ${response.responseData}',
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error saving FCM Token: $e');
    }
  }

  //Get the FCM Token
  Future<String?> getFCMToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request permissions for iOS
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      AppLoggerHelper.debug(
        'Notification permission status: ${settings.authorizationStatus}',
      );

      String? token = await messaging.getToken();
      AppLoggerHelper.debug('FCM Token: $token');
      return token;
    } catch (e) {
      AppLoggerHelper.error('Error getting FCM Token: $e');
      return null;
    }
  }

  // Get FCM Token and save it automatically
  Future<void> getAndSaveFCMToken() async {
    try {
      String? token = await getFCMToken();
      if (token != null) {
        await saveFCMToken(token);
      } else {
        AppLoggerHelper.error('Failed to get FCM token');
      }
    } catch (e) {
      AppLoggerHelper.error('Error in getAndSaveFCMToken: $e');
    }
  }
}

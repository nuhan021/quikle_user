import 'package:get/get.dart';
import 'package:quikle_user/core/services/freshchat_service.dart';
import 'package:quikle_user/features/user/data/models/user_model.dart';

/// Extension to integrate Freshchat with user authentication
///
/// Usage:
/// ```dart
/// // After user logs in
/// await FreshchatHelper.identifyUserFromModel(userModel);
///
/// // On user logout
/// await FreshchatHelper.resetUserSession();
/// ```
class FreshchatHelper {
  /// Identify user in Freshchat after login
  static Future<void> identifyUserFromModel(UserModel user) async {
    try {
      final freshchatService = Get.find<FreshchatService>();

      await freshchatService.identifyUser(
        externalId: user.id,
        firstName: user.name,
        lastName: '', // Add if you have last name in user model
        email: user.email,
        phoneNumber: user.phone,
        customProperties: {
          'userId': user.id,
          'platform': 'mobile_app',
          if (user.postalCode != null) 'postalCode': user.postalCode!,
        },
      );
    } catch (e) {
      print('Error identifying user in Freshchat: $e');
    }
  }

  /// Update user properties in Freshchat
  static Future<void> updateUserInfo({
    required String userId,
    Map<String, String>? customProperties,
  }) async {
    try {
      final freshchatService = Get.find<FreshchatService>();

      final properties = {'userId': userId, ...?customProperties};

      await freshchatService.updateUserProperties(properties);
    } catch (e) {
      print('Error updating Freshchat user properties: $e');
    }
  }

  /// Track order-related events
  static Future<void> trackOrderEvent({
    required String eventName,
    String? orderId,
    String? orderStatus,
    double? orderValue,
  }) async {
    try {
      final freshchatService = Get.find<FreshchatService>();

      await freshchatService.trackEvent(eventName);

      // Update user properties with order info
      if (orderId != null || orderStatus != null || orderValue != null) {
        final properties = <String, String>{
          if (orderId != null) 'lastOrderId': orderId,
          if (orderStatus != null) 'lastOrderStatus': orderStatus,
          if (orderValue != null) 'lastOrderValue': orderValue.toString(),
          'lastOrderDate': DateTime.now().toIso8601String(),
        };

        await freshchatService.updateUserProperties(properties);
      }
    } catch (e) {
      print('Error tracking order event: $e');
    }
  }

  /// Reset user session (call on logout)
  static Future<void> resetUserSession() async {
    try {
      final freshchatService = Get.find<FreshchatService>();
      await freshchatService.resetUser();
    } catch (e) {
      print('Error resetting Freshchat session: $e');
    }
  }

  /// Open chat programmatically
  static Future<void> openSupportChat() async {
    try {
      final freshchatService = Get.find<FreshchatService>();
      await freshchatService.openChat();
    } catch (e) {
      print('Error opening support chat: $e');
    }
  }

  /// Track app events
  static Future<void> trackAppEvent(String eventName) async {
    try {
      final freshchatService = Get.find<FreshchatService>();
      await freshchatService.trackEvent(eventName);
    } catch (e) {
      print('Error tracking app event: $e');
    }
  }
}

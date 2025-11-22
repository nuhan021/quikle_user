import 'dart:async';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/services/storage_service.dart';

/// Freshchat Service for Customer Support
///
/// This service handles all Freshchat SDK operations including:
/// - SDK initialization
/// - User identification and properties
/// - Opening chat interface
/// - Unread message count tracking
/// - Real-time message update listeners
/// - User logout handling
class FreshchatService extends GetxController {
  static FreshchatService get instance => Get.find<FreshchatService>();

  // Observable for unread message count
  final RxInt unreadMessageCount = 0.obs;

  // Observable for restore ID
  final RxString restoreId = ''.obs;

  // Stream subscriptions for event listeners
  StreamSubscription? _restoreIdSubscription;
  StreamSubscription? _unreadCountSubscription;

  // Freshchat configuration
  // TODO: Replace these with your actual Freshchat credentials
  static const String _appId = '7c54e627-275f-4e5c-92af-e3427bf5bf4c';
  static const String _appKey = '8577ea2e-9b72-4348-9c6a-a157ec00c9cd';
  static const String _domain = 'msdk.in.freshchat.com';

  @override
  void onInit() {
    super.onInit();
    _initializeFreshchat();
  }

  /// Initialize Freshchat SDK with configuration
  Future<void> _initializeFreshchat() async {
    try {
      Freshchat.init(_appId, _appKey, _domain);
      _setupEventListeners();
    } catch (e) {
      print('Freshchat initialization error: $e');
    }
  }

  /// Set up event listeners for Freshchat updates
  void _setupEventListeners() {
    try {
      // Listen for restore ID events
      _restoreIdSubscription = Freshchat.onRestoreIdGenerated.listen((
        event,
      ) async {
        try {
          FreshchatUser user = await Freshchat.getUser;
          final generatedRestoreId = user.getRestoreId();

          if (generatedRestoreId != null && generatedRestoreId.isNotEmpty) {
            print('🔑 Freshchat Restore ID: $generatedRestoreId');
            restoreId.value = generatedRestoreId;
            await StorageService.saveFreshchatRestoreId(generatedRestoreId);
          }
        } catch (e) {
          print('Error retrieving restore ID: $e');
        }
      });

      // Listen for unread message count updates
      _unreadCountSubscription = Freshchat.onMessageCountUpdate.listen((
        event,
      ) async {
        try {
          // Event is a boolean, we need to fetch the actual count
          final countResult = await Freshchat.getUnreadCountAsync;
          if (countResult['count'] != null) {
            unreadMessageCount.value = countResult['count'] as int;
          }
        } catch (e) {
          print('Error retrieving unread count: $e');
        }
      });
    } catch (e) {
      print('Error setting up Freshchat event listeners: $e');
    }
  }

  /// Identify user with Freshchat
  /// Call this after user login
  Future<void> identifyUser({
    String? externalId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    Map<String, String>? customProperties,
  }) async {
    try {
      final userId = externalId ?? StorageService.userId?.toString() ?? '';

      if (userId.isEmpty) return;

      final savedRestoreId = StorageService.freshchatRestoreId;
      var user = FreshchatUser(userId, savedRestoreId);

      // Set user properties
      if (firstName != null && firstName.isNotEmpty) {
        user.setFirstName(firstName);
      }
      if (lastName != null && lastName.isNotEmpty) {
        user.setLastName(lastName);
      }
      if (email != null && email.isNotEmpty) {
        user.setEmail(email);
      }
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        String countryCode = '++91';
        String phone = phoneNumber;

        if (phoneNumber.startsWith('+')) {
          final digitsOnly = phoneNumber
              .substring(1)
              .replaceAll(RegExp(r'\D'), '');

          if (digitsOnly.length > 4) {
            for (int codeLength in [1, 2, 3, 4]) {
              final possibleCode = '+' + digitsOnly.substring(0, codeLength);
              final possiblePhone = digitsOnly.substring(codeLength);

              if (possiblePhone.length >= 7 && possiblePhone.length <= 15) {
                countryCode = possibleCode;
                phone = possiblePhone;
                break;
              }
            }
          } else {
            phone = digitsOnly;
          }
        } else {
          phone = phoneNumber.replaceAll(RegExp(r'\D'), '');
        }

        if (phone.isNotEmpty) {
          user.setPhone(countryCode, phone);
        }
      }

      // Identify user with external ID and restore ID
      Freshchat.identifyUser(externalId: userId, restoreId: savedRestoreId);

      // Set user properties
      Freshchat.setUser(user);

      // Set custom properties if provided
      if (customProperties != null && customProperties.isNotEmpty) {
        Freshchat.setUserProperties(customProperties);
      }
    } catch (e) {
      print('Error identifying Freshchat user: $e');
    }
  }

  /// Update user properties
  Future<void> updateUserProperties(Map<String, String> properties) async {
    try {
      Freshchat.setUserProperties(properties);
    } catch (e) {
      print('Error updating user properties: $e');
    }
  }

  /// Open Freshchat conversation screen
  Future<void> openChat() async {
    try {
      Freshchat.showConversations();
    } catch (e) {
      print('Error opening Freshchat: $e');
    }
  }

  /// Track custom event to Freshchat
  Future<void> trackEvent(String eventName) async {
    try {
      Freshchat.trackEvent(eventName);
    } catch (e) {
      print('Error tracking event: $e');
    }
  }

  /// Get current Freshchat user details
  Future<FreshchatUser?> getCurrentUser() async {
    try {
      return await Freshchat.getUser;
    } catch (e) {
      print('Error getting current Freshchat user: $e');
      return null;
    }
  }

  /// Reset Freshchat user data (call on logout)
  Future<void> resetUser() async {
    try {
      Freshchat.resetUser();
      unreadMessageCount.value = 0;
      restoreId.value = '';
    } catch (e) {
      print('Error resetting Freshchat user: $e');
    }
  }

  @override
  void onClose() {
    // Cancel all stream subscriptions
    _restoreIdSubscription?.cancel();
    _unreadCountSubscription?.cancel();
    super.onClose();
  }
}

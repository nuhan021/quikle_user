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

  // Stream subscriptions for event listeners
  StreamSubscription? _restoreIdSubscription;
  StreamSubscription? _unreadCountSubscription;

  // Freshchat configuration
  // TODO: Replace these with your actual Freshchat credentials
  static const String _appId = '7c54e627-275f-4e5c-92af-e3427bf5bf4c';
  static const String _appKey = '8577ea2e-9b72-4348-9c6a-a157ec00c9cd';
  static const String _domain =
      'msdk.in.freshchat.com'; // or your custom domain

  @override
  void onInit() {
    super.onInit();
    _initializeFreshchat();
  }

  /// Initialize Freshchat SDK with configuration
  Future<void> _initializeFreshchat() async {
    try {
      // Initialize SDK
      Freshchat.init(_appId, _appKey, _domain);

      // Set up event listeners for real-time updates
      _setupEventListeners();

      // If user is logged in, identify them
      if (StorageService.hasToken()) {
        await identifyUser();
      }

      print('Freshchat initialized with event listeners');
    } catch (e) {
      print('Freshchat initialization error: $e');
    }
  }

  /// Set up event listeners for Freshchat updates
  void _setupEventListeners() {
    try {
      // Listen for restore ID events
      _restoreIdSubscription = Freshchat.onRestoreIdGenerated.listen((
        restoreId,
      ) {
        print('Freshchat restore ID generated: $restoreId');
        // You can save this for restoring user session later if needed
      });

      // Listen for unread message count updates
      // This will trigger whenever a new message arrives
      _unreadCountSubscription = Freshchat.onMessageCountUpdate.listen((count) {
        print('Freshchat unread count updated: $count');
        unreadMessageCount.value = count;
      });

      print('Freshchat event listeners initialized');
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

      if (userId.isEmpty) {
        print('Freshchat: Cannot identify user - userId is empty');
        return;
      }

      // Create Freshchat user with external ID
      var user = FreshchatUser(userId, userId);

      // Set user - this identifies the user with Freshchat
      Freshchat.setUser(user);

      print('Freshchat user identified with ID: $userId');

      // Now set user properties using the correct property names
      // Freshchat uses specific property names that map to the user profile
      Map<String, String> userProperties = {};

      if (firstName != null && firstName.isNotEmpty) {
        userProperties['first_name'] = firstName;
      }
      if (lastName != null && lastName.isNotEmpty) {
        userProperties['last_name'] = lastName;
      }
      if (email != null && email.isNotEmpty) {
        userProperties['email'] = email;
      }
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        userProperties['phone'] = phoneNumber;
      }

      // Add custom properties if provided
      if (customProperties != null) {
        userProperties.addAll(customProperties);
      }

      // Set all user properties
      if (userProperties.isNotEmpty) {
        Freshchat.setUserProperties(userProperties);
        print('Freshchat user properties set:');
        print('  Name: $firstName $lastName');
        print('  Email: $email');
        print('  Phone: $phoneNumber');
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
      // Open conversation
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

  /// Reset Freshchat user data (call on logout)
  Future<void> resetUser() async {
    try {
      Freshchat.resetUser();
      unreadMessageCount.value = 0;
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

import 'dart:async';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';

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

  // Network caller for API requests
  final NetworkCaller _networkCaller = NetworkCaller();

  // Observable for unread message count
  final RxInt unreadMessageCount = 0.obs;

  // Observable for restore ID
  final RxString restoreId = ''.obs;

  // Stream subscriptions for event listeners
  StreamSubscription? _restoreIdSubscription;
  StreamSubscription? _unreadCountSubscription;

  // Freshchat configuration
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

      // Configure notifications for Android
      await _configureNotifications();

      _setupEventListeners();
    } catch (e) {
      print('Freshchat initialization error: $e');
    }
  }

  /// Configure Freshchat notifications
  Future<void> _configureNotifications() async {
    try {
      // Set notification config for Android
      Freshchat.setNotificationConfig(
        priority: Priority.PRIORITY_HIGH,
        importance: Importance.IMPORTANCE_HIGH,
        notificationSoundEnabled: true,
        notificationInterceptionEnabled: false,
      );

      print('✅ Freshchat notification config set');
    } catch (e) {
      print('❌ Error configuring Freshchat notifications: $e');
    }
  }

  /// Set FCM token for Freshchat (call this when FCM token is available)
  Future<void> setFCMToken(String fcmToken) async {
    try {
      Freshchat.setPushRegistrationToken(fcmToken);
      print('✅ FCM token registered with Freshchat: $fcmToken');
    } catch (e) {
      print('❌ Error setting FCM token in Freshchat: $e');
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
            print('✅ 🔑 Freshchat Restore ID Generated: $generatedRestoreId');
            restoreId.value = generatedRestoreId;

            // Save to local storage
            await StorageService.saveFreshchatRestoreId(generatedRestoreId);

            // Verify it was saved by reading it back
            final savedRestoreId = StorageService.freshchatRestoreId;
            print('✅ 💾 Restore ID saved to local storage successfully!');
            print('🔍 Verification - Retrieved from storage: $savedRestoreId');
            print(
              '✅ Storage verification: ${savedRestoreId == generatedRestoreId ? "MATCH ✓" : "MISMATCH ✗"}',
            );

            // Save to database
            await _saveRestoreIdToDatabase(generatedRestoreId);

            AppLoggerHelper.debug(
              'Freshchat Restore ID saved: $generatedRestoreId',
            );
          }
        } catch (e) {
          print('❌ Error retrieving restore ID: $e');
          AppLoggerHelper.error('Error retrieving restore ID', e);
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
          print('❌ Error retrieving unread count: $e');
        }
      });
    } catch (e) {
      print('❌ Error setting up Freshchat event listeners: $e');
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
        print('⚠️ User ID is empty, skipping Freshchat identification');
        return;
      }

      final savedRestoreId = StorageService.freshchatRestoreId;
      if (savedRestoreId != null && savedRestoreId.isNotEmpty) {
        print('🔑 Restore ID found: $savedRestoreId');
      } else {
        print('🔑 No Restore ID found (First time user)');
      }

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

      print('✅ Freshchat user identified successfully');

      // Print current restore ID after identification
      await _printCurrentRestoreId();
    } catch (e) {
      print('❌ Error identifying Freshchat user: $e');
      AppLoggerHelper.error('Error identifying Freshchat user', e);
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
  /// This method will identify the user before opening chat if not already identified
  Future<void> openChat({Map<String, dynamic>? orderContext}) async {
    try {
      print('🚀 Opening Freshchat...');

      // Get user ID from storage
      final userId = StorageService.userId;

      if (userId == null) {
        print('⚠️ User ID not found in storage. Please login first.');
        Freshchat.showConversations();
        return;
      }

      print('📱 User ID from storage: $userId');

      // Get saved restore ID from local storage
      String? savedRestoreId = StorageService.freshchatRestoreId;

      if (savedRestoreId != null && savedRestoreId.isNotEmpty) {
        print('🔑 Found saved Restore ID in local storage: $savedRestoreId');
        print('✅ Restoring previous Freshchat session from local storage');
      } else {
        print('🔑 No Restore ID in local storage');
        print('📥 Checking database for restore ID...');

        // Try to fetch from database
        savedRestoreId = await _fetchRestoreIdFromDatabase();

        if (savedRestoreId != null && savedRestoreId.isNotEmpty) {
          print('✅ Restore ID found in database and synced to local storage');
        } else {
          print('ℹ️ No Restore ID found in database either');
          print(
            'ℹ️ This is a new Freshchat session - Restore ID will be generated after first message',
          );
        }
      }

      // Identify user with Freshchat
      await identifyUser(externalId: userId.toString());

      // Open Freshchat conversations
      print('✅ User identified, opening Freshchat conversations');
      Freshchat.showConversations();

      // If order context is provided, send order details as a message
      // Small delay to ensure chat is opened before sending message
      if (orderContext != null) {
        print('📦 Order context provided, sending order details as message');
        await Future.delayed(const Duration(milliseconds: 500));
        await sendOrderDetailsMessage(orderContext);
      }
    } catch (e) {
      print('❌ Error opening Freshchat: $e');
      // Still try to open chat even if identification fails
      Freshchat.showConversations();
    }
  }

  /// Track custom event to Freshchat
  Future<void> trackEvent(
    String eventName, {
    Map<String, dynamic>? properties,
  }) async {
    try {
      if (properties != null) {
        Freshchat.trackEvent(eventName, properties: properties);
      } else {
        Freshchat.trackEvent(eventName);
      }
    } catch (e) {
      print('Error tracking event: $e');
    }
  }

  /// Send order details as a message to the support team
  /// This sends a formatted message with all order information directly in the chat
  /// Only sends once per order ID to avoid duplicate messages
  Future<void> sendOrderDetailsMessage(
    Map<String, dynamic> orderContext,
  ) async {
    try {
      final orderId = orderContext['Order ID']?.toString();

      // Check if we've already sent details for this order
      if (orderId == null || orderId.isEmpty) {
        print('⚠️ No Order ID provided, skipping message send');
        return;
      }

      // Check persistent storage to see if we've already sent this order
      if (StorageService.sentOrderIds.contains(orderId)) {
        print('ℹ️ Order details already sent for Order ID: $orderId, skipping');
        return;
      }

      // Format order details into a readable message
      final StringBuffer message = StringBuffer();
      message.writeln('📦 ORDER DETAILS');
      message.writeln('━━━━━━━━━━━━━━━━━━━━');

      message.writeln('🔖 Order ID: $orderId');

      if (orderContext['Order Status'] != null) {
        message.writeln('📊 Status: ${orderContext['Order Status']}');
      }
      if (orderContext['Order Date'] != null) {
        message.writeln('📅 Order Date: ${orderContext['Order Date']}');
      }
      if (orderContext['Order Amount'] != null) {
        message.writeln('💰 Amount: ${orderContext['Order Amount']}');
      }
      if (orderContext['Estimated Delivery'] != null) {
        message.writeln(
          '⏰ Estimated Delivery: ${orderContext['Estimated Delivery']}',
        );
      }

      message.writeln('\n🍽️ RESTAURANT INFO');
      message.writeln('━━━━━━━━━━━━━━━━━━━━');
      if (orderContext['Restaurant Name'] != null) {
        message.writeln('📍 Name: ${orderContext['Restaurant Name']}');
      }
      if (orderContext['Restaurant Phone'] != null) {
        message.writeln('📞 Phone: ${orderContext['Restaurant Phone']}');
      }

      if (orderContext['Delivery Person'] != null ||
          orderContext['Delivery Contact'] != null) {
        message.writeln('\n🛵 DELIVERY INFO');
        message.writeln('━━━━━━━━━━━━━━━━━━━━');
        if (orderContext['Delivery Person'] != null) {
          message.writeln('👤 Rider: ${orderContext['Delivery Person']}');
        }
        if (orderContext['Delivery Contact'] != null) {
          message.writeln('📱 Contact: ${orderContext['Delivery Contact']}');
        }
        if (orderContext['Rider Location'] != null) {
          message.writeln('� Location: ${orderContext['Rider Location']}');
        }
      }

      if (orderContext['Items'] != null) {
        message.writeln('\n🛒 ITEMS');
        message.writeln('━━━━━━━━━━━━━━━━━━━━');
        message.writeln('${orderContext['Items']}');
      }

      final messageText = message.toString();

      print('💬 Sending order details message to support team');
      print('Message preview:\n$messageText');

      // Send message to general support tag
      // The tag should match your Freshchat channel configuration
      Freshchat.sendMessage('general', messageText);

      // Mark this order as sent in persistent storage
      await StorageService.addSentOrderId(orderId);
      print('✅ Order details message sent successfully for Order ID: $orderId');
    } catch (e) {
      print('❌ Error sending order details message: $e');
      AppLoggerHelper.error('Error sending order details message', e);
    }
  }

  /// Get current Freshchat user details
  Future<FreshchatUser?> getCurrentUser() async {
    try {
      return await Freshchat.getUser;
    } catch (e) {
      print('❌ Error getting current Freshchat user: $e');
      return null;
    }
  }

  /// Manually print current restore ID (for debugging)
  Future<void> _printCurrentRestoreId() async {
    try {
      final user = await Freshchat.getUser;
      final currentRestoreId = user.getRestoreId();

      print('════════════════════════════════════════');
      print('📋 FRESHCHAT RESTORE ID STATUS');
      print('════════════════════════════════════════');
      print('Current Restore ID: ${currentRestoreId ?? "Not yet generated"}');
      print(
        'Stored Restore ID: ${StorageService.freshchatRestoreId ?? "None"}',
      );
      print(
        'Observable Value: ${restoreId.value.isEmpty ? "Empty" : restoreId.value}',
      );
      print('════════════════════════════════════════');
    } catch (e) {
      print('❌ Error fetching restore ID: $e');
    }
  }

  /// Public method to check restore ID anytime
  Future<String?> getRestoreId() async {
    await _printCurrentRestoreId();
    try {
      final user = await Freshchat.getUser;
      return user.getRestoreId();
    } catch (e) {
      print('❌ Error getting restore ID: $e');
      return null;
    }
  }

  /// Fetch restore ID from database
  Future<String?> _fetchRestoreIdFromDatabase() async {
    try {
      final token = StorageService.token;
      final refreshToken = StorageService.refreshToken;

      if (token == null || refreshToken == null) {
        print('⚠️ No auth tokens available, skipping database fetch');
        return null;
      }

      print('📥 Fetching restore ID from database...');

      final response = await _networkCaller.getRequest(
        ApiConstants.getFreshchatRestoreId,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': refreshToken,
        },
      );

      if (response.isSuccess && response.statusCode == 200) {
        final fetchedRestoreId = response.responseData?['restore_id'];

        if (fetchedRestoreId != null && fetchedRestoreId.isNotEmpty) {
          print('✅ 💾 Restore ID fetched from database: $fetchedRestoreId');

          // Save to local storage for future use
          await StorageService.saveFreshchatRestoreId(fetchedRestoreId);
          print('✅ Restore ID synced to local storage');

          AppLoggerHelper.debug('Freshchat Restore ID fetched from database');
          return fetchedRestoreId;
        } else {
          print('ℹ️ No restore ID found in database');
          return null;
        }
      } else {
        print(
          '❌ Failed to fetch restore ID from database: ${response.statusCode} - ${response.errorMessage}',
        );
        return null;
      }
    } catch (e) {
      print('❌ Error fetching restore ID from database: $e');
      AppLoggerHelper.error('Error fetching restore ID from database', e);
      return null;
    }
  }

  /// Save restore ID to database
  Future<void> _saveRestoreIdToDatabase(String restoreId) async {
    try {
      final token = StorageService.token;
      final refreshToken = StorageService.refreshToken;

      if (token == null || refreshToken == null) {
        print('⚠️ No auth tokens available, skipping database save');
        return;
      }

      print('📤 Saving restore ID to database...');

      final response = await _networkCaller.multipartRequest(
        ApiConstants.saveFreshchatRestoreId,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': refreshToken,
        },
        fields: {'restore_id': restoreId},
      );

      if (response.isSuccess && response.statusCode == 200) {
        print('✅ 💾 Restore ID saved to database successfully!');
        AppLoggerHelper.debug('Freshchat Restore ID saved to database');
      } else {
        print(
          '❌ Failed to save restore ID to database: ${response.statusCode} - ${response.errorMessage}',
        );
        AppLoggerHelper.error(
          'Failed to save restore ID to database',
          response.errorMessage,
        );
      }
    } catch (e) {
      print('❌ Error saving restore ID to database: $e');
      AppLoggerHelper.error('Error saving restore ID to database', e);
    }
  }

  /// Reset Freshchat user data (call on logout)
  Future<void> resetUser() async {
    try {
      print('🔄 Resetting Freshchat user...');
      Freshchat.resetUser();
      unreadMessageCount.value = 0;
      restoreId.value = '';
      await StorageService.clearSentOrderIds(); // Clear sent order IDs on reset
      print('✅ Freshchat user reset successfully');
    } catch (e) {
      print('❌ Error resetting Freshchat user: $e');
    }
  }

  @override
  void onClose() {
    // Cancel all stream subscriptions
    _restoreIdSubscription?.cancel();
    _unreadCountSubscription?.cancel();
    super.onClose();
  }

  /// Create order context map from order details
  /// This is a helper method to format order information for Freshchat
  static Map<String, dynamic> createOrderContext({
    required String orderId,
    required String orderStatus,
    String? restaurantName,
    String? restaurantPhone,
    String? deliveryPersonName,
    String? deliveryPersonPhone,
    String? deliveryPersonLocation,
    String? orderDate,
    String? estimatedDelivery,
    String? orderTotal,
    List<String>? items,
  }) {
    final Map<String, dynamic> context = {
      'Order ID': orderId,
      'Order Status': orderStatus,
    };

    if (orderDate != null) context['Order Date'] = orderDate;
    if (orderTotal != null) context['Order Amount'] = orderTotal;
    if (estimatedDelivery != null) {
      context['Estimated Delivery'] = estimatedDelivery;
    }

    if (restaurantName != null) {
      context['Restaurant Name'] = restaurantName;
    }
    if (restaurantPhone != null) {
      context['Restaurant Phone'] = restaurantPhone;
    }

    if (deliveryPersonName != null) {
      context['Delivery Person'] = deliveryPersonName;
    }
    if (deliveryPersonPhone != null) {
      context['Delivery Contact'] = deliveryPersonPhone;
    }
    if (deliveryPersonLocation != null) {
      context['Rider Location'] = deliveryPersonLocation;
    }

    if (items != null && items.isNotEmpty) {
      context['Items'] = items.join(', ');
    }

    return context;
  }
}

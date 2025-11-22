import 'package:flutter/material.dart';
import 'package:quikle_user/core/common/widgets/customer_support_fab.dart';
import 'package:quikle_user/core/utils/helpers/freshchat_helper.dart';

/// Example implementations of Freshchat customer support integration
///
/// This file demonstrates various ways to integrate customer support
/// across different screens and scenarios in your app.

// ============================================================================
// EXAMPLE 1: Basic Screen with Support Button
// ============================================================================
class ExampleBasicScreen extends StatelessWidget {
  const ExampleBasicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Screen')),
      body: Stack(
        children: [
          // Your screen content
          Center(child: Text('Your content here')),

          // Add customer support FAB
          const CustomerSupportFAB(),
        ],
      ),
    );
  }
}

// ============================================================================
// EXAMPLE 2: Custom Positioned Support Button
// ============================================================================
class ExampleCustomPositionScreen extends StatelessWidget {
  const ExampleCustomPositionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YourContentWidget(),

          // Custom position to avoid conflicts
          CustomerSupportFAB(
            bottom: 120, // Position above bottom navigation
            right: 20, // Slight offset from edge
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EXAMPLE 3: Profile Screen with Support Option
// ============================================================================
class ExampleProfileScreen extends StatelessWidget {
  const ExampleProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Edit Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {},
          ),
          Divider(),
          // Support option in menu
          ListTile(
            leading: Icon(Icons.support_agent),
            title: Text('Customer Support'),
            subtitle: Text('Get help from our team'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Open Freshchat
              FreshchatHelper.openSupportChat();
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help & FAQs'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EXAMPLE 4: Login Success Handler
// ============================================================================
class ExampleLoginController {
  Future<void> onLoginSuccess(dynamic userModel) async {
    // ... your login logic

    // Identify user in Freshchat for better support context
    await FreshchatHelper.identifyUserFromModel(userModel);

    // Navigate to home
    // Get.offAllNamed(Routes.home);
  }
}

// ============================================================================
// EXAMPLE 5: Logout Handler
// ============================================================================
class ExampleLogoutHandler {
  Future<void> handleLogout() async {
    // Clear local data
    // await StorageService.logoutUser();

    // Reset Freshchat session
    await FreshchatHelper.resetUserSession();

    // Navigate to login
    // Get.offAllNamed(Routes.login);
  }
}

// ============================================================================
// EXAMPLE 6: Order Placed Event Tracking
// ============================================================================
class ExampleOrderController {
  Future<void> onOrderPlaced({
    required String orderId,
    required double totalAmount,
    required String status,
  }) async {
    // ... your order placement logic

    // Track order event in Freshchat
    await FreshchatHelper.trackOrderEvent(
      eventName: 'order_placed',
      orderId: orderId,
      orderStatus: status,
      orderValue: totalAmount,
    );
  }

  Future<void> onOrderDelivered(String orderId) async {
    // Track delivery
    await FreshchatHelper.trackOrderEvent(
      eventName: 'order_delivered',
      orderId: orderId,
      orderStatus: 'delivered',
    );
  }
}

// ============================================================================
// EXAMPLE 7: Payment Failure Handler
// ============================================================================
class ExamplePaymentHandler {
  Future<void> onPaymentFailed({
    required String reason,
    required double amount,
  }) async {
    // Track payment failure
    await FreshchatHelper.trackAppEvent('payment_failed');

    // Update user properties
    await FreshchatHelper.updateUserInfo(
      userId: 'user_id', // Get from your user service
      customProperties: {
        'lastPaymentFailure': DateTime.now().toIso8601String(),
        'paymentFailureReason': reason,
      },
    );

    // Optionally, offer support
    _showPaymentFailedDialog();
  }

  void _showPaymentFailedDialog() {
    // Show dialog with option to contact support
    // Implementation depends on your dialog system
  }
}

// ============================================================================
// EXAMPLE 8: Product Issue Reporter
// ============================================================================
class ExampleProductIssueHandler {
  Future<void> reportProductIssue({
    required String productId,
    required String productName,
    required String issueType,
  }) async {
    // Update user properties with product issue context
    await FreshchatHelper.updateUserInfo(
      userId: 'user_id',
      customProperties: {
        'lastReportedProduct': productId,
        'lastReportedIssue': issueType,
        'issueTimestamp': DateTime.now().toIso8601String(),
      },
    );

    // Track event
    await FreshchatHelper.trackAppEvent('product_issue_reported');

    // Open support chat with context
    await FreshchatHelper.openSupportChat();
  }
}

// ============================================================================
// EXAMPLE 9: Conditional Support Button (Show/Hide)
// ============================================================================
class ExampleConditionalSupportScreen extends StatelessWidget {
  final bool isCheckoutScreen;
  final bool hasActiveOrder;

  const ExampleConditionalSupportScreen({
    super.key,
    this.isCheckoutScreen = false,
    this.hasActiveOrder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YourContentWidget(),

          // Only show support button in certain conditions
          if (!isCheckoutScreen || hasActiveOrder) const CustomerSupportFAB(),
        ],
      ),
    );
  }
}

// ============================================================================
// EXAMPLE 10: Support Button in Bottom Sheet
// ============================================================================
class ExampleBottomSheetSupport {
  static void showSupportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Need Help?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.chat_bubble_outline),
              title: Text('Chat with Support'),
              subtitle: Text('Get instant help from our team'),
              onTap: () {
                Navigator.pop(context);
                FreshchatHelper.openSupportChat();
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Call Support'),
              subtitle: Text('+1-800-SUPPORT'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email Support'),
              subtitle: Text('support@quikle.com'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// EXAMPLE 11: Track User Journey Events
// ============================================================================
class ExampleUserJourneyTracking {
  Future<void> trackScreenView(String screenName) async {
    await FreshchatHelper.trackAppEvent('screen_viewed_$screenName');
  }

  Future<void> trackFeatureUsed(String featureName) async {
    await FreshchatHelper.trackAppEvent('feature_used_$featureName');
  }

  Future<void> trackSearchPerformed(String query) async {
    await FreshchatHelper.trackAppEvent('search_performed');
    await FreshchatHelper.updateUserInfo(
      userId: 'user_id',
      customProperties: {
        'lastSearchQuery': query,
        'lastSearchTime': DateTime.now().toIso8601String(),
      },
    );
  }
}

// ============================================================================
// EXAMPLE 12: Custom Support Widget with Multiple Actions
// ============================================================================
class ExampleCustomSupportWidget extends StatelessWidget {
  const ExampleCustomSupportWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Having Issues?', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => FreshchatHelper.openSupportChat(),
                icon: Icon(Icons.chat),
                label: Text('Chat Now'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  // Navigate to FAQ
                },
                icon: Icon(Icons.help),
                label: Text('FAQs'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Dummy widgets for examples
class YourContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}

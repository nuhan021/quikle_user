import 'package:get/get.dart';
import 'package:quikle_user/features/main/presentation/screens/main_screen.dart';

class NavbarNavigationHelper {
  /// Navigate to main screen with specific tab index
  /// This clears all previous routes and navigates to the main screen
  static void navigateToTab(int index) {
    Get.offAll(
      () => MainScreen(initialIndex: index),
      predicate: (route) => false, // Remove all previous routes
    );
  }

  /// Get the current active tab index based on the current route
  /// Returns -1 if current page is not a main tab
  static int getCurrentTabIndex() {
    final currentRoute = Get.currentRoute;

    // Define which routes correspond to which tabs
    switch (currentRoute) {
      case '/home':
      case '/main':
        return 0; // Home tab
      case '/orders':
        return 1; // Orders tab
      case '/categories':
      case '/unified-category':
        return 2; // Categories tab
      case '/profile':
        return 3; // Profile tab
      default:
        return -1; // Not a main tab, no active state
    }
  }

  /// Check if the current page should show navbar with active state
  /// Returns true if it's a main tab page, false otherwise
  static bool shouldShowActiveTab() {
    return getCurrentTabIndex() != -1;
  }
}

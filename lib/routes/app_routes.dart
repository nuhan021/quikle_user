import 'package:get/get.dart';
import 'package:quikle_user/features/auth/presentation/screens/resgiter_screen.dart';
import 'package:quikle_user/features/auth/presentation/screens/verification_scree.dart';
import 'package:quikle_user/features/auth/presentation/screens/welcome_screen.dart';
import 'package:quikle_user/features/main/presentation/screens/main_screen.dart';
import 'package:quikle_user/features/profile/presentation/screens/my_profile_screen.dart';
import 'package:quikle_user/features/splash/presentation/screens/splash_screen.dart';
import 'package:quikle_user/features/auth/presentation/screens/login_screen.dart';
import 'package:quikle_user/features/cart/presentation/screens/cart_screen.dart';
import 'package:quikle_user/features/product/presentation/screens/product_details_screen.dart';
import 'package:quikle_user/features/categories/presentation/screens/category_detail_screen.dart';
import 'package:quikle_user/features/categories/presentation/screens/subcategory_products_screen.dart';
import 'package:quikle_user/features/categories/presentation/screens/grocery_navigation_screen.dart';
import 'package:quikle_user/features/categories/presentation/screens/unified_category_screen.dart';
import 'package:quikle_user/features/categories/presentation/screens/category_products_screen.dart';
import 'package:quikle_user/features/restaurants/presentation/screens/category_restaurants_screen.dart';
import 'package:quikle_user/features/restaurants/presentation/screens/restaurant_page_screen.dart';
import 'package:quikle_user/features/payout/presentation/screens/checkout_screen.dart';
import 'package:quikle_user/features/profile/presentation/screens/favorites_screen.dart';
import 'package:quikle_user/features/profile/presentation/screens/address_book_screen.dart';
import 'package:quikle_user/features/profile/presentation/screens/add_address_screen.dart';
import 'package:quikle_user/features/profile/presentation/screens/payment_method_screen.dart';
import 'package:quikle_user/features/profile/presentation/screens/notification_settings_screen.dart';
import 'package:quikle_user/features/profile/presentation/screens/help_support_screen.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/search/presentation/screens/search_screen.dart';
import 'package:quikle_user/features/orders/presentation/screens/order_tracking_screen.dart';
import 'package:quikle_user/features/orders/presentation/screens/order_invoice_screen.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';

class AppRoute {
  static const String _splash = '/';
  static const String _login = '/login';
  static const String _register = '/register';
  static const String _verify = '/verify';
  static const String _welcome = '/welcome';
  static const String _home = '/home';
  static const String _main = '/main';
  static const String _cart = '/cart';
  static const String _productDetails = '/product-details';
  static const String _categoryDetail = '/category-detail';
  static const String _unifiedCategory = '/unified-category';
  static const String _categoryProducts = '/category-products';
  static const String _subcategoryProducts = '/subcategory-products';
  static const String _groceryNavigation = '/grocery-navigation';
  static const String _checkout = '/checkout';
  static const String _favorites = '/favorites';
  static const String _addressBook = '/address-book';
  static const String _addAddress = '/add-address';
  static const String _paymentMethods = '/payment-methods';
  static const String _notificationSettings = '/notification-settings';
  static const String _languageSettings = '/language-settings';
  static const String _helpSupport = '/help-support';
  static const String _aboutUs = '/about-us';
  static const String _search = '/search';
  static const String _categoryRestaurants = '/category-restaurants';
  static const String _restaurantMenu = '/restaurant-menu';
  static const String _myProfile = '/my-profile';
  static const String _orderTracking = '/order-tracking';
  static const String _orderInvoice = '/order-invoice';

  static String getSplashScreen() => _splash;
  static String getLoginScreen() => _login;
  static String getRegister() => _register;
  static String getVerify() => _verify;
  static String getHome() => _home;
  static String getMain() => _main;
  static String getWelcome() => _welcome;
  static String getCart() => _cart;
  static String getProductDetails() => _productDetails;
  static String getCategoryDetail() => _categoryDetail;
  static String getUnifiedCategory() => _unifiedCategory;
  static String getCategoryProducts() => _categoryProducts;
  static String getSubcategoryProducts() => _subcategoryProducts;
  static String getGroceryNavigation() => _groceryNavigation;
  static String getCheckout() => _checkout;
  static String getFavorites() => _favorites;
  static String getAddressBook() => _addressBook;
  static String getAddAddress() => _addAddress;
  static String getPaymentMethods() => _paymentMethods;
  static String getNotificationSettings() => _notificationSettings;
  static String getLanguageSettings() => _languageSettings;
  static String getHelpSupport() => _helpSupport;
  static String getAboutUs() => _aboutUs;
  static String getSearch() => _search;
  static String getCategoryRestaurants() => _categoryRestaurants;
  static String getRestaurantMenu() => _restaurantMenu;
  static String getMyProfile() => _myProfile;
  static String getOrderTracking() => _orderTracking;
  static String getOrderInvoice() => _orderInvoice;

  static final List<GetPage<dynamic>> routes = <GetPage>[
    GetPage(name: _splash, page: () => const SplashScreen()),
    GetPage(name: _login, page: () => const LoginScreen()),
    GetPage(name: _register, page: () => const RegisterScreen()),
    GetPage(name: _verify, page: () => const VerificationScreen()),
    GetPage(name: _welcome, page: () => const WelcomeScreen()),
    GetPage(
      name: _home,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return MainScreen(initialIndex: args?['initialIndex'] ?? 0);
      },
    ),
    GetPage(
      name: _main,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return MainScreen(initialIndex: args?['initialIndex'] ?? 0);
      },
    ),
    GetPage(name: _cart, page: () => const CartScreen()),
    GetPage(
      name: _productDetails,
      page: () => ProductDetailsScreen(product: Get.arguments as ProductModel),
    ),
    GetPage(name: _categoryDetail, page: () => const CategoryDetailScreen()),
    GetPage(name: _unifiedCategory, page: () => const UnifiedCategoryScreen()),
    GetPage(
      name: _categoryProducts,
      page: () => const CategoryProductsScreen(),
    ),
    GetPage(
      name: _subcategoryProducts,
      page: () => const SubcategoryProductsScreen(),
    ),
    GetPage(
      name: _groceryNavigation,
      page: () => const GroceryNavigationScreen(),
    ),
    GetPage(name: _checkout, page: () => const CheckoutScreen()),
    GetPage(name: _favorites, page: () => const FavoritesScreen()),
    GetPage(name: _addressBook, page: () => const AddressBookScreen()),
    GetPage(name: _addAddress, page: () => const AddAddressScreen()),
    GetPage(name: _paymentMethods, page: () => const PaymentMethodScreen()),
    GetPage(
      name: _notificationSettings,
      page: () => const NotificationSettingsScreen(),
    ),
    GetPage(name: _helpSupport, page: () => const HelpSupportScreen()),
    GetPage(name: _search, page: () => const SearchScreen()),
    GetPage(
      name: _categoryRestaurants,
      page: () => const CategoryRestaurantsScreen(),
    ),
    GetPage(name: _restaurantMenu, page: () => const RestaurantPageScreen()),
    GetPage(name: _myProfile, page: () => const MyProfileScreen()),
    GetPage(
      name: _orderTracking,
      page: () => OrderTrackingScreen(order: Get.arguments as OrderModel),
    ),
    GetPage(
      name: _orderInvoice,
      page: () => OrderInvoiceScreen(order: Get.arguments as OrderModel),
    ),

    // GetPage(
    //   name: _home,
    //   page: () => const _PlaceholderHome(),
    // ),
  ];
}

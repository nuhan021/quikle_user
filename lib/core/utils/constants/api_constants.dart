class ApiConstants {
  static const String baseUrl = "https://caditya619-backend-ng0e.onrender.com";

  //Get banner images
  static const String getBannerImages = "$baseUrl/banner/pictures/";

  //For auth api's
  static const String authApi = "$baseUrl/auth";
  static const String sendOtp = "$authApi/send_otp/";
  static const String login = "$authApi/login/";
  static const String signup = "$authApi/customer/signup/";

  static const String verifyToken = "$authApi/verify-token/";

  //For category api's
  static const String getAllCategories = "$baseUrl/items/categories/";

  //For subcategory api's
  static const String getSubcategoriesByCategory =
      "$baseUrl/items/subcategories/?category_id={category_id}";
  //Get sub sub category for grocery
  static const String getSubSubcategoriesBySubcategory =
      "$baseUrl/items/sub-subcategories/?subcategory_id={subcategory_id}";

  //For product api's
  static const String getFoodProducts = "$baseUrl/items/food/";
  static const String getMedicineProducts = "$baseUrl/items/medicine/is_otc/";
  // Groceries endpoint
  static const String getGroceriesProducts = "$baseUrl/items/grocery/";

  //Profile api's
  static const String getUserProfile = "$baseUrl/customer/profile/";
  static const String deleteAccount = "$baseUrl/user/users/me/delete";

  //Shipping address api's
  static const String shippingAddresses =
      "$baseUrl/customer/shipping-addresses/";
  static const String getShippingAddresses =
      "$baseUrl/customer/shipping-addresses/";
  static const String makeDefault =
      "$baseUrl/customer/shipping-addresses/{address_id}/set-default";
  static const String deleteAddress =
      "$baseUrl/customer/shipping-addresses/{address_id}";

  //Freshchat api's
  static const String saveFreshchatRestoreId = "$baseUrl/user/freshchat/";
  static const String getFreshchatRestoreId =
      "$baseUrl/user/freshchat/restore_id";

  //Review api's
  static const String submitReview = "$baseUrl/items/reviews/";
  static const String getReviews = "$baseUrl/items/reviews/?item_id={item_id}";

  //Order api's
  static const String createOrder = "$baseUrl/customer/orders/";
  static const String getOrders = "$baseUrl/customer/orders/";

  //Payment api's
  static const String initiatePayment = "$baseUrl/payment/payment/initiate";
  static const String confirmPayment = "$baseUrl/payment/payment/confirm";
  static const String verifyPhonePePayment =
      "$baseUrl/payment/payment/phonepe/status";

  //Search api's
  static const String searchItems = "$baseUrl/items/items/";
  static const String getItemById = "$baseUrl/items/items/{id}/";

  //Favorites api's
  static const String favorites = "$baseUrl/favourites/favorites/";

  //Save FCM Token
  static const String saveFcmToken = "$baseUrl/rider/save_token/";

  //Prescription api's
  static const String uploadPrescription =
      "$baseUrl/prescription/prescriptions/";
  static const String getPrescriptions = "$baseUrl/prescription/prescriptions/";
  static const String getPrescriptionById =
      "$baseUrl/prescription/prescriptions/{id}/";
  static const String deletePrescription =
      "$baseUrl/prescription/prescriptions/{id}";

  //Restaurant api's
  static const String getRestaurants = "$authApi/restaurant/restaurants";
  static const String getRestaurantProducts = "$baseUrl/items/food/";
  // Promo / Coupons
  static const String getCoupons = "$baseUrl/promo/cupons/";
  static const String applyCoupon = "$baseUrl/promo/cupons/apply";

  //Refund and Issues api's
  static const String reportIssue =
      "$baseUrl/payment/refunds/reports-and-issues";
  static const String cancelOrder =
      "$baseUrl/payment/refunds/orders/{order_id}/cancel";
  static const String cancelIndividualOrder =
      "$baseUrl/payment/refunds/individual-orders/{order_id}/cancel";
}

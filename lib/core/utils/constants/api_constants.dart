class ApiConstants {
  static const String baseUrl = "https://caditya619-backend.onrender.com";

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
  static const String getGroceriesProducts = "$baseUrl/items/groceries/";

  //Profile api's
  static const String getUserProfile = "$baseUrl/customer/profile/";

  //Shipping address api's
  static const String shippingAddresses = "$baseUrl/customer/shipping-address/";
  static const String getShippingAddresses =
      "$baseUrl/customer/shipping-address/";
  static const String makeDefault =
      "$baseUrl/customer/shipping-address/{address_id}/set-default";
  static const String deleteAddress =
      "$baseUrl/customer/shipping-address/{address_id}";
}

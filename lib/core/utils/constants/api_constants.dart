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
      "$baseUrl/items/subcategories/?parent_subcategory_id={parent_subcategory_id}";

  //Profile api's
  static const String getUserProfile = "$baseUrl/customer/profile/";
}

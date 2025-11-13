class ApiConstants {
  static const String baseUrl = "https://caditya619-backend.onrender.com";

  //For auth api's
  static const String authApi = "$baseUrl/auth";
  static const String sendOtp = "$authApi/send_otp/";
  static const String verifyOtp = "$authApi/login/";
}

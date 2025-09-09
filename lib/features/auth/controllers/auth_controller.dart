import 'package:get/get.dart';
import '../../user/data/models/user_model.dart';
import '../../user/data/services/user_service.dart';
import '../data/services/auth_service.dart';
import 'package:quikle_user/core/models/response_data.dart';

class AuthController extends GetxController {
  late final AuthService _authService;
  late final UserService _userService;

  UserModel? get currentUser => _userService.currentUser;
  bool get isLoggedIn => _userService.isLoggedIn;
  String? get currentUserId => _userService.currentUserId;
  String get token => _userService.token;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
    _userService = Get.find<UserService>();
  }

  Future<ResponseData> login(String phoneNumber) async {
    try {
      return await _authService.login(phoneNumber);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<ResponseData> register(String name, String phoneNumber) async {
    try {
      return await _authService.register(name, phoneNumber);
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<ResponseData> verifyOtp(String phone, String otp) async {
    try {
      return await _authService.verifyOtp(phone, otp);
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  Future<ResponseData> resendOtp(String phone) async {
    try {
      return await _authService.resendOtp(phone);
    } catch (e) {
      throw Exception('Failed to resend OTP: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
}

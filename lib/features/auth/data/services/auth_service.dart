import 'package:get/get.dart';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/features/user/data/models/user_model.dart';
import 'package:quikle_user/features/user/data/services/user_service.dart';

class AuthService {
  late final UserService _userService;

  AuthService() {
    _userService = Get.find<UserService>();
  }

  UserModel? get currentUser => _userService.currentUser;
  String get currentToken => _userService.token;
  bool get isLoggedIn => _userService.isLoggedIn;

  final NetworkCaller _networkCaller = NetworkCaller();

  // Unified method for sending OTP - handles both login and signup
  Future<ResponseData> sendOtp(
    String phone, {
    String? name,
    String purpose = 'login',
  }) async {
    try {
      final fields = {'phone': phone, 'purpose': purpose};

      // Add name field if provided (for signup)
      if (name != null && name.isNotEmpty) {
        fields['name'] = name;
      }

      final ResponseData response = await _networkCaller.multipartRequest(
        ApiConstants.sendOtp,
        fields: fields,
      );
      if (response.statusCode == 200 && response.isSuccess) {
        return response;
      } else if (response.statusCode == 400) {
        return response;
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: response.errorMessage,
          responseData: response.responseData,
        );
      }
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Failed to send OTP. Please try again.',
        responseData: null,
      );
    }
  }

  Future<ResponseData> login(String phone, String otp) async {
    try {
      final ResponseData response = await _networkCaller.multipartRequest(
        ApiConstants.login,
        fields: {'phone': phone, 'otp': otp, 'purpose': 'login'},
      );

      if (response.statusCode != 200 || !response.isSuccess) {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Invalid OTP. Please try again.',
          responseData: null,
        );
      }

      final token = response.responseData?['access_token'];
      final refreshToken = response.responseData?['refresh_token'];

      StorageService.saveToken(token);
      StorageService.saveRefreshToken(refreshToken);

      verifyToken();

      return ResponseData(
        isSuccess: true,
        statusCode: 200,
        errorMessage: '',
        responseData: response.responseData,
      );
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 400,
        errorMessage: 'Invalid OTP. Please try again.',
        responseData: null,
      );
    }
  }

  Future<ResponseData> signupWithOtp(
    String phone,
    String name,
    String otp,
  ) async {
    try {
      final ResponseData response = await _networkCaller.multipartRequest(
        ApiConstants.signup,
        fields: {'phone': phone, 'name': name, 'otp': otp},
      );

      if (response.statusCode != 200 || !response.isSuccess) {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Invalid OTP. Please try again.',
          responseData: null,
        );
      }

      final token = response.responseData?['access_token'];
      final refreshToken = response.responseData?['refresh_token'];

      StorageService.saveToken(token);
      StorageService.saveRefreshToken(refreshToken);

      return ResponseData(
        isSuccess: true,
        statusCode: 200,
        errorMessage: '',
        responseData: response.responseData,
      );
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 400,
        errorMessage: 'Invalid OTP. Please try again.',
        responseData: null,
      );
    }
  }

  Future<void> logout() async {
    await _userService.clearUser();
  }

  Future<ResponseData> resendOtp(String phone) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      return ResponseData(
        isSuccess: true,
        statusCode: 200,
        errorMessage: '',
        responseData: {'success': true, 'message': 'OTP resent successfully'},
      );
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Failed to resend OTP. Please try again.',
        responseData: null,
      );
    }
  }

  Future<void> verifyToken() async {
    try {
      final token = StorageService.token;
      final refreshToken = StorageService.refreshToken;

      final ResponseData response = await _networkCaller.getRequest(
        ApiConstants.verifyToken,
        headers: {
          'refresh-token': '$refreshToken',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final userId = response.responseData?['id'];
        StorageService.saveUserId(userId);
      }
    } catch (e) {}
  }
}

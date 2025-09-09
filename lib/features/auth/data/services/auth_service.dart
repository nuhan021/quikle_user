import 'package:get/get.dart';
import 'package:quikle_user/core/models/response_data.dart';
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

  Future<ResponseData> login(String phone) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      final mockUser = UserModel(
        id: '1',
        name: 'User',
        phone: phone,
        isVerified: false,
        createdAt: DateTime.now(),
      );

      return ResponseData(
        isSuccess: true,
        statusCode: 200,
        errorMessage: '',
        responseData: {
          'success': true,
          'message': 'OTP sent successfully',
          'data': {'user': mockUser.toJson()},
        },
      );
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Failed to send OTP. Please try again.',
        responseData: null,
      );
    }
  }

  Future<ResponseData> register(String name, String phone) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      final mockUser = UserModel(
        id: '2',
        name: name,
        phone: phone,
        isVerified: false,
        createdAt: DateTime.now(),
      );

      return ResponseData(
        isSuccess: true,
        statusCode: 200,
        errorMessage: '',
        responseData: {
          'success': true,
          'message': 'OTP sent successfully',
          'data': {'user': mockUser.toJson()},
        },
      );
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Failed to create account. Please try again.',
        responseData: null,
      );
    }
  }

  Future<ResponseData> verifyOtp(String phone, String otp) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      final mockUser = UserModel(
        id: '3',
        name: 'John Doe',
        phone: phone,
        isVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      const mockToken = 'mock_jwt_token_here';

      await _userService.setUser(mockUser, mockToken);

      return ResponseData(
        isSuccess: true,
        statusCode: 200,
        errorMessage: '',
        responseData: {
          'success': true,
          'message': 'Phone number verified successfully',
          'data': {'user': mockUser.toJson(), 'token': mockToken},
        },
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

  Future<ResponseData> getUserProfile() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final mockUser = UserModel(
        id: currentUser?.id ?? '1',
        name: currentUser?.name ?? 'John Doe',
        phone: currentUser?.phone ?? '+1234567890',
        isVerified: true,
        createdAt: currentUser?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _userService.updateUser(mockUser);

      return ResponseData(
        isSuccess: true,
        statusCode: 200,
        errorMessage: '',
        responseData: {
          'success': true,
          'message': 'Profile fetched successfully',
          'data': {'user': mockUser.toJson()},
        },
      );
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Failed to fetch profile. Please try again.',
        responseData: null,
      );
    }
  }

  Future<ResponseData> updateProfile(Map<String, dynamic> data) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));

      final updatedUser = currentUser?.copyWith(
        name: data['name'] ?? currentUser?.name,
        phone: data['phone'] ?? currentUser?.phone,
        updatedAt: DateTime.now(),
      );

      if (updatedUser != null) {
        _userService.updateUser(updatedUser);
      }

      return ResponseData(
        isSuccess: true,
        statusCode: 200,
        errorMessage: '',
        responseData: {
          'success': true,
          'message': 'Profile updated successfully',
          'data': {'user': updatedUser?.toJson()},
        },
      );
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Failed to update profile. Please try again.',
        responseData: null,
      );
    }
  }
}

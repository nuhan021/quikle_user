import 'package:get/get.dart';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/models/user_model.dart';
import 'package:quikle_user/core/services/user_service.dart';

class AuthService {
  late final UserService _userService;

  AuthService() {
    _userService = Get.find<UserService>();
  }

  // Getter for current user from UserService
  UserModel? get currentUser => _userService.currentUser;
  String get currentToken => _userService.token;
  bool get isLoggedIn => _userService.isLoggedIn;

  Future<ResponseData> login(String phone) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _networkCaller.postRequest(
      //   'your-api-base-url/auth/login',
      //   body: {'phone': phone},
      // );

      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Mock successful response using your ResponseData model
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
      // TODO: Replace with actual API call
      // final response = await _networkCaller.postRequest(
      //   'your-api-base-url/auth/register',
      //   body: {'name': name, 'phone': phone},
      // );

      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Mock successful response
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
      // TODO: Replace with actual API call
      // final response = await _networkCaller.postRequest(
      //   'your-api-base-url/auth/verify-otp',
      //   body: {'phone': phone, 'otp': otp},
      // );

      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Mock successful verification
      final mockUser = UserModel(
        id: '3',
        name: 'John Doe',
        phone: phone,
        isVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      const mockToken = 'mock_jwt_token_here';

      // Store user session in UserService
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
    // TODO: Call API to invalidate token
    // await _networkCaller.postRequest('your-api-base-url/auth/logout');

    await _userService.clearUser();
  }

  Future<ResponseData> resendOtp(String phone) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _networkCaller.postRequest(
      //   'your-api-base-url/auth/resend-otp',
      //   body: {'phone': phone},
      // );

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

  // Get user profile from API
  Future<ResponseData> getUserProfile() async {
    try {
      // TODO: Replace with actual API call
      // final response = await _networkCaller.getRequest(
      //   'your-api-base-url/auth/profile',
      //   token: currentToken,
      // );

      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Mock user profile
      final mockUser = UserModel(
        id: currentUser?.id ?? '1',
        name: currentUser?.name ?? 'John Doe',
        phone: currentUser?.phone ?? '+1234567890',
        email: 'john.doe@example.com',
        isVerified: true,
        createdAt: currentUser?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Update user in service
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

  // Update user profile
  Future<ResponseData> updateProfile(Map<String, dynamic> data) async {
    try {
      // TODO: Replace with actual API call
      // final response = await _networkCaller.postRequest(
      //   'your-api-base-url/auth/profile',
      //   body: data,
      //   token: currentToken,
      // );

      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Mock updated user
      final updatedUser = currentUser?.copyWith(
        name: data['name'] ?? currentUser?.name,
        email: data['email'] ?? currentUser?.email,
        address: data['address'] ?? currentUser?.address,
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

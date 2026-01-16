import 'package:get/get.dart';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/freshchat_service.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/routes/app_routes.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import '../models/user_model.dart';

class UserService extends GetxController {
  static UserService get instance => Get.find<UserService>();
  final NetworkCaller _networkCaller = NetworkCaller();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  Rx<UserModel?> get userRx => _currentUser;

  final RxBool _isLoggedIn = false.obs;

  UserModel? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String? get currentUserId => _currentUser.value?.id;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final token = StorageService.token;
    final refreshToken = StorageService.refreshToken;

    if (token == null || refreshToken == null) {
      print('⚠️ No token found, skipping user profile load');
      _currentUser.value = null;
      return;
    }

    try {
      print('📱 Loading user profile...');
      final ResponseData response = await _networkCaller.getRequest(
        ApiConstants.getUserProfile,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': '$refreshToken',
        },
      );

      print('📱 User profile response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.responseData['data']);
        _currentUser.value = user;
        _isLoggedIn.value = true;
        print('✅ User profile loaded: ${user.name} (ID: ${user.id})');

        // Identify user with Freshchat after profile is loaded
        _identifyUserWithFreshchat(user);
      } else {
        print(
          '❌ Failed to load user profile: ${response.statusCode} - ${response.errorMessage}',
        );
        _currentUser.value = null;
        _isLoggedIn.value = false;
      }
    } catch (e) {
      // Don't throw - just log and set user to null
      print('❌ Error loading user profile: $e');
      _currentUser.value = null;
      _isLoggedIn.value = false;
    }
  }

  /// Refresh user data from server
  Future<void> refreshUser() async {
    await _loadUser();
  }

  /// Identify current user with Freshchat (public method)
  Future<void> identifyFreshchatUser() async {
    try {
      // Get user ID from storage
      final userId = StorageService.userId;

      if (userId == null) {
        print('❌ Cannot identify Freshchat user: User ID is null in storage');
        return;
      }

      // Check if FreshchatService is available
      if (!Get.isRegistered<FreshchatService>()) {
        print('❌ FreshchatService not registered, skipping identification');
        return;
      }

      final freshchatService = Get.find<FreshchatService>();

      // Identify user with just the user ID
      await freshchatService.identifyUser(externalId: userId.toString());

      print('✅ Freshchat user identified with ID: $userId');
    } catch (e) {
      print('❌ Error identifying Freshchat user: $e');
    }
  }

  /// Identify user with Freshchat support
  Future<void> _identifyUserWithFreshchat(UserModel user) async {
    try {
      // Check if FreshchatService is available
      if (!Get.isRegistered<FreshchatService>()) {
        AppLoggerHelper.debug(
          'FreshchatService not registered, skipping identification',
        );
        return;
      }

      final freshchatService = Get.find<FreshchatService>();

      // Identify user with Freshchat
      await freshchatService.identifyUser(
        externalId: user.id,
        firstName: user.name.split(' ').first,
        lastName: user.name.split(' ').length > 1
            ? user.name.split(' ').last
            : '',
        email: user.email,
        phoneNumber: user.phone,
      );

      AppLoggerHelper.debug(
        'User identified with Freshchat: ${user.name} (${user.id})',
      );
    } catch (e) {
      AppLoggerHelper.debug('Error identifying user with Freshchat: $e');
    }
  }

  Future<bool> updateProfile(UserModel updatedUser) async {
    final token = StorageService.token;
    final refreshToken = StorageService.refreshToken;
    try {
      final ResponseData response = await _networkCaller.putRequest(
        ApiConstants.getUserProfile,
        body: updatedUser.toJson(),
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': '$refreshToken',
        },
      );

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.responseData['data']);
        _currentUser.value = user;
        return true;
      }

      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logoutUser() async {
    // Reset Freshchat user session before logout
    try {
      if (Get.isRegistered<FreshchatService>()) {
        final freshchatService = Get.find<FreshchatService>();
        await freshchatService.resetUser();
        AppLoggerHelper.debug('Freshchat user session reset on logout');
      }
    } catch (e) {
      AppLoggerHelper.debug('Error resetting Freshchat on logout: $e');
    }

    // Clear prescription data before logout
    try {
      if (Get.isRegistered<PrescriptionController>()) {
        final prescriptionController = Get.find<PrescriptionController>();
        prescriptionController.clearData();
        AppLoggerHelper.debug('Prescription data cleared on logout');
      }
    } catch (e) {
      AppLoggerHelper.debug('Error clearing prescription data on logout: $e');
    }

    await StorageService.logoutUser();
    _currentUser.value = null;
    _isLoggedIn.value = false;
    Get.offAllNamed(AppRoute.getLoginScreen());
  }

  Future<bool> deleteAccount() async {
    try {
      final token = StorageService.token;
      final refreshToken = StorageService.refreshToken;
      final userId = currentUserId;

      if (token == null || refreshToken == null || userId == null) {
        AppLoggerHelper.debug(
          'Cannot delete account: Missing token or user ID',
        );
        return false;
      }

      // final String endpoint = ApiConstants.deleteAccount.replaceFirst(
      //   '{user_id}',
      //   userId,
      // );
      final response = await _networkCaller.deleteRequest(
        ApiConstants.deleteAccount,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': '$refreshToken',
        },
      );

      AppLoggerHelper.debug(
        'Delete account response: ${response.statusCode} - ${response.errorMessage}',
      );

      return response.isSuccess;
    } catch (e) {
      return false;
    }
  }
}

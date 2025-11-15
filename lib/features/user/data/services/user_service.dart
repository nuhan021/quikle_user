import 'package:get/get.dart';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/routes/app_routes.dart';
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
      _currentUser.value = null;
      return;
    }

    try {
      final ResponseData response = await _networkCaller.getRequest(
        ApiConstants.getUserProfile,
        headers: {
          'Authorization': 'Bearer $token',
          'refresh-token': '$refreshToken',
        },
      );
      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.responseData['data']);
        _currentUser.value = user;
        _isLoggedIn.value = true;
      } else {
        _currentUser.value = null;
        _isLoggedIn.value = false;
      }
    } catch (e) {
      // Don't throw - just log and set user to null
      print('Error loading user profile: $e');
      _currentUser.value = null;
      _isLoggedIn.value = false;
    }
  }

  /// Refresh user data from server
  Future<void> refreshUser() async {
    await _loadUser();
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
    await StorageService.logoutUser();
    _currentUser.value = null;
    _isLoggedIn.value = false;
    Get.offAllNamed(AppRoute.getLoginScreen());
  }
}

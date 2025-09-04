import 'package:get/get.dart';
import 'package:quikle_user/core/models/user_model.dart';
import 'package:quikle_user/core/services/storage_service.dart';

class UserService extends GetxController {
  static UserService get instance => Get.find<UserService>();
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxString _token = ''.obs;
  UserModel? get currentUser => _currentUser.value;
  String get token => _token.value;
  bool get isLoggedIn => _currentUser.value != null && _token.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    final userId = StorageService.userId;
    final token = StorageService.token;

    if (userId != null && token != null) {
      _token.value = token;
      // TODO: Load user data from storage or fetch from API
      _currentUser.value = UserModel(
        id: userId,
        // Add other user data
      );
    }
  }

  Future<void> setUser(UserModel user, String token) async {
    _currentUser.value = user;
    _token.value = token;
    if (user.id != null) {
      await StorageService.saveToken(token, user.id!);
    }
  }

  void updateUser(UserModel updatedUser) {
    _currentUser.value = updatedUser;
    _currentUser.refresh();
  }

  Future<void> clearUser() async {
    _currentUser.value = null;
    _token.value = '';
    await StorageService.logoutUser();
  }

  bool get isUserVerified => _currentUser.value?.isVerified ?? false;
  String get userName => _currentUser.value?.name ?? 'User';
  String get userPhone => _currentUser.value?.phone ?? '';
  String get userEmail => _currentUser.value?.email ?? '';
}

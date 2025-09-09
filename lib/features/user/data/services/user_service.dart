import 'package:get/get.dart';
import '../models/user_model.dart';

class UserService extends GetxController {
  static UserService get instance => Get.find<UserService>();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxString _token = ''.obs;
  final RxBool _isLoggedIn = false.obs;

  UserModel? get currentUser => _currentUser.value;
  String get token => _token.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String? get currentUserId => _currentUser.value?.id;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    try {
      _currentUser.value = UserModel(
        id: 'user_123',
        name: 'Aanya Desai',
        phone: '+1 (555) 123-4567',
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );
      _isLoggedIn.value = true;
      _token.value = 'demo_token_123';
    } catch (e) {
      throw Exception('Error loading user from storage: $e');
    }
  }

  Future<void> setUser(UserModel user, String token) async {
    try {
      _currentUser.value = user;
      _token.value = token;
      _isLoggedIn.value = true;
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  void updateUser(UserModel updatedUser) {
    _currentUser.value = updatedUser;
  }

  Future<void> clearUser() async {
    try {
      _currentUser.value = null;
      _token.value = '';
      _isLoggedIn.value = false;
    } catch (e) {
      throw Exception('Failed to clear user: $e');
    }
  }
}

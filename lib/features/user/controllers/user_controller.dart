import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/services/user_service.dart';

class UserController extends GetxController {
  final UserService _userService = Get.find<UserService>();

  UserModel? get currentUser => _userService.currentUser;
  bool get isLoggedIn => _userService.isLoggedIn;
  String? get currentUserId => _userService.currentUserId;
  String get token => _userService.token;
  Future<void> updateUserProfile({String? name, String? phone}) async {
    try {
      if (currentUser == null) throw Exception('No user logged in');

      final updatedUser = currentUser!.copyWith(
        name: name,
        phone: phone,
        updatedAt: DateTime.now(),
      );

      _userService.updateUser(updatedUser);
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }
}

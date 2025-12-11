import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quikle_user/app.dart';
import 'package:quikle_user/core/services/network_controller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/services/freshchat_service.dart';
import 'core/common/widgets/no_internet_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (required for FCM + any Firebase service)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize services
  await StorageService.init();

  // Initialize controllers
  final networkController = Get.put(NetworkController());

  // Freshchat service
  Get.put(FreshchatService());

  bool isOverlayShown = false;

  ever<bool>(networkController.hasConnection, (hasInternet) {
    if (!hasInternet && !isOverlayShown) {
      isOverlayShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.dialog(
          const NoInternetScreen(),
          barrierDismissible: false,
          useSafeArea: false,
        );
      });
    } else if (hasInternet && isOverlayShown) {
      isOverlayShown = false;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  });

  runApp(const MyApp());
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/app.dart';
import 'package:quikle_user/core/services/network_controller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'core/common/widgets/no_internet_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  final networkController = Get.put(NetworkController());
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

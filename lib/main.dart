import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quikle_user/app.dart';
import 'package:quikle_user/core/services/network_controller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/services/freshchat_service.dart';
import 'package:quikle_user/core/services/firebase/fcm_notification_handler.dart';
import 'core/common/widgets/no_internet_screen.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("⬅️ Background Message Received: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    print("📱 FCM Token refreshed: $fcmToken");
  });

  String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  print("🍏 APNS Token: $apnsToken");

  String? token = await _getFCMToken();
  print("📱 FCM Token: $token");

  await StorageService.init();
  await FCMNotificationHandler.initialize();
  final networkController = Get.put(NetworkController());
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

Future<String?> _getFCMToken() async {
  String? token;
  while (token == null) {
    token = await FirebaseMessaging.instance.getToken();
    if (token == null) await Future.delayed(const Duration(seconds: 1));
  }
  return token;
}

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

/// 🔥 REQUIRED for background notifications
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("⬅️ Background Message Received: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔥 Firebase initialized successfully!");

  // Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request permissions (Android 13+ and iOS)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // ⛔ IMPORTANT — Without this, foreground notifications will NOT appear
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Print FCM token
  String? token = await FirebaseMessaging.instance.getToken();
  print("📱 FCM Token: $token");

  // Initialize services
  await StorageService.init();

  // 🔔 Initialize FCM notification handler
  await FCMNotificationHandler.initialize();
  print("🔔 FCM Notification Handler initialized!");

  // Initialize controllers
  final networkController = Get.put(NetworkController());

  // Freshchat
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

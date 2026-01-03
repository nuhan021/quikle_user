import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:quikle_user/app.dart';
import 'package:quikle_user/core/services/network_controller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/services/freshchat_service.dart';
import 'package:quikle_user/core/services/firebase/fcm_notification_handler.dart';

import 'core/common/widgets/no_internet_screen.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final isFreshchatNotification = await Freshchat.isFreshchatNotification(
    message.data,
  );

  if (isFreshchatNotification) {
    // Initialize Freshchat SDK in background isolate
    Freshchat.init(
      '60c5fdb1-e89c-4906-982a-00cb1f2c9d10',
      'fd2be8f5-0f01-445c-9f50-9e0e5bb41ec1',
      'https://msdk.freshchat.com',
    );

    // Configure notification settings for background
    Freshchat.setNotificationConfig(
      priority: Priority.PRIORITY_HIGH,
      importance: Importance.IMPORTANCE_HIGH,
      notificationSoundEnabled: true,
      notificationInterceptionEnabled: false,
    );

    Freshchat.handlePushNotification(message.data);
  }
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

  await StorageService.init();
  await FCMNotificationHandler.initialize();

  final networkController = Get.put(NetworkController());
  final freshchatService = Get.put(FreshchatService());

  String? fcmToken = await FirebaseMessaging.instance.getToken();
  if (fcmToken != null) {
    print("📱 FCM Token: $fcmToken");
    await freshchatService.setFCMToken(fcmToken);
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print("📱 FCM Token refreshed: $newToken");
    freshchatService.setFCMToken(newToken);
  });

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

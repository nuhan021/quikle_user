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

  // String? fcmToken = await FirebaseMessaging.instance.getToken();
  // if (fcmToken != null) {
  //   print("📱 FCM Token: $fcmToken");
  //   await freshchatService.setFCMToken(fcmToken);
  // }

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

/**
 * 
 * 
 * Cashfree 
 * 
 * 
 */

// import 'package:flutter/material.dart';
// import 'package:quikle_user/features/payment/services/cashfree_payment_service.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: PaymentPage());
//   }
// }

// class PaymentPage extends StatefulWidget {
//   const PaymentPage({super.key});

//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   final CashfreePaymentService _paymentService = CashfreePaymentService();

//   final TextEditingController _cfOrderIdController = TextEditingController();
//   final TextEditingController _paymentSessionIdController =
//       TextEditingController();
//   final TextEditingController _parentOrderIdController =
//       TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _paymentService.initialize(
//       onPaymentSuccess: (orderId) {
//         debugPrint('Payment Success: $orderId');
//       },
//       onPaymentError: (orderId, errorMessage) {
//         debugPrint('Payment Error: $errorMessage');
//       },
//       onPaymentProcessing: () {
//         debugPrint('Payment Processing');
//       },
//     );
//   }

//   void _payNow() {
//     if (_cfOrderIdController.text.isEmpty ||
//         _paymentSessionIdController.text.isEmpty ||
//         _parentOrderIdController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
//       return;
//     }

//     _paymentService.startPayment(
//       cfOrderId: _cfOrderIdController.text.trim(),
//       paymentSessionId: _paymentSessionIdController.text.trim(),
//       parentOrderId: _parentOrderIdController.text.trim(),
//     );
//   }

//   @override
//   void dispose() {
//     _cfOrderIdController.dispose();
//     _paymentSessionIdController.dispose();
//     _parentOrderIdController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Cashfree Payment')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _cfOrderIdController,
//               decoration: const InputDecoration(
//                 labelText: 'CF Order ID',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _paymentSessionIdController,
//               decoration: const InputDecoration(
//                 labelText: 'Payment Session ID',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _parentOrderIdController,
//               decoration: const InputDecoration(
//                 labelText: 'Parent Order ID',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(onPressed: _payNow, child: const Text('Pay Now')),
//           ],
//         ),
//       ),
//     );
//   }
// }

/*

PHone pe



 */

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

// void main() {
//   runApp(const MaterialApp(home: PhonePePaymentPage()));
// }

// class PhonePePaymentPage extends StatefulWidget {
//   const PhonePePaymentPage({super.key});

//   @override
//   State<PhonePePaymentPage> createState() => _PhonePePaymentPageState();
// }

// class _PhonePePaymentPageState extends State<PhonePePaymentPage> {
//   // Use your actual Sandbox MID from the dashboard
//   String merchantId = "M23KQHM5ST3C2";
//   bool isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     phonePeInit();
//   }

//   void phonePeInit() async {
//     try {
//       // environment: 'SANDBOX' for testing, 'PRODUCTION' for live
//       bool result = await PhonePePaymentSdk.init(
//         'SANDBOX',
//         merchantId,
//         "UserFlowID001",
//         true,
//       );
//       setState(() {
//         isInitialized = result;
//       });
//     } catch (e) {
//       print("Init Error: $e");
//     }
//   }

//   void startPayment() async {
//     // 1. The Token from your backend
//     String backendToken =
//         "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcmVzT24iOjE3Njg0NzQxNzc1MTMsIm1lcmNoYW50SWQiOiJNMjNLUUhNNTNTNzNDIiwibWVyY2hhbnRPcmRlcklkIjoiUE9SRF8yRUQ5Q0I4MiJ9.tqkjJjvi10ZMBvttiPVMrnJ7qoz62czZJvThFDZRpVk";

//     String phonePeOrderId = "OMO2601150949375131868821";

//     Map<String, dynamic> payload = {
//       "orderId": phonePeOrderId,
//       "merchantId": merchantId,
//       "token": backendToken,
//       "paymentMode": {"type": "PAY_PAGE"},
//     };

//     String request = jsonEncode(payload);

//     // 3. Set the target app (Simulator)
//     String appSchema = "com.phonepe.simulator";

//     try {
//       var response = await PhonePePaymentSdk.startTransaction(
//         request, // Send encoded request
//         appSchema,
//       );

//       if (response != null) {
//         String status = response['status'].toString();
//         String error = response['error'] ?? "None";

//         if (status == 'SUCCESS') {
//           _showSnackBar("Success!");
//         } else {
//           _showSnackBar("Status: $status, Error: $error");
//         }
//       }
//     } catch (e) {
//       _showSnackBar("Transaction Error: $e");
//     }
//   }

//   void _showSnackBar(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("PhonePe Test")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: isInitialized ? startPayment : null,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.purple,
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//           ),
//           child: Text(
//             isInitialized ? "PAY NOW" : "SDK Not Ready",
//             style: const TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }

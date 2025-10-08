import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import 'package:quikle_user/features/prescription/data/services/prescription_service.dart';

class PrescriptionNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final PrescriptionService _prescriptionService = PrescriptionService();

  static bool _isInitialized = false;

  // Initialize the notification service
  static Future<void> init() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    await _requestPermissions();

    _isInitialized = true;
  }

  // Request notification permissions
  static Future<void> _requestPermissions() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  // Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && payload.startsWith('prescription_')) {
      // Navigate to prescription details
      final prescriptionId = payload.replaceFirst('prescription_', '');
      Future.microtask(() => _handlePrescriptionTap(prescriptionId));
    }
  }

  static Future<void> _handlePrescriptionTap(String prescriptionId) async {
    try {
      PrescriptionModel? prescription;

      if (Get.isRegistered<PrescriptionController>()) {
        final controller = Get.find<PrescriptionController>();
        prescription = _findPrescriptionById(
          controller.prescriptions,
          prescriptionId,
        );

        if (prescription == null) {
          await controller.loadUserPrescriptions(silent: true);
          prescription = _findPrescriptionById(
            controller.prescriptions,
            prescriptionId,
          );
        }

        if (prescription != null) {
          controller.selectedPrescription.value = prescription;
        }
      }

      prescription ??= await _prescriptionService.getPrescriptionById(
        prescriptionId,
      );

      if (prescription != null) {
        Get.toNamed('/prescription-details', arguments: prescription);
      } else {
        Get.toNamed('/prescription-list');
        Get.snackbar(
          'Prescription not found',
          'Please check your prescriptions list.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to open prescription: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  static PrescriptionModel? _findPrescriptionById(
    List<PrescriptionModel> prescriptions,
    String id,
  ) {
    for (final prescription in prescriptions) {
      if (prescription.id == id) {
        return prescription;
      }
    }
    return null;
  }

  // Show notification for prescription status update
  static Future<void> showPrescriptionStatusNotification({
    required PrescriptionModel prescription,
  }) async {
    if (!_isInitialized) {
      await init();
    }

    final notificationData = _getNotificationData(prescription.status);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'prescription_channel',
          'Prescription Updates',
          channelDescription: 'Notifications for prescription status updates',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF2196F3), // Blue color for medical notifications
          showWhen: true,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      prescription.id.hashCode, // Use prescription ID hash as notification ID
      notificationData.title,
      notificationData.body,
      platformChannelSpecifics,
      payload: 'prescription_${prescription.id}',
    );
  }

  // Get notification title and body based on prescription status
  static _NotificationData _getNotificationData(PrescriptionStatus status) {
    switch (status) {
      case PrescriptionStatus.uploaded:
        return const _NotificationData(
          title: '📋 Prescription Uploaded',
          body:
              'Your prescription has been uploaded successfully. Pharmacies will review it shortly.',
        );
      case PrescriptionStatus.underReview:
        return const _NotificationData(
          title: '⏳ Prescription Under Review',
          body:
              'A pharmacy has opened your prescription for review. You will be notified when medicines are available.',
        );
      case PrescriptionStatus.valid:
        return const _NotificationData(
          title: '✅ Prescription Valid',
          body:
              'Your prescription is valid. We are checking medicine availability.',
        );
      case PrescriptionStatus.invalid:
        return const _NotificationData(
          title: '❌ Prescription Invalid',
          body:
              'We could not validate your prescription. Please check and upload a valid one or contact support.',
        );
      case PrescriptionStatus.medicinesReady:
        return const _NotificationData(
          title: '💊 Medicines Ready',
          body:
              'Medicines are ready for your order. Review them now and place your order.',
        );
    }
  }

  // Show a general prescription reminder notification
  // static Future<void> showPrescriptionReminderNotification() async {
  //   if (!_isInitialized) {
  //     await init();
  //   }

  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //         'prescription_reminder_channel',
  //         'Prescription Reminders',
  //         channelDescription: 'Reminders for prescription-related actions',
  //         importance: Importance.defaultImportance,
  //         priority: Priority.defaultPriority,
  //         icon: '@mipmap/ic_launcher',
  //       );

  //   const DarwinNotificationDetails iOSPlatformChannelSpecifics =
  //       DarwinNotificationDetails(
  //         presentAlert: true,
  //         presentBadge: true,
  //         presentSound: true,
  //       );

  //   const NotificationDetails platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: iOSPlatformChannelSpecifics,
  //   );

  //   await _localNotifications.show(
  //     999, // Fixed ID for reminder notifications
  //     '💊 Need Medicines?',
  //     'Upload your prescription to get quotes from nearby pharmacies.',
  //     platformChannelSpecifics,
  //     payload: 'prescription_upload',
  //   );
  // }

  // Cancel all prescription notifications
  static Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Cancel specific prescription notification
  static Future<void> cancelNotification(String prescriptionId) async {
    await _localNotifications.cancel(prescriptionId.hashCode);
  }
}

class _NotificationData {
  final String title;
  final String body;

  const _NotificationData({required this.title, required this.body});
}

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class WhatsAppService {
  static const String _whatsappBusinessNumber = '+1234567890';

  static Future<void> requestCustomOrder({
    required String searchQuery,
    String? userName,
  }) async {
    final message = _generateCustomOrderMessage(searchQuery, userName);
    final encodedMessage = Uri.encodeComponent(message);
    final phone = _digitsOnly(_whatsappBusinessNumber);
    final appUri = Uri.parse(
      'whatsapp://send?phone=$phone&text=$encodedMessage',
    );

    try {
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri, mode: LaunchMode.externalApplication);
        return;
      }
      final webUri = Uri.parse('https://wa.me/$phone?text=$encodedMessage');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return;
      }
      _showErrorSnackbar(
        Platform.isIOS
            ? 'Cannot open WhatsApp. Check permissions or installation.'
            : 'Cannot open WhatsApp. It may not be installed or visible to the app.',
      );
    } catch (e) {
      if (kDebugMode) print('Error launching WhatsApp: $e');
      _showErrorSnackbar('Failed to open WhatsApp. Please try again.');
    }
  }

  static String _digitsOnly(String s) => s.replaceAll(RegExp(r'\D'), '');

  static String _generateCustomOrderMessage(
    String searchQuery,
    String? userName,
  ) {
    final greeting = userName != null ? 'Hello, I am $userName.' : 'Hello!';
    return '''$greeting

I was searching for "$searchQuery" on the Quikle app but couldn't find it in your current catalog.

Could you please help me with a custom order for this item? I would appreciate details about:
- Availability
- Pricing
- Delivery time

Thank you for your assistance!''';
  }

  static void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}

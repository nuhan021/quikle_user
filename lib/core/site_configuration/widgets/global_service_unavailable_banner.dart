import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/site_configuration/controllers/site_configuration_controller.dart';

class GlobalServiceUnavailableBanner extends StatelessWidget {
  const GlobalServiceUnavailableBanner({super.key, this.controller});

  final SiteConfigurationController? controller;

  @override
  Widget build(BuildContext context) {
    final siteConfigurationController =
        controller ?? Get.find<SiteConfigurationController>();

    return Obx(() {
      if (siteConfigurationController.isServiceAvailable.value) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        color: Colors.red.shade700,
        child: SafeArea(
          top: false,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Service unavailable',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      );
    });
  }
}

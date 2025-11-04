import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:app_settings/app_settings.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import '../../../../core/services/network_controller.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();

    return Obx(() {
      // Auto-navigate when internet is restored
      if (networkController.hasConnection.value) {
        Future.microtask(() => Get.offAll(() => const LoginScreen()));
      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                Text(
                  "Oops! Network is off",
                  style: getTextStyle(
                    font: CustomFonts.manrope,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Text(
                  "Turn on your mobile network or Wi-Fi to continue ordering",
                  style: getTextStyle(
                    font: CustomFonts.manrope,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                Image.asset(
                  'assets/images/special_images/noInternet.png',
                  height: 300.h,
                  fit: BoxFit.contain,
                ),

                const Spacer(flex: 2),

                Row(
                  children: [
                    // Retry Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          AppSettings.openAppSettings(
                            type: AppSettingsType.wifi,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC107),
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Enable Network",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Settings Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          AppSettings.openAppSettings();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Settings",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    });
  }
}

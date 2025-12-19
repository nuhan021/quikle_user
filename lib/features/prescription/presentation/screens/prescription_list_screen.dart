import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/prescription_card_widget.dart';

class PrescriptionListScreen extends StatefulWidget {
  const PrescriptionListScreen({super.key});

  @override
  State<PrescriptionListScreen> createState() => _PrescriptionListScreenState();
}

class _PrescriptionListScreenState extends State<PrescriptionListScreen> {
  final GlobalKey _cartFabKey = GlobalKey(); // for locating the button

  @override
  void initState() {
    super.initState();
    // Fetch prescriptions when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final controller = Get.find<PrescriptionController>();
        // Always load to ensure fresh data from API
        controller.loadUserPrescriptions();
      } catch (e) {
        print('Error loading prescriptions: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrescriptionController>();

    return CartAnimationWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,

        appBar: const CommonAppBar(
          title: 'My Prescriptions',
          showNotification: false,
          showProfile: false,
          backgroundColor: AppColors.backgroundLight,
        ),

        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => controller.refreshData(),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.prescriptions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 80.sp,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No prescriptions found',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Upload a prescription to get medicine recommendations',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton.icon(
                          onPressed: controller.isUploading.value
                              ? null
                              : controller.showUploadOptions,
                          icon: const Icon(Icons.add),
                          label: const Text('Upload Prescription'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Prescriptions (${controller.prescriptions.length})',
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ebonyBlack,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: controller.isUploading.value
                                ? null
                                : controller.showUploadOptions,
                            icon: Icon(Icons.add, size: 16.sp),
                            label: Text(
                              'Upload',
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: controller.prescriptions.length,
                        itemBuilder: (context, index) {
                          final prescription = controller.prescriptions[index];
                          return PrescriptionCardWidget(
                            prescription: prescription,
                            controller: controller,
                            onCartAnimation: _triggerCartAnimation,
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),

        floatingActionButton: Container(
          key: _cartFabKey,
          child: const FloatingCartButton(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  void _triggerCartAnimation(GlobalKey sourceKey, String imagePath) {
    try {
      final controller = Get.find<CartAnimationController>();

      final sourceBox =
          sourceKey.currentContext?.findRenderObject() as RenderBox?;
      if (sourceBox == null) return;

      final topLeft = sourceBox.localToGlobal(Offset.zero);
      final center = Offset(
        topLeft.dx + sourceBox.size.width / 2,
        topLeft.dy + sourceBox.size.height / 2,
      );

      final screen = MediaQuery.of(context).size;
      final target = Offset(screen.width - 40.w, screen.height - 100.h);

      final startSize = sourceBox.size.shortestSide.clamp(24.0, 80.0);
      final endSize = 28.w;

      controller.addAnimation(
        CartAnimation(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          imagePath: imagePath,
          startPosition: center,
          endPosition: target,
          startSize: startSize,
          endSize: endSize,
        ),
      );
    } catch (e) {
      print('Cart animation controller not found: $e');
    }
  }
}

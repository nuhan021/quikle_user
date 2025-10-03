import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';

import 'package:quikle_user/features/prescription/presentation/widgets/prescription_image_card_widget.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/prescription_info_card_widget.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/prescription_timeline_widget.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/vendor_response_card.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/prescription_status_badge.dart';

class PrescriptionDetailsScreen extends StatefulWidget {
  const PrescriptionDetailsScreen({super.key});

  @override
  State<PrescriptionDetailsScreen> createState() =>
      _PrescriptionDetailsScreenState();
}

class _PrescriptionDetailsScreenState extends State<PrescriptionDetailsScreen> {
  final GlobalKey _cartFabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrescriptionController>();
    final prescription = Get.arguments as PrescriptionModel;

    return CartAnimationWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: const CommonAppBar(
          title: 'Prescription Details',
          showNotification: false,
          showProfile: false,
          backgroundColor: AppColors.backgroundLight,
        ),
        body: RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          color: AppColors.primary,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrescriptionImageCardWidget(prescription: prescription),

                SizedBox(height: 8.h),

                PrescriptionInfoCardWidget(prescription: prescription),

                SizedBox(height: 8.h),

                PrescriptionTimelineWidget(prescription: prescription),

                if (prescription.vendorResponses.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Text(
                    'Store Responses',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  ...prescription.vendorResponses.map((response) {
                    if (response.status == VendorResponseStatus.approved ||
                        response.status ==
                            VendorResponseStatus.partiallyApproved) {
                      return VendorResponseCard(
                        response: response,
                        controller: controller,
                        onCartAnimation: _triggerCartAnimation,
                      );
                    }

                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: _getVendorStatusColor(
                            response.status,
                          ).withValues(alpha: .3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: _getVendorStatusColor(
                                response.status,
                              ).withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.store,
                              color: _getVendorStatusColor(response.status),
                              size: 16.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  response.vendorName,
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                VendorResponseStatusBadge(
                                  status: response.status,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 30.h),
                ] else
                  SizedBox(height: 30.h),
              ],
            ),
          ),
        ),

        floatingActionButton: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(right: 16.w, bottom: 16.h),
            child: Container(
              key: _cartFabKey,
              child: const FloatingCartButton(),
            ),
          ),
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

      final sourceTopLeft = sourceBox.localToGlobal(Offset.zero);
      final sourceCenter = Offset(
        sourceTopLeft.dx + sourceBox.size.width / 2,
        sourceTopLeft.dy + sourceBox.size.height / 2,
      );

      Offset? targetCenter;
      final fabBox =
          _cartFabKey.currentContext?.findRenderObject() as RenderBox?;
      if (fabBox != null) {
        final fabTopLeft = fabBox.localToGlobal(Offset.zero);
        targetCenter = Offset(
          fabTopLeft.dx + fabBox.size.width / 2,
          fabTopLeft.dy + fabBox.size.height / 2,
        );
      }

      targetCenter ??= () {
        final size = MediaQuery.of(context).size;
        final safeBottom = MediaQuery.of(context).padding.bottom;
        return Offset(size.width - 40.w, size.height - (safeBottom + 40.h));
      }();

      final startSize = sourceBox.size.shortestSide.clamp(24.0, 80.0);
      final endSize = 28.w;

      controller.addAnimation(
        CartAnimation(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          imagePath: imagePath,
          startPosition: sourceCenter,
          endPosition: targetCenter,
          startSize: startSize,
          endSize: endSize,
        ),
      );
    } catch (e) {
      print('Cart animation error: $e');
    }
  }

  Color _getVendorStatusColor(VendorResponseStatus status) {
    switch (status) {
      case VendorResponseStatus.pending:
        return Colors.orange;
      case VendorResponseStatus.approved:
        return Colors.green;
      case VendorResponseStatus.partiallyApproved:
        return Colors.blue;
      case VendorResponseStatus.rejected:
        return Colors.red;
      case VendorResponseStatus.expired:
        return Colors.grey;
    }
  }
}

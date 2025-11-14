import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
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
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  PrescriptionImageCardWidget(prescription: prescription),
                  SizedBox(height: 8.h),
                  // Show rejection reason as separate box for invalid prescriptions
                  if (prescription.status == PrescriptionStatus.invalid &&
                      prescription.notes?.isNotEmpty == true) ...[
                    _buildRejectionReasonBox(prescription.notes!),
                    SizedBox(height: 8.h),
                  ],

                  if (prescription.vendorResponses.isNotEmpty) ...[
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
                    SizedBox(height: 8.h),
                  ],
                  PrescriptionInfoCardWidget(prescription: prescription),
                  SizedBox(height: 8.h),
                  PrescriptionTimelineWidget(prescription: prescription),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
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

  Widget _buildRejectionReasonBox(String reason) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.shade700,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Rejection Reason',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            reason,
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: Colors.red.shade200, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.orange.shade700,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Suggested Actions',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _buildActionPoint(
                  '• Ensure the prescription is clear and readable',
                ),
                _buildActionPoint(
                  '• Check that the prescription date is not expired',
                ),
                _buildActionPoint(
                  '• Verify all required information is visible',
                ),
                _buildActionPoint(
                  '• Upload a new prescription with corrections',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(
        text,
        style: getTextStyle(
          font: CustomFonts.inter,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

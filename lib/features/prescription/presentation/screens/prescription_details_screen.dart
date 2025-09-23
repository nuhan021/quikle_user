
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import 'package:quikle_user/features/prescription/data/models/prescription_model.dart';
import 'package:quikle_user/core/common/widgets/common_app_bar.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/prescription_image_card_widget.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/prescription_info_card_widget.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/prescription_timeline_widget.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/vendor_response_card.dart';
import 'package:quikle_user/features/prescription/presentation/widgets/prescription_status_badge.dart';

class PrescriptionDetailsScreen extends StatelessWidget {
  const PrescriptionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrescriptionController>();
    final prescription = Get.arguments as PrescriptionModel;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: const CommonAppBar(
        title: 'Prescription Details',
        showNotification: false,
        showProfile: false,
        backgroundColor: AppColors.backgroundLight,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            PrescriptionImageCardWidget(prescription: prescription),

            SizedBox(height: 16.h),

            
            PrescriptionInfoCardWidget(prescription: prescription),

            SizedBox(height: 16.h),

            
            PrescriptionTimelineWidget(prescription: prescription),

            
            if (prescription.vendorResponses.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                'Store Responses',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              ...prescription.vendorResponses.map((response) {
                
                if (response.status == VendorResponseStatus.approved ||
                    response.status == VendorResponseStatus.partiallyApproved) {
                  return VendorResponseCard(
                    response: response,
                    controller: controller,
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
                      ).withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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
                          ).withOpacity(0.1),
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
                            VendorResponseStatusBadge(status: response.status),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
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

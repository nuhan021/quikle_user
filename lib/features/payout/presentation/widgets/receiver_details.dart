import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/payout/controllers/payout_controller.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'change_receiver_modal.dart';

class ReceiverDetails extends StatelessWidget {
  const ReceiverDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final payoutController = Get.find<PayoutController>();

    return Obx(() {
      final receiverName = payoutController.getCurrentReceiverName();
      final receiverPhone = payoutController.getCurrentReceiverPhone();

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.ebonyBlack, width: 1.8),
          borderRadius: BorderRadius.circular(26.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$receiverName ${receiverPhone.isNotEmpty ? "($receiverPhone)" : ""}',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ebonyBlack,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () => _showReceiverModal(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.beakYellow.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.beakYellow, width: 1),
                ),
                child: Text(
                  'Change',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.beakYellow,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showReceiverModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => const ChangeReceiverModal(),
    );
  }
}

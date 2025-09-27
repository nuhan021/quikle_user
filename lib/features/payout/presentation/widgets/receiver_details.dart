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

      return Row(
        children: [
          Expanded(
            child: Text(
              'Order for $receiverName ${receiverPhone.isNotEmpty ? "($receiverPhone)" : ""}',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.ebonyBlack,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _showReceiverModal(context),
            child: Text(
              'Change',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.beakYellow,
              ),
            ),
          ),
        ],
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

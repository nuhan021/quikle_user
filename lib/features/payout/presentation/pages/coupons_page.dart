import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import '../../controllers/payout_controller.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final controller = Get.find<PayoutController>();
  Map<String, dynamic>? selected;
  String? expandedCouponId;

  @override
  void initState() {
    super.initState();
    selected = controller.appliedCoupon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text('Available Coupons'), centerTitle: true),
      body: Obx(() {
        final coupons = controller.availableCoupons;

        if (coupons.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.local_offer_outlined, size: 60, color: Colors.grey),
                SizedBox(height: 12),
                Text('No coupons available'),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: coupons.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (_, i) {
            final c = coupons[i];
            final isApplicable = controller.isCouponApplicable(c);
            final couponId = c['id']?.toString() ?? i.toString();
            final isExpanded = expandedCouponId == couponId;
            return _couponCard(
              data: c,
              isSelected: selected?['id'] == c['id'],
              isApplicable: isApplicable,
              isExpanded: isExpanded,
              savings: controller.estimateSavings(c),
              onTap: isApplicable ? () => setState(() => selected = c) : null,
              onExpand: () => setState(() {
                expandedCouponId = isExpanded ? null : couponId;
              }),
            );
          },
        );
      }),
      bottomNavigationBar: selected == null
          ? null
          : Padding(
              padding: EdgeInsets.all(16.w),
              child: ElevatedButton(
                onPressed: () {
                  controller.applyCouponLocally(selected!);
                  Get.back();
                },
                child: const Text('Apply Coupon'),
              ),
            ),
    );
  }

  Widget _couponCard({
    required Map<String, dynamic> data,
    required bool isSelected,
    required bool isApplicable,
    required bool isExpanded,
    required double savings,
    VoidCallback? onTap,
    required VoidCallback onExpand,
  }) {
    final code = data['cupon'] ?? data['coupon'] ?? '';
    final title = data['title'] ?? code;
    final desc = data['description'] ?? '';
    final min = data['up_to'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onExpand,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12.r),
              bottom: isExpanded ? Radius.zero : Radius.circular(12.r),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4F4),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.r),
                  bottom: isExpanded ? Radius.zero : Radius.circular(12.r),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E63),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.local_offer,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getTextStyle(
                            font: CustomFonts.manrope,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Use code $code',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 11.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (min != null)
                    Text(
                      'Min ₹$min',
                      style: TextStyle(
                        color: isApplicable
                            ? Colors.blue.shade700
                            : Colors.red.shade700,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  SizedBox(width: 6.w),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 24.sp,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    desc,
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 13.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      if (savings > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            'Save ₹${savings.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (savings > 0 && min != null) SizedBox(width: 8.w),
                      if (min != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: isApplicable
                                ? Colors.blue.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            'Min ₹$min',
                            style: TextStyle(
                              color: isApplicable
                                  ? Colors.blue.shade700
                                  : Colors.red.shade700,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: const Color(0xFF6366F1).withOpacity(.3),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              code,
                              style: TextStyle(
                                color: const Color(0xFF6366F1),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ElevatedButton(
                        onPressed: isApplicable ? onTap : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? const Color(0xFF6366F1)
                              : Colors.white,
                          foregroundColor: isSelected
                              ? Colors.white
                              : const Color(0xFF6366F1),
                          side: BorderSide(
                            color: const Color(0xFF6366F1),
                            width: 1.5,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isSelected ? 'Applied' : 'Apply',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!isApplicable)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14.sp,
                            color: Colors.orange.shade700,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Minimum order amount not met',
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontSize: 11.sp,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

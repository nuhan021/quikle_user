import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DisclaimerSection extends StatelessWidget {
  final bool hasMedicine;

  const DisclaimerSection({super.key, required this.hasMedicine});

  static const String _medicineText =
      'Quikle connects customers with licensed pharmacies. Medicines are dispensed by partner pharmacies as per applicable laws.';

  static const String _cancellationText =
      '100% cancellation fee may apply once the order is confirmed.';

  void _showFullText(String title, String text) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: Icon(Icons.close, size: 20.sp),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(text, style: TextStyle(fontSize: 14.sp, height: 1.4)),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildRow(String title, String text) {
    return InkWell(
      onTap: () => _showFullText(title, text),
      child: Container(
        width: double.infinity,
        color: Colors.grey.shade200,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp, color: Colors.black87),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.info_outline, size: 18.sp, color: Colors.grey.shade700),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];

    // Cancellation disclaimer always shown
    rows.add(_buildRow('Cancellation Policy', _cancellationText));

    // Medicine disclaimer shown only when there's medicine in cart
    if (hasMedicine) {
      rows.insert(0, _buildRow('Medicine Disclaimer', _medicineText));
    }

    return Column(
      children: rows
          .map(
            (w) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: w,
            ),
          )
          .toList(),
    );
  }
}

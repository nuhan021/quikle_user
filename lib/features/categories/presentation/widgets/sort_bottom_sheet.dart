import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';

class SortBottomSheet extends StatefulWidget {
  final String selectedSort;
  final Function(String) onSortSelected;

  const SortBottomSheet({
    super.key,
    required this.selectedSort,
    required this.onSortSelected,
  });

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  late String _currentSort;

  @override
  void initState() {
    super.initState();
    _currentSort = widget.selectedSort;
  }

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {'key': 'price_low_high', 'label': 'Price: Low to High'},
      {'key': 'a_z', 'label': 'Alphabetical: A to Z'},
      {'key': 'z_a', 'label': 'Alphabetical: Z to A'},
      {'key': 'popularity', 'label': 'Popularity'},
      {'key': 'new_arrivals', 'label': 'New Arrivals'},
    ];

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          Center(
            child: Text(
              'Sort By',
              style: getTextStyle(
                font: CustomFonts.obviously,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.ebonyBlack,
              ),
            ),
          ),
          SizedBox(height: 20.h),

          
          ...sortOptions.map((option) {
            return ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              contentPadding: EdgeInsets.zero,
              leading: Radio<String>(
                value: option['key']!,
                groupValue: _currentSort,
                onChanged: (value) {
                  setState(() {
                    _currentSort = value!;
                  });
                },
                activeColor: AppColors.ebonyBlack,
              ),
              title: Text(
                option['label']!,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ebonyBlack,
                ),
              ),
            );
          }).toList(),

          SizedBox(height: 20.h),

          
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    "Cancel",
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ebonyBlack,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    widget.onSortSelected(_currentSort);
                    Get.back();
                  },
                  child: Text(
                    "Apply",
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

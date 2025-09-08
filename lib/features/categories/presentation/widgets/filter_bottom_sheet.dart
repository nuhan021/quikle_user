import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> selectedFilters;
  final List<double> priceRange;
  final bool showOnlyInStock;
  final Function(List<String>, List<double>, bool) onFiltersApplied;

  const FilterBottomSheet({
    super.key,
    required this.selectedFilters,
    required this.priceRange,
    required this.showOnlyInStock,
    required this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> _selectedFilters;
  late RangeValues _priceRange;
  late bool _showOnlyInStock;

  final List<Map<String, String>> filterOptions = [
    {'key': 'rating_4_plus', 'label': 'Rating 4+ Stars'},
    {'key': 'fast_delivery', 'label': 'Fast Delivery'},
    {'key': 'discount', 'label': 'On Sale'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilters = List.from(widget.selectedFilters);
    _priceRange = RangeValues(widget.priceRange[0], widget.priceRange[1]);
    _showOnlyInStock = widget.showOnlyInStock;
  }

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter',
                style: getTextStyle(
                  font: CustomFonts.obviously,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ebonyBlack,
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Price Range Section
          Text(
            'Price Range',
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 10.h),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 100,
            divisions: 20,
            labels: RangeLabels(
              '\$${_priceRange.start.round()}',
              '\$${_priceRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
            activeColor: AppColors.beakYellow,
            inactiveColor: AppColors.featherGrey.withOpacity(0.3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_priceRange.start.round()}',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 12.sp,
                  color: AppColors.featherGrey,
                ),
              ),
              Text(
                '\$${_priceRange.end.round()}',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 12.sp,
                  color: AppColors.featherGrey,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Other Filters Section
          Text(
            'Other Filters',
            style: getTextStyle(
              font: CustomFonts.inter,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 10.h),

          ...filterOptions.map((option) {
            final isSelected = _selectedFilters.contains(option['key']);
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedFilters.add(option['key']!);
                  } else {
                    _selectedFilters.remove(option['key']!);
                  }
                });
              },
              title: Text(
                option['label']!,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  color: AppColors.ebonyBlack,
                ),
              ),
              activeColor: AppColors.beakYellow,
              controlAffinity: ListTileControlAffinity.leading,
            );
          }).toList(),

          // In Stock Filter
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _showOnlyInStock,
            onChanged: (value) {
              setState(() {
                _showOnlyInStock = value ?? false;
              });
            },
            title: Text(
              'In Stock Only',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                color: AppColors.ebonyBlack,
              ),
            ),
            activeColor: AppColors.beakYellow,
            controlAffinity: ListTileControlAffinity.leading,
          ),

          SizedBox(height: 30.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedFilters.clear();
                      _priceRange = const RangeValues(0, 100);
                      _showOnlyInStock = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.featherGrey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'Clear All',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.featherGrey,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onFiltersApplied(_selectedFilters, [
                      _priceRange.start,
                      _priceRange.end,
                    ], _showOnlyInStock);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.beakYellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

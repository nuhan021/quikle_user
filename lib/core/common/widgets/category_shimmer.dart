import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading effect for categories section
/// Matches the exact dimensions of CategoriesSection
class CategoryShimmer extends StatelessWidget {
  final int itemCount;

  const CategoryShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: SizedBox(
        height: 70.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                right: index < itemCount - 1 ? 24.w : 0,
              ),
              child: const _CategoryItemShimmer(),
            );
          },
        ),
      ),
    );
  }
}

/// Individual category item shimmer
/// Matches CategoryItem widget dimensions
class _CategoryItemShimmer extends StatelessWidget {
  const _CategoryItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon shimmer
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 6.h),
          // Title shimmer
          Container(
            width: 50.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading effect for product cards
/// Matches the exact dimensions of UnifiedProductCard
class ProductCardShimmer extends StatelessWidget {
  final double? width;
  final double? height;

  const ProductCardShimmer({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image placeholder
          Container(
            width: width ?? double.infinity,
            height: height ?? 100.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(height: 6.h),

          // Product title placeholder
          Container(
            width: (width ?? 100.w) * 0.8,
            height: 12.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 4.h),

          // Rating and info placeholder
          Row(
            children: [
              Container(
                width: 40.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 30.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Price and cart button placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Grid shimmer for category screens (3 columns)
class ProductGridShimmer extends StatelessWidget {
  final int itemCount;

  const ProductGridShimmer({super.key, this.itemCount = 9});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 0.70,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const ProductCardShimmer(),
          childCount: itemCount,
        ),
      ),
    );
  }
}

/// Horizontal shimmer for home screen sections
class ProductHorizontalShimmer extends StatelessWidget {
  final int itemCount;

  const ProductHorizontalShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: itemCount,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: ProductCardShimmer(width: 120.w, height: 120.h),
        ),
      ),
    );
  }
}

/// Product section shimmer for home screen
/// Matches the ProductSection widget with header and 3-column grid
class ProductSectionShimmer extends StatelessWidget {
  final bool isMedicine;

  const ProductSectionShimmer({super.key, this.isMedicine = false});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header shimmer
            SizedBox(
              height: 32.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Icon shimmer
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Title shimmer
                      Container(
                        width: 100.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                  // View all button shimmer
                  Container(
                    width: 60.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),

            // Grid shimmer
            GridView.builder(
              padding: EdgeInsets.only(top: 12.h),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: isMedicine ? 0.7 : 0.9,
              ),
              itemCount: 6, // Always show 6 shimmer cards
              itemBuilder: (context, index) => const ProductCardShimmer(),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

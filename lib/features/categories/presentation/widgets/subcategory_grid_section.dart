import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:shimmer/shimmer.dart';

class SubcategoryGridSection extends StatelessWidget {
  final String categoryTitle;
  final String categoryIconPath;
  final List<SubcategoryModel> subcategories;
  final Function(SubcategoryModel) onSubcategoryTap;
  final VoidCallback? onViewAllTap;
  final bool isLoading;

  const SubcategoryGridSection({
    super.key,
    required this.categoryTitle,
    required this.categoryIconPath,
    required this.subcategories,
    required this.onSubcategoryTap,
    this.onViewAllTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Show shimmer while loading
    if (isLoading) {
      return _buildShimmerState();
    }

    if (subcategories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category title
        // Reduced vertical padding to tighten space between sections
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 42.w,
                height: 42.w,
                child: Center(
                  child: categoryIconPath.toLowerCase().startsWith('http')
                      ? Image.network(
                          categoryIconPath,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.broken_image,
                              size: 20.w,
                              color: AppColors.primary,
                            );
                          },
                        )
                      : Image.asset(
                          categoryIconPath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.category,
                              size: 20.w,
                              color: AppColors.primary,
                            );
                          },
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  categoryTitle,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              // View All button
              if (onViewAllTap != null)
                GestureDetector(
                  onTap: onViewAllTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Subcategories laid out with Wrap so items size to available width
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 8.w;
              final runSpacing = 6.h;
              final crossCount = 3;
              final totalSpacing = spacing * (crossCount - 1);
              final itemWidth =
                  (constraints.maxWidth - totalSpacing) / crossCount;

              return Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: subcategories.map((subcategory) {
                  // Use fixed square size so all cards across rows keep the same
                  // width and height. This prevents rows with fewer items from
                  // showing taller/shorter cards.
                  return SizedBox(
                    width: itemWidth,
                    height: itemWidth,
                    child: _buildSubcategoryCard(subcategory),
                  );
                }).toList(),
              );
            },
          ),
        ),

        // Small bottom gap to separate sections slightly
        SizedBox(height: 6.h),
      ],
    );
  }

  Widget _buildSubcategoryCard(SubcategoryModel subcategory) {
    return GestureDetector(
      onTap: () => onSubcategoryTap(subcategory),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Subcategory icon
            Container(
              width: 56.w,
              height: 56.w,
              child: Center(
                child: subcategory.iconPath.toLowerCase().startsWith('http')
                    ? Image.network(
                        subcategory.iconPath,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.fastfood,
                            size: 32.w,
                            color: AppColors.primary,
                          );
                        },
                      )
                    : Image.asset(
                        subcategory.iconPath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.fastfood,
                            size: 32.w,
                            color: AppColors.primary,
                          );
                        },
                      ),
              ),
            ),

            SizedBox(height: 8.h),

            // Subcategory title
            Text(
              subcategory.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category title header shimmer
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // Category icon shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Category title shimmer
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 150.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
              // View All button shimmer
              if (onViewAllTap != null)
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 70.w,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Subcategories shimmer laid out using Wrap for consistent compact look
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 8.w;
              final runSpacing = 8.h;
              final crossCount = 3;
              final totalSpacing = spacing * (crossCount - 1);
              final itemWidth =
                  (constraints.maxWidth - totalSpacing) / crossCount;

              return Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: itemWidth,
                    height: itemWidth,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon shimmer
                            Container(
                              width: 56.w,
                              height: 56.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            // Title shimmer
                            Container(
                              width: 60.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),

        // Make shimmer bottom spacing consistent
        SizedBox(height: 6.h),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import '../../data/models/review_model.dart';
import '../../controllers/product_controller.dart';

class ReviewsWidget extends StatelessWidget {
  final double rating;
  final List<ReviewModel> reviews;
  final Map<String, dynamic> ratingDistribution;
  final VoidCallback onSeeAll;
  final VoidCallback onWriteReview;

  const ReviewsWidget({
    super.key,
    required this.rating,
    required this.reviews,
    required this.ratingDistribution,
    required this.onSeeAll,
    required this.onWriteReview,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ratings & Reviews',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.ebonyBlack,
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See All',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ebonyBlack,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Rating summary
        Row(
          children: [
            // Overall rating
            Column(
              children: [
                Text(
                  rating.toString(),
                  style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating.floor() ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 16.sp,
                    );
                  }),
                ),
                SizedBox(height: 4.h),
                Text(
                  '500+ reviews',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(width: 32.w),

            // Rating distribution
            Expanded(
              child: Column(
                children: [
                  for (int i = 5; i >= 1; i--)
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Row(
                        children: [
                          Text(
                            '$i',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: LinearProgressIndicator(
                              value:
                                  (ratingDistribution[i.toString()] ?? 0) / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.beakYellow,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Rating selector for new review
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.homeGrey,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rate this product:',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ebonyBlack,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () =>
                          controller.setUserRating((index + 1).toDouble()),
                      child: Icon(
                        index < controller.userRating.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.orange,
                        size: 24.sp,
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: controller.reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write your review here...",
                  hintStyle: getTextStyle(
                    font: CustomFonts.inter,
                    fontSize: 14.sp,
                    color: AppColors.featherGrey,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(12.w),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 48.h,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onWriteReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Submit Review',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.eggshellWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20.h),

        // Reviews header
        Obx(
          () => reviews.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Reviews (${controller.reviews.length})',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ebonyBlack,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ...controller.reviews.map(
                      (review) => _buildReviewCard(review),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.textWhite, // keep your current bg
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundImage: AssetImage(review.userImage),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              review.userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ebonyBlack,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            review.timeAgo,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 12.sp,
                              color: AppColors.featherGrey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < review.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.orange,
                            size: 12.sp,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            Text(
              review.comment,
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                color: AppColors.ebonyBlack,
                //height: 1.4,
              ),
            ),

            SizedBox(height: 8.h),

            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  'Reply',
                  style: getTextStyle(
                    font: CustomFonts.inter,
                    color: AppColors.ebonyBlack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

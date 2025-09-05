import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/review_model.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ratings & Reviews',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFF6B35),
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
                                Colors.orange,
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

        // Write review button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onWriteReview,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              side: const BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Write A Review',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // Reviews list
        ...reviews.map((review) => _buildReviewItem(review)),
      ],
    );
  }

  Widget _buildReviewItem(ReviewModel review) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
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
                    Text(
                      review.userName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      review.timeAgo,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
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
                SizedBox(height: 8.h),
                Text(
                  review.comment,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Reply',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFF6B35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/orders/data/models/order_model.dart';
import 'package:quikle_user/features/orders/presentation/widgets/order_status_helpers.dart';

class BriefOrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;
  final VoidCallback? onTrack;

  const BriefOrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onTrack,
  });

  /// (removed) previously generated combined name helper

  String _buildMainTitle() {
    if (order.items.isEmpty) return order.orderId;
    final t = order.items.first.product.title.trim();
    return t.isNotEmpty ? t : order.orderId;
  }

  String _buildSubtitle() {
    if (order.items.isEmpty) return '';
    final first = order.items.first;
    final qty = first.quantityDisplay;
    if (order.items.length == 1) {
      final price = first.product.price;
      return '$qty • ${price.isNotEmpty ? price : ''}'.trim();
    }
    return '$qty • +${order.items.length - 1} more';
  }

  Widget _buildThumbnail() {
    if (order.items.isEmpty) {
      return Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.shopping_bag_outlined,
          color: Colors.grey.shade500,
          size: 28.sp,
        ),
      );
    }

    final path = order.items.first.product.imagePath;
    if (path.isEmpty) {
      return Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.image_outlined,
          color: Colors.grey.shade400,
          size: 26.sp,
        ),
      );
    }

    final widget = path.startsWith('http')
        ? Image.network(
            path,
            width: 60.w,
            height: 60.w,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              color: Colors.grey.shade100,
              child: Icon(
                Icons.broken_image,
                color: Colors.grey.shade400,
                size: 26.sp,
              ),
            ),
          )
        : Image.asset(path, width: 60.w, height: 60.w, fit: BoxFit.cover);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(width: 60.w, height: 60.w, child: widget),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: thumbnail + main item info
                Expanded(
                  child: Row(
                    children: [
                      _buildThumbnail(),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _buildMainTitle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getTextStyle(
                                font: CustomFonts.obviously,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ebonyBlack,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              _buildSubtitle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7C7C7C),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              DateFormat(
                                "MMM d, yyyy 'at' h:mm a",
                              ).format(order.orderDate),
                              style: getTextStyle(
                                font: CustomFonts.inter,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9A9A9A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Right: price and item count with fixed width to avoid overlap
                SizedBox(
                  width: 96.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${order.total.toStringAsFixed(2)}',
                        style: getTextStyle(
                          font: CustomFonts.obviously,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${order.items.length} item${order.items.length != 1 ? 's' : ''}',
                        style: getTextStyle(
                          font: CustomFonts.inter,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF7C7C7C),
                        ),
                      ),
                    ],
                  ),
                ),
                // (removed duplicate price column)
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    OrderStatusHelpers.getStatusIcon(order.status),
                    SizedBox(width: 6.w),
                    Text(
                      OrderStatusHelpers.getStatusText(order.status),
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: OrderStatusHelpers.getStatusColor(order.status),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'View Details',
                      style: getTextStyle(
                        font: CustomFonts.inter,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.beakYellow,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10.sp,
                      color: AppColors.beakYellow,
                    ),
                  ],
                ),
              ],
            ),

            if (order.isTrackable) ...[
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                height: 36.h,
                decoration: BoxDecoration(
                  color: AppColors.beakYellow.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.beakYellow, width: 1),
                ),
                child: TextButton(
                  onPressed: onTrack ?? onTap,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    'Track Order',
                    style: getTextStyle(
                      font: CustomFonts.inter,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.beakYellow,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

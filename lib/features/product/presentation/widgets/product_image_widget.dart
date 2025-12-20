import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductImageWidget extends StatelessWidget {
  final String imagePath;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProductImageWidget({
    super.key,
    required this.imagePath,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                imagePath,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.broken_image,
                    size: 48.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16.h,
            right: 16.w,
            child: Row(
              children: [
                GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    padding: EdgeInsets.all(8.sp),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20.sp,
                      color: isFavorite ? Colors.red : Colors.black54,
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

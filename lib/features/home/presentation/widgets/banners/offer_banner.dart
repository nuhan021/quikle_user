import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../data/models/banner_image.dart';

class OfferBanner extends StatelessWidget {
  final List<BannerImage>? images;
  final bool isLoading;

  const OfferBanner({super.key, this.images, this.isLoading = false});

  Widget _buildShimmer(double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bannerHeight = 200.h;
    if (isLoading || images == null) {
      return _buildShimmer(bannerHeight);
    }
    if (images!.isEmpty) {
      return SizedBox(
        height: bannerHeight,
        child: const Center(child: Text('No banners available')),
      );
    }
    return CarouselSlider(
      options: CarouselOptions(
        height: bannerHeight,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        viewportFraction: 1.0,
      ),
      items: images!.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: double.infinity,
                  height: bannerHeight,
                  color: Colors.grey[200],
                  child: Image.network(
                    banner.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildShimmer(bannerHeight);
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

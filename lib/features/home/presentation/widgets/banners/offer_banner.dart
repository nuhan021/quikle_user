import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferBanner extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/offer1.png',
    'assets/images/offer2.png',
    'assets/images/offer3.png',
    'assets/images/offer4.png',
  ];

  @override
  Widget build(BuildContext context) {
    final double bannerHeight = 200.h;

    return CarouselSlider(
      options: CarouselOptions(
        height: bannerHeight,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        viewportFraction: 1.0,
        //aspectRatio: aspectRatio,
      ),
      items: imagePaths.map((path) {
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
                  child: Image.asset(path, fit: BoxFit.cover),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

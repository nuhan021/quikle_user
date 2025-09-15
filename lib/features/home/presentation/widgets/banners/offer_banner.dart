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
    return SizedBox(
      height: 150.h,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150.h,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enlargeCenterPage: true,
          viewportFraction: 1.0,
        ),
        items: imagePaths.map((path) {
          return Builder(
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(path, fit: BoxFit.cover, width: 360.w),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

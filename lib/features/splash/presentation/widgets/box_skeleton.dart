import 'package:flutter/material.dart';

class BoxSkeleton extends StatelessWidget {
  final double width, height, radius;

  const BoxSkeleton({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Container(
      width: width,
      height: height,
      color: const Color(0xFFF8B800),
    ),
  );
}

// lib/routes/app_routes.dart (top of file or separate file you import)
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullscreenBottomIn extends CustomTransition {
  FullscreenBottomIn();

  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOutCubic));

    final fade = Tween<double>(
      begin: 0,
      end: 1,
    ).chain(CurveTween(curve: Curves.easeOutCubic));

    return FadeTransition(
      opacity: animation.drive(fade),
      child: SlideTransition(position: animation.drive(slide), child: child),
    );
  }
}

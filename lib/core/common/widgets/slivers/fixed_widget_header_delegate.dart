import 'dart:ui';
import 'package:flutter/material.dart';

typedef HeaderBuilder =
    Widget Function(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
    );

class FixedWidgetHeaderDelegate extends SliverPersistentHeaderDelegate {
  FixedWidgetHeaderDelegate({
    required double minExtent,
    double? maxExtent,
    required this.builder,
    this.backgroundColor,
    this.shouldAddElevation = false,
    this.enableGlassEffect = false,
    this.blurSigma = 10.0,
  }) : _minExtent = minExtent,
       _maxExtent = maxExtent ?? minExtent;

  final double _minExtent;
  final double _maxExtent;
  final HeaderBuilder builder;
  final Color? backgroundColor;
  final bool shouldAddElevation;
  final bool enableGlassEffect;
  final double blurSigma;

  @override
  double get minExtent => _minExtent;

  @override
  double get maxExtent => _maxExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final Widget child = builder(context, shrinkOffset, overlapsContent);
    final bool showElevation =
        shouldAddElevation && (shrinkOffset > 0 || overlapsContent);

    if (!showElevation && backgroundColor == null && !enableGlassEffect) {
      return child;
    }

    Widget content = child;

    // Add glass effect if enabled
    if (enableGlassEffect) {
      content = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            decoration: BoxDecoration(
              color: (backgroundColor ?? Colors.white).withValues(alpha: 0.7),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: child,
          ),
        ),
      );
    } else {
      content = Material(
        color: backgroundColor ?? Colors.transparent,
        elevation: showElevation ? 4 : 0,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        child: child,
      );
    }

    return content;
  }

  @override
  bool shouldRebuild(covariant FixedWidgetHeaderDelegate oldDelegate) {
    return _minExtent != oldDelegate._minExtent ||
        _maxExtent != oldDelegate._maxExtent ||
        shouldAddElevation != oldDelegate.shouldAddElevation ||
        backgroundColor != oldDelegate.backgroundColor ||
        enableGlassEffect != oldDelegate.enableGlassEffect ||
        blurSigma != oldDelegate.blurSigma ||
        builder != oldDelegate.builder;
  }
}

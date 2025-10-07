import 'package:flutter/material.dart';

typedef HeaderBuilder = Widget Function(
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
  })  : _minExtent = minExtent,
        _maxExtent = maxExtent ?? minExtent;

  final double _minExtent;
  final double _maxExtent;
  final HeaderBuilder builder;
  final Color? backgroundColor;
  final bool shouldAddElevation;

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

    if (!showElevation && backgroundColor == null) {
      return child;
    }

    return Material(
      color: backgroundColor ?? Colors.transparent,
      elevation: showElevation ? 4 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant FixedWidgetHeaderDelegate oldDelegate) {
    return _minExtent != oldDelegate._minExtent ||
        _maxExtent != oldDelegate._maxExtent ||
        shouldAddElevation != oldDelegate.shouldAddElevation ||
        backgroundColor != oldDelegate.backgroundColor ||
        builder != oldDelegate.builder;
  }
}

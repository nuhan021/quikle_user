import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconRowMarquee extends StatefulWidget {
  final List<ImageProvider> images;
  final double boxSize;
  final double gap;
  final double speed;
  final double offsetSlots;
  final bool reverse;

  const IconRowMarquee({
    super.key,
    required this.images,
    this.boxSize = 100,
    this.gap = 12,
    this.speed = 60,
    this.offsetSlots = 0.0,
    this.reverse = false,
  });

  @override
  State<IconRowMarquee> createState() => _IconRowMarqueeState();
}

class _IconRowMarqueeState extends State<IconRowMarquee>
    with SingleTickerProviderStateMixin {
  final ScrollController _sc = ScrollController();
  late final Ticker _ticker;
  double _lastTs = 0;

  late double _slotW;
  late double _itemW;
  late double _spacing;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initPosition());
  }

  void _initPosition() {
    if (!mounted || widget.images.isEmpty) return;
    final base = widget.images.length * 500;
    final startPx = base * _slotW + widget.offsetSlots * _slotW;
    if (_sc.hasClients) {
      _sc.jumpTo(startPx);
    }
  }

  void _onTick(Duration elapsed) {
    if (!mounted || !_sc.hasClients || widget.images.isEmpty) return;
    final t = elapsed.inMicroseconds / 1e6;
    final dt = max(0.0, t - _lastTs);
    _lastTs = t;

    final v = widget.reverse ? -widget.speed : widget.speed;
    double next = _sc.offset + v * dt;
    final period = widget.images.length * _slotW;
    final center = period * 500;
    if ((next - center).abs() > period * 400) {
      next = center + (next - center) % period;
    }

    try {
      _sc.jumpTo(next);
    } catch (_) {}
  }

  @override
  void dispose() {
    _ticker.dispose();
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    _itemW = widget.boxSize.w;
    _spacing = widget.gap.w;
    _slotW = _itemW + _spacing;

    return SizedBox(
      height: _itemW,
      child: ListView.builder(
        controller: _sc,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: _spacing / 2),
        itemExtent: _slotW,
        itemBuilder: (context, index) {
          final img = widget.images[index % widget.images.length];
          return Align(
            alignment: Alignment.centerLeft,
            child: _FigmaBox(image: img, size: _itemW),
          );
        },
        itemCount: widget.images.length * 100000,
      ),
    );
  }
}

class _FigmaBox extends StatelessWidget {
  final ImageProvider image;
  final double size;

  const _FigmaBox({required this.image, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.white.withValues(alpha: 0.25),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Center(
        child: Container(
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            image: DecorationImage(image: image, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

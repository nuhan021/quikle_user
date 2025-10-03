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

  double _slotW = 0;
  double _itemW = 0;
  double _spacing = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _sc.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (!mounted || !_sc.hasClients || widget.images.isEmpty || _slotW <= 0)
      return;

    final t = elapsed.inMicroseconds / 1e6;
    final dt = max(0.0, t - _lastTs);
    _lastTs = t;

    final v = widget.reverse ? -widget.speed : widget.speed;
    double next = _sc.offset + v * dt;

    final period = widget.images.length * _slotW;
    if (period <= 0) return;

    final center = period * 500;
    if ((next - center).abs() > period * 400) {
      next = center + (next - center) % period;
    }

    try {
      _sc.jumpTo(next);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    _itemW = widget.boxSize.w;
    _spacing = widget.gap.w;
    _slotW = _itemW + _spacing;

    final phasePx = ((_slotW > 0) ? (widget.offsetSlots % 1) * _slotW : 0.0);

    final leftPad = widget.reverse ? _spacing / 2 : _spacing / 2 + phasePx;
    final rightPad = widget.reverse ? _spacing / 2 + phasePx : _spacing / 2;

    return SizedBox(
      height: _itemW,
      child: ListView.builder(
        controller: _sc,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(leftPad, 0, rightPad, 0),
        itemExtent: _slotW,
        itemCount: widget.images.length * 100000,
        itemBuilder: (context, index) {
          final img = widget.images[index % widget.images.length];
          return Align(
            alignment: Alignment.centerLeft,
            child: _FigmaBox(image: img, size: _itemW),
          );
        },
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
    final boxHeight = size;

    return Container(
      width: size,
      height: boxHeight,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: .15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image(image: image, fit: BoxFit.cover),
      ),
    );
  }
}

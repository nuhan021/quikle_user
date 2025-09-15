import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CartAnimationController extends GetxController {
  final List<CartAnimation> _activeAnimations = <CartAnimation>[].obs;
  List<CartAnimation> get activeAnimations => _activeAnimations;

  void addAnimation(CartAnimation animation) {
    _activeAnimations.add(animation);
    Future.delayed(animation.duration + const Duration(milliseconds: 150), () {
      _activeAnimations.remove(animation);
    });
  }
}

class CartAnimation {
  final String id;
  final String imagePath;
  final Offset startPosition;
  final Offset endPosition;
  final double startSize;
  final double endSize;
  final Duration duration;
  final DateTime createdAt;

  CartAnimation({
    required this.id,
    required this.imagePath,
    required this.startPosition,
    required this.endPosition,
    required this.startSize,
    required this.endSize,
    this.duration = const Duration(milliseconds: 900),
  }) : createdAt = DateTime.now();
}

class CartAnimationOverlay extends StatelessWidget {
  const CartAnimationOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartAnimationController>();
    return Obx(
      () => Stack(
        children: controller.activeAnimations
            .map((a) => AnimatedCartImage(animation: a))
            .toList(),
      ),
    );
  }
}

class AnimatedCartImage extends StatefulWidget {
  final CartAnimation animation;
  const AnimatedCartImage({super.key, required this.animation});

  @override
  State<AnimatedCartImage> createState() => _AnimatedCartImageState();
}

class _AnimatedCartImageState extends State<AnimatedCartImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _position;
  late Animation<double> _size;
  late Animation<double> _opacity;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animation.duration,
      vsync: this,
    );

    _position =
        Tween<Offset>(
          begin: widget.animation.startPosition,
          end: widget.animation.endPosition,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );

    _size = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: widget.animation.startSize,
          end: widget.animation.startSize * 1.15,
        ),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: widget.animation.startSize * 1.15,
          end: widget.animation.endSize,
        ),
        weight: 75,
      ),
    ]).animate(_controller);

    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 75),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _rotation = Tween(
      begin: 0.0,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final s = _size.value;
        return Positioned(
          left: _position.value.dx - s / 2,
          top: _position.value.dy - s / 2,
          child: Transform.rotate(
            angle: _rotation.value,
            child: Opacity(
              opacity: _opacity.value,
              child: Container(
                width: s,
                height: s,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 12.r,
                      spreadRadius: 2.r,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  widget.animation.imagePath,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CartAnimationWrapper extends StatelessWidget {
  final Widget child;
  const CartAnimationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    try {
      Get.find<CartAnimationController>();
    } catch (_) {
      Get.put(CartAnimationController());
    }
    return Stack(children: [child, const CartAnimationOverlay()]);
  }
}

extension CartAnimationTrigger on Widget {
  void triggerCartAnimation({
    required BuildContext context,
    required String imagePath,
    required GlobalKey sourceKey,
    GlobalKey? targetKey,
  }) {
    final controller = Get.find<CartAnimationController>();

    final RenderBox? sourceBox =
        sourceKey.currentContext?.findRenderObject() as RenderBox?;
    if (sourceBox == null) return;

    final sourceTopLeft = sourceBox.localToGlobal(Offset.zero);
    final sourceCenter = Offset(
      sourceTopLeft.dx + sourceBox.size.width / 2,
      sourceTopLeft.dy + sourceBox.size.height / 2,
    );

    Offset targetCenter;
    if (targetKey != null) {
      final RenderBox? targetBox =
          targetKey.currentContext?.findRenderObject() as RenderBox?;
      if (targetBox != null) {
        final targetTopLeft = targetBox.localToGlobal(Offset.zero);
        targetCenter = Offset(
          targetTopLeft.dx + targetBox.size.width / 2,
          targetTopLeft.dy + targetBox.size.height / 2,
        );
      } else {
        final s = MediaQuery.of(context).size;
        targetCenter = Offset(s.width - 50.w, s.height - 90.h);
      }
    } else {
      final s = MediaQuery.of(context).size;
      targetCenter = Offset(s.width - 50.w, s.height - 90.h);
    }

    final startSize = max(24.0, min(sourceBox.size.shortestSide, 80.0));
    final endSize = 28.w;

    final animation = CartAnimation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: imagePath,
      startPosition: sourceCenter,
      endPosition: targetCenter,
      startSize: startSize,
      endSize: endSize,
    );

    controller.addAnimation(animation);
  }
}

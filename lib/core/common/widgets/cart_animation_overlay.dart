import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/services/cart_position_service.dart';

/// Custom Tween that gets the real-time cart position during animation
class _DynamicPositionTween extends Tween<Offset> {
  final Offset originalEnd;
  static Offset? _cachedCartPosition;
  static DateTime? _lastCacheTime;
  static const Duration _cacheValidDuration = Duration(
    milliseconds: 16,
  ); // ~60fps

  _DynamicPositionTween({required Offset begin, required this.originalEnd})
    : super(begin: begin, end: originalEnd);

  @override
  Offset lerp(double t) {
    // Get the current cart position with caching for performance
    Offset currentEnd = originalEnd;
    final now = DateTime.now();

    // Use cached position if it's recent enough
    if (_cachedCartPosition != null &&
        _lastCacheTime != null &&
        now.difference(_lastCacheTime!) < _cacheValidDuration) {
      currentEnd = _cachedCartPosition!;
    } else {
      // Get fresh position
      try {
        final positionService = Get.find<CartPositionService>();
        final cartPosition = positionService.getCartButtonPosition();
        if (cartPosition != null) {
          currentEnd = cartPosition;
          _cachedCartPosition = cartPosition;
          _lastCacheTime = now;
        }
      } catch (e) {
        // Use original end position if service is not available
      }
    }

    return Offset.lerp(begin!, currentEnd, t)!;
  }
}

class CartAnimationController extends GetxController {
  final List<CartAnimation> _activeAnimations = <CartAnimation>[].obs;
  List<CartAnimation> get activeAnimations => _activeAnimations;

  void addAnimation(CartAnimation animation) {
    _activeAnimations.add(animation);
    Future.delayed(animation.duration + const Duration(milliseconds: 200), () {
      _activeAnimations.remove(animation);
    });
  }

  /// Creates and adds a cart animation with automatic target detection
  void addCartAnimation({
    required String imagePath,
    required Offset startPosition,
    required double startSize,
    Offset? fallbackTarget,
  }) {
    Offset targetPosition;

    // Try to get the actual cart button position
    try {
      final positionService = Get.find<CartPositionService>();
      final cartPosition = positionService.getCartButtonPosition();

      if (cartPosition != null) {
        targetPosition = cartPosition;
      } else {
        // Use fallback position if cart position not available
        targetPosition = fallbackTarget ?? _getDefaultCartPosition();
      }
    } catch (e) {
      // Service not available, use fallback
      targetPosition = fallbackTarget ?? _getDefaultCartPosition();
    }

    final animation = CartAnimation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: imagePath,
      startPosition: startPosition,
      endPosition: targetPosition,
      startSize: startSize,
      endSize: 32.w, // Slightly larger end size for better visibility
      duration: const Duration(
        milliseconds: 1000,
      ), // Slightly longer for smoother animation
    );

    addAnimation(animation);
  }

  Offset _getDefaultCartPosition() {
    // Fallback position when cart button position cannot be determined
    final screenSize = Get.size;
    return Offset(
      screenSize.width - 48.w, // Adjusted for better positioning
      screenSize.height - 120.h, // Adjusted for bottom navigation
    );
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
    this.duration = const Duration(milliseconds: 1000),
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

    // Create a position animation that gets updated position dynamically
    _position =
        _DynamicPositionTween(
          begin: widget.animation.startPosition,
          originalEnd: widget.animation.endPosition,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
        );

    // Improved size animation with bounce effect
    _size = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: widget.animation.startSize,
          end: widget.animation.startSize * 1.2, // Slightly more expansion
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: widget.animation.startSize * 1.2,
          end: widget.animation.startSize * 0.9, // Slight compression
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: widget.animation.startSize * 0.9,
          end: widget.animation.endSize,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    // Smoother opacity animation
    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 80),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 20,
      ),
    ]).animate(_controller);

    // Gentler rotation for more natural movement
    _rotation =
        Tween(
          begin: 0.0,
          end: 0.4, // Reduced rotation for smoother effect
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOutSine, // Smoother rotation curve
          ),
        );

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
        final progress = _controller.value;

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
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    // Dynamic shadow that gets stronger during flight
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.15 + (progress * 0.1),
                      ),
                      blurRadius: 8.r + (progress * 8.r),
                      spreadRadius: 1.r + (progress * 2.r),
                      offset: Offset(0, 4 + (progress * 4)),
                    ),
                    // Additional glow effect
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.3 * progress),
                      blurRadius: 16.r,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // Product image
                    Image.asset(
                      widget.animation.imagePath,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      width: s,
                      height: s,
                    ),
                    // Subtle overlay for better visibility during animation
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.1 * progress),
                          ],
                          stops: const [0.3, 1.0],
                        ),
                      ),
                    ),
                  ],
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

    final startSize = max(28.0, min(sourceBox.size.shortestSide, 80.0));

    // Use the new improved animation method
    controller.addCartAnimation(
      imagePath: imagePath,
      startPosition: sourceCenter,
      startSize: startSize,
      fallbackTarget: Offset(
        MediaQuery.of(context).size.width - 48.w,
        MediaQuery.of(context).size.height - 120.h,
      ),
    );
  }
}

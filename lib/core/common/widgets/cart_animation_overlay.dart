import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class CartAnimationController extends GetxController {
  final List<CartAnimation> _activeAnimations = <CartAnimation>[].obs;

  List<CartAnimation> get activeAnimations => _activeAnimations;

  void addAnimation(CartAnimation animation) {
    _activeAnimations.add(animation);

    // Remove animation after completion
    Future.delayed(animation.duration + const Duration(milliseconds: 100), () {
      _activeAnimations.remove(animation);
    });
  }

  void clearAnimations() {
    _activeAnimations.clear();
  }
}

class CartAnimation {
  final String id;
  final Offset startPosition;
  final Offset endPosition;
  final Duration duration;
  final DateTime createdAt;

  CartAnimation({
    required this.id,
    required this.startPosition,
    required this.endPosition,
    this.duration = const Duration(milliseconds: 800),
  }) : createdAt = DateTime.now();
}

class CartAnimationOverlay extends StatelessWidget {
  const CartAnimationOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final cartAnimationController = Get.find<CartAnimationController>();

    return Obx(() {
      return Stack(
        children: cartAnimationController.activeAnimations
            .map((animation) => AnimatedCartIcon(animation: animation))
            .toList(),
      );
    });
  }
}

class AnimatedCartIcon extends StatefulWidget {
  final CartAnimation animation;

  const AnimatedCartIcon({super.key, required this.animation});

  @override
  State<AnimatedCartIcon> createState() => _AnimatedCartIconState();
}

class _AnimatedCartIconState extends State<AnimatedCartIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animation.duration,
      vsync: this,
    );

    // Create curved position animation
    _positionAnimation =
        Tween<Offset>(
          begin: widget.animation.startPosition,
          end: widget.animation.endPosition,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
        );

    // Scale animation: starts normal, grows a bit, then shrinks
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3),
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 0.8),
        weight: 70.0,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Opacity animation: visible, then fades out at the end
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 70.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 30.0,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Rotation animation: slight rotation during flight
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5, // Half rotation
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start the animation
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
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx - 12.w, // Center the icon
          top: _positionAnimation.value.dy - 12.w,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.3),
                        blurRadius: 8.r,
                        spreadRadius: 2.r,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      ImagePath.cartIcon,
                      width: 16.w,
                      height: 16.w,
                      color: Colors.white,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Helper widget to wrap any screen that needs cart animations
class CartAnimationWrapper extends StatelessWidget {
  final Widget child;

  const CartAnimationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller if not already done
    try {
      Get.find<CartAnimationController>();
    } catch (e) {
      Get.put(CartAnimationController());
    }

    return Stack(children: [child, const CartAnimationOverlay()]);
  }
}

// Extension to make it easy to trigger cart animations
extension CartAnimationTrigger on Widget {
  void triggerCartAnimation({
    required BuildContext context,
    required GlobalKey sourceKey,
    GlobalKey? targetKey,
  }) {
    final cartAnimationController = Get.find<CartAnimationController>();

    // Get source position
    final RenderBox? sourceBox =
        sourceKey.currentContext?.findRenderObject() as RenderBox?;
    if (sourceBox == null) return;

    final sourcePosition = sourceBox.localToGlobal(Offset.zero);
    final sourceCenter = Offset(
      sourcePosition.dx + sourceBox.size.width / 2,
      sourcePosition.dy + sourceBox.size.height / 2,
    );

    // Get target position (floating cart button or custom target)
    Offset targetPosition;
    if (targetKey != null) {
      final RenderBox? targetBox =
          targetKey.currentContext?.findRenderObject() as RenderBox?;
      if (targetBox != null) {
        final targetPos = targetBox.localToGlobal(Offset.zero);
        targetPosition = Offset(
          targetPos.dx + targetBox.size.width / 2,
          targetPos.dy + targetBox.size.height / 2,
        );
      } else {
        // Default to bottom right if target not found
        final screenSize = MediaQuery.of(context).size;
        targetPosition = Offset(
          screenSize.width - 40.w,
          screenSize.height - 100.h,
        );
      }
    } else {
      // Default floating cart position
      final screenSize = MediaQuery.of(context).size;
      targetPosition = Offset(
        screenSize.width - 40.w,
        screenSize.height - 100.h,
      );
    }

    // Create and trigger animation
    final animation = CartAnimation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startPosition: sourceCenter,
      endPosition: targetPosition,
    );

    cartAnimationController.addAnimation(animation);
  }
}

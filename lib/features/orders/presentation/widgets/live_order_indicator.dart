import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/orders/controllers/live_order_controller.dart';

class LiveOrderIndicator extends StatefulWidget {
  final double bottomInset;

  const LiveOrderIndicator({super.key, this.bottomInset = 16.0});

  @override
  State<LiveOrderIndicator> createState() => _LiveOrderIndicatorState();
}

class _LiveOrderIndicatorState extends State<LiveOrderIndicator>
    with TickerProviderStateMixin {
  static const double _boundaryPadding = 16.0;
  final double _outerSize = 80.w;

  late AnimationController _scaleController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _tapFeedback() {
    _scaleController.forward().then((_) => _scaleController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final double systemBottomInset = MediaQuery.of(context).viewPadding.bottom;

    return GetBuilder<LiveOrderController>(
      init: LiveOrderController(),
      builder: (controller) {
        return Obx(() {
          if (!controller.hasLiveOrder) {
            return const SizedBox.shrink();
          }

          final shouldPulse = _shouldShowPulse(controller.statusText);

          return Positioned(
            left: _boundaryPadding,
            bottom: widget.bottomInset + systemBottomInset,
            child: AnimatedBuilder(
              animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
              builder: (context, _) {
                final pulseScale = shouldPulse ? _pulseAnimation.value : 1.0;

                return Transform.scale(
                  scale: _scaleAnimation.value * pulseScale,
                  child: Container(
                    width: _outerSize,
                    height: _outerSize,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          _getStatusColor(
                            controller.statusText,
                          ).withValues(alpha: .05),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getStatusColor(
                            controller.statusText,
                          ).withValues(alpha: .22),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: .85),
                          blurRadius: 10,
                          offset: const Offset(-2, -2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          _tapFeedback();
                          controller.navigateToTracking();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: _outerSize - 18.w,
                              height: _outerSize - 18.w,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    _getStatusColor(
                                      controller.statusText,
                                    ).withValues(alpha: .18),
                                    _getStatusColor(
                                      controller.statusText,
                                    ).withValues(alpha: .06),
                                    Colors.transparent,
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: _outerSize - 28.w,
                              height: _outerSize - 28.w,
                              decoration: BoxDecoration(
                                color: _getStatusColor(controller.statusText),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _getStatusColor(
                                      controller.statusText,
                                    ).withValues(alpha: .32),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _getStatusIcon(controller.statusText),
                                size: 22.sp,
                                color: Colors.white,
                              ),
                            ),
                            if (controller.estimatedTime.isNotEmpty)
                              Positioned(
                                bottom: 6.h,
                                right: 6.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: .75),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    controller.estimatedTime,
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
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
            ),
          );
        });
      },
    );
  }

  bool _shouldShowPulse(String status) {
    return ['preparing', 'on the way'].contains(status.toLowerCase());
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'order confirmed':
        return const Color(0xFF2196F3);
      case 'preparing':
        return const Color(0xFFF57C00);
      case 'ready for pickup':
        return const Color(0xFF9C27B0);
      case 'on the way':
        return const Color(0xFF4CAF50);
      case 'delivered':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFF757575);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'order confirmed':
        return Icons.check_circle;
      case 'preparing':
        return Icons.restaurant;
      case 'ready for pickup':
        return Icons.done_all;
      case 'on the way':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.home;
      default:
        return Icons.info;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/orders/controllers/live_order_controller.dart';

class LiveOrderIndicator extends StatefulWidget {
  const LiveOrderIndicator({super.key});

  @override
  State<LiveOrderIndicator> createState() => _LiveOrderIndicatorState();
}

class _LiveOrderIndicatorState extends State<LiveOrderIndicator>
    with TickerProviderStateMixin {
  static const double _boundaryPadding = 16.0;
  final double _outerSize = 80.w;
  final double _ringStroke = 3.5.w;

  Offset _position = Offset(20.w, 100.h);

  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

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

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final bottomInset = MediaQuery.of(context).padding.bottom;

      final navGap = 100.h;
      final dx = _boundaryPadding;
      final dy =
          size.height - navGap - _outerSize - _boundaryPadding - bottomInset;

      setState(() {
        _position = Offset(dx, dy);
      });
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Offset _getConstrainedPosition(Offset newPosition, Size screenSize) {
    final currentWidth = _outerSize;
    final currentHeight = _outerSize;

    return Offset(
      newPosition.dx.clamp(
        _boundaryPadding,
        screenSize.width - currentWidth - _boundaryPadding,
      ),
      newPosition.dy.clamp(
        _boundaryPadding + MediaQuery.of(context).padding.top,
        screenSize.height - currentHeight - _boundaryPadding - 100.h,
      ),
    );
  }

  void _tapFeedback() {
    _scaleController.forward().then((_) => _scaleController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveOrderController>(
      init: LiveOrderController(),
      builder: (controller) {
        return Obx(() {
          if (!controller.hasLiveOrder) {
            return const SizedBox.shrink();
          }

          final shouldPulse = _shouldShowPulse(controller.statusText);

          return Positioned(
            left: _position.dx,
            top: _position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  final newPosition = Offset(
                    _position.dx + details.delta.dx,
                    _position.dy + details.delta.dy,
                  );
                  _position = _getConstrainedPosition(
                    newPosition,
                    MediaQuery.of(context).size,
                  );
                });
              },
              onPanEnd: (_) {
                setState(() {
                  _position = _getConstrainedPosition(
                    _position,
                    MediaQuery.of(context).size,
                  );
                });
              },
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _scaleAnimation,
                  _pulseAnimation,
                  _shimmerAnimation,
                ]),
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
                              SizedBox(
                                width: (_outerSize - 4.w),
                                height: (_outerSize - 4.w),
                                child: CircularProgressIndicator(
                                  value: null,
                                  backgroundColor: Colors.grey[100],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.lerp(
                                      _getStatusColor(controller.statusText),
                                      _getStatusColor(
                                        controller.statusText,
                                      ).withValues(alpha: .35),
                                      _shimmerAnimation.value,
                                    )!,
                                  ),
                                  strokeWidth: _ringStroke,
                                  strokeCap: StrokeCap.round,
                                ),
                              ),

                              Container(
                                width: (_outerSize - 18.w),
                                height: (_outerSize - 18.w),
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
                                width: (_outerSize - 28.w),
                                height: (_outerSize - 28.w),
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
                                      color: Colors.black.withValues(
                                        alpha: .75,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: .12,
                                          ),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
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

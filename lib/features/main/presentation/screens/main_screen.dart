import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/custom_navbar.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/features/home/presentation/screens/home_content_screen.dart';
import 'package:quikle_user/features/orders/presentation/screens/orders_screen.dart';
import 'package:quikle_user/features/categories/presentation/screens/categories_screen.dart';
import 'package:quikle_user/features/profile/presentation/screens/profile_screen.dart';
import 'package:quikle_user/features/orders/presentation/widgets/live_order_indicator.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late int _currentIndex;
  late final AnimationController _navController;
  Timer? _scrollDebounce;
  final GlobalKey _navKey = GlobalKey();
  double _navBarHeight = 0.0;

  static const double _hideDistance = 28.0;
  static const double _showDistance = 44.0;
  static const double _minDelta = 1.2;
  static const int _debounceMs = 320;
  static const int _coolDownMS = 350;
  final Duration _hideDur = const Duration(milliseconds: 360);
  final Duration _showDur = const Duration(milliseconds: 420);
  final Curve _hideCurve = Curves.easeInCubic;
  final Curve _showCurve = Curves.easeOutCubic;

  double _cumDown = 0.0;
  double _cumUp = 0.0;
  DateTime? _lastToggleAt;

  final List<Widget> _screens = const [
    HomeContentScreen(),
    OrdersScreen(),
    CategoriesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    _navController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    setState(() => _currentIndex = index);
    _showNav();
  }

  void _animateTo(double v, Duration d, Curve c, bool animated) {
    if (animated) {
      _navController.animateTo(v, duration: d, curve: c);
    } else {
      _navController.value = v;
    }
    _lastToggleAt = DateTime.now();
  }

  bool _canToggle() {
    if (_lastToggleAt == null) return true;
    return DateTime.now().difference(_lastToggleAt!) >
        Duration(milliseconds: _coolDownMS);
  }

  void _showNav({bool animated = true}) {
    if (_navController.value == 1.0) return;
    _animateTo(1.0, _showDur, _showCurve, animated);
  }

  void _hideNav({bool animated = true}) {
    if (_navController.value == 0.0) return;
    _animateTo(0.0, _hideDur, _hideCurve, animated);
  }

  void _measureNavBarHeight() {
    final ctx = _navKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final h = box.size.height;
    if (h > 0 && (h - _navBarHeight).abs() > 0.5) {
      setState(() => _navBarHeight = h);
    }
  }

  bool _onScrollNotification(ScrollNotification n) {
    if (n.depth != 0 || n.metrics.axis != Axis.vertical) return false;

    if (n is ScrollUpdateNotification) {
      final delta = n.scrollDelta ?? 0.0;
      if (delta.abs() < _minDelta) return false;

      if (delta > 0) {
        _cumDown += delta;
        _cumUp = 0;
        if (_cumDown >= _hideDistance && _canToggle()) {
          _hideNav();
          _cumDown = 0;
        }
      } else {
        _cumUp += -delta;
        _cumDown = 0;
        if (_cumUp >= _showDistance && _canToggle()) {
          _showNav();
          _cumUp = 0;
        }
      }

      _scrollDebounce?.cancel();
      _scrollDebounce = Timer(const Duration(milliseconds: _debounceMs), () {
        if (mounted) _showNav();
      });
    }

    if (n is ScrollEndNotification) {
      _scrollDebounce?.cancel();
      _scrollDebounce = Timer(const Duration(milliseconds: _debounceMs), () {
        if (mounted) _showNav();
      });
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavBarHeight());
    //const double cartMargin = 16.0;

    return CartAnimationWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _navController,
                builder: (context, _) {
                  return IndexedStack(index: _currentIndex, children: _screens);
                },
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  ignoring: _navController.value < 0.01,
                  child: AnimatedBuilder(
                    animation: _navController,
                    builder: (context, child) {
                      final dy = 1.0 - _navController.value;
                      return Transform.translate(
                        offset: Offset(0, dy * _navBarHeight),
                        child: Opacity(
                          opacity: _navController.value.clamp(0.0, 1.0),
                          child: child,
                        ),
                      );
                    },
                    child: KeyedSubtree(
                      key: _navKey,
                      child: CustomNavBar(
                        currentIndex: _currentIndex,
                        onTap: _onNavItemTapped,
                      ),
                    ),
                  ),
                ),
              ),

              AnimatedBuilder(
                animation: _navController,
                builder: (context, _) {
                  final inset = (_navController.value * _navBarHeight);
                  return FloatingCartButton(bottomInset: inset);
                },
              ),

              AnimatedBuilder(
                animation: _navController,
                builder: (context, _) {
                  final inset = (_navController.value * _navBarHeight);
                  return LiveOrderIndicator(bottomInset: inset);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

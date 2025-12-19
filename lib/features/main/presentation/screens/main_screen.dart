import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final GlobalKey _navKey = GlobalKey();
  double _navBarHeight = 0.0;

  final List<Widget> _screens = [
    const HomeContentScreen(),
    const OrdersScreen(),
    const CategoriesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _navController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    setState(() => _currentIndex = index);
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

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse &&
          _navController.value != 0.0 &&
          _navController.status != AnimationStatus.reverse) {
        _navController.reverse();
      } else if (notification.direction == ScrollDirection.forward &&
          _navController.value != 1.0 &&
          _navController.status != AnimationStatus.forward) {
        _navController.forward();
      } else if (notification.direction == ScrollDirection.idle) {
        if (_navController.value != 1.0) {
          _navController.forward();
        }
      }
    }
    if (notification is ScrollEndNotification) {
      if (_navController.value != 1.0) {
        _navController.forward();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavBarHeight());

    return CartAnimationWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: Stack(
            children: [
              IndexedStack(index: _currentIndex, children: _screens),

              // ✅ Fixed Bottom Navbar
              Positioned(
                left: 0,
                right: 0,
                // keep the nav bar above any system bottom inset (navigation bar / gesture area)
                bottom: MediaQuery.of(context).viewPadding.bottom,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 180),
                  offset: const Offset(0, 0),
                  child: SizeTransition(
                    axisAlignment: 1.0,
                    sizeFactor: _navController,
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
                  // account for system bottom areas (navigation bar, gesture area) and keyboard
                  final systemInset = MediaQuery.of(context).viewPadding.bottom;
                  final keyboardInset = MediaQuery.of(
                    context,
                  ).viewInsets.bottom;
                  // take the larger of system inset and keyboard inset so we don't double-count
                  final bottomInset =
                      inset +
                      (systemInset > keyboardInset
                          ? systemInset
                          : keyboardInset);
                  return FloatingCartButton(bottomInset: bottomInset);
                },
              ),

              AnimatedBuilder(
                animation: _navController,
                builder: (context, _) {
                  final inset = (_navController.value * _navBarHeight);
                  final systemInset = MediaQuery.of(context).viewPadding.bottom;
                  final keyboardInset = MediaQuery.of(
                    context,
                  ).viewInsets.bottom;
                  final bottomInset =
                      inset +
                      (systemInset > keyboardInset
                          ? systemInset
                          : keyboardInset);
                  return LiveOrderIndicator(bottomInset: bottomInset);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

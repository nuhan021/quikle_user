import 'package:flutter/material.dart';
import 'package:quikle_user/core/common/widgets/cart_animation_overlay.dart';
import 'package:quikle_user/core/common/widgets/custom_navbar.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/features/home/presentation/screens/home_content_screen.dart';
import 'package:quikle_user/features/orders/presentation/screens/orders_screen.dart';
import 'package:quikle_user/features/categories/presentation/screens/categories_screen.dart';
import 'package:quikle_user/features/profile/presentation/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [
    HomeContentScreen(),
    OrdersScreen(),
    CategoriesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CartAnimationWrapper(
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(index: _currentIndex, children: _screens),
            const FloatingCartButton(),
          ],
        ),
        bottomNavigationBar: CustomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavItemTapped,
        ),
        backgroundColor: const Color(0xFFF0F0F0),
      ),
    );
  }
}

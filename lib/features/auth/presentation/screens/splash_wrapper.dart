import 'package:flutter/material.dart';
import 'package:quikle_user/features/auth/presentation/screens/welcome_screen.dart';
import 'package:quikle_user/features/main/presentation/screens/main_screen.dart';

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showWelcome = true;

  void _removeWelcome() {
    setState(() {
      _showWelcome = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const MainScreen(),
        if (_showWelcome) WelcomeScreen(onFinish: _removeWelcome),
      ],
    );
  }
}

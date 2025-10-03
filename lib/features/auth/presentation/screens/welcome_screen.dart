import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const WelcomeScreen({super.key, required this.onFinish});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnim = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    _controller =
        VideoPlayerController.asset("assets/videos/welcome_screen.mp4")
          ..initialize().then((_) {
            setState(() {});
            _controller.play();

            Future.delayed(const Duration(seconds: 3), () async {
              if (mounted) {
                await _fadeController.forward();
                if (mounted)
                  widget.onFinish(); // ✅ tell SplashWrapper to hide it
              }
            });
          });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0).animate(_fadeController),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 50.0, end: 0.0),
            duration: const Duration(seconds: 6),
            curve: Curves.easeOutCubic,
            builder: (context, blurValue, child) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurValue,
                      sigmaY: blurValue,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: .4),
                            Colors.black.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: AnimatedOpacity(
                        opacity: _controller.value.isInitialized ? 1 : 0,
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
                          width: 160.w,
                          height: 160.w,
                          child: _controller.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: VideoPlayer(_controller),
                                  ),
                                )
                              : const CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

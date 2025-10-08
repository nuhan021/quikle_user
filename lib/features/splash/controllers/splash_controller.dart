import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../auth/presentation/screens/login_screen.dart';

class SplashController extends GetxController {
  late final VideoPlayerController video;
  final RxBool isReady = false.obs;
  final RxBool shouldShrink = false.obs; // New: controls video shrinking

  static const double _ellipseTopIdle = 812.0;
  static const double _ellipseTopPlaying = 666.0;
  final RxDouble ellipseTop = _ellipseTopIdle.obs;
  final RxBool showEllipse = false.obs;
  final RxBool showLogin = false.obs;

  final Duration shrinkTriggerAt = const Duration(milliseconds: 200);
  final Duration ellipseTriggerAt = const Duration(seconds: 2);
  final Duration playDuration = const Duration(seconds: 3);
  bool _ellipseMoved = false;
  bool _videoShrunk = false; // Track if video has shrunk

  @override
  void onInit() {
    super.onInit();
    _initVideo();
  }

  Future<void> _initVideo() async {
    video = VideoPlayerController.asset('assets/videos/splash_intro.mp4');
    await video.initialize();
    // await video.setPlaybackSpeed(0.1);
    await video.setVolume(0);
    await video.play();
    isReady.value = true;
    video.addListener(_videoShrinkWatcher); // Watch for video shrink trigger
    video.addListener(_progressWatcher);
    video.addListener(_listenDuration);
  }

  void _videoShrinkWatcher() {
    final v = video.value;
    if (!_videoShrunk && v.isInitialized && v.position >= shrinkTriggerAt) {
      _videoShrunk = true;
      shouldShrink.value = true; // Trigger smooth shrink animation
      video.removeListener(_videoShrinkWatcher);
    }
  }

  void _progressWatcher() {
    final v = video.value;
    if (!_ellipseMoved && v.isInitialized && v.position >= ellipseTriggerAt) {
      _ellipseMoved = true;
      startEllipseAnimation();
      video.removeListener(_progressWatcher);
    }
  }

  void startEllipseAnimation() {
    showEllipse.value = true;
    ellipseTop.value = _ellipseTopPlaying;
  }

  void _listenDuration() {
    final v = video.value;
    if (v.isInitialized && v.position >= playDuration) {
      video.pause();
      // showLogin.value = true;
      Get.off(() => const LoginScreen());
      video.removeListener(_listenDuration);
    }
  }

  @override
  void onClose() {
    video.removeListener(_videoShrinkWatcher);
    video.removeListener(_progressWatcher);
    video.removeListener(_listenDuration);
    video.dispose();
    super.onClose();
  }
}

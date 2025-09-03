import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:quikle_user/routes/app_routes.dart';

class SplashController extends GetxController {
  late final VideoPlayerController video;
  final RxBool isReady = false.obs;

  static const double _ellipseTopIdle = 812.0;
  static const double _ellipseTopPlaying = 666.0;
  final RxDouble ellipseTop = _ellipseTopIdle.obs;
  final RxBool showLogin = false.obs;

  final Duration ellipseTriggerAt = const Duration(seconds: 2);
  bool _ellipseMoved = false;

  @override
  void onInit() {
    super.onInit();
    _initVideo();
  }

  Future<void> _initVideo() async {
    video = VideoPlayerController.asset('assets/videos/splash_intro.mp4');
    await video.initialize();
    await video.setVolume(0);
    await video.play();
    isReady.value = true;
    video.addListener(_progressWatcher);
    video.addListener(_listenEnd);
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
    ellipseTop.value = _ellipseTopPlaying;
  }

  void _listenEnd() {
    final v = video.value;
    if (v.isInitialized && v.position >= v.duration && !v.isPlaying) {
      showLogin.value = true;
      // Remove: Get.offAllNamed(AppRoute.getLoginScreen());
    }
  }

  @override
  void onClose() {
    video.removeListener(_progressWatcher);
    video.removeListener(_listenEnd);
    video.dispose();
    super.onClose();
  }
}

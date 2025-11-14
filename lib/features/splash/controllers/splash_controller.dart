import 'dart:async';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/no_internet_screen.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:video_player/video_player.dart';
import '../../../core/services/network_controller.dart';
import '../../auth/presentation/screens/login_screen.dart';

class SplashController extends GetxController {
  final networkController = Get.find<NetworkController>();
  late final VideoPlayerController video;
  final RxBool isReady = false.obs;
  final RxBool shouldShrink = false.obs;

  static const double _ellipseTopFinal = 666.0;
  final RxDouble ellipseTop = _ellipseTopFinal.obs;

  final RxBool showEllipse = false.obs;
  final RxBool showLogin = false.obs;

  final Duration shrinkDelay = const Duration(milliseconds: 20);
  final Duration ellipseTriggerAt = const Duration(seconds: 2);
  final Duration playDuration = const Duration(seconds: 3);

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

    Future.delayed(shrinkDelay, () {
      shouldShrink.value = true;
    });

    video.addListener(_progressWatcher);
    video.addListener(_listenDuration);
  }

  void _progressWatcher() {
    final v = video.value;
    if (!_ellipseMoved && v.isInitialized && v.position >= ellipseTriggerAt) {
      _ellipseMoved = true;
      showEllipse.value = true;
      video.removeListener(_progressWatcher);
    }
  }

  void _listenDuration() async {
    final v = video.value;
    if (v.isInitialized && v.position >= playDuration) {
      video.pause();
      video.removeListener(_listenDuration);

      AppLoggerHelper.debug(
        'Checking network status from SplashController: ${networkController.hasConnection.value}',
      );

      if (networkController.hasConnection.value) {
        Get.off(() => const LoginScreen());
      } else {
        Get.off(() => const NoInternetScreen());
      }
    }
  }

  @override
  void onClose() {
    video.removeListener(_progressWatcher);
    video.removeListener(_listenDuration);
    video.dispose();
    super.onClose();
  }
}

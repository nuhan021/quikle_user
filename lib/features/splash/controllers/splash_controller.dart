import 'dart:async';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/widgets/no_internet_screen.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/features/home/data/services/home_services.dart';
import 'package:quikle_user/core/services/global_prefetch_service.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/auth/presentation/screens/splash_wrapper.dart';
import 'package:video_player/video_player.dart';
import '../../../core/services/network_controller.dart';
import '../../auth/presentation/screens/login_screen.dart';

class SplashController extends GetxController {
  final networkController = Get.find<NetworkController>();
  late final VideoPlayerController video;
  final RxBool isReady = false.obs;
  final RxBool shouldShrink = false.obs;

  // Ellipse top will be provided by the view after layout is available.
  final RxDouble ellipseTop = 0.0.obs;

  final RxBool showEllipse = false.obs;
  final RxBool showLogin = false.obs;

  final Duration shrinkDelay = const Duration(milliseconds: 20);
  final Duration ellipseTriggerAt = const Duration(seconds: 2);
  final Duration playDuration = const Duration(seconds: 3);

  bool _ellipseMoved = false;

  @override
  void onInit() {
    super.onInit();
    // Do NOT access Get.height here — GetMaterialApp / window may not be
    // available yet which causes a null-check crash. The view will compute
    // and pass a proper value after first layout.
    _initVideo();
  }

  /// Set the final top position for the ellipse. This should be called by
  /// the view after layout (for example from a post-frame callback) so
  /// we don't access window dimensions too early.
  void setEllipseTop(double value) {
    ellipseTop.value = value;
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

      if (!networkController.hasConnection.value) {
        Get.off(() => const NoInternetScreen());
        return;
      }

      try {
        final homeService = HomeService();
        final categories = await homeService.fetchCategories();
        for (final cat in categories) {
          // skip 'All' pseudo-category
          if (cat.id == '0') continue;
          // Enqueue full prefetch regardless of network type per user request
          GlobalPrefetchService.instance.enqueueCategory(cat.id, full: true);
        }
      } catch (_) {}

      // Check if user is already logged in
      final bool hasToken = StorageService.hasToken();
      AppLoggerHelper.debug('User has token: $hasToken');

      if (hasToken) {
        // User is logged in, navigate to home screen
        Get.offAll(() => const SplashWrapper());
      } else {
        // User is not logged in, navigate to login screen
        Get.off(() => const LoginScreen());
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

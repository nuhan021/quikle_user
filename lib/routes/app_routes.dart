import 'package:get/get.dart';
import 'package:quikle_user/features/splash/presentation/screens/splash_screen.dart';

class AppRoute {
  static String splashScreen = "/";
  static String loginScreen = "/loginScreen";

  static String getLoginScreen() => loginScreen;
  static String getSplashScreen() => splashScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
  ];
}

import 'package:get/get.dart';
import 'package:quikle_user/features/auth/presentation/screens/resgiter_screen.dart';
import 'package:quikle_user/features/auth/presentation/screens/verification_scree.dart';
import 'package:quikle_user/features/auth/presentation/screens/welcome_screen.dart';
import 'package:quikle_user/features/main/presentation/screens/main_screen.dart';
import 'package:quikle_user/features/splash/presentation/screens/splash_screen.dart';
import 'package:quikle_user/features/auth/presentation/screens/login_screen.dart';
import 'package:quikle_user/features/cart/presentation/screens/cart_screen.dart';

class AppRoute {
  static const String _splash = '/';
  static const String _login = '/login';
  static const String _register = '/register';
  static const String _verify = '/verify';
  static const String _welcome = '/welcome';
  static const String _home = '/home';
  static const String _main = '/main';
  static const String _cart = '/cart';

  static String getSplashScreen() => _splash;
  static String getLoginScreen() => _login;
  static String getRegister() => _register;
  static String getVerify() => _verify;
  static String getHome() => _home;
  static String getMain() => _main;
  static String getWelcome() => _welcome;
  static String getCart() => _cart;

  static final List<GetPage<dynamic>> routes = <GetPage>[
    GetPage(name: _splash, page: () => const SplashScreen()),
    GetPage(name: _login, page: () => const LoginScreen()),
    GetPage(name: _register, page: () => const RegisterScreen()),
    GetPage(name: _verify, page: () => const VerificationScreen()),
    GetPage(name: _welcome, page: () => const WelcomeScreen()),
    GetPage(name: _home, page: () => const MainScreen()),
    GetPage(name: _main, page: () => const MainScreen()),
    GetPage(name: _cart, page: () => const CartScreen()),

    // GetPage(
    //   name: _home,
    //   page: () => const _PlaceholderHome(),
    // ),
  ];
}

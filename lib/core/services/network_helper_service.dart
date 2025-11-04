import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  static Future<bool> hasNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}

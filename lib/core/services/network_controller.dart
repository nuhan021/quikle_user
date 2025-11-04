import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

class NetworkController extends GetxController {
  final hasConnection = true.obs;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivityMonitoring();
  }

  void _initConnectivityMonitoring() {
    final connectivity = Connectivity();

    // Listen to connectivity changes
    _connectivitySubscription = connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );

    // Check initial connectivity state
    connectivity
        .checkConnectivity()
        .then(_updateConnectionStatus)
        .catchError((_) => hasConnection.value = true);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) async {
    // Step 1: Check if any interface is available
    final isConnected = results.any(
      (result) => result != ConnectivityResult.none,
    );

    // Step 2: Verify actual internet access if connected
    bool hasInternet = false;
    if (isConnected) {
      try {
        final lookup = await InternetAddress.lookup(
          'example.com',
        ).timeout(const Duration(seconds: 3));
        hasInternet = lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
      } catch (_) {
        hasInternet = false;
      }
    }

    // Step 3: Update reactive state
    final previousState = hasConnection.value;
    hasConnection.value = hasInternet;

    // Optional: Trigger something when connection restores
    if (hasInternet && !previousState) {
      // Example: You can refresh some data here if needed
      // fetchDashboardData();
    }
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}

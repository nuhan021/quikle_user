import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/search/controllers/search_controller.dart';
import 'package:quikle_user/routes/app_routes.dart';

/// Mixin to provide voice search functionality to any controller
mixin VoiceSearchMixin on GetxController {
  ProductSearchController? _searchController;

  /// Gets or creates a ProductSearchController instance
  ProductSearchController get searchController {
    if (_searchController == null) {
      try {
        _searchController = Get.find<ProductSearchController>();
      } catch (e) {
        _searchController = Get.put(ProductSearchController());
      }
    }
    return _searchController!;
  }

  /// Starts voice search and handles the completion
  /// If [navigateToSearch] is true, it will navigate to search page after completion
  /// If [onCompleted] is provided, it will call that callback instead of navigating
  Future<void> startVoiceSearch({
    bool navigateToSearch = true,
    Function(String recognizedText)? onCompleted,
  }) async {
    try {
      // Set up the completion callback
      searchController.onVoiceSearchCompleted = (String recognizedText) {
        if (onCompleted != null) {
          onCompleted(recognizedText);
        } else if (navigateToSearch) {
          Get.toNamed(AppRoute.getSearch());
        }
      };

      // Start voice recognition
      await searchController.toggleVoiceRecognition();
    } catch (e) {
      debugPrint('Error in voice search: $e');
      Get.snackbar(
        'Voice Search Error',
        'An error occurred while starting voice search.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Returns true if voice search is currently listening
  bool get isListening => searchController.isListening;

  /// Returns the current sound level (0.0 to 1.0)
  double get soundLevel => searchController.soundLevel.value;

  /// Stops voice recognition
  Future<void> stopVoiceSearch() async {
    if (isListening) {
      await searchController.toggleVoiceRecognition();
    }
  }
}

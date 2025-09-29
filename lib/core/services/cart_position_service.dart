import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPositionService extends GetxController {
  GlobalKey? _cartButtonKey;
  Offset? _lastKnownPosition;

  void setCartButtonKey(GlobalKey key) {
    _cartButtonKey = key;
    // Clear cached position when key changes
    _lastKnownPosition = null;
  }

  Offset? getCartButtonPosition() {
    if (_cartButtonKey?.currentContext == null) return _lastKnownPosition;

    try {
      final RenderBox? renderBox =
          _cartButtonKey!.currentContext!.findRenderObject() as RenderBox?;

      if (renderBox == null) return _lastKnownPosition;

      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      // Calculate center position of the cart button
      final centerPosition = Offset(
        position.dx + size.width / 2,
        position.dy + size.height / 2,
      );

      // Cache the position for performance
      _lastKnownPosition = centerPosition;
      return centerPosition;
    } catch (e) {
      // Return last known position if there's an error
      return _lastKnownPosition;
    }
  }

  bool hasCartButton() => _cartButtonKey?.currentContext != null;

  void invalidatePosition() {
    _lastKnownPosition = null;
  }
}

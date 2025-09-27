import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPositionService extends GetxController {
  GlobalKey? _cartButtonKey;

  void setCartButtonKey(GlobalKey key) {
    _cartButtonKey = key;
  }

  Offset? getCartButtonPosition() {
    if (_cartButtonKey?.currentContext == null) return null;

    final RenderBox? renderBox =
        _cartButtonKey!.currentContext!.findRenderObject() as RenderBox?;

    if (renderBox == null) return null;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Return center position of the cart button
    return Offset(position.dx + size.width / 2, position.dy + size.height / 2);
  }

  bool hasCartButton() => _cartButtonKey?.currentContext != null;
}

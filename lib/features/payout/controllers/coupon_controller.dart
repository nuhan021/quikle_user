import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:quikle_user/features/payout/data/services/payout_service.dart';
import '../../cart/controllers/cart_controller.dart';

class CouponController extends GetxController {
  final PayoutService _payoutService = PayoutService();
  final _cartController = Get.find<CartController>();

  final _couponCode = ''.obs;
  final _appliedCoupon = Rxn<Map<String, dynamic>>();
  final _availableCoupons = <Map<String, dynamic>>[].obs;
  final _couponController = TextEditingController();

  String get couponCode => _couponCode.value;
  Map<String, dynamic>? get appliedCoupon => _appliedCoupon.value;
  List<Map<String, dynamic>> get availableCoupons => _availableCoupons;
  TextEditingController get couponController => _couponController;

  double get subtotal => _cartController.totalAmount;

  bool get canApplyCoupon => _couponCode.value.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _couponController.addListener(_syncCouponText);
    fetchAndApplyBestCoupon();
  }

  @override
  void onClose() {
    _couponController.removeListener(_syncCouponText);
    _couponController.dispose();
    super.onClose();
  }

  void _syncCouponText() {
    _couponCode.value = _couponController.text;
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  Future<void> fetchAndApplyBestCoupon() async {
    try {
      final coupons = await _payoutService.fetchCoupons();
      _availableCoupons.value = coupons;

      if (coupons.isEmpty) return;

      double bestSavings = 0.0;
      Map<String, dynamic>? bestCoupon;

      for (final c in coupons) {
        final base = subtotal;
        final minRequired = c.containsKey('up_to')
            ? _toDouble(c['up_to'])
            : 0.0;
        if (minRequired > 0 && base < minRequired) continue;

        final savings = _calculateCouponSavings(c, base);
        if (savings > bestSavings) {
          bestSavings = savings;
          bestCoupon = c;
        }
      }

      if (bestCoupon != null && bestSavings > 0) {
        _appliedCoupon.value = {
          ...bestCoupon,
          'isValid': true,
          'calculatedSavings': bestSavings,
          'message': bestCoupon['description'] ?? 'Coupon applied',
        };
        final code = bestCoupon['cupon'] ?? bestCoupon['coupon'] ?? '';
        _couponController.text = code;
        _couponCode.value = code;
      }
    } catch (e) {
      // ignore for now
    }
  }

  void applyCouponLocally(Map<String, dynamic> coupon) {
    _appliedCoupon.value = {
      ...coupon,
      'isValid': true,
      'message': coupon['description'] ?? 'Coupon applied',
    };
    final code = coupon['cupon'] ?? coupon['coupon'] ?? '';
    _couponController.text = code;
    _couponCode.value = code;
  }

  bool isCouponApplicable(Map<String, dynamic> coupon) {
    final base = subtotal;
    if (coupon.containsKey('up_to')) {
      final minRequired = _toDouble(coupon['up_to']);
      if (minRequired > 0 && base < minRequired) return false;
    }
    return true;
  }

  double estimateSavings(Map<String, dynamic> coupon) {
    if (!isCouponApplicable(coupon)) return 0.0;
    return _calculateCouponSavings(coupon, subtotal);
  }

  double _calculateCouponSavings(Map<String, dynamic> coupon, double base) {
    try {
      if (base <= 0) return 0.0;

      if (coupon.containsKey('discountType') &&
          coupon.containsKey('discountValue')) {
        final String type = coupon['discountType']?.toString() ?? '';
        final double value = (coupon['discountValue'] is num)
            ? (coupon['discountValue'] as num).toDouble()
            : double.tryParse(coupon['discountValue']?.toString() ?? '') ?? 0.0;

        if (type == 'percentage') {
          double raw = base * (value / 100.0);
          final cap = coupon['max_value'] ?? coupon['max'] ?? coupon['cap'];
          if (cap != null) {
            final double capVal = _toDouble(cap);
            return raw > capVal ? capVal : raw;
          }
          return raw;
        } else if (type == 'fixed') {
          final double fixed = value;
          return fixed > base ? base : fixed;
        }
      }

      if (coupon.containsKey('discount')) {
        final double discount = _toDouble(coupon['discount']);
        double raw = base * (discount / 100.0);
        final cap = coupon['max_value'] ?? coupon['max'] ?? coupon['cap'];
        if (cap != null) {
          final double capVal = _toDouble(cap);
          return raw > capVal ? capVal : raw;
        }
        return raw;
      }

      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  double get discountAmount {
    final coupon = appliedCoupon;
    if (coupon == null || coupon['isValid'] != true) return 0.0;
    final base = subtotal;
    if (base <= 0) return 0.0;

    try {
      if (coupon.containsKey('discountType') &&
          coupon.containsKey('discountValue')) {
        final String discountType = coupon['discountType']?.toString() ?? '';
        final double discountValue = _toDouble(coupon['discountValue']);

        double discount = 0.0;
        switch (discountType) {
          case 'percentage':
            discount = base * (discountValue / 100.0);
            break;
          case 'fixed':
            discount = discountValue;
            break;
          default:
            discount = 0.0;
        }
        if (discount > base) discount = base;
        return discount;
      }

      if (coupon.containsKey('discount')) {
        final double discountPercent = _toDouble(coupon['discount']);
        double discount = base * (discountPercent / 100.0);
        final cap = coupon['max_value'] ?? coupon['up_to'];
        if (cap != null) {
          final capVal = _toDouble(cap);
          if (discount > capVal) discount = capVal;
        }
        if (discount > base) discount = base;
        return discount;
      }

      if (coupon.containsKey('discountValue')) {
        final double val = _toDouble(coupon['discountValue']);
        return val > base ? base : val;
      }
    } catch (e) {
      // ignore
    }

    return 0.0;
  }
}

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
  // Expose the underlying reactive applied-coupon so UI can observe
  // changes directly via `Obx(() => ...)` when needed.
  Rxn<Map<String, dynamic>> get appliedCouponRx => _appliedCoupon;
  List<Map<String, dynamic>> get availableCoupons => _availableCoupons;
  TextEditingController get couponController => _couponController;

  double get subtotal => _cartController.totalAmount;

  bool get canApplyCoupon => _couponCode.value.trim().isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    print('🎯 CouponController initialized');
    _couponController.addListener(_syncCouponText);

    // Watch for cart total amount changes and re-evaluate coupons. This ensures an
    // auto-applied coupon doesn't remain when the cart subtotal drops
    // below its minimum requirement (the bug you reported).
    // We listen to totalAmount instead of cartItems because totalAmount is
    // the actual value we use for validation, and it updates after items change.
    print('🎯 Setting up cart total amount listener...');
    ever(_cartController.totalAmountObservable, (amount) {
      print('🔔 Cart total changed - subtotal: ₹$amount');
      _onCartChanged();
    });

    // Try to fetch and auto-apply the best coupon initially.
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
      print('📥 Fetching available coupons...');
      final coupons = await _payoutService.fetchCoupons();
      _availableCoupons.value = coupons;
      print('📥 Fetched ${coupons.length} coupons');

      if (coupons.isEmpty) {
        print('   No coupons available');
        return;
      }

      double bestSavings = 0.0;
      Map<String, dynamic>? bestCoupon;

      for (final c in coupons) {
        final base = subtotal;
        final minRequired = c.containsKey('up_to')
            ? _toDouble(c['up_to'])
            : 0.0;
        final couponCode = c['cupon'] ?? c['coupon'] ?? 'N/A';
        print(
          '   Checking coupon "$couponCode": min=₹$minRequired, current=₹$base',
        );

        if (minRequired > 0 && base < minRequired) {
          print('     ❌ Not applicable (subtotal < minimum)');
          continue;
        }

        final savings = _calculateCouponSavings(c, base);
        print('     Potential savings: ₹${savings.toStringAsFixed(2)}');
        if (savings > bestSavings) {
          bestSavings = savings;
          bestCoupon = c;
        }
      }

      if (bestCoupon != null && bestSavings > 0) {
        final bestCode = bestCoupon['cupon'] ?? bestCoupon['coupon'] ?? '';
        print(
          '   ✅ Best coupon: "$bestCode" (saves ₹${bestSavings.toStringAsFixed(2)})',
        );
        _appliedCoupon.value = {
          ...bestCoupon,
          'isValid': true,
          'calculatedSavings': bestSavings,
          'message': bestCoupon['description'] ?? 'Coupon applied',
        };
        final code = bestCoupon['cupon'] ?? bestCoupon['coupon'] ?? '';
        _couponController.text = code;
        _couponCode.value = code;
      } else {
        print('   ℹ️  No applicable coupons found');
      }
    } catch (e) {
      print('   ⚠️  Error fetching coupons: $e');
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

  // Called whenever the cart changes. If the currently applied coupon is
  // no longer applicable for the new subtotal, clear it and attempt to
  // auto-apply the best remaining coupon (if any).
  void _onCartChanged() async {
    try {
      print('🔄 Cart changed - validating coupon eligibility...');
      print('   Current subtotal: ₹$subtotal');

      final current = appliedCoupon;

      // If no coupon currently applied, attempt to auto-apply best one
      if (current == null) {
        print('   No coupon applied - attempting to auto-apply best coupon');
        // Non-blocking: fetch may call network; keep it async but don't
        // await here to avoid blocking UI updates frequently.
        fetchAndApplyBestCoupon();
        return;
      }

      print('   Current coupon: ${current['cupon'] ?? current['coupon']}');

      // If the current coupon is no longer applicable, clear it and try
      // to find another that fits the new subtotal.
      if (!isCouponApplicable(current)) {
        final couponCode = current['cupon'] ?? current['coupon'] ?? '';
        final minRequired = current.containsKey('up_to')
            ? _toDouble(current['up_to'])
            : 0.0;
        print('   ❌ Coupon "$couponCode" no longer applicable');
        print(
          '   Minimum required: ₹$minRequired, Current subtotal: ₹$subtotal',
        );

        _appliedCoupon.value = null;
        _couponController.text = '';
        _couponCode.value = '';

        // Search available coupons (already fetched) for a valid one and
        // apply the best locally without forcing a network call.
        double bestSavings = 0.0;
        Map<String, dynamic>? bestCoupon;
        for (final c in _availableCoupons) {
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
          final newCouponCode =
              bestCoupon['cupon'] ?? bestCoupon['coupon'] ?? '';
          print(
            '   ✅ Applying new coupon: "$newCouponCode" (saves ₹${bestSavings.toStringAsFixed(2)})',
          );
          applyCouponLocally(bestCoupon);
        } else {
          print('   ℹ️  No eligible coupons available for current subtotal');
        }

        // Notify listeners so UI updates immediately in screens that
        // observe this controller (e.g., `CouponSection` inside cart).
        update();
      } else {
        // If coupon is still applicable, update calculatedSavings to match
        // the current subtotal (discount may change with subtotal).
        final recalculated = _calculateCouponSavings(current, subtotal);
        print(
          '   ✅ Coupon still valid - recalculated savings: ₹${recalculated.toStringAsFixed(2)}',
        );
        _appliedCoupon.value = {
          ...current,
          'isValid': true,
          'calculatedSavings': recalculated,
          'message': current['description'] ?? 'Coupon applied',
        };
        // Ensure any UI depending on coupon values refreshes.
        update();
      }
    } catch (e) {
      print('   ⚠️  Error in _onCartChanged: $e');
      // don't crash on cart change handling
    }
  }
}

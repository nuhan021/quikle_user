import 'package:quikle_user/core/utils/constants/enums/address_type_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/delivery_enums.dart';
import 'package:quikle_user/core/utils/constants/enums/payment_enums.dart';
import 'package:quikle_user/features/payout/data/models/delivery_option_model.dart';
import 'package:quikle_user/features/payout/data/models/payment_method_model.dart';
import 'package:quikle_user/features/profile/data/models/shipping_address_model.dart';

class PayoutService {
  List<DeliveryOptionModel> getDeliveryOptions() {
    return [
      DeliveryOptionModel(
        type: DeliveryType.combined,
        title: 'Combined',
        description: 'Products delivered together (cheaper)',
        price: 1.99,
        isSelected: true,
      ),
      DeliveryOptionModel(
        type: DeliveryType.split,
        title: 'Split',
        description: 'Faster delivery by different riders',
        price: 3.99,
        isSelected: false,
      ),
    ];
  }

  List<PaymentMethodModel> getPaymentMethods() {
    return [
      PaymentMethodModel(type: PaymentMethodType.paytm, isSelected: true),
      PaymentMethodModel(type: PaymentMethodType.googlePay),
      PaymentMethodModel(type: PaymentMethodType.phonePe),
      PaymentMethodModel(type: PaymentMethodType.cashfree),
      PaymentMethodModel(type: PaymentMethodType.razorpay),
      PaymentMethodModel(type: PaymentMethodType.cashOnDelivery),
    ];
  }

  List<ShippingAddressModel> getShippingAddresses() {
    return [
      ShippingAddressModel(
        id: 'addr_1',
        userId: 'user_123',
        name: 'Aanya Desai',
        address: '28 Crescent Day',
        city: 'LA Port',
        state: 'CA',
        country: 'India',
        zipCode: '90731',
        phoneNumber: '+1 (555) 123-4567',
        type: AddressType.home,
        isDefault: true,
        isSelected: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];
  }

  Future<Map<String, dynamic>> validateCoupon(String couponCode) async {
    await Future.delayed(const Duration(seconds: 1));
    switch (couponCode.toLowerCase()) {
      case 'save10':
        return {
          'isValid': true,
          'discountType': 'percentage',
          'discountValue': 10.0,
          'message': 'You saved 10%!',
        };
      case 'flat20':
        return {
          'isValid': true,
          'discountType': 'fixed',
          'discountValue': 20.0,
          'message': 'You saved \$20!',
        };
      default:
        return {'isValid': false, 'message': 'Invalid coupon code'};
    }
  }

  Future<Map<String, dynamic>> processPayment({
    required double amount,
    required PaymentMethodModel paymentMethod,
    required String orderId,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    if (paymentMethod.type == PaymentMethodType.cashOnDelivery) {
      return {
        'success': true,
        'transactionId': 'COD_$orderId',
        'message': 'Order placed successfully! Pay on delivery.',
      };
    } else {
      return {
        'success': true,
        'transactionId': 'TXN_${DateTime.now().millisecondsSinceEpoch}',
        'message': 'Payment successful!',
      };
    }
  }
}

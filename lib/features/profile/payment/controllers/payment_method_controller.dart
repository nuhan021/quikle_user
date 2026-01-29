import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/enums/payment_enums.dart';
import '../data/models/payment_method_model.dart';

class PaymentMethodController extends GetxController {
  final _paymentMethods = <PaymentMethodModel>[].obs;
  final _selectedPaymentMethod = Rxn<PaymentMethodModel>();

  List<PaymentMethodModel> get paymentMethods => _paymentMethods;
  PaymentMethodModel? get selectedPaymentMethod => _selectedPaymentMethod.value;

  @override
  void onInit() {
    super.onInit();
    _loadPaymentMethods();
  }

  void _loadPaymentMethods() {
    _paymentMethods.value = [
      // const PaymentMethodModel(
      //   id: '1',
      //   type: PaymentMethodType.paytm,
      //   isRemovable: true,
      // ),
      // const PaymentMethodModel(
      //   id: '2',
      //   type: PaymentMethodType.googlePay,
      //   isRemovable: true,
      // ),
      const PaymentMethodModel(
        id: '3',
        type: PaymentMethodType.phonePe,
        isRemovable: true,
      ),
      const PaymentMethodModel(
        id: '4',
        type: PaymentMethodType.cashfree,
        isRemovable: true,
      ),
      // const PaymentMethodModel(
      //   id: '5',
      //   type: PaymentMethodType.razorpay,
      //   isRemovable: true,
      // ),
      const PaymentMethodModel(
        id: '6',
        type: PaymentMethodType.cashOnDelivery,
        isRemovable: false,
      ),
    ];
  }

  void selectPaymentMethod(PaymentMethodModel method) {
    _selectedPaymentMethod.value = method;
  }

  void removePaymentMethod(String id) {
    _paymentMethods.removeWhere((method) => method.id == id);

    if (_selectedPaymentMethod.value?.id == id) {
      _selectedPaymentMethod.value = null;
    }
  }

  void addPaymentMethod(PaymentMethodModel method) {
    _paymentMethods.add(method);
  }
}

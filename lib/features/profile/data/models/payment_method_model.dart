import 'package:quikle_user/core/utils/constants/enums/payment_enums.dart';

class PaymentMethodModel {
  final String id;
  final PaymentMethodType type;
  final bool isRemovable;
  final bool isActive;

  const PaymentMethodModel({
    required this.id,
    required this.type,
    this.isRemovable = true,
    this.isActive = true,
  });

  PaymentMethodModel copyWith({
    String? id,
    PaymentMethodType? type,
    bool? isRemovable,
    bool? isActive,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      type: type ?? this.type,
      isRemovable: isRemovable ?? this.isRemovable,
      isActive: isActive ?? this.isActive,
    );
  }
}

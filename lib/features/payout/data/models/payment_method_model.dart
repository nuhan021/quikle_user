import '../../../../core/utils/constants/enums/payment_enums.dart';

class PaymentMethodModel {
  final PaymentMethodType type;
  final bool isSelected;

  const PaymentMethodModel({required this.type, this.isSelected = false});
  String get name => type.displayName;
  String? get icon => type.iconPath;

  PaymentMethodModel copyWith({PaymentMethodType? type, bool? isSelected}) {
    return PaymentMethodModel(
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

import '../../../../core/utils/constants/enums/delivery_enums.dart';

class DeliveryOptionModel {
  final DeliveryType type;
  final String title;
  final String description;
  final double price;
  final bool isSelected;

  DeliveryOptionModel({
    required this.type,
    required this.title,
    required this.description,
    required this.price,
    required this.isSelected,
  });

  DeliveryOptionModel copyWith({
    DeliveryType? type,
    String? title,
    String? description,
    double? price,
    bool? isSelected,
  }) {
    return DeliveryOptionModel(
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

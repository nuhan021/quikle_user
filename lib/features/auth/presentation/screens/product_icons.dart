import 'package:flutter/widgets.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

/// Product category icons for carousels
class ProductIcons {
  static const List<AssetImage> items = [
    AssetImage(ImagePath.allIcon),
    AssetImage(ImagePath.foodIcon),
    AssetImage(ImagePath.groceryIcon),
    AssetImage(ImagePath.medicineIcon),
    AssetImage(ImagePath.cleaningIcon),
    AssetImage(ImagePath.personalCareIcon),
    AssetImage(ImagePath.petSuppliesIcon),
    AssetImage(ImagePath.customIcon),
    AssetImage(ImagePath.drinksIcon),
    AssetImage(ImagePath.lightIcon),
    AssetImage(ImagePath.pondIcon),
    AssetImage(ImagePath.riceIcon),
  ];

  /// If a List<ImageProvider> is needed
  static List<ImageProvider> asProviders() => List<ImageProvider>.from(items);
}

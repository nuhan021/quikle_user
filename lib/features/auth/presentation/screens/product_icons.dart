import 'package:flutter/widgets.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

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
    AssetImage(ImagePath.antacid),
    AssetImage(ImagePath.banana),
    AssetImage(ImagePath.bread),
    AssetImage(ImagePath.catFood),
    AssetImage(ImagePath.chickenBreast),
    AssetImage(ImagePath.cleaningSpray),
    AssetImage(ImagePath.dishWashing),
    AssetImage(ImagePath.dogChewToy),
    AssetImage(ImagePath.dogFood),
    AssetImage(ImagePath.earbuds),
    AssetImage(ImagePath.eggs),
    AssetImage(ImagePath.glassCleaner),
    AssetImage(ImagePath.lipBalm),
    AssetImage(ImagePath.milk),
    AssetImage(ImagePath.moisturizer),
    AssetImage(ImagePath.momos),
    AssetImage(ImagePath.mop),
    AssetImage(ImagePath.paracetamol),
    AssetImage(ImagePath.puri),
    AssetImage(ImagePath.shampoo),
    AssetImage(ImagePath.soup),
    AssetImage(ImagePath.syrup),
    AssetImage(ImagePath.tShirt),
    AssetImage(ImagePath.vitaminC),
    AssetImage(ImagePath.waterBottle),
  ];

  static List<ImageProvider> asProviders() => List<ImageProvider>.from(items);
}

import 'dart:math';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class SignatureDish {
  final String id;
  final String name;
  final String image;
  final String description;
  final String price;
  final bool isPopular;

  const SignatureDish({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    this.isPopular = false,
  });
}

class RestaurantModel {
  final String id;
  final String name;
  final String image;
  final String deliveryTime;
  final double rating;
  final String address;
  final bool isOpen;
  final List<String> cuisines;
  final List<String> specialties;
  final int reviewCount;
  final double popularity;
  final bool isTopRated;
  final List<SignatureDish> signatureDishes;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.image,
    required this.deliveryTime,
    required this.rating,
    required this.address,
    this.isOpen = true,
    required this.cuisines,
    required this.specialties,
    this.reviewCount = 0,
    this.popularity = 0.0,
    this.isTopRated = false,
    this.signatureDishes = const [],
  });

  bool servesCategory(String categoryId) {
    return specialties.contains(categoryId);
  }

  double get popularityScore {
    return (rating * 0.7) + (reviewCount / 100 * 0.3);
  }

  String getDisplayImage() {
    // If restaurant has signature dishes and no specific image, use signature dish
    if (signatureDishes.isNotEmpty && image.isEmpty) {
      final random = Random();
      final selectedDish =
          signatureDishes[random.nextInt(signatureDishes.length)];
      return selectedDish.image;
    }

    // Otherwise use restaurant image or fallback
    return image.isNotEmpty ? image : ImagePath.profileIcon;
  }

  SignatureDish? get mostPopularDish {
    if (signatureDishes.isEmpty) return null;

    final popularDishes = signatureDishes
        .where((dish) => dish.isPopular)
        .toList();
    if (popularDishes.isNotEmpty) {
      return popularDishes.first;
    }

    return signatureDishes.first;
  }
}

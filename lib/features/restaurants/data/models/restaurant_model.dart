import 'package:flutter/material.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';

class SignatureDish {
  final int id;
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

  factory SignatureDish.fromJson(Map<String, dynamic> json) {
    final price = json['sell_price'] ?? json['price'] ?? 0;
    return SignatureDish(
      id: json['id'] ?? 0,
      name: json['title'] ?? '',
      image: '', // API doesn't provide signature dish images
      description: '',
      price: '\$${price.toStringAsFixed(2)}',
      isPopular: false,
    );
  }
}

class Cuisine {
  final int id;
  final String name;

  const Cuisine({required this.id, required this.name});

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class RestaurantModel {
  final String id;
  final String vendorId;
  final String name;
  final String image;
  final String deliveryTime;
  final double rating;
  final String address;
  final bool isOpen;
  final List<Cuisine> cuisines;
  final List<String> specialties;
  final int reviewCount;
  final double popularity;
  final bool isTopRated;
  final List<SignatureDish> signatureDishes;
  final String? specialities;
  final double? latitude;
  final double? longitude;
  final String? openTime;
  final String? closeTime;

  const RestaurantModel({
    required this.id,
    required this.vendorId,
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
    this.specialities,
    this.latitude,
    this.longitude,
    this.openTime,
    this.closeTime,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    // Parse cuisines from API
    List<Cuisine> cuisineList = [];
    if (json['cuisines'] != null && json['cuisines'] is List) {
      cuisineList = (json['cuisines'] as List)
          .map((c) => Cuisine.fromJson(c as Map<String, dynamic>))
          .toList();
    }

    // Parse signature dishes from API
    List<SignatureDish> dishes = [];
    if (json['signature_dishes'] != null && json['signature_dishes'] is List) {
      dishes = (json['signature_dishes'] as List)
          .map((d) => SignatureDish.fromJson(d as Map<String, dynamic>))
          .toList();
    }

    // Check if restaurant is currently open
    bool isCurrentlyOpen = _checkIfOpen(
      json['open_time']?.toString(),
      json['close_time']?.toString(),
    );

    return RestaurantModel(
      id: json['restaurant_id']?.toString() ?? '',
      vendorId: json['vendor_id']?.toString() ?? '',
      name: json['restaurant_name'] ?? '',
      image: json['photo'] ?? '',
      deliveryTime: '25-30 min', // Default delivery time
      rating: 4.5, // Default rating as API doesn't provide it
      address: '', // API doesn't provide address
      isOpen: isCurrentlyOpen,
      cuisines: cuisineList,
      specialties:
          json['specialities']
              ?.toString()
              .split(',')
              .map((s) => s.trim())
              .toList() ??
          [],
      reviewCount: 0, // API doesn't provide review count
      popularity: 4.5,
      isTopRated: cuisineList.isNotEmpty && dishes.isNotEmpty,
      signatureDishes: dishes,
      specialities: json['specialities']?.toString(),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      openTime: json['open_time']?.toString(),
      closeTime: json['close_time']?.toString(),
    );
  }

  static bool _checkIfOpen(String? openTime, String? closeTime) {
    if (openTime == null || closeTime == null) return true;

    try {
      final now = DateTime.now();
      final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

      final openParts = openTime.split(':');
      final closeParts = closeTime.split(':');

      final open = TimeOfDay(
        hour: int.parse(openParts[0]),
        minute: int.parse(openParts[1]),
      );
      final close = TimeOfDay(
        hour: int.parse(closeParts[0]),
        minute: int.parse(closeParts[1]),
      );

      final currentMinutes = currentTime.hour * 60 + currentTime.minute;
      final openMinutes = open.hour * 60 + open.minute;
      final closeMinutes = close.hour * 60 + close.minute;

      if (closeMinutes < openMinutes) {
        // Closes after midnight
        return currentMinutes >= openMinutes || currentMinutes <= closeMinutes;
      } else {
        return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
      }
    } catch (e) {
      return true; // Default to open if parsing fails
    }
  }

  bool servesCategory(String categoryId) {
    return specialties.contains(categoryId);
  }

  double get popularityScore {
    return (rating * 0.7) + (reviewCount / 100 * 0.3);
  }

  String getDisplayImage() {
    if (signatureDishes.isNotEmpty && image.isEmpty) {
      final selectedDish = signatureDishes[0];
      return selectedDish.image;
    }

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

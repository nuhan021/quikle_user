import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';

class HomeService {
  Future<List<CategoryModel>> fetchCategories() async {
    //await Future.delayed(Duration(seconds: 2));
    return [
      CategoryModel(title: 'All', iconPath: ImagePath.allIcon),
      CategoryModel(title: 'Food', iconPath: ImagePath.foodIcon),
      CategoryModel(title: 'Groceries', iconPath: ImagePath.groceryIcon),
      CategoryModel(title: 'Medicines', iconPath: ImagePath.medicineIcon),
      CategoryModel(title: 'Cleaning', iconPath: ImagePath.cleaningIcon),
      CategoryModel(
        title: 'Personal Care',
        iconPath: ImagePath.personalcareIcon,
      ),
      CategoryModel(title: 'Pet Supplies', iconPath: ImagePath.petSuppliesIcon),
      CategoryModel(title: 'Custom', iconPath: ImagePath.customIcon),
    ];
  }

  Future<List<ProductSectionModel>> fetchProductSections() async {
    //await Future.delayed(Duration(seconds: 2));
    return [
      ProductSectionModel(
        title: '🍕 Foods',
        viewAllText: 'Restaurants',
        products: _foodProducts,
      ),
      ProductSectionModel(
        title: '🛒 Grocery',
        viewAllText: 'View all',
        products: _groceryProducts,
      ),
      ProductSectionModel(
        title: '💊 Medicines',
        viewAllText: 'View all',
        products: _medicineProducts,
      ),
      ProductSectionModel(
        title: '🧽 Cleaning Essentials',
        viewAllText: 'View all',
        products: _cleaningProducts,
      ),
      ProductSectionModel(
        title: '🧴 Personal Care',
        viewAllText: 'View all',
        products: _personalCareProducts,
      ),
      ProductSectionModel(
        title: '🐾 Pet Supplies',
        viewAllText: 'View all',
        products: _petSuppliesProducts,
      ),
      ProductSectionModel(
        title: '🎨 Custom',
        viewAllText: 'View all',
        products: _customProducts,
      ),
    ];
  }

  // Mock data for different product categories
  List<ProductModel> get _foodProducts => [
    const ProductModel(
      title: 'Butter Croissant & Cappuccino',
      price: '\$180',
      icon: Icons.restaurant,
    ),
    const ProductModel(
      title: 'Chicken Sandwich',
      price: '\$160',
      icon: Icons.restaurant,
    ),
    const ProductModel(
      title: 'Chicken Burger',
      price: '\$190',
      icon: Icons.restaurant,
    ),
    const ProductModel(
      title: 'Tandoori Chicken Pizza',
      price: '\$220',
      icon: Icons.restaurant,
    ),
    const ProductModel(
      title: 'Indian Pan Biryani',
      price: '\$180',
      icon: Icons.restaurant,
    ),
    const ProductModel(
      title: 'Spice Chicken Shawarma',
      price: '\$140',
      icon: Icons.restaurant,
    ),
  ];

  List<ProductModel> get _groceryProducts => [
    const ProductModel(
      title: 'Organic Milk - Amul Fresh',
      price: '\$180',
      icon: Icons.local_drink,
    ),
    const ProductModel(
      title: 'Bread Slice - Brown Bread',
      price: '\$160',
      icon: Icons.bakery_dining,
    ),
    const ProductModel(
      title: 'Fresh Banana - Yellow Banana',
      price: '\$80',
      icon: Icons.breakfast_dining,
    ),
    const ProductModel(
      title: 'Wheat Wheat Flour - Atta',
      price: '\$120',
      icon: Icons.grain,
    ),
    const ProductModel(
      title: 'Basmati Rice - Premium Quality',
      price: '\$200',
      icon: Icons.rice_bowl,
    ),
    const ProductModel(
      title: 'Free Range Eggs - Dozen Pack',
      price: '\$140',
      icon: Icons.egg,
    ),
  ];

  List<ProductModel> get _medicineProducts => [
    const ProductModel(
      title: 'Antacid Chewable Tablet',
      price: '\$160',
      icon: Icons.medical_services,
    ),
    const ProductModel(
      title: 'Antiseptic Mouthwash',
      price: '\$140',
      icon: Icons.medical_services,
    ),
    const ProductModel(
      title: 'Ibuprofen Pain Relief',
      price: '\$120',
      icon: Icons.medical_services,
    ),
    const ProductModel(
      title: 'Cough Suppressant Syrup',
      price: '\$180',
      icon: Icons.medical_services,
    ),
    const ProductModel(
      title: 'Vitamin C - Immune Support',
      price: '\$160',
      icon: Icons.medical_services,
    ),
    const ProductModel(
      title: 'Paracetamol Fever Relief',
      price: '\$100',
      icon: Icons.medical_services,
    ),
  ];

  List<ProductModel> get _cleaningProducts => [
    const ProductModel(
      title: 'Cleaning Spray - Lemon Fresh',
      price: '\$160',
      icon: Icons.cleaning_services,
    ),
    const ProductModel(
      title: 'Powerful Dish Soap',
      price: '\$140',
      icon: Icons.cleaning_services,
    ),
    const ProductModel(
      title: 'Glass Cleaner Spray',
      price: '\$120',
      icon: Icons.cleaning_services,
    ),
    const ProductModel(
      title: 'Disinfectant Wipes',
      price: '\$180',
      icon: Icons.cleaning_services,
    ),
    const ProductModel(
      title: 'Liquid Laundry Detergent',
      price: '\$200',
      icon: Icons.cleaning_services,
    ),
    const ProductModel(
      title: 'All-Purpose Cleaner',
      price: '\$160',
      icon: Icons.cleaning_services,
    ),
  ];

  List<ProductModel> get _personalCareProducts => [
    const ProductModel(
      title: 'Long Lasting Perfume',
      price: '\$180',
      icon: Icons.person,
    ),
    const ProductModel(
      title: 'Whitening Toothpaste',
      price: '\$160',
      icon: Icons.person,
    ),
    const ProductModel(
      title: 'Hydrating Body Lotion',
      price: '\$140',
      icon: Icons.person,
    ),
    const ProductModel(
      title: 'Revitalizing Shampoo',
      price: '\$180',
      icon: Icons.person,
    ),
    const ProductModel(
      title: 'Soothing Lip Balm',
      price: '\$100',
      icon: Icons.person,
    ),
    const ProductModel(
      title: 'Daily Face Moisturizer',
      price: '\$160',
      icon: Icons.person,
    ),
  ];

  List<ProductModel> get _petSuppliesProducts => [
    const ProductModel(
      title: 'Premium Dry Dog Food',
      price: '\$220',
      icon: Icons.pets,
    ),
    const ProductModel(
      title: 'Super Soft Shampoo',
      price: '\$160',
      icon: Icons.pets,
    ),
    const ProductModel(
      title: 'Durable Chew Toy',
      price: '\$80',
      icon: Icons.pets,
    ),
    const ProductModel(
      title: 'Cozy Dog Bed - Medium Size',
      price: '\$180',
      icon: Icons.pets,
    ),
    const ProductModel(
      title: 'Stainless Steel Food Bowl',
      price: '\$120',
      icon: Icons.pets,
    ),
    const ProductModel(
      title: 'Premium Dry Cat Food',
      price: '\$200',
      icon: Icons.pets,
    ),
  ];

  List<ProductModel> get _customProducts => [
    const ProductModel(
      title: 'Adjustable LED Desk Lamp',
      price: '\$160',
      icon: Icons.lightbulb,
    ),
    const ProductModel(
      title: 'Bluetooth Wireless Speaker',
      price: '\$180',
      icon: Icons.speaker,
    ),
    const ProductModel(
      title: 'Succulent Plant Trio',
      price: '\$100',
      icon: Icons.local_florist,
    ),
    const ProductModel(
      title: 'Personalized Travel Mug',
      price: '\$140',
      icon: Icons.coffee,
    ),
    const ProductModel(
      title: 'Stainless Steel Water Bottle',
      price: '\$120',
      icon: Icons.water_drop,
    ),
    const ProductModel(
      title: 'Aromatherapy Essential Oil Set',
      price: '\$200',
      icon: Icons.spa,
    ),
  ];
}

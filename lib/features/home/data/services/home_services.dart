import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';

class HomeService {
  Future<List<CategoryModel>> fetchCategories() async {
    //await Future.delayed(Duration(seconds: 2));
    return [
      CategoryModel(title: 'All', iconPath: ImagePath.allIcon, id: 0),
      CategoryModel(title: 'Food', iconPath: ImagePath.foodIcon, id: 1),
      CategoryModel(title: 'Groceries', iconPath: ImagePath.groceryIcon, id: 2),
      CategoryModel(
        title: 'Medicines',
        iconPath: ImagePath.medicineIcon,
        id: 3,
      ),
      CategoryModel(title: 'Cleaning', iconPath: ImagePath.cleaningIcon, id: 4),
      CategoryModel(
        title: 'Personal Care',
        iconPath: ImagePath.personalcareIcon,
        id: 5,
      ),
      CategoryModel(
        title: 'Pet Supplies',
        iconPath: ImagePath.petSuppliesIcon,
        id: 6,
      ),
      CategoryModel(title: 'Custom', iconPath: ImagePath.customIcon, id: 7),
    ];
  }

  // Get product sections for "All" category (6 items each)
  Future<List<ProductSectionModel>> fetchProductSections() async {
    return [
      ProductSectionModel(
        viewAllText: 'View all',
        products: _foodProducts.take(6).toList(),
        categoryId: 1,
      ),
      ProductSectionModel(
        viewAllText: 'View all',
        products: _groceryProducts.take(6).toList(),
        categoryId: 2,
      ),
      ProductSectionModel(
        viewAllText: 'View all',
        products: _medicineProducts.take(6).toList(),
        categoryId: 3,
      ),
      ProductSectionModel(
        viewAllText: 'View all',
        products: _cleaningProducts.take(6).toList(),
        categoryId: 4,
      ),
      ProductSectionModel(
        viewAllText: 'View all',
        products: _personalCareProducts.take(6).toList(),
        categoryId: 5,
      ),
      ProductSectionModel(
        viewAllText: 'View all',
        products: _petSuppliesProducts.take(6).toList(),
        categoryId: 6,
      ),
      ProductSectionModel(
        viewAllText: 'View all',
        products: _customProducts.take(6).toList(),
        categoryId: 7,
      ),
    ];
  }

  // Get all products with their category assignments
  Future<List<ProductModel>> fetchAllProducts() async {
    return [
      ..._foodProducts,
      ..._groceryProducts,
      ..._medicineProducts,
      ..._cleaningProducts,
      ..._personalCareProducts,
      ..._petSuppliesProducts,
      ..._customProducts,
    ];
  }

  // Get products filtered by category
  Future<List<ProductModel>> fetchProductsByCategory(int categoryId) async {
    if (categoryId == 0) {
      return await fetchAllProducts();
    }
    final allProducts = await fetchAllProducts();
    return allProducts
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  // Mock data for different product categories
  List<ProductModel> get _foodProducts => [
    ProductModel(
      title: 'Butter Croissant & Cappuccino',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 1,
      isFavorite: true,
    ),
    ProductModel(
      title: 'Chicken Sandwich',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 1,
      isFavorite: false,
    ),
    ProductModel(
      title: 'Chicken Burger',
      price: '\$190',
      imagePath: ImagePath.foodIcon,
      categoryId: 1,
      isFavorite: true,
    ),
    ProductModel(
      title: 'Tandoori Chicken Pizza',
      price: '\$220',
      imagePath: ImagePath.foodIcon,
      categoryId: 1,
    ),
    ProductModel(
      title: 'Indian Pan Biryani',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 1,
    ),
    ProductModel(
      title: 'Spice Chicken Shawarma',
      price: '\$140',
      imagePath: ImagePath.foodIcon,
      categoryId: 1,
    ),
  ];

  List<ProductModel> get _groceryProducts => [
    ProductModel(
      title: 'Organic Milk - Amul Fresh',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 2,
    ),
    ProductModel(
      title: 'Bread Slice - Brown Bread',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 2,
    ),
    ProductModel(
      title: 'Fresh Banana - Yellow Banana',
      price: '\$80',
      imagePath: ImagePath.foodIcon,
      categoryId: 2,
    ),
    ProductModel(
      title: 'Wheat Wheat Flour - Atta',
      price: '\$120',
      imagePath: ImagePath.foodIcon,
      categoryId: 2,
    ),
    ProductModel(
      title: 'Basmati Rice - Premium Quality',
      price: '\$200',
      imagePath: ImagePath.foodIcon,
      categoryId: 2,
    ),
    ProductModel(
      title: 'Free Range Eggs - Dozen Pack',
      price: '\$140',
      imagePath: ImagePath.foodIcon,
      categoryId: 2,
    ),
  ];

  List<ProductModel> get _medicineProducts => [
    ProductModel(
      title: 'Antacid Chewable Tablet',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 3,
    ),
    ProductModel(
      title: 'Antiseptic Mouthwash',
      price: '\$140',
      imagePath: ImagePath.foodIcon,
      categoryId: 3,
    ),
    ProductModel(
      title: 'Ibuprofen Pain Relief',
      price: '\$120',
      imagePath: ImagePath.foodIcon,
      categoryId: 3,
    ),
    ProductModel(
      title: 'Cough Suppressant Syrup',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 3,
    ),
    ProductModel(
      title: 'Vitamin C - Immune Support',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 3,
    ),
    ProductModel(
      title: 'Paracetamol Fever Relief',
      price: '\$100',
      imagePath: ImagePath.foodIcon,
      categoryId: 3,
    ),
  ];

  List<ProductModel> get _cleaningProducts => [
    ProductModel(
      title: 'Cleaning Spray - Lemon Fresh',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 4,
    ),
    ProductModel(
      title: 'Powerful Dish Soap',
      price: '\$140',
      imagePath: ImagePath.foodIcon,
      categoryId: 4,
    ),
    ProductModel(
      title: 'Glass Cleaner Spray',
      price: '\$120',
      imagePath: ImagePath.foodIcon,
      categoryId: 4,
    ),
    ProductModel(
      title: 'Disinfectant Wipes',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 4,
    ),
    ProductModel(
      title: 'Liquid Laundry Detergent',
      price: '\$200',
      imagePath: ImagePath.foodIcon,
      categoryId: 4,
    ),
    ProductModel(
      title: 'All-Purpose Cleaner',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 4,
    ),
  ];

  List<ProductModel> get _personalCareProducts => [
    ProductModel(
      title: 'Long Lasting Perfume',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 5,
    ),
    ProductModel(
      title: 'Whitening Toothpaste',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 5,
    ),
    ProductModel(
      title: 'Hydrating Body Lotion',
      price: '\$140',
      imagePath: ImagePath.foodIcon,
      categoryId: 5,
    ),
    ProductModel(
      title: 'Revitalizing Shampoo',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 5,
    ),
    ProductModel(
      title: 'Soothing Lip Balm',
      price: '\$100',
      imagePath: ImagePath.foodIcon,
      categoryId: 5,
    ),
    ProductModel(
      title: 'Daily Face Moisturizer',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 5,
    ),
  ];

  List<ProductModel> get _petSuppliesProducts => [
    ProductModel(
      title: 'Premium Dry Dog Food',
      price: '\$220',
      imagePath: ImagePath.foodIcon,
      categoryId: 6,
    ),
    ProductModel(
      title: 'Super Soft Shampoo',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 6,
    ),
    ProductModel(
      title: 'Durable Chew Toy',
      price: '\$80',
      imagePath: ImagePath.foodIcon,
      categoryId: 6,
    ),
    ProductModel(
      title: 'Cozy Dog Bed - Medium Size',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 6,
    ),
    ProductModel(
      title: 'Stainless Steel Food Bowl',
      price: '\$120',
      imagePath: ImagePath.foodIcon,
      categoryId: 6,
    ),
    ProductModel(
      title: 'Premium Dry Cat Food',
      price: '\$200',
      imagePath: ImagePath.foodIcon,
      categoryId: 6,
    ),
  ];

  List<ProductModel> get _customProducts => [
    ProductModel(
      title: 'Adjustable LED Desk Lamp',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 7,
    ),
    ProductModel(
      title: 'Bluetooth Wireless Speaker',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 7,
    ),
    ProductModel(
      title: 'Succulent Plant Trio',
      price: '\$100',
      imagePath: ImagePath.foodIcon,
      categoryId: 7,
    ),
    ProductModel(
      title: 'Personalized Travel Mug',
      price: '\$140',
      imagePath: ImagePath.foodIcon,
      categoryId: 7,
    ),
    ProductModel(
      title: 'Stainless Steel Water Bottle',
      price: '\$120',
      imagePath: ImagePath.foodIcon,
      categoryId: 7,
    ),
    ProductModel(
      title: 'Aromatherapy Essential Oil Set',
      price: '\$200',
      imagePath: ImagePath.foodIcon,
      categoryId: 7,
    ),
  ];
}

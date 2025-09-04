import 'package:flutter/material.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/home/data/services/home_services.dart';
import '../data/models/category_model.dart';
import '../data/models/product_model.dart';

class HomeController {
  final HomeService _homeService =
      HomeService(); // Create an instance of HomeService

  // Categories data
  Future<List<CategoryModel>> fetchCategories() async {
    return await _homeService
        .fetchCategories(); // Fetch categories from HomeService
  }

  // Product sections data
  Future<List<ProductSectionModel>> fetchProductSections() async {
    return await _homeService
        .fetchProductSections(); // Fetch product sections from HomeService
  }

  // Handle actions like tapping a category, product, etc.
  void onNotificationPressed() {
    // Handle notification tap
  }

  void onSearchPressed() {
    // Handle search tap
  }

  void onCategoryPressed(CategoryModel category) {
    // Handle category tap
  }

  void onProductPressed(ProductModel product) {
    // Handle product tap
  }

  void onAddToCartPressed(ProductModel product) {
    // Handle add to cart
  }

  void onViewAllPressed(String sectionTitle) {
    // Handle view all tap
  }

  void onShopNowPressed() {
    // Handle shop now tap
  }
}

import 'dart:async';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';

class HomeService {
  final ProductDataService _productService = ProductDataService();

  Future<List<CategoryModel>> fetchCategories() async {
    return [
      const CategoryModel(id: '0', title: 'All', iconPath: ImagePath.allIcon),
      const CategoryModel(id: '1', title: 'Food', iconPath: ImagePath.foodIcon),
      const CategoryModel(
        id: '2',
        title: 'Groceries',
        iconPath: ImagePath.groceryIcon,
      ),
      const CategoryModel(
        id: '3',
        title: 'Medicines',
        iconPath: ImagePath.medicineIcon,
      ),
      const CategoryModel(
        id: '4',
        title: 'Cleaning',
        iconPath: ImagePath.cleaningIcon,
      ),
      const CategoryModel(
        id: '5',
        title: 'Personal Care',
        iconPath: ImagePath.personalCareIcon,
      ),
      const CategoryModel(
        id: '6',
        title: 'Pet Supplies',
        iconPath: ImagePath.petSuppliesIcon,
      ),
      const CategoryModel(
        id: '7',
        title: 'Custom',
        iconPath: ImagePath.customIcon,
      ),
    ];
  }

  Future<List<ShopModel>> fetchShops() async {
    return [
      const ShopModel(
        id: 'shop_1',
        name: 'Tandoori Tarang',
        image: ImagePath.profileIcon,
        deliveryTime: '30-35 min',
        rating: 4.8,
        address: '123 Food Street, City',
      ),
      const ShopModel(
        id: 'shop_2',
        name: 'Fresh Market',
        image: ImagePath.profileIcon,
        deliveryTime: '25-30 min',
        rating: 4.6,
        address: '456 Market Lane, City',
      ),
      const ShopModel(
        id: 'shop_3',
        name: 'Health Plus Pharmacy',
        image: ImagePath.profileIcon,
        deliveryTime: '15-20 min',
        rating: 4.9,
        address: '789 Health Ave, City',
      ),
    ];
  }

  Future<List<ProductSectionModel>> fetchProductSections() async {
    return [
      ProductSectionModel(
        id: 'section_1',
        viewAllText: 'View all',
        products: _productService.getProductsByCategory('1').take(6).toList(),
        categoryId: '1',
      ),
      ProductSectionModel(
        id: 'section_2',
        viewAllText: 'View all',
        products: _productService.getProductsByCategory('2').take(6).toList(),
        categoryId: '2',
      ),
      ProductSectionModel(
        id: 'section_3',
        viewAllText: 'View all',
        products: _productService.getProductsByCategory('3').take(6).toList(),
        categoryId: '3',
      ),
      ProductSectionModel(
        id: 'section_4',
        viewAllText: 'View all',
        products: _productService.getProductsByCategory('4').take(6).toList(),
        categoryId: '4',
      ),
      ProductSectionModel(
        id: 'section_5',
        viewAllText: 'View all',
        products: _productService.getProductsByCategory('5').take(6).toList(),
        categoryId: '5',
      ),
      ProductSectionModel(
        id: 'section_6',
        viewAllText: 'View all',
        products: _productService.getProductsByCategory('6').take(6).toList(),
        categoryId: '6',
      ),
      ProductSectionModel(
        id: 'section_7',
        viewAllText: 'View all',
        products: _productService.getProductsByCategory('7').take(6).toList(),
        categoryId: '7',
      ),
    ];
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    return _productService.allProducts;
  }
}

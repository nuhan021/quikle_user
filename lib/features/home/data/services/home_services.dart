import 'dart:async';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';

class HomeService {
  final ProductDataService _productService = ProductDataService();
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<List<CategoryModel>> fetchCategories() async {
    final ResponseData response = await _networkCaller.getRequest(
      ApiConstants.getAllCategories,
    );

    if (response.isSuccess) {
      final List data = response.responseData as List;

      final categories = data
          .map((json) => CategoryModel.fromJson(json))
          .toList();

      categories.insert(
        0,
        const CategoryModel(
          id: '0',
          title: 'All',
          type: 'All',
          iconPath: ImagePath.allIcon,
        ),
      );

      return categories;
    } else {
      throw Exception("Failed to load categories: ${response.errorMessage}");
    }
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

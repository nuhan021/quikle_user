import 'dart:async';
import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
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

  Future<List<ProductSectionModel>> fetchProductSections() async {
    final List<Future<List<ProductModel>>> productFutures = [
      _productService.getProductsByCategory('1', limit: 6),
      _productService.getProductsByCategory('2', limit: 6),
      _productService.getProductsByCategory('3', limit: 6),
      _productService.getProductsByCategory('4', limit: 6),
      _productService.getProductsByCategory('5', limit: 6),
      _productService.getProductsByCategory('6', limit: 6),
    ];

    final List<List<ProductModel>> results = await Future.wait(productFutures);
    return [
      ProductSectionModel(
        id: 'section_1',
        viewAllText: 'View all',
        products: results[0],
        categoryId: '1',
      ),
      ProductSectionModel(
        id: 'section_2',
        viewAllText: 'View all',
        products: results[1],
        categoryId: '2',
      ),
      ProductSectionModel(
        id: 'section_3',
        viewAllText: 'View all',
        products: results[2],
        categoryId: '3',
      ),
      ProductSectionModel(
        id: 'section_4',
        viewAllText: 'View all',
        products: results[3],
        categoryId: '4',
      ),
      ProductSectionModel(
        id: 'section_5',
        viewAllText: 'View all',
        products: results[4],
        categoryId: '5',
      ),
      ProductSectionModel(
        id: 'section_6',
        viewAllText: 'View all',
        products: results[5],
        categoryId: '6',
      ),
    ];
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    return [];
  }
}

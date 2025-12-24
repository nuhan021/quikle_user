import 'package:get/get.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';

class SuggestedProductsService extends GetxService {
  static SuggestedProductsService get instance => Get.find();

  final ProductDataService _productService = ProductDataService();
  final RxList<ProductModel> _suggestedProducts = <ProductModel>[].obs;
  final RxBool _isLoading = true.obs;

  List<ProductModel> get suggestedProducts => _suggestedProducts;
  bool get isLoading => _isLoading.value;

  Future<void> preloadSuggestedProducts() async {
    try {
      _isLoading.value = true;
      final tags = StorageService.searchTags;
      final products = await _productService.getProductsByTags(
        tags: tags,
        limit: 7,
      );
      _suggestedProducts.value = products;
    } catch (e) {
      print('Error preloading suggested products: $e');
      _suggestedProducts.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshSuggestions() async {
    await preloadSuggestedProducts();
  }
}

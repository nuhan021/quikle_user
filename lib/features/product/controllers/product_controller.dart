import 'package:get/get.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';
import '../data/models/review_model.dart';
import '../data/models/question_model.dart';
import '../data/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();
  late final CartController _cartController;

  final _isLoading = false.obs;
  final _product = Rx<ProductModel?>(null);
  final _reviews = <ReviewModel>[].obs;
  final _questions = <QuestionModel>[].obs;
  final _shop = Rx<ShopModel?>(null);
  final _description = ''.obs;
  final _ratingDistribution = <String, dynamic>{}.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  ProductModel? get product => _product.value;
  List<ReviewModel> get reviews => _reviews;
  List<QuestionModel> get questions => _questions;
  ShopModel? get shop => _shop.value;
  String get description => _description.value;
  Map<String, dynamic> get ratingDistribution => _ratingDistribution;

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();
  }

  void loadProductDetails(ProductModel productModel) {
    _isLoading.value = true;

    try {
      _product.value = productModel;
      _reviews.value = _productService.getProductReviews(productModel);
      _questions.value = _productService.getProductQuestions(productModel);
      _shop.value = _productService.getShopInfo(productModel);
      _description.value = _productService.getProductDescription(productModel);
      _ratingDistribution.value = _productService.getRatingDistribution(
        productModel,
      );
    } catch (e) {
      print('Error loading product details: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void onAddToCart() {
    if (_product.value != null) {
      if (!_product.value!.canAddToCart) {
        if (_product.value!.isMedicine &&
            _product.value!.isOTC &&
            !_product.value!.hasPrescriptionUploaded) {
          Get.snackbar(
            'Prescription Required',
            'Please upload a valid prescription to add this OTC medicine to your cart.',
            duration: const Duration(seconds: 3),
          );
        }
        return;
      }

      _cartController.addToCart(_product.value!);
      Get.snackbar(
        'Added to Cart',
        '${_product.value!.title} has been added to your cart.',
        duration: const Duration(seconds: 2),
      );
    }
  }

  void onUploadPrescription() {
    // Handle prescription upload
    if (_product.value != null) {
      // In a real app, this would open a file picker or camera
      // For now, we'll simulate successful upload
      final updatedProduct = _product.value!.copyWith(
        hasPrescriptionUploaded: true,
      );
      _product.value = updatedProduct;

      Get.snackbar(
        'Prescription Uploaded',
        'Your prescription has been uploaded successfully. You can now add this medicine to your cart.',
        duration: const Duration(seconds: 3),
      );
    }
  }

  void onViewPrescription() {
    // Handle view prescription
    Get.snackbar(
      'View Prescription',
      'Prescription viewer will open here.',
      duration: const Duration(seconds: 2),
    );
  }

  void onFavoriteToggle() {
    if (_product.value != null) {
      final updatedProduct = _product.value!.copyWith(
        isFavorite: !_product.value!.isFavorite,
      );
      _product.value = updatedProduct;

      Get.snackbar(
        updatedProduct.isFavorite
            ? 'Added to Favorites'
            : 'Removed from Favorites',
        updatedProduct.isFavorite
            ? '${updatedProduct.title} has been added to your favorites.'
            : '${updatedProduct.title} has been removed from your favorites.',
        duration: const Duration(seconds: 2),
      );
    }
  }

  void onSimilarProductTap(ProductModel product) {
    loadProductDetails(product);
  }

  void onWriteReview() {
    // Handle write review action
    Get.snackbar(
      'Write Review',
      'Review functionality will be implemented',
      duration: const Duration(seconds: 2),
    );
  }

  void onAskQuestion() {
    // Handle ask question action
    Get.snackbar(
      'Ask Question',
      'Question functionality will be implemented',
      duration: const Duration(seconds: 2),
    );
  }

  void onReplyToQuestion(QuestionModel question) {
    // Handle reply to question
    Get.snackbar(
      'Reply',
      'Reply functionality will be implemented',
      duration: const Duration(seconds: 2),
    );
  }

  void onSeeAllReviews() {
    // Handle see all reviews
    Get.snackbar(
      'All Reviews',
      'All reviews functionality will be implemented',
      duration: const Duration(seconds: 2),
    );
  }

  void onShareProduct() {
    // Handle share product
    Get.snackbar(
      'Share',
      'Share functionality will be implemented',
      duration: const Duration(seconds: 2),
    );
  }

  void addToCartFromSimilar(ProductModel product) {
    _cartController.addToCart(product);
    Get.snackbar(
      'Added to Cart',
      '${product.title} has been added to your cart.',
      duration: const Duration(seconds: 2),
    );
  }

  void onFavoriteToggleFromSimilar(ProductModel product) {
    // Handle favorite toggle for similar products
    Get.snackbar(
      'Favorite',
      '${product.title} ${product.isFavorite ? 'removed from' : 'added to'} favorites.',
      duration: const Duration(seconds: 2),
    );
  }
}

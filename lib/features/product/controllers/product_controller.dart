import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
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

  
  final reviewController = TextEditingController();
  final questionController = TextEditingController();
  final _userRating = 5.0.obs;

  
  bool get isLoading => _isLoading.value;
  ProductModel? get product => _product.value;
  List<ReviewModel> get reviews => _reviews;
  List<QuestionModel> get questions => _questions;
  ShopModel? get shop => _shop.value;
  String get description => _description.value;
  Map<String, dynamic> get ratingDistribution => _ratingDistribution;
  double get userRating => _userRating.value;

  @override
  void onInit() {
    super.onInit();
    _cartController = Get.find<CartController>();
  }

  @override
  void onClose() {
    reviewController.dispose();
    questionController.dispose();
    super.onClose();
  }

  void setUserRating(double rating) {
    _userRating.value = rating;
  }

  void loadProductDetails(ProductModel productModel) {
    _isLoading.value = true;

    try {
      _product.value = productModel;

      
      _reviews.clear();
      _reviews.addAll(_productService.getProductReviews(productModel));

      _questions.clear();
      _questions.addAll(_productService.getProductQuestions(productModel));

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
    
    if (_product.value != null) {
      
      
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
    
    Get.snackbar(
      'View Prescription',
      'Prescription viewer will open here.',
      duration: const Duration(seconds: 2),
    );
  }

  void onFavoriteToggle() {
    if (_product.value != null) {
      
      if (FavoritesController.isProductFavorite(_product.value!.id)) {
        FavoritesController.removeFromGlobalFavorites(_product.value!.id);
      } else {
        FavoritesController.addToGlobalFavorites(_product.value!.id);
      }

      
      final isFavorite = FavoritesController.isProductFavorite(
        _product.value!.id,
      );
      final updatedProduct = _product.value!.copyWith(isFavorite: isFavorite);
      _product.value = updatedProduct;

      Get.snackbar(
        isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
        isFavorite
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
    if (reviewController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please write a review before submitting',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    
    final newReview = ReviewModel(
      id: 'review_${DateTime.now().millisecondsSinceEpoch}',
      productId: _product.value?.id ?? '',
      userId: 'current_user',
      userName: 'You',
      userImage: 'assets/icons/profile.png',
      rating: _userRating.value,
      comment: reviewController.text.trim(),
      date: DateTime.now(),
    );

    
    _reviews.insert(0, newReview);

    
    reviewController.clear();
    _userRating.value = 5.0;

    Get.snackbar(
      'Review Added',
      'Your review has been added successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void onAskQuestion() {
    if (questionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please write a question before submitting',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    
    final newQuestion = QuestionModel(
      id: 'question_${DateTime.now().millisecondsSinceEpoch}',
      productId: _product.value?.id ?? '',
      userId: 'current_user',
      userName: 'You',
      userImage: 'assets/icons/profile.png',
      question: questionController.text.trim(),
      answer: '', 
      date: DateTime.now(),
    );

    
    _questions.insert(0, newQuestion);

    
    questionController.clear();

    Get.snackbar(
      'Question Added',
      'Your question has been posted successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void onReplyToQuestion(QuestionModel question) {
    
    Get.snackbar(
      'Reply',
      'Reply functionality will be implemented',
      duration: const Duration(seconds: 2),
    );
  }

  void onSeeAllReviews() {
    
    Get.snackbar(
      'All Reviews',
      'All reviews functionality will be implemented',
      duration: const Duration(seconds: 2),
    );
  }

  void onShareProduct() {
    
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
    
    Get.snackbar(
      'Favorite',
      '${product.title} ${product.isFavorite ? 'removed from' : 'added to'} favorites.',
      duration: const Duration(seconds: 2),
    );
  }
}

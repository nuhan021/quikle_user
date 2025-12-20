import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/data/services/category_cache_service.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import 'package:quikle_user/features/cart/controllers/cart_controller.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';
import 'package:quikle_user/features/profile/controllers/favorites_controller.dart';
import '../data/models/review_model.dart';
import '../data/models/question_model.dart';
import '../data/services/product_service.dart';
import '../data/repositories/review_repository.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();
  final ReviewRepository _reviewRepository = ReviewRepository();
  final CategoryCacheService _cacheService = CategoryCacheService();
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

  void loadProductDetails(ProductModel productModel) async {
    _isLoading.value = true;

    try {
      _product.value = productModel;

      // Load questions and shop info from service (mock data)
      _questions.clear();
      _questions.addAll(_productService.getProductQuestions(productModel));

      _shop.value = _productService.getShopInfo(productModel);
      _description.value = _productService.getProductDescription(productModel);

      // Use ratings summary from product model if available
      if (productModel.ratingsSummary != null) {
        _ratingDistribution.value = productModel.ratingsSummary!;
      } else {
        // Fallback to service mock data if not available
        _ratingDistribution.value = _productService.getRatingDistribution(
          productModel,
        );
      }

      // Fetch reviews from API
      await fetchReviews();
    } catch (e) {
      print('Error loading product details: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Fetch reviews from API
  Future<void> fetchReviews() async {
    if (_product.value == null) return;

    try {
      final productId = int.tryParse(_product.value!.id);
      if (productId == null) {
        AppLoggerHelper.error('Invalid product ID: ${_product.value!.id}');
        // Fallback to mock data if product ID is invalid
        _reviews.clear();
        _reviews.addAll(_productService.getProductReviews(_product.value!));
        return;
      }

      AppLoggerHelper.debug('Fetching reviews for product: $productId');

      final response = await _reviewRepository.getReviews(itemId: productId);

      if (response.isSuccess && response.responseData is List<ReviewModel>) {
        _reviews.clear();
        _reviews.addAll(response.responseData as List<ReviewModel>);
        AppLoggerHelper.info('Loaded ${_reviews.length} reviews from API');

        // Update product rating and ratings summary based on fetched reviews
        _updateProductRatingsFromReviews();
      } else {
        AppLoggerHelper.error(
          'Failed to fetch reviews: ${response.errorMessage}',
        );
        // Fallback to mock data on error
        _reviews.clear();
        _reviews.addAll(_productService.getProductReviews(_product.value!));
      }
    } catch (e) {
      AppLoggerHelper.error('Error fetching reviews', e);
      // Fallback to mock data on exception
      if (_product.value != null) {
        _reviews.clear();
        _reviews.addAll(_productService.getProductReviews(_product.value!));
      }
    }
  }

  /// Update product rating and ratings summary based on current reviews
  void _updateProductRatingsFromReviews() {
    if (_product.value == null || _reviews.isEmpty) return;

    // Filter only main reviews (not replies) for rating calculation
    final mainReviews = _reviews.where((r) => !r.isReply).toList();

    if (mainReviews.isEmpty) return;

    // Calculate average rating
    double totalRating = 0;
    int count = 0;

    for (var review in mainReviews) {
      if (review.rating != null) {
        totalRating += review.rating!;
        count++;
      }
    }

    final averageRating = count > 0 ? totalRating / count : 0.0;

    // Calculate ratings summary (percentage of each star rating)
    Map<String, int> starCounts = {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0};

    for (var review in mainReviews) {
      if (review.rating != null) {
        final rating = review.rating!.round();
        if (rating >= 1 && rating <= 5) {
          starCounts[rating.toString()] =
              (starCounts[rating.toString()] ?? 0) + 1;
        }
      }
    }

    // Convert counts to percentages
    Map<String, dynamic> ratingsSummary = {};
    for (var entry in starCounts.entries) {
      final percentage = count > 0 ? (entry.value / count * 100).round() : 0;
      ratingsSummary[entry.key] = percentage;
    }

    // Update product model with new ratings
    _product.value = _product.value!.copyWith(
      rating: averageRating,
      reviewsCount: mainReviews.length,
      ratingsSummary: ratingsSummary,
    );

    // Update rating distribution for UI
    _ratingDistribution.value = ratingsSummary;

    AppLoggerHelper.debug(
      'Updated ratings - Average: $averageRating, Count: ${mainReviews.length}, Summary: $ratingsSummary',
    );
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
    }
  }

  void onUploadPrescription() {
    if (_product.value != null) {
      final updatedProduct = _product.value!.copyWith(
        hasPrescriptionUploaded: true,
      );
      _product.value = updatedProduct;

      // Get.snackbar(
      //   'Prescription Uploaded',
      //   'Your prescription has been uploaded successfully. You can now add this medicine to your cart.',
      //   duration: const Duration(seconds: 3),
      // );
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
      Get.find<FavoritesController>().toggleFavorite(_product.value!);

      final isFavorite = FavoritesController.isProductFavorite(
        _product.value!.id,
      );
      final updatedProduct = _product.value!.copyWith(isFavorite: isFavorite);
      _product.value = updatedProduct;

      // Get.snackbar(
      //   isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
      //   isFavorite
      //       ? '${updatedProduct.title} has been added to your favorites.'
      //       : '${updatedProduct.title} has been removed from your favorites.',
      //   duration: const Duration(seconds: 2),
      // );
    }
  }

  void onSimilarProductTap(ProductModel product) {
    loadProductDetails(product);
  }

  void onWriteReview() async {
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

    if (_product.value == null) {
      Get.snackbar(
        'Error',
        'Product information not available',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Parse product ID to int
      final productId = int.tryParse(_product.value!.id);
      if (productId == null) {
        Get.back(); // Close loading dialog
        Get.snackbar(
          'Error',
          'Invalid product ID',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        return;
      }

      // Submit review to API
      final response = await _reviewRepository.submitReview(
        itemId: productId,
        rating: _userRating.value.toInt(),
        comment: reviewController.text.trim(),
      );

      Get.back(); // Close loading dialog

      if (response.isSuccess) {
        // Clear form
        reviewController.clear();
        _userRating.value = 5.0;

        // Refresh reviews from API to get the latest data
        await fetchReviews();

        // Invalidate cache so fresh data is loaded on home/category screens
        if (_product.value != null) {
          await _cacheService.invalidateProductCache(_product.value!);
          AppLoggerHelper.info(
            '✅ Cache invalidated for product ${_product.value!.id}',
          );
        }

        Get.snackbar(
          'Success',
          'Your review has been submitted successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to submit review. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.back(); // Close loading dialog if still open
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
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

  /// Reply to a review
  void onReplyToReview(ReviewModel parentReview) async {
    final TextEditingController replyController = TextEditingController();
    final RxDouble replyRating = 5.0.obs;

    Get.dialog(
      AlertDialog(
        title: Text(
          'Reply to ${parentReview.userName}',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate your experience:',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => replyRating.value = (index + 1).toDouble(),
                    child: Icon(
                      index < replyRating.value.floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.orange,
                      size: 24.sp,
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: replyController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write your reply...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                contentPadding: EdgeInsets.all(12.w),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              replyController.dispose();
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (replyController.text.trim().isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please write a reply',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
                return;
              }

              Get.back(); // Close dialog

              try {
                // Show loading
                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );

                final productId = int.tryParse(_product.value!.id);
                final parentReviewId = int.tryParse(parentReview.id);

                if (productId == null || parentReviewId == null) {
                  Get.back();
                  Get.snackbar(
                    'Error',
                    'Invalid product or review ID',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                final response = await _reviewRepository.submitReply(
                  itemId: productId,
                  rating: replyRating.value.toInt(),
                  comment: replyController.text.trim(),
                  parentReviewId: parentReviewId,
                );

                Get.back(); // Close loading

                if (response.isSuccess) {
                  // Refresh reviews from API to get the latest data with replies
                  await fetchReviews();

                  // Invalidate cache so fresh data is loaded on home/category screens
                  if (_product.value != null) {
                    await _cacheService.invalidateProductCache(_product.value!);
                    AppLoggerHelper.info(
                      '✅ Cache invalidated for product ${_product.value!.id}',
                    );
                  }

                  Get.snackbar(
                    'Success',
                    'Your reply has been submitted successfully!',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    response.errorMessage.isNotEmpty
                        ? response.errorMessage
                        : 'Failed to submit reply. Please try again.',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
                  );
                }
              } catch (e) {
                Get.back();
                Get.snackbar(
                  'Error',
                  'An unexpected error occurred: ${e.toString()}',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              } finally {
                replyController.dispose();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void addToCartFromSimilar(ProductModel product) {
    _cartController.addToCart(product);
  }

  void onFavoriteToggleFromSimilar(ProductModel product) {
    Get.snackbar(
      'Favorite',
      '${product.title} ${product.isFavorite ? 'removed from' : 'added to'} favorites.',
      duration: const Duration(seconds: 2),
    );
  }
}

import 'package:quikle_user/core/models/response_data.dart';
import 'package:quikle_user/core/services/network_caller.dart';
import 'package:quikle_user/core/services/storage_service.dart';
import 'package:quikle_user/core/utils/constants/api_constants.dart';
import 'package:quikle_user/core/utils/logging/logger.dart';
import '../models/review_model.dart';

class ReviewRepository {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Get all reviews for a product/item
  ///
  /// Parameters:
  /// - [itemId]: The ID of the product/item to fetch reviews for
  ///
  /// Returns ResponseData with a list of ReviewModel objects
  Future<ResponseData> getReviews({required int itemId}) async {
    try {
      final url = ApiConstants.getReviews.replaceAll(
        '{item_id}',
        itemId.toString(),
      );

      AppLoggerHelper.debug('Fetching reviews for item: $itemId');

      final response = await _networkCaller.getRequest(url);

      if (response.isSuccess) {
        try {
          final List<ReviewModel> reviews = [];

          if (response.responseData is List) {
            for (var reviewJson in response.responseData) {
              try {
                final review = ReviewModel.fromJson(reviewJson);
                reviews.add(review);
              } catch (e) {
                AppLoggerHelper.error('Error parsing review item', e);
              }
            }
          }

          AppLoggerHelper.info(
            'Successfully fetched ${reviews.length} reviews',
          );

          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: reviews,
            errorMessage: '',
          );
        } catch (e) {
          AppLoggerHelper.error('Error parsing reviews response', e);
          return ResponseData(
            isSuccess: false,
            statusCode: 500,
            responseData: null,
            errorMessage: 'Failed to parse reviews: ${e.toString()}',
          );
        }
      } else {
        AppLoggerHelper.error(
          'Failed to fetch reviews: ${response.errorMessage}',
        );
        return response;
      }
    } catch (e) {
      AppLoggerHelper.error('Error fetching reviews', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Failed to fetch reviews: ${e.toString()}',
      );
    }
  }

  /// Submit a review for a product
  ///
  /// Parameters:
  /// - [itemId]: The ID of the product/item to review
  /// - [rating]: Rating value (1-5)
  /// - [comment]: Review comment text
  /// - [parentId]: Optional parent review ID for replies (null for main reviews)
  ///
  /// Returns ResponseData with the created review data
  Future<ResponseData> submitReview({
    required int itemId,
    required int rating,
    required String comment,
    int? parentId,
  }) async {
    try {
      final token = StorageService.token;

      if (token == null) {
        return ResponseData(
          isSuccess: false,
          statusCode: 401,
          responseData: null,
          errorMessage: 'User not authenticated',
        );
      }

      // Validate rating
      if (rating < 1 || rating > 5) {
        return ResponseData(
          isSuccess: false,
          statusCode: 400,
          responseData: null,
          errorMessage: 'Rating must be between 1 and 5',
        );
      }

      // Validate comment
      if (comment.trim().isEmpty) {
        return ResponseData(
          isSuccess: false,
          statusCode: 400,
          responseData: null,
          errorMessage: 'Comment cannot be empty',
        );
      }

      // Prepare form data fields
      final fields = {
        'item': itemId.toString(),
        'rating': rating.toString(),
        'comment': comment.trim(),
        'parent': parentId?.toString() ?? '',
      };

      AppLoggerHelper.debug('Submitting review with fields: $fields');

      // Make the API call with form-urlencoded content type
      final response = await _networkCaller.postRequest(
        ApiConstants.submitReview,
        body: fields,
        token: 'Bearer $token',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      );

      if (response.isSuccess) {
        AppLoggerHelper.info('Review submitted successfully');
      } else {
        AppLoggerHelper.error(
          'Failed to submit review: ${response.errorMessage}',
        );
      }

      return response;
    } catch (e) {
      AppLoggerHelper.error('Error submitting review', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Failed to submit review: ${e.toString()}',
      );
    }
  }

  /// Submit a reply to an existing review
  ///
  /// This is a convenience method that calls submitReview with a parent ID
  Future<ResponseData> submitReply({
    required int itemId,
    required int rating,
    required String comment,
    required int parentReviewId,
  }) async {
    return submitReview(
      itemId: itemId,
      rating: rating,
      comment: comment,
      parentId: parentReviewId,
    );
  }
}

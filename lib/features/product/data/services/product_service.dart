import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';
import '../models/review_model.dart';
import '../models/question_model.dart';

class ProductService {
  List<ReviewModel> getProductReviews(ProductModel product) {
    return [
      ReviewModel(
        id: 'review_1',
        productId: product.id,
        userImage: ImagePath.profileIcon,
        userName: 'Aaradhya Sharma',
        userId: 'user_1',
        rating: 5.0,
        comment:
            'Always fresh and perfectly ripe! These avocados are my go-to for my morning toast. Delivery was quick too.',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewModel(
        id: 'review_2',
        productId: product.id,
        userImage: ImagePath.profileIcon,
        userName: 'Isha Patel',
        userId: 'user_2',
        rating: 5.0,
        comment:
            'Always fresh and perfectly ripe! These avocados are my go-to for my morning toast. Delivery was quick too.',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewModel(
        id: 'review_3',
        productId: product.id,
        userImage: ImagePath.profileIcon,
        userName: 'Mira Reddy',
        userId: 'user_3',
        rating: 5.0,
        comment:
            'Always fresh and perfectly ripe! These avocados are my go-to for my morning toast. Delivery was quick too.',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  List<QuestionModel> getProductQuestions(ProductModel product) {
    return [
      QuestionModel(
        id: 'question_1',
        productId: product.id,
        userImage: ImagePath.profileIcon,
        userName: 'Pooja Verma',
        userId: 'user_4',
        question: 'May I order more than 1 kg ?',
        answer:
            'Yes, you can order multiple quantities. Please select the quantity before adding to cart.',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  ShopModel getShopInfo(ProductModel product) {
    // Use actual shop data from the product API response
    return ShopModel(
      id: product.shopId,
      name: product.shopName ?? 'Shop',
      image: product.shopLogo ?? 'assets/images/shopImage.png',
      deliveryTime: '30-35 min', // Default delivery time
      rating: 4.8, // Default rating
      address: '', // Address not available from product API
      isOpen: true,
    );
  }

  String getProductDescription(ProductModel product) {
    return product.description;
  }

  Map<String, dynamic> getRatingDistribution(ProductModel product) {
    return {'5': 85, '4': 10, '3': 3, '2': 1, '1': 1};
  }
}

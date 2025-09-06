import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';
import '../models/review_model.dart';
import '../models/question_model.dart';

class ProductService {
  // Mock data for reviews
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

  // Mock data for questions
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

  // Mock shop information - now gets the actual shop data
  ShopModel getShopInfo(ProductModel product) {
    return ShopModel(
      id: product.shopId,
      name: 'Tandoori Tarang',
      deliveryTime: 'Delivery in 30-35 min',
      image: ImagePath.profileIcon,
      rating: 4.8,
      address: '123 Food Street, City',
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

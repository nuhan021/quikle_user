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
    // Define all available shops
    final shops = {
      'shop_1': ShopModel(
        id: 'shop_1',
        name: 'Tandoori Tarang',
        deliveryTime: '30-35 min',
        image: ImagePath.shopImage,
        rating: 4.8,
        address: '123 Food Street, City',
        isOpen: true,
      ),
      'shop_2': ShopModel(
        id: 'shop_2',
        name: 'Fresh Market',
        deliveryTime: '25-30 min',
        image: ImagePath.shopImage,
        rating: 4.6,
        address: '456 Market Lane, City',
        isOpen: true,
      ),
      'shop_3': ShopModel(
        id: 'shop_3',
        name: 'Health Plus Pharmacy',
        deliveryTime: '15-20 min',
        image: ImagePath.shopImage,
        rating: 4.9,
        address: '789 Health Ave, City',
        isOpen: true,
      ),
    };

    // Return the correct shop based on product's shopId
    return shops[product.shopId] ?? shops['shop_1']!;
  }

  String getProductDescription(ProductModel product) {
    return product.description;
  }

  Map<String, dynamic> getRatingDistribution(ProductModel product) {
    return {'5': 85, '4': 10, '3': 3, '2': 1, '1': 1};
  }
}

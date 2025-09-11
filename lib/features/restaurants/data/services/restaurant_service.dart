import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/restaurants/data/models/restaurant_model.dart';

class RestaurantService {
  // Mock data for restaurants
  static List<RestaurantModel> _restaurants = [
    // Top-rated restaurants serving multiple categories
    const RestaurantModel(
      id: 'restaurant_1',
      name: 'Tandoori Tarang',
      image: ImagePath.shopImage,
      deliveryTime: '30-35 min',
      rating: 4.8,
      address: '123 Food Street, City',
      isOpen: true,
      cuisines: ['Indian', 'Tandoori'],
      specialties: ['food_biryani', 'food_burger', 'food_chinese'],
      reviewCount: 1250,
      popularity: 4.8,
      isTopRated: true,
    ),
    const RestaurantModel(
      id: 'restaurant_2',
      name: 'Biryani Paradise',
      image: ImagePath.shopImage,
      deliveryTime: '25-30 min',
      rating: 4.9,
      address: '456 Spice Avenue, City',
      isOpen: true,
      cuisines: ['Indian', 'Biryani'],
      specialties: ['food_biryani'],
      reviewCount: 980,
      popularity: 4.9,
      isTopRated: true,
    ),
    const RestaurantModel(
      id: 'restaurant_3',
      name: 'Pizza Palace',
      image: ImagePath.shopImage,
      deliveryTime: '20-25 min',
      rating: 4.7,
      address: '789 Italian Street, City',
      isOpen: true,
      cuisines: ['Italian'],
      specialties: ['food_pizza', 'food_pasta'],
      reviewCount: 850,
      popularity: 4.7,
      isTopRated: true,
    ),
    const RestaurantModel(
      id: 'restaurant_4',
      name: 'Burger Junction',
      image: ImagePath.shopImage,
      deliveryTime: '15-20 min',
      rating: 4.6,
      address: '321 Fast Food Lane, City',
      isOpen: true,
      cuisines: ['American', 'Fast Food'],
      specialties: ['food_burger', 'food_sandwich'],
      reviewCount: 750,
      popularity: 4.6,
      isTopRated: true,
    ),
    const RestaurantModel(
      id: 'restaurant_5',
      name: 'Chinese Garden',
      image: ImagePath.shopImage,
      deliveryTime: '35-40 min',
      rating: 4.5,
      address: '654 Asian Plaza, City',
      isOpen: true,
      cuisines: ['Chinese', 'Asian'],
      specialties: ['food_chinese'],
      reviewCount: 620,
      popularity: 4.5,
      isTopRated: true,
    ),
    const RestaurantModel(
      id: 'restaurant_6',
      name: 'Spice Route',
      image: ImagePath.shopImage,
      deliveryTime: '30-35 min',
      rating: 4.4,
      address: '987 Curry Street, City',
      isOpen: true,
      cuisines: ['Indian', 'Spicy'],
      specialties: ['food_biryani', 'food_chinese'],
      reviewCount: 540,
      popularity: 4.4,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_7',
      name: 'Pasta Villa',
      image: ImagePath.shopImage,
      deliveryTime: '25-30 min',
      rating: 4.3,
      address: '147 Mediterranean Ave, City',
      isOpen: true,
      cuisines: ['Italian', 'Mediterranean'],
      specialties: ['food_pasta', 'food_pizza'],
      reviewCount: 420,
      popularity: 4.3,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_8',
      name: 'Royal Biryani',
      image: ImagePath.shopImage,
      deliveryTime: '40-45 min',
      rating: 4.7,
      address: '258 Royal Court, City',
      isOpen: true,
      cuisines: ['Indian', 'Mughlai'],
      specialties: ['food_biryani'],
      reviewCount: 680,
      popularity: 4.7,
      isTopRated: true,
    ),
    const RestaurantModel(
      id: 'restaurant_9',
      name: 'Quick Bites',
      image: ImagePath.shopImage,
      deliveryTime: '10-15 min',
      rating: 4.2,
      address: '369 Express Road, City',
      isOpen: true,
      cuisines: ['Fast Food', 'Snacks'],
      specialties: ['food_burger', 'food_sandwich'],
      reviewCount: 380,
      popularity: 4.2,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_10',
      name: 'Maharaja Kitchen',
      image: ImagePath.profileIcon,
      deliveryTime: '35-40 min',
      rating: 4.6,
      address: '741 Heritage Lane, City',
      isOpen: true,
      cuisines: ['Indian', 'Traditional'],
      specialties: ['food_biryani', 'food_chinese'],
      reviewCount: 720,
      popularity: 4.6,
      isTopRated: true,
    ),
    const RestaurantModel(
      id: 'restaurant_11',
      name: 'Street Food Corner',
      image: ImagePath.profileIcon,
      deliveryTime: '20-25 min',
      rating: 4.1,
      address: '852 Street Food Hub, City',
      isOpen: true,
      cuisines: ['Street Food', 'Indian'],
      specialties: ['food_burger', 'food_sandwich'],
      reviewCount: 290,
      popularity: 4.1,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_12',
      name: 'Golden Dragon',
      image: ImagePath.profileIcon,
      deliveryTime: '30-35 min',
      rating: 4.4,
      address: '963 Golden Plaza, City',
      isOpen: true,
      cuisines: ['Chinese', 'Thai'],
      specialties: ['food_chinese'],
      reviewCount: 480,
      popularity: 4.4,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_13',
      name: 'Italian Corner',
      image: ImagePath.profileIcon,
      deliveryTime: '25-30 min',
      rating: 4.5,
      address: '159 Europe Street, City',
      isOpen: true,
      cuisines: ['Italian'],
      specialties: ['food_pizza', 'food_pasta'],
      reviewCount: 560,
      popularity: 4.5,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_14',
      name: 'Grill House',
      image: ImagePath.profileIcon,
      deliveryTime: '20-25 min',
      rating: 4.3,
      address: '357 Grill Avenue, City',
      isOpen: true,
      cuisines: ['Grill', 'BBQ'],
      specialties: ['food_burger'],
      reviewCount: 340,
      popularity: 4.3,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_15',
      name: 'Hyderabadi Biryani',
      image: ImagePath.profileIcon,
      deliveryTime: '45-50 min',
      rating: 4.8,
      address: '468 Hyderabad Street, City',
      isOpen: true,
      cuisines: ['Indian', 'Hyderabadi'],
      specialties: ['food_biryani'],
      reviewCount: 920,
      popularity: 4.8,
      isTopRated: true,
    ),
    const RestaurantModel(
      id: 'restaurant_16',
      name: 'Sandwich Express',
      image: ImagePath.profileIcon,
      deliveryTime: '15-20 min',
      rating: 4.0,
      address: '579 Quick Lane, City',
      isOpen: true,
      cuisines: ['Fast Food'],
      specialties: ['food_sandwich'],
      reviewCount: 180,
      popularity: 4.0,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_17',
      name: 'Wok This Way',
      image: ImagePath.profileIcon,
      deliveryTime: '25-30 min',
      rating: 4.2,
      address: '681 Wok Street, City',
      isOpen: true,
      cuisines: ['Chinese', 'Asian Fusion'],
      specialties: ['food_chinese'],
      reviewCount: 320,
      popularity: 4.2,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_18',
      name: 'Burger King',
      image: ImagePath.profileIcon,
      deliveryTime: '20-25 min',
      rating: 4.1,
      address: '792 King Road, City',
      isOpen: true,
      cuisines: ['Fast Food', 'American'],
      specialties: ['food_burger'],
      reviewCount: 450,
      popularity: 4.1,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_19',
      name: 'Pizza Hut',
      image: ImagePath.profileIcon,
      deliveryTime: '30-35 min',
      rating: 4.2,
      address: '803 Pizza Lane, City',
      isOpen: true,
      cuisines: ['Italian', 'American'],
      specialties: ['food_pizza'],
      reviewCount: 640,
      popularity: 4.2,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_20',
      name: 'Noodle House',
      image: ImagePath.profileIcon,
      deliveryTime: '25-30 min',
      rating: 4.0,
      address: '914 Noodle Street, City',
      isOpen: true,
      cuisines: ['Chinese', 'Noodles'],
      specialties: ['food_chinese'],
      reviewCount: 240,
      popularity: 4.0,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_21',
      name: 'Biriyani Brothers',
      image: ImagePath.profileIcon,
      deliveryTime: '35-40 min',
      rating: 4.5,
      address: '125 Brothers Lane, City',
      isOpen: true,
      cuisines: ['Indian', 'South Indian'],
      specialties: ['food_biryani'],
      reviewCount: 580,
      popularity: 4.5,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_22',
      name: 'McDonalds',
      image: ImagePath.profileIcon,
      deliveryTime: '15-20 min',
      rating: 4.0,
      address: '236 Golden Arches, City',
      isOpen: true,
      cuisines: ['Fast Food', 'American'],
      specialties: ['food_burger'],
      reviewCount: 1200,
      popularity: 4.0,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_23',
      name: 'Dominos',
      image: ImagePath.profileIcon,
      deliveryTime: '25-30 min',
      rating: 4.1,
      address: '347 Pizza Plaza, City',
      isOpen: true,
      cuisines: ['Italian', 'Pizza'],
      specialties: ['food_pizza'],
      reviewCount: 780,
      popularity: 4.1,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_24',
      name: 'Subway',
      image: ImagePath.profileIcon,
      deliveryTime: '10-15 min',
      rating: 3.9,
      address: '458 Sub Street, City',
      isOpen: true,
      cuisines: ['Fast Food', 'Healthy'],
      specialties: ['food_sandwich'],
      reviewCount: 520,
      popularity: 3.9,
      isTopRated: false,
    ),
    const RestaurantModel(
      id: 'restaurant_25',
      name: 'KFC',
      image: ImagePath.profileIcon,
      deliveryTime: '20-25 min',
      rating: 4.0,
      address: '569 Chicken Lane, City',
      isOpen: true,
      cuisines: ['Fast Food', 'Chicken'],
      specialties: ['food_burger'],
      reviewCount: 890,
      popularity: 4.0,
      isTopRated: false,
    ),
  ];

  // Get all restaurants
  Future<List<RestaurantModel>> getAllRestaurants() async {
    return _restaurants;
  }

  // Get top restaurants sorted by popularity/rating
  Future<List<RestaurantModel>> getTopRestaurants({int limit = 25}) async {
    final restaurants = await getAllRestaurants();
    restaurants.sort(
      (a, b) => b.rating.compareTo(a.rating),
    ); // Sort by rating (highest first)
    return restaurants.take(limit).toList();
  }

  // Get restaurants that serve a specific food category
  Future<List<RestaurantModel>> getRestaurantsByCategory(
    String categoryId,
  ) async {
    return _restaurants
        .where((restaurant) => restaurant.servesCategory(categoryId))
        .toList();
  }

  // Get restaurant by ID
  Future<RestaurantModel?> getRestaurantById(String restaurantId) async {
    try {
      return _restaurants.firstWhere(
        (restaurant) => restaurant.id == restaurantId,
      );
    } catch (e) {
      return null;
    }
  }

  // Get top-rated restaurants
  Future<List<RestaurantModel>> getTopRatedRestaurants({int limit = 10}) async {
    final topRated = _restaurants
        .where((restaurant) => restaurant.isTopRated)
        .toList();
    topRated.sort((a, b) => b.rating.compareTo(a.rating));
    return topRated.take(limit).toList();
  }

  // Search restaurants by name or cuisine
  Future<List<RestaurantModel>> searchRestaurants(String query) async {
    final lowercaseQuery = query.toLowerCase();
    return _restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(lowercaseQuery) ||
          restaurant.cuisines.any(
            (cuisine) => cuisine.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }
}

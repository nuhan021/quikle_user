import 'dart:async';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/home/data/models/shop_model.dart';

class HomeService {
  Future<List<CategoryModel>> fetchCategories() async {
    return [
      const CategoryModel(id: '0', title: 'All', iconPath: ImagePath.allIcon),
      const CategoryModel(id: '1', title: 'Food', iconPath: ImagePath.foodIcon),
      const CategoryModel(
        id: '2',
        title: 'Groceries',
        iconPath: ImagePath.groceryIcon,
      ),
      const CategoryModel(
        id: '3',
        title: 'Medicines',
        iconPath: ImagePath.medicineIcon,
      ),
      const CategoryModel(
        id: '4',
        title: 'Cleaning',
        iconPath: ImagePath.cleaningIcon,
      ),
      const CategoryModel(
        id: '5',
        title: 'Personal Care',
        iconPath: ImagePath.personalCareIcon,
      ),
      const CategoryModel(
        id: '6',
        title: 'Pet Supplies',
        iconPath: ImagePath.petSuppliesIcon,
      ),
      const CategoryModel(
        id: '7',
        title: 'Custom',
        iconPath: ImagePath.customIcon,
      ),
    ];
  }

  Future<List<ShopModel>> fetchShops() async {
    return [
      const ShopModel(
        id: 'shop_1',
        name: 'Tandoori Tarang',
        image: ImagePath.profileIcon,
        deliveryTime: 'Delivery in 30-35 min',
        rating: 4.8,
        address: '123 Food Street, City',
      ),
      const ShopModel(
        id: 'shop_2',
        name: 'Fresh Market',
        image: ImagePath.profileIcon,
        deliveryTime: 'Delivery in 25-30 min',
        rating: 4.6,
        address: '456 Market Lane, City',
      ),
      const ShopModel(
        id: 'shop_3',
        name: 'Health Plus Pharmacy',
        image: ImagePath.profileIcon,
        deliveryTime: 'Delivery in 15-20 min',
        rating: 4.9,
        address: '789 Health Ave, City',
      ),
    ];
  }

  Future<List<ProductSectionModel>> fetchProductSections() async {
    return [
      ProductSectionModel(
        id: 'section_1',
        viewAllText: 'View all',
        products: _foodProducts.take(6).toList(),
        categoryId: '1',
      ),
      ProductSectionModel(
        id: 'section_2',
        viewAllText: 'View all',
        products: _groceryProducts.take(6).toList(),
        categoryId: '2',
      ),
      ProductSectionModel(
        id: 'section_3',
        viewAllText: 'View all',
        products: _medicineProducts.take(6).toList(),
        categoryId: '3',
      ),
      ProductSectionModel(
        id: 'section_4',
        viewAllText: 'View all',
        products: _cleaningProducts.take(6).toList(),
        categoryId: '4',
      ),
      ProductSectionModel(
        id: 'section_5',
        viewAllText: 'View all',
        products: _personalCareProducts.take(6).toList(),
        categoryId: '5',
      ),
      ProductSectionModel(
        id: 'section_6',
        viewAllText: 'View all',
        products: _petSuppliesProducts.take(6).toList(),
        categoryId: '6',
      ),
      ProductSectionModel(
        id: 'section_7',
        viewAllText: 'View all',
        products: _customProducts.take(6).toList(),
        categoryId: '7',
      ),
    ];
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    return [
      ..._foodProducts,
      ..._groceryProducts,
      ..._medicineProducts,
      ..._cleaningProducts,
      ..._personalCareProducts,
      ..._petSuppliesProducts,
      ..._customProducts,
    ];
  }

  // Mock data for different product categories
  List<ProductModel> get _foodProducts => [
    const ProductModel(
      id: 'food_1',
      title: 'Butter Croissant & Cappuccino',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$18',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      shopId: 'shop_1',
      isFavorite: true,
      rating: 4.8,
      weight: '2 pieces',
    ),
    const ProductModel(
      id: 'food_2',
      title: 'Chicken Sandwich',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$16',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      shopId: 'shop_1',
      isFavorite: false,
      rating: 4.6,
      weight: '1 sandwich',
    ),
    const ProductModel(
      id: 'food_3',
      title: 'Chicken Burger',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$19',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      shopId: 'shop_2',
      isFavorite: true,
      rating: 4.9,
      weight: '1 burger',
    ),
    const ProductModel(
      id: 'food_4',
      title: 'Tandoori Chicken Pizza',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$22',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      shopId: 'shop_2',
      rating: 4.7,
      weight: 'Large size',
    ),
    const ProductModel(
      id: 'food_5',
      title: 'Fresh Vegetable Salad',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$14',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      shopId: 'shop_1',
      rating: 4.5,
      weight: 'Medium size',
    ),
    const ProductModel(
      id: 'food_6',
      title: 'Indian Pan Biryani',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$18',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      shopId: 'shop_1',
      rating: 4.8,
      weight: '2 portions',
    ),
    const ProductModel(
      id: 'food_7',
      title: 'Spice Chicken Shawarma',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$14',
      imagePath: ImagePath.foodIcon,
      categoryId: '1',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1 wrap',
    ),
  ];

  List<ProductModel> get _groceryProducts => [
    const ProductModel(
      id: 'grocery_1',
      title: 'Organic Milk - Amul Fresh',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$5',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '1 liter',
    ),
    const ProductModel(
      id: 'grocery_2',
      title: 'Bread Slice - Brown Bread',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$3',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '400g pack',
    ),
    const ProductModel(
      id: 'grocery_3',
      title: 'Fresh Banana - Yellow Banana',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$2',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '1kg bunch',
    ),
    const ProductModel(
      id: 'grocery_4',
      title: 'Wheat Flour - Atta',
      price: '\$4',
      imagePath: ImagePath.groceryIcon,
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      categoryId: '2',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1kg pack',
    ),
    const ProductModel(
      id: 'grocery_5',
      title: 'Basmati Rice - Premium Quality',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$8',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '2kg pack',
    ),
    const ProductModel(
      id: 'grocery_6',
      title: 'Free Range Eggs - Dozen Pack',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$6',
      imagePath: ImagePath.groceryIcon,
      categoryId: '2',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '12 pieces',
    ),
  ];

  List<ProductModel> get _medicineProducts => [
    const ProductModel(
      id: 'medicine_1',
      title: 'Antacid Chewable Tablet',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$8',
      imagePath: ImagePath.medicineIcon,
      categoryId: '3',
      shopId: 'shop_3',
      rating: 4.3,
      weight: '20 tablets',
    ),
    const ProductModel(
      id: 'medicine_2',
      title: 'Antiseptic Mouthwash',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$7',
      imagePath: ImagePath.medicineIcon,
      categoryId: '3',
      shopId: 'shop_3',
      rating: 4.5,
      weight: '250ml bottle',
    ),
    const ProductModel(
      id: 'medicine_3',
      title: 'Ibuprofen Pain Relief',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$6',
      imagePath: ImagePath.medicineIcon,
      categoryId: '3',
      shopId: 'shop_3',
      rating: 4.6,
      weight: '30 tablets',
    ),
    const ProductModel(
      id: 'medicine_4',
      title: 'Cough Suppressant Syrup',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$9',
      imagePath: ImagePath.medicineIcon,
      categoryId: '3',
      shopId: 'shop_3',
      rating: 4.2,
      weight: '100ml bottle',
    ),
    const ProductModel(
      id: 'medicine_5',
      title: 'Vitamin C - Immune Support',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$8',
      imagePath: ImagePath.medicineIcon,
      categoryId: '3',
      shopId: 'shop_3',
      rating: 4.7,
      weight: '60 tablets',
    ),
    const ProductModel(
      id: 'medicine_6',
      title: 'Paracetamol Fever Relief',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$5',
      imagePath: ImagePath.medicineIcon,
      categoryId: '3',
      shopId: 'shop_3',
      rating: 4.4,
      weight: '10 tablets',
    ),
  ];

  List<ProductModel> get _cleaningProducts => [
    const ProductModel(
      id: 'cleaning_1',
      title: 'Cleaning Spray - Lemon Fresh',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$8',
      imagePath: ImagePath.cleaningIcon,
      categoryId: '4',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '500ml bottle',
    ),
    const ProductModel(
      id: 'cleaning_2',
      title: 'Powerful Dish Soap',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$7',
      imagePath: ImagePath.cleaningIcon,
      categoryId: '4',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '250ml bottle',
    ),
    const ProductModel(
      id: 'cleaning_3',
      title: 'Glass Cleaner Spray',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$6',
      imagePath: ImagePath.cleaningIcon,
      categoryId: '4',
      shopId: 'shop_2',
      rating: 4.3,
      weight: '300ml bottle',
    ),
    const ProductModel(
      id: 'cleaning_4',
      title: 'Disinfectant Wipes',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$9',
      imagePath: ImagePath.cleaningIcon,
      categoryId: '4',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '100 wipes',
    ),
    const ProductModel(
      id: 'cleaning_5',
      title: 'Liquid Laundry Detergent',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$10',
      imagePath: ImagePath.cleaningIcon,
      categoryId: '4',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '1 liter',
    ),
    const ProductModel(
      id: 'cleaning_6',
      title: 'All-Purpose Cleaner',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$8',
      imagePath: ImagePath.cleaningIcon,
      categoryId: '4',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '500ml bottle',
    ),
  ];

  List<ProductModel> get _personalCareProducts => [
    const ProductModel(
      id: 'care_1',
      title: 'Moisturizing Face Cream',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$12',
      imagePath: ImagePath.personalCareIcon,
      categoryId: '5',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '50ml tube',
    ),
    const ProductModel(
      id: 'care_2',
      title: 'Nourishing Hair Shampoo',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$10',
      imagePath: ImagePath.personalCareIcon,
      categoryId: '5',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '200ml bottle',
    ),
    const ProductModel(
      id: 'care_3',
      title: 'Long Lasting Perfume',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$18',
      imagePath: ImagePath.personalCareIcon,
      categoryId: '5',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '50ml bottle',
    ),
    const ProductModel(
      id: 'care_4',
      title: 'Whitening Toothpaste',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$8',
      imagePath: ImagePath.personalCareIcon,
      categoryId: '5',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '100g tube',
    ),
    const ProductModel(
      id: 'care_5',
      title: 'Hydrating Body Lotion',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$14',
      imagePath: ImagePath.personalCareIcon,
      categoryId: '5',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '200ml bottle',
    ),
    const ProductModel(
      id: 'care_6',
      title: 'Soothing Lip Balm',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$5',
      imagePath: ImagePath.personalCareIcon,
      categoryId: '5',
      shopId: 'shop_2',
      rating: 4.3,
      weight: '4g stick',
    ),
  ];

  List<ProductModel> get _petSuppliesProducts => [
    const ProductModel(
      id: 'pet_1',
      title: 'Premium Dry Dog Food',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$22',
      imagePath: ImagePath.petSuppliesIcon,
      categoryId: '6',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '2kg pack',
    ),
    const ProductModel(
      id: 'pet_2',
      title: 'Super Soft Shampoo',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$8',
      imagePath: ImagePath.petSuppliesIcon,
      categoryId: '6',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '250ml bottle',
    ),
    const ProductModel(
      id: 'pet_3',
      title: 'Durable Chew Toy',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$4',
      imagePath: ImagePath.petSuppliesIcon,
      categoryId: '6',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '1 piece',
    ),
    const ProductModel(
      id: 'pet_4',
      title: 'Cozy Dog Bed - Medium Size',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$18',
      imagePath: ImagePath.petSuppliesIcon,
      categoryId: '6',
      shopId: 'shop_2',
      rating: 4.7,
      weight: 'Medium size',
    ),
    const ProductModel(
      id: 'pet_5',
      title: 'Stainless Steel Food Bowl',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$6',
      imagePath: ImagePath.petSuppliesIcon,
      categoryId: '6',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '500ml capacity',
    ),
    const ProductModel(
      id: 'pet_6',
      title: 'Premium Dry Cat Food',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$20',
      imagePath: ImagePath.petSuppliesIcon,
      categoryId: '6',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '1.5kg pack',
    ),
  ];

  List<ProductModel> get _customProducts => [
    const ProductModel(
      id: 'custom_1',
      title: 'Adjustable LED Desk Lamp',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$16',
      imagePath: ImagePath.customIcon,
      categoryId: '7',
      shopId: 'shop_2',
      rating: 4.5,
      weight: '1 piece',
    ),
    const ProductModel(
      id: 'custom_2',
      title: 'Bluetooth Wireless Speaker',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$18',
      imagePath: ImagePath.customIcon,
      categoryId: '7',
      shopId: 'shop_2',
      rating: 4.7,
      weight: '1 piece',
    ),
    const ProductModel(
      id: 'custom_3',
      title: 'Succulent Plant Trio',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$10',
      imagePath: ImagePath.customIcon,
      categoryId: '7',
      shopId: 'shop_2',
      rating: 4.3,
      weight: '3 plants',
    ),
    const ProductModel(
      id: 'custom_4',
      title: 'Personalized Travel Mug',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$14',
      imagePath: ImagePath.customIcon,
      categoryId: '7',
      shopId: 'shop_2',
      rating: 4.6,
      weight: '350ml capacity',
    ),
    const ProductModel(
      id: 'custom_5',
      title: 'Stainless Steel Water Bottle',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$12',
      imagePath: ImagePath.customIcon,
      categoryId: '7',
      shopId: 'shop_2',
      rating: 4.4,
      weight: '500ml capacity',
    ),
    const ProductModel(
      id: 'custom_6',
      title: 'Aromatherapy Essential Oil Set',
      description:
          'A delicious butter croissant served with a cup of cappuccino.',
      price: '\$20',
      imagePath: ImagePath.customIcon,
      categoryId: '7',
      shopId: 'shop_2',
      rating: 4.8,
      weight: '6 bottles set',
    ),
  ];
}

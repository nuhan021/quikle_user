import 'dart:async';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';

class HomeService {
  Future<List<CategoryModel>> fetchCategories() async {
    return [
      CategoryModel(title: 'All', iconPath: ImagePath.allIcon, id: 0),
      CategoryModel(title: 'Food', iconPath: ImagePath.foodIcon, id: 1),
      CategoryModel(title: 'Groceries', iconPath: ImagePath.groceryIcon, id: 2),
      CategoryModel(
        title: 'Medicines',
        iconPath: ImagePath.medicineIcon,
        id: 3,
      ),
      CategoryModel(title: 'Cleaning', iconPath: ImagePath.cleaningIcon, id: 4),
      CategoryModel(
        title: 'Personal Care',
        iconPath: ImagePath.personalcareIcon,
        id: 5,
      ),
      CategoryModel(
        title: 'Pet Supplies',
        iconPath: ImagePath.petSuppliesIcon,
        id: 6,
      ),
      CategoryModel(title: 'Custom', iconPath: ImagePath.customIcon, id: 7),
    ];
  }

  Future<List<ProductSectionModel>> fetchProductSections() async {
    return [
      ProductSectionModel(
        viewAllText: 'View all',
        products: _foodProducts.take(6).toList(),
        categoryId: 1,
      ),
      ProductSectionModel(
        viewAllText: 'View all',
        products: _groceryProducts.take(6).toList(),
        categoryId: 2,
      ),
      ProductSectionModel(
        viewAllText: 'View all',
        products: _medicineProducts.take(6).toList(),
        categoryId: 3,
      ),
      ProductSectionModel(
        viewAllText: 'View all',
        products: _cleaningProducts.take(6).toList(),
        categoryId: 4,
      ),
      ProductSectionModel(
        viewAllText: 'View all',
        products: _personalCareProducts.take(6).toList(),
        categoryId: 5,
      ),
      ProductSectionModel(
        viewAllText: 'View all',
        products: _petSuppliesProducts.take(6).toList(),
        categoryId: 6,
      ),
      ProductSectionModel(
        viewAllText: 'View all',
        products: _customProducts.take(6).toList(),
        categoryId: 7,
      ),
    ];
  }

  // Get all products with their category assignments
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

  // Get products filtered by category
  Future<List<ProductModel>> fetchProductsByCategory(int categoryId) async {
    if (categoryId == 0) {
      return await fetchAllProducts();
    }
    final allProducts = await fetchAllProducts();
    return allProducts
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  // Mock data for different product categories
  List<ProductModel> get _foodProducts => [
    ProductModel(
      title: 'Butter Croissant & Cappuccino',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 1,
      isFavorite: true,
      rating: 4.8,
      weight: '2 pieces',
    ),
    ProductModel(
      title: 'Chicken Sandwich',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 1,
      isFavorite: false,
      rating: 4.6,
      weight: '1 sandwich',
    ),
    ProductModel(
      title: 'Chicken Burger',
      price: '\$190',
      imagePath: ImagePath.foodIcon,
      categoryId: 1,
      isFavorite: true,
      rating: 4.9,
      weight: '1 burger',
    ),
    ProductModel(
      title: 'Tandoori Chicken Pizza',
      price: '\$220',
      imagePath: ImagePath.foodIcon,
      categoryId: 1,
      rating: 4.7,
      weight: 'Medium size',
    ),
    ProductModel(
      title: 'Indian Pan Biryani',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 1,
      rating: 4.8,
      weight: '2 portions',
    ),
    ProductModel(
      title: 'Spice Chicken Shawarma',
      price: '\$140',
      imagePath: ImagePath.foodIcon,
      categoryId: 1,
      rating: 4.5,
      weight: '1 wrap',
    ),
  ];

  List<ProductModel> get _groceryProducts => [
    ProductModel(
      title: 'Organic Milk - Amul Fresh',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 2,
      rating: 4.6,
      weight: '1 liter',
    ),
    ProductModel(
      title: 'Bread Slice - Brown Bread',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 2,
      rating: 4.4,
      weight: '400g pack',
    ),
    ProductModel(
      title: 'Fresh Banana - Yellow Banana',
      price: '\$80',
      imagePath: ImagePath.foodIcon,
      categoryId: 2,
      rating: 4.7,
      weight: '1kg bunch',
    ),
    ProductModel(
      title: 'Wheat Wheat Flour - Atta',
      price: '\$120',
      imagePath: ImagePath.foodIcon,
      categoryId: 2,
      rating: 4.5,
      weight: '1kg pack',
    ),
    ProductModel(
      title: 'Basmati Rice - Premium Quality',
      price: '\$200',
      imagePath: ImagePath.foodIcon,
      categoryId: 2,
      rating: 4.8,
      weight: '2kg pack',
    ),
    ProductModel(
      title: 'Free Range Eggs - Dozen Pack',
      price: '\$140',
      imagePath: ImagePath.foodIcon,
      categoryId: 2,
      rating: 4.6,
      weight: '12 pieces',
    ),
  ];

  List<ProductModel> get _medicineProducts => [
    ProductModel(
      title: 'Antacid Chewable Tablet',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 3,
      rating: 4.3,
      weight: '20 tablets',
    ),
    ProductModel(
      title: 'Antiseptic Mouthwash',
      price: '\$140',
      imagePath: ImagePath.foodIcon,
      categoryId: 3,
      rating: 4.5,
      weight: '250ml bottle',
    ),
    ProductModel(
      title: 'Ibuprofen Pain Relief',
      price: '\$120',
      imagePath: ImagePath.foodIcon,
      categoryId: 3,
      rating: 4.6,
      weight: '30 tablets',
    ),
    ProductModel(
      title: 'Cough Suppressant Syrup',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 3,
      rating: 4.2,
      weight: '100ml bottle',
    ),
    ProductModel(
      title: 'Vitamin C - Immune Support',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 3,
      rating: 4.7,
      weight: '60 tablets',
    ),
    ProductModel(
      title: 'Paracetamol Fever Relief',
      price: '\$100',
      imagePath: ImagePath.foodIcon,
      categoryId: 3,
      rating: 4.4,
      weight: '10 tablets',
    ),
  ];

  List<ProductModel> get _cleaningProducts => [
    ProductModel(
      title: 'Cleaning Spray - Lemon Fresh',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 4,
      rating: 4.5,
      weight: '500ml bottle',
    ),
    ProductModel(
      title: 'Powerful Dish Soap',
      price: '\$140',
      imagePath: ImagePath.foodIcon,
      categoryId: 4,
      rating: 4.6,
      weight: '250ml bottle',
    ),
    ProductModel(
      title: 'Glass Cleaner Spray',
      price: '\$120',
      imagePath: ImagePath.foodIcon,
      categoryId: 4,
      rating: 4.3,
      weight: '300ml bottle',
    ),
    ProductModel(
      title: 'Disinfectant Wipes',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 4,
      rating: 4.7,
      weight: '100 wipes',
    ),
    ProductModel(
      title: 'Liquid Laundry Detergent',
      price: '\$200',
      imagePath: ImagePath.foodIcon,
      categoryId: 4,
      rating: 4.8,
      weight: '1 liter',
    ),
    ProductModel(
      title: 'All-Purpose Cleaner',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 4,
      rating: 4.4,
      weight: '500ml bottle',
    ),
  ];

  List<ProductModel> get _personalCareProducts => [
    ProductModel(
      title: 'Long Lasting Perfume',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 5,
      rating: 4.6,
      weight: '50ml bottle',
    ),
    ProductModel(
      title: 'Whitening Toothpaste',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 5,
      rating: 4.4,
      weight: '100g tube',
    ),
    ProductModel(
      title: 'Hydrating Body Lotion',
      price: '\$140',
      imagePath: ImagePath.foodIcon,
      categoryId: 5,
      rating: 4.7,
      weight: '200ml bottle',
    ),
    ProductModel(
      title: 'Revitalizing Shampoo',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 5,
      rating: 4.5,
      weight: '250ml bottle',
    ),
    ProductModel(
      title: 'Soothing Lip Balm',
      price: '\$100',
      imagePath: ImagePath.foodIcon,
      categoryId: 5,
      rating: 4.3,
      weight: '4g stick',
    ),
    ProductModel(
      title: 'Daily Face Moisturizer',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 5,
      rating: 4.6,
      weight: '50ml tube',
    ),
  ];

  List<ProductModel> get _petSuppliesProducts => [
    ProductModel(
      title: 'Premium Dry Dog Food',
      price: '\$220',
      imagePath: ImagePath.foodIcon,
      categoryId: 6,
      rating: 4.8,
      weight: '2kg pack',
    ),
    ProductModel(
      title: 'Super Soft Shampoo',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 6,
      rating: 4.5,
      weight: '250ml bottle',
    ),
    ProductModel(
      title: 'Durable Chew Toy',
      price: '\$80',
      imagePath: ImagePath.foodIcon,
      categoryId: 6,
      rating: 4.6,
      weight: '1 piece',
    ),
    ProductModel(
      title: 'Cozy Dog Bed - Medium Size',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 6,
      rating: 4.7,
      weight: 'Medium size',
    ),
    ProductModel(
      title: 'Stainless Steel Food Bowl',
      price: '\$120',
      imagePath: ImagePath.foodIcon,
      categoryId: 6,
      rating: 4.4,
      weight: '500ml capacity',
    ),
    ProductModel(
      title: 'Premium Dry Cat Food',
      price: '\$200',
      imagePath: ImagePath.foodIcon,
      categoryId: 6,
      rating: 4.7,
      weight: '1.5kg pack',
    ),
  ];

  List<ProductModel> get _customProducts => [
    ProductModel(
      title: 'Adjustable LED Desk Lamp',
      price: '\$160',
      imagePath: ImagePath.foodIcon,
      categoryId: 7,
      rating: 4.5,
      weight: '1 piece',
    ),
    ProductModel(
      title: 'Bluetooth Wireless Speaker',
      price: '\$180',
      imagePath: ImagePath.foodIcon,
      categoryId: 7,
      rating: 4.7,
      weight: '1 piece',
    ),
    ProductModel(
      title: 'Succulent Plant Trio',
      price: '\$100',
      imagePath: ImagePath.foodIcon,
      categoryId: 7,
      rating: 4.3,
      weight: '3 plants',
    ),
    ProductModel(
      title: 'Personalized Travel Mug',
      price: '\$140',
      imagePath: ImagePath.foodIcon,
      categoryId: 7,
      rating: 4.6,
      weight: '350ml capacity',
    ),
    ProductModel(
      title: 'Stainless Steel Water Bottle',
      price: '\$120',
      imagePath: ImagePath.foodIcon,
      categoryId: 7,
      rating: 4.4,
      weight: '500ml capacity',
    ),
    ProductModel(
      title: 'Aromatherapy Essential Oil Set',
      price: '\$200',
      imagePath: ImagePath.foodIcon,
      categoryId: 7,
      rating: 4.8,
      weight: '6 bottles set',
    ),
  ];
}

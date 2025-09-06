import 'dart:async';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';

class CategoryService {
  // Food subcategories
  Future<List<SubcategoryModel>> fetchFoodSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'food_biryani',
        title: 'Biryani',
        description: 'Aromatic rice dishes with spices',
        iconPath: ImagePath.foodIcon,
        categoryId: '1',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'food_pizza',
        title: 'Pizza',
        description: 'Italian flatbread with toppings',
        iconPath: ImagePath.foodIcon,
        categoryId: '1',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'food_burger',
        title: 'Burger',
        description: 'Grilled patties in buns',
        iconPath: ImagePath.foodIcon,
        categoryId: '1',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'food_sandwich',
        title: 'Sandwich',
        description: 'Bread with fillings',
        iconPath: ImagePath.foodIcon,
        categoryId: '1',
        isPopular: false,
      ),
      const SubcategoryModel(
        id: 'food_pasta',
        title: 'Pasta',
        description: 'Italian noodles with sauce',
        iconPath: ImagePath.foodIcon,
        categoryId: '1',
        isPopular: false,
      ),
      const SubcategoryModel(
        id: 'food_chinese',
        title: 'Chinese',
        description: 'Asian cuisine dishes',
        iconPath: ImagePath.foodIcon,
        categoryId: '1',
        isPopular: false,
      ),
    ];
  }

  // Grocery main categories (first level)
  Future<List<SubcategoryModel>> fetchGroceryMainCategories() async {
    return [
      const SubcategoryModel(
        id: 'grocery_produce',
        title: 'Produce',
        description: 'Fresh fruits and vegetables',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'grocery_cooking',
        title: 'Cooking',
        description: 'Cooking essentials and ingredients',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'grocery_meats',
        title: 'Meats',
        description: 'Fresh meat and poultry',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'grocery_oils',
        title: 'Oils',
        description: 'Cooking oils and vinegars',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        isPopular: false,
      ),
      const SubcategoryModel(
        id: 'grocery_dairy',
        title: 'Dairy',
        description: 'Milk, cheese, and dairy products',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        isPopular: false,
      ),
      const SubcategoryModel(
        id: 'grocery_grains',
        title: 'Grains',
        description: 'Rice, flour, and cereals',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        isPopular: false,
      ),
    ];
  }

  // Grocery subcategories (second level - under Produce)
  Future<List<SubcategoryModel>> fetchProduceSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'produce_vegetables',
        title: 'Vegetables',
        description: 'Fresh vegetables',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_produce',
      ),
      const SubcategoryModel(
        id: 'produce_fruits',
        title: 'Fruits',
        description: 'Fresh fruits',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_produce',
      ),
      const SubcategoryModel(
        id: 'produce_herbs',
        title: 'Herbs',
        description: 'Fresh herbs and spices',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_produce',
      ),
      const SubcategoryModel(
        id: 'produce_packaged',
        title: 'Packaged',
        description: 'Pre-packaged produce items',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_produce',
      ),
    ];
  }

  // Medicine subcategories (Category 3)
  Future<List<SubcategoryModel>> fetchMedicineSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'medicine_prescription',
        title: 'Prescription',
        description: 'Prescription medicines',
        iconPath: ImagePath.medicineIcon,
        categoryId: '3',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'medicine_otc',
        title: 'Over the Counter',
        description: 'OTC medicines',
        iconPath: ImagePath.medicineIcon,
        categoryId: '3',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'medicine_vitamins',
        title: 'Vitamins',
        description: 'Vitamins and supplements',
        iconPath: ImagePath.medicineIcon,
        categoryId: '3',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'medicine_firstaid',
        title: 'First Aid',
        description: 'First aid supplies',
        iconPath: ImagePath.medicineIcon,
        categoryId: '3',
        isPopular: false,
      ),
    ];
  }

  // Cleaning subcategories (Category 4)
  Future<List<SubcategoryModel>> fetchCleaningSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'cleaning_household',
        title: 'Household',
        description: 'General household cleaners',
        iconPath: ImagePath.cleaningIcon,
        categoryId: '4',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'cleaning_bathroom',
        title: 'Bathroom',
        description: 'Bathroom cleaning supplies',
        iconPath: ImagePath.cleaningIcon,
        categoryId: '4',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'cleaning_kitchen',
        title: 'Kitchen',
        description: 'Kitchen cleaning products',
        iconPath: ImagePath.cleaningIcon,
        categoryId: '4',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'cleaning_laundry',
        title: 'Laundry',
        description: 'Laundry detergents and supplies',
        iconPath: ImagePath.cleaningIcon,
        categoryId: '4',
        isPopular: false,
      ),
    ];
  }

  // Personal Care subcategories (Category 5)
  Future<List<SubcategoryModel>> fetchPersonalCareSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'personal_skincare',
        title: 'Skincare',
        description: 'Skincare products',
        iconPath: ImagePath.personalCareIcon,
        categoryId: '5',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'personal_haircare',
        title: 'Hair Care',
        description: 'Hair care products',
        iconPath: ImagePath.personalCareIcon,
        categoryId: '5',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'personal_oral',
        title: 'Oral Care',
        description: 'Oral hygiene products',
        iconPath: ImagePath.personalCareIcon,
        categoryId: '5',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'personal_hygiene',
        title: 'Personal Hygiene',
        description: 'Personal hygiene items',
        iconPath: ImagePath.personalCareIcon,
        categoryId: '5',
        isPopular: false,
      ),
    ];
  }

  // Pet Supplies subcategories (Category 6)
  Future<List<SubcategoryModel>> fetchPetSuppliesSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'pet_food',
        title: 'Pet Food',
        description: 'Food for pets',
        iconPath: ImagePath.petSuppliesIcon,
        categoryId: '6',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'pet_toys',
        title: 'Toys',
        description: 'Pet toys and accessories',
        iconPath: ImagePath.petSuppliesIcon,
        categoryId: '6',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'pet_health',
        title: 'Health',
        description: 'Pet health products',
        iconPath: ImagePath.petSuppliesIcon,
        categoryId: '6',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'pet_grooming',
        title: 'Grooming',
        description: 'Pet grooming supplies',
        iconPath: ImagePath.petSuppliesIcon,
        categoryId: '6',
        isPopular: false,
      ),
    ];
  }

  // Custom subcategories (Category 7)
  Future<List<SubcategoryModel>> fetchCustomSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'custom_electronics',
        title: 'Electronics',
        description: 'Electronic items',
        iconPath: ImagePath.customIcon,
        categoryId: '7',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'custom_books',
        title: 'Books',
        description: 'Books and magazines',
        iconPath: ImagePath.customIcon,
        categoryId: '7',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'custom_gifts',
        title: 'Gifts',
        description: 'Gift items',
        iconPath: ImagePath.customIcon,
        categoryId: '7',
        isPopular: true,
      ),
      const SubcategoryModel(
        id: 'custom_other',
        title: 'Other',
        description: 'Other custom items',
        iconPath: ImagePath.customIcon,
        categoryId: '7',
        isPopular: false,
      ),
    ];
  }

  // Get subcategories for a given category or parent subcategory
  Future<List<SubcategoryModel>> fetchSubcategories(
    String categoryId, {
    String? parentSubcategoryId,
  }) async {
    if (categoryId == '1') {
      // Food category
      return fetchFoodSubcategories();
    } else if (categoryId == '2') {
      // Grocery category
      if (parentSubcategoryId == null) {
        // Main grocery categories
        return fetchGroceryMainCategories();
      } else if (parentSubcategoryId == 'grocery_produce') {
        // Produce subcategories
        return fetchProduceSubcategories();
      } else if (parentSubcategoryId == 'grocery_cooking') {
        // Cooking subcategories (placeholder for future implementation)
        return [];
      } else if (parentSubcategoryId == 'grocery_meats') {
        // Meats subcategories (placeholder for future implementation)
        return [];
      } else if (parentSubcategoryId == 'grocery_oils') {
        // Oils subcategories (placeholder for future implementation)
        return [];
      }
      // Add more subcategory handling for other grocery main categories as needed
      return [];
    } else if (categoryId == '3') {
      // Medicine category
      return fetchMedicineSubcategories();
    } else if (categoryId == '4') {
      // Cleaning category
      return fetchCleaningSubcategories();
    } else if (categoryId == '5') {
      // Personal Care category
      return fetchPersonalCareSubcategories();
    } else if (categoryId == '6') {
      // Pet Supplies category
      return fetchPetSuppliesSubcategories();
    } else if (categoryId == '7') {
      // Custom category
      return fetchCustomSubcategories();
    }
    return [];
  }

  // Get products by subcategory
  Future<List<ProductModel>> fetchProductsBySubcategory(
    String subcategoryId,
  ) async {
    final allProducts = await _getAllProducts();
    return allProducts
        .where((product) => product.subcategoryId == subcategoryId)
        .toList();
  }

  // Get popular subcategories for a category
  Future<List<SubcategoryModel>> fetchPopularSubcategories(
    String categoryId,
  ) async {
    final subcategories = await fetchSubcategories(categoryId);
    return subcategories.where((sub) => sub.isPopular).toList();
  }

  // Get featured products for a category
  Future<List<ProductModel>> fetchFeaturedProducts(String categoryId) async {
    final allProducts = await _getAllProducts();
    if (categoryId == '2') {
      // For groceries, return produce items as featured
      final categoryProducts = allProducts
          .where(
            (product) =>
                product.categoryId == categoryId &&
                product.subcategoryId != null &&
                product.subcategoryId!.startsWith('produce_'),
          )
          .toList();
      categoryProducts.shuffle();
      return categoryProducts.take(6).toList();
    } else {
      // For food and other categories
      final categoryProducts = allProducts
          .where(
            (product) =>
                product.categoryId == categoryId && product.rating >= 4.7,
          )
          .toList();
      categoryProducts.shuffle();
      return categoryProducts.take(6).toList();
    }
  }

  // Get recommended products for a category
  Future<List<ProductModel>> fetchRecommendedProducts(String categoryId) async {
    final allProducts = await _getAllProducts();
    final categoryProducts = allProducts
        .where((product) => product.categoryId == categoryId)
        .toList();
    categoryProducts.shuffle();
    return categoryProducts.take(8).toList();
  }

  // Get all products for a main category (like all produce items)
  Future<List<ProductModel>> fetchProductsByMainCategory(
    String mainCategoryId,
  ) async {
    final allProducts = await _getAllProducts();

    if (mainCategoryId == 'grocery_produce') {
      // Return all products from produce subcategories
      return allProducts
          .where(
            (product) =>
                product.subcategoryId != null &&
                product.subcategoryId!.startsWith('produce_'),
          )
          .toList();
    } else if (mainCategoryId == 'grocery_cooking') {
      // Return all products from cooking subcategories (for future implementation)
      return allProducts
          .where(
            (product) =>
                product.subcategoryId != null &&
                product.subcategoryId!.startsWith('cooking_'),
          )
          .toList();
    } else if (mainCategoryId == 'grocery_meats') {
      // Return all products from meat subcategories (for future implementation)
      return allProducts
          .where(
            (product) =>
                product.subcategoryId != null &&
                product.subcategoryId!.startsWith('meats_'),
          )
          .toList();
    } else if (mainCategoryId == 'grocery_oils') {
      // Return all products from oils subcategories (for future implementation)
      return allProducts
          .where(
            (product) =>
                product.subcategoryId != null &&
                product.subcategoryId!.startsWith('oils_'),
          )
          .toList();
    }

    // For other main categories, return empty for now
    return [];
  }

  // Get all products for a category (for non-grocery categories)
  Future<List<ProductModel>> fetchAllProductsByCategory(
    String categoryId,
  ) async {
    final allProducts = await _getAllProducts();
    return allProducts
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  // Private method to get all products with subcategory assignments
  Future<List<ProductModel>> _getAllProducts() async {
    return [
      // Biryani items
      const ProductModel(
        id: 'biryani_1',
        title: 'Chicken Biryani',
        description: 'Aromatic basmati rice with tender chicken pieces',
        price: '\$18',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_biryani',
        shopId: 'shop_1',
        rating: 4.8,
        weight: '2 portions',
      ),
      const ProductModel(
        id: 'biryani_2',
        title: 'Mutton Biryani',
        description: 'Rich and flavorful mutton biryani',
        price: '\$22',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_biryani',
        shopId: 'shop_1',
        rating: 4.9,
        weight: '2 portions',
      ),
      const ProductModel(
        id: 'biryani_3',
        title: 'Vegetable Biryani',
        description: 'Mixed vegetable biryani with aromatic spices',
        price: '\$15',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_biryani',
        shopId: 'shop_2',
        rating: 4.6,
        weight: '2 portions',
      ),
      const ProductModel(
        id: 'biryani_4',
        title: 'Hyderabadi Biryani',
        description: 'Authentic Hyderabadi style biryani',
        price: '\$25',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_biryani',
        shopId: 'shop_1',
        rating: 4.9,
        weight: '2 portions',
      ),

      // Pizza items
      const ProductModel(
        id: 'pizza_1',
        title: 'Margherita Pizza',
        description: 'Classic tomato sauce with fresh mozzarella',
        price: '\$16',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_pizza',
        shopId: 'shop_2',
        rating: 4.7,
        weight: 'Medium size',
      ),
      const ProductModel(
        id: 'pizza_2',
        title: 'Pepperoni Pizza',
        description: 'Spicy pepperoni with melted cheese',
        price: '\$19',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_pizza',
        shopId: 'shop_2',
        rating: 4.8,
        weight: 'Medium size',
      ),
      const ProductModel(
        id: 'pizza_3',
        title: 'Tandoori Chicken Pizza',
        description: 'Indian style pizza with tandoori chicken',
        price: '\$22',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_pizza',
        shopId: 'shop_2',
        rating: 4.7,
        weight: 'Large size',
      ),

      // Burger items
      const ProductModel(
        id: 'burger_1',
        title: 'Classic Beef Burger',
        description: 'Juicy beef patty with fresh vegetables',
        price: '\$12',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_burger',
        shopId: 'shop_1',
        rating: 4.6,
        weight: '1 burger',
      ),
      const ProductModel(
        id: 'burger_2',
        title: 'Chicken Burger',
        description: 'Grilled chicken breast with crispy lettuce',
        price: '\$14',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_burger',
        shopId: 'shop_2',
        rating: 4.9,
        weight: '1 burger',
      ),
      const ProductModel(
        id: 'burger_3',
        title: 'Vegetarian Burger',
        description: 'Plant-based patty with fresh toppings',
        price: '\$11',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_burger',
        shopId: 'shop_1',
        rating: 4.4,
        weight: '1 burger',
      ),

      // Vegetables (under Produce)
      const ProductModel(
        id: 'veg_1',
        title: 'Fresh Tomatoes',
        description: 'Juicy red tomatoes',
        price: '\$3',
        imagePath: ImagePath.groceryIcon,
        categoryId: '2',
        subcategoryId: 'produce_vegetables',
        shopId: 'shop_2',
        rating: 4.5,
        weight: '1kg',
      ),
      const ProductModel(
        id: 'veg_2',
        title: 'Green Capsicum',
        description: 'Fresh bell peppers',
        price: '\$4',
        imagePath: ImagePath.groceryIcon,
        categoryId: '2',
        subcategoryId: 'produce_vegetables',
        shopId: 'shop_2',
        rating: 4.3,
        weight: '500g',
      ),
      const ProductModel(
        id: 'veg_3',
        title: 'Fresh Spinach',
        description: 'Organic leafy greens',
        price: '\$2',
        imagePath: ImagePath.groceryIcon,
        categoryId: '2',
        subcategoryId: 'produce_vegetables',
        shopId: 'shop_2',
        rating: 4.6,
        weight: '250g bunch',
      ),

      // Fruits (under Produce)
      const ProductModel(
        id: 'fruit_1',
        title: 'Fresh Bananas',
        description: 'Sweet yellow bananas',
        price: '\$2',
        imagePath: ImagePath.groceryIcon,
        categoryId: '2',
        subcategoryId: 'produce_fruits',
        shopId: 'shop_2',
        rating: 4.7,
        weight: '1kg bunch',
      ),
      const ProductModel(
        id: 'fruit_2',
        title: 'Red Apples',
        description: 'Crisp and sweet apples',
        price: '\$5',
        imagePath: ImagePath.groceryIcon,
        categoryId: '2',
        subcategoryId: 'produce_fruits',
        shopId: 'shop_2',
        rating: 4.8,
        weight: '1kg',
      ),
      const ProductModel(
        id: 'fruit_3',
        title: 'Fresh Oranges',
        description: 'Juicy citrus oranges',
        price: '\$4',
        imagePath: ImagePath.groceryIcon,
        categoryId: '2',
        subcategoryId: 'produce_fruits',
        shopId: 'shop_2',
        rating: 4.6,
        weight: '1kg',
      ),

      // Add more products for other subcategories as needed
      // Herbs
      const ProductModel(
        id: 'herb_1',
        title: 'Fresh Mint',
        description: 'Aromatic mint leaves',
        price: '\$1',
        imagePath: ImagePath.groceryIcon,
        categoryId: '2',
        subcategoryId: 'produce_herbs',
        shopId: 'shop_2',
        rating: 4.4,
        weight: '50g bunch',
      ),
      const ProductModel(
        id: 'herb_2',
        title: 'Coriander Leaves',
        description: 'Fresh cilantro',
        price: '\$1',
        imagePath: ImagePath.groceryIcon,
        categoryId: '2',
        subcategoryId: 'produce_herbs',
        shopId: 'shop_2',
        rating: 4.5,
        weight: '100g bunch',
      ),

      // Regular food items without specific subcategories (matches existing home service)
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
        description: 'A delicious grilled chicken sandwich.',
        price: '\$16',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_sandwich',
        shopId: 'shop_1',
        isFavorite: false,
        rating: 4.6,
        weight: '1 sandwich',
      ),
      const ProductModel(
        id: 'food_6',
        title: 'Indian Pan Biryani',
        description: 'Traditional Indian biryani with aromatic spices.',
        price: '\$18',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_biryani',
        shopId: 'shop_1',
        rating: 4.8,
        weight: '2 portions',
      ),
      const ProductModel(
        id: 'food_4',
        title: 'Tandoori Chicken Pizza',
        description: 'Indian style pizza with tandoori chicken.',
        price: '\$22',
        imagePath: ImagePath.foodIcon,
        categoryId: '1',
        subcategoryId: 'food_pizza',
        shopId: 'shop_2',
        rating: 4.7,
        weight: 'Large size',
      ),

      // Regular grocery items
      const ProductModel(
        id: 'grocery_1',
        title: 'Organic Milk - Amul Fresh',
        description: 'Fresh organic milk',
        price: '\$5',
        imagePath: ImagePath.groceryIcon,
        categoryId: '2',
        subcategoryId: 'cooking_dairy', // Example cooking subcategory
        shopId: 'shop_2',
        rating: 4.6,
        weight: '1 liter',
      ),
      const ProductModel(
        id: 'grocery_2',
        title: 'Bread Slice - Brown Bread',
        description: 'Healthy brown bread',
        price: '\$3',
        imagePath: ImagePath.groceryIcon,
        categoryId: '2',
        subcategoryId: 'cooking_bakery', // Example cooking subcategory
        shopId: 'shop_2',
        rating: 4.4,
        weight: '400g pack',
      ),
      const ProductModel(
        id: 'grocery_3',
        title: 'Chicken Breast',
        description: 'Fresh chicken breast',
        price: '\$12',
        imagePath: ImagePath.groceryIcon,
        categoryId: '2',
        subcategoryId: 'meats_chicken', // Example meat subcategory
        shopId: 'shop_1',
        rating: 4.7,
        weight: '1kg',
      ),
      const ProductModel(
        id: 'grocery_4',
        title: 'Olive Oil - Extra Virgin',
        description: 'Premium olive oil',
        price: '\$18',
        imagePath: ImagePath.groceryIcon,
        categoryId: '2',
        subcategoryId: 'oils_olive', // Example oil subcategory
        shopId: 'shop_2',
        rating: 4.8,
        weight: '500ml',
      ),

      // Medicine products
      const ProductModel(
        id: 'medicine_1',
        title: 'Paracetamol 500mg',
        description: 'Pain relief tablets',
        price: '\$8',
        imagePath: ImagePath.medicineIcon,
        categoryId: '3',
        subcategoryId: 'medicine_otc',
        shopId: 'shop_1',
        rating: 4.7,
        weight: '20 tablets',
      ),
      const ProductModel(
        id: 'medicine_2',
        title: 'Vitamin D3',
        description: 'Essential vitamin supplement',
        price: '\$15',
        imagePath: ImagePath.medicineIcon,
        categoryId: '3',
        subcategoryId: 'medicine_vitamins',
        shopId: 'shop_1',
        rating: 4.8,
        weight: '60 capsules',
      ),
      const ProductModel(
        id: 'medicine_3',
        title: 'First Aid Kit',
        description: 'Complete first aid supplies',
        price: '\$25',
        imagePath: ImagePath.medicineIcon,
        categoryId: '3',
        subcategoryId: 'medicine_firstaid',
        shopId: 'shop_2',
        rating: 4.9,
        weight: '1 kit',
      ),

      // Cleaning products
      const ProductModel(
        id: 'cleaning_1',
        title: 'All-Purpose Cleaner',
        description: 'Multi-surface cleaning solution',
        price: '\$6',
        imagePath: ImagePath.cleaningIcon,
        categoryId: '4',
        subcategoryId: 'cleaning_household',
        shopId: 'shop_1',
        rating: 4.5,
        weight: '500ml',
      ),
      const ProductModel(
        id: 'cleaning_2',
        title: 'Bathroom Cleaner',
        description: 'Powerful bathroom cleaning spray',
        price: '\$7',
        imagePath: ImagePath.cleaningIcon,
        categoryId: '4',
        subcategoryId: 'cleaning_bathroom',
        shopId: 'shop_2',
        rating: 4.6,
        weight: '750ml',
      ),
      const ProductModel(
        id: 'cleaning_3',
        title: 'Dish Soap',
        description: 'Gentle yet effective dish cleaning',
        price: '\$4',
        imagePath: ImagePath.cleaningIcon,
        categoryId: '4',
        subcategoryId: 'cleaning_kitchen',
        shopId: 'shop_1',
        rating: 4.4,
        weight: '500ml',
      ),

      // Personal Care products
      const ProductModel(
        id: 'personal_1',
        title: 'Face Moisturizer',
        description: 'Hydrating daily moisturizer',
        price: '\$18',
        imagePath: ImagePath.personalCareIcon,
        categoryId: '5',
        subcategoryId: 'personal_skincare',
        shopId: 'shop_1',
        rating: 4.7,
        weight: '100ml',
      ),
      const ProductModel(
        id: 'personal_2',
        title: 'Shampoo',
        description: 'Nourishing hair shampoo',
        price: '\$12',
        imagePath: ImagePath.personalCareIcon,
        categoryId: '5',
        subcategoryId: 'personal_haircare',
        shopId: 'shop_2',
        rating: 4.5,
        weight: '400ml',
      ),
      const ProductModel(
        id: 'personal_3',
        title: 'Toothpaste',
        description: 'Whitening toothpaste',
        price: '\$5',
        imagePath: ImagePath.personalCareIcon,
        categoryId: '5',
        subcategoryId: 'personal_oral',
        shopId: 'shop_1',
        rating: 4.6,
        weight: '100g',
      ),

      // Pet Supplies products
      const ProductModel(
        id: 'pet_1',
        title: 'Dog Food - Premium',
        description: 'High-quality dog food',
        price: '\$35',
        imagePath: ImagePath.petSuppliesIcon,
        categoryId: '6',
        subcategoryId: 'pet_food',
        shopId: 'shop_1',
        rating: 4.8,
        weight: '5kg',
      ),
      const ProductModel(
        id: 'pet_2',
        title: 'Cat Toy Ball',
        description: 'Interactive toy for cats',
        price: '\$8',
        imagePath: ImagePath.petSuppliesIcon,
        categoryId: '6',
        subcategoryId: 'pet_toys',
        shopId: 'shop_2',
        rating: 4.6,
        weight: '1 piece',
      ),
      const ProductModel(
        id: 'pet_3',
        title: 'Pet Shampoo',
        description: 'Gentle pet grooming shampoo',
        price: '\$14',
        imagePath: ImagePath.petSuppliesIcon,
        categoryId: '6',
        subcategoryId: 'pet_grooming',
        shopId: 'shop_1',
        rating: 4.7,
        weight: '250ml',
      ),

      // Custom products
      const ProductModel(
        id: 'custom_1',
        title: 'Wireless Headphones',
        description: 'Bluetooth wireless headphones',
        price: '\$89',
        imagePath: ImagePath.customIcon,
        categoryId: '7',
        subcategoryId: 'custom_electronics',
        shopId: 'shop_1',
        rating: 4.8,
        weight: '1 piece',
      ),
      const ProductModel(
        id: 'custom_2',
        title: 'Mystery Novel',
        description: 'Bestselling mystery book',
        price: '\$15',
        imagePath: ImagePath.customIcon,
        categoryId: '7',
        subcategoryId: 'custom_books',
        shopId: 'shop_2',
        rating: 4.6,
        weight: '1 book',
      ),
      const ProductModel(
        id: 'custom_3',
        title: 'Gift Basket',
        description: 'Assorted gift basket',
        price: '\$45',
        imagePath: ImagePath.customIcon,
        categoryId: '7',
        subcategoryId: 'custom_gifts',
        shopId: 'shop_1',
        rating: 4.9,
        weight: '1 basket',
      ),
    ];
  }
}

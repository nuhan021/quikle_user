import 'dart:async';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/categories/data/models/subcategory_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';

class CategoryService {
  final ProductDataService _productService = ProductDataService();

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
        // Cooking subcategories
        return fetchCookingSubcategories();
      } else if (parentSubcategoryId == 'grocery_meats') {
        // Meats subcategories
        return fetchMeatsSubcategories();
      } else if (parentSubcategoryId == 'grocery_oils') {
        // Oils subcategories
        return fetchOilsSubcategories();
      } else if (parentSubcategoryId == 'grocery_dairy') {
        // Dairy subcategories
        return fetchDairySubcategories();
      } else if (parentSubcategoryId == 'grocery_grains') {
        // Grains subcategories
        return fetchGrainsSubcategories();
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

  // Cooking subcategories (second level - under Cooking)
  Future<List<SubcategoryModel>> fetchCookingSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'cooking_spices',
        title: 'Spices',
        description: 'Herbs and spices',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_cooking',
      ),
      const SubcategoryModel(
        id: 'cooking_condiments',
        title: 'Condiments',
        description: 'Sauces and condiments',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_cooking',
      ),
      const SubcategoryModel(
        id: 'cooking_baking',
        title: 'Baking',
        description: 'Baking ingredients',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_cooking',
      ),
      const SubcategoryModel(
        id: 'cooking_canned',
        title: 'Canned Foods',
        description: 'Canned and preserved foods',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_cooking',
      ),
    ];
  }

  // Meats subcategories (second level - under Meats)
  Future<List<SubcategoryModel>> fetchMeatsSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'meats_chicken',
        title: 'Chicken',
        description: 'Fresh chicken and poultry',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_meats',
      ),
      const SubcategoryModel(
        id: 'meats_beef',
        title: 'Beef',
        description: 'Fresh beef cuts',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_meats',
      ),
      const SubcategoryModel(
        id: 'meats_fish',
        title: 'Fish & Seafood',
        description: 'Fresh fish and seafood',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_meats',
      ),
      const SubcategoryModel(
        id: 'meats_processed',
        title: 'Processed Meats',
        description: 'Sausages, bacon, and deli meats',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_meats',
      ),
    ];
  }

  // Oils subcategories (second level - under Oils)
  Future<List<SubcategoryModel>> fetchOilsSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'oils_cooking',
        title: 'Cooking Oils',
        description: 'Cooking and frying oils',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_oils',
      ),
      const SubcategoryModel(
        id: 'oils_olive',
        title: 'Olive Oil',
        description: 'Extra virgin and regular olive oil',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_oils',
      ),
      const SubcategoryModel(
        id: 'oils_specialty',
        title: 'Specialty Oils',
        description: 'Coconut, sesame, and other specialty oils',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_oils',
      ),
      const SubcategoryModel(
        id: 'oils_vinegar',
        title: 'Vinegar',
        description: 'Cooking vinegars and dressings',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_oils',
      ),
    ];
  }

  // Dairy subcategories (second level - under Dairy)
  Future<List<SubcategoryModel>> fetchDairySubcategories() async {
    return [
      const SubcategoryModel(
        id: 'dairy_milk',
        title: 'Milk',
        description: 'Fresh milk and alternatives',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_dairy',
      ),
      const SubcategoryModel(
        id: 'dairy_cheese',
        title: 'Cheese',
        description: 'Various types of cheese',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_dairy',
      ),
      const SubcategoryModel(
        id: 'dairy_yogurt',
        title: 'Yogurt',
        description: 'Greek yogurt, regular yogurt',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_dairy',
      ),
      const SubcategoryModel(
        id: 'dairy_eggs',
        title: 'Eggs',
        description: 'Fresh eggs and egg products',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_dairy',
      ),
    ];
  }

  // Grains subcategories (second level - under Grains)
  Future<List<SubcategoryModel>> fetchGrainsSubcategories() async {
    return [
      const SubcategoryModel(
        id: 'grains_rice',
        title: 'Rice',
        description: 'Basmati, jasmine, and other rice varieties',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_grains',
      ),
      const SubcategoryModel(
        id: 'grains_flour',
        title: 'Flour',
        description: 'Wheat, almond, and specialty flours',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_grains',
      ),
      const SubcategoryModel(
        id: 'grains_cereal',
        title: 'Cereals',
        description: 'Breakfast cereals and oats',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_grains',
      ),
      const SubcategoryModel(
        id: 'grains_pasta',
        title: 'Pasta',
        description: 'Dried pasta and noodles',
        iconPath: ImagePath.groceryIcon,
        categoryId: '2',
        parentSubcategoryId: 'grocery_grains',
      ),
    ];
  }

  // Get products by subcategory
  Future<List<ProductModel>> fetchProductsBySubcategory(
    String subcategoryId,
  ) async {
    return _productService.getProductsBySubcategory(subcategoryId);
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
    return _productService.getFeaturedProducts(categoryId);
  }

  // Get recommended products for a category
  Future<List<ProductModel>> fetchRecommendedProducts(String categoryId) async {
    return _productService.getRecommendedProducts(categoryId);
  }

  // Get all products for a main category (like all produce items)
  Future<List<ProductModel>> fetchProductsByMainCategory(
    String mainCategoryId,
  ) async {
    return _productService.getProductsByMainCategory(mainCategoryId);
  }

  // Get all products for a category (for non-grocery categories)
  Future<List<ProductModel>> fetchAllProductsByCategory(
    String categoryId,
  ) async {
    return _productService.getProductsByCategory(categoryId);
  }
}

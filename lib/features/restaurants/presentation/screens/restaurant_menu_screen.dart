import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/common/widgets/floating_cart_button.dart';
import 'package:quikle_user/core/data/services/product_data_service.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import 'package:quikle_user/features/restaurants/data/models/restaurant_model.dart';
import 'package:quikle_user/features/categories/presentation/widgets/category_product_item.dart';

class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({super.key});

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  final ProductDataService _productService = ProductDataService();
  List<ProductModel> _categoryProducts = [];
  List<ProductModel> _allRestaurantProducts = [];
  bool _isLoading = true;

  late RestaurantModel restaurant;
  late String categoryId;
  late String categoryName;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    final arguments = Get.arguments as Map<String, dynamic>;
    restaurant = arguments['restaurant'];
    categoryId = arguments['categoryId'] ?? '';
    categoryName = arguments['categoryName'] ?? '';

    _loadProducts();
  }

  void _loadProducts() {
    setState(() => _isLoading = true);

    // Get all products from this restaurant
    _allRestaurantProducts = _productService.allProducts
        .where((product) => product.shopId == restaurant.id)
        .toList();

    // Filter products by category if specified
    if (categoryId.isNotEmpty) {
      _categoryProducts = _allRestaurantProducts
          .where((product) => product.subcategoryId == categoryId)
          .toList();
    } else {
      _categoryProducts = _allRestaurantProducts;
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.homeGrey,
        body: Stack(
          children: [
            Column(
              children: [
                // Custom App Bar with Restaurant Info
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 16.w,
                    right: 16.w,
                    bottom: 16.h,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: AppColors.ebonyBlack,
                              size: 24.sp,
                            ),
                            onPressed: () => Get.back(),
                          ),
                          Expanded(
                            child: Text(
                              restaurant.name,
                              style: getTextStyle(
                                font: CustomFonts.obviously,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ebonyBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 48.w), // Balance the back button
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Restaurant details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16.sp,
                            color: AppColors.beakYellow,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            restaurant.rating.toString(),
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ebonyBlack,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Icon(
                            Icons.access_time,
                            size: 16.sp,
                            color: AppColors.featherGrey,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            restaurant.deliveryTime,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.featherGrey,
                            ),
                          ),
                        ],
                      ),

                      if (categoryName.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.beakYellow.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            categoryName,
                            style: getTextStyle(
                              font: CustomFonts.inter,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ebonyBlack,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _categoryProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: 64.sp,
                                color: AppColors.featherGrey,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                categoryName.isNotEmpty
                                    ? 'No $categoryName items'
                                    : 'No menu items',
                                style: getTextStyle(
                                  font: CustomFonts.obviously,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.featherGrey,
                                ),
                              ),
                              Text(
                                'available at this restaurant',
                                style: getTextStyle(
                                  font: CustomFonts.inter,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.featherGrey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Section title
                              Text(
                                categoryName.isNotEmpty
                                    ? '$categoryName Menu (${_categoryProducts.length} items)'
                                    : 'Menu (${_categoryProducts.length} items)',
                                style: getTextStyle(
                                  font: CustomFonts.obviously,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ebonyBlack,
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // Products grid
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12.w,
                                        mainAxisSpacing: 12.h,
                                        childAspectRatio: 0.75,
                                      ),
                                  itemCount: _categoryProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = _categoryProducts[index];
                                    return CategoryProductItem(
                                      product: product,
                                      onTap: () {
                                        // Navigate to product details
                                        Get.toNamed(
                                          '/product-details',
                                          arguments: {'product': product},
                                        );
                                      },
                                      onAddToCart: () {
                                        // Add to cart logic
                                        Get.snackbar(
                                          'Added to Cart',
                                          '${product.title} added to your cart',
                                          snackPosition: SnackPosition.BOTTOM,
                                          duration: const Duration(seconds: 2),
                                        );
                                      },
                                      onFavoriteToggle: () {
                                        // Toggle favorite logic
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),

            // Floating Cart Button
            const FloatingCartButton(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/common/widgets/voice_search_overlay.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import '../../controllers/home_controller.dart';
import '../widgets/app_bar/home_app_bar.dart';
import '../widgets/banners/offer_banner.dart';
import '../widgets/categories/categories_section.dart';
import '../widgets/products/product_section.dart';
import '../widgets/search/search_bar.dart' as custom_search;
import '../widgets/prescription_status_indicator.dart';

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({super.key});

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen>
    with SingleTickerProviderStateMixin {
  final HomeController controller = Get.find<HomeController>();
  final ScrollController _scroll = ScrollController();

  late final AnimationController _barAnim;

  @override
  void initState() {
    super.initState();

    _barAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1,
    );

    _scroll.addListener(() {
      if (_scroll.offset > 8 && _barAnim.value == 1) {
        _barAnim.reverse();
      } else if (_scroll.offset <= 8 && _barAnim.value == 0) {
        _barAnim.forward();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _barAnim.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Refresh both home data and prescription data
    await Future.wait([
      controller.refreshData(),
      Get.find<PrescriptionController>().refreshData(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                ClipRect(
                  child: SizeTransition(
                    axisAlignment: -1,
                    sizeFactor: _barAnim,
                    child: HomeAppBar(
                      //onNotificationTap: controller.onNotificationPressed,
                    ),
                  ),
                ),

                Column(
                  children: [
                    custom_search.SearchBar(
                      onTap: controller.onSearchPressed,
                      onVoiceTap: controller.onVoiceSearchPressed,
                    ),
                    //12.verticalSpace,
                    CategoriesSection(
                      categories: controller.categories,
                      onCategoryTap: controller.onCategoryPressed,
                      selectedCategoryId: controller.selectedCategoryId,
                      showTitle: true,
                    ),
                  ],
                ),
                Expanded(
                  child: Obx(
                    () => controller.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: _onRefresh,
                            color: AppColors.primary,
                            child: ListView(
                              controller: _scroll,
                              padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                              children: [
                                // Prescription Status Indicator
                                const PrescriptionStatusIndicator(),
                                8.verticalSpace,
                                Center(child: OfferBanner()),
                                12.verticalSpace,
                                if (controller.isShowingAllCategories)
                                  ...controller.productSections.map(
                                    (section) => ProductSection(
                                      section: section,
                                      onProductTap: controller.onProductPressed,
                                      onAddToCart:
                                          controller.onAddToCartPressed,
                                      onViewAllTap: () => controller
                                          .onViewAllPressed(section.categoryId),
                                      categoryIconPath: controller
                                          .getCategoryIconPath(
                                            section.categoryId,
                                          ),
                                      categoryTitle: controller
                                          .getCategoryTitle(section.categoryId),
                                      onFavoriteToggle:
                                          controller.onFavoriteToggle,
                                    ),
                                  )
                                else
                                  _buildFilteredSection(),
                              ],
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),

          // Voice search overlay
          Obx(() {
            if (!controller.isListening) return const SizedBox.shrink();
            return VoiceSearchOverlay(
              soundLevel: controller.soundLevel,
              onCancel: controller.stopVoiceSearch,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilteredSection() {
    if (controller.filteredProducts.isEmpty) {
      return const Center(
        child: Text(
          'No products found for this category',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final selectedCat = controller.categories.firstWhere(
      (c) => c.id == controller.selectedCategoryId,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedCat.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    controller.onViewAllPressed(controller.selectedCategoryId),
                child: const Text(
                  'View all',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,

          // ...controller.filteredProducts.map(
          //   (prod) => ProductSection(
          //     section: prod,
          //     onProductTap: controller.onProductPressed,
          //     onAddToCart: controller.onAddToCartPressed,
          //     onFavoriteToggle: controller.onFavoriteToggle,
          //   ),
          // ),
        ],
      ),
    );
  }
}

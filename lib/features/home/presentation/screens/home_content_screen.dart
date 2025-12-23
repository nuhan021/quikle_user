import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/common/widgets/voice_search_overlay.dart';
import 'package:quikle_user/features/prescription/controllers/prescription_controller.dart';
import 'package:quikle_user/core/common/widgets/product_card_shimmer.dart';
import 'package:quikle_user/core/common/widgets/category_shimmer.dart';
import '../../controllers/home_controller.dart';
import '../widgets/app_bar/home_app_bar.dart';
import '../widgets/banners/offer_banner.dart';
import '../widgets/categories/categories_section.dart';
import '../widgets/products/product_section.dart';
import '../widgets/search/search_bar.dart' as custom_search;
import '../widgets/prescription_status_indicator.dart';
import '../../../../core/common/widgets/slivers/fixed_widget_header_delegate.dart';

class HomeContentScreen extends StatefulWidget {
  const HomeContentScreen({super.key});

  @override
  State<HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  final HomeController controller = Get.find<HomeController>();
  final ScrollController _scroll = ScrollController();
  final PrescriptionController _prescriptionController =
      Get.find<PrescriptionController>();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Refresh both home data and prescription data
    await Future.wait([
      controller.refreshData(),
      _prescriptionController.refreshData(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    controller.saveFCMToken();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    final double categoriesHeaderHeight = CategoriesSection.kHeight + 32.h;
    final double searchBarHeight = custom_search.SearchBar.kPreferredHeight;
    final double baseFiltersHeaderHeight =
        searchBarHeight + categoriesHeaderHeight;

    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: Stack(
        children: [
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              child: CustomScrollView(
                controller: _scroll,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(child: const HomeAppBar()),
                  Obx(() {
                    final bool hasIndicator =
                        PrescriptionStatusIndicator.hasVisibleStatus(
                          _prescriptionController.prescriptions,
                        );
                    final double filtersHeaderHeight =
                        baseFiltersHeaderHeight +
                        (hasIndicator
                            ? PrescriptionStatusIndicator.kPreferredHeight
                            : 0);

                    return SliverPersistentHeader(
                      pinned: true,
                      delegate: FixedWidgetHeaderDelegate(
                        minExtent: filtersHeaderHeight,
                        maxExtent: filtersHeaderHeight,
                        backgroundColor: AppColors.homeGrey,
                        shouldAddElevation: true,
                        enableGlassEffect: true,
                        blurSigma: 10.0,
                        builder: (context, shrinkOffset, overlapsContent) {
                          return SizedBox(
                            height: filtersHeaderHeight,
                            child: Container(
                              color: Colors.transparent,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    custom_search.SearchBar(
                                      onTap: controller.onSearchPressed,
                                      onVoiceTap:
                                          controller.onVoiceSearchPressed,
                                    ),
                                    Obx(() {
                                      if (controller.isLoading) {
                                        return const CategoryShimmer(
                                          itemCount: 6,
                                        );
                                      }
                                      return CategoriesSection(
                                        categories: controller.categories,
                                        onCategoryTap:
                                            controller.onCategoryPressed,
                                        selectedCategoryId:
                                            controller.selectedCategoryId,
                                        showTitle: true,
                                      );
                                    }),
                                    if (hasIndicator)
                                      const PrescriptionStatusIndicator(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  Obx(() {
                    if (controller.isLoading) {
                      return SliverPadding(
                        padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            Center(child: OfferBanner()),
                            12.verticalSpace,
                            // Show shimmer for 6 product sections
                            const ProductSectionShimmer(isMedicine: false),
                            const ProductSectionShimmer(isMedicine: false),
                            const ProductSectionShimmer(isMedicine: true),
                            const ProductSectionShimmer(isMedicine: false),
                            const ProductSectionShimmer(isMedicine: false),
                            const ProductSectionShimmer(isMedicine: false),
                            SizedBox(height: 50.h),
                          ]),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Center(child: OfferBanner()),
                          12.verticalSpace,
                          if (controller.isShowingAllCategories)
                            ...controller.productSections.map(
                              (section) => ProductSection(
                                section: section,
                                onProductTap: controller.onProductPressed,
                                onAddToCart: controller.onAddToCartPressed,
                                onViewAllTap: () => controller.onViewAllPressed(
                                  section.categoryId,
                                ),
                                categoryIconPath: controller
                                    .getCategoryIconPath(section.categoryId),
                                categoryTitle: controller.getCategoryTitle(
                                  section.categoryId,
                                ),
                                onFavoriteToggle: controller.onFavoriteToggle,
                              ),
                            )
                          else
                            _buildFilteredSection(),
                          SizedBox(height: 50.h),
                        ]),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
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

// SearchScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/common/styles/global_text_style.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/core/utils/constants/enums/font_enum.dart';
import 'package:quikle_user/core/utils/constants/image_path.dart';
import 'package:quikle_user/features/search/controllers/search_controller.dart';
import 'package:quikle_user/core/common/widgets/unified_product_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductSearchController controller = Get.put(
      ProductSearchController(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.ebonyBlack),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Search Products',
          style: getTextStyle(
            font: CustomFonts.obviously,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.ebonyBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar Section
              Container(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 16.w),
                            Icon(Icons.search, color: Colors.grey, size: 20.w),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Obx(
                                () => TextField(
                                  controller: controller.searchController,
                                  onChanged: controller.onSearchChanged,
                                  decoration: InputDecoration(
                                    hintText:
                                        controller.currentPlaceholder.value,
                                    hintStyle: getTextStyle(
                                      font: CustomFonts.inter,
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                  style: getTextStyle(
                                    font: CustomFonts.inter,
                                    fontSize: 16,
                                    color: AppColors.ebonyBlack,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Obx(
                              () => GestureDetector(
                                onTap: controller.toggleVoiceRecognition,
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: controller.isListening
                                        ? AppColors.primary.withOpacity(0.1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Image.asset(
                                    ImagePath.voiceIcon,
                                    height: 20.w,
                                    width: 20.w,
                                    color: controller.isListening
                                        ? AppColors.primary
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Recent Searches or Search Results
              Expanded(
                child: Obx(() {
                  if (controller.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (controller.searchQuery.isEmpty) {
                    return _buildSuggestionsView(controller);
                  } else {
                    return _buildSearchResults(controller);
                  }
                }),
              ),
            ],
          ),

          // Listening popup overlay
          Obx(() {
            if (!controller.isListening) return const SizedBox.shrink();
            return Container(
              color: Colors.black.withOpacity(0.25),
              alignment: Alignment.center,
              child: _ListeningPopup(
                soundLevel: controller.soundLevel.value,
                onCancel: () async {
                  await controller.toggleVoiceRecognition();
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSuggestionsView(ProductSearchController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (controller.recentSearches.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Searches',
                        style: getTextStyle(
                          font: CustomFonts.obviously,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ebonyBlack,
                        ),
                      ),
                      TextButton(
                        onPressed: controller.clearRecentSearches,
                        child: Text(
                          'Clear All',
                          style: getTextStyle(
                            font: CustomFonts.inter,
                            fontSize: 14.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ...controller.recentSearches.map(
                    (search) => _buildSearchSuggestion(
                      search,
                      controller,
                      Icons.history,
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              );
            }
            return const SizedBox();
          }),
          Text(
            'Popular Searches',
            style: getTextStyle(
              font: CustomFonts.obviously,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.ebonyBlack,
            ),
          ),
          SizedBox(height: 12.h),
          ...controller.popularSearches.map(
            (search) =>
                _buildSearchSuggestion(search, controller, Icons.trending_up),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestion(
    String suggestion,
    ProductSearchController controller,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () => controller.selectSuggestion(suggestion),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 20.w, color: Colors.grey),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                suggestion,
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  color: AppColors.ebonyBlack,
                ),
              ),
            ),
            Icon(Icons.north_west, size: 16.w, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(ProductSearchController controller) {
    return Obx(() {
      if (controller.searchResults.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64.w, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              Text(
                'No results found',
                style: getTextStyle(
                  font: CustomFonts.obviously,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ebonyBlack,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Try searching for something else',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Text(
              '${controller.searchResults.length} results found',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.75,
              ),
              itemCount: controller.searchResults.length,
              itemBuilder: (context, index) {
                final product = controller.searchResults[index];
                return UnifiedProductCard(
                  product: product,
                  onTap: () => controller.onProductPressed(product),
                  onAddToCart: () => controller.onAddToCartPressed(product),
                  onFavoriteToggle: () => controller.onFavoriteToggle(product),
                  variant: ProductCardVariant.category,
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

class _ListeningPopup extends StatefulWidget {
  final double soundLevel;
  final VoidCallback onCancel;
  const _ListeningPopup({required this.soundLevel, required this.onCancel});

  @override
  State<_ListeningPopup> createState() => _ListeningPopupState();
}

class _ListeningPopupState extends State<_ListeningPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.96, end: 1.04).animate(_pulse);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double dynamicSize = 80.w + (widget.soundLevel.clamp(0, 1) * 40.w);

    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 220.w,
        height: 220.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 28,
              spreadRadius: 8,
            ),
          ],
          border: Border.all(
            color: AppColors.primary.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: dynamicSize,
              height: dynamicSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.18),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: Icon(Icons.mic, size: 56.w, color: AppColors.primary),
            ),
            SizedBox(height: 14.h),
            Text(
              'Listening...',
              style: getTextStyle(
                font: CustomFonts.inter,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.ebonyBlack,
              ),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: widget.onCancel,
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              child: Text(
                'Tap to stop',
                style: getTextStyle(
                  font: CustomFonts.inter,
                  fontSize: 13.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

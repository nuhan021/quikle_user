import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_user/core/utils/constants/colors.dart';
import 'package:quikle_user/features/categories/controllers/categories_screen_controller.dart';
import 'package:quikle_user/features/profile/presentation/widgets/unified_profile_app_bar.dart';
import 'package:quikle_user/features/categories/presentation/widgets/subcategory_grid_section.dart';
import 'package:quikle_user/features/categories/presentation/widgets/category_screen_shimmer.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoriesScreenController controller = Get.put(
    CategoriesScreenController(),
  );
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeGrey,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          slivers: [
            const SliverToBoxAdapter(
              child: UnifiedProfileAppBar(
                title: 'All Categories',
                showBackButton: false,
              ),
            ),
            Obx(() {
              if (controller.isLoading) {
                return SliverPadding(
                  padding: EdgeInsets.only(bottom: 100.h, top: 8.h),
                  sliver: const SliverToBoxAdapter(
                    child: CategoriesScreenShimmer(),
                  ),
                );
              }

              // Show all subcategories grouped by category
              final groupedSubcategories = controller.groupedSubcategories;

              if (groupedSubcategories.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No categories found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.only(bottom: 100.h, top: 8.h),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final categoryId = groupedSubcategories.keys.elementAt(
                      index,
                    );
                    final subcategories = groupedSubcategories[categoryId]!;
                    final categoryTitle =
                        controller.getCategoryTitle(categoryId) ?? '';
                    final categoryIconPath =
                        controller.getCategoryIconPath(categoryId) ?? '';

                    return SubcategoryGridSection(
                      categoryTitle: categoryTitle,
                      categoryIconPath: categoryIconPath,
                      subcategories: subcategories,
                      onSubcategoryTap: controller.onSubcategoryPressed,
                      onViewAllTap: () =>
                          controller.onViewAllPressed(categoryId),
                    );
                  }, childCount: groupedSubcategories.length),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

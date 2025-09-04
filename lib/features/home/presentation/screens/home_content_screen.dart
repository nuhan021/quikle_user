import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quikle_user/features/home/data/models/category_model.dart';
import 'package:quikle_user/features/home/data/models/product_model.dart';
import '../widgets/widgets.dart';
import '../widgets/search_bar.dart' as custom_search;
import '../../controllers/home_controller.dart';

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFF0F0F0),
          appBar: HomeAppBar(
            onNotificationTap: controller.onNotificationPressed,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                custom_search.SearchBar(onTap: controller.onSearchPressed),

                // Categories Section
                FutureBuilder<List<CategoryModel>>(
                  future: controller.fetchCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return CategoriesSection(
                        categories: snapshot.data!,
                        onCategoryTap: controller.onCategoryPressed,
                      );
                    }
                    return const Center(
                      child: Text('No categories available.'),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Big Offer Banner
                Center(child: OfferBanner()),

                const SizedBox(height: 24),

                // Product Sections
                FutureBuilder<List<ProductSectionModel>>(
                  future: controller.fetchProductSections(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!
                            .map(
                              (section) => ProductSection(
                                section: section,
                                onProductTap: controller.onProductPressed,
                                onAddToCart: controller.onAddToCartPressed,
                                onViewAllTap: () =>
                                    controller.onViewAllPressed(section.title),
                              ),
                            )
                            .toList(),
                      );
                    }
                    return const Center(
                      child: Text('No product sections available.'),
                    );
                  },
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

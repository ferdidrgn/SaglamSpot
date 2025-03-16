import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/domain/entities/product.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_category.dart';
import '../../../core/widgets/custom_decorated_card.dart';
import '../../../core/widgets/custom_product_card.dart';
import '../../../core/widgets/custom_search.dart';
import '../../../core/widgets/custom_title.dart';
import '../../../data/providers/product/product_provider.dart';
import '../search_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final productState = ref.watch(productProvider);

    return productState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : productState.errorMessage != null
        ? _buildErrorState(productState.errorMessage!)
        : _buildContentState(context, productState.products);
  }

  Widget _buildErrorState(final String message) {
    return Center(child: Text(message));
  }

  Widget _buildContentState(final BuildContext context,
      final List<Product> products) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          CustomSearchBar(onSearchTap: () => _navigateToSearch(context)),
          const SizedBox(height: 20),
          _buildCategorySection(),
          const SizedBox(height: 20),
          CustomDecoratedCard(
            title: 'Evinizi Güzelleştirin',
            content: 'Kaliteli ve şık mobilyalarla yaşam alanınızı yenileyin',
            color: Colors.brown[200]!,
            imageUrl: 'assets/images/bicycle_france.jpg',
          ),
          const SizedBox(height: 20),
          _buildProductSection(
            'Yeni Gelen Ürünlerimiz',
            products.where((final p) => !p.isSold).toList(),
          ),
          const SizedBox(height: 20),
          _buildProductSection(
            'Satılmış Ürünlerimiz (3 Ay İçinde)',
            products.where((final p) => p.isSold).toList(),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final ScrollController scrollController = ScrollController();

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomSectionTitle(title: "Kategoriler"),
          SizedBox(
            height: 100,
            child: Row(
              children: [
                _buildScrollButton(scrollController, -1),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    children: const [
                      CustomCategory(icon: Icons.chair, label: "Sandalye"),
                      CustomCategory(icon: Icons.weekend, label: "Kanepe"),
                      CustomCategory(icon: Icons.bed, label: "Yatak"),
                      CustomCategory(icon: Icons.table_chart, label: "Masa"),
                      CustomCategory(icon: Icons.tv, label: "TV Ünitesi"),
                    ],
                  ),
                ),
                _buildScrollButton(scrollController, 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection(final String title,
      final List<Product> products) {
    final ScrollController scrollController = ScrollController();

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(174, 101, 41, 0.8),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSectionTitle(title: title),
          SizedBox(
            height: 400,
            child: Row(
              children: [
                _buildScrollButton(scrollController, -1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (final context, final index) {
                      return Container(
                        width: 300,
                        margin: const EdgeInsets.only(right: 16),
                        child: ProductCard(product: products[index]),
                      );
                    },
                  ),
                ),
                _buildScrollButton(scrollController, 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollButton(final ScrollController controller,
      final int direction) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          direction == -1 ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
          color: AppColors.primary,
        ),
        onPressed: () => _scrollList(controller, direction),
      ),
    );
  }

  void _scrollList(final ScrollController controller, final int direction) {
    const double scrollAmount = 300;
    final double offset = controller.offset + (direction * scrollAmount);
    controller.animateTo(
      offset.clamp(0.0, controller.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _navigateToSearch(final BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (final context) => const SearchPage()),
    );
  }
}

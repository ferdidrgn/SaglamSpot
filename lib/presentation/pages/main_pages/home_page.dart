import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_product_card.dart';
import '../../../core/widgets/custom_search.dart';
import '../../../core/widgets/custom_title.dart';
import '../../bloc/product_bloc.dart';
import '../search_page.dart';
import 'package:saglamspot/domain/entities/product.dart';
import '../../../core/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          return _buildContent(state.products);
        } else if (state is ProductError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildContent(List<Product> products) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: CustomSearchBar(onSearchTap: _navigateToSearch),
          ),
          const SizedBox(height: 20),
          _buildHeroSection(),
          const SizedBox(height: 20),
          _buildProductSection('Yeni Gelen Ürünlerimiz', products.where((p) => !p.isSold).toList()),
          _buildProductSection('Satılmış Ürünlerimiz (3 Ay İçinde)', products.where((p) => p.isSold).toList()),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Evinizi Güzelleştirin',
            style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Kaliteli ve şık mobilyalarla yaşam alanınızı yenileyin',
            style: TextStyle(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.lightTheme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Hemen Keşfet'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection(String title, List<Product> products) {
    final ScrollController scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
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
                    itemBuilder: (context, index) {
                      return Container(
                        width: 300,
                        padding: const EdgeInsets.only(right: 16),
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

  Widget _buildScrollButton(ScrollController controller, int direction) {
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
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
        onPressed: () => _scrollList(controller, direction),
      ),
    );
  }

  void _scrollList(ScrollController controller, int direction) {
    const double scrollAmount = 300;
    final double offset = controller.offset + (direction * scrollAmount);
    controller.animateTo(
      offset.clamp(0.0, controller.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPage()),
    );
  }
}
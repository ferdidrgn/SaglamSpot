import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_decorated_card.dart';
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
          return Container(
            padding: const EdgeInsets.all(50),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
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
          CustomDecoratedCard(
            title: 'Evinizi Güzelleştirin',
            content: 'Kaliteli ve şık mobilyalarla yaşam alanınızı yenileyin',
            color: Colors.brown[200]!,
            imageUrl: 'assets/images/bicycle_france.jpg',
          ),
          const SizedBox(height: 20),
          _buildProductSection('Yeni Gelen Ürünlerimiz',
              products.where((p) => !p.isSold).toList()),
          const SizedBox(height: 20),
          _buildProductSection('Satılmış Ürünlerimiz (3 Ay İçinde)',
              products.where((p) => p.isSold).toList()),
          const SizedBox(height: 40),
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
          color: AppColors.primary,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../domain/entites/product.dart';
import '../providers/product_provider.dart';

class SpotProductsPage extends ConsumerStatefulWidget {
  const SpotProductsPage({super.key});

  @override
  ConsumerState<SpotProductsPage> createState() => _SpotProductsPageState();
}

class _SpotProductsPageState extends ConsumerState<SpotProductsPage>
    with SingleTickerProviderStateMixin {
  String _sortBy = 'newest';
  int _hoveredIndex = -1;
  late AnimationController _fadeController;

  final List<String> _sortOptions = [
    'newest',
    'price_low',
    'price_high',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  List<Product> _sortProducts(final List<Product> products) {
    final list = List<Product>.from(products);
    switch (_sortBy) {
      case 'price_low':
        list.sort((final a, final b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        list.sort((final a, final b) => b.price.compareTo(a.price));
        break;
      default:
        list.sort((final a, final b) => b.createdAt.compareTo(a.createdAt));
    }
    return list;
  }

  @override
  Widget build(final BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return FadeTransition(
      opacity: _fadeController,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: productsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (final e, final _) => Center(child: Text(e.toString())),
          data: (final products) {
            final spotDealsProducts =
                products.where((final p) => p.isSpotProduct && !p.isSold).toList();

            final sortedProducts = _sortProducts(spotDealsProducts);

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(context),
                _buildSortBar(context, sortedProducts.length),
                _buildSpotlightBanner(context),
                if (sortedProducts.isEmpty)
                  const SliverToBoxAdapter(child: _EmptyWidget())
                else
                  _buildProductsGrid(context, sortedProducts),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
                const SliverToBoxAdapter(child: AdsenseBanner(height: 100)),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------------- UI ----------------

  SliverPadding _buildProductsGrid(
      final BuildContext context, final List<Product> products) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(4),
          childAspectRatio: context.responsive(mobile: 0.7, desktop: 0.75),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) => GestureDetector(
            onTapDown: (final _) => setState(() => _hoveredIndex = index),
            onTapUp: (final _) => setState(() => _hoveredIndex = -1),
            onTapCancel: () => setState(() => _hoveredIndex = -1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()
                ..scale(_hoveredIndex == index ? 1.05 : 1.0),
              child: CustomProductCard(product: products[index]),
            ),
          ),
          childCount: products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSortBar(
      final BuildContext context, final int count) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.sort),
            const SizedBox(width: 10),
            Expanded(
              child: Wrap(
                spacing: 8,
                children: _sortOptions.map((final opt) {
                  return ChoiceChip(
                    label: Text(_getSortLabel(opt)),
                    selected: _sortBy == opt,
                    onSelected: (final _) => setState(() => _sortBy = opt),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: _sortBy == opt ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),
            ),
            Text('$count Ürün'),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(final BuildContext context) =>
      const SliverToBoxAdapter(child: SizedBox(height: 24));

  SliverToBoxAdapter _buildSpotlightBanner(final BuildContext context) =>
      const SliverToBoxAdapter(child: SizedBox(height: 24));

  String _getSortLabel(final String opt) {
    switch (opt) {
      case 'price_low':
        return 'En Ucuz';
      case 'price_high':
        return 'En Pahalı';
      default:
        return 'En Yeni';
    }
  }
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();

  @override
  Widget build(final BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Text('Henüz spot ürün yok'),
        ),
      );
}

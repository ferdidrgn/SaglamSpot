import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/core/widgets/custom_product_card.dart';
import 'package:saglamspot/features/products/presentation/providers/product_filters_provider.dart';
import 'package:saglamspot/features/products/presentation/providers/product_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/shimmer_components.dart';
import '../../domain/entites/product.dart';

class NewProductsPage extends ConsumerStatefulWidget {
  const NewProductsPage({super.key});

  @override
  ConsumerState<NewProductsPage> createState() => _NewProductsPageState();
}

class _NewProductsPageState extends ConsumerState<NewProductsPage> {
  String _selectedCategory = 'Tümü';
  String _selectedSort = 'newest';
  int _hoveredIndex = -1;

  @override
  Widget build(final BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: productsAsync.when(
        loading: () => const FullPageShimmer(),
        error: (final e, final _) => Center(child: Text(e.toString())),
        data: (final _) {
          final products = ref.watch(newDealsProductsProvider);
          final filtered = _applyCategory(products)..sort(_sort);

          if (filtered.isEmpty) {
            return const Center(child: Text('Ürün bulunamadı'));
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeader(context, filtered.length),
              _buildCategories(context),
              _buildSortBar(context, filtered.length),
              _buildProductGrid(context, filtered),
              _buildAdBanner(context),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
      ),
    );
  }

  // ---------------- LOGIC ----------------

  List<Product> _applyCategory(final List<Product> list) {
    if (_selectedCategory == 'Tümü') return list;
    return list.where((final e) => e.category == _selectedCategory).toList();
  }

  int _sort(final Product a, final Product b) {
    switch (_selectedSort) {
      case 'price_low':
        return a.price.compareTo(b.price);
      case 'price_high':
        return b.price.compareTo(a.price);
      default:
        return b.createdAt.compareTo(a.createdAt);
    }
  }

  // ---------------- UI ----------------

  SliverToBoxAdapter _buildHeader(
          final BuildContext context, final int count) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 24, desktop: 60),
            vertical: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'YENİ KOLEKSİYON',
                style: TextStyle(
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Kusursuz Seçimler',
                style: TextStyle(
                  fontSize: context.responsive(mobile: 34, desktop: 52),
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '$count ürün listeleniyor',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );

  SliverToBoxAdapter _buildCategories(final BuildContext context) {
    final cats = ['Tümü', 'Koltuk', 'Masa', 'Yatak', 'Dolap'];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
              left: context.responsive(mobile: 24, desktop: 60)),
          itemCount: cats.length,
          itemBuilder: (final _, final i) {
            final c = cats[i];
            final active = _selectedCategory == c;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ChoiceChip(
                label: Text(c),
                selected: active,
                onSelected: (final _) => setState(() => _selectedCategory = c),
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSortBar(
          final BuildContext context, final int count) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.responsive(mobile: 24, desktop: 60)),
          child: Align(
            alignment: Alignment.centerRight,
            child: DropdownButton<String>(
              value: _selectedSort,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'newest', child: Text('En Yeni')),
                DropdownMenuItem(value: 'price_low', child: Text('En Ucuz')),
                DropdownMenuItem(value: 'price_high', child: Text('En Pahalı')),
              ],
              onChanged: (final v) => setState(() => _selectedSort = v!),
            ),
          ),
        ),
      );

  SliverPadding _buildProductGrid(
      final BuildContext context, final List<Product> products) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 24, desktop: 60)),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(4),
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) => MouseRegion(
            onEnter: (final _) => setState(() => _hoveredIndex = index),
            onExit: (final _) => setState(() => _hoveredIndex = -1),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: _hoveredIndex == index ? 1.03 : 1,
              child: CustomProductCard(product: products[index]),
            ),
          ),
          childCount: products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildAdBanner(final BuildContext context) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.responsive(mobile: 24, desktop: 60)),
          child: const AdsenseBanner(height: 100),
        ),
      );
}

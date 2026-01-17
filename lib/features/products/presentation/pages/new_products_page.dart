import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/core/widgets/custom_product_card.dart';
import 'package:saglamspot/features/products/presentation/providers/product_filters_provider.dart';
import 'package:saglamspot/features/products/presentation/providers/product_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_context_extension.dart';
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
      backgroundColor: context.scaffoldBackgroundColor,
      body: productsAsync.when(
        loading: () => const FullPageShimmer(),
        error: (final e, final _) => Center(child: Text(e.toString())),
        data: (final _) {
          final products = ref.watch(newDealsProductsProvider);
          final filtered = _applyCategory(products)..sort(_sort);

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Lüks Başlık Alanı
              _buildLuxeHeader(context, filtered.length),

              // Şık Kategori Barı
              _buildModernFilterBar(context),

              // Ürün Sayısı ve Sıralama
              _buildInfoAndSortRow(context, filtered.length),

              // Ürün Gridi
              if (filtered.isEmpty)
                const SliverToBoxAdapter(
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.all(100.0),
                    child: Text('Aradığınız kategoride ürün bulunamadı.'),
                  )),
                )
              else
                _buildProductGrid(context, filtered),

              // Reklam Alanı
              _buildAdBanner(context),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  // ---------------- UI COMPONENTS ----------------

  SliverToBoxAdapter _buildLuxeHeader(
          final BuildContext context, final int count) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.pagePadding.left,
            context.responsive(mobile: 40, desktop: 80),
            context.pagePadding.right,
            40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SIFIR ÜRÜNLER',
                style: TextStyle(
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: context.secondaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Yeni Koleksiyon',
                style: TextStyle(
                  fontSize: context.h1Size,
                  fontWeight: FontWeight.w900,
                  color: context.primaryColor,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Container(height: 3, width: 50, color: context.secondaryColor),
            ],
          ),
        ),
      );

  SliverToBoxAdapter _buildModernFilterBar(final BuildContext context) {
    final cats = [
      'Tümü',
      'Koltuk',
      'Masa',
      'Yatak',
      'Dolap',
      'Mutfak',
      'Aydınlatma'
    ];

    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: context.pagePadding.left),
          itemCount: cats.length,
          itemBuilder: (final _, final i) {
            final c = cats[i];
            final active = _selectedCategory == c;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: active ? context.primaryColor : context.surfaceColor,
                    borderRadius:
                        BorderRadius.circular(context.borderRadius(2)),
                    border: Border.all(
                      color: active
                          ? context.primaryColor
                          : context.primaryColor.withOpacity(0.1),
                    ),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: context.primaryColor.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      c,
                      style: TextStyle(
                        color: active ? Colors.white : context.primaryColor,
                        fontWeight: active ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoAndSortRow(
          final BuildContext context, final int count) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.pagePadding.left, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$count Ürün bulundu',
                style: TextStyle(
                  color: context.primaryColor.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: context.primaryColor.withOpacity(0.1)),
                ),
                child: DropdownButton<String>(
                  value: _selectedSort,
                  underline: const SizedBox(),
                  icon: Icon(Icons.keyboard_arrow_down,
                      size: 18, color: context.primaryColor),
                  style: TextStyle(
                      color: context.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                  items: const [
                    DropdownMenuItem(value: 'newest', child: Text('En Yeni')),
                    DropdownMenuItem(
                        value: 'price_low', child: Text('En Ucuz')),
                    DropdownMenuItem(
                        value: 'price_high', child: Text('En Pahalı')),
                  ],
                  onChanged: (final v) => setState(() => _selectedSort = v!),
                ),
              ),
            ],
          ),
        ),
      );

  SliverPadding _buildProductGrid(
      final BuildContext context, final List<Product> products) {
    return SliverPadding(
      padding: context.pagePadding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(4),
          mainAxisSpacing: context.gridSpacing,
          crossAxisSpacing: context.gridSpacing,
          childAspectRatio: context.cardAspectRatio(),
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) => MouseRegion(
            onEnter: (final _) => setState(() => _hoveredIndex = index),
            onExit: (final _) => setState(() => _hoveredIndex = -1),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              scale: _hoveredIndex == index ? 1.02 : 1,
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
          padding: EdgeInsets.fromLTRB(
            context.pagePadding.left,
            80,
            context.pagePadding.right,
            20,
          ),
          child: const AdsenseBanner(height: 120),
        ),
      );

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
}

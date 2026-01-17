import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/util/responsive_utils.dart';
import '../../../../core/theme/theme_context_extension.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/shimmer_components.dart';
import '../../../../core/widgets/custom_product_card.dart';

import '../../../products/presentation/providers/product_provider.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../domain/entites/product.dart';

class NewProductsPage extends ConsumerStatefulWidget {
  const NewProductsPage({super.key});

  @override
  ConsumerState<NewProductsPage> createState() => _NewProductsPageState();
}

class _NewProductsPageState extends ConsumerState<NewProductsPage> {
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'Tümü';

  @override
  Widget build(final BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: productsAsync.when(
        loading: () => const FullPageShimmer(),
        error: (final e, final _) => Center(child: Text('Hata: $e')),
        data: (final _) {
          final products = ref.watch(newDealsProductsProvider);
          final filtered = products
              .where((final p) =>
                  _selectedCategory == 'Tümü' ||
                  p.category == _selectedCategory)
              .toList();

          return Stack(
            children: [
              _BackgroundLayer(context),
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeader(context),
                  _buildCategoryBar(context),
                  _buildAd(context, 90),
                  _buildProductGrid(context, filtered),
                  _buildAd(context, 120),
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ───────────────── HEADER ─────────────────

  SliverAppBar _buildHeader(final BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: context.responsive(
        mobile: 220,
        tablet: 260,
        desktop: 300,
      ),
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _HeaderPatternPainter(
                color: context.secondaryColor.withOpacity(0.08),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.scaffoldBackgroundColor.withOpacity(0.7),
                    context.scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
            Padding(
              padding: context.pagePadding,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEW ARRIVALS',
                      style: TextStyle(
                        fontSize: context.captionSize,
                        letterSpacing: 3,
                        color: context.secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Yeni\nKoleksiyon',
                      style: TextStyle(
                        fontSize: context.h1Size,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        color: context.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 80,
                      height: 3,
                      color: context.secondaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── CATEGORY BAR ─────────────────

  SliverToBoxAdapter _buildCategoryBar(final BuildContext context) {
    final categories = ['Tümü', 'Koltuk', 'Masa', 'Dekor', 'Ofis', 'Yatak'];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 64,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: context.pagePadding.left,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (final _, final __) => const SizedBox(width: 12),
          itemBuilder: (final context, final index) {
            final active = _selectedCategory == categories[index];

            return OutlinedButton(
              onPressed: () =>
                  setState(() => _selectedCategory = categories[index]),
              style: OutlinedButton.styleFrom(
                backgroundColor:
                    active ? context.primaryColor : Colors.transparent,
                side: BorderSide(
                  color: context.primaryColor.withOpacity(0.3),
                ),
                padding: EdgeInsets.symmetric(horizontal: context.spacingLarge),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: active ? Colors.white : context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ───────────────── PRODUCT GRID (MOZAİK) ─────────────────

  SliverPadding _buildProductGrid(
      final BuildContext context, final List<Product> products) {
    return SliverPadding(
      padding: context.pagePadding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumnsManuel(5),
          crossAxisSpacing: context.gridSpacing,
          mainAxisSpacing: context.gridSpacing,
          childAspectRatio: context.cardAspectRatio(),
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) =>
              CustomProductCard(product: products[index]),
          childCount: products.length,
        ),
      ),
    );
  }

  // ───────────────── ADS ─────────────────

  SliverToBoxAdapter _buildAd(final BuildContext context, final double height) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: context.sectionPadding,
        child: AdsenseBanner(height: height),
      ),
    );
  }
}

// ───────────────── BACKGROUND ─────────────────

class _BackgroundLayer extends StatelessWidget {
  final BuildContext context;

  const _BackgroundLayer(this.context);

  @override
  Widget build(final BuildContext _) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _GraffitiPainter(
          lineColor: context.primaryColor.withOpacity(0.04),
          shapeColor: context.secondaryColor.withOpacity(0.02),
        ),
      ),
    );
  }
}

// ───────────────── STAT ITEM ─────────────────

class _StatItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StatItem({required this.title, required this.subtitle});

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: context.titleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle.toUpperCase(),
          style: TextStyle(
            fontSize: context.captionSize,
            letterSpacing: 2,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

// ───────────────── PAINTERS ─────────────────

class _GraffitiPainter extends CustomPainter {
  final Color lineColor;
  final Color shapeColor;

  _GraffitiPainter({
    required this.lineColor,
    required this.shapeColor,
  });

  @override
  void paint(final Canvas canvas, final Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.5;

    final shapePaint = Paint()
      ..color = shapeColor
      ..style = PaintingStyle.fill;

    for (double i = 0; i < size.width; i += 90) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i - 200, size.height),
        linePaint,
      );
      if (i % 270 == 0) {
        canvas.drawRect(
          Rect.fromLTWH(i, size.height * 0.3, 40, 40),
          shapePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(final _) => false;
}

class _HeaderPatternPainter extends CustomPainter {
  final Color color;

  _HeaderPatternPainter({required this.color});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    for (double i = 0; i < size.width; i += 32) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + 48, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(final _) => false;
}

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

class _SpotProductsPageState extends ConsumerState<SpotProductsPage> {
  String _sortBy = 'newest';
  int _hoveredIndex = -1;
  final List<String> _sortOptions = [
    'newest',
    'price_low',
    'price_high',
    'discount'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      ref.read(productProvider.notifier).loadProducts();
    });
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
      /*case 'discount':
        list.sort((a, b) => (b.discount ?? 0).compareTo(a.discount ?? 0));
        break;*/
      default:
        list.sort((final a, final b) => b.createdAt.compareTo(a.createdAt));
    }
    return list;
  }

  @override
  Widget build(final BuildContext context) {
    final spotProducts = ref.watch(spotProductsProvider);
    final productState = ref.watch(productProvider);
    final sortedProducts = _sortProducts(spotProducts);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(context),
          _buildSortBar(context, sortedProducts.length),
          _buildSpotlightBanner(context),
          if (productState.isLoading)
            SliverToBoxAdapter(child: _buildLoadingState(context))
          else if (productState.errorMessage != null)
            SliverToBoxAdapter(
                child: _buildErrorState(context, productState.errorMessage!))
          else if (sortedProducts.isEmpty)
            SliverToBoxAdapter(child: _buildEmptyState(context))
          else
            _buildProductsGrid(context, sortedProducts),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
          const SliverToBoxAdapter(child: AdsenseBanner(height: 100)),
        ],
      ),
    );
  }

  // --- HEADER ---
  SliverToBoxAdapter _buildHeader(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
            mobile: const EdgeInsets.all(16),
            desktop: const EdgeInsets.all(24)),
        padding: context.responsive(
            mobile: const EdgeInsets.all(24),
            desktop: const EdgeInsets.all(48)),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D), Color(0xFF4ECDC4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(
              context.responsive(mobile: 24, desktop: 32)),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
                blurRadius: 40,
                offset: const Offset(0, 20))
          ],
        ),
        child: context.isMobile
            ? _buildMobileHeader(context)
            : _buildDesktopHeader(context),
      ),
    );
  }

  Widget _buildMobileHeader(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderBadge(),
        const SizedBox(height: 20),
        const Text('Kaçırılmayacak\nFırsatlar',
            style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.1,
                shadows: [
                  Shadow(
                      color: Colors.black26,
                      offset: Offset(1, 2),
                      blurRadius: 8)
                ])),
        const SizedBox(height: 24),
        _buildCountdownTimer(),
      ],
    );
  }

  Widget _buildDesktopHeader(final BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderBadge(),
              const SizedBox(height: 20),
              const Text('Kaçırılmayacak\nFırsatlar',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      shadows: [
                        Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 2),
                            blurRadius: 8)
                      ])),
              const SizedBox(height: 32),
              _buildCountdownTimer(),
            ],
          ),
        ),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 40,
                    offset: const Offset(0, 15))
              ]),
          child: const Icon(Icons.percent_outlined,
              color: Colors.white24, size: 120),
        ),
      ],
    );
  }

  Widget _buildHeaderBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text('SPOT ÜRÜNLER',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- SORT BAR ---
  SliverToBoxAdapter _buildSortBar(
      final BuildContext context, final int count) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8))
            ]),
        child: Row(
          children: [
            const Icon(Icons.sort_rounded, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _sortOptions
                      .map((final opt) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(_getSortLabel(opt)),
                              selected: _sortBy == opt,
                              onSelected: (final _) =>
                                  setState(() => _sortBy = opt),
                              selectedColor:
                                  AppColors.primary.withOpacity(0.85),
                              backgroundColor: Colors.grey.shade100,
                              labelStyle: TextStyle(
                                  color: _sortBy == opt
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold),
                              elevation: 3,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            Text('$count Ürün',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // --- SPOTLIGHT BANNER ---
  SliverToBoxAdapter _buildSpotlightBanner(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.shade200),
            boxShadow: [
              BoxShadow(
                  color: Colors.amber.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8))
            ]),
        child: const Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.amber),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                "Spot ürünler hızla tükenir, beğendiğin ürünü kaçırma!",
                style:
                    TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- PRODUCT GRID ---
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
          (final context, final index) => MouseRegion(
            onEnter: (final _) => setState(() => _hoveredIndex = index),
            onExit: (final _) => setState(() => _hoveredIndex = -1),
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
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

  Widget _buildCountdownTimer() {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (final context, final snapshot) {
        final now = DateTime.now();
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
        final remaining = endOfDay.difference(now);
        return Text(
          'Günün Fırsatı Bitişine: ${remaining.inHours}:${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        );
      },
    );
  }

  String _getSortLabel(final String opt) {
    switch (opt) {
      case 'newest':
        return 'En Yeni';
      case 'price_low':
        return 'En Ucuz';
      case 'price_high':
        return 'En Pahalı';
      case 'discount':
        return 'İndirim';
      default:
        return '';
    }
  }

  Widget _buildLoadingState(final BuildContext context) => const Center(
      child: Padding(
          padding: EdgeInsets.all(40), child: CircularProgressIndicator()));

  Widget _buildErrorState(final BuildContext context, final String msg) =>
      Center(child: Text(msg));

  Widget _buildEmptyState(final BuildContext context) => const Center(
      child: Padding(
          padding: EdgeInsets.all(40),
          child: Text("Henüz spot ürün bulunamadı.")));
}

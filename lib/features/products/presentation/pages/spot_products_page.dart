import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../domain/entites/product.dart';
import '../providers/product_notifier.dart';
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
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeController.forward();

    Future.microtask(() {
      ref.read(productProvider.notifier).loadProducts();
    });
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
    final spotProducts = ref.watch(spotProductsProvider);
    final productState = ref.watch(productProvider);
    final sortedProducts = _sortProducts(spotProducts);

    return FadeTransition(
      opacity: _fadeController,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildHeader(context),
            _buildSortBar(context, sortedProducts.length),
            _buildSpotlightBanner(context),
            if (productState.isLoading && sortedProducts.isEmpty)
              const SliverToBoxAdapter(child: _LoadingWidget())
            else if (productState.errorMessage != null)
              SliverToBoxAdapter(
                  child: _ErrorWidget(message: productState.errorMessage!))
            else if (sortedProducts.isEmpty)
              const SliverToBoxAdapter(child: _EmptyWidget())
            else
              _buildProductsGrid(context, sortedProducts),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
            const SliverToBoxAdapter(child: AdsenseBanner(height: 100)),
          ],
        ),
      ),
    );
  }

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
            ? _buildMobileHeaderContent()
            : _buildDesktopHeaderContent(),
      ),
    );
  }

  Widget _buildMobileHeaderContent() => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderBadge(),
          SizedBox(height: 20),
          _HeaderText(fontSize: 32),
          SizedBox(height: 24),
          _CountdownTimer(),
        ],
      );

  Widget _buildDesktopHeaderContent() => const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderBadge(),
                SizedBox(height: 20),
                _HeaderText(fontSize: 48),
                SizedBox(height: 32),
                _CountdownTimer(),
              ],
            ),
          ),
          _HeaderIcon(),
        ],
      );

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
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)
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
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                  color: _sortBy == opt
                                      ? Colors.white
                                      : Colors.black87),
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

  SliverToBoxAdapter _buildSpotlightBanner(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.shade200)),
        child: const Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.amber),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                "Spot ürünler hızla tükenir, fırsatı kaçırma!",
                style:
                    TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge();

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white24, borderRadius: BorderRadius.circular(20)),
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
}

class _HeaderText extends StatelessWidget {
  final double fontSize;

  const _HeaderText({required this.fontSize});

  @override
  Widget build(final BuildContext context) => Text(
        'Kaçırılmayacak\nFırsatlar',
        style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            height: 1.1),
      );
}

class _CountdownTimer extends StatelessWidget {
  const _CountdownTimer();

  @override
  Widget build(final BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (final context, final snapshot) {
        final now = DateTime.now();
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
        final remaining = endOfDay.difference(now);
        return Text(
          'Kalan Süre: ${remaining.inHours}:${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon();

  @override
  Widget build(final BuildContext context) => Container(
        width: 150,
        height: 150,
        decoration:
            const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
        child: const Icon(Icons.percent, color: Colors.white24, size: 80),
      );
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(final BuildContext context) => const Center(
        child: Padding(
            padding: EdgeInsets.all(50), child: CircularProgressIndicator()),
      );
}

class _ErrorWidget extends StatelessWidget {
  final String message;

  const _ErrorWidget({required this.message});

  @override
  Widget build(final BuildContext context) => Center(
        child: Padding(padding: const EdgeInsets.all(50), child: Text(message)),
      );
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();

  @override
  Widget build(final BuildContext context) => const Center(
        child: Padding(
            padding: EdgeInsets.all(50),
            child: Text("Henüz spot ürün bulunamadı.")),
      );
}

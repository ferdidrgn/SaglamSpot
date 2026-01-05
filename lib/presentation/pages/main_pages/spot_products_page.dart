import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_product_card.dart';
import '../../../data/providers/product/product_provider.dart';
import '../../../data/providers/product/product_state.dart';
import '../../../domain/entities/product.dart';

class SpotProductsPage extends ConsumerStatefulWidget {
  const SpotProductsPage({super.key});

  @override
  ConsumerState<SpotProductsPage> createState() => _SpotProductsPageState();
}

class _SpotProductsPageState extends ConsumerState<SpotProductsPage> {
  String _sortBy = 'newest';
  final List<String> _sortOptions = [
    'newest',
    'price_low',
    'price_high',
    'discount'
  ];

  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında verileri sunucudan çek
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      ref.read(productProvider.notifier).loadProducts();
    });
  }

  // --- ÜRÜN SIRALAMA MANTIĞI ---
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
        list.sort((final a, final b) {
          final aDisc = a.oldPrice != null ? (a.oldPrice! - a.price) : 0;
          final bDisc = b.oldPrice != null ? (b.oldPrice! - b.price) : 0;
          return bDisc.compareTo(aDisc);
        });
        break;*/
      default:
        // En yeni ürünler
        list.sort((final a, final b) => b.createdAt.compareTo(a.createdAt));
    }
    return list;
  }

  @override
  Widget build(final BuildContext context) {
    // Sadece satılmamış VE spot olan ürünleri getiren provider
    final spotProducts = ref.watch(spotProductsProvider);
    final productState = ref.watch(productProvider);
    final sortedProducts = _sortProducts(spotProducts);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 1. DİNAMİK HEADER
          _buildSpotHeader(context),

          // 2. SIRALAMA ÇUBUĞU
          _buildSortBar(context, sortedProducts.length),

          // 3. İPUCU BANNERI
          _buildSpotlightBanner(context),

          // 4. İÇERİK DURUMLARI
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
        ],
      ),
    );
  }

  // --- HEADER METODLARI ---
  SliverToBoxAdapter _buildSpotHeader(final BuildContext context) {
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
              context.responsive(mobile: 24.0, desktop: 32.0)),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFFF6B6B).withOpacity(0.3),
                blurRadius: 40,
                offset: const Offset(0, 20))
          ],
        ),
        child: context.isMobile
            ? _buildMobileSpotHeader(context)
            : _buildDesktopSpotHeader(context),
      ),
    );
  }

  Widget _buildMobileSpotHeader(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSpotHeaderBadge(),
        const SizedBox(height: 20),
        const Text('Kaçırılmayacak\nFırsatlar',
            style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                height: 1.1)),
        const SizedBox(height: 32),
        _buildCountdownTimer(context),
      ],
    );
  }

  Widget _buildDesktopSpotHeader(final BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSpotHeaderBadge(),
              const SizedBox(height: 20),
              const Text('Kaçırılmayacak\nFırsatlar',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      height: 1.1)),
              const SizedBox(height: 32),
              _buildCountdownTimer(context),
            ],
          ),
        ),
        const Icon(Icons.percent_outlined, color: Colors.white24, size: 200),
      ],
    );
  }

  // --- YARDIMCI BİLEŞENLER ---
  Widget _buildSpotHeaderBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white30, borderRadius: BorderRadius.circular(20)),
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

  Widget _buildCountdownTimer(final BuildContext context) {
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

  SliverToBoxAdapter _buildSortBar(
      final BuildContext context, final int count) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12)),
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
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(_getSortLabel(opt)),
                              selected: _sortBy == opt,
                              onSelected: (final val) =>
                                  setState(() => _sortBy = opt),
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

  String _getSortLabel(final String opt) {
    if (opt == 'newest') return 'En Yeni';
    if (opt == 'price_low') return 'En Ucuz';
    if (opt == 'price_high') return 'En Pahalı';
    return 'İndirim';
  }

  SliverToBoxAdapter _buildSpotlightBanner(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber.shade200)),
        child: const Row(
          children: [
            Icon(Icons.lightbulb_outline, color: Colors.amber),
            SizedBox(width: 15),
            Expanded(
                child: Text(
                    "Spot ürünler hızla tükenir, beğendiğin ürünü kaçırma!",
                    style: TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid(
      final BuildContext context, final List<Product> products) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(4),
          childAspectRatio: context.responsive(mobile: 0.72, desktop: 0.75),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) =>
              CustomProductCard(product: products[index]),
          childCount: products.length,
        ),
      ),
    );
  }

  // --- DURUM WIDGETLARI ---
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

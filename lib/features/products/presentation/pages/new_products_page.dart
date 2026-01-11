import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/core/widgets/custom_product_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/interactive_magic_spotlight.dart';
import '../../domain/entites/product.dart';
import '../providers/product_notifier.dart';

class NewProductsPage extends ConsumerStatefulWidget {
  const NewProductsPage({super.key});

  @override
  ConsumerState<NewProductsPage> createState() => _NewProductsPageState();
}

class _NewProductsPageState extends ConsumerState<NewProductsPage> {
  String _selectedLocalCategory = "Tümü";
  String _selectedSort = 'newest';
  int _hoveredIndex = -1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(productProvider.notifier).loadProducts());
  }

  @override
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider);
    final allProducts = productState.dataList ?? [];

    // Veri ayrıştırma
    final availableProducts =
        allProducts.where((final p) => !p.isSold).toList();
    final soldProducts = allProducts.where((final p) => p.isSold).toList();

    // Filtreleme ve Sıralama
    final filteredAvailable = _applyLocalCategory(availableProducts);
    _applySort(filteredAvailable);

    // Satılmışları tarihe göre sırala
    soldProducts.sort((final a, final b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Arka plan dekoratif öğeleri
          _buildFloatingTypography(),
          _buildGradientBackgroundShape(),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. ÜST BAŞLIK (Header)
              _buildHeader(context, filteredAvailable.length),

              // 2. MODERN KATEGORİ SEÇİCİ
              _buildCategories(context),

              // 3. SORT BAR (Sıralama)
              _buildSortBar(context, filteredAvailable.length),

              // 4. ANA ÜRÜN GRİDİ
              if (productState.isLoading && filteredAvailable.isEmpty)
                _buildShimmerLoading(context)
              else if (filteredAvailable.isEmpty)
                _buildEmpty()
              else
                _buildProductGrid(context, filteredAvailable),

              // 5. LIFESTYLE INTERMEZZO (Ara Geçiş Bannerı)
              _buildIntermezzoBanner(context),

              // 6. SHOWROOM: YAKINDA SATILANLAR
              if (soldProducts.isNotEmpty) ...[
                _buildSoldSectionHeader(context),
                _buildSoldShowroomGrid(context, soldProducts),
              ],

              const SliverToBoxAdapter(
                child: InsaneMagicShowcase(
                    imageUrl:
                        "https://images.unsplash.com/photo-1600585154340-be6161a56a0c"),
              ),

              // 7. REKLAM ALANI (AdSense)
              const SliverToBoxAdapter(child: SizedBox(height: 60)),
              _buildAdBanner(context),

              // 8. CTA & FOOTER BANNER
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
              _buildCTABanner(context),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // ZENGİNLEŞTİRİCİ SECTION WIDGETLARI
  // ═══════════════════════════════════════════════════════════

  Widget _buildFloatingTypography() => const Positioned(
        top: 150,
        right: -100,
        child: Opacity(
          opacity: 0.03,
          child: Text(
            "STYLISH\nMODERN",
            style: TextStyle(
              fontSize: 200,
              fontWeight: FontWeight.w900,
              height: 0.8,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      );

  Widget _buildIntermezzoBanner(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: 80,
            horizontal: context.responsive(mobile: 24, desktop: 60)),
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: const DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=2000'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("İntermezzo",
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4)),
              const SizedBox(height: 10),
              Text("Yaşam Alanınıza\nDeğer Katıyoruz",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: context.responsive(mobile: 28, desktop: 42),
                      fontWeight: FontWeight.w900,
                      height: 1.1)),
              const SizedBox(height: 20),
              const Text(
                  "En kaliteli ikinci el ve spot ürünler,\nuzman ekibimiz tarafından incelenerek listelenir.",
                  style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoldSectionHeader(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 24.0, desktop: 60.0),
            vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.verified_outlined,
                    color: AppColors.primary, size: 20),
                SizedBox(width: 8),
                Text("SHOWROOM",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 10),
            Text("Yakında Sahiplerini Bulanlar",
                style: TextStyle(
                    fontSize: context.responsive(mobile: 28, desktop: 36),
                    fontWeight: FontWeight.w900)),
            const Text("Bu ürünler artık yeni evlerinde mutluluk saçıyor.",
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSoldShowroomGrid(
      final BuildContext context, final List<Product> soldItems) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
          horizontal:
              context.responsive(mobile: 24.0, tablet: 40.0, desktop: 60.0),
          vertical:
              context.responsive(mobile: 20.0, tablet: 30.0, desktop: 40.0)),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(4),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) {
            final item = soldItems[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: CustomProductCard(product: item),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(-15 / 360),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8)),
                        child: const Text("SATILDI",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                fontSize: 12)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: soldItems.length > 4 ? 4 : soldItems.length,
        ),
      ),
    );
  }

  // ---------------- LOGIC & REFACTORING ----------------

  List<Product> _applyLocalCategory(final List<Product> list) {
    if (_selectedLocalCategory == "Tümü") return list;
    return list
        .where((final p) => p.category == _selectedLocalCategory)
        .toList();
  }

  void _applySort(final List<Product> list) {
    switch (_selectedSort) {
      case 'price_low':
        list.sort((final a, final b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        list.sort((final a, final b) => b.price.compareTo(a.price));
        break;
      default:
        list.sort((final a, final b) => b.createdAt.compareTo(a.createdAt));
    }
  }

  // ---------------- UI COMPONENTS ----------------

  Widget _buildGradientBackgroundShape() => Positioned(
        top: 400,
        left: -100,
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [AppColors.primary.withOpacity(0.05), Colors.transparent],
            ),
          ),
        ),
      );

  SliverToBoxAdapter _buildHeader(
          final BuildContext context, final int count) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.responsive(mobile: 24.0, desktop: 60.0),
            80,
            context.responsive(mobile: 24.0, desktop: 60.0),
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 30, height: 2, color: AppColors.primary),
                  const SizedBox(width: 10),
                  const Text("YENİ KOLEKSİYON",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3)),
                ],
              ),
              const SizedBox(height: 15),
              Text("Kusursuzluğun\nYeni Adresi",
                  style: TextStyle(
                      fontSize: context.responsive(mobile: 36.0, desktop: 56.0),
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                      letterSpacing: -1.5)),
            ],
          ),
        ),
      );

  SliverToBoxAdapter _buildCategories(final BuildContext context) {
    final cats = {
      "Tümü": Icons.grid_view_rounded,
      "Koltuk": Icons.chair_rounded,
      "Masa": Icons.table_restaurant_rounded,
      "Yatak": Icons.bed_rounded,
      "Dolap": Icons.door_sliding_rounded,
    };
    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
              left: context.responsive(mobile: 24, desktop: 60)),
          itemCount: cats.length,
          itemBuilder: (final context, final i) {
            final key = cats.keys.elementAt(i);
            final isActive = _selectedLocalCategory == key;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilterChip(
                showCheckmark: false,
                avatar: Icon(cats[key],
                    size: 16,
                    color: isActive ? Colors.white : AppColors.primary),
                label: Text(key),
                selected: isActive,
                onSelected: (val) =>
                    setState(() => _selectedLocalCategory = key),
                backgroundColor: AppColors.surface,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                    color: isActive ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSortBar(
      final BuildContext context, final int count) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 24, desktop: 60),
            vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$count Ürün Listeleniyor',
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            DropdownButton<String>(
              value: _selectedSort,
              underline: const SizedBox(),
              icon: const Icon(Icons.sort_rounded, size: 20),
              items: const [
                DropdownMenuItem(value: 'newest', child: Text("En Yeni")),
                DropdownMenuItem(value: 'price_low', child: Text("En Ucuz")),
                DropdownMenuItem(value: 'price_high', child: Text("En Pahalı")),
              ],
              onChanged: (val) => setState(() => _selectedSort = val!),
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding _buildProductGrid(
      final BuildContext context, final List<Product> products) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 24.0, desktop: 60.0)),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(4),
          childAspectRatio: 0.75,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) => MouseRegion(
            onEnter: (final _) => setState(() => _hoveredIndex = index),
            onExit: (final _) => setState(() => _hoveredIndex = -1),
            child: AnimatedScale(
              scale: _hoveredIndex == index ? 1.02 : 1.0,
              duration: const Duration(milliseconds: 250),
              child: CustomProductCard(product: products[index]),
            ),
          ),
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildAdBanner(final BuildContext context) => SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.responsive(mobile: 24.0, desktop: 60.0)),
          child: const AdsenseBanner(height: 100),
        ),
      );

  Widget _buildCTABanner(final BuildContext context) => SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.responsive(mobile: 24.0, desktop: 60.0)),
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Aradığınızı bulamadınız mı?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text(
                          "Bizimle iletişime geçin, size özel stok araştıralım.",
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: const Text("WhatsApp Destek")),
              ],
            ),
          ),
        ),
      );

  SliverToBoxAdapter _buildShimmerLoading(final BuildContext context) =>
      const SliverToBoxAdapter(
          child: Center(
              child: Padding(
                  padding: EdgeInsets.all(100),
                  child: CircularProgressIndicator())));

  SliverToBoxAdapter _buildEmpty() => const SliverToBoxAdapter(
      child: Center(
          child: Padding(
              padding: EdgeInsets.all(100),
              child: Text("Henüz uygun ürün bulunmuyor."))));
}

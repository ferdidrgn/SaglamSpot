import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/core/widgets/custom_product_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
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
    // İlk veri çekme işlemini microtask ile başlatıyoruz
    Future.microtask(() => ref.read(productProvider.notifier).loadProducts());
  }

  @override
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider);
    final allProducts = productState.dataList ?? [];

    // Mevcut ve Satılmış ürün ayrımı
    final availableProducts =
        allProducts.where((final p) => !p.isSold).toList();
    final soldProducts = allProducts.where((final p) => p.isSold).toList();

    // Sort işlemi sadece mevcut ürünlere
    _applySort(availableProducts);
    // Satılmış ürünleri en yeniden eskiye sırala (Yakında Satılanlar)
    soldProducts.sort((final a, final b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildFloatingTypography(),
          _buildGradientBackgroundShape(),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Üst kısımlar (Dokunulmadı)
              _buildHeader(context, availableProducts.length),
              _buildCategories(context),
              _buildSortBar(context, availableProducts.length),

              // 🛍 MEVCUT KOLEKSİYON
              if (productState.isLoading && availableProducts.isEmpty)
                _buildShimmerLoading(context)
              else if (availableProducts.isEmpty)
                _buildEmpty()
              else
                _buildProductGrid(context, availableProducts),

              // ✨ ZENGİNLEŞTİRME: ARA SHOWROOM BANNER
              _buildIntermezzoBanner(context),

              // 🏆 YAKINDA SATILANLAR (Showroom Vitrini)
              if (soldProducts.isNotEmpty) ...[
                _buildSoldSectionHeader(context),
                _buildSoldShowroomGrid(context, soldProducts),
              ],

              // 📢 REKLAM VE CTA
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
              _buildAdBanner(context), // Sliver uyumlu hale getirildi
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
              _buildCTABanner(context),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntermezzoBanner(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: const DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1555041469-a586c61ea9bc'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent]),
          ),
          padding: const EdgeInsets.all(40),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("YAŞAM ALANINIZI",
                  style: TextStyle(color: Colors.white70, letterSpacing: 2)),
              Text("Yeniden Tanımlayın",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoldSectionHeader(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("YAKINDA SAHİPLERİNİ BULDULAR",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: AppColors.primary)),
            const SizedBox(height: 10),
            Text("Mutlu Evlerin Yeni Üyeleri",
                style: TextStyle(
                    fontSize: context.responsive(mobile: 28, desktop: 36),
                    fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _buildSoldShowroomGrid(
      final BuildContext context, final List<Product> soldItems) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(3), // Mobilde 1, Webde 3 gibi
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1.2,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) {
            final item = soldItems[index];
            return Opacity(
              opacity: 0.8,
              child: Stack(
                children: [
                  CustomProductCard(product: item),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text("SATILDI",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2)),
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: soldItems.length > 6
              ? 6
              : soldItems.length, // Sadece son 6 satılanı göster
        ),
      ),
    );
  }

  Widget _buildAdBanner(final BuildContext context) => SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.responsive(mobile: 24.0, desktop: 60.0)),
          child: const AdsenseBanner(height: 120),
        ),
      );

  // ---------------- LOGIC ----------------

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

  // ---------------- WIDGETS ----------------

  Widget _buildFloatingTypography() => Positioned(
        top: 100,
        right: -50,
        child: Opacity(
          opacity: 0.05,
          child: Text(
            "Stylish",
            style: TextStyle(
              fontSize: 180,
              fontWeight: FontWeight.w900,
              color: AppColors.textSecondary.withOpacity(0.15),
            ),
          ),
        ),
      );

  Widget _buildGradientBackgroundShape() => Positioned(
        top: 250,
        left: -50,
        child: Transform.rotate(
          angle: -0.2,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.3),
                  Colors.transparent
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
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
            40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 40, height: 2, color: AppColors.primary),
                  const SizedBox(width: 10),
                  const Text("NEW ARRIVALS",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Kusursuzluğun\nYeni Adresi",
                        style: TextStyle(
                            fontSize:
                                context.responsive(mobile: 40.0, desktop: 64.0),
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            letterSpacing: -2)),
                  ),
                  _buildCountBadge(count),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildCountBadge(final int count) => Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(
            color: AppColors.primary, shape: BoxShape.circle),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$count",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const Text("PIECES",
                  style: TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
        ),
      );

  SliverToBoxAdapter _buildCategories(final BuildContext context) {
    final cats = {
      "Tümü": Icons.auto_awesome_mosaic_rounded,
      "Koltuk": Icons.chair_rounded,
      "Masa": Icons.table_restaurant_rounded,
      "Yatak": Icons.bed_rounded,
      "Dolap": Icons.door_sliding_rounded,
    };
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(
              left: context.responsive(mobile: 24, desktop: 60)),
          itemCount: cats.length,
          itemBuilder: (final context, final i) {
            final key = cats.keys.elementAt(i);
            final isActive = _selectedLocalCategory == key;
            return GestureDetector(
              onTap: () => setState(() => _selectedLocalCategory = key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.only(right: 12, bottom: 10),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(cats[key],
                        color: isActive ? Colors.white : AppColors.textPrimary,
                        size: 18),
                    const SizedBox(width: 8),
                    Text(key,
                        style: TextStyle(
                            color:
                                isActive ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSortBar(
      final BuildContext context, final int count) {
    final options = ['newest', 'price_low', 'price_high'];
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            const Icon(Icons.sort_rounded, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: options
                      .map((final opt) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(_getSortLabel(opt)),
                              selected: _selectedSort == opt,
                              onSelected: (final _) =>
                                  setState(() => _selectedSort = opt),
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                  color: _selectedSort == opt
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

  SliverPadding _buildProductGrid(
      final BuildContext context, final List<Product> products) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 24.0, desktop: 60.0)),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(),
          childAspectRatio: context.responsive(mobile: 0.7, desktop: 0.75),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) => MouseRegion(
            onEnter: (final _) => setState(() => _hoveredIndex = index),
            onExit: (final _) => setState(() => _hoveredIndex = -1),
            child: AnimatedScale(
              scale: _hoveredIndex == index ? 1.03 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: CustomProductCard(product: products[index]),
            ),
          ),
          childCount: products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildShimmerLoading(final BuildContext context) =>
      const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: CircularProgressIndicator(),
          ),
        ),
      );

  SliverToBoxAdapter _buildEmpty() => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(100),
            child: Text("Henüz yeni ürün eklenmedi."),
          ),
        ),
      );

  SliverToBoxAdapter _buildCTABanner(final BuildContext context) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.responsive(mobile: 24.0, desktop: 60.0)),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                    child: Text("Yeni koleksiyonu keşfet!",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                ElevatedButton(onPressed: () {}, child: const Text("İncele")),
              ],
            ),
          ),
        ),
      );

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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saglamspot/features/products/presentation/providers/product_filters_provider.dart';
import '../../../../core/ads/widgets/ad_grid_helper.dart';
import '../../../../core/ads/widgets/adsense_banner.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/providers/product_view_mode_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/design_system/ambient_mesh_background.dart';
import '../../../../core/widgets/design_system/reveal_fade.dart';
import '../../../../core/widgets/design_system/tactile_press.dart';
import '../../../../core/widgets/editorial_product_grid_widgets.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../core/widgets/shimmer_components.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../domain/entites/product.dart';

enum _SortMode { newest, priceLowHigh, priceHighLow, popular }

class NewProductsPage extends ConsumerStatefulWidget {
  const NewProductsPage({super.key});

  @override
  ConsumerState<NewProductsPage> createState() => _NewProductsPageState();
}

class _NewProductsPageState extends ConsumerState<NewProductsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  ProductCategory? _selectedCategory;
  _SortMode _selectedSort = _SortMode.newest;
  String _searchQuery = '';

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollToCollection() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        780,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  String _getCategoryTitle(ProductCategory category) {
    switch (category) {
      case ProductCategory.sofa:
        return "Koltuk & Kanepe";
      case ProductCategory.chair:
        return "Sandalye & Berjer";
      case ProductCategory.table:
        return "Yemek & Çalışma Masası";
      case ProductCategory.bed:
        return "Yatak & Baza";
      case ProductCategory.wardrobe:
        return "Gardırop & Dolap";
      case ProductCategory.white:
        return "Beyaz Eşya";
      case ProductCategory.other:
        return "Dekorasyon & Diğer";
    }
  }

  IconData _getCategoryIcon(ProductCategory category) {
    switch (category) {
      case ProductCategory.sofa:
        return Icons.weekend_outlined;
      case ProductCategory.chair:
        return Icons.chair_outlined;
      case ProductCategory.table:
        return Icons.table_restaurant_outlined;
      case ProductCategory.bed:
        return Icons.bed_outlined;
      case ProductCategory.wardrobe:
        return Icons.door_sliding_outlined;
      case ProductCategory.white:
        return Icons.kitchen_outlined;
      case ProductCategory.other:
        return Icons.category_outlined;
    }
  }

  String _getCategoryImageUrl(ProductCategory category) {
    switch (category) {
      case ProductCategory.sofa:
        return 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=80';
      case ProductCategory.chair:
        return 'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=800&q=80';
      case ProductCategory.table:
        return 'https://images.unsplash.com/photo-1530018607912-eff2daa1bac4?auto=format&fit=crop&w=800&q=80';
      case ProductCategory.bed:
        return 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80';
      case ProductCategory.wardrobe:
        return 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=800&q=80';
      case ProductCategory.white:
        return 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=800&q=80';
      case ProductCategory.other:
        return 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?auto=format&fit=crop&w=800&q=80';
    }
  }

  @override
  Widget build(final BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final isDesktop = context.isDesktop;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: productsAsync.when(
        loading: () => const FullPageShimmer(),
        error: (final e, final _) => _buildErrorState(context, e.toString()),
        data: (final _) {
          final products = ref.watch(newDealsProductsProvider);
          final filtered = _filterProducts(products);

          return Stack(
            children: [
              const Positioned.fill(child: AmbientMeshBackground()),
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 1. DRIBBBLE HERO VİTRİN
                  SliverToBoxAdapter(
                    child: _buildHeroSection(context, products.length),
                  ),

                  // 2. GÜVEN & MARKA BANDI (DOĞTAŞ, BELLONA, KELEBEK...)
                  SliverToBoxAdapter(
                    child: _buildBrandTicker(context),
                  ),

                  // 3. KATEGORİYE GÖRE KEŞFET (Dinamik HD Kartlar)
                  SliverToBoxAdapter(
                    child: _buildShopByCategorySection(context, products),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // 4. BÜYÜK WEB ARAMA KUTUSU (In-Place Canlı Arama & Filtreleme)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: context.sectionPadding.copyWith(top: 0, bottom: 20),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1240),
                          child: _buildLargeWebSearchBar(context),
                        ),
                      ),
                    ),
                  ),

                  // 5. ANA BÖLÜM (SOLDA ŞIK DİKEY KATEGORİ RAYI + SAĞDA YENİLENMİŞ ÜRÜN KARTLARI)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: context.sectionPadding.copyWith(top: 0, bottom: 36),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1240),
                          child: isDesktop
                              ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sol Dikey Yan Sekme
                              _buildVerticalCategoryRail(),
                              const SizedBox(width: 28),
                              // Sağ Ürün Grid Vitrini
                              Expanded(
                                child: _buildProductContent(context, filtered),
                              ),
                            ],
                          )
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHorizontalCategoryBar(),
                              const SizedBox(height: 20),
                              _buildProductContent(context, filtered),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 6. ADSENSE REKLAM ALANI
                  if (filtered.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: context.sectionPadding.copyWith(top: 16, bottom: 24),
                        child: const AdsenseBanner(height: 120, type: AdUnitType.multiplex),
                      ),
                    ),

                  SliverToBoxAdapter(child: SizedBox(height: context.spacingLarge * 2)),
                ],
              ),
              ScrollUpButton(scrollController: _scrollController),
            ],
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 1. HERO BÖLÜMÜ
  // ════════════════════════════════════════════════════════════

  Widget _buildHeroSection(final BuildContext context, final int totalProducts) {
    final isDesktop = context.isDesktop;

    final leftContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RevealFade(
          child: Text(
            context.l10n.newProductsBadgeEyebrow.toUpperCase(),
            style: AppTextStyles.microLabel(
              fontSize: 11,
              letterSpacing: 2.2,
              color: AppColors.accentDark,
            ),
          ),
        ),
        const SizedBox(height: 12),
        RevealFade(
          delayMs: 60,
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.fraunces(
                fontSize: context.responsive(mobile: 34, tablet: 44, desktop: 52),
                height: 1.1,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1E1815),
                letterSpacing: -0.5,
              ),
              children: [
                const TextSpan(text: "Yaşam Alanınız İçin\n"),
                TextSpan(
                  text: "Zamansız ",
                  style: TextStyle(
                    color: AppColors.accentDark,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: context.l10n.newCollection),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        RevealFade(
          delayMs: 120,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              context.l10n.newCollectionSub,
              style: TextStyle(
                fontSize: context.bodySize,
                color: const Color(0xFF7A6F66),
                height: 1.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        RevealFade(
          delayMs: 180,
          child: Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: _scrollToCollection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C241E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                label: const Icon(Icons.arrow_forward_rounded, size: 16),
                icon: const Text("Koleksiyonu İncele", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton.icon(
                onPressed: _scrollToCollection,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2C241E),
                  side: const BorderSide(color: Color(0xFFE5DFD7), width: 1.4),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.search_rounded, size: 16),
                label: const Text("Hızlı Filtrele", style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 36),
        RevealFade(
          delayMs: 240,
          child: Row(
            children: [
              _buildStatItem("$totalProducts+", "AKTİF ÜRÜN"),
              const SizedBox(width: 24),
              _buildStatItem("2.4k+", "MUTLU MÜŞTERİ"),
              const SizedBox(width: 24),
              _buildStatItem("%100", "KONTROLLÜ STOK"),
            ],
          ),
        ),
      ],
    );

    final heroImage = RevealFade(
      delayMs: 100,
      offsetY: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1200&q=80',
              height: context.responsive(mobile: 260.0, tablet: 340.0, desktop: 400.0),
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 340,
                color: AppColors.surface,
                child: Center(
                  child: Icon(Icons.chair_outlined, size: 80, color: AppColors.accentDark),
                ),
              ),
            ),
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.65)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.verified_outlined, size: 18, color: AppColors.accentDark),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.l10n.productTrustBadgeVerified,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        border: Border(bottom: BorderSide(color: const Color(0xFFEDE8E1).withOpacity(0.7))),
      ),
      padding: context.pagePadding.copyWith(
        top: context.responsive(mobile: 24, desktop: 40),
        bottom: context.responsive(mobile: 32, desktop: 44),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBreadcrumb(context),
              const SizedBox(height: 24),
              isDesktop
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 6, child: leftContent),
                  const SizedBox(width: 44),
                  Expanded(flex: 5, child: heroImage),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heroImage,
                  const SizedBox(height: 32),
                  leftContent,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(final String value, final String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.fraunces(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E1815),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: Color(0xFF8C827A),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // 2. MARKA & GÜVEN BANDI
  // ════════════════════════════════════════════════════════════

  Widget _buildBrandTicker(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF6F3EE),
        border: Border(bottom: BorderSide(color: Color(0xFFEAE3D8))),
      ),
      child: Center(
        child: Wrap(
          spacing: context.responsive(mobile: 24, desktop: 54),
          runSpacing: 10,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _tickerText("DOĞTAŞ"),
            _tickerText("BELLONA"),
            _tickerText("KELEBEK"),
            _tickerText("ENZA HOME"),
            _tickerText("İPEK MOBİLYA"),
            _tickerText("SPOT FIRSATLAR"),
          ],
        ),
      ),
    );
  }

  Widget _tickerText(final String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.2,
        color: Color(0xFF8C827A),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 3. KATEGORİYE GÖRE KEŞFET (Dinamik Kartlar)
  // ════════════════════════════════════════════════════════════

  Widget _buildShopByCategorySection(final BuildContext context, final List<Product> allProducts) {
    final availableCategories = ProductCategory.values.take(4).toList();

    return Padding(
      padding: context.sectionPadding.copyWith(top: 36, bottom: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.fraunces(
                        fontSize: context.responsive(mobile: 24, desktop: 30),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1E1815),
                      ),
                      children: [
                        const TextSpan(text: "Kategoriye Göre "),
                        TextSpan(
                          text: "Keşfet",
                          style: TextStyle(
                            color: AppColors.accentDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _selectedCategory = null);
                      _scrollToCollection();
                    },
                    child: const Row(
                      children: [
                        Text(
                          "Tümünü Göster",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E1815),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF1E1815)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = context.isDesktop
                      ? (constraints.maxWidth - (3 * 16)) / 4
                      : (constraints.maxWidth - 12) / 2;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: List.generate(availableCategories.length, (index) {
                      final cat = availableCategories[index];
                      final count = allProducts.where((p) => p.category == cat).length;
                      final imageUrl = _getCategoryImageUrl(cat);

                      return _buildVisualCategoryCard(
                        width: cardWidth,
                        title: _getCategoryTitle(cat),
                        itemCount: "$count Ürün",
                        imageUrl: imageUrl,
                        isSelected: _selectedCategory == cat,
                        onTap: () {
                          setState(() => _selectedCategory = cat);
                          _scrollToCollection();
                        },
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisualCategoryCard({
    required final double width,
    required final String title,
    required final String itemCount,
    required final String imageUrl,
    required final bool isSelected,
    required final VoidCallback onTap,
  }) {
    return TactilePress(
      onTap: onTap,
      child: Container(
        width: width,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: isSelected ? const Color(0xFF2C241E).withOpacity(0.20) : Colors.black.withOpacity(0.06),
              blurRadius: isSelected ? 16 : 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: isSelected ? const Color(0xFF2C241E) : Colors.white,
            width: isSelected ? 2.5 : 1.2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFFEBE5DF)),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.80),
                    ],
                    stops: const [0.35, 0.65, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    size: 14,
                    color: isSelected ? AppColors.accentDark : const Color(0xFF1E1815),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fraunces(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        itemCount,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 4. BÜYÜK VE OKUNAKLI WEB ARAMA ÇUBUĞU
  // ════════════════════════════════════════════════════════════

  Widget _buildLargeWebSearchBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE5DFD7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C2018).withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 24, color: Color(0xFF7A6F66)),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: GoogleFonts.inter(
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E1815),
              ),
              decoration: InputDecoration(
                hintText: "Eviniz için mobilya, koltuk, masa veya kategori ara...",
                hintStyle: GoogleFonts.inter(
                  fontSize: 14.5,
                  color: const Color(0xFFA69C92),
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 20, color: Color(0xFF7A6F66)),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),
          Container(
            height: 28,
            width: 1,
            color: const Color(0xFFE5DFD7),
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          GestureDetector(
            onTap: () => _openSortSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F1EB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.swap_vert_rounded, size: 18, color: Color(0xFF5D5248)),
                  const SizedBox(width: 6),
                  Text(
                    _sortLabel(_selectedSort),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B332B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 5. SOLDA DİKEY KATEGORİ RAYI (Vertical Rail)
  // ════════════════════════════════════════════════════════════

  Widget _buildVerticalCategoryRail() {
    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: const Color(0xFFEFE9E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRailIconItem(
            icon: Icons.grid_view_rounded,
            label: "Tümü",
            isSelected: _selectedCategory == null,
            onTap: () => setState(() => _selectedCategory = null),
          ),
          const SizedBox(height: 12),
          ...ProductCategory.values.map(
                (cat) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildRailIconItem(
                icon: _getCategoryIcon(cat),
                label: _getCategoryTitle(cat),
                isSelected: _selectedCategory == cat,
                onTap: () => setState(() => _selectedCategory = cat),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRailIconItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2C241E) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            size: 22,
            color: isSelected ? Colors.white : const Color(0xFF8C827A),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalCategoryBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildMobileCategoryPill(
            title: "Tümü",
            icon: Icons.grid_view_rounded,
            isSelected: _selectedCategory == null,
            onTap: () => setState(() => _selectedCategory = null),
          ),
          ...ProductCategory.values.map(
                (cat) => _buildMobileCategoryPill(
              title: _getCategoryTitle(cat),
              icon: _getCategoryIcon(cat),
              isSelected: _selectedCategory == cat,
              onTap: () => setState(() => _selectedCategory = cat),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCategoryPill({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2C241E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF2C241E) : const Color(0xFFE8E2D9),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : const Color(0xFF7A6F66)),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF2C241E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 6. ÜRÜN VİTRİNİ VE YENİLENMİŞ LUMA TARZI ÜRÜN KARTI
  // ════════════════════════════════════════════════════════════

  Widget _buildProductContent(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return _buildEmptyState(context);
    }

    final isDesktop = context.isDesktop;
    final crossAxisCount = isDesktop ? 3 : (context.isTablet ? 2 : 2);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: context.responsive(mobile: 0.68, tablet: 0.72, desktop: 0.76),
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return RevealFade(
          delayMs: (index % 6) * 30,
          offsetY: 12,
          child: _buildPremiumLumaProductCard(context, products[index]),
        );
      },
    );
  }

  // Yeni Luma & Minimal E-Ticaret Ürün Kartı
  Widget _buildPremiumLumaProductCard(BuildContext context, Product product) {
    return TactilePress(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFEDE7DF), width: 1.1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C241E).withOpacity(0.045),
              blurRadius: 18,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Üst Görsel Kutusu
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F4F0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: EditorialProductCard(product: product),
                  ),
                  // Sol Alt: Kırmızı YENİ / FIRSAT Rozeti
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "YENİ",
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  // Sağ Alt: Yıldızlı Puan Rozeti
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 3),
                          Text(
                            "4.8",
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E1815),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Ürün Başlığı
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.fraunces(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E1815),
              ),
            ),
            const SizedBox(height: 2),

            // Kategori Alt Başlığı
            Text(
              _getCategoryTitle(product.category),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8C827A),
              ),
            ),

            const SizedBox(height: 8),

            // Fiyat ve Yuvarlak Ekleme Butonu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "₺${product.price.toStringAsFixed(0)}",
                  style: GoogleFonts.inter(
                    fontSize: 17.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E1815),
                  ),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C241E),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEFE9E0)),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFFA69C92)),
          const SizedBox(height: 16),
          Text(
            "Aradığınız Kriterde Mobilya Bulunamadı",
            style: GoogleFonts.fraunces(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1E1815),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Arama kelimesini değiştirebilir ya da filtreleri temizleyebilirsiniz.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 13.5, color: const Color(0xFF8C827A)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline_rounded, size: 64, color: AppColors.error),
        const SizedBox(height: 14),
        Text(
          context.l10n.errorOccurred,
          style: TextStyle(fontSize: context.h4Size, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(error, style: TextStyle(color: AppColors.textSecondary)),
      ],
    ),
  );

  Widget _buildBreadcrumb(final BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.home_outlined, size: 13, color: Color(0xFF8C827A)),
      const SizedBox(width: 6),
      Text(context.l10n.breadcrumbHome,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8C827A))),
      const SizedBox(width: 6),
      const Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFF8C827A)),
      const SizedBox(width: 6),
      Text(
        context.l10n.newCollection,
        style: const TextStyle(
            fontSize: 12, color: Color(0xFF2C241E), fontWeight: FontWeight.w700),
      ),
    ],
  );

  List<Product> _filterProducts(List<Product> products) {
    var filtered = products;
    if (_selectedCategory != null) {
      filtered = filtered.where((final p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      filtered = filtered.where((final p) => p.name.toLowerCase().contains(query)).toList();
    }
    switch (_selectedSort) {
      case _SortMode.priceLowHigh:
        filtered.sort((final a, final b) => a.price.compareTo(b.price));
        break;
      case _SortMode.priceHighLow:
        filtered.sort((final a, final b) => b.price.compareTo(a.price));
        break;
      default:
        break;
    }
    return filtered;
  }

  void _openSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (final sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E2D9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Text(
                "Sıralama Seçenekleri",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E1815),
                ),
              ),
              const SizedBox(height: 12),
              ..._SortMode.values.map((mode) {
                final selected = mode == _selectedSort;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    _sortLabel(mode),
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? const Color(0xFF2C241E) : const Color(0xFF7A6F66),
                    ),
                  ),
                  trailing: selected ? const Icon(Icons.check_rounded, color: Color(0xFF2C241E)) : null,
                  onTap: () {
                    setState(() => _selectedSort = mode);
                    Navigator.pop(sheetContext);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _sortLabel(_SortMode mode) {
    switch (mode) {
      case _SortMode.newest:
        return "En Yeniler";
      case _SortMode.priceLowHigh:
        return "Fiyat: Düşükten Yükseğe";
      case _SortMode.priceHighLow:
        return "Fiyat: Yüksekten Düşüğe";
      case _SortMode.popular:
        return "En Çok İncelenenler";
    }
  }
}
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
        620,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  String _getCategoryTitle(BuildContext context, ProductCategory category) {
    switch (category) {
      case ProductCategory.sofa:
        return "Koltuk & Kanepe";
      case ProductCategory.chair:
        return "Sandalye & Berjer";
      case ProductCategory.table:
        return "Masa & Sandalye";
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

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F6),
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
                  // 1. HERO VİTRİN
                  SliverToBoxAdapter(
                    child: _buildHeroSection(context, products.length),
                  ),

                  // 2. GÜVEN & MARKA BANDI
                  SliverToBoxAdapter(
                    child: _buildBrandTicker(context),
                  ),

                  // 3. KATEGORİYE GÖRE KEŞFET (Dinamik HD Kartlar)
                  SliverToBoxAdapter(
                    child: _buildShopByCategorySection(context, products),
                  ),

                  // 4. KATEGORİ SEÇİM RAYI (Filter Chips)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: EditorialCategoryRail(
                        selected: _selectedCategory,
                        onSelect: (final c) =>
                            setState(() => _selectedCategory = c),
                        allLabel: context.l10n.conditionAll,
                        padding: context.sectionPadding.copyWith(
                            top: 0, bottom: 0),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: context.spacing)),

                  // 5. MATERIAL 3 CANLI ARAMA ÇUBUĞU (In-Page Search & Filter)
                  _buildM3SearchBar(context, filtered.length),

                  SliverToBoxAdapter(child: SizedBox(height: context.spacing)),

                  // 6. MATERIAL 3 ÜRÜN KARTLARI IZGARASI
                  _buildProductGrid(context, filtered),

                  // 7. ADSENSE REKLAM ALANI
                  if (filtered.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: context.sectionPadding.copyWith(
                            top: 32, bottom: 16),
                        child: const AdsenseBanner(
                            height: 120, type: AdUnitType.multiplex),
                      ),
                    ),

                  SliverToBoxAdapter(
                      child: SizedBox(height: context.spacingLarge * 2)),
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
                fontSize: context.responsive(
                    mobile: 36, tablet: 46, desktop: 54),
                height: 1.1,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
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
                color: AppColors.textSecondary,
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
                  backgroundColor: AppColors.textPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                label: const Icon(Icons.arrow_forward_rounded, size: 16),
                icon: const Text("Koleksiyonu İncele",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              OutlinedButton.icon(
                onPressed: _scrollToCollection,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: AppColors.border, width: 1.4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.search_rounded, size: 16),
                label: const Text("Fırsatları Filtrele",
                    style: TextStyle(fontWeight: FontWeight.w600)),
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
              height: context.responsive(
                  mobile: 260.0, tablet: 340.0, desktop: 400.0),
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 340,
                color: AppColors.surface,
                child: Center(
                  child: Icon(Icons.chair_outlined,
                      size: 80, color: AppColors.accentDark),
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
                    child: Icon(Icons.verified_outlined,
                        size: 18, color: AppColors.accentDark),
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
        color: AppColors.surface.withOpacity(0.6),
        border: Border(
            bottom: BorderSide(color: AppColors.border.withOpacity(0.5))),
      ),
      padding: context.pagePadding.copyWith(
        top: context.responsive(mobile: 24, desktop: 44),
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
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: AppColors.textTertiary,
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
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
            bottom: BorderSide(color: AppColors.border.withOpacity(0.5))),
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
      style: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.2,
        color: AppColors.textTertiary.withOpacity(0.7),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 3. KATEGORİYE GÖRE KEŞFET (HD Kartlar)
  // ════════════════════════════════════════════════════════════

  Widget _buildShopByCategorySection(
      final BuildContext context, final List<Product> allProducts) {
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
                        color: AppColors.textPrimary,
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
                    child: Row(
                      children: [
                        Text(
                          "Tümünü Göster",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded,
                            size: 14, color: AppColors.textPrimary),
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
                      final count =
                          allProducts.where((p) => p.category == cat).length;
                      final imageUrl = _getCategoryImageUrl(cat);

                      return _buildVisualCategoryCard(
                        width: cardWidth,
                        title: _getCategoryTitle(context, cat),
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
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.25)
                  : Colors.black.withOpacity(0.08),
              blurRadius: isSelected ? 18 : 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.white.withOpacity(0.7),
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
                errorBuilder: (_, __, ___) =>
                    Container(color: AppColors.surface),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.85),
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    size: 14,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
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
  // 4. MATERIAL 3 SEARCH BAR (Figma M3 Specs - In-Place Live Search)
  // ════════════════════════════════════════════════════════════

  Widget _buildM3SearchBar(final BuildContext context, final int resultCount) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: context.sectionPadding.copyWith(top: 8, bottom: 4),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color(0xFFE0D9D1),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2C2018).withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // M3 Search Icon
                    const Icon(
                      Icons.search_rounded,
                      size: 22,
                      color: Color(0xFF5D544C),
                    ),
                    const SizedBox(width: 12),

                    // M3 Live Search TextField
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E1A16),
                        ),
                        decoration: InputDecoration(
                          hintText: "Eviniz için ürün, mobilya veya marka ara...",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF8C827A),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),

                    // Clear search button
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            size: 18, color: Color(0xFF8C827A)),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      ),

                    // Vertical M3 Divider
                    Container(
                      height: 24,
                      width: 1,
                      color: const Color(0xFFE6E0D9),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // M3 Sort Button
                    _M3ActionButton(
                      icon: Icons.swap_vert_rounded,
                      label: _sortLabel(context, _selectedSort),
                      onTap: () => _openSortSheet(context),
                    ),

                    const SizedBox(width: 8),

                    // M3 Grid/List Switcher
                    _ViewToggle(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  void _openSortSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (final sheetContext) => _SortSheet<_SortMode>(
        title: context.l10n.sortPanelTitle,
        options: _SortMode.values,
        current: _selectedSort,
        labelBuilder: (final m) => _sortLabel(context, m),
        onSelect: (final m) {
          setState(() => _selectedSort = m);
          Navigator.pop(sheetContext);
        },
      ),
    );
  }

  String _sortLabel(final BuildContext context, final _SortMode mode) {
    switch (mode) {
      case _SortMode.newest:
        return "Yeniler";
      case _SortMode.priceLowHigh:
        return "En Düşük Fiyat";
      case _SortMode.priceHighLow:
        return "En Yüksek Fiyat";
      case _SortMode.popular:
        return "Popüler";
    }
  }

  // ════════════════════════════════════════════════════════════
  // 5. MATERIAL 3 ELEVATED PRODUCT GRID
  // ════════════════════════════════════════════════════════════

  Widget _buildProductGrid(
      final BuildContext context, final List<Product> products) {
    if (products.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState(context));
    }

    if (ref.watch(productViewModeProvider) == ProductViewMode.list) {
      return SliverPadding(
        padding: context.sectionPadding.copyWith(top: 12),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (final context, final index) => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildM3ProductCard(context, products[index]),
                ),
              ),
            ),
            childCount: products.length,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: context.sectionPadding.copyWith(top: 12),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.responsive(
              mobile: 2, tablet: 3, desktop: 4, largeDesktop: 4),
          crossAxisSpacing: 18,
          mainAxisSpacing: 20,
          childAspectRatio: context.responsive(
              mobile: 0.67, tablet: 0.72, desktop: 0.76),
        ),
        delegate: SliverChildBuilderDelegate(
              (final context, final index) {
            if (isAdSlot(index, products.length)) return const NativeAdCard();
            final realIndex = realIndexForAdGrid(index, products.length);
            if (realIndex >= products.length) return const SizedBox.shrink();
            return RevealFade(
              delayMs: (realIndex % 8) * 35,
              offsetY: 16,
              child: _buildM3ProductCard(context, products[realIndex]),
            );
          },
          childCount: paddedItemCountForAds(products.length),
        ),
      ),
    );
  }

  // Figma M3 Elevated Card Spec
  Widget _buildM3ProductCard(BuildContext context, Product product) {
    return TactilePress(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFEBE5DF),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C2018).withOpacity(0.07),
              blurRadius: 14,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFF2C2018).withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün Görseli (Top Radius & Category Badge)
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(19)),
                    child: _buildProductImage(product),
                  ),

                  // Category M3 Surface Badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.70),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getCategoryTitle(context, product.category).toUpperCase(),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Ürün Bilgi Alanı
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E1A16),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "₺${product.price.toStringAsFixed(0)}",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF8B4513),
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4EDE6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: Color(0xFF5D544C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return EditorialProductCard(product: product);
  }

  Widget _buildEmptyState(final BuildContext context) => Padding(
    padding: context.sectionPadding.copyWith(top: 40, bottom: 60),
    child: Column(
      children: [
        Icon(Icons.search_off_rounded,
            size: 48, color: AppColors.textTertiary.withOpacity(0.6)),
        const SizedBox(height: 14),
        Text(
          "Aradığınız kriterlere uygun ürün bulunamadı",
          style: GoogleFonts.fraunces(
            fontSize: 18,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Farklı anahtar kelimeler veya kategoriler seçerek tekrar deneyin.",
          style: TextStyle(fontSize: 13, color: AppColors.textTertiary),
        ),
      ],
    ),
  );

  Widget _buildErrorState(final BuildContext context, final String error) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: AppColors.error),
            const SizedBox(height: 14),
            Text(
              context.l10n.errorOccurred,
              style: TextStyle(
                  fontSize: context.h4Size, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(error, style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );

  Widget _buildBreadcrumb(final BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.home_outlined, size: 13, color: AppColors.textTertiary),
      const SizedBox(width: 6),
      Text(context.l10n.breadcrumbHome,
          style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
      const SizedBox(width: 6),
      Icon(Icons.chevron_right_rounded,
          size: 14, color: AppColors.textTertiary),
      const SizedBox(width: 6),
      Text(
        context.l10n.newCollection,
        style: TextStyle(
            fontSize: 12,
            color: AppColors.primary,
            fontWeight: FontWeight.w700),
      ),
    ],
  );

  // Canlı arama ve kategori/fiyat filtrelemesi
  List<Product> _filterProducts(final List<Product> products) {
    var filtered = products;
    if (_selectedCategory != null) {
      filtered =
          filtered.where((final p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      filtered = filtered
          .where((final p) => p.name.toLowerCase().contains(query))
          .toList();
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
}

class _M3ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _M3ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    final showLabel = context.isTablet || context.isDesktop;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F2EC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF5D544C)),
            if (showLabel) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3B332B),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ViewToggle extends ConsumerWidget {
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final mode = ref.watch(productViewModeProvider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _viewIcon(
          icon: Icons.grid_view_rounded,
          isSelected: mode == ProductViewMode.grid,
          onTap: () =>
              ref.read(productViewModeProvider.notifier).set(ProductViewMode.grid),
        ),
        const SizedBox(width: 6),
        _viewIcon(
          icon: Icons.view_list_rounded,
          isSelected: mode == ProductViewMode.list,
          onTap: () =>
              ref.read(productViewModeProvider.notifier).set(ProductViewMode.list),
        ),
      ],
    );
  }

  Widget _viewIcon({
    required final IconData icon,
    required final bool isSelected,
    required final VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2C2018) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isSelected ? Colors.white : const Color(0xFF8C827A),
          ),
        ),
      );
}

class _SortSheet<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T current;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onSelect;

  const _SortSheet({
    required this.title,
    required this.options,
    required this.current,
    required this.labelBuilder,
    required this.onSelect,
  });

  @override
  Widget build(final BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFE0D9D1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: const Color(0xFF8C827A),
            ),
          ),
          const SizedBox(height: 12),
          ...options.map((final o) {
            final selected = o == current;
            return GestureDetector(
              onTap: () => onSelect(o),
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFF5EFE9)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        labelBuilder(o),
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selected
                              ? const Color(0xFF2C2018)
                              : const Color(0xFF5D544C),
                        ),
                      ),
                    ),
                    if (selected)
                      const Icon(Icons.check_circle_rounded,
                          size: 20, color: Color(0xFF2C2018)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    ),
  );
}
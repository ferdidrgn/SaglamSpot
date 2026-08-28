import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saglamspot/features/products/presentation/providers/product_filters_provider.dart';
import '../../../../core/ads/widgets/ad_grid_helper.dart';
import '../../../../core/ads/widgets/adsense_banner.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/catalog_theme.dart';
import '../../../../core/widgets/design_system/reveal_fade.dart';
import '../../../../core/widgets/design_system/tactile_press.dart';
import '../../../../core/widgets/editorial_product_grid_widgets.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
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
        return "Yemek Masası";
      case ProductCategory.bed:
        return "Yatak & Baza";
      case ProductCategory.wardrobe:
        return "Gardırop & Dolap";
      case ProductCategory.white:
        return "Beyaz Eşya";
      case ProductCategory.other:
        return "Dekorasyon";
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
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                      child: _buildHeroSection(context, products.length)),
                  SliverToBoxAdapter(child: _buildBrandTicker(context)),
                  SliverToBoxAdapter(
                      child: _buildShopByCategorySection(context, products)),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: context.sectionPadding.copyWith(
                          top: 0, bottom: 20),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1240),
                          child: _buildRefinedSearchBox(context),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: context.sectionPadding.copyWith(
                          top: 0, bottom: 36),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1240),
                          child: isDesktop
                              ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildVerticalCategoryRail(),
                              const SizedBox(width: 28),
                              Expanded(child: _buildProductContent(
                                  context, filtered)),
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
                  if (filtered.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: context.sectionPadding.copyWith(
                            top: 16, bottom: 24),
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

  // ============================================================
  // 1. HERO
  // ============================================================
  Widget _buildHeroSection(final BuildContext context,
      final int totalProducts) {
    final isDesktop = context.isDesktop;
    final leftContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RevealFade(
          child: Text(
            context.l10n.newProductsBadgeEyebrow.toUpperCase(),
            style: AppTextStyles.microLabel(
                fontSize: 11, letterSpacing: 2.2, color: AppColors.accentDark),
          ),
        ),
        const SizedBox(height: 12),
        RevealFade(
          delayMs: 60,
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.fraunces(
                fontSize: context.responsive(
                    mobile: 34, tablet: 44, desktop: 52),
                height: 1.1,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1E1815),
                letterSpacing: -0.5,
              ),
              children: [
                const TextSpan(text: "Yaşam Alanınız İçin\n"),
                TextSpan(
                  text: "Zamansız ",
                  style: TextStyle(color: AppColors.accentDark,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500),
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
              style: TextStyle(fontSize: context.bodySize,
                  color: const Color(0xFF7A6F66),
                  height: 1.6),
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
                  foregroundColor: const Color(0xFF2C241E),
                  side: const BorderSide(color: Color(0xFFE5DFD7), width: 1.4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.search_rounded, size: 16),
                label: const Text("Hızlı Filtrele",
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
              errorBuilder: (_, __, ___) =>
                  Container(
                    height: 340,
                    color: AppColors.surface,
                    child: Center(child: Icon(Icons.chair_outlined, size: 80,
                        color: AppColors.accentDark)),
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
                        shape: BoxShape.circle),
                    child: Icon(Icons.verified_outlined, size: 18,
                        color: AppColors.accentDark),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.l10n.productTrustBadgeVerified,
                    style: const TextStyle(color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
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
        border: Border(bottom: BorderSide(
            color: const Color(0xFFEDE8E1).withOpacity(0.7))),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: FurnitureMotifBackdrop()),
          Padding(
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(final String value, final String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.fraunces(fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1815)),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: Color(0xFF8C827A)),
        ),
      ],
    );
  }

  // ============================================================
  // 2. MARKA BANDI
  // ============================================================
  Widget _buildBrandTicker(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF4EFE6),
        border: Border(bottom: BorderSide(color: Color(0xFFE8E1D5))),
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

  // ============================================================
  // 3. KATEGORİ KEŞFET
  // ============================================================
  Widget _buildShopByCategorySection(final BuildContext context,
      final List<Product> allProducts) {
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
                          style: TextStyle(color: AppColors.accentDark,
                              fontWeight: FontWeight.w600),
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
                        Text("Tümünü Göster", style: TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E1815))),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 14,
                            color: Color(0xFF1E1815)),
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
                    children: List.generate(
                        availableCategories.length, (index) {
                      final cat = availableCategories[index];
                      final count = allProducts
                          .where((p) => p.category == cat)
                          .length;
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
              color: isSelected
                  ? const Color(0xFF2C241E).withOpacity(0.20)
                  : Colors.black.withOpacity(0.06),
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
                errorBuilder: (_, __, ___) =>
                    Container(color: const Color(0xFFEBE5DF)),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.80)
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
                      shape: BoxShape.circle),
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    size: 14,
                    color: isSelected ? AppColors.accentDark : const Color(
                        0xFF1E1815),
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
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        itemCount,
                        style: const TextStyle(fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
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

  // ============================================================
  // 4. ARAMA ÇUBUĞU
  // ============================================================
  Widget _buildRefinedSearchBox(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE5DFD7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C2018).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 22, color: Color(0xFF8B7D72)),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              style: GoogleFonts.inter(fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2C241E)),
              decoration: InputDecoration(
                hintText: "Mobilya, koltuk, masa veya kategori ara...",
                hintStyle: GoogleFonts.inter(
                    fontSize: 14, color: const Color(0xFFA69C92)),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: const Icon(
                  Icons.close_rounded, size: 18, color: Color(0xFF8B7D72)),
            ),
          Container(height: 24,
              width: 1,
              color: const Color(0xFFEBE5DE),
              margin: const EdgeInsets.symmetric(horizontal: 12)),
          GestureDetector(
            onTap: () => _openSortSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFF7F4F0),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const Icon(Icons.swap_vert_rounded, size: 18,
                      color: Color(0xFF5D5248)),
                  const SizedBox(width: 6),
                  Text(
                    _sortLabel(_selectedSort),
                    style: GoogleFonts.inter(fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3B332B)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 5. KATEGORİ RAYLARI
  // ============================================================
  Widget _buildVerticalCategoryRail() {
    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: const Color(0xFFEFE9E0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.025),
              blurRadius: 14,
              offset: const Offset(0, 4))
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
                (cat) =>
                Padding(
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
          child: Icon(icon, size: 22,
              color: isSelected ? Colors.white : const Color(0xFF8C827A)),
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
                (cat) =>
                _buildMobileCategoryPill(
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
                color: isSelected ? const Color(0xFF2C241E) : const Color(
                    0xFFE8E2D9)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16,
                  color: isSelected ? Colors.white : const Color(0xFF7A6F66)),
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

  // ============================================================
  // 6. ANA GRID VE SON KART (TEK KART, RENKLİ)
  // ============================================================
  Widget _buildProductContent(BuildContext context, List<Product> products) {
    if (products.isEmpty) return _buildEmptyState(context);

    final isDesktop = context.isDesktop;
    final crossAxisCount = isDesktop ? 3 : (context.isTablet ? 2 : 2);
    final childAspectRatio = isDesktop ? 0.72 : (context.isTablet
        ? 0.75
        : 0.70);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: paddedItemCountForAds(products.length),
      itemBuilder: (context, index) {
        if (isAdSlot(index, products.length)) return const NativeAdCard();
        final realIndex = realIndexForAdGrid(index, products.length);
        return _buildFinalCard(context, products[realIndex]);
      },
    );
  }

  // ============================================================
  // SON KART - Renkli, okunur, boşluksuz
  // ============================================================
  Widget _buildFinalCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => NavigationHandler.goToProduct(
        context: context,
        productId: product.id,
        productSlug: product.name.toSlug(),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: NewCollectionPalette.background, // Sayfa ile aynı sıcak bej
          borderRadius: BorderRadius.circular(NewCollectionPalette.cardRadius),
          border: Border.all(color: NewCollectionPalette.cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C2018).withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. GÖRSEL (Üst %55) ---
            Expanded(
              flex: 55,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: product.imagesUrl.isNotEmpty
                        ? OptimizedCachedImage(
                            imageUrl: product.imagesUrl.first,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            borderRadius: 0,
                            errorBuilder: (_, __, ___) =>
                                const _NewCardImageFallback(),
                          )
                        : const _NewCardImageFallback(),
                  ),
                  // Kategori etiketi (sol üst)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getCategoryTitle(product.category).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3D3630),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  // Favori butonu (sağ üst)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_border, size: 18,
                          color: Color(0xFF3D3630)),
                    ),
                  ),
                  // Fiyat etiketi (görsel alt sağ)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C241E).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "₺${product.price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. İÇERİK (Alt %45) - Boşluk azaltıldı ---
            Expanded(
              flex: 45,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
                // Üst boşluk 10'a düşürüldü
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Başlık
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getCategoryTitle(product.category).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9C938A),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: NewCollectionPalette.headingFont,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2C241E),
                            // Sayfa ile uyumlu koyu kahve
                            height: 1.2,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),

                    // Bilgi satırları
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SATIR: SIFIR rozeti (bu sayfadaki tüm ürünler
                        // gerçekten sıfır olduğu için doğru bir bilgi —
                        // spot sayfasındaki gibi sahte bir yıldız puanı ya
                        // da uydurma "popülerlik" metni YOK) + stok.
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: NewCollectionPalette.badgeGreenBg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: NewCollectionPalette.badgeGreenBorder),
                              ),
                              child: Text(
                                "SIFIR",
                                style: TextStyle(fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: NewCollectionPalette.badgeGreen,
                                    letterSpacing: 0.5),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(width: 3,
                                height: 3,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFD1D5DB),
                                    shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            const Icon(Icons.check_circle, size: 12,
                                color: Color(0xFF16A34A)),
                            const SizedBox(width: 4),
                            const Text(
                              "Stokta",
                              style: TextStyle(fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF16A34A)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // 3. SATIR: Teslimat + Buton
                        Row(
                          children: [
                            const Icon(Icons.local_shipping_outlined, size: 14,
                                color: Color(0xFF6B7280)),
                            const SizedBox(width: 6),
                            const Text(
                              "Ücretsiz teslimat",
                              style: TextStyle(fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B7280)),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2C241E),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "İncele",
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_rounded, size: 12,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
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
          const Icon(
              Icons.search_off_rounded, size: 48, color: Color(0xFFA69C92)),
          const SizedBox(height: 16),
          Text(
            "Aradığınız Kriterde Mobilya Bulunamadı",
            style: GoogleFonts.fraunces(fontSize: 20,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E1815)),
          ),
          const SizedBox(height: 6),
          Text(
            "Arama kelimesini değiştirebilir ya da filtreleri temizleyebilirsiniz.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 13.5, color: const Color(0xFF8C827A)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: AppColors.error),
            const SizedBox(height: 14),
            Text(context.l10n.errorOccurred, style: TextStyle(
                fontSize: context.h4Size, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(error, style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );

  Widget _buildBreadcrumb(final BuildContext context) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.home_outlined, size: 13, color: Color(0xFF8C827A)),
          const SizedBox(width: 6),
          Text(context.l10n.breadcrumbHome,
              style: const TextStyle(fontSize: 12, color: Color(0xFF8C827A))),
          const SizedBox(width: 6),
          const Icon(
              Icons.chevron_right_rounded, size: 14, color: Color(0xFF8C827A)),
          const SizedBox(width: 6),
          Text(context.l10n.newCollection, style: const TextStyle(fontSize: 12,
              color: Color(0xFF2C241E),
              fontWeight: FontWeight.w700)),
        ],
      );

  List<Product> _filterProducts(List<Product> products) {
    var filtered = products;
    if (_selectedCategory != null) {
      filtered =
          filtered.where((final p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery
        .trim()
        .isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      filtered =
          filtered
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

  void _openSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (final sheetContext) =>
          SafeArea(
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
                      decoration: BoxDecoration(color: const Color(0xFFE8E2D9),
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  Text(
                    "Sıralama Seçenekleri",
                    style: GoogleFonts.inter(fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1815)),
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
                          fontWeight: selected ? FontWeight.w700 : FontWeight
                              .w500,
                          color: selected
                              ? const Color(0xFF2C241E)
                              : const Color(0xFF7A6F66),
                        ),
                      ),
                      trailing: selected ? const Icon(
                          Icons.check_rounded, color: Color(0xFF2C241E)) : null,
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

/// Ürünün gerçek fotoğrafı yoksa ya da yüklenemezse gösterilen yedek görsel.
class _NewCardImageFallback extends StatelessWidget {
  const _NewCardImageFallback();

  @override
  Widget build(BuildContext context) => Container(
        color: const Color(0xFFF0EBE3),
        child: const Center(
          child: Icon(Icons.chair_outlined, size: 48, color: Color(0xFFB0A59A)),
        ),
      );
}

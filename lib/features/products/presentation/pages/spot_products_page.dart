import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saglamspot/features/products/presentation/providers/product_filters_provider.dart';
import '../../../../core/ads/widgets/ad_grid_helper.dart';
import '../../../../core/ads/widgets/adsense_banner.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_wear_tier_ex.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/providers/product_view_mode_provider.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/catalog_theme.dart';
import '../../../../core/widgets/design_system/glass_surface.dart';
import '../../../../core/widgets/design_system/hud_corner_frame.dart';
import '../../../../core/widgets/design_system/reveal_fade.dart';
import '../../../../core/widgets/design_system/tactile_press.dart';
import '../../../../core/widgets/editorial_product_grid_widgets.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../core/widgets/shimmer_components.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../domain/entites/product.dart';

/// "Spot / İkinci El Ürünler" — KÖKLÜ, ikinci kez baştan tasarlandı.
enum _SortMode { newest, priceLowHigh, priceHighLow, popular }

class SpotProductsPage extends ConsumerStatefulWidget {
  const SpotProductsPage({super.key});

  @override
  ConsumerState<SpotProductsPage> createState() => _SpotProductsPageState();
}

class _SpotProductsPageState extends ConsumerState<SpotProductsPage> {
  final ScrollController _scrollController = ScrollController();
  ProductCategory? _selectedCategory;
  _SortMode _selectedSort = _SortMode.newest;
  RangeValues _priceRange = const RangeValues(0, 50000);
  bool _priceFilterActive = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Kategori başlıkları
  String _getCategoryTitle(ProductCategory category) {
    switch (category) {
      case ProductCategory.sofa: return "Koltuk & Kanepe";
      case ProductCategory.chair: return "Sandalye & Berjer";
      case ProductCategory.table: return "Yemek Masası";
      case ProductCategory.bed: return "Yatak & Baza";
      case ProductCategory.wardrobe: return "Gardırop & Dolap";
      case ProductCategory.white: return "Beyaz Eşya";
      case ProductCategory.other: return "Dekorasyon";
    }
  }

  IconData _getCategoryIcon(ProductCategory category) {
    switch (category) {
      case ProductCategory.sofa: return Icons.weekend_outlined;
      case ProductCategory.chair: return Icons.chair_outlined;
      case ProductCategory.table: return Icons.table_restaurant_outlined;
      case ProductCategory.bed: return Icons.bed_outlined;
      case ProductCategory.wardrobe: return Icons.door_sliding_outlined;
      case ProductCategory.white: return Icons.kitchen_outlined;
      case ProductCategory.other: return Icons.category_outlined;
    }
  }

  @override
  Widget build(final BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      body: productsAsync.when(
        loading: () => const FullPageShimmer(),
        error: (final e, final _) => _buildErrorState(context, e.toString()),
        data: (final _) {
          final products = ref.watch(spotDealsProductsProvider);
          final filtered = _filterProducts(products);

          return Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildMasthead(context, products.length)),

                  // Üstte arama + sıralama çubuğu — new-products sayfasıyla
                  // aynı 1240px merkezi sınır, kenarlara yapışmasın diye.
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1240),
                          child: _buildSearchAndFilters(context, filtered.length),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  SliverToBoxAdapter(child: _buildAphorismSection(context)),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // ANA KISIM: arama bitiminde hemen aşağı doğru başlar —
                  // sol tarafta ürünler, sağında dikey kategori rail'i.
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1240),
                          child: context.isDesktop
                              ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sol: Ürünler
                              Expanded(
                                child: _buildProductGrid(context, filtered),
                              ),
                              const SizedBox(width: 20),
                              // Sağ: Dikey Kategori Rail
                              _buildVerticalCategoryRail(),
                            ],
                          )
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Mobil: Kategori bar yatay
                              _buildHorizontalCategoryBar(),
                              const SizedBox(height: 16),
                              _buildProductGrid(context, filtered),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (filtered.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1240),
                            child: const AdsenseBanner(height: 100, type: AdUnitType.multiplex),
                          ),
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
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
  // 1. HERO (Aynen korundu)
  // ============================================================
  Widget _buildMasthead(final BuildContext context, final int totalProducts) {
    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RevealFade(
          child: Text(
            "FIRSAT DEPOSU",
            style: AppTextStyles.microLabel(fontSize: 12, letterSpacing: 3, color: const Color(0xFFE65100)),
          ),
        ),
        const SizedBox(height: 8),
        RevealFade(
          delayMs: 70,
          child: Text(
            "İkinci El & Spot",
            style: GoogleFonts.spaceGrotesk(
              fontSize: context.responsive(mobile: 34, tablet: 46, desktop: 58),
              fontWeight: FontWeight.w700,
              height: 1.02,
              color: const Color(0xFF1A1A1A),
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        RevealFade(
          delayMs: 140,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.responsive(mobile: 400, desktop: 460)),
            child: Text(
              "Kullanılmış ama kullanışlı. Her bütçeye uygun, yeni gibi ürünler. Pazarlık payı açıktır.",
              style: TextStyle(fontSize: context.bodySize, color: const Color(0xFF5A5A5A), height: 1.6),
            ),
          ),
        ),
        SizedBox(height: context.spacing),
        RevealFade(
          delayMs: 210,
          child: Wrap(
            spacing: 18,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text("${totalProducts}+ Fırsat",
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
              _dotSep(),
              _plainStat("Pazarlık Payı Mevcut"),
              _dotSep(),
              _plainStat("Kullanılmış"),
            ],
          ),
        ),
      ],
    );

    final showcase = RevealFade(
      delayMs: 100,
      offsetY: 20,
      child: _buildShowcaseImage(
        context: context,
        imageUrl: 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=900&q=80',
        // NOT: "siz teklif verin, biz değerlendirelim" gibi satıcı davet
        // eden bir metin BİLİNÇLİ olarak kullanılmıyor — bu sayfa alım
        // odaklı bir vitrin, eşya satmak isteyenler için bir başvuru kanalı
        // değil.
        badgeIcon: Icons.task_alt_rounded,
        badgeTitle: "Elden Geçirildi",
        badgeSubtitle: "Her ürün teslimden önce tek tek kontrol edilir.",
        accentColor: const Color(0xFFE65100),
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(child: FurnitureMotifBackdrop()),
        Padding(
          padding: context.pagePadding.copyWith(
              top: context.responsive(mobile: 20, tablet: 28, desktop: 40), bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBreadcrumb(context),
              SizedBox(height: context.spacingLarge),
              context.isDesktop
                  ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 6, child: textColumn),
                  SizedBox(width: context.spacingLarge),
                  Expanded(flex: 5, child: showcase),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  showcase,
                  SizedBox(height: context.spacingLarge),
                  textColumn,
                ],
              ),
              SizedBox(height: context.spacingLarge),
              const FurnitureMotifDivider(),
              SizedBox(height: context.spacingLarge),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShowcaseImage({
    required final BuildContext context,
    required final String imageUrl,
    required final IconData badgeIcon,
    required final String badgeTitle,
    required final String badgeSubtitle,
    required final Color accentColor,
  }) {
    final imageHeight = context.responsive(mobile: 300.0, tablet: 420.0, desktop: 520.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: TactilePress(
        child: HudCornerFrame(
          armLength: 22,
          inset: 12,
          color: accentColor,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(context.borderRadius(1.1)),
                // Görsel, yazının hemen altından %10 saydamlıkla başlayıp
                // aşağı doğru yumuşakça tam opağa bağlanıyor — "yazının
                // altından beliren şık bir ev dekorasyonu görseli" hissi.
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (final rect) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x1AFFFFFF), Colors.white],
                    stops: [0.0, 0.42],
                  ).createShader(rect),
                  child: OptimizedCachedImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: imageHeight,
                    fit: BoxFit.cover,
                    borderRadius: 0,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: -28,
                child: GlassSurface(
                  borderRadius: 18,
                  strong: true,
                  chromaticEdge: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(badgeIcon, color: accentColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(badgeTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A))),
                            const SizedBox(height: 2),
                            Text(badgeSubtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11, color: Color(0xFF5A5A5A))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dotSep() => Text('•', style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12));

  Widget _plainStat(final String label) => Text(label,
      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF5A5A5A)));

  Widget _buildBreadcrumb(final BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.home_outlined, size: 13, color: const Color(0xFF9E9E9E)),
      const SizedBox(width: 6),
      Text("Ana Sayfa", style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E))),
      const SizedBox(width: 6),
      Icon(Icons.chevron_right_rounded, size: 14, color: const Color(0xFF9E9E9E)),
      const SizedBox(width: 6),
      const Text("Spot & İkinci El",
          style: TextStyle(fontSize: 12, color: Color(0xFFE65100), fontWeight: FontWeight.w700)),
    ],
  );

  // ============================================================
  // 1.5 "BİR SÖZÜMÜZ VAR" — İkinci elin ruhunu anlatan kısa, çarpıcı bir
  // söz + birkaç soluk mobilya motifi. Sayfaya duygusal bir ağırlık
  // katıyor; new-products'ın "zamansız koleksiyon" havasının tam
  // karşısında, "eski ama değerli" havasını pekiştiriyor.
  // ============================================================
  Widget _buildAphorismSection(final BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.symmetric(
                  horizontal: context.responsive(mobile: 26, desktop: 60),
                  vertical: context.responsive(mobile: 32, desktop: 52)),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -6,
                    left: context.isMobile ? -4 : 8,
                    child: Icon(Icons.format_quote_rounded,
                        size: 60, color: const Color(0xFFE65100).withOpacity(0.35)),
                  ),
                  Positioned(
                    right: -14,
                    bottom: -20,
                    child: Transform.rotate(
                      angle: -0.14,
                      child: Icon(Icons.chair_rounded,
                          size: 100, color: Colors.white.withOpacity(0.045)),
                    ),
                  ),
                  if (!context.isMobile)
                    Positioned(
                      right: 140,
                      top: 20,
                      child: Transform.rotate(
                        angle: 0.2,
                        child: Icon(Icons.emoji_objects_outlined,
                            size: 42, color: Colors.white.withOpacity(0.05)),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("BİR SÖZÜMÜZ VAR",
                          style: AppTextStyles.microLabel(
                              fontSize: 11,
                              letterSpacing: 3,
                              color: const Color(0xFFE65100))),
                      const SizedBox(height: 16),
                      Text(
                        "Eskimiş değil, emek görmüş.\nİyi mobilya asla eskimez, sadece ev değiştirir.",
                        style: GoogleFonts.fraunces(
                          fontSize: context.responsive(mobile: 22, tablet: 28, desktop: 34),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Text(
                          "Biz de tam bu yüzden buradayız: hâlâ hayatı olan parçaları, onlara değer verecek yeni bir eve ulaştırmak için.",
                          style: TextStyle(
                              fontSize: context.bodySize,
                              color: Colors.white.withOpacity(0.55),
                              height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  // ============================================================
  // 2. ARAMA + FİLTRELER (Üstte Yatay)
  // ============================================================
  Widget _buildSearchAndFilters(BuildContext context, int resultCount) {
    final isDesktop = context.isDesktop;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A1A).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Arama (Sol)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 12),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, size: 20, color: Color(0xFF5A5A5A)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Fırsat ara...",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF5A5A5A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filtreler (Sağ)
          if (isDesktop) ...[
            Container(width: 1, height: 24, color: const Color(0xFFE0E0E0)),
            const SizedBox(width: 8),

            _buildFilterButton(
              icon: Icons.tune_rounded,
              label: "Fiyat Aralığı",
              isActive: _priceFilterActive,
              onTap: () => _openPriceFilterSheet(context),
            ),

            const SizedBox(width: 8),
            Container(width: 1, height: 24, color: const Color(0xFFE0E0E0)),
            const SizedBox(width: 8),

            _buildFilterButton(
              icon: Icons.swap_vert_rounded,
              label: _sortLabel(_selectedSort),
              isActive: false,
              onTap: () => _openSortSheet(context),
            ),

            const SizedBox(width: 8),
            Container(width: 1, height: 24, color: const Color(0xFFE0E0E0)),
            const SizedBox(width: 8),

            _ViewToggle(),
            const SizedBox(width: 8),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.tune_rounded, size: 22, color: Color(0xFF1A1A1A)),
              onPressed: () => _openFilterSheet(context),
            ),
            const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE65100).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isActive ? const Color(0xFFE65100) : const Color(0xFF5A5A5A)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? const Color(0xFFE65100) : const Color(0xFF5A5A5A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 3. SAĞ DİKEY KATEGORİ RAİL — ürünlerin sağında, arama çubuğunun
  // hemen altında başlayıp aşağı doğru sıralı.
  // ============================================================
  Widget _buildVerticalCategoryRail() {
    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: const Color(0xFFE8E3DC), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
          ).toList(),
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
            color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
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

  // ============================================================
  // 4. YATAY KATEGORİ BAR (Mobil için)
  // ============================================================
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
          ).toList(),
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
            color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFFE8E2D9),
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
                  color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 5. ÜRÜN GRİDİ (İÇ İÇE OLMAYAN TEK KART)
  // ============================================================
  Widget _buildProductGrid(final BuildContext context, final List<Product> products) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: _buildEmptyState(context),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.responsive(mobile: 2, tablet: 3, desktop: 3, largeDesktop: 4),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: context.responsive(mobile: 0.64, tablet: 0.68, desktop: 0.71),
      ),
      itemCount: paddedItemCountForAds(products.length),
      itemBuilder: (final context, final index) {
        if (isAdSlot(index, products.length)) {
          return const RevealFade(offsetY: 18, child: NativeAdCard());
        }
        final realIndex = realIndexForAdGrid(index, products.length);
        return RevealFade(
          delayMs: (index % 8) * 45,
          offsetY: 18,
          child: _buildSingleSpotCard(context, products[realIndex]),
        );
      },
    );
  }

  // ================================================================
  // TEK KART (SIFIRDAN - EditorialProductCard KULLANILMADI)
  // ================================================================
  Widget _buildSingleSpotCard(BuildContext context, Product product) {
    final imageUrl = product.imagesUrl.isNotEmpty ? product.imagesUrl.first : null;

    return GestureDetector(
      onTap: () => NavigationHandler.goToProduct(
        context: context,
        productId: product.id,
        productSlug: product.name.toSlug(),
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: SpotPalette.cardBackground,
          borderRadius: BorderRadius.circular(SpotPalette.cardRadius),
          // Sol kenardaki kalın turuncu şerit, "fiyat etiketi" hissi
          // veriyor — Sıfır kartlarının yumuşak, şeritsiz haliyle bilinçli
          // bir zıtlık kuruyor.
          border: Border(
            top: BorderSide(color: SpotPalette.cardBorder, width: 1),
            right: BorderSide(color: SpotPalette.cardBorder, width: 1),
            bottom: BorderSide(color: SpotPalette.cardBorder, width: 1),
            left: BorderSide(color: SpotPalette.accent, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A1A1A).withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GÖRSEL BÖLÜMÜ (Üst %60) ---
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const _SpotCardImageFallback(),
                          )
                        : const _SpotCardImageFallback(),
                  ),

                  // Kategori etiketi (sol üst)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border, size: 18, color: Color(0xFF1A1A1A)),
                    ),
                  ),

                  // Fiyat etiketi (görsel alt sağ)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
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

            // --- İÇERİK BÖLÜMÜ (Alt %40) ---
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getCategoryTitle(product.category).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF9E9E9E),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: SpotPalette.heading,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),

                    // Bilgi satırları
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. SATIR: Gerçek durum rozeti (esnafın kendi girdiği
                        // bilgi — sahte yıldız puanı ve "SIFIR" etiketi
                        // KALDIRILDI, ikinci el ürünü sıfırmış gibi
                        // göstermek yanıltıcıydı) + stok.
                        Row(
                          children: [
                            if (product.wearTier != null) ...[
                              Icon(product.wearTier!.icon,
                                  size: 13, color: product.wearTier!.color),
                              const SizedBox(width: 4),
                              Text(
                                product.wearTier!.label,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: product.wearTier!.color),
                              ),
                              const SizedBox(width: 8),
                              Container(width: 3, height: 3, decoration: const BoxDecoration(color: Color(0xFFD1D5DB), shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                            ],
                            const Icon(Icons.check_circle, size: 12, color: Color(0xFF16A34A)),
                            const SizedBox(width: 4),
                            const Text(
                              "Stokta",
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF16A34A)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // 3. SATIR: Teslimat + Buton
                        Row(
                          children: [
                            const Icon(Icons.local_shipping_outlined, size: 14, color: Color(0xFF6B7280)),
                            const SizedBox(width: 6),
                            const Text(
                              "Ücretsiz teslimat",
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)),
                            ),
                            const Spacer(),
                            // İncele butonu
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "İncele",
                                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
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

  // ============================================================
  // FİLTRE VE SIRALAMA FONKSİYONLARI
  // ============================================================

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (final sheetContext) => StatefulBuilder(
        builder: (final sheetContext, final setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
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
                        color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const Text("FİLTRELER",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                        color: Color(0xFF5A5A5A))),
                const SizedBox(height: 16),
                const Text("Fiyat Aralığı", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                const SizedBox(height: 8),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 50000,
                  divisions: 50,
                  activeColor: const Color(0xFFE65100),
                  inactiveColor: const Color(0xFFE0E0E0),
                  onChanged: (final v) => setSheetState(() => _priceRange = v),
                ),
                Text(
                  '₺${_priceRange.start.round()} — ₺${_priceRange.end.round()}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE65100),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      setState(() {
                        _priceFilterActive = _priceRange.start > 0 || _priceRange.end < 50000;
                      });
                      Navigator.pop(sheetContext);
                    },
                    child: const Text("Filtreleri Uygula",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPriceFilterSheet(final BuildContext context) {
    RangeValues temp = _priceRange;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (final sheetContext) => StatefulBuilder(
        builder: (final sheetContext, final setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
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
                        color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const Text("FİYAT ARALIĞI",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                        color: Color(0xFF5A5A5A))),
                const SizedBox(height: 10),
                Text(
                  '₺${temp.start.round()} — ₺${temp.end.round()}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 26, color: Color(0xFF1A1A1A)),
                ),
                RangeSlider(
                  values: temp,
                  min: 0,
                  max: 50000,
                  divisions: 50,
                  activeColor: const Color(0xFFE65100),
                  inactiveColor: const Color(0xFFE0E0E0),
                  onChanged: (final v) => setSheetState(() => temp = v),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE65100),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      setState(() {
                        _priceRange = temp;
                        _priceFilterActive = temp.start > 0 || temp.end < 50000;
                      });
                      Navigator.pop(sheetContext);
                    },
                    child: const Text("Uygula",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openSortSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (final sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
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
                      color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const Text("SIRALAMA",
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      color: Color(0xFF5A5A5A))),
              const SizedBox(height: 8),
              ..._SortMode.values.map((mode) {
                final selected = mode == _selectedSort;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedSort = mode);
                    Navigator.pop(sheetContext);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _sortLabel(mode),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                              color: selected ? const Color(0xFF1A1A1A) : const Color(0xFF5A5A5A),
                            ),
                          ),
                        ),
                        if (selected) const Icon(Icons.check_rounded, size: 20, color: Color(0xFFE65100)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  String _sortLabel(_SortMode mode) {
    switch (mode) {
      case _SortMode.newest: return "En Yeni Fırsatlar";
      case _SortMode.priceLowHigh: return "Fiyat: Düşükten Yükseğe";
      case _SortMode.priceHighLow: return "Fiyat: Yüksekten Düşüğe";
      case _SortMode.popular: return "En Çok İncelenen";
    }
  }

  Widget _buildEmptyState(final BuildContext context) => Column(
    children: [
      Icon(Icons.search_off_rounded, size: 44, color: const Color(0xFF9E9E9E).withOpacity(0.6)),
      const SizedBox(height: 14),
      const Text("Bu kriterde fırsat bulamadık",
          style: TextStyle(fontSize: 18, color: Color(0xFF1A1A1A), fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      const Text("Filtreleri temizlemeyi veya farklı bir kategori denemeyi dene.",
          style: TextStyle(fontSize: 13, color: Color(0xFF5A5A5A))),
    ],
  );

  Widget _buildErrorState(final BuildContext context, final String error) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline_rounded, size: 64, color: const Color(0xFFE65100)),
        const SizedBox(height: 14),
        const Text("Bir hata oluştu",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(error, style: const TextStyle(color: Color(0xFF5A5A5A))),
      ],
    ),
  );

  List<Product> _filterProducts(final List<Product> products) {
    var filtered = products;
    if (_selectedCategory != null) {
      filtered = filtered.where((final p) => p.category == _selectedCategory).toList();
    }
    filtered = filtered
        .where((final p) => p.price >= _priceRange.start && p.price <= _priceRange.end)
        .toList();
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

// ============================================================
// VIEW TOGGLE WIDGET
// ============================================================
class _ViewToggle extends ConsumerWidget {
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final mode = ref.watch(productViewModeProvider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => ref.read(productViewModeProvider.notifier).set(ProductViewMode.grid),
          child: Icon(
            Icons.grid_view_rounded,
            size: 20,
            color: mode == ProductViewMode.grid ? const Color(0xFF1A1A1A) : const Color(0xFF9E9E9E),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => ref.read(productViewModeProvider.notifier).set(ProductViewMode.list),
          child: Icon(
            Icons.view_list_rounded,
            size: 20,
            color: mode == ProductViewMode.list ? const Color(0xFF1A1A1A) : const Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }
}

/// Ürünün gerçek fotoğrafı yoksa ya da yüklenemezse gösterilen yedek görsel.
class _SpotCardImageFallback extends StatelessWidget {
  const _SpotCardImageFallback();

  @override
  Widget build(BuildContext context) => Container(
        color: const Color(0xFFEEEEEE),
        child: const Center(
          child: Icon(Icons.chair_outlined, size: 48, color: Color(0xFFBDBDBD)),
        ),
      );
}
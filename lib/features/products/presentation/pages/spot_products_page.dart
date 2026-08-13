import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/features/products/presentation/providers/product_filters_provider.dart';
import '../../../../core/ads/widgets/ad_grid_helper.dart';
import '../../../../core/ads/widgets/adsense_banner.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/providers/product_view_mode_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../../core/widgets/dynamic_category_chips.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../core/widgets/product_list_card.dart';
import '../../../../core/widgets/shimmer_components.dart';
import '../../../../core/widgets/view_mode_toggle.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../domain/entites/product.dart';

/// "Spot / İkinci El Ürünler" — köklü, sıfırdan yeniden tasarlandı. Eski
/// sürümdeki dev animasyonlu arka plan deseni, sahte istatistik kutuları
/// ve karmaşık, her zaman State'e bağlı filtre paneli kaldırıldı. Yerine:
/// fırsat vurgulu sade bir başlık, gerçek ürün sayısı, alt sayfadan açılan
/// hafif bir fiyat filtresi ve temiz bir ızgara/liste.
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

  @override
  Widget build(final BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
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
                  _buildHeader(context, products.length),
                  _buildToolbar(context),
                  SliverToBoxAdapter(
                      child: DynamicCategoryChips(
                    selected: _selectedCategory,
                    onSelect: (final c) => setState(() => _selectedCategory = c),
                    padding: EdgeInsets.symmetric(horizontal: context.pagePadding.left),
                  )),
                  SliverToBoxAdapter(child: SizedBox(height: context.spacingLarge)),
                  _buildProductGrid(context, filtered),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: context.sectionPadding,
                      child: const AdsenseBanner(height: 100, type: AdUnitType.multiplex),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: context.spacingLarge * 3)),
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
  // BAŞLIK — fırsat vurgulu panel + gerçek ürün sayısı
  // ════════════════════════════════════════════════════════════

  Widget _buildHeader(final BuildContext context, final int totalProducts) => SliverAppBar(
        pinned: true,
        expandedHeight: context.responsive(mobile: 232, tablet: 260, desktop: 288),
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -60,
                  top: -60,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [AppColors.error.withOpacity(0.16), Colors.transparent],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: context.pagePadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBreadcrumb(context),
                        SizedBox(height: context.spacing),
                        Text(
                          context.l10n.spotBadgeEyebrow,
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 3,
                            fontWeight: FontWeight.w800,
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.l10n.spotProducts,
                          style: TextStyle(
                            fontSize: context.responsive(mobile: 30, tablet: 38, desktop: 44),
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.productsFound(totalProducts),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                        SizedBox(height: context.spacing),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _TrustChip(
                                icon: Icons.inventory_2_rounded,
                                label: context.l10n.statSpotProductLabel,
                                accent: AppColors.error),
                            _TrustChip(
                                icon: Icons.chat_bubble_rounded,
                                label: context.l10n.productTrustBadgeNegotiate),
                          ],
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

  Widget _buildBreadcrumb(final BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.home_outlined, size: 13, color: AppColors.textTertiary),
          const SizedBox(width: 6),
          Text(context.l10n.breadcrumbHome,
              style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
          const SizedBox(width: 6),
          Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.textTertiary),
          const SizedBox(width: 6),
          Text(context.l10n.spotProducts,
              style: TextStyle(
                  fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w700)),
        ],
      );

  // ════════════════════════════════════════════════════════════
  // ARAÇ ÇUBUĞU — arama + fiyat filtresi + sırala + görünüm
  // ════════════════════════════════════════════════════════════

  Widget _buildToolbar(final BuildContext context) => SliverToBoxAdapter(
        child: Padding(
          padding: context.sectionPadding,
          child: Row(
            children: [
              Expanded(child: _buildSearchBar(context)),
              SizedBox(width: context.spacing),
              _buildPriceFilterButton(context),
              SizedBox(width: context.spacing),
              _buildSortPill(context),
              if (context.isTablet || context.isDesktop) ...[
                SizedBox(width: context.spacing),
                const ViewModeToggle(),
              ],
            ],
          ),
        ),
      );

  Widget _buildSearchBar(final BuildContext context) => GestureDetector(
        onTap: () => context.go('/search'),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(fontSize: context.bodySize, color: AppColors.textSecondary),
                    children: [
                      TextSpan(text: context.l10n.searchBarRichPrefix),
                      TextSpan(
                        text: context.l10n.searchBarRichHereLink,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.error,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()..onTap = () => context.go('/search'),
                      ),
                      TextSpan(text: context.l10n.searchBarRichSuffix),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildPriceFilterButton(final BuildContext context) => GestureDetector(
        onTap: () => _openPriceFilterSheet(context),
        child: Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: _priceFilterActive ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _priceFilterActive ? AppColors.primary : AppColors.border),
          ),
          child: Icon(Icons.tune_rounded,
              color: _priceFilterActive ? Colors.white : AppColors.textPrimary, size: 20),
        ),
      );

  void _openPriceFilterSheet(final BuildContext context) {
    RangeValues temp = _priceRange;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (final sheetContext) => StatefulBuilder(
        builder: (final sheetContext, final setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24,
              24 + MediaQuery.of(sheetContext).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.priceRangeSectionTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
              const SizedBox(height: 8),
              Text(
                '₺${temp.start.round()} - ₺${temp.end.round()}',
                style: TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.primary),
              ),
              RangeSlider(
                values: temp,
                min: 0,
                max: 50000,
                divisions: 50,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.border,
                onChanged: (final v) => setSheetState(() => temp = v),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _priceRange = const RangeValues(0, 50000);
                          _priceFilterActive = false;
                        });
                        Navigator.pop(sheetContext);
                      },
                      child: Text(context.l10n.clearFiltersButton),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                      onPressed: () {
                        setState(() {
                          _priceRange = temp;
                          _priceFilterActive = temp.start > 0 || temp.end < 50000;
                        });
                        Navigator.pop(sheetContext);
                      },
                      child: Text(context.l10n.apply),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortPill(final BuildContext context) => Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<_SortMode>(
            value: _selectedSort,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary),
            items: _SortMode.values
                .map((final mode) =>
                    DropdownMenuItem(value: mode, child: Text(_sortLabel(context, mode))))
                .toList(),
            onChanged: (final val) => setState(() => _selectedSort = val!),
          ),
        ),
      );

  String _sortLabel(final BuildContext context, final _SortMode mode) {
    switch (mode) {
      case _SortMode.newest:
        return context.l10n.sortSpotProductsDefault;
      case _SortMode.priceLowHigh:
        return context.l10n.sortPriceLowHigh;
      case _SortMode.priceHighLow:
        return context.l10n.sortPriceHighLow;
      case _SortMode.popular:
        return context.l10n.sortMostPopular;
    }
  }

  // ════════════════════════════════════════════════════════════
  // IZGARA / LİSTE
  // ════════════════════════════════════════════════════════════

  Widget _buildProductGrid(final BuildContext context, final List<Product> products) {
    if (products.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyState(context));
    }

    if (ref.watch(productViewModeProvider) == ProductViewMode.list) {
      return SliverPadding(
        padding: context.sectionPadding,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (final context, final index) => ProductListCard(product: products[index]),
            childCount: products.length,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: context.sectionPadding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.responsive(mobile: 2, tablet: 3, desktop: 4, largeDesktop: 5),
          crossAxisSpacing: context.gridSpacing,
          mainAxisSpacing: context.gridSpacing,
          childAspectRatio: context.responsive(mobile: 0.65, tablet: 0.70, desktop: 0.73),
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) {
            if (isAdSlot(index, products.length)) return const NativeAdCard();
            final realIndex = realIndexForAdGrid(index, products.length);
            if (realIndex >= products.length) return const SizedBox.shrink();
            return CustomProductCard(product: products[realIndex]);
          },
          childCount: paddedItemCountForAds(products.length),
        ),
      ),
    );
  }

  Widget _buildEmptyState(final BuildContext context) => Container(
        height: 360,
        margin: context.sectionPadding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: AppColors.textTertiary.withOpacity(0.6)),
            const SizedBox(height: 14),
            Text(context.l10n.productNotFound,
                style: TextStyle(
                    fontSize: 16, color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(context.l10n.tryDifferentFiltersShort,
                style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
          ],
        ),
      );

  Widget _buildErrorState(final BuildContext context, final String error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: AppColors.error),
            const SizedBox(height: 14),
            Text(context.l10n.errorOccurred,
                style: TextStyle(fontSize: context.h4Size, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(error, style: TextStyle(color: AppColors.textSecondary)),
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

class _TrustChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;

  _TrustChip({required this.icon, required this.label, this.accent = AppColors.primary});

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: accent),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ],
        ),
      );
}

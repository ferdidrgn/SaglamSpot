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
import '../../../../core/widgets/design_system/glass_surface.dart';
import '../../../../core/widgets/editorial_product_grid_widgets.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../core/widgets/shimmer_components.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../domain/entites/product.dart';

/// "Spot / İkinci El Ürünler" — KÖKLÜ, ikinci kez baştan tasarlandı.
/// new_products_page.dart ile aynı editoryal katalog dilini paylaşır
/// (bkz. core/widgets/editorial_product_grid_widgets.dart) — sadece vurgu
/// rengi (AppColors.error) ve fiyat filtresi ile ayrışır.
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
              const Positioned.fill(child: AmbientMeshBackground()),
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _buildMasthead(context, products.length)),
                  SliverToBoxAdapter(
                      child: EditorialCategoryRail(
                    selected: _selectedCategory,
                    onSelect: (final c) => setState(() => _selectedCategory = c),
                    allLabel: context.l10n.conditionAll,
                    // NOT: sadece YATAY padding — dikey bileşen eklenirse
                    // sabit 40px yükseklikli rayı neredeyse tamamen kırpar.
                    padding: context.sectionPadding.copyWith(top: 0, bottom: 0),
                  )),
                  SliverToBoxAdapter(child: SizedBox(height: context.spacing)),
                  _buildToolbar(context, filtered.length),
                  SliverToBoxAdapter(child: SizedBox(height: context.spacing)),
                  _buildProductGrid(context, filtered),
                  if (filtered.isNotEmpty)
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
  // BAŞLIK
  // ════════════════════════════════════════════════════════════

  Widget _buildMasthead(final BuildContext context, final int totalProducts) => Stack(
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
                Text(
                  context.l10n.spotBadgeEyebrow,
                  style: AppTextStyles.microLabel(
                    fontSize: 12,
                    letterSpacing: 3,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.spotProducts,
                  style: GoogleFonts.fraunces(
                    fontSize: context.responsive(mobile: 34, tablet: 46, desktop: 58),
                    fontWeight: FontWeight.w600,
                    height: 1.02,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.responsive(mobile: 400, desktop: 520)),
                  child: Text(
                    context.l10n.spotProductsDesc,
                    style: TextStyle(
                        fontSize: context.bodySize, color: AppColors.textSecondary, height: 1.5),
                  ),
                ),
                SizedBox(height: context.spacing),
                Wrap(
                  spacing: 18,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(context.l10n.productsFound(totalProducts),
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    _dotSep(),
                    _plainStat(context.l10n.statSpotProductLabel),
                    _dotSep(),
                    _plainStat(context.l10n.productTrustBadgeNegotiate),
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

  Widget _dotSep() => Text('•', style: TextStyle(color: AppColors.border, fontSize: 12));

  Widget _plainStat(final String label) => Text(label,
      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textTertiary));

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
  // ARAÇ ÇUBUĞU — arama + fiyat filtresi + sırala + görünüm, metin tabanlı
  // ════════════════════════════════════════════════════════════

  Widget _buildToolbar(final BuildContext context, final int resultCount) => SliverToBoxAdapter(
        child: Padding(
          // NOT: yalnızca yatay — sectionPadding'in tamamı masthead/toolbar/
          // grid arasında fazladan onlarca piksel boş alan biriktiriyordu.
          padding: context.sectionPadding.copyWith(top: 0, bottom: 0),
          child: GlassSurface(
            borderRadius: 18,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () => context.go('/search'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_rounded, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(context.l10n.searchHint,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.border)),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              _TextTabButton(
                icon: Icons.tune_rounded,
                label: context.l10n.priceRangeSectionTitle,
                isActive: _priceFilterActive,
                onTap: () => _openPriceFilterSheet(context),
              ),
              SizedBox(width: context.spacing),
              _TextTabButton(
                icon: Icons.swap_vert_rounded,
                label: _sortLabel(context, _selectedSort),
                onTap: () => _openSortSheet(context),
              ),
              SizedBox(width: context.spacing),
              _ViewToggle(),
            ],
            ),
          ),
        ),
      );

  void _openPriceFilterSheet(final BuildContext context) {
    RangeValues temp = _priceRange;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (final sheetContext) => StatefulBuilder(
        builder: (final sheetContext, final setSheetState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                24, 16, 24, 20 + MediaQuery.of(sheetContext).viewInsets.bottom),
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
                        color: AppColors.border, borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                Text(context.l10n.priceRangeSectionTitle,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                        color: AppColors.textTertiary)),
                const SizedBox(height: 10),
                Text(
                  '₺${temp.start.round()} — ₺${temp.end.round()}',
                  style: GoogleFonts.fraunces(
                      fontWeight: FontWeight.w600, fontSize: 26, color: AppColors.textPrimary),
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
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
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
                    child: Text(context.l10n.apply,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _priceRange = const RangeValues(0, 50000);
                        _priceFilterActive = false;
                      });
                      Navigator.pop(sheetContext);
                    },
                    child: Text(context.l10n.clearFiltersButton,
                        style: TextStyle(
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                            letterSpacing: 0.6)),
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
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
        padding: context.sectionPadding.copyWith(top: 0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (final context, final index) => EditorialProductRow(product: products[index]),
            childCount: products.length,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: context.sectionPadding.copyWith(top: 0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.responsive(mobile: 2, tablet: 3, desktop: 4, largeDesktop: 5),
          crossAxisSpacing: context.gridSpacing,
          mainAxisSpacing: context.gridSpacing,
          childAspectRatio: context.responsive(mobile: 0.64, tablet: 0.68, desktop: 0.71),
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) {
            if (isAdSlot(index, products.length)) return const NativeAdCard();
            final realIndex = realIndexForAdGrid(index, products.length);
            if (realIndex >= products.length) return const SizedBox.shrink();
            return EditorialProductCard(product: products[realIndex]);
          },
          childCount: paddedItemCountForAds(products.length),
        ),
      ),
    );
  }

  Widget _buildEmptyState(final BuildContext context) => Padding(
        padding: context.sectionPadding.copyWith(top: 40, bottom: 60),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 44, color: AppColors.textTertiary.withOpacity(0.6)),
            const SizedBox(height: 14),
            Text(context.l10n.productNotFound,
                style: GoogleFonts.fraunces(
                    fontSize: 18, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
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

/// Metin + ikon tabanlı araç çubuğu düğmesi (kutulu ikon yerine).
class _TextTabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _TextTabButton(
      {required this.icon, required this.label, required this.onTap, this.isActive = false});

  @override
  Widget build(final BuildContext context) {
    final showLabel = context.isTablet || context.isDesktop;
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isActive ? AppColors.error : AppColors.textPrimary),
            if (showLabel) ...[
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isActive ? AppColors.error : AppColors.textPrimary)),
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
          onTap: () => ref.read(productViewModeProvider.notifier).set(ProductViewMode.grid),
        ),
        const SizedBox(width: 10),
        _viewIcon(
          icon: Icons.view_list_rounded,
          isSelected: mode == ProductViewMode.list,
          onTap: () => ref.read(productViewModeProvider.notifier).set(ProductViewMode.list),
        ),
      ],
    );
  }

  Widget _viewIcon(
          {required final IconData icon,
          required final bool isSelected,
          required final VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Icon(icon,
            size: 19, color: isSelected ? AppColors.textPrimary : AppColors.textTertiary),
      );
}

/// Alt sayfadan açılan, radyo listesi tarzı sade sıralama seçici.
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
                      color: AppColors.border, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              Text(title,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      color: AppColors.textTertiary)),
              const SizedBox(height: 8),
              ...options.map((final o) {
                final selected = o == current;
                return GestureDetector(
                  onTap: () => onSelect(o),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(labelBuilder(o),
                              style: GoogleFonts.fraunces(
                                  fontSize: 17,
                                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                                  color: selected
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary)),
                        ),
                        if (selected) Icon(Icons.check_rounded, size: 18, color: AppColors.error),
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

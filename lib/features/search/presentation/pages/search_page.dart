import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/common/extentions/product_category_ex.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import '../../../../core/ads/widgets/ad_grid_helper.dart';
import '../../../../core/ads/widgets/ad_native_widget.dart';
import '../../../../core/providers/product_view_mode_provider.dart';
import '../../../../core/widgets/product_list_card.dart';
import '../../../../core/widgets/view_mode_toggle.dart';
import '../../../../core/ads/widgets/adsense_banner.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/util/responsive_product_grid.dart';
import '../../../../core/widgets/dynamic_category_chips.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../core/widgets/shimmer_components.dart';
import '../../../../shared/navigation/widgets/back_navigation_guards.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/category_meta_provider.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../providers/search_providers.dart';
import '../widgets/filter_sheet.dart';

/// Arama/keşif sayfası — eski tasarımdaki devasa arka plan fotoğraflı hero
/// yerine, sonuçları hep görünür tutan modern bir "kalıcı yan panel filtre"
/// düzeni: masaüstünde solda sabit kategori/durum/fiyat paneli + sağda
/// sonuç ızgarası; mobil/tablette ise kompakt bir üst arama çubuğu + yatay
/// kategori şeridi + alt köşede "Filtrele" butonu.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showSearchFocus = false;

  @override
  void initState() {
    super.initState();
    // Ana sayfadan (chip/oda kartı) '/search?category=sofa' gibi bir bağlantıyla
    // gelindiyse, o kategoriyi otomatik olarak seçili hale getir.
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      if (!mounted) return;
      final categoryParam =
          GoRouterState.of(context).uri.queryParameters['category'];
      if (categoryParam != null && categoryParam.isNotEmpty) {
        ref
            .read(searchFiltersProvider.notifier)
            .setCategory(categoryParam.toProductCategory());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _resetAll() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).update('');
    ref.read(searchFiltersProvider.notifier).setCategory(ProductCategory.other);
    ref.read(searchFiltersProvider.notifier).reset();
  }

  @override
  Widget build(final BuildContext context) {
    final searchResultsAsync = ref.watch(searchedProductsProvider);
    final currentFilters = ref.watch(searchFiltersProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    // Kalıcı yan panel yalnızca gerçek masaüstü genişliğinde: dar
    // tablet/laptop pencerelerinde sonuç alanını sıkıştırmasın.
    final showSidebar = context.isDesktop;

    final scaffold = Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: !kIsWeb ? const MobileBottomNav() : null,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, searchQuery),
            if (!showSidebar) _buildCategoryStrip(currentFilters),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showSidebar) _buildSidebar(context, currentFilters),
                  if (showSidebar)
                    const VerticalDivider(width: 1, color: AppColors.border),
                  Expanded(
                    child: Stack(
                      children: [
                        CustomScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            _buildActiveFiltersSliver(currentFilters, showSidebar),
                            searchResultsAsync.when(
                              loading: () => const SliverToBoxAdapter(
                                  child: SizedBox.shrink()),
                              error: (final _, final __) =>
                                  const SliverToBoxAdapter(
                                      child: SizedBox.shrink()),
                              data: (final products) => _buildResultsHeader(
                                  context, products.length, searchQuery),
                            ),
                            searchResultsAsync.when(
                              loading: () => const SliverFillRemaining(
                                  child: FullPageShimmer()),
                              error: (final err, final _) => SliverFillRemaining(
                                child: _buildErrorState(err.toString()),
                              ),
                              data: (final products) {
                                if (products.isEmpty) return _buildEmptyState();
                                return SliverPadding(
                                  padding: EdgeInsets.only(
                                    bottom: context.isMobile ? 100 : 60,
                                    left: context.responsive(
                                        mobile: 0.0, desktop: 8.0),
                                    right: context.responsive(
                                        mobile: 0.0, desktop: 8.0),
                                  ),
                                  sliver: SliverMainAxisGroup(
                                    slivers:
                                        _buildProductGridsWithAds(context, products),
                                  ),
                                );
                              },
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  context.responsive(
                                      mobile: 16.0, tablet: 24.0, desktop: 32.0),
                                  24,
                                  context.responsive(
                                      mobile: 16.0, tablet: 24.0, desktop: 32.0),
                                  40,
                                ),
                                child: const Column(
                                  children: [
                                    AdsenseBanner(
                                        height: 90, type: AdUnitType.multiplex),
                                    AdNativeWidget(),
                                  ],
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(child: SizedBox(height: 80)),
                          ],
                        ),
                        ScrollUpButton(scrollController: _scrollController),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !showSidebar ? _buildFloatingFilter(context) : null,
    );

    return kIsWeb ? scaffold : BackToHomeGuard(child: scaffold);
  }

  // ─────────────────────────────────────────────────────────────
  // ÜST ÇUBUK — dev arka plan fotoğraflı hero'nun yerini alan, sonuçlarla
  // aynı ekranda her zaman görünen kompakt arama şeridi.
  // ─────────────────────────────────────────────────────────────
  Widget _buildTopBar(final BuildContext context, final String query) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive(mobile: 16.0, tablet: 24.0, desktop: 32.0),
        vertical: context.responsive(mobile: 10.0, desktop: 14.0),
      ),
      child: Row(
        children: [
          _RoundIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => NavigationHandler.smartGoBack(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: context.responsive(mobile: 46.0, desktop: 50.0),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _showSearchFocus
                      ? AppColors.textSecondary
                      : AppColors.border,
                  width: 1.4,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (final val) =>
                    ref.read(searchQueryProvider.notifier).update(val),
                onTap: () => setState(() => _showSearchFocus = true),
                onTapOutside: (final _) =>
                    setState(() => _showSearchFocus = false),
                style: const TextStyle(
                  fontSize: 14.5,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: context.l10n.searchHint,
                  hintStyle: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                      fontSize: 13.5),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.textSecondary, size: 20),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded,
                              color: AppColors.textSecondary, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(searchQueryProvider.notifier).update('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _buildSortDropdown(),
          if (!context.isMobile) ...[
            const SizedBox(width: 10),
            const ViewModeToggle(),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryStrip(final dynamic filters) => Container(
        color: AppColors.surface,
        padding: EdgeInsets.symmetric(
            vertical: context.responsive(mobile: 6.0, tablet: 8.0, desktop: 8.0)),
        child: DynamicCategoryChips(
          selected: filters.category as ProductCategory?,
          onSelect: (final category) =>
              ref.read(searchFiltersProvider.notifier).setCategory(category),
          padding: EdgeInsets.symmetric(
              horizontal:
                  context.responsive(mobile: 12.0, tablet: 20.0, desktop: 32.0)),
        ),
      );

  // ─────────────────────────────────────────────────────────────
  // KALICI YAN PANEL — yalnızca masaüstü. Kategori/Durum/Fiyat aynı anda
  // görünür, kaydırma sırasında sabit kalır; bottom-sheet açmaya gerek yok.
  // ─────────────────────────────────────────────────────────────
  Widget _buildSidebar(final BuildContext context, final dynamic filters) {
    final categories = ref.watch(orderedActiveCategoriesProvider);
    final available = ref.watch(availableProductsProvider);

    return SizedBox(
      width: 236,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sidebarTitle(context.l10n.category),
            const SizedBox(height: 12),
            _SidebarCategoryRow(
              label: context.l10n.conditionAll,
              icon: Icons.grid_view_rounded,
              color: AppColors.textSecondary,
              count: available.length,
              selected: filters.category == null,
              onTap: () =>
                  ref.read(searchFiltersProvider.notifier).setCategory(null),
            ),
            for (final meta in categories)
              _SidebarCategoryRow(
                label: meta.customLabel ?? meta.category.label(context),
                icon: meta.icon,
                color: meta.color,
                count: available
                    .where((final p) => p.category == meta.category)
                    .length,
                selected: filters.category == meta.category,
                onTap: () => ref
                    .read(searchFiltersProvider.notifier)
                    .setCategory(meta.category),
              ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 20),
            _sidebarTitle(context.l10n.condition),
            const SizedBox(height: 12),
            _SidebarConditionSelector(filters: filters),
            const SizedBox(height: 20),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 20),
            _sidebarTitle(context.l10n.priceRange),
            const SizedBox(height: 14),
            _SidebarPriceRange(filters: filters),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _resetAll,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(context.l10n.clear),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: BorderSide(
                      color: AppColors.textSecondary.withOpacity(0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sidebarTitle(final String title) => Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: AppColors.textTertiary,
        ),
      );

  Widget _buildSortDropdown() {
    final current = ref.watch(sortOptionProvider);
    return PopupMenuButton<SortOption>(
      initialValue: current,
      onSelected: (final option) =>
          ref.read(sortOptionProvider.notifier).set(option),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (final context) => SortOption.values
          .map((final o) => PopupMenuItem(value: o, child: Text(o.label(context))))
          .toList(),
      child: Container(
        height: context.responsive(mobile: 46.0, desktop: 50.0),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_vert_rounded,
                size: 18, color: AppColors.textSecondary),
            if (!context.isMobile) ...[
              const SizedBox(width: 6),
              Text(current.label(context),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ],
          ],
        ),
      ),
    );
  }

  bool _hasActiveFilters(final dynamic filters) {
    return (filters.category != null &&
            filters.category != ProductCategory.other) ||
        (filters.condition != null &&
            filters.condition != ProductCondition.all) ||
        filters.minPrice > 0 ||
        filters.maxPrice < 100000;
  }

  Widget _buildActiveFiltersSliver(
      final dynamic filters, final bool showSidebar) {
    // Yan panel açıkken seçili durum zaten orada görünür — burada tekrar
    // etmeye gerek yok, yalnızca varsa fiyat/durum rozetlerini göster.
    if (!_hasActiveFilters(filters)) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              context.responsive(mobile: 16.0, tablet: 24.0, desktop: 32.0),
          vertical: 16,
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (!showSidebar &&
                filters.category != null &&
                filters.category != ProductCategory.other)
              _buildFilterChip(
                ProductCategoryExtension(filters.category).label(context),
                Icons.category_rounded,
                onRemove: () =>
                    ref.read(searchFiltersProvider.notifier).setCategory(null),
              ),
            if (filters.condition != null &&
                filters.condition != ProductCondition.all)
              _buildFilterChip(
                filters.condition!.label(context),
                Icons.verified_rounded,
                onRemove: () => ref
                    .read(searchFiltersProvider.notifier)
                    .setCondition(ProductCondition.all),
              ),
            if (filters.minPrice > 0 || filters.maxPrice < 100000)
              _buildFilterChip(
                '${filters.minPrice.toInt()}₺ - ${filters.maxPrice.toInt()}₺',
                Icons.payments_rounded,
                onRemove: () => ref
                    .read(searchFiltersProvider.notifier)
                    .setPriceRange(0, 100000),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(final String label, final IconData icon,
          {final VoidCallback? onRemove}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            if (onRemove != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.close_rounded,
                    size: 15, color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      );

  Widget _buildResultsHeader(
      final BuildContext context, final int count, final String query) {
    if (count == 0 || query.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.responsive(mobile: 20.0, tablet: 28.0, desktop: 24.0),
          context.responsive(mobile: 20.0, tablet: 24.0, desktop: 20.0),
          context.responsive(mobile: 20.0, tablet: 28.0, desktop: 24.0),
          context.responsive(mobile: 14.0, tablet: 16.0, desktop: 14.0),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.productsFound(count),
                  style: TextStyle(
                    fontSize: context.responsive(
                        mobile: 17.0, tablet: 18.0, desktop: 19.0),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  context.l10n.resultsFor(query),
                  style: TextStyle(
                    fontSize: context.responsive(
                        mobile: 12.5, tablet: 13.0, desktop: 13.5),
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() => SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: context.pagePadding,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: context.responsive(
                      mobile: 110.0, tablet: 120.0, desktop: 130.0),
                  height: context.responsive(
                      mobile: 110.0, tablet: 120.0, desktop: 130.0),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search_off_rounded,
                    size: context.responsive(
                        mobile: 52.0, tablet: 56.0, desktop: 60.0),
                    color: AppColors.textSecondary.withOpacity(0.4),
                  ),
                ),
                SizedBox(
                    height: context.responsive(
                        mobile: 20.0, tablet: 24.0, desktop: 28.0)),
                Text(
                  context.l10n.noProductFoundTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.responsive(
                        mobile: 19.0, tablet: 20.0, desktop: 21.0),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                SizedBox(
                    height: context.responsive(
                        mobile: 10.0, tablet: 12.0, desktop: 14.0)),
                Text(
                  context.l10n.noProductFoundDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.responsive(
                        mobile: 14.0, tablet: 15.0, desktop: 16.0),
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(
                    height: context.responsive(
                        mobile: 28.0, tablet: 32.0, desktop: 36.0)),
                ElevatedButton.icon(
                  onPressed: _resetAll,
                  icon: Icon(Icons.refresh_rounded,
                      size: context.responsive(
                          mobile: 19.0, tablet: 20.0, desktop: 21.0)),
                  label: Text(context.l10n.clear,
                      style: TextStyle(
                          fontSize:
                              context.responsive(mobile: 15.0, desktop: 16.0))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textSecondary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsive(
                          mobile: 28.0, tablet: 32.0, desktop: 36.0),
                      vertical: context.responsive(
                          mobile: 14.0, tablet: 16.0, desktop: 18.0),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildErrorState(final String error) => Center(
        child: Padding(
          padding: context.pagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 80, color: AppColors.error.withOpacity(0.7)),
              const SizedBox(height: 20),
              Text(context.l10n.errorOccurred,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Text(error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary)),
            ],
          ),
        ),
      );

  List<Widget> _buildProductGridsWithAds(
      final BuildContext context, final List<Product> products) {
    final available = products.where((final p) => !p.isSold).toList();
    final sold = products.where((final p) => p.isSold).toList();

    final List<Widget> slivers = [];

    if (available.isNotEmpty) {
      slivers.add(_buildSectionDivider(context.l10n.currentCollection,
          available.length, AppColors.onPrimary));
      slivers.addAll(_buildProductsWithAds(context, available));
    }

    if (sold.isNotEmpty) {
      slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 40)));
      slivers.add(_buildSectionDivider(
          context.l10n.soldProducts, sold.length, AppColors.textTertiary));
      slivers.addAll(_buildProductsWithAds(context, sold));
    }

    return slivers;
  }

  // Reklamlar artık ürünlerin arasına, ürün kartıyla AYNI çerçevede
  // "doğal" kartlar olarak serpiştiriliyor (bkz. ad_grid_helper.dart) —
  // liste kısaysa her 5, uzunsa her 10 üründe bir. Eskiden aralara büyük
  // tam genişlikte bloklar sokuluyordu; artık ızgaraya/listeye gömülü.
  List<Widget> _buildProductsWithAds(
      final BuildContext context, final List<Product> products) {
    final isListMode =
        ref.watch(productViewModeProvider) == ProductViewMode.list;

    if (!isListMode) {
      return [
        ResponsiveProductSliverGrid(
          products: products,
          insertAds: true,
          onProductTap: (final p) => NavigationHandler.goToProduct(
              context: context, productId: p.id, productSlug: p.name.toSlug()),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(
            horizontal:
                context.responsive(mobile: 16.0, tablet: 20.0, desktop: 24.0)),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (final context, final index) {
              if (isAdSlot(index, products.length)) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 14),
                  child: SizedBox(height: 140, child: NativeAdCard()),
                );
              }
              final realIndex = realIndexForAdGrid(index, products.length);
              if (realIndex >= products.length) return const SizedBox.shrink();
              return ProductListCard(product: products[realIndex]);
            },
            childCount: paddedItemCountForAds(products.length),
          ),
        ),
      ),
    ];
  }

  Widget _buildSectionDivider(
          final String title, final int count, final Color color) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.responsive(mobile: 20.0, tablet: 28.0, desktop: 24.0),
            context.responsive(mobile: 32.0, tablet: 40.0, desktop: 32.0),
            context.responsive(mobile: 20.0, tablet: 28.0, desktop: 24.0),
            context.responsive(mobile: 16.0, tablet: 18.0, desktop: 20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      fontSize: context.responsive(
                          mobile: 16.0, tablet: 18.0, desktop: 22.0),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.5),
                            color.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 52),
                child: Text(
                  context.l10n.pieces(count),
                  style: TextStyle(
                    fontSize: context.responsive(
                        mobile: 13.0, tablet: 14.0, desktop: 16.0),
                    color: AppColors.textSecondary.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildFloatingFilter(final BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showFilterSheet(context),
          backgroundColor: AppColors.textSecondary,
          elevation: 0,
          icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
          label: Text(context.l10n.filter,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
        ),
      );

  void _showFilterSheet(final BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (final _) => FilterSheet(
            onApplyFilters: () => Navigator.pop(context),
            onResetFilters: _resetAll),
      );
}

/// Üst çubuktaki geri butonu — sade, yuvarlak, ikon tabanlı.
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) => Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: SizedBox(
            width: context.responsive(mobile: 46.0, desktop: 50.0),
            height: context.responsive(mobile: 46.0, desktop: 50.0),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
        ),
      );
}

/// Yan paneldeki kategori satırı: ikon + isim + adet, seçiliyse vurgulanır.
class _SidebarCategoryRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarCategoryRow({
    required this.label,
    required this.icon,
    required this.color,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: selected ? color : AppColors.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
              Text('$count',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary)),
            ],
          ),
        ),
      );
}

/// Yan paneldeki durum seçici — üç eşit segment (Tümü / Sıfır / İkinci El).
class _SidebarConditionSelector extends ConsumerWidget {
  final dynamic filters;

  const _SidebarConditionSelector({required this.filters});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final notifier = ref.read(searchFiltersProvider.notifier);
    final current = filters.condition ?? ProductCondition.all;

    return Row(
      children: ProductCondition.values.map((final cond) {
        final isSelected = current == cond;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: cond == ProductCondition.values.last ? 0 : 8),
            child: InkWell(
              onTap: () => notifier.setCondition(cond),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.textSecondary
                      : AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  cond.label(context),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Yan paneldeki fiyat aralığı — eski dialog+metin kutuları yerine tek
/// bakışta anlaşılan bir RangeSlider.
class _SidebarPriceRange extends ConsumerStatefulWidget {
  final dynamic filters;

  const _SidebarPriceRange({required this.filters});

  @override
  ConsumerState<_SidebarPriceRange> createState() => _SidebarPriceRangeState();
}

class _SidebarPriceRangeState extends ConsumerState<_SidebarPriceRange> {
  static const double _cap = 100000;
  late RangeValues _localValues;

  @override
  void initState() {
    super.initState();
    _localValues = RangeValues(
      widget.filters.minPrice.toDouble().clamp(0, _cap),
      widget.filters.maxPrice.toDouble().clamp(0, _cap),
    );
  }

  @override
  void didUpdateWidget(covariant final _SidebarPriceRange oldWidget) {
    super.didUpdateWidget(oldWidget);
    _localValues = RangeValues(
      widget.filters.minPrice.toDouble().clamp(0, _cap),
      widget.filters.maxPrice.toDouble().clamp(0, _cap),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('₺${_localValues.start.toInt()}',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text('₺${_localValues.end.toInt()}${_localValues.end >= _cap ? '+' : ''}',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: AppColors.border,
            thumbColor: AppColors.accent,
            overlayColor: AppColors.accent.withOpacity(0.15),
            rangeThumbShape:
                const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 3,
          ),
          child: RangeSlider(
            values: _localValues,
            min: 0,
            max: _cap,
            divisions: 100,
            onChanged: (final values) => setState(() => _localValues = values),
            onChangeEnd: (final values) => ref
                .read(searchFiltersProvider.notifier)
                .setPriceRange(values.start, values.end),
          ),
        ),
      ],
    );
  }
}

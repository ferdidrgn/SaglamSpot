import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/common/extentions/product_category_ex.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import '../../../../core/ads/widgets/ad_native_widget.dart';
import '../../../../core/ads/widgets/web_ad_product_card.dart';
import '../../../../core/providers/product_view_mode_provider.dart';
import '../../../../core/widgets/product_list_card.dart';
import '../../../../core/widgets/view_mode_toggle.dart';
import '../../../../core/ads/widgets/adsense_banner.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/util/responsive_product_grid.dart';
import '../../../../core/widgets/back_button_glassmorphism.dart';
import '../../../../core/widgets/dynamic_category_chips.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../core/widgets/shimmer_components.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../products/domain/entites/product.dart';
import '../providers/search_providers.dart';
import '../widgets/filter_sheet.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  bool _showSearchFocus = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();

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
    _animController.dispose();
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
    final isMobile = context.isMobile;
    final searchQuery = ref.watch(searchQueryProvider);
    final getSearchSectionHeight =
        context.responsive(mobile: 180.0, tablet: 220.0, desktop: 240.0);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Fresh Hero Header
              _buildHeroHeader(context, isMobile),

              /*SliverPersistentHeader(
                pinned: true,
                delegate: _StickySearchDelegate(
                    minHeight: getSearchSectionHeight,
                    maxHeight: getSearchSectionHeight,
                    child: _buildSearchSection(context, isMobile, searchQuery)),
              ),*/

              SliverToBoxAdapter(
                  child: _buildSearchSection(context, isMobile, searchQuery)),

              // Fresh Category Pills
              _buildCategorySection(currentFilters, isMobile),

              // Aktif filtreler + sıralama (sıralama her zaman görünür)
              _buildActiveFiltersSliver(currentFilters),

              // Results Header
              searchResultsAsync.when(
                loading: () =>
                    const SliverToBoxAdapter(child: SizedBox.shrink()),
                error: (final _, final __) =>
                    const SliverToBoxAdapter(child: SizedBox.shrink()),
                data: (final products) =>
                    _buildResultsHeader(context, products.length, searchQuery),
              ),

              // Product Showcase with Ads
              searchResultsAsync.when(
                loading: () =>
                    const SliverFillRemaining(child: FullPageShimmer()),
                error: (final err, final _) => SliverFillRemaining(
                  child: _buildErrorState(err.toString()),
                ),
                data: (final products) {
                  if (products.isEmpty) return _buildEmptyState();
                  return SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: isMobile ? 100 : 60,
                      left: context.responsive(mobile: 0.0, desktop: 20.0),
                      right: context.responsive(mobile: 0.0, desktop: 20.0),
                    ),
                    sliver: SliverMainAxisGroup(
                      slivers: _buildProductGridsWithAds(context, products),
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
                    40, // Alt boşluk
                  ),
                  child: const Column(
                    children: [
                      AdsenseBanner(height: 90, type: AdUnitType.multiplex),
                      AdNativeWidget(),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
          ScrollUpButton(scrollController: _scrollController)
        ],
      ),
      floatingActionButton: isMobile ? _buildFloatingFilter(context) : null,
    );
  }

  Widget _buildHeroHeader(final BuildContext context, final bool isMobile) {
    return SliverAppBar(
      expandedHeight:
          context.responsive(mobile: 240.0, tablet: 280.0, desktop: 320.0),
      pinned: true,
      // Scroll yapınca AppBar'ın üstte kalmasını sağlar
      stretch: true,
      backgroundColor: AppColors.textPrimary,

      // 1. ADIM: Butonu AppBar'ın leading kısmına taşıyarak sabitliyoruz
      automaticallyImplyLeading: false,
      // Varsayılan butonu kapat
      leadingWidth: 80,
      // Butonun rahat sığması için geniş alan
      leading: const Center(
        child: Padding(
          padding: EdgeInsets.only(left: 16),
          child: GlassmorphismBackButton(
            backgroundColor: AppColors.primary,
          ),
        ),
      ),

      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Arka plan görseli
            Image.network(
              'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6',
              fit: BoxFit.cover,
            ),

            // Premium Gradient Layer
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black45, Colors.black87],
                ),
              ),
            ),

            // 2. ADIM: Marka logosu ve metinler (Buton artık burada değil)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsive(
                    mobile: 20.0, tablet: 32.0, desktop: 48.0),
                vertical: context.responsive(
                    mobile: 24.0, tablet: 32.0, desktop: 40.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBrandLogo(context),
                  const SizedBox(height: 20),
                  Text(
                    context.l10n.collection,
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 4,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    context.l10n.eleganceAndComfort,
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: context.responsive(
                          mobile: 28.0, tablet: 36.0, desktop: 44.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandLogo(final BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo Görseli (Beyaz kutu içinde)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
              ],
            ),
            child: Image.asset(
              'assets/images/saglam_spot_logo.png',
              height:
                  context.responsive(mobile: 50.0, tablet: 60.0, desktop: 70.0),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          // Marka Metinleri
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SAĞLAM SPOT",
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  fontSize: context.responsive(
                      mobile: 18.0, tablet: 22.0, desktop: 26.0),
                ),
              ),
              Text(
                context.l10n.mottoBrand,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: context.responsive(
                      mobile: 10.0, tablet: 12.0, desktop: 14.0),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(
      final BuildContext context, final bool isMobile, final String query) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: context.responsive(
        mobile: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        tablet: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        desktop: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      ),
      child: Column(
        children: [
          Container(
            height:
                context.responsive(mobile: 56.0, tablet: 60.0, desktop: 64.0),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _showSearchFocus
                    ? AppColors.textSecondary
                    : AppColors.border,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (final val) =>
                  ref.read(searchQueryProvider.notifier).update(val),
              onTap: () => setState(() => _showSearchFocus = true),
              onTapOutside: (final _) =>
                  setState(() => _showSearchFocus = false),
              style: TextStyle(
                fontSize: context.responsive(
                    mobile: 15.0, tablet: 15.5, desktop: 16.0),
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: context.l10n.searchHint,
                hintStyle: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.5),
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: _showSearchFocus
                      ? AppColors.textSecondary
                      : AppColors.textSecondary.withOpacity(0.6),
                  size: context.responsive(
                      mobile: 22.0, tablet: 23.0, desktop: 24.0),
                ),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: AppColors.textSecondary, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).update('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              ),
            ),
          ),

          // Desktop Filters Row
          if (!isMobile) ...[
            const SizedBox(height: 12),
            _buildDesktopQuickFilters(),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopQuickFilters() {
    return Consumer(
      builder: (final context, final ref, final _) {
        final filters = ref.watch(searchFiltersProvider);
        final notifier = ref.read(searchFiltersProvider.notifier);

        return Row(
          children: [
            Expanded(
              child: _buildQuickFilterDropdown(
                context.l10n.condition,
                filters.condition ?? ProductCondition.all,
                ProductCondition.values,
                (final val) => notifier.setCondition(val),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildPriceRangeButton(context)),
            const SizedBox(width: 12),
            _buildResetButton(),
          ],
        );
      },
    );
  }

  Widget _buildQuickFilterDropdown(
    final String label,
    final ProductCondition value, // String? yerine ProductCondition
    final List<ProductCondition> items,
    // List<String> yerine List<ProductCondition>
    final Function(ProductCondition?) onChanged,
    // Callback tipini de güncelle
  ) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ProductCondition>(
          // Tipi buraya açıkça yaz
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary, size: 20),
          style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500),
          // Otomatik Enum-to-L10n dönüşümü burada yapılıyor:
          items: items
              .map((final item) => DropdownMenuItem<ProductCondition>(
                    value: item,
                    child: Text(item.label(context)), // Extension metodu
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPriceRangeButton(final BuildContext context) {
    return InkWell(
      onTap: () => _showPriceRangeDialog(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Text(context.l10n.priceRange,
                style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.tune_rounded,
                color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton() => InkWell(
        onTap: _resetAll,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.refresh_rounded,
                  color: AppColors.textSecondary, size: 18),
              const SizedBox(width: 8),
              Text(context.l10n.clear,
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );

  Widget _buildCategorySection(final dynamic filters, final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.surface,
        padding: EdgeInsets.symmetric(
          vertical:
              context.responsive(mobile: 8.0, tablet: 10.0, desktop: 12.0),
        ),
        child: DynamicCategoryChips(
          selected: filters.category as ProductCategory?,
          onSelect: (final category) =>
              ref.read(searchFiltersProvider.notifier).setCategory(category),
          padding: EdgeInsets.symmetric(
            horizontal:
                context.responsive(mobile: 12.0, tablet: 20.0, desktop: 32.0),
          ),
        ),
      ),
    );
  }

  bool _hasActiveFilters(final dynamic filters) {
    return (filters.category != null &&
            filters.category != ProductCategory.other) ||
        // Eski: filters.condition != 'Tümü'
        (filters.condition != null &&
            filters.condition != ProductCondition.all) ||
        filters.minPrice > 0 ||
        filters.maxPrice < 100000;
  }

  Widget _buildActiveFiltersSliver(final dynamic filters) => SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal:
                context.responsive(mobile: 16.0, tablet: 24.0, desktop: 32.0),
            vertical: 16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (filters.category != null &&
                        filters.category != ProductCategory.other)
                      _buildFilterChip(
                        ProductCategoryExtension(filters.category)
                            .label(context),
                        Icons.category_rounded,
                        onRemove: () => ref
                            .read(searchFiltersProvider.notifier)
                            .setCategory(null),
                      ),
                    if (filters.condition != null &&
                        filters.condition != ProductCondition.all)
                      _buildFilterChip(
                        // .label(context) eklemezsen o "Instance of ProductCondition" hatasını alırsın
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
              const SizedBox(width: 12),
              const ViewModeToggle(),
              const SizedBox(width: 12),
              _buildSortDropdown(),
            ],
          ),
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
          .map((final o) => PopupMenuItem(value: o, child: Text(o.label)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_vert_rounded,
                size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(current.label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
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
          context.responsive(mobile: 20.0, tablet: 28.0, desktop: 36.0),
          context.responsive(mobile: 20.0, tablet: 24.0, desktop: 28.0),
          context.responsive(mobile: 20.0, tablet: 28.0, desktop: 36.0),
          context.responsive(mobile: 14.0, tablet: 16.0, desktop: 18.0),
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
        hasScrollBody: false, // Ekranın taşmasını önlemek için kritik ayar
        child: Padding(
          padding: context.pagePadding,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // İçeriği sıkıştırır
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

  List<Widget> _buildProductsWithAds(
      final BuildContext context, final List<Product> products) {
    final List<Widget> slivers = [];
    final crossAxisCount = context.gridColumns();
    final adFrequency = context.responsive(
        mobile: 6, tablet: 9, desktop: 12); // Her N üründe bir reklam
    final isListMode =
        ref.watch(productViewModeProvider) == ProductViewMode.list;

    // Sayfa başına gösterilecek reklam sayısını sabit bir tavanla sınırlıyoruz.
    // Filtre uygulanmadığında (Tümü) ürün sayısı çok artabiliyor; her chunk'ta
    // bir reklam eklemek onlarca AdSense DOM enjeksiyonunun AYNI ANDA monte
    // olmasına yol açıp tarayıcıyı kilitleyebiliyordu (donma + UI kaybolması).
    const int maxAdsPerList = 3;
    int adsInserted = 0;

    int productIndex = 0;
    while (productIndex < products.length) {
      final endIndex = (productIndex + adFrequency).clamp(0, products.length);
      final chunk = products.sublist(productIndex, endIndex);

      // Ürün chunklarını ekle — seçili görünüme göre ızgara veya liste.
      slivers.add(
        isListMode
            ? SliverPadding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.responsive(
                        mobile: 16.0, tablet: 20.0, desktop: 24.0)),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (final context, final i) =>
                        ProductListCard(product: chunk[i]),
                    childCount: chunk.length,
                  ),
                ),
              )
            : ResponsiveProductSliverGrid(
                products: chunk,
                onProductTap: (final p) => NavigationHandler.goToProduct(
                    context: context,
                    productId: p.id,
                    productSlug: p.name.toSlug()),
              ),
      );

      // Chunk sonunda, daha ürün varsa VE reklam tavanına ulaşılmadıysa ekle.
      if (endIndex < products.length && adsInserted < maxAdsPerList) {
        adsInserted++;
        slivers.add(
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsive(
                    mobile: 16.0, tablet: 20.0, desktop: 24.0),
                vertical: context.responsive(
                    mobile: 16.0, tablet: 20.0, desktop: 24.0),
              ),
              child: const WebAdProductCard(height: 280),
            ),
          ),
        );
      }

      productIndex = endIndex;
    }

    return slivers;
  }

  Widget _buildSectionDivider(
          final String title, final int count, final Color color) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.responsive(mobile: 20.0, tablet: 28.0, desktop: 36.0),
            context.responsive(mobile: 40.0, tablet: 48.0, desktop: 56.0),
            context.responsive(mobile: 20.0, tablet: 28.0, desktop: 36.0),
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

  void _showPriceRangeDialog(final BuildContext context) {
    final filters = ref.read(searchFiltersProvider);
    final minController = TextEditingController(
        text: filters.minPrice > 0 ? filters.minPrice.toInt().toString() : '');
    final maxController = TextEditingController(
        text: filters.maxPrice < 100000
            ? filters.maxPrice.toInt().toString()
            : '');

    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.surface,
        title: Text(context.l10n.priceRange,
            style: const TextStyle(color: AppColors.textPrimary)),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: minController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Min',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  suffixText: '₺',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('-',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
            ),
            Expanded(
              child: TextField(
                controller: maxController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Max',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  suffixText: '₺',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final min = double.tryParse(minController.text) ?? 0;
              final max = double.tryParse(maxController.text) ?? 100000;
              ref.read(searchFiltersProvider.notifier).setPriceRange(min, max);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textSecondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(context.l10n.apply),
          ),
        ],
      ),
    );
  }
}

class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _StickySearchDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  Widget build(final context, final shrinkOffset, final overlapsContent) {
    // Scroll miktarına göre opaklık ve gölge hesaplama
    final progress = shrinkOffset / maxExtent;

    return Container(
      height: maxHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(progress * 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant final _StickySearchDelegate oldDelegate) =>
      oldDelegate.minHeight != minHeight || oldDelegate.maxHeight != maxHeight;
}

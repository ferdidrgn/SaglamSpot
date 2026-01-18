import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import '../../../../core/enum/enums.dart';
import '../../../../core/extentions/app_context_ui_extension.dart';
import '../../../../core/extentions/product_category_ex.dart';
import '../../../../core/util/responsive_product_grid.dart';
import '../../../../core/widgets/ad_native_widget.dart';
import '../../../../core/widgets/shimmer_components.dart';
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
  final _scrollController = ScrollController();
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
    // String 'Tümü' yerine Enum gönderiyoruz:
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
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Fresh Hero Header
          _buildHeroHeader(context, isMobile),

          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchDelegate(
              minHeight: getSearchSectionHeight,
              maxHeight: getSearchSectionHeight,
              child: _buildSearchSection(context, isMobile, searchQuery),
            ),
          ),

          // Fresh Category Pills
          _buildCategorySection(currentFilters, isMobile),

          // Active Filters
          if (_hasActiveFilters(currentFilters))
            _buildActiveFiltersSliver(currentFilters),

          // Results Header
          searchResultsAsync.when(
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (final _, final __) =>
                const SliverToBoxAdapter(child: SizedBox.shrink()),
            data: (final products) =>
                _buildResultsHeader(context, products.length, searchQuery),
          ),

          // Product Showcase with Ads
          searchResultsAsync.when(
            loading: () => const SliverFillRemaining(child: FullPageShimmer()),
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

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: isMobile ? _buildFloatingFilter(context) : null,
    );
  }

  Widget _buildHeroHeader(final BuildContext context, final bool isMobile) {
    return SliverAppBar(
      expandedHeight:
          context.responsive(mobile: 200.0, tablet: 240.0, desktop: 280.0),
      pinned: false,
      stretch: true,
      backgroundColor: AppColors.textPrimary,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
          StretchMode.blurBackground,
        ],
        centerTitle: false,
        titlePadding: EdgeInsets.only(
          left: context.responsive(mobile: 20.0, tablet: 32.0, desktop: 40.0),
          bottom: context.responsive(mobile: 16.0, tablet: 20.0, desktop: 24.0),
        ),
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.collection,
                style: TextStyle(
                  fontSize: context.responsive(
                      mobile: 9.0, tablet: 10.0, desktop: 11.0),
                  letterSpacing: 3,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textSecondary.withOpacity(0.7),
                ),
              ),
              SizedBox(height: context.responsive(mobile: 4.0, desktop: 6.0)),
              Text(
                context.l10n.eleganceAndComfort,
                style: TextStyle(
                  fontSize: context.responsive(
                      mobile: 22.0, tablet: 28.0, desktop: 32.0),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6',
              fit: BoxFit.cover,
              errorBuilder: (final _, final __, final ___) =>
                  Container(color: AppColors.textPrimary),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    AppColors.textPrimary.withOpacity(0.85),
                    AppColors.textPrimary,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ],
        ),
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
          // Premium Search Input
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
                  fontWeight: FontWeight.w400,
                ),
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
      height: 48,
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
        child: const Row(
          children: [
            Text('Fiyat Aralığı',
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500)),
            Spacer(),
            Icon(Icons.tune_rounded, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return InkWell(
      onTap: _resetAll,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
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
  }

  Widget _buildCategorySection(final dynamic filters, final bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        height: context.responsive(mobile: 60.0, tablet: 65.0, desktop: 70.0),
        color: AppColors.surface,
        padding: EdgeInsets.symmetric(
          horizontal:
              context.responsive(mobile: 12.0, tablet: 20.0, desktop: 32.0),
          vertical:
              context.responsive(mobile: 8.0, tablet: 10.0, desktop: 12.0),
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: ProductCategory.values.length,
          separatorBuilder: (final _, final __) => const SizedBox(width: 10),
          itemBuilder: (final context, final index) {
            final category = ProductCategory.values[index];
            final isSelected =
                (filters.category ?? ProductCategory.other) == category;

            return _buildCategoryPill(
              // Extension sayesinde otomatik TR/EN gelir:
              category.label(context),
              isSelected,
              () => ref
                  .read(searchFiltersProvider.notifier)
                  .setCategory(category),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryPill(
      final String label, final bool isSelected, final VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal:
              context.responsive(mobile: 18.0, tablet: 20.0, desktop: 22.0),
          vertical:
              context.responsive(mobile: 10.0, tablet: 11.0, desktop: 12.0),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textSecondary : AppColors.secondary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.textSecondary : AppColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.textSecondary.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize:
                  context.responsive(mobile: 13.0, tablet: 13.5, desktop: 14.0),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.textPrimary,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  bool _hasActiveFilters(final dynamic filters) {
    return (filters.category != null && filters.category != ProductCategory.other) ||
        // Eski: filters.condition != 'Tümü'
        (filters.condition != null && filters.condition != ProductCondition.all) ||
        filters.minPrice > 0 ||
        filters.maxPrice < 100000;
  }

  Widget _buildActiveFiltersSliver(final dynamic filters) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal:
              context.responsive(mobile: 16.0, tablet: 24.0, desktop: 32.0),
          vertical: 16,
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (filters.category != null && filters.category != 'Tümü')
              _buildFilterChip(filters.category!, Icons.category_rounded),
            if (filters.condition != null && filters.condition != ProductCondition.all)
              _buildFilterChip(
                // .label(context) eklemezsen o "Instance of ProductCondition" hatasını alırsın
                filters.condition!.label(context),
                Icons.verified_rounded
              ),
            if (filters.minPrice > 0 || filters.maxPrice < 100000)
              _buildFilterChip(
                '${filters.minPrice.toInt()}₺ - ${filters.maxPrice.toInt()}₺',
                Icons.payments_rounded,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(final String label, final IconData icon) {
    return Container(
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
        ],
      ),
    );
  }

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

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: context.pagePadding,
          child: Column(
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
                'Aradığınız Kriterde\nÜrün Bulunamadı',
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
                'Farklı filtreler deneyebilir veya\narama teriminizi değiştirebilirsiniz',
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
                label: Text('Filtreleri Temizle',
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
  }

  Widget _buildErrorState(final String error) {
    return Center(
      child: Padding(
        padding: context.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 80, color: AppColors.error.withOpacity(0.7)),
            const SizedBox(height: 20),
            const Text('Bir Hata Oluştu',
                style: TextStyle(
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
  }

  List<Widget> _buildProductGridsWithAds(
      final BuildContext context, final List<Product> products) {
    final available = products.where((final p) => !p.isSold).toList();
    final sold = products.where((final p) => p.isSold).toList();

    final List<Widget> slivers = [];

    if (available.isNotEmpty) {
      slivers.add(_buildSectionDivider(
          context.l10n.currentCollection, available.length, AppColors.success));
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

    int productIndex = 0;
    while (productIndex < products.length) {
      final endIndex = (productIndex + adFrequency).clamp(0, products.length);
      final chunk = products.sublist(productIndex, endIndex);

      // Ürün chunklarını ekle
      slivers.add(
        ResponsiveProductSliverGrid(
          products: chunk,
          onProductTap: (final p) => context.push('/product/${p.id}'),
        ),
      );

      // Chunk sonunda ve daha ürün varsa reklam ekle
      if (endIndex < products.length) {
        slivers.add(
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsive(
                    mobile: 16.0, tablet: 20.0, desktop: 24.0),
                vertical: context.responsive(
                    mobile: 16.0, tablet: 20.0, desktop: 24.0),
              ),
              child: const AdNativeWidget(),
            ),
          ),
        );
      }

      productIndex = endIndex;
    }

    return slivers;
  }

  Widget _buildSectionDivider(
      final String title, final int count, final Color color) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.responsive(mobile: 20.0, tablet: 28.0, desktop: 36.0),
          context.responsive(mobile: 28.0, tablet: 32.0, desktop: 36.0),
          context.responsive(mobile: 20.0, tablet: 28.0, desktop: 36.0),
          context.responsive(mobile: 16.0, tablet: 18.0, desktop: 20.0),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 32,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: context.responsive(
                        mobile: 11.0, tablet: 11.5, desktop: 12.0),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.pieces(count),
                  style: TextStyle(
                    fontSize: context.responsive(
                        mobile: 12.5, tablet: 13.0, desktop: 13.5),
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingFilter(final BuildContext context) {
    return Container(
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
  }

  void _showFilterSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final _) => FilterSheet(
        onApplyFilters: () => Navigator.pop(context),
        onResetFilters: _resetAll,
      ),
    );
  }

  void _showPriceRangeDialog(final BuildContext context) {
    final filters = ref.read(searchFiltersProvider);
    final minController = TextEditingController(
      text: filters.minPrice > 0 ? filters.minPrice.toInt().toString() : '',
    );
    final maxController = TextEditingController(
      text:
          filters.maxPrice < 100000 ? filters.maxPrice.toInt().toString() : '',
    );

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
            child: const Text('İptal',
                style: TextStyle(color: AppColors.textSecondary)),
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
            child: const Text('Uygula'),
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
    return Material(elevation: shrinkOffset > 0 ? 4 : 0, child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant final _StickySearchDelegate oldDelegate) =>
      oldDelegate.minHeight != minHeight || oldDelegate.maxHeight != maxHeight;
}

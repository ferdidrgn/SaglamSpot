import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import '../../../../core/util/responsive_utils.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/responsive_product_grid.dart';
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

  final _categories = const [
    'Tümü',
    'Oturma Grupları',
    'Yatak Odası',
    'Yemek Odası',
    'Çalışma Masası',
    'Dekorasyon',
    'Aydınlatma',
  ];

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
    ref.read(searchFiltersProvider.notifier).reset();
  }

  @override
  Widget build(final BuildContext context) {
    final searchResultsAsync = ref.watch(searchedProductsProvider);
    final currentFilters = ref.watch(searchFiltersProvider);
    final isMobile = context.isMobile;
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Minimalist Hero Header
          _buildHeroHeader(context, isMobile),

          // Elegant Search Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchDelegate(
              child: _buildSearchSection(context, isMobile, searchQuery),
            ),
          ),

          // Refined Category Pills
          _buildCategorySection(currentFilters, isMobile),

          // Active Filters
          if (_hasActiveFilters(currentFilters))
            _buildActiveFiltersSliver(currentFilters),

          // Results Header with Count
          searchResultsAsync.when(
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            data: (products) => _buildResultsHeader(context, products.length, searchQuery),
          ),

          // Product Showcase
          searchResultsAsync.when(
            loading: () => const SliverFillRemaining(child: FullPageShimmer()),
            error: (err, _) => SliverFillRemaining(
              child: _buildErrorState(err.toString()),
            ),
            data: (products) {
              if (products.isEmpty) return _buildEmptyState();
              return SliverPadding(
                padding: EdgeInsets.only(
                  bottom: isMobile ? 100 : 60,
                  left: isMobile ? 0 : 20,
                  right: isMobile ? 0 : 20,
                ),
                sliver: SliverMainAxisGroup(
                  slivers: _buildProductGrids(context, products),
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: AdsenseBanner(height: 250)),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: isMobile ? _buildFloatingFilter(context) : null,
    );
  }

  Widget _buildHeroHeader(BuildContext context, bool isMobile) {
    return SliverAppBar(
      expandedHeight: isMobile ? 200 : 280,
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
          left: isMobile ? 20 : 40,
          bottom: isMobile ? 16 : 24,
        ),
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KOLEKSİYON',
                style: TextStyle(
                  fontSize: isMobile ? 9 : 11,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w300,
                  color: AppColors.accent.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Zarafet & Konfor',
                style: TextStyle(
                  fontSize: isMobile ? 22 : 32,
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
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.textPrimary,
              ),
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

  Widget _buildSearchSection(BuildContext context, bool isMobile, String query) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 16 : 20,
      ),
      child: Column(
        children: [
          // Premium Search Input
          Container(
            height: isMobile ? 56 : 64,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _showSearchFocus
                    ? AppColors.accent
                    : AppColors.border,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(searchQueryProvider.notifier).update(val);
              },
              onTap: () => setState(() => _showSearchFocus = true),
              onTapOutside: (_) => setState(() => _showSearchFocus = false),
              style: TextStyle(
                fontSize: isMobile ? 15 : 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Ürün, kategori veya stil arayın...',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: _showSearchFocus
                      ? AppColors.accent
                      : AppColors.textSecondary,
                  size: isMobile ? 22 : 24,
                ),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(searchQueryProvider.notifier).update('');
                  },
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            ),
          ),

          // Desktop Filters Row
          if (!isMobile) ...[
            const SizedBox(height: 16),
            _buildDesktopQuickFilters(),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopQuickFilters() {
    return Consumer(
      builder: (context, ref, _) {
        final filters = ref.watch(searchFiltersProvider);
        final notifier = ref.read(searchFiltersProvider.notifier);

        return Row(
          children: [
            Expanded(
              child: _buildQuickFilterDropdown(
                'Durum',
                filters.condition ?? 'Tümü',
                ['Tümü', 'Sıfır', 'İkinci El'],
                    (val) => notifier.setCondition(val),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPriceRangeButton(context),
            ),
            const SizedBox(width: 12),
            _buildResetButton(),
          ],
        );
      },
    );
  }

  Widget _buildQuickFilterDropdown(
      String label,
      String value,
      List<String> items,
      Function(String?) onChanged,
      ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary, size: 20),
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPriceRangeButton(BuildContext context) {
    return InkWell(
      onTap: () => _showPriceRangeDialog(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Text(
              'Fiyat Aralığı',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(Icons.tune_rounded,
                color: AppColors.textSecondary, size: 20),
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
          color: AppColors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.refresh_rounded,
                color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Temizle',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(dynamic filters, bool isMobile) {
    return SliverToBoxAdapter(
      child: Container(
        height: isMobile ? 60 : 70,
        color: AppColors.surface,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 32,
          vertical: isMobile ? 8 : 12,
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = (filters.category ?? 'Tümü') == category;

            return _buildCategoryPill(
              category,
              isSelected,
                  () => ref.read(searchFiltersProvider.notifier).setCategory(category),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryPill(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent
              : AppColors.background,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : AppColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : AppColors.textPrimary,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  bool _hasActiveFilters(dynamic filters) {
    return filters.category != null ||
        filters.condition != null ||
        filters.minPrice > 0 ||
        filters.maxPrice < 100000;
  }

  Widget _buildActiveFiltersSliver(dynamic filters) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (filters.category != null && filters.category != 'Tümü')
              _buildFilterChip(filters.category!, Icons.category_rounded),
            if (filters.condition != null && filters.condition != 'Tümü')
              _buildFilterChip(filters.condition!, Icons.verified_rounded),
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

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textPrimary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(BuildContext context, int count, String query) {
    if (count == 0 || query.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count Ürün Bulundu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  '"$query" için sonuçlar',
                  style: TextStyle(
                    fontSize: 13,
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
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: 56,
                  color: AppColors.textSecondary.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Aradığınız Kriterde\nÜrün Bulunamadı',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Farklı filtreler deneyebilir veya\narama teriminizi değiştirebilirsiniz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _resetAll,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text('Filtreleri Temizle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: AppColors.error.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              'Bir Hata Oluştu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProductGrids(BuildContext context, List<Product> products) {
    final available = products.where((p) => !p.isSold).toList();
    final sold = products.where((p) => p.isSold).toList();

    return [
      if (available.isNotEmpty) ...[
        _buildSectionDivider('MEVCUT KOLEKSİYON', available.length, AppColors.success),
        ResponsiveProductSliverGrid(
          products: available,
          onProductTap: (p) => context.push('/product/${p.id}'),
        ),
      ],
      if (sold.isNotEmpty) ...[
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
        _buildSectionDivider('SATILMIŞ ÜRÜNLER', sold.length, AppColors.textTertiary),
        ResponsiveProductSliverGrid(
          products: sold,
          onProductTap: (p) => context.push('/product/${p.id}'),
        ),
      ],
    ];
  }

  Widget _buildSectionDivider(String title, int count, Color color) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$count Parça',
                  style: TextStyle(
                    fontSize: 13,
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

  Widget _buildFloatingFilter(BuildContext context) {
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
        backgroundColor: AppColors.primary,
        elevation: 0,
        icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
        label: const Text(
          'Filtrele',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSheet(
        onApplyFilters: () => Navigator.pop(context),
        onResetFilters: _resetAll,
      ),
    );
  }

  void _showPriceRangeDialog(BuildContext context) {
    final filters = ref.read(searchFiltersProvider);
    final minController = TextEditingController(
      text: filters.minPrice > 0 ? filters.minPrice.toInt().toString() : '',
    );
    final maxController = TextEditingController(
      text: filters.maxPrice < 100000 ? filters.maxPrice.toInt().toString() : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Fiyat Aralığı'),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                controller: minController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Min',
                  suffixText: '₺',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: TextField(
                controller: maxController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Max',
                  suffixText: '₺',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final min = double.tryParse(minController.text) ?? 0;
              final max = double.tryParse(maxController.text) ?? 100000;
              ref.read(searchFiltersProvider.notifier).setPriceRange(min, max);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
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

  _StickySearchDelegate({required this.child});

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Material(
      elevation: shrinkOffset > 0 ? 4 : 0,
      child: child,
    );
  }

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 200;

  @override
  bool shouldRebuild(covariant _StickySearchDelegate oldDelegate) => true;
}
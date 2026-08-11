import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../domain/entites/product.dart';

class SpotProductsPage extends ConsumerStatefulWidget {
  const SpotProductsPage({super.key});

  @override
  ConsumerState<SpotProductsPage> createState() =>
      _EnhancedSpotProductsPageState();
}

class _EnhancedSpotProductsPageState extends ConsumerState<SpotProductsPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ProductCategory? _selectedCategory;
  String _selectedCondition = 'all';
  String _selectedSort = 'En Yeni';
  double _minPrice = 0;
  double _maxPrice = 50000;
  bool _showFilters = false;
  late AnimationController _filterAnimController;

  @override
  void initState() {
    super.initState();
    _filterAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _filterAnimController.dispose();
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
              _buildAnimatedBackground(context),
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildDynamicHeader(context, products.length),
                  _buildStatsAndFilters(context, products),
                  _buildCategoryFilter(context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.pagePadding.left, vertical: 8),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: ViewModeToggle(),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: SizedBox(height: context.spacingLarge)),
                  _buildProductGrid(context, filtered),
                  _buildAdBanner(context, 100),
                  SliverToBoxAdapter(
                      child: SizedBox(height: context.spacingLarge * 3)),
                ],
              ),
              ScrollUpButton(scrollController: _scrollController),
              if (_showFilters) _buildFilterPanel(context),
            ],
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // DYNAMIC HEADER WITH PARALLAX EFFECT
  // ════════════════════════════════════════════════════════════════

  Widget _buildDynamicHeader(
      final BuildContext context, final int totalProducts) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: context.responsive(
        mobile: 320,
        tablet: 400,
        desktop: 480,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient Background with Animation
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent.withOpacity(0.15),
                    AppColors.background,
                    AppColors.secondary.withOpacity(0.3),
                  ],
                ),
              ),
            ),

            // Animated Diagonal Lines Pattern
            CustomPaint(
              painter: _DiagonalLinesPainter(
                  color: AppColors.primary.withOpacity(0.04)),
            ),

            // Content
            SafeArea(
              child: Padding(
                padding: context.pagePadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breadcrumb
                    _buildBreadcrumb(context),
                    SizedBox(height: context.spacingLarge),

                    // Special Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: AppColors.error.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_fire_department,
                              color: AppColors.error, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'SPOT ÜRÜNLER',
                            style: TextStyle(
                              fontSize: context.captionSize,
                              fontWeight: FontWeight.w800,
                              color: AppColors.error,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.spacing),

                    // Main Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fırsat\nÜrünleri',
                                style: TextStyle(
                                  fontFamily: 'Fraunces',
                                  fontSize: context.responsive(
                                    mobile: 48,
                                    tablet: 64,
                                    desktop: 80,
                                  ),
                                  fontWeight: FontWeight.w600,
                                  height: 0.95,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -2,
                                ),
                              ),
                              SizedBox(height: context.spacing),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                child: Text(
                                  'Kaliteli ürünlerde inanılmaz fiyatlar',
                                  style: TextStyle(
                                    fontSize: context.responsive(
                                        mobile: 16, desktop: 20),
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Circular Badge (Desktop)
                        if (context.isDesktop)
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.error,
                                  AppColors.error.withOpacity(0.7),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.error.withOpacity(0.4),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '%30',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'İNDİRİM',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white70,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: context.spacingLarge),

                    // Decorative Elements
                    Row(
                      children: [
                        Container(
                          width: context.responsive(mobile: 80, desktop: 140),
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.spacing),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(final BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.home_outlined,
            size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          'Ana Sayfa',
          style: TextStyle(
            fontSize: context.captionSize,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right,
            size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          'Spot Ürünler',
          style: TextStyle(
            fontSize: context.captionSize,
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════
  // STATS & FILTERS BAR
  // ════════════════════════════════════════════════════════════════

  Widget _buildStatsAndFilters(
      final BuildContext context, final List<Product> products) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: context.sectionPadding,
        child: Column(
          children: [
            // Stats Cards
            context.responsive(
              mobile: _buildStatsColumn(context, products),
              desktop: _buildStatsRow(context, products),
            ),

            SizedBox(height: context.spacingLarge),

            // Filter & Search Bar
            Row(
              children: [
                Expanded(child: _buildSearchBar(context)),
                SizedBox(width: context.spacing),
                _buildFilterButton(context),
                if (context.isTablet || context.isDesktop) ...[
                  SizedBox(width: context.spacing),
                  _buildSortButton(context),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(
      final BuildContext context, final List<Product> products) {
    return Row(
      children: [
        Expanded(
            child: _buildStatCard(context, '${products.length}', 'Spot Ürün',
                Icons.inventory_2_outlined, AppColors.error)),
        SizedBox(width: context.spacing),
        Expanded(
            child: _buildStatCard(context, '%30', 'İndirim',
                Icons.local_offer_outlined, AppColors.success)),
        SizedBox(width: context.spacing),
        Expanded(
            child: _buildStatCard(context, '16/6', 'Destek',
                Icons.support_agent_outlined, AppColors.info)),
        SizedBox(width: context.spacing),
        Expanded(
            child: _buildStatCard(
                context,
                'Ücretsiz',
                'Maalesef Yakın Çevrelerimize, Kargo',
                Icons.local_shipping_outlined,
                AppColors.accent)),
      ],
    );
  }

  Widget _buildStatsColumn(
      final BuildContext context, final List<Product> products) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _buildStatCard(context, '${products.length}',
                    'Spot Ürün', Icons.inventory_2_outlined, AppColors.error)),
            SizedBox(width: context.spacing),
            Expanded(
                child: _buildStatCard(context, '%30', 'İndirim',
                    Icons.local_offer_outlined, AppColors.success)),
          ],
        ),
        SizedBox(height: context.spacing),
        Row(
          children: [
            Expanded(
                child: _buildStatCard(context, '16/6', 'Destek',
                    Icons.support_agent_outlined, AppColors.info)),
            SizedBox(width: context.spacing),
            Expanded(
                child: _buildStatCard(context, 'Ücretsiz', 'Kargo',
                    Icons.local_shipping_outlined, AppColors.accent)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(final BuildContext context, final String value,
          final String label, final IconData icon, final Color color) =>
      Container(
        padding: EdgeInsets.all(context.responsive(mobile: 16, desktop: 24)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: context.spacing),
            Text(
              value,
              style: TextStyle(
                fontSize: context.responsive(mobile: 20, desktop: 28),
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: context.captionSize,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  Widget _buildSearchBar(final BuildContext context) => GestureDetector(
        onTap: () => context.go('/search'),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: context.bodySize,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Detaylı ürün araması için ',
                      ),
                      const TextSpan(
                        text: 'Ctrl + K',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentDark,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(
                        text: ' yapın ya da ',
                      ),
                      TextSpan(
                        text: 'BURADAKİ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentDark,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.go('/search'),
                      ),
                      const TextSpan(
                        text: ' yazıya tıklayın.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildFilterButton(final BuildContext context) {
    return Material(
      color: _showFilters ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          setState(() => _showFilters = !_showFilters);
          if (_showFilters)
            _filterAnimController.forward();
          else
            _filterAnimController.reverse();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _showFilters ? Colors.transparent : AppColors.border,
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.tune,
            color: _showFilters ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildSortButton(final BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: DropdownButton<String>(
        value: _selectedSort,
        underline: const SizedBox(),
        icon:
            const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
        items: [
          'En Yeni',
          'Fiyat: Düşük-Yüksek',
          'Fiyat: Yüksek-Düşük',
          'En Popüler'
        ].map((final e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (final val) => setState(() => _selectedSort = val!),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // FILTER PANEL (Animated Slide-in)
  // ════════════════════════════════════════════════════════════════

  Widget _buildFilterPanel(final BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() => _showFilters = false);
          _filterAnimController.reverse();
        },
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping panel
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _filterAnimController,
                  curve: Curves.easeOut,
                )),
                child: Container(
                  width: context.responsive(
                      mobile: context.screenWidth * 0.85, desktop: 400),
                  height: double.infinity,
                  color: AppColors.surface,
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Padding(
                          padding: EdgeInsets.all(context.spacingLarge),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'FİLTRELER',
                                style: TextStyle(
                                  fontSize: context.h4Size,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() => _showFilters = false);
                                  _filterAnimController.reverse();
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),

                        // Filter Content
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.all(context.spacingLarge),
                            children: [
                              _buildFilterSection(
                                context.l10n.statusLabel.toUpperCase(),
                                const ['all', 'new', 'used', 'showcase'],
                                [
                                  context.l10n.conditionAll,
                                  context.l10n.conditionNew,
                                  context.l10n.conditionUsed,
                                  context.l10n.conditionShowcase,
                                ],
                                _selectedCondition,
                                (final val) =>
                                    setState(() => _selectedCondition = val),
                              ),
                              SizedBox(height: context.spacingLarge),
                              _buildPriceRangeFilter(context),
                              SizedBox(height: context.spacingLarge),
                              _buildResetButton(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(final String title, final List<String> values,
      final List<String> labels, final String selected,
      final Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(values.length, (final i) {
            final value = values[i];
            final isSelected = selected == value;
            return GestureDetector(
              onTap: () => onSelect(value),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.error : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.error : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FİYAT ARALIĞI',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        RangeSlider(
          values: RangeValues(_minPrice, _maxPrice),
          min: 0,
          max: 50000,
          divisions: 100,
          activeColor: AppColors.error,
          inactiveColor: AppColors.border,
          labels: RangeLabels(
            '₺${_minPrice.toInt()}',
            '₺${_maxPrice.toInt()}',
          ),
          onChanged: (final values) {
            setState(() {
              _minPrice = values.start;
              _maxPrice = values.end;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₺${_minPrice.toInt()}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '₺${_maxPrice.toInt()}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResetButton(final BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedCondition = 'all';
              _minPrice = 0;
              _maxPrice = 50000;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: const Center(
            child: Text(
              'FİLTRELERİ TEMİZLE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // CATEGORY FILTER
  // ════════════════════════════════════════════════════════════════

  Widget _buildCategoryFilter(final BuildContext context) {
    return SliverToBoxAdapter(
      child: DynamicCategoryChips(
        selected: _selectedCategory,
        onSelect: (final category) =>
            setState(() => _selectedCategory = category),
        padding: EdgeInsets.symmetric(horizontal: context.pagePadding.left),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // PRODUCT GRID
  // ════════════════════════════════════════════════════════════════

  Widget _buildProductGrid(
      final BuildContext context, final List<Product> products) {
    if (products.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 400,
          margin: context.sectionPadding,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 80,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Ürün bulunamadı',
                style: TextStyle(
                  fontSize: context.h4Size,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Farklı filtreler deneyebilirsiniz',
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (ref.watch(productViewModeProvider) == ProductViewMode.list) {
      return SliverPadding(
        padding: context.sectionPadding,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (final context, final index) =>
                ProductListCard(product: products[index]),
            childCount: products.length,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: context.sectionPadding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.responsive(
            mobile: 2,
            tablet: 3,
            desktop: 4,
            largeDesktop: 5,
          ),
          crossAxisSpacing: context.gridSpacing,
          mainAxisSpacing: context.gridSpacing,
          childAspectRatio: context.responsive(
            mobile: 0.65,
            tablet: 0.70,
            desktop: 0.73,
          ),
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) {
            if (isAdSlot(index, products.length)) return const NativeAdCard();
            final realIndex = realIndexForAdGrid(index, products.length);
            if (realIndex >= products.length) return const SizedBox.shrink();
            return _buildSpotProductCard(context, products[realIndex]);
          },
          childCount: paddedItemCountForAds(products.length),
        ),
      ),
    );
  }

  Widget _buildSpotProductCard(
      final BuildContext context, final Product product) {
    // Use CustomProductCard with special Spot styling overlay
    return Stack(
      children: [
        CustomProductCard(product: product),

        // Spot Badge Overlay
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.error, AppColors.error.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withOpacity(0.4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Text(
              'SPOT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedBackground(final BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _SpotPatternPainter(
          color: AppColors.error.withOpacity(0.02),
        ),
      ),
    );
  }

  Widget _buildAdBanner(final BuildContext context, final double height) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: context.sectionPadding,
        child: AdsenseBanner(height: height,type: AdUnitType.multiplex),
      ),
    );
  }

  Widget _buildErrorState(final BuildContext context, final String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Bir hata oluştu',
            style: TextStyle(
              fontSize: context.h4Size,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Product> _filterProducts(final List<Product> products) {
    var filtered = products;

    // Category filter
    if (_selectedCategory != null) {
      filtered =
          filtered.where((final p) => p.category == _selectedCategory).toList();
    }

    // Condition filter
    if (_selectedCondition != 'all') {
      // Add your condition logic here
    }

    // Price filter
    filtered = filtered
        .where((final p) => p.price >= _minPrice && p.price <= _maxPrice)
        .toList();

    // Sort
    switch (_selectedSort) {
      case 'Fiyat: Düşük-Yüksek':
        filtered.sort((final a, final b) => a.price.compareTo(b.price));
        break;
      case 'Fiyat: Yüksek-Düşük':
        filtered.sort((final a, final b) => b.price.compareTo(a.price));
        break;
    }

    return filtered;
  }
}

// ════════════════════════════════════════════════════════════════
// CUSTOM PAINTERS
// ════════════════════════════════════════════════════════════════

class _DiagonalLinesPainter extends CustomPainter {
  final Color color;

  _DiagonalLinesPainter({required this.color});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (double i = -size.height; i < size.width + size.height; i += 40) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(final _) => false;
}

class _SpotPatternPainter extends CustomPainter {
  final Color color;

  _SpotPatternPainter({required this.color});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (double i = 0; i < size.width; i += 100) {
      for (double j = 0; j < size.height; j += 100) {
        if ((i + j) % 200 == 0) {
          canvas.drawCircle(Offset(i, j), 5, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(final _) => false;
}

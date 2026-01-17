import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/responsive_utils.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../../core/widgets/shimmer_components.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../domain/entites/product.dart';

class SpotProductsPage extends ConsumerStatefulWidget {
  const SpotProductsPage({super.key});

  @override
  ConsumerState<SpotProductsPage> createState() =>
      _EnhancedSpotProductsPageState();
}

class _EnhancedSpotProductsPageState
    extends ConsumerState<SpotProductsPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'Tümü';
  String _selectedCondition = 'Tümü';
  String _selectedSort = 'En Yeni';
  double _minPrice = 0;
  double _maxPrice = 50000;
  bool _showFilters = false;
  late AnimationController _filterAnimController;

  @override
  void initState() {
    super.initState();
    _filterAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Auto-hide filters on scroll
    if (_scrollController.offset > 100 && _showFilters) {
      setState(() => _showFilters = false);
      _filterAnimController.reverse();
    }
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
                  _buildDealsBanner(context),
                  _buildStatsAndFilters(context, products),
                  _buildCategoryFilter(context),
                  SliverToBoxAdapter(
                      child: SizedBox(height: context.spacingLarge)),
                  _buildProductGrid(context, filtered),
                  _buildAdBanner(context, 100),
                  _buildSpecialOffers(context),
                  _buildWhySpotSection(context),
                  SliverToBoxAdapter(
                      child: SizedBox(height: context.spacingLarge * 3)),
                ],
              ),
              if (context.isDesktop) _buildFloatingActions(context),
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
                color: AppColors.primary.withOpacity(0.04),
              ),
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
                                  fontSize: context.responsive(
                                    mobile: 48,
                                    tablet: 64,
                                    desktop: 80,
                                  ),
                                  fontWeight: FontWeight.w900,
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
                                  '%70',
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
        const Icon(Icons.home_outlined, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          'Ana Sayfa',
          style: TextStyle(
            fontSize: context.captionSize,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, size: 14, color: AppColors.textSecondary),
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
  // DEALS BANNER (Limited Time Offers)
  // ════════════════════════════════════════════════════════════════

  Widget _buildDealsBanner(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.sectionPadding.copyWith(top: 0, bottom: 0),
        padding: EdgeInsets.all(context.responsive(mobile: 20, desktop: 32)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.error.withOpacity(0.9),
              AppColors.error,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'SINIRLΙ SÜRE!',
                        style: TextStyle(
                          fontSize: context.captionSize,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.spacing),
                  Text(
                    'Bu Hafta Özel İndirimler',
                    style: TextStyle(
                      fontSize: context.responsive(mobile: 20, desktop: 28),
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: context.spacing / 2),
                  Text(
                    'Seçili ürünlerde %70\'e varan indirim',
                    style: TextStyle(
                      fontSize: context.bodySize,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            if (context.isDesktop) ...[
              const SizedBox(width: 32),
              _buildCountdownTimer(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownTimer(final BuildContext context) {
    return Row(
      children: [
        _buildTimerBox('23', 'SAAT'),
        const SizedBox(width: 8),
        _buildTimerBox('45', 'DAKİKA'),
        const SizedBox(width: 8),
        _buildTimerBox('12', 'SANİYE'),
      ],
    );
  }

  Widget _buildTimerBox(final String value, final String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
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
            child: _buildStatCard(context, '%70', 'İndirim',
                Icons.local_offer_outlined, AppColors.success)),
        SizedBox(width: context.spacing),
        Expanded(
            child: _buildStatCard(context, '24/7', 'Destek',
                Icons.support_agent_outlined, AppColors.info)),
        SizedBox(width: context.spacing),
        Expanded(
            child: _buildStatCard(context, 'Ücretsiz', 'Kargo',
                Icons.local_shipping_outlined, AppColors.accent)),
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
                child: _buildStatCard(context, '%70', 'İndirim',
                    Icons.local_offer_outlined, AppColors.success)),
          ],
        ),
        SizedBox(height: context.spacing),
        Row(
          children: [
            Expanded(
                child: _buildStatCard(context, '24/7', 'Destek',
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
      final String label, final IconData icon, final Color color) {
    return Container(
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
  }

  Widget _buildSearchBar(final BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Fırsat ürünlerinde ara...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: context.bodySize,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFilterButton(final BuildContext context) {
    return Material(
      color: _showFilters ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          setState(() => _showFilters = !_showFilters);
          if (_showFilters) {
            _filterAnimController.forward();
          } else {
            _filterAnimController.reverse();
          }
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
                                'DURUM',
                                ['Tümü', 'Sıfır', 'İkinci El', 'Vitrin'],
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

  Widget _buildFilterSection(final String title, final List<String> options,
      final String selected, final Function(String) onSelect) {
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
          children: options.map((final option) {
            final isSelected = selected == option;
            return GestureDetector(
              onTap: () => onSelect(option),
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
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
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
              _selectedCondition = 'Tümü';
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
    final categories = [
      'Tümü',
      'Koltuk',
      'Masa',
      'Dekor',
      'Ofis',
      'Yatak',
      'Sandalye',
      'Dolap'
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: context.responsive(mobile: 60, desktop: 70),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: context.pagePadding.left),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (final _, final __) => const SizedBox(width: 12),
          itemBuilder: (final context, final index) {
            final isActive = _selectedCategory == categories[index];

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () =>
                    setState(() => _selectedCategory = categories[index]),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsive(mobile: 24, desktop: 32),
                  ),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: [
                              AppColors.error,
                              AppColors.error.withOpacity(0.8)
                            ],
                          )
                        : null,
                    color: isActive ? null : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive ? Colors.transparent : AppColors.border,
                      width: 1.5,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.error.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isActive ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: context.bodySize,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
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
          (final context, final index) =>
              _buildSpotProductCard(context, products[index]),
          childCount: products.length,
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

  // ════════════════════════════════════════════════════════════════
  // SPECIAL OFFERS SECTION
  // ════════════════════════════════════════════════════════════════

  Widget _buildSpecialOffers(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: context.sectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ÖZEL FIRSATLAR',
              style: TextStyle(
                fontSize: context.h3Size,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.spacingLarge),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount:
                  context.responsive(mobile: 1, tablet: 2, desktop: 3),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: context.responsive(mobile: 2.5, desktop: 3),
              children: [
                _buildOfferCard(
                  icon: Icons.local_fire_department,
                  title: 'Günün Fırsatı',
                  subtitle: 'Bugün %50 indirim',
                  color: AppColors.error,
                ),
                _buildOfferCard(
                  icon: Icons.flash_on,
                  title: 'Hızlı Teslimat',
                  subtitle: 'Aynı gün kargo',
                  color: AppColors.accent,
                ),
                _buildOfferCard(
                  icon: Icons.card_giftcard,
                  title: 'Hediye Çeki',
                  subtitle: '500₺ ve üzeri alışverişte',
                  color: AppColors.success,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard({
    required final IconData icon,
    required final String title,
    required final String subtitle,
    required final Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // WHY SPOT SECTION
  // ════════════════════════════════════════════════════════════════

  Widget _buildWhySpotSection(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.sectionPadding,
        padding: context.responsive(
          mobile: const EdgeInsets.all(32),
          desktop: const EdgeInsets.all(48),
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondary,
              AppColors.background,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NEDEN SPOT ÜRÜN?',
              style: TextStyle(
                fontSize: context.h3Size,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.spacingLarge),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount:
                  context.responsive(mobile: 1, tablet: 2, desktop: 4),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: context.responsive(mobile: 3, desktop: 1.2),
              children: [
                _buildReasonCard(
                  icon: Icons.price_check,
                  title: 'Uygun Fiyat',
                  description: 'En iyi fiyat garantisi',
                ),
                _buildReasonCard(
                  icon: Icons.verified,
                  title: 'Kalite Kontrolü',
                  description: 'Tüm ürünler test edilir',
                ),
                _buildReasonCard(
                  icon: Icons.security,
                  title: 'Güvenli Alışveriş',
                  description: 'SSL sertifikası',
                ),
                _buildReasonCard(
                  icon: Icons.refresh,
                  title: 'Kolay İade',
                  description: '14 gün iade hakkı',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonCard({
    required final IconData icon,
    required final String title,
    required final String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // HELPER WIDGETS
  // ════════════════════════════════════════════════════════════════

  Widget _buildFloatingActions(final BuildContext context) {
    return Positioned(
      right: 32,
      bottom: 32,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFloatingButton(
            icon: Icons.filter_list,
            color: AppColors.error,
            onTap: () {
              setState(() => _showFilters = !_showFilters);
              if (_showFilters) {
                _filterAnimController.forward();
              } else {
                _filterAnimController.reverse();
              }
            },
          ),
          const SizedBox(height: 12),
          _buildFloatingButton(
            icon: Icons.arrow_upward,
            onTap: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({
    required final IconData icon,
    final Color? color,
    required final VoidCallback onTap,
  }) {
    return Material(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color != null ? Colors.transparent : AppColors.border,
            ),
          ),
          child: Icon(
            icon,
            color: color != null ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
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
        child: AdsenseBanner(height: height),
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
    if (_selectedCategory != 'Tümü') {
      filtered =
          filtered.where((final p) => p.category == _selectedCategory).toList();
    }

    // Condition filter
    if (_selectedCondition != 'Tümü') {
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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../core/widgets/shimmer_components.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../domain/entites/product.dart';

class NewProductsPage extends ConsumerStatefulWidget {
  const NewProductsPage({super.key});

  @override
  ConsumerState<NewProductsPage> createState() =>
      _EnhancedNewProductsPageState();
}

class _EnhancedNewProductsPageState extends ConsumerState<NewProductsPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'Tümü';
  String _selectedSort = 'Yeniler';
  late AnimationController _filterAnimController;

  @override
  void initState() {
    super.initState();
    _filterAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
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
          final products = ref.watch(newDealsProductsProvider);
          final filtered = _filterProducts(products);

          return Stack(
            children: [
              _buildBackgroundPattern(context),
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeroHeader(context, products.length),
                  _buildStatsBar(context, products),
                  _buildFilterSection(context),
                  _buildCategoryTabs(context),
                  SliverToBoxAdapter(
                      child: SizedBox(height: context.spacingLarge)),
                  _buildProductGrid(context, filtered),
                  _buildAdBanner(context, 120),
                  SliverToBoxAdapter(
                      child: SizedBox(height: context.spacingLarge * 3)),
                ],
              ),
              ScrollUpButton(scrollController: _scrollController),
            ],
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // HERO HEADER WITH ANIMATED GRADIENT
  // ════════════════════════════════════════════════════════════════

  Widget _buildHeroHeader(
          final BuildContext context, final int totalProducts) =>
      SliverAppBar(
        pinned: true,
        expandedHeight: context.responsive(
          mobile: 280,
          tablet: 360,
          desktop: 420,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: [
              // Animated Gradient Background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.secondary,
                      AppColors.background,
                      AppColors.secondary.withOpacity(0.3),
                    ],
                  ),
                ),
              ),

              // Geometric Pattern Overlay
              CustomPaint(
                painter: _GeometricPatternPainter(
                  color: AppColors.primary.withOpacity(0.03),
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

                      // Main Title
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'NEW COLLECTION',
                                  style: TextStyle(
                                    fontSize: context.captionSize,
                                    letterSpacing: 4,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accent,
                                  ),
                                ),
                                SizedBox(height: context.spacing),
                                Text(
                                  'Yeni\nKoleksiyon',
                                  style: TextStyle(
                                    fontSize: context.responsive(
                                      mobile: 42,
                                      tablet: 56,
                                      desktop: 72,
                                    ),
                                    fontWeight: FontWeight.w900,
                                    height: 0.95,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -1,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Featured Badge (Desktop only)
                          if (context.isDesktop)
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$totalProducts+',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'ÜRÜN',
                                    style: TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 2,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: context.spacingLarge),

                      // Decorative Line
                      Row(
                        children: [
                          Container(
                            width: context.responsive(mobile: 60, desktop: 120),
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
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

  Widget _buildBreadcrumb(final BuildContext context) => Row(
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
            'Yeni Koleksiyon',
            style: TextStyle(
              fontSize: context.captionSize,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );

  // ════════════════════════════════════════════════════════════════
  // STATS BAR
  // ════════════════════════════════════════════════════════════════

  Widget _buildStatsBar(
          final BuildContext context, final List<Product> products) =>
      SliverToBoxAdapter(
        child: Container(
          margin: context.sectionPadding.copyWith(top: 0, bottom: 0),
          padding: EdgeInsets.symmetric(
            vertical: context.spacing,
            horizontal: context.responsive(mobile: 16, desktop: 32),
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(
                context.responsive(mobile: 16, desktop: 24)),
            border: Border.all(color: AppColors.border, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: context.responsive(
            mobile: _buildStatsColumn(context, products),
            desktop: _buildStatsRow(context, products),
          ),
        ),
      );

  Widget _buildStatsRow(
          final BuildContext context, final List<Product> products) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, '${products.length}', 'TOPLAM ÜRÜN',
              Icons.inventory_2_outlined),
          _buildDivider(context),
          _buildStatItem(context, '5', 'KATEGORİ', Icons.category_outlined),
          _buildDivider(context),
          _buildStatItem(context, 'YENİ', 'DURUM', Icons.fiber_new_outlined),
          _buildDivider(context),
          _buildStatItem(context, '⭐ 4.8', 'PUAN', Icons.star_outline),
        ],
      );

  Widget _buildStatsColumn(
          final BuildContext context, final List<Product> products) =>
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(context, '${products.length}', 'TOPLAM ÜRÜN',
                  Icons.inventory_2_outlined),
              _buildStatItem(context, '5', 'KATEGORİ', Icons.category_outlined),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                  context, 'YENİ', 'DURUM', Icons.fiber_new_outlined),
              _buildStatItem(context, '⭐ 4.8', 'PUAN', Icons.star_outline),
            ],
          ),
        ],
      );

  Widget _buildStatItem(final BuildContext context, final String value,
          final String label, final IconData icon) =>
      Column(
        children: [
          Icon(icon,
              size: context.responsive(mobile: 20, desktop: 24),
              color: AppColors.accent),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: context.responsive(mobile: 18, desktop: 24),
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: context.captionSize,
              letterSpacing: 1.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );

  Widget _buildDivider(final BuildContext context) => Container(
        height: 50,
        width: 1,
        color: AppColors.border,
      );

  // ════════════════════════════════════════════════════════════════
  // FILTER SECTION
  // ════════════════════════════════════════════════════════════════

  Widget _buildFilterSection(final BuildContext context) => SliverToBoxAdapter(
        child: Padding(
          padding: context.sectionPadding,
          child: Row(
            children: [
              Expanded(
                child: _buildSearchBar(context),
              ),
              SizedBox(width: context.spacing),
              _buildSortDropdown(context),
              if (context.isTablet || context.isDesktop) ...[
                SizedBox(width: context.spacing),
                _buildViewToggle(context),
              ],
            ],
          ),
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

  Widget _buildSortDropdown(final BuildContext context) => Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: DropdownButton<String>(
          value: _selectedSort,
          underline: const SizedBox(),
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.textPrimary),
          items: [
            'Yeniler',
            'Fiyat: Düşük-Yüksek',
            'Fiyat: Yüksek-Düşük',
            'En Popüler'
          ]
              .map((final e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (final val) => setState(() => _selectedSort = val!),
        ),
      );

  Widget _buildViewToggle(final BuildContext context) => Container(
        height: 56,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Row(
          children: [
            _buildToggleButton(Icons.grid_view, true),
            const SizedBox(width: 4),
            _buildToggleButton(Icons.view_list, false),
          ],
        ),
      );

  Widget _buildToggleButton(final IconData icon, final bool isActive) =>
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : AppColors.textSecondary,
          size: 20,
        ),
      );

  // ════════════════════════════════════════════════════════════════
  // CATEGORY TABS
  // ════════════════════════════════════════════════════════════════

  Widget _buildCategoryTabs(final BuildContext context) {
    final categories = [
      'Tümü',
      'Koltuk',
      'Masa',
      'Dekor',
      'Ofis',
      'Yatak',
      'Aydınlatma'
    ];

    return SliverToBoxAdapter(
      child: SizedBox(
        height: context.responsive(mobile: 56, desktop: 64),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: context.pagePadding.left),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (final _, final __) => const SizedBox(width: 12),
          itemBuilder: (final context, final index) {
            final isActive = _selectedCategory == categories[index];

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () =>
                      setState(() => _selectedCategory = categories[index]),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.responsive(mobile: 20, desktop: 32),
                    ),
                    decoration: BoxDecoration(
                      gradient: isActive ? AppColors.primaryGradient : null,
                      color: isActive ? null : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isActive ? Colors.transparent : AppColors.border,
                        width: 1.5,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color:
                              isActive ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: context.bodySize,
                          letterSpacing: 0.5,
                        ),
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
    if (products.isEmpty)
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
            ],
          ),
        ),
      );

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
            mobile: 0.68,
            tablet: 0.72,
            desktop: 0.75,
          ),
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) =>
              _buildEnhancedProductCard(context, products[index]),
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildEnhancedProductCard(
          final BuildContext context, final Product product) =>
      CustomProductCard(product: product);

  // ════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ════════════════════════════════════════════════════════════════

  List<Product> _filterProducts(final List<Product> products) {
    var filtered = products;

    if (_selectedCategory != 'Tümü')
      filtered =
          filtered.where((final p) => p.category == _selectedCategory).toList();

    // Sort logic
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

  Widget _buildBackgroundPattern(final BuildContext context) => Positioned.fill(
        child: CustomPaint(
          painter: _BackgroundPatternPainter(
              color: AppColors.primary.withOpacity(0.02)),
        ),
      );

  Widget _buildAdBanner(final BuildContext context, final double height) =>
      SliverToBoxAdapter(
        child: Padding(
            padding: context.sectionPadding,
            child: AdsenseBanner(height: height)),
      );

  Widget _buildErrorState(final BuildContext context, final String error) =>
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Bir hata oluştu',
              style: TextStyle(
                  fontSize: context.h4Size, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
}

// ════════════════════════════════════════════════════════════════
// CUSTOM PAINTERS
// ════════════════════════════════════════════════════════════════

class _GeometricPatternPainter extends CustomPainter {
  final Color color;

  _GeometricPatternPainter({required this.color});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (double i = 0; i < size.width; i += 80)
      for (double j = 0; j < size.height; j += 80) {
        canvas.drawCircle(Offset(i, j), 30, paint);
        canvas.drawRect(Rect.fromLTWH(i - 15, j - 15, 30, 30), paint);
      }
  }

  @override
  bool shouldRepaint(final _) => false;
}

class _BackgroundPatternPainter extends CustomPainter {
  final Color color;

  _BackgroundPatternPainter({required this.color});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.8;

    for (double i = 0; i < size.width; i += 60)
      canvas.drawLine(Offset(i, 0), Offset(i - 100, size.height), paint);
  }

  @override
  bool shouldRepaint(final _) => false;
}

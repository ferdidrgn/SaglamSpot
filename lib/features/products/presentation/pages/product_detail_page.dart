import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/features/products/domain/entites/product.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/services/deeplink/deeplink_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/widgets/back_button_glassmorphism.dart';
import '../../../../core/widgets/count_up_on_visible.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../data/models/category_meta.dart';
import '../providers/product_filters_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_color_section.dart';
import '../widgets/wave_bottom_clipper.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage>
    with TickerProviderStateMixin {
  int _selectedImageIndex = 0;
  bool _isFavorite = false;
  bool _showMoreDescription = false;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  // Sayfa açılırken bilgi kartının yumuşak şekilde belirmesi için.
  late final AnimationController _entranceController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<double> _entranceFade = CurvedAnimation(
    parent: _entranceController,
    curve: Curves.easeOut,
  );
  late final Animation<Offset> _entranceSlide = Tween<Offset>(
    begin: const Offset(0, 0.04),
    end: Offset.zero,
  ).animate(CurvedAnimation(
      parent: _entranceController, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
    _entranceController.forward();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_isScrolled)
      setState(() => _isScrolled = true);
    else if (_scrollController.offset <= 100 && _isScrolled)
      setState(() => _isScrolled = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(widget.productId));

    return productAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body:
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (final e, final _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(e.toString(),
              style: const TextStyle(color: AppColors.textPrimary)),
        ),
      ),
      data: (final product) {
        final similarProducts = ref.watch(similarProductsProvider(
          category: product.category.name,
          // Enum'ın kod adını gönderiyoruz (örn: sofa)
          currentProductId: product.id,
        ));
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(context, product),
                  SliverToBoxAdapter(
                      child: SizedBox(
                          height: MediaQuery.of(context).padding.top + 20)),
                  _buildResponsiveProductLayout(context, product),
                  _buildTabSection(context, product),
                  _buildSimilarProducts(context, similarProducts),
                  _buildFeatures(context),
                  _buildReviews(context),
                  SliverToBoxAdapter(
                      child: SizedBox(height: context.spacingLarge * 3)),
                ],
              ),
              _buildFloatingHeader(context, product),
            ],
          ),
          bottomNavigationBar:
              context.isMobile ? _buildMobileBottomBar(context, product) : null,
        );
      },
    );
  }

  // ════════════════════════════════════════════════════════════════
  // FLOATING HEADER (for scroll effect)
  // ════════════════════════════════════════════════════════════════

  Widget _buildFloatingHeader(
      final BuildContext context, final Product product) {
    final double safeTop = MediaQuery.of(context).padding.top;
    final double headerHeight = safeTop + 60; // Dinamik yükseklik

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      top: _isScrolled ? 0 : -headerHeight,
      // Yukarı kaydırarak gizle/göster
      left: 0,
      right: 0,
      child: GlassmorphismAppBar(
        title: product.name,
        subtitle: product.isSold
            ? context.l10n.sold
            : '₺${product.price.toStringAsFixed(0)}',
        showBackButton: true,
        // Actions kısmı mobil/tablet için responsive olmalı
        actions: [
          if (!context.isMobile) ...[
            // Mobilde çok kalabalık yapmasın
            GlassmorphismIconButton(
              icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
              onPressed: () => setState(() => _isFavorite = !_isFavorite),
              backgroundColor:
                  _isFavorite ? AppColors.error : AppColors.primary,
            ),
            const SizedBox(width: 8),
          ],
          GlassmorphismIconButton(
            icon: Icons.share_outlined,
            onPressed: () => FurnitureShareService.shareProduct(
              productId: product.id,
              productName: product.name,
            ),
            backgroundColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════
  // SLIVER APP BAR
  // ════════════════════════════════════════════════════════════════

  SliverAppBar _buildSliverAppBar(
          final BuildContext context, final Product product) =>
      const SliverAppBar(
        expandedHeight: 0,
        pinned: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: SizedBox(),
      );

  // ════════════════════════════════════════════════════════════════
  // RESPONSIVE PRODUCT LAYOUT
  // ════════════════════════════════════════════════════════════════

  Widget _buildResponsiveProductLayout(
          final BuildContext context, final Product product) =>
      context.responsive(
          mobile: _buildMobileLayout(context, product),
          desktop: _buildDesktopLayout(context, product));

  SliverToBoxAdapter _buildDesktopLayout(
          final BuildContext context, final Product product) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: context.sectionPadding,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1600),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gallery Section - 55%
                Expanded(
                  flex: 55,
                  child: _buildGallerySection(
                    context,
                    product,
                    height: context.hp(75),
                  ),
                ),
                SizedBox(width: context.spacingLarge * 2),

                // Info Section - 45%
                Expanded(
                  flex: 45,
                  child: _buildStickyInfoSection(context, product),
                ),
              ],
            ),
          ),
        ),
      );

  SliverList _buildMobileLayout(
          final BuildContext context, final Product product) =>
      SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: context.pagePadding,
            child: Column(
              children: [
                _buildGallerySection(
                  context,
                  product,
                  height: context.hp(50),
                  isMobile: true,
                ),
                SizedBox(height: context.spacingLarge),
                _buildProductInfo(context, product, isMobile: true),
              ],
            ),
          ),
        ]),
      );

  // ════════════════════════════════════════════════════════════════
  // ════════════════════════════════════════════════════════════════
  // GALLERY SECTION
  // ════════════════════════════════════════════════════════════════

  /// Ürünün kategorisine göre canlı bir zemin rengi döndürür (referans
  /// tasarımlardaki dolgun, tek renkli arka plan hissi için).
  Color _heroColor(final Product product) =>
      defaultCategoryMeta[product.category]?.color ?? AppColors.primary;

  Widget _buildGallerySection(
    final BuildContext context,
    final Product product, {
    required final double height,
    final bool isMobile = false,
  }) =>
      Column(
        children: [
          // Main Image Container — artık kategori rengine göre canlı bir
          // gradyan zemin üzerinde "yüzen" ürün görseli + dalgalı alt kenar.
          ClipPath(
            clipper: const WaveBottomClipper(),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _heroColor(product).withOpacity(0.85),
                    _heroColor(product),
                  ],
                ),
              ),
            child: Stack(
              children: [
                // Background Pattern
                _buildBackgroundPattern(),

                // Main Image
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(
                        context.responsive(mobile: 24, desktop: 48)),
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (final child, final animation) =>
                            FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.96, end: 1.0)
                                .animate(animation),
                            child: child,
                          ),
                        ),
                        child: ClipRRect(
                          key: ValueKey(_selectedImageIndex),
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            product.imagesUrl[_selectedImageIndex],
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Navigation Arrows
                if (product.imagesUrl.length > 1)
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildImageNavigationButton(
                          icon: Icons.chevron_left_rounded,
                          onTap: () {
                            setState(() {
                              _selectedImageIndex = (_selectedImageIndex -
                                      1 +
                                      product.imagesUrl.length) %
                                  product.imagesUrl.length;
                            });
                          },
                        ),
                        _buildImageNavigationButton(
                          icon: Icons.chevron_right_rounded,
                          onTap: () {
                            setState(() {
                              _selectedImageIndex = (_selectedImageIndex + 1) %
                                  product.imagesUrl.length;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                // Top Actions
                Positioned(
                  top: MediaQuery.of(context).padding.top > 0
                      ? MediaQuery.of(context).padding.top
                      : 10,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const GlassmorphismBackButton(
                          backgroundColor: AppColors.primary),
                      Row(
                        children: [
                          GlassmorphismIconButton(
                            icon: _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            onPressed: () =>
                                setState(() => _isFavorite = !_isFavorite),
                            backgroundColor: _isFavorite
                                ? AppColors.error
                                : AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          GlassmorphismIconButton(
                            icon: Icons.share_outlined,
                            onPressed: () {
                              FurnitureShareService.shareProduct(
                                  productId: product.id,
                                  productName: product.name);
                            },
                            backgroundColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Image Counter
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Text(
                      '${_selectedImageIndex + 1} / ${product.imagesUrl.length}',
                      style: TextStyle(
                        fontSize: context.captionSize,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                // Durum Rozeti (SIFIR / İKİNCİ EL) — artık ürünün gerçek
                // durumuna göre renk ve metin değiştiriyor.
                Positioned(
                  top: 20,
                  left: 20,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(product.isSpotProduct),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: product.isSpotProduct
                            ? const LinearGradient(colors: [
                                AppColors.accentDark,
                                AppColors.accent,
                              ])
                            : AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (product.isSpotProduct
                                    ? AppColors.accent
                                    : AppColors.primary)
                                .withOpacity(0.35),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            product.isSpotProduct
                                ? Icons.inventory_2_rounded
                                : Icons.new_releases_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            product.isSpotProduct
                                ? 'İKİNCİ EL · TEK PARÇA'
                                : 'SIFIR ÜRÜN',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (product.isSold)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2), // Hafif karartma
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: -0.2, // Hafif yan yatırılmış
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 20)
                              ],
                            ),
                            child: Text(
                              context.l10n.sold,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ),

          SizedBox(height: context.spacingLarge),

          // Thumbnail Gallery
          _buildThumbnailGallery(context, product),
        ],
      );

  Widget _buildThumbnailGallery(
          final BuildContext context, final Product product) =>
      Container(
        height: context.responsive(mobile: 80, desktop: 100),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: product.imagesUrl.length,
          separatorBuilder: (final _, final __) => const SizedBox(width: 12),
          itemBuilder: (final _, final i) => GestureDetector(
            onTap: () => setState(() => _selectedImageIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: context.responsive(mobile: 70, desktop: 80),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: i == _selectedImageIndex
                      ? AppColors.primary
                      : AppColors.border,
                  width: i == _selectedImageIndex ? 3 : 1.5,
                ),
                boxShadow: i == _selectedImageIndex
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.imagesUrl[i],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildImageNavigationButton(
          {required final IconData icon, required final VoidCallback onTap}) =>
      Padding(
        padding: const EdgeInsets.all(20),
        child: Material(
          color: AppColors.surface.withOpacity(0.95),
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
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(icon, color: AppColors.textPrimary, size: 32),
            ),
          ),
        ),
      );

  Widget _buildBackgroundPattern() => Opacity(
        opacity: 0.02,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=1600&q=80',
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.modulate,
              ),
            ),
          ),
        ),
      );

  // ════════════════════════════════════════════════════════════════
  // INFO SECTION (STICKY ON DESKTOP)
  // ════════════════════════════════════════════════════════════════

  Widget _buildStickyInfoSection(
          final BuildContext context, final Product product) =>
      SingleChildScrollView(child: _buildProductInfo(context, product));

  Widget _buildProductInfo(final BuildContext context, final Product product,
          {final bool isMobile = false}) =>
      FadeTransition(
        opacity: _entranceFade,
        child: SlideTransition(
          position: _entranceSlide,
          child: Container(
        padding: EdgeInsets.all(context.responsive(mobile: 24, desktop: 40)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.05),
              blurRadius: 40,
              spreadRadius: 5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                product.category.label(context),
                style: TextStyle(
                  fontSize: context.captionSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1.5,
                ),
              ),
            ),

            SizedBox(height: context.spacing),

            // Product Title
            Text(
              product.name,
              style: TextStyle(
                fontSize: context.responsive(mobile: 28, desktop: 42),
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                height: 1.1,
                letterSpacing: -0.5,
              ),
            ),

            SizedBox(height: context.spacing),

            // Rating & Reviews
            Row(
              children: [
                ...List.generate(
                  5,
                  (final i) => Icon(
                    i < 4 ? Icons.star : Icons.star_border,
                    color: AppColors.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '4.8',
                  style: TextStyle(
                    fontSize: context.bodySize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(127 değerlendirme)',
                  style: TextStyle(
                    fontSize: context.captionSize,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            SizedBox(height: context.spacingLarge),

            // Price Section
            Container(
              padding: EdgeInsets.symmetric(
                vertical: context.spacing,
                horizontal: context.spacingLarge,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.3),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.price.toUpperCase(),
                        style: TextStyle(
                          fontSize: context.captionSize,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₺',
                            style: TextStyle(
                              fontSize:
                                  context.responsive(mobile: 20, desktop: 24),
                              fontWeight: FontWeight.w300,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          CountUpOnVisible(
                            targetValue: product.price,
                            decimalDigits: 0,
                            duration: const Duration(milliseconds: 900),
                            style: TextStyle(
                              fontSize:
                                  context.responsive(mobile: 48, desktop: 64),
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              height: 0.9,
                              letterSpacing: -2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: AppColors.success.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.trending_down,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '%15',
                          style: TextStyle(
                            fontSize: context.bodySize,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.spacingLarge * 1.5),

            // Renk seçenekleri (sıfır ürün) / Tek parça rozeti (ikinci el)
            ProductColorSection(product: product),

            SizedBox(height: context.spacingLarge * 1.5),

            // Description
            _buildDescriptionSection(context, product),

            SizedBox(height: context.spacingLarge * 2),

            // Action Buttons
            _buildActionButtons(context, product, isMobile),

            SizedBox(height: context.spacingLarge * 2),

            // Product Details Grid
            _buildDetailsGrid(context, product),

            SizedBox(height: context.spacingLarge * 2),

            // Seller Info
            _buildSellerInfo(context),
          ],
        ),
      ),
        ),
      );

  Widget _buildDescriptionSection(
      final BuildContext context, final Product product) {
    final shortDesc = product.desc.length > 200
        ? '${product.desc.substring(0, 200)}...'
        : product.desc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              context.l10n.explanation,
              style: TextStyle(
                fontSize: context.bodySize,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AnimatedCrossFade(
          firstChild: Text(
            shortDesc,
            style: TextStyle(
              fontSize: context.bodySize,
              height: 1.8,
              color: AppColors.textPrimary.withOpacity(0.8),
            ),
          ),
          secondChild: Text(
            product.desc,
            style: TextStyle(
              fontSize: context.bodySize,
              height: 1.8,
              color: AppColors.textPrimary.withOpacity(0.8),
            ),
          ),
          crossFadeState: _showMoreDescription
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        if (product.desc.length > 200) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () =>
                setState(() => _showMoreDescription = !_showMoreDescription),
            icon: Icon(
              _showMoreDescription ? Icons.expand_less : Icons.expand_more,
              color: AppColors.primary,
              size: 20,
            ),
            label: Text(
              _showMoreDescription ? 'DAHA AZ GÖSTER' : 'DEVAMINI OKU',
              style: TextStyle(
                fontSize: context.captionSize,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(
      final BuildContext context, final Product product, final bool isMobile) {
    if (product.isSold) return _buildSoldBottomNotification(context);

    void contactWhatsApp() => FurnitureShareService.contactAboutProduct(
          productId: product.id,
          productName: product.name,
          price: product.price,
        );

    void callPhone() => SaglamSpotCommunication.makeCall();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Eğer genişlik 500px'den fazlaysa butonları yan yana diz (Tablet/Desktop)
        if (constraints.maxWidth > 500) {
          return Row(
            children: [
              Expanded(
                  child: _buildPrimaryButton(context,
                      label: 'WHATSAPP\'TAN YAZ',
                      icon: Icons.chat_bubble_rounded,
                      onTap: contactWhatsApp)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildSecondaryButton(context,
                      label: 'ARA', icon: Icons.call_rounded, onTap: callPhone)),
            ],
          );
        }

        // Mobilde alt alta diz (Zaten kaydırılabilir alan içindeyiz)
        return Column(
          children: [
            _buildPrimaryButton(context,
                label: 'WHATSAPP\'TAN YAZ',
                icon: Icons.chat_bubble_rounded,
                onTap: contactWhatsApp),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildSecondaryButton(context,
                        label: 'TELEFON ET',
                        icon: Icons.call_rounded,
                        onTap: callPhone)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildSecondaryButton(context,
                        label: 'PAYLAŞ',
                        icon: Icons.share_rounded,
                        onTap: () => FurnitureShareService.shareProduct(
                            productId: product.id,
                            productName: product.name,
                            price: product.price.toStringAsFixed(0)))),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrimaryButton(final BuildContext context,
      {required final String label,
      required final IconData icon,
      required final VoidCallback onTap}) {
    return Container(
      // Küçük ekranlarda 50px, büyük ekranlarda 60px
      height: context.responsive(mobile: 50.0, tablet: 56.0, desktop: 60.0),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon,
                    color: Colors.white,
                    size: context.responsive(mobile: 18.0, desktop: 24.0)),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: context.responsive(mobile: 13.0, desktop: 16.0),
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(final BuildContext context,
          {required final String label,
          required final IconData icon,
          required final VoidCallback onTap}) =>
      Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.textPrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: context.captionSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildDetailsGrid(final BuildContext context, final Product product) {
    final details = [
      {
        'icon': Icons.category_rounded,
        'label': 'Kategori',
        'value': product.category.label(context),
        'color': AppColors.primary
      },
      {
        'icon': Icons.verified_outlined,
        'label': 'Durum',
        'value': product.isSpotProduct ? 'İkinci El' : 'Sıfır',
        'color': AppColors.success
      },
      {
        'icon': Icons.local_shipping_outlined,
        'label': 'Teslimat',
        'value': '1-2 Gün',
        'color': AppColors.info
      },
      {
        'icon': Icons.location_on_outlined,
        'label': 'Konum',
        'value': 'İstanbul',
        'color': AppColors.accent
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Ekran genişliğine göre sütun sayısını belirliyoruz
        final int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            // Sabit yükseklik vererek taşmayı engelliyoruz
            mainAxisExtent:
                context.responsive(mobile: 75.0, tablet: 85.0, desktop: 90.0),
          ),
          itemCount: details.length,
          itemBuilder: (final context, final index) {
            final detail = details[index];
            final Animation<double> staggered = CurvedAnimation(
              parent: _entranceController,
              curve: Interval(
                (index * 0.1).clamp(0.0, 0.6),
                1.0,
                curve: Curves.easeOut,
              ),
            );

            return AnimatedBuilder(
              animation: staggered,
              builder: (final context, final child) => Opacity(
                opacity: staggered.value,
                child: Transform.translate(
                  offset: Offset(0, (1 - staggered.value) * 12),
                  child: child,
                ),
              ),
              child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(
                    detail['icon'] as IconData,
                    size: context.responsive(mobile: 18.0, desktop: 22.0),
                    color: detail['color'] as Color,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          detail['label'] as String,
                          style: TextStyle(
                            fontSize:
                                context.responsive(mobile: 10.0, desktop: 12.0),
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          detail['value'] as String,
                          style: TextStyle(
                            fontSize:
                                context.responsive(mobile: 11.0, desktop: 14.0),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSellerInfo(final BuildContext context) => Container(
        padding: EdgeInsets.all(context.spacing),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset('assets/images/saglam_spot_logo.png')),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sağlam Spot',
                    style: TextStyle(
                      fontSize: context.bodySize,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.verified,
                          size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(
                        'Onaylı Satıcı',
                        style: TextStyle(
                          fontSize: context.captionSize,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => NavigationHandler.goToAbout(context),
              icon: const Icon(Icons.chevron_right),
              color: AppColors.textPrimary,
            ),
          ],
        ),
      );

  // ════════════════════════════════════════════════════════════════
  // TAB SECTION (Details, Shipping, Reviews)
  // ════════════════════════════════════════════════════════════════

  Widget _buildTabSection(final BuildContext context, final Product product) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: context.sectionPadding,
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                // ... styling ...
                tabs: const [
                  Tab(text: 'DETAYLAR'),
                  Tab(text: 'TESLİMAT'),
                  Tab(text: 'DEĞERLENDİRMELER'),
                ],
              ),
              // SABİT 300 YERİNE RESPONSIVE YÜKSEKLİK
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                // Mobilde içerik taşmaması için daha esnek bir alan veriyoruz
                height: context.responsive(
                    mobile: 350.0, tablet: 400.0, desktop: 500.0),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDetailsTab(context, product),
                    _buildShippingTab(context),
                    _buildReviewsTab(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildDetailsTab(final BuildContext context, final Product product) =>
      Container(
        margin: const EdgeInsets.only(top: 24),
        padding: EdgeInsets.all(context.spacingLarge),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: SingleChildScrollView(
          child: Text(
            product.desc,
            style: TextStyle(
              fontSize: context.bodySize,
              height: 1.8,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      );

  Widget _buildShippingTab(final BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 24),
        child: ListView(
          children: [
            _buildInfoTile(
              icon: Icons.local_shipping_outlined,
              title: 'Ücretsiz Kargo',
              subtitle: 'Maalesef Yakın Çevrelerimize',
            ),
            _buildInfoTile(
              icon: Icons.access_time,
              title: 'Hızlı Teslimat',
              subtitle: '1-2 iş günü içinde',
            ),
            _buildInfoTile(
              icon: Icons.shield_outlined,
              title: '',
              subtitle: '',
            ),
          ],
        ),
      );

  Widget _buildReviewsTab(final BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 24),
        child: Center(
          child: Text(
            'Henüz değerlendirme yok',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: context.bodySize,
            ),
          ),
        ),
      );

  Widget _buildInfoTile(
          {required final IconData icon,
          required final String title,
          required final String subtitle}) =>
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  // ════════════════════════════════════════════════════════════════
  // FEATURES SECTION
  // ════════════════════════════════════════════════════════════════

  Widget _buildFeatures(final BuildContext context) => SliverToBoxAdapter(
        child: Padding(
          padding: context.sectionPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ÖZELLİKLER',
                style: TextStyle(
                  fontSize: context.h3Size,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: context.spacingLarge),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: context.responsive(mobile: 2, desktop: 4),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildFeatureCard(
                    icon: Icons.verified_user_outlined,
                    title: 'Garantimiz Yoktur',
                    subtitle: 'X',
                  ),
                  _buildFeatureCard(
                    icon: Icons.settings_outlined,
                    title: 'Montaj',
                    subtitle: 'Ücretsiz',
                  ),
                  _buildFeatureCard(
                    icon: Icons.swap_horiz_outlined,
                    title: 'İade Yoktur',
                    subtitle: 'X',
                  ),
                  _buildFeatureCard(
                    icon: Icons.support_agent_outlined,
                    title: 'Destek',
                    subtitle: '16/6',
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildFeatureCard({
    required final IconData icon,
    required final String title,
    required final String subtitle,
  }) =>
      Container(
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
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );

  // ════════════════════════════════════════════════════════════════
  // REVIEWS SECTION
  // ════════════════════════════════════════════════════════════════

  Widget _buildReviews(final BuildContext context) => SliverToBoxAdapter(
        child: Padding(
          padding: context.sectionPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MÜŞTERİ GÖRÜŞLERİ',
                    style: TextStyle(
                      fontSize: context.h3Size,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.spacingLarge),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (final context, final index) =>
                      _buildReviewCard(context),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildReviewCard(final BuildContext context) => Container(
        width: context.responsive(mobile: 280, desktop: 350),
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'AY',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ayşe Y.',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (final i) => const Icon(
                            Icons.star,
                            color: AppColors.accent,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Ürün çok kaliteli ve tam beklemde gibi geldi. Montajı da çok kolay oldu. Teşekkürler!',
              style: TextStyle(
                fontSize: context.captionSize,
                height: 1.6,
                color: AppColors.textPrimary.withOpacity(0.8),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              '2 gün önce',
              style: TextStyle(
                fontSize: context.captionSize,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );

  // ════════════════════════════════════════════════════════════════
  // SIMILAR PRODUCTS
  // ════════════════════════════════════════════════════════════════

  Widget _buildSimilarProducts(
          final BuildContext context, final List<Product> allProducts) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: context.sectionPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BENZER ÜRÜNLER',
                style: TextStyle(
                  fontSize: context.h3Size,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: context.spacingLarge),
              SizedBox(
                height: 300,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: allProducts.length,
                  separatorBuilder: (final _, final __) =>
                      const SizedBox(width: 16),
                  itemBuilder: (final context, final index) =>
                      _buildSimilarProductCard(context, allProducts[index]),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSimilarProductCard(
      final BuildContext context, final Product product) {
    return GestureDetector(
      onTap: () {
        final String slug = product.name.toSlug();

        NavigationHandler.goToProduct(
          context: context,
          productId: product.id,
          productSlug: slug,
        );
      },
      child: Container(
        width: context.responsive(mobile: 180, desktop: 220),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16))),
              child: product.imagesUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        product.imagesUrl.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : const Icon(Icons.image_not_supported),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: context.bodySize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₺${product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: context.bodySize,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
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

  // ════════════════════════════════════════════════════════════════
  // MOBILE BOTTOM BAR
  // ════════════════════════════════════════════════════════════════

  Widget _buildMobileBottomBar(
          final BuildContext context, final Product product) =>
      Container(
        // Padding'i responsive yapalım
        padding:
            EdgeInsets.all(context.responsive(mobile: 12.0, desktop: 20.0)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false, // Sadece alt tarafı koru
          child: product.isSold
              ? _buildSoldBottomNotification(context)
              : IntrinsicHeight(
                  // İçeriğin kendi boyuna göre daralmasını sağlar
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Toplam Fiyat',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                            FittedBox(
                              // Fiyat çok uzunsa küçültür, taşmayı önler
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '₺${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => FurnitureShareService
                                  .contactAboutProduct(
                                productId: product.id,
                                productName: product.name,
                                price: product.price,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.chat_bubble_rounded,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      'WHATSAPP\'TAN YAZ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );

  Widget _buildSoldBottomNotification(final BuildContext context) => Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.textSecondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16)),
        child: const Center(
          child: Text(
            'ÜRÜN STOKTA YOK (SATILDI)',
            style: TextStyle(
                fontWeight: FontWeight.w900, color: AppColors.textSecondary),
          ),
        ),
      );
}

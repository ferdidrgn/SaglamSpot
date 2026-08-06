import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/features/products/domain/entites/product.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/services/deeplink/deeplink_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/widgets/count_up_on_visible.dart';
import '../../../../core/widgets/gallery_section.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../data/models/category_meta.dart';
import '../providers/gallery_provider.dart';
import '../providers/product_filters_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_color_section.dart';

/// Ürün Detay Sayfası — sıfırdan, sade ve premium bir tasarım anlayışıyla
/// yeniden inşa edildi. Renkli/dalgalı zemin denemesi tamamen kaldırıldı;
/// bunun yerine temiz beyaz zemin, güçlü tipografi, yumuşak gölgeler ve
/// ince mikro-animasyonlarla "sakin ama şık" bir his hedeflendi.
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
  bool _showFullDescription = false;
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarSolid = false;

  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  )..forward();

  Animation<double> _stagger(final double startAt) => CurvedAnimation(
        parent: _entrance,
        curve: Interval(startAt.clamp(0.0, 0.9), 1.0, curve: Curves.easeOutCubic),
      );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final solid = _scrollController.offset > 180;
      if (solid != _isAppBarSolid) setState(() => _isAppBarSolid = solid);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(widget.productId));

    return productAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (final e, final _) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Text('Ürün yüklenemedi: $e',
              style: const TextStyle(color: AppColors.textPrimary)),
        ),
      ),
      data: (final product) {
        final similar = ref.watch(similarProductsProvider(
          category: product.category.name,
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
                  _buildAppBar(context, product),
                  SliverPadding(
                    padding: context.pagePadding,
                    sliver: SliverToBoxAdapter(
                      child: context.isMobile
                          ? _buildMobileBody(context, product)
                          : _buildDesktopBody(context, product),
                    ),
                  ),
                  if (similar.isNotEmpty)
                    SliverToBoxAdapter(
                        child: _buildSimilarSection(context, similar)),
                  SliverToBoxAdapter(
                      child:
                          SizedBox(height: context.isMobile ? 110 : 60)),
                ],
              ),
              if (context.isMobile) _buildStickyBar(context, product),
            ],
          ),
        );
      },
    );
  }

  // ════════════════════════════════════════════════════════════
  // APP BAR
  // ════════════════════════════════════════════════════════════

  Widget _buildAppBar(final BuildContext context, final Product product) =>
      SliverAppBar(
        pinned: true,
        backgroundColor: _isAppBarSolid ? AppColors.surface : Colors.transparent,
        elevation: _isAppBarSolid ? 1 : 0,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: _RoundIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => NavigationHandler.smartGoBack(context),
          ),
        ),
        title: AnimatedOpacity(
          opacity: _isAppBarSolid ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Text(product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: _RoundIconButton(
              icon: Icons.ios_share_rounded,
              onTap: () => FurnitureShareService.shareProduct(
                productId: product.id,
                productName: product.name,
                price: product.price.toStringAsFixed(0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            child: _RoundIconButton(
              icon: _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              iconColor: _isFavorite ? AppColors.error : AppColors.textPrimary,
              onTap: () => setState(() => _isFavorite = !_isFavorite),
            ),
          ),
        ],
      );

  // ════════════════════════════════════════════════════════════
  // LAYOUT — MOBİL / MASAÜSTÜ
  // ════════════════════════════════════════════════════════════

  Widget _buildMobileBody(final BuildContext context, final Product product) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGallery(context, product, height: context.hp(48)),
          SizedBox(height: context.spacingLarge),
          _buildInfo(context, product),
        ],
      );

  Widget _buildDesktopBody(final BuildContext context, final Product product) =>
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 55,
                child: _buildGallery(context, product, height: context.hp(70))),
            SizedBox(width: context.spacingLarge * 1.5),
            Expanded(flex: 45, child: _buildInfo(context, product)),
          ],
        ),
      );

  /// Görsele tıklanınca, tıklanan index'ten başlayarak sağa/sola kaydırılabilir
  /// tam ekran galeriyi açar (mevcut GalleryViewerDialog altyapısını kullanır).
  void _openFullscreenGallery(final BuildContext context, final Product product) {
    ref
        .read(galleryProvider(product.imagesUrl.length).notifier)
        .setCurrentIndex(_selectedImageIndex);
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.95),
      builder: (final _) => GalleryViewerDialog(
        images: product.imagesUrl,
        isMobile: context.isMobile,
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // GALERİ — sade, beyaz, yumuşak gölgeli. Renk/dalga denemesi kaldırıldı.
  // ════════════════════════════════════════════════════════════

  Widget _buildGallery(final BuildContext context, final Product product,
      {required final double height}) {
    return FadeTransition(
      opacity: _stagger(0),
      child: Column(
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withOpacity(0.06),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (final child, final anim) =>
                        FadeTransition(opacity: anim, child: child),
                    child: Padding(
                      key: ValueKey(_selectedImageIndex),
                      padding: EdgeInsets.all(
                          context.responsive(mobile: 28, desktop: 48)),
                      child: Hero(
                        tag: 'product-${product.id}',
                        child: GestureDetector(
                          onTap: () => _openFullscreenGallery(context, product),
                          child: Image.network(
                            product.imagesUrl[_selectedImageIndex],
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (final c, final e, final s) => const Icon(
                                Icons.chair_alt_rounded,
                                size: 64,
                                color: AppColors.textTertiary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Durum rozeti — sade, tek renk, ürünün gerçek durumunu yansıtır.
                Positioned(
                  top: 18,
                  left: 18,
                  child: _StatusPill(product: product),
                ),

                if (product.isSold)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Container(
                        color: Colors.black.withOpacity(0.45),
                        alignment: Alignment.center,
                        child: const Text('SATILDI',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2)),
                      ),
                    ),
                  ),

                // Sayaç
                if (product.imagesUrl.length > 1)
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_selectedImageIndex + 1}/${product.imagesUrl.length}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (product.imagesUrl.length > 1) ...[
            const SizedBox(height: 14),
            _buildThumbnails(product),
          ],
        ],
      ),
    );
  }

  Widget _buildThumbnails(final Product product) => SizedBox(
        height: 68,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: product.imagesUrl.length,
          separatorBuilder: (final _, final __) => const SizedBox(width: 10),
          itemBuilder: (final context, final index) {
            final selected = index == _selectedImageIndex;
            return GestureDetector(
              onTap: () => setState(() => _selectedImageIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? AppColors.accent : AppColors.border,
                    width: selected ? 2 : 1,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                              color: AppColors.accent.withOpacity(0.25),
                              blurRadius: 10)
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(product.imagesUrl[index],
                      fit: BoxFit.cover,
                      errorBuilder: (final c, final e, final s) =>
                          const SizedBox.shrink()),
                ),
              ),
            );
          },
        ),
      );

  // ════════════════════════════════════════════════════════════
  // BİLGİ KARTI
  // ════════════════════════════════════════════════════════════

  Widget _buildInfo(final BuildContext context, final Product product) {
    final meta = defaultCategoryMeta[product.category];

    return FadeTransition(
      opacity: _stagger(0.15),
      child: SlideTransition(
        position: Tween<Offset>(
                begin: const Offset(0, 0.03), end: Offset.zero)
            .animate(_stagger(0.15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori etiketi
            Row(
              children: [
                if (meta != null) ...[
                  Icon(meta.icon, size: 15, color: meta.color),
                  const SizedBox(width: 6),
                ],
                Text(
                  product.category.label(context).toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: meta?.color ?? AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Ürün adı
            Text(
              product.name,
              style: TextStyle(
                fontSize: context.responsive(mobile: 24, desktop: 30),
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            // Fiyat
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CountUpOnVisible(
                  targetValue: product.price,
                  decimalDigits: 0,
                  duration: const Duration(milliseconds: 700),
                  style: TextStyle(
                    fontSize: context.responsive(mobile: 34, desktop: 42),
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    letterSpacing: -1,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 6, left: 4),
                  child: Text('₺',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textSecondary)),
                ),
              ],
            ),
            SizedBox(height: context.spacingLarge),

            // Renk seçenekleri / tek parça bilgisi
            ProductColorSection(product: product),
            SizedBox(height: context.spacingLarge),

            // Açıklama
            _buildDescription(context, product),
            SizedBox(height: context.spacingLarge),

            // Özellik ızgarası
            _buildSpecs(context, product),
            SizedBox(height: context.spacingLarge),

            // Satıcı kartı
            _buildSellerCard(context),
            SizedBox(height: context.spacingLarge),

            // Masaüstünde aksiyon butonları burada (mobilde sabit alt bar var)
            if (!context.isMobile) _buildActionButtons(product),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(final BuildContext context, final Product product) {
    final isLong = product.desc.length > 140;
    final text = _showFullDescription || !isLong
        ? product.desc
        : '${product.desc.substring(0, 140)}…';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Açıklama',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 8),
        Text(text,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14, height: 1.55)),
        if (isLong)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: GestureDetector(
              onTap: () =>
                  setState(() => _showFullDescription = !_showFullDescription),
              child: Text(
                _showFullDescription ? 'Daha az göster' : 'Devamını oku',
                style: const TextStyle(
                    color: AppColors.accentDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 13),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSpecs(final BuildContext context, final Product product) {
    final specs = [
      (Icons.category_rounded, 'Kategori', product.category.label(context)),
      (
        product.isSpotProduct
            ? Icons.inventory_2_rounded
            : Icons.new_releases_rounded,
        'Durum',
        product.isSpotProduct ? 'İkinci El' : 'Sıfır Ürün',
      ),
      (Icons.local_shipping_rounded, 'Teslimat', '1-2 Gün İçinde'),
      (Icons.location_on_rounded, 'Konum', 'İçerenköy, İstanbul'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.6,
      ),
      itemCount: specs.length,
      itemBuilder: (final context, final index) {
        final (icon, label, value) = specs[index];
        return FadeTransition(
          opacity: _stagger(0.3 + index * 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 17, color: AppColors.onSecondary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              fontSize: 10.5, color: AppColors.textTertiary)),
                      Text(value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSellerCard(final BuildContext context) => GestureDetector(
        onTap: () => NavigationHandler.goToAbout(context),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.storefront_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text('Sağlam Spot',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 14)),
                        SizedBox(width: 4),
                        Icon(Icons.verified_rounded,
                            size: 14, color: AppColors.success),
                      ],
                    ),
                    Text('20 yıllık esnaf güvencesi · İçerenköy',
                        style: TextStyle(
                            fontSize: 11.5, color: AppColors.textTertiary)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textTertiary),
            ],
          ),
        ),
      );

  Widget _buildActionButtons(final Product product) {
    if (product.isSold) return const SizedBox.shrink();
    return Row(
      children: [
        Expanded(
          child: _PrimaryButton(
            label: "WhatsApp'tan Yaz",
            icon: Icons.chat_bubble_rounded,
            onTap: () => FurnitureShareService.contactAboutProduct(
              productId: product.id,
              productName: product.name,
              price: product.price,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _RoundIconButton(
          size: 52,
          icon: Icons.call_rounded,
          filled: true,
          onTap: SaglamSpotCommunication.makeCall,
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // BENZER ÜRÜNLER
  // ════════════════════════════════════════════════════════════

  Widget _buildSimilarSection(
      final BuildContext context, final List<Product> similar) {
    return Padding(
      padding: EdgeInsets.only(top: context.spacingLarge, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.pagePadding.left),
            child: const Text('Benzer Ürünler',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  EdgeInsets.symmetric(horizontal: context.pagePadding.left),
              itemCount: similar.length,
              separatorBuilder: (final _, final __) => const SizedBox(width: 14),
              itemBuilder: (final context, final index) =>
                  _SimilarProductCard(product: similar[index]),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // MOBİL SABİT ALT BAR
  // ════════════════════════════════════════════════════════════

  Widget _buildStickyBar(final BuildContext context, final Product product) {
    if (product.isSold) return const SizedBox.shrink();
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
            16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -6)),
          ],
        ),
        child: Row(
          children: [
            _RoundIconButton(
              size: 52,
              icon: Icons.call_rounded,
              filled: true,
              onTap: SaglamSpotCommunication.makeCall,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PrimaryButton(
                label: "WhatsApp'tan Yaz",
                icon: Icons.chat_bubble_rounded,
                onTap: () => FurnitureShareService.contactAboutProduct(
                  productId: product.id,
                  productName: product.name,
                  price: product.price,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// KÜÇÜK YARDIMCI WIDGET'LAR
// ══════════════════════════════════════════════════════════════

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final bool filled;
  final Color? iconColor;

  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.size = 40,
    this.filled = false,
    this.iconColor,
  });

  @override
  Widget build(final BuildContext context) => Material(
        color: filled ? AppColors.secondary : Colors.white,
        shape: const CircleBorder(),
        elevation: filled ? 0 : 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon,
                size: size * 0.42,
                color: iconColor ??
                    (filled ? AppColors.primary : AppColors.textPrimary)),
          ),
        ),
      );
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) => Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 52,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.5)),
              ],
            ),
          ),
        ),
      );
}

class _StatusPill extends StatelessWidget {
  final Product product;

  const _StatusPill({required this.product});

  @override
  Widget build(final BuildContext context) {
    final bool spot = product.isSpotProduct;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: (spot ? AppColors.accentDark : AppColors.success)
            .withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            spot ? Icons.inventory_2_rounded : Icons.new_releases_rounded,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 5),
          Text(
            spot ? 'İKİNCİ EL' : 'SIFIR ÜRÜN',
            style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.8),
          ),
        ],
      ),
    );
  }
}

class _SimilarProductCard extends StatelessWidget {
  final Product product;

  const _SimilarProductCard({required this.product});

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: () => NavigationHandler.goToProduct(
          context: context,
          productId: product.id,
          productSlug: product.name.toSlug(),
        ),
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  product.imagesUrl.first,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (final c, final e, final s) => Container(
                      height: 120,
                      color: AppColors.secondary,
                      child: const Icon(Icons.chair_alt_rounded)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('₺${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

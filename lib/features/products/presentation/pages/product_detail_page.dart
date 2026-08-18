import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/features/products/domain/entites/product.dart';
import '../../../../core/ads/widgets/platform_bottom_banner.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/services/deeplink/deeplink_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/widgets/count_up_on_visible.dart';
import '../../../../core/widgets/gallery_section.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../features/cart/presentation/providers/cart_provider.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../data/models/category_meta.dart';
import '../providers/favorites_provider.dart';
import '../providers/gallery_provider.dart';
import '../providers/product_filters_provider.dart';
import '../providers/product_provider.dart';
import '../providers/recently_viewed_provider.dart';
import '../widgets/product_color_section.dart';

/// Uygulama artık TEK bir marka paleti kullanıyor (teal/sage — eski sıcak
/// espresso/ahşap palet kaldırıldı, bkz. app_colors.dart). Bu yardımcı
/// jenerik bırakıldı (Color VEYA Gradient dönebilir) — mobile/web kolları
/// artık aynı değeri döndürse de çağrı yerlerini tek tek değiştirmemek
/// için korunuyor.
T _pc<T>(final BuildContext context, {required final T mobile, required final T web}) =>
    context.isMobile ? mobile : web;

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
  bool _showFullDescription = false;
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarSolid = false;
  String? _trackedProductId;

  // "360°" sürükle-çevir jesti — ÖNCEKİ SÜRÜM elle yazılmış bir sürükleme
  // eşiği + AnimatedSwitcher/FadeTransition kullanıyordu; hızlı sürüklemede
  // eşik art arda birden çok kez aşılıp üst üste binen fade'ler tetikliyor,
  // "eski fotoğrafı gösterip kayboluyor" gibi bozuk bir görüntü
  // oluşturuyordu. Artık gerçek bir PageView kullanıyoruz — Flutter'ın
  // kendi, parmakla birebir takip eden, bırakınca en yakın fotoğrafa
  // "snap" eden native kaydırma mekanizması; elle yazılmış eşik/animasyon
  // kodu tamamen kaldırıldı.
  late final PageController _galleryController =
      PageController(initialPage: _selectedImageIndex);
  bool _showRotateHint = true;

  // remove.bg ile üretilmiş, arka planı kaldırılmış "stüdyo" versiyon
  // varsa (studioImagesUrl), kullanıcı orijinal mağaza fotoğrafı ile
  // stüdyo versiyonu arasında geçiş yapabilir.
  bool _showStudioVersion = false;

  String? _studioUrlFor(final Product product, final int index) {
    if (index >= product.studioImagesUrl.length) return null;
    final url = product.studioImagesUrl[index];
    return url.isEmpty ? null : url;
  }

  String _effectiveImageUrl(final Product product, final int index) {
    if (_showStudioVersion) {
      final studio = _studioUrlFor(product, index);
      if (studio != null) return studio;
    }
    return product.imagesUrl[index];
  }

  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  )..forward();

  Animation<double> _stagger(final double startAt) => CurvedAnimation(
        parent: _entrance,
        curve: Interval(startAt.clamp(0.0, 0.9), 1.0, curve: Curves.easeOutCubic),
      );

  bool _inCart(final Product product) =>
      ref.watch(cartProvider).any((final i) => i.product.id == product.id);

  bool _isFavorite(final Product product) =>
      ref.watch(favoritesProvider).any((final p) => p.id == product.id);

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
    _galleryController.dispose();
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(widget.productId));

    return productAsync.when(
      loading: () => Scaffold(
        backgroundColor: _pc(context, mobile: AppColors.mobileBackground, web: AppColors.background),
        body: Center(
            child: CircularProgressIndicator(
                color: _pc(context, mobile: AppColors.mobilePrimary, web: AppColors.primary))),
      ),
      error: (final e, final _) => Scaffold(
        backgroundColor: _pc(context, mobile: AppColors.mobileBackground, web: AppColors.background),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Text(context.l10n.productLoadError('$e'),
              style: TextStyle(
                  color: _pc(context,
                      mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary))),
        ),
      ),
      data: (final product) {
        final similar = ref.watch(similarProductsProvider(
          category: product.category.name,
          currentProductId: product.id,
        ));

        if (_trackedProductId != product.id) {
          _trackedProductId = product.id;
          WidgetsBinding.instance.addPostFrameCallback(
              (final _) => ref.read(recentlyViewedProvider.notifier).track(product));
        }

        return Scaffold(
          backgroundColor: _pc(context, mobile: AppColors.mobileBackground, web: AppColors.background),
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
                    child: Padding(
                      padding: context.pagePadding.copyWith(
                          top: context.spacingLarge, bottom: 0),
                      child: const PlatformBottomBanner(),
                    ),
                  ),
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
        backgroundColor: _isAppBarSolid
            ? _pc(context, mobile: AppColors.mobileSurface, web: AppColors.surface)
            : Colors.transparent,
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
              style: TextStyle(
                  color: _pc(context,
                      mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary),
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
              icon: _isFavorite(product)
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              iconColor: _isFavorite(product)
                  ? AppColors.error
                  : _pc(context, mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary),
              onTap: () => ref.read(favoritesProvider.notifier).toggle(product),
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
              color: _pc(context, mobile: AppColors.mobileSurface, web: AppColors.surface),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: _pc(context, mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary)
                      .withOpacity(0.06),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Hero(
                    tag: 'product-${product.id}',
                    child: PageView.builder(
                      controller: _galleryController,
                      physics: product.imagesUrl.length > 1
                          ? const BouncingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      itemCount: product.imagesUrl.length,
                      onPageChanged: (final index) => setState(() {
                        _selectedImageIndex = index;
                        _showRotateHint = false;
                      }),
                      itemBuilder: (final context, final index) => Padding(
                        padding:
                            EdgeInsets.all(context.responsive(mobile: 28, desktop: 48)),
                        child: GestureDetector(
                          onTap: () => _openFullscreenGallery(context, product),
                          child: OptimizedCachedImage(
                            imageUrl: _effectiveImageUrl(product, index),
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                            borderRadius: 0,
                            errorBuilder: (final c, final u, final e) => Icon(
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
                        child: Text(context.l10n.sold,
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

                // "Mağaza / Stüdyo" geçişi — sadece bu index için remove.bg
                // ile üretilmiş bir stüdyo (arka plansız) versiyon varsa.
                if (_studioUrlFor(product, _selectedImageIndex) != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: _StudioToggle(
                      isStudio: _showStudioVersion,
                      onTap: () => setState(() => _showStudioVersion = !_showStudioVersion),
                    ),
                  ),

                // "Sürükleyerek çevirin" ipucu — sadece birden çok fotoğraf
                // varken ve kullanıcı henüz sürüklemediyse görünür.
                if (product.imagesUrl.length > 1)
                  Positioned(
                    top: 18,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _showRotateHint ? 1 : 0,
                        duration: const Duration(milliseconds: 350),
                        child: IgnorePointer(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.swipe_rounded,
                                    size: 15, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(context.l10n.dragToRotateHint,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700)),
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
              onTap: () {
                setState(() => _selectedImageIndex = index);
                _galleryController.animateToPage(index,
                    duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? _pc(context, mobile: AppColors.mobileAccent, web: AppColors.accent)
                        : _pc(context, mobile: AppColors.mobileBorder, web: AppColors.border),
                    width: selected ? 2 : 1,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                              color: _pc(context,
                                      mobile: AppColors.mobileAccent, web: AppColors.accent)
                                  .withOpacity(0.25),
                              blurRadius: 10)
                        ]
                      : null,
                ),
                child: OptimizedCachedImage(
                  imageUrl: product.imagesUrl[index],
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                  borderRadius: 14,
                  errorBuilder: (final c, final u, final e) => const SizedBox.shrink(),
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
                    color: meta?.color ??
                        _pc(context, mobile: AppColors.mobileTextSecondary, web: AppColors.textSecondary),
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
                color: _pc(context, mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary),
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
                    color: _pc(context, mobile: AppColors.mobilePrimary, web: AppColors.textPrimary),
                    letterSpacing: -1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 4),
                  child: Text('₺',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: _pc(context,
                              mobile: AppColors.mobilePrimary, web: AppColors.textSecondary))),
                ),
              ],
            ),
            SizedBox(height: context.spacingLarge),

            // Güven rozetleri + eklenme tarihi
            _buildTrustRow(context, product),
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

            // Nasıl satın alırım? (3 adımlık mini rehber)
            _buildHowToBuy(context),
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
        Text(context.l10n.productDescriptionTitle,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: _pc(context, mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary))),
        const SizedBox(height: 8),
        Text(text,
            style: TextStyle(
                color: _pc(context, mobile: AppColors.mobileTextSecondary, web: AppColors.textSecondary),
                fontSize: 14,
                height: 1.55)),
        if (isLong)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: GestureDetector(
              onTap: () =>
                  setState(() => _showFullDescription = !_showFullDescription),
              child: Text(
                _showFullDescription ? context.l10n.readLess : context.l10n.readMore,
                style: TextStyle(
                    color: _pc(context, mobile: AppColors.mobilePrimary, web: AppColors.accentDark),
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
      (Icons.category_rounded, context.l10n.category, product.category.label(context)),
      (
        product.isSpotProduct
            ? Icons.inventory_2_rounded
            : Icons.new_releases_rounded,
        context.l10n.condition,
        product.isSpotProduct ? context.l10n.conditionUsed : context.l10n.productSpecConditionNew,
      ),
      (Icons.local_shipping_rounded, context.l10n.specDelivery, context.l10n.specDeliveryValue),
      (Icons.location_on_rounded, context.l10n.specLocation, context.l10n.productLocationValue),
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
              color: _pc(context, mobile: AppColors.mobileSurface, web: AppColors.surface),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _pc(context, mobile: AppColors.mobileBorder, web: AppColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _pc(context, mobile: AppColors.mobileCardBg, web: AppColors.secondary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon,
                      size: 17,
                      color: _pc(context, mobile: AppColors.mobilePrimary, web: AppColors.onSecondary)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label,
                          style: TextStyle(
                              fontSize: 10.5,
                              color: _pc(context,
                                  mobile: AppColors.mobileTextTertiary, web: AppColors.textTertiary))),
                      Text(value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: _pc(context,
                                  mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary))),
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

  // ════════════════════════════════════════════════════════════
  // GÜVEN ROZETLERİ + EKLENME TARİHİ
  // ════════════════════════════════════════════════════════════

  String? _listedLabel(final BuildContext context, final Product product) {
    final parsed = DateTime.tryParse(product.createdAt);
    if (parsed == null) return null;
    final days = DateTime.now().difference(parsed).inDays;
    if (days <= 0) return context.l10n.listedToday;
    if (days < 7) return context.l10n.listedDaysAgo(days);
    return context.l10n.listedWeeksAgo((days / 7).floor());
  }

  Widget _buildTrustRow(final BuildContext context, final Product product) {
    final listed = _listedLabel(context, product);
    return FadeTransition(
      opacity: _stagger(0.22),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _TrustChip(
              icon: Icons.verified_rounded,
              label: context.l10n.productTrustBadgeVerified),
          _TrustChip(
              icon: Icons.chat_bubble_rounded,
              label: context.l10n.productTrustBadgeNegotiate),
          _TrustChip(
              icon: Icons.local_shipping_rounded,
              label: context.l10n.productTrustBadgeDelivery),
          if (listed != null)
            _TrustChip(icon: Icons.schedule_rounded, label: listed, subtle: true),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // NASIL SATIN ALIRIM? — mini rehber
  // ════════════════════════════════════════════════════════════

  Widget _buildHowToBuy(final BuildContext context) {
    final steps = [
      (Icons.chat_bubble_rounded, context.l10n.howToBuyStep1Title, context.l10n.howToBuyStep1Desc),
      (Icons.handshake_rounded, context.l10n.howToBuyStep2Title, context.l10n.howToBuyStep2Desc),
      (Icons.local_shipping_rounded, context.l10n.howToBuyStep3Title, context.l10n.howToBuyStep3Desc),
    ];

    return FadeTransition(
      opacity: _stagger(0.4),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _pc(context, mobile: AppColors.mobileCardBg, web: AppColors.secondary),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.howToBuyTitle,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: _pc(context, mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary))),
            const SizedBox(height: 14),
            for (int i = 0; i < steps.length; i++) ...[
              if (i != 0) const SizedBox(height: 12),
              _HowToBuyStep(
                  index: i + 1,
                  icon: steps[i].$1,
                  title: steps[i].$2,
                  desc: steps[i].$3),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSellerCard(final BuildContext context) => GestureDetector(
        onTap: () => NavigationHandler.goToAbout(context),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _pc(context, mobile: AppColors.mobileSurface, web: AppColors.surface),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _pc(context, mobile: AppColors.mobileBorder, web: AppColors.border)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: _pc(context,
                      mobile: AppColors.mobilePrimaryGradient, web: AppColors.primaryGradient),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.storefront_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(context.l10n.loginBrand,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: _pc(context,
                                    mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary))),
                        const SizedBox(width: 4),
                        Icon(Icons.verified_rounded,
                            size: 14, color: AppColors.success),
                      ],
                    ),
                    Text(context.l10n.sellerTrustLine,
                        style: TextStyle(
                            fontSize: 11.5,
                            color: _pc(context,
                                mobile: AppColors.mobileTextTertiary, web: AppColors.textTertiary))),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: _pc(context, mobile: AppColors.mobileTextTertiary, web: AppColors.textTertiary)),
            ],
          ),
        ),
      );

  /// Sepete ekleme ve WhatsApp iletişimi İKİ AYRI, eşit ağırlıklı buton —
  /// biri diğerinin küçük bir ikona indirgenmiş hali DEĞİL. Ara (telefon)
  /// daha düşük öncelikli bir ikon düğmesi olarak kalıyor; favori artık
  /// burada değil, üst çubuktaki kalp ikonunda (bkz. _buildAppBar) ve
  /// SEPETTEN tamamen bağımsız (favoritesProvider).
  Widget _buildActionButtons(final Product product) {
    if (product.isSold) return const SizedBox.shrink();
    final bool inCart = _inCart(product);
    return Row(
      children: [
        _RoundIconButton(
          size: 52,
          icon: Icons.call_rounded,
          filled: true,
          onTap: SaglamSpotCommunication.makeCall,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _HalfActionButton(
            label: inCart ? context.l10n.addedToCartMessage : context.l10n.addToCartCta,
            icon: inCart ? Icons.check_rounded : Icons.shopping_bag_rounded,
            filled: true,
            onTap: () => ref.read(cartProvider.notifier).toggle(product),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _HalfActionButton(
            label: context.l10n.whatsappCta,
            icon: Icons.chat_bubble_rounded,
            filled: false,
            onTap: () => FurnitureShareService.contactAboutProduct(
              productId: product.id,
              productName: product.name,
              price: product.price,
            ),
          ),
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
            child: Text(context.l10n.similarProducts,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: _pc(context, mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary))),
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
          color: _pc(context, mobile: AppColors.mobileSurface, web: AppColors.surface),
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
            const SizedBox(width: 10),
            Expanded(
              child: _HalfActionButton(
                label: _inCart(product)
                    ? context.l10n.addedToCartMessage
                    : context.l10n.addToCartCta,
                icon: _inCart(product) ? Icons.check_rounded : Icons.shopping_bag_rounded,
                filled: true,
                onTap: () => ref.read(cartProvider.notifier).toggle(product),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _HalfActionButton(
                label: context.l10n.whatsappCta,
                icon: Icons.chat_bubble_rounded,
                filled: false,
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
        color: filled
            ? _pc(context, mobile: AppColors.mobileCardBg, web: AppColors.secondary)
            : _pc(context, mobile: AppColors.mobileSurface, web: AppColors.surface),
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
                    (filled
                        ? _pc(context, mobile: AppColors.mobilePrimary, web: AppColors.primary)
                        : _pc(context, mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary))),
          ),
        ),
      );
}

/// Sepete Ekle ve WhatsApp'ı EŞİT AĞIRLIKLI iki yarım-genişlik butona
/// ayırır — biri diğerinin gölgesinde kalmasın diye. `filled == true`
/// dolgu (birincil, sepet), `false` ise sadece kenarlıklı (ikincil,
/// WhatsApp) çizilir.
class _HalfActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _HalfActionButton(
      {required this.label, required this.icon, required this.onTap, required this.filled});

  @override
  Widget build(final BuildContext context) {
    final Color accent = _pc(context, mobile: AppColors.mobilePrimary, web: AppColors.primary);
    final Color fg = filled ? Colors.white : accent;

    return Material(
      color: filled ? accent : Colors.transparent,
      shape: StadiumBorder(side: filled ? BorderSide.none : BorderSide(color: accent, width: 1.6)),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fg, size: 17),
              const SizedBox(width: 7),
              Flexible(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 13.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool subtle;

  const _TrustChip({required this.icon, required this.label, this.subtle = false});

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: subtle
              ? Colors.transparent
              : _pc(context, mobile: AppColors.mobileCardBg, web: AppColors.secondary),
          borderRadius: BorderRadius.circular(30),
          border: subtle
              ? Border.all(color: _pc(context, mobile: AppColors.mobileBorder, web: AppColors.border))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 13,
                color: subtle
                    ? _pc(context, mobile: AppColors.mobileTextTertiary, web: AppColors.textTertiary)
                    : _pc(context, mobile: AppColors.mobilePrimary, web: AppColors.primary)),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: subtle
                        ? _pc(context, mobile: AppColors.mobileTextTertiary, web: AppColors.textTertiary)
                        : _pc(context, mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary))),
          ],
        ),
      );
}

class _HowToBuyStep extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String desc;

  const _HowToBuyStep(
      {required this.index, required this.icon, required this.title, required this.desc});

  @override
  Widget build(final BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: _pc(context, mobile: AppColors.mobileAccentGradient, web: AppColors.accentGradient),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$index. $title',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                        color: _pc(context,
                            mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary))),
                const SizedBox(height: 2),
                Text(desc,
                    style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: _pc(context,
                            mobile: AppColors.mobileTextSecondary, web: AppColors.textSecondary))),
              ],
            ),
          ),
        ],
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
        color: (spot
                ? _pc(context, mobile: AppColors.mobileAccentDark, web: AppColors.accentDark)
                : AppColors.success)
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
            spot ? context.l10n.usedProductBadge : context.l10n.newProductBadge,
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

/// "Mağaza" (orijinal) / "Stüdyo" (remove.bg, arka plansız) görsel geçişi.
class _StudioToggle extends StatelessWidget {
  final bool isStudio;
  final VoidCallback onTap;

  const _StudioToggle({required this.isStudio, required this.onTap});

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome_rounded, size: 13, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                isStudio ? context.l10n.studioPhotoLabel : context.l10n.storePhotoLabel,
                style: const TextStyle(
                    color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      );
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
            color: _pc(context, mobile: AppColors.mobileSurface, web: AppColors.surface),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _pc(context, mobile: AppColors.mobileBorder, web: AppColors.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: OptimizedCachedImage(
                  imageUrl: product.imagesUrl.first,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                  errorBuilder: (final c, final u, final e) => Container(
                      height: 120,
                      color: _pc(context, mobile: AppColors.mobileCardBg, web: AppColors.secondary),
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
                        style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: _pc(context,
                                mobile: AppColors.mobileTextPrimary, web: AppColors.textPrimary))),
                    const SizedBox(height: 4),
                    Text('₺${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: _pc(context, mobile: AppColors.mobilePrimary, web: AppColors.textPrimary))),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

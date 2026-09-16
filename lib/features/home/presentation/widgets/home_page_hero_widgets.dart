import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/design_system/glass_surface.dart';
import '../../../../core/widgets/design_system/hud_corner_frame.dart';
import '../../../../core/widgets/design_system/kinetic_beam_skeleton.dart';
import '../../../../core/widgets/design_system/tactile_press.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../products/domain/entites/product.dart';

/// Ana sayfanın ("HomePage", web) hero banner'ı ve onun yüzen ürün
/// vitrini — eskiden home_page_web.dart'ın sonunda duruyordu, okunabilirlik
/// için ayrı dosyaya taşındı. Davranış/görünüm AYNI kaldı.

/// Tek parça hero banner arka planı: sayfalanabilir (PageView) fotoğraflar,
/// üzerinde sol/sağ ok düğmeleri ve sayfa noktaları — referans tasarımdaki
/// gibi elle de otomatik de gezilebilir. Sağ altta gerçek bir ürünü tanıtan
/// yüzen kart durur; satın alma değil, ürün detayına yönlendirir.
class HeroBanner extends StatefulWidget {
  final List<String> images;
  final List<Product> featuredPool;

  const HeroBanner({required this.images, required this.featuredPool});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  final PageController _pageController = PageController();
  int _page = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (final _) {
      if (mounted) _goTo((_page + 1) % widget.images.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(final int index) {
    setState(() => _page = index);
    if (_pageController.hasClients) {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(final BuildContext context) {
    // Arka plan sayfalandıkça başlık/CTA de birlikte akar: Sıfır ->
    // İkinci El -> Keşfet — sabit tek mesaj yerine dinamik bir döngü.
    final slides = <_HeroSlideContent>[
      _HeroSlideContent(
        eyebrow: context.l10n.newSeason,
        title: context.l10n.heroTitle,
        subtitle: context.l10n.featureArtisan,
      ),
      _HeroSlideContent(
        eyebrow: context.l10n.heroSlide2Eyebrow,
        title: context.l10n.heroSlide2Title,
        subtitle: context.l10n.heroSlide2Subtitle,
      ),
      _HeroSlideContent(
        eyebrow: context.l10n.showcaseEyebrow,
        title: context.l10n.heroSlide3Title,
        subtitle: context.l10n.byRoomSub,
      ),
    ];
    final slide = slides[_page % slides.length];

    // Yüzen kartları yalnızca gerçekten sığacak kadar genişlik varsa
    // göster — dar tabletlerde/laptop pencerelerinde başlık metniyle
    // çakışmalarını (üst üste binmesini) önler. Not: LayoutBuilder
    // bilerek kullanılmadı — bu widget bazı ata bağlamlarda intrinsic
    // boyut sorgusuna maruz kaldığında "LayoutBuilder does not support
    // returning intrinsic dimensions" hatasını fırlatıyordu ve tüm
    // sayfayı boş/kırık bırakıyordu. Ekran genişliği burada yerel
    // constraint genişliğine zaten çok yakın (maksimum genişlikli
    // konteynerde), bu yüzden güvenli bir vekil.
    final showSideCards =
        context.screenWidth >= 1100 && widget.featuredPool.isNotEmpty;
    return HudCornerFrame(
      armLength: 26,
      inset: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.borderRadius(1.2)),
        child: _buildHeroContent(context, slide, showSideCards),
      ),
    );
  }

  Widget _buildHeroContent(final BuildContext context,
      final _HeroSlideContent slide, final bool showSideCards) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.images.length,
          onPageChanged: (final i) => setState(() => _page = i),
          itemBuilder: (final context, final i) => Image.network(
            widget.images[i],
            fit: BoxFit.cover,
            errorBuilder: (final c, final e, final s) =>
                Container(color: AppColors.secondary),
            loadingBuilder: (final c, final child, final progress) =>
                progress == null
                    ? child
                    : const KineticBeamSkeleton(borderRadius: 0),
          ),
        ),
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primaryVariant.withOpacity(0.78),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.68],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(context.responsive(mobile: 22, desktop: 56)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                child: Container(
                  key: ValueKey('eyebrow-$_page'),
                  padding: EdgeInsets.symmetric(
                      horizontal: context.responsive(mobile: 10, desktop: 14),
                      vertical: context.responsive(mobile: 5, desktop: 7)),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.accentLight.withOpacity(0.7)),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(slide.eyebrow,
                      style: AppTextStyles.microLabel(
                          color: AppColors.accentLight,
                          letterSpacing: context.isMobile ? 2 : 3,
                          fontSize:
                              context.responsive(mobile: 9, desktop: 12))),
                ),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: context.responsive(
                        mobile: 320, tablet: 380, desktop: 480)),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  child: Text(slide.title,
                      key: ValueKey('title-$_page'),
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: context.heroSize * 0.72,
                          height: 1.12)),
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: context.responsive(mobile: 280, desktop: 420)),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  child: Text(slide.subtitle,
                      key: ValueKey('subtitle-$_page'),
                      style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white.withOpacity(0.78),
                          fontSize:
                              context.responsive(mobile: 13, desktop: 16))),
                ),
              ),
              SizedBox(height: context.responsive(mobile: 18, desktop: 26)),
              // Üç eylem her zaman birlikte, yan yana duruyor — slayta
              // göre tek bir dinamik CTA yerine, referans tasarımdaki
              // şık "üç buton" şeridinin karşılığı. Wrap kullanılıyor ki
              // dar ekranlarda taşma yerine ikinci satıra sarsın.
              Wrap(
                spacing: context.responsive(mobile: 8, desktop: 12),
                runSpacing: 10,
                children: [
                  _HeroPillButton(
                    icon: Icons.new_releases_rounded,
                    label: context.l10n.conditionNew,
                    variant: _HeroPillVariant.solidLight,
                    onTap: () => NavigationHandler.goToNewProducts(context),
                  ),
                  _HeroPillButton(
                    icon: Icons.history_rounded,
                    label: context.l10n.conditionUsed,
                    variant: _HeroPillVariant.solidAccent,
                    onTap: () => NavigationHandler.goToSpotProducts(context),
                  ),
                  _HeroPillButton(
                    icon: Icons.explore_outlined,
                    label: context.l10n.exploreButton,
                    variant: _HeroPillVariant.outline,
                    onTap: () => NavigationHandler.goToSearch(context),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.images.length > 1) ...[
          Positioned(
            left: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: _HeroArrowButton(
                icon: Icons.chevron_left_rounded,
                onTap: () => _goTo(
                    (_page - 1 + widget.images.length) % widget.images.length),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: _HeroArrowButton(
                icon: Icons.chevron_right_rounded,
                onTap: () => _goTo((_page + 1) % widget.images.length),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (final i) {
                final active = i == _page;
                return GestureDetector(
                  onTap: () => _goTo(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 18 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color:
                          active ? Colors.white : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
        if (showSideCards)
          Positioned(
            right: 88,
            top: 90,
            child: _FloatingFeaturedStack(products: widget.featuredPool),
          ),
      ],
    );
  }
}

/// Hero'nun bir sayfasına ait metin içeriği — arka plan görseliyle birlikte
/// döner. Eylem butonları artık sabit üç buton olduğu için burada CTA yok.
class _HeroSlideContent {
  final String eyebrow;
  final String title;
  final String subtitle;

  const _HeroSlideContent({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });
}

enum _HeroPillVariant { solidLight, solidAccent, outline }

/// Hero'daki üç eylem butonundan biri — referans tasarımdaki şık "yan yana
/// üç buton" şeridinin karşılığı. Başlık fontuyla (Fraunces) aynı ailede,
/// gövde metninden ayrışan bir tipografi kullanır; her varyantın kendi
/// rengi vardır.
class _HeroPillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final _HeroPillVariant variant;
  final VoidCallback onTap;

  const _HeroPillButton({
    required this.icon,
    required this.label,
    required this.variant,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    late final Color background;
    late final Color foreground;
    late final BoxBorder? border;
    switch (variant) {
      case _HeroPillVariant.solidLight:
        background = Colors.white;
        foreground = AppColors.primary;
        border = null;
        break;
      case _HeroPillVariant.solidAccent:
        background = AppColors.accent;
        foreground = Colors.white;
        border = null;
        break;
      case _HeroPillVariant.outline:
        background = Colors.white.withOpacity(0.08);
        foreground = Colors.white;
        border = Border.all(color: Colors.white.withOpacity(0.6));
        break;
    }

    // Tek dokunma kaynağı [TactilePress]'tir — içeride ayrıca bir InkWell
    // eklenmiyor ki aynı dokunuşun iki kez tetiklenmesi (çift navigasyon)
    // riski olmasın. Dokunsal geri bildirim spring tabanlı ölçek animasyonu
    // ile veriliyor.
    return TactilePress(
      onTap: onTap,
      pressScale: 0.94,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: context.responsive(mobile: 14, desktop: 20),
              vertical: context.responsive(mobile: 10, desktop: 13)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: border,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: context.responsive(mobile: 14, desktop: 16),
                  color: foreground),
              SizedBox(width: context.responsive(mobile: 5, desktop: 7)),
              Text(label,
                  style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontWeight: FontWeight.w600,
                      color: foreground,
                      fontSize: context.responsive(mobile: 12.5, desktop: 14))),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeroArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.white.withOpacity(0.22),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      );
}

/// Hero görselinin solunda, gerçek stoktan 3'erli setler halinde dönen,
/// hafifçe dağınık (fanned) bir kart yığını — küçük bir "reklam panosu"
/// hissi. Birkaç saniyede bir mevcut 3 kart kayıp-solarak gider, yeni bir
/// 3'lü aynı şekilde belirir. Sepete ekleme yok; her kart kendi ürününün
/// detay sayfasına gider.
class _FloatingFeaturedStack extends StatefulWidget {
  final List<Product> products;

  const _FloatingFeaturedStack({required this.products});

  @override
  State<_FloatingFeaturedStack> createState() => _FloatingFeaturedStackState();
}

class _FloatingFeaturedStackState extends State<_FloatingFeaturedStack> {
  Timer? _timer;
  int _setIndex = 0;
  late List<List<Product>> _sets;

  @override
  void initState() {
    super.initState();
    _sets = _buildSets();
    if (_sets.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (final _) {
        if (!mounted) return;
        setState(() => _setIndex = (_setIndex + 1) % _sets.length);
      });
    }
  }

  List<List<Product>> _buildSets() {
    final sets = <List<Product>>[];
    for (var i = 0; i < widget.products.length; i += 3) {
      sets.add(widget.products.skip(i).take(3).toList());
    }
    return sets;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (_sets.isEmpty) return const SizedBox.shrink();
    final currentSet = _sets[_setIndex % _sets.length];

    return SizedBox(
      width: context.responsive(mobile: 210, desktop: 252),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 650),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (final child, final animation) => SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.18, -0.06), end: Offset.zero)
                  .animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: Column(
          key: ValueKey(_setIndex),
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < currentSet.length; i++) ...[
              if (i > 0) const SizedBox(height: 14),
              _NumberedProductCard(number: i + 1, product: currentSet[i]),
            ],
          ],
        ),
      ),
    );
  }
}

/// Referans tasarımdaki sağ üstteki numaralı kart şeridinin karşılığı:
/// numara + ürün fotoğrafı + isim + fiyat/kategori + "İncele" rozeti.
/// "Shop Now" yerine ürün detayına yönlendiren dürüst bir eylem.
class _NumberedProductCard extends StatelessWidget {
  final int number;
  final Product product;

  const _NumberedProductCard({required this.number, required this.product});

  @override
  Widget build(final BuildContext context) {
    final hasImage = product.imagesUrl.isNotEmpty;
    // Tek dokunma kaynağı [TactilePress] — kart arkasındaki hero fotoğrafı
    // gerçek bir buzlu-cam (backdrop blur) yüzeyle bulanıklaştırıyor, bu
    // yüzden [GlassSurface]'e ayrıca onTap verilMEZ (çift tetiklemeyi önler).
    return TactilePress(
      onTap: () => NavigationHandler.goToProduct(
          context: context,
          productId: product.id,
          productSlug: product.name.toSlug()),
      child: GlassSurface(
        borderRadius: 18,
        strong: true,
        chromaticEdge: true,
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 54,
                height: 54,
                child: hasImage
                    ? Image.network(
                        product.imagesUrl.first,
                        fit: BoxFit.cover,
                        errorBuilder: (final c, final e, final s) =>
                            const _FeaturedCardFallback(),
                        loadingBuilder: (final c, final child,
                                final progress) =>
                            progress == null
                                ? child
                                : const KineticBeamSkeleton(borderRadius: 0),
                      )
                    : const _FeaturedCardFallback(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$number.',
                      style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 3),
                  Text(
                      '₺${product.price.toStringAsFixed(0)} · ${product.category.label(context)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: AppColors.textTertiary, fontSize: 11)),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(context.l10n.viewButton,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11)),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 12),
                        ],
                      ),
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
}

class _FeaturedCardFallback extends StatelessWidget {
  const _FeaturedCardFallback();

  @override
  Widget build(final BuildContext context) => Container(
      color: AppColors.secondary,
      child:
          Icon(Icons.chair_rounded, size: 18, color: AppColors.textTertiary));
}

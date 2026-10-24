import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/core/theme/app_text_styles.dart';
import 'package:saglamspot/core/theme/app_tokens.dart';
import 'package:saglamspot/core/theme/catalog_theme.dart';
import 'package:saglamspot/core/widgets/business_info_showcase.dart';
import 'package:saglamspot/core/widgets/design_system/infinite_ticker.dart';
import 'package:saglamspot/core/widgets/design_system/section_heading.dart';
import 'package:saglamspot/core/widgets/shimmer_components.dart';
import 'package:saglamspot/features/products/presentation/providers/product_provider.dart';
import '../../../../core/ads/widgets/ad_grid_helper.dart';
import '../../../../core/ads/widgets/adsense_banner.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/util/responsive_utils.dart';
import '../../../../core/widgets/design_system/reveal_fade.dart';
import '../../../../core/widgets/design_system/tactile_press.dart';
import '../../../../core/widgets/count_up_on_visible.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../../shared/widgets/site_footer.dart';
import '../../../products/data/models/category_meta.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/category_meta_provider.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../search/presentation/providers/search_providers.dart';
import '../widgets/furniture_tips_section.dart';
import '../widgets/home_page_hero_widgets.dart';
import '../widgets/home_page_showcase_cards.dart';
import '../widgets/home_store_showcase_sections.dart';
import '../widgets/how_it_works_section.dart';
import '../widgets/social_showcase_section.dart';
import '../widgets/why_us_section.dart';

/// Ana sayfa — referans alınan vitrin/katalog düzenine göre sıfırdan
/// kurulmuştur: tek parça banner hero, güven şeridi, ürün ızgarası, oda
/// ilhamı paneli, bakım ipuçları ve sosyal galeri. Satın alma/sepet akışı
/// YOK — tüm yönlendirmeler ürün detayına veya WhatsApp'a gider.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with ResponsiveUtils {
  /// Geniş ekranlarda içeriğin ortalandığı azami genişlik.
  /// (Eski 1440 + 48–64 pagePadding yanlarda ölü şerit bırakıyordu.)
  static const double _contentMaxWidth = 1920;

  /// Bant zaten içeriği ortalıyor; ekstra yatay padding'i sıkı tut.
  EdgeInsets get _homePad => EdgeInsets.symmetric(
        horizontal: context.responsive(
            mobile: 16.0, tablet: 24.0, desktop: 28.0, largeDesktop: 32.0),
        vertical: context.responsive(mobile: 16.0, tablet: 20.0, desktop: 24.0),
      );

  final ScrollController _scrollController = ScrollController();

  // Hero arka planında sırayla gösterilen fotoğraflar.
  static const List<String> _heroImages = [
    "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1600",
    "https://images.unsplash.com/photo-1581539250439-c96689b516dd?q=80&w=1600",
    "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1600",
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final availableProducts = ref.watch(availableProductsProvider);
    final selectedCategory = ref.watch(searchFiltersProvider).category;
    final filteredFeaturedProducts = availableProducts
        .where((final p) =>
            selectedCategory == null || p.category == selectedCategory)
        .toList();
    final Product? promoSpotlight = () {
      for (final p in availableProducts) {
        if (!p.isSpotProduct) return p;
      }
      return availableProducts.isNotEmpty ? availableProducts.first : null;
    }();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: productsAsync.when(
        loading: () => const FullPageShimmer(),
        error: (final err, final stack) =>
            Center(child: Text(context.l10n.productsLoadError('$err'))),
        data: (final _) => Stack(
          children: [
            // Eskiden tüm kaydırma alanı tek bir max-width kutusundaydı:
            // renkli bantlar da daralıyor, geniş ekranda iki yanda ölü
            // şerit kalıyordu. Artık bant ZEMİNLERİ tam genişlik, yalnızca
            // İÇERİK [_contentMaxWidth]'te ortalanıyor.
            Builder(builder: (final context) {
              final double side =
                  ((MediaQuery.sizeOf(context).width - _contentMaxWidth) / 2)
                      .clamp(0.0, double.infinity);
              Widget band(final Color color, final List<Widget> slivers) =>
                  DecoratedSliver(
                    decoration: BoxDecoration(color: color),
                    sliver: SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: side),
                      sliver: SliverMainAxisGroup(slivers: slivers),
                    ),
                  );
              return CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // --- BANT 1: krem zemin — hero'dan ürün ızgarasına kadar
                  // vitrinin "giriş" bölümü. Referans görsellerdeki gibi
                  // section'lar arasında belirgin ama yumuşak (aynı sıcak
                  // aile içinde) zemin geçişleri için sayfa artık tek
                  // düz krem yerine ayrı renkli bantlara bölündü.
                  band(
                    AppColors.background,
                    [
                      _buildHeroBanner(availableProducts),
                      _buildMottoStrip(),
                      // Referans vitrin tanıtımları + eski “iki kapı”
                      // GatewayCard (ürün görseli harmanlı).
                      if (availableProducts.isNotEmpty)
                        SliverToBoxAdapter(
                          child: HomeFeaturedProductRail(
                            products: availableProducts.take(10).toList(),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: HomeCollectionPromoBanner(
                          spotlight: promoSpotlight,
                        ),
                      ),
                      _buildFeatureTicker(),
                      _buildCatalogGateway(),
                      _buildTrustBar(),
                      _buildCategoriesSection(),
                      if (availableProducts.length > 2)
                        SliverToBoxAdapter(
                          child: HomeRecommendedStrip(
                            products: availableProducts.skip(2).take(8).toList(),
                          ),
                        ),
                      const SliverToBoxAdapter(child: HomeCategoryPromoPair()),
                      _buildProductsHeader(
                          filteredFeaturedProducts.length, selectedCategory),
                      _buildDynamicFeaturedGrid(
                          filteredFeaturedProducts, selectedCategory),
                      if (availableProducts.isNotEmpty)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: AdsenseBanner(
                                type: AdUnitType.display, height: 250),
                          ),
                        ),
                    ],
                  ),
                  // --- BANT 2: kırık-beyaz zemin (surface) ---
                  band(
                    AppColors.surface,
                    [
                      _buildRoomsInspirationBanner(),
                      // Sayfanın tam ortasına — canlı Google Haritalar +
                      // Açık/Kapalı durumu, gerçek çalışma saatleri ve
                      // iletişim aksiyonlarıyla, ziyaretçinin "gerçek bir
                      // işletme" olduğumuzu ilk bakışta gördüğü nokta.
                      const SliverToBoxAdapter(child: BusinessInfoShowcase()),
                      const FurnitureTipsSection(),
                    ],
                  ),
                  // --- BANT 3: krem zemin ---
                  band(
                    AppColors.background,
                    [
                      const SocialShowcaseSection(),
                      // --- Önceki tasarımların bölümleri: kaldırılmadı,
                      // yeni vitrin düzeninin altına eklendi. "Popüler
                      // Kategoriler" artık ayrı bir bölüm değil — verisi
                      // yukarıdaki "Yaşam Alanına Göre" panelinde
                      // kullanılıyor. ---
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: AdsenseBanner(
                              type: AdUnitType.inArticle, height: 300),
                        ),
                      ),
                      const HowItWorksSection(),
                    ],
                  ),
                  // --- BANT 4: kırık-beyaz zemin (surface) ---
                  band(
                    AppColors.surface,
                    [
                      _buildArtisanInfo(),
                      const WhyUsSection(),
                      // Reklam bilerek koyu istatistik şeridinden ÖNCE,
                      // hâlâ açık zeminin içinde duruyor — Stats + Footer
                      // arasına girerse iki koyu blok arasında açık bir
                      // yama gibi görünüp geçişi sertleştiriyordu. Böylece
                      // sayfanın en altı tek, kesintisiz bir koyu bant
                      // olarak akıyor.
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: AdsenseBanner(
                              type: AdUnitType.multiplex, height: 250),
                        ),
                      ),
                    ],
                  ),
                  _buildStatsSection(),
                  _buildFooter(),
                ],
              );
            }),
            // Web'de sağ altta sabit WhatsApp balonu var (NavigationScreen) —
            // yukarı çık butonu onun üstüne binmesin diye ek boşluk.
            ScrollUpButton(
              scrollController: _scrollController,
              extraBottomOffset: 72,
            ),
          ],
        ),
      ),
    );
  }

  // Referans tasarımdaki gibi: en fazla 2 sıra (8 kart) gösterilir, devamı
  // için altta ortalanmış bir "Tümünü Gör" hapı bulunur — sonsuz kaydırma
  // yerine bilinçli, sakin bir vitrin.
  Widget _buildDynamicFeaturedGrid(final List<Product> availableProducts,
      final ProductCategory? selectedCategory) {
    final visibleProducts = availableProducts.take(8).toList();

    return SliverPadding(
      padding: _homePad,
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.gridColumns(4),
              mainAxisSpacing: context.gridSpacing,
              crossAxisSpacing: context.gridSpacing,
              childAspectRatio: context.cardAspectRatio(),
            ),
            delegate: SliverChildBuilderDelegate(
              (final context, final index) {
                if (isAdSlot(index, visibleProducts.length)) {
                  return const NativeAdCard();
                }
                final realIndex =
                    realIndexForAdGrid(index, visibleProducts.length);
                if (realIndex >= visibleProducts.length) {
                  return const SizedBox.shrink();
                }
                return CustomProductCard(product: visibleProducts[realIndex]);
              },
              childCount: paddedItemCountForAds(visibleProducts.length),
            ),
          ),
          if (availableProducts.length > visibleProducts.length)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: context.spacingLarge),
                child: Center(
                  child: OutlinedButton(
                    onPressed: () => NavigationHandler.goToSearchWithCategory(
                        context, selectedCategory?.toFirestore()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(context.l10n.viewAllButton,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Karşılama + özel seçki bandı — motto şeridinin güçlendirilmiş hali
  /// (bölüm sayısı aynı; içerik profesyonel vitrin diline çekildi).
  Widget _buildMottoStrip() => SliverToBoxAdapter(
        child: Padding(
          padding: _homePad.copyWith(
              top: context.spacingLarge, bottom: context.spacingLarge),
          child: Column(
            children: [
              Text(
                context.l10n.homeWelcomeGreeting,
                textAlign: TextAlign.center,
                style: AppTextStyles.serif(
                  fontSize: context.responsive(mobile: 22, desktop: 28),
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.l10n.homeWelcomeTagline,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: context.captionSize),
              ),
              const SizedBox(height: 18),
              TactilePress(
                onTap: () => NavigationHandler.goToDiscover(context),
                pressScale: 0.99,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 960),
                    height: context.responsive(
                        mobile: 148.0, tablet: 168.0, desktop: 186.0),
                    color: AppColors.accent.withValues(alpha: 0.16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: OptimizedCachedImage(
                            imageUrl:
                                'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=900',
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                            borderRadius: 0,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: context.responsive(
                                    mobile: 16, desktop: 28),
                                vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context.l10n.specialOfferLabel,
                                  style: AppTextStyles.microLabel(
                                    color: AppColors.accentDark,
                                    fontSize: 10,
                                    letterSpacing: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  context.l10n.specialOfferTitle,
                                  style: AppTextStyles.serif(
                                    fontSize: context.responsive(
                                        mobile: 18, desktop: 24),
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  context.l10n.specialOfferBody,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: context.captionSize,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontFamily: AppTextStyles.headingFontFamily,
                    fontSize: context.responsive(mobile: 16, desktop: 18),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                  children: [
                    TextSpan(text: context.l10n.mottoTitlePart1),
                    TextSpan(
                      text: context.l10n.mottoTitlePart2,
                      style: TextStyle(
                          color: AppColors.accentDark,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

  // Eski “iki kapı” kartı + güncel ürün görselleri (harman).
  Widget _buildCatalogGateway() {
    final newProducts = ref.watch(newDealsProductsProvider);
    final spotProducts = ref.watch(spotDealsProductsProvider);

    String? imageOf(final List<Product> list) {
      if (list.isEmpty) return null;
      final p = list.first;
      if (p.studioImagesUrl.isNotEmpty && p.studioImagesUrl.first.isNotEmpty) {
        return p.studioImagesUrl.first;
      }
      return p.imagesUrl.isNotEmpty ? p.imagesUrl.first : null;
    }

    final newCard = RevealFade(
      delayMs: 40,
      child: GatewayCard(
        eyebrow: context.l10n.gatewayNewEyebrow,
        eyebrowColor: NewCollectionPalette.badgeGreen,
        title: context.l10n.gatewayNewTitle,
        subtitle: context.l10n.gatewayNewSubtitle,
        count: newProducts.length,
        background: NewCollectionPalette.background,
        cardBorder: NewCollectionPalette.cardBorder,
        heading: NewCollectionPalette.heading,
        body: NewCollectionPalette.body,
        accent: NewCollectionPalette.accent,
        headingFontFamily: NewCollectionPalette.headingFont,
        icon: Icons.chair_rounded,
        buttonLabel: context.l10n.gatewayNewButton,
        imageUrl: imageOf(newProducts),
        onTap: () => NavigationHandler.goToNewProducts(context),
      ),
    );

    final spotCard = RevealFade(
      delayMs: 100,
      child: GatewayCard(
        eyebrow: context.l10n.gatewaySpotEyebrow,
        eyebrowColor: SpotPalette.accent,
        title: context.l10n.gatewaySpotTitle,
        subtitle: context.l10n.gatewaySpotSubtitle,
        count: spotProducts.length,
        background: SpotPalette.background,
        cardBorder: SpotPalette.cardBorder,
        heading: SpotPalette.heading,
        body: SpotPalette.body,
        accent: SpotPalette.accent,
        headingFontFamily: null,
        icon: Icons.local_offer_rounded,
        buttonLabel: context.l10n.gatewaySpotButton,
        imageUrl: imageOf(spotProducts),
        onTap: () => NavigationHandler.goToSpotProducts(context),
      ),
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: _homePad.copyWith(bottom: context.spacingLarge),
        child: context.isMobile
            ? Column(children: [newCard, const SizedBox(height: 16), spotCard])
            : IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: newCard),
                    const SizedBox(width: 20),
                    Expanded(child: spotCard),
                  ],
                ),
              ),
      ),
    );
  }

  // Tek parça, geniş banner hero: arka planda kaydırılabilir (ok + nokta
  // göstergeli) fotoğraflar, solda başlık + tek bir "keşfet" CTA'sı, sağ
  // altta gerçek bir ürünü tanıtan yüzen kart. Satın alma değil, ürün
  // detayına ya da WhatsApp'a yönlendirme.
  Widget _buildHeroBanner(final List<Product> availableProducts) {
    final featuredPool = availableProducts.take(9).toList();

    return SliverToBoxAdapter(
      child: Padding(
        padding: _homePad,
        child: SizedBox(
          // Tarayıcı penceresinin yüksekliğine (hp) değil, sabit ve her
          // kırılım noktasında içeriğin rahatça sığdığı bir yüksekliğe
          // bağlandı — kısa/geniş pencerelerde metnin taşmasını önler.
          height: context.responsive(
              mobile: 460.0,
              tablet: 500.0,
              desktop: 560.0,
              largeDesktop: 620.0),
          child: HeroBanner(images: _heroImages, featuredPool: featuredPool),
        ),
      ),
    );
  }

  // Önceden tek sıra, aynı boyutlu 4 öğeydi (düz bir "liste" hissi).
  // 2026 web tasarımında asimetrik kutu/bento ızgaraları artık öne çıkan
  // bir vitrin düzeni (karma boyutlu kutularla tek bakışta birden çok
  // vurguyu göstermek) — az sayıda gerçek içerikle bile sayfanın daha
  // "dolu" hissetmesini sağlıyor. Aynı 4 güven vurgusu artık tek boyutlu
  // bir kutu yerine; bir büyük + ikisi orta + biri uzun kutudan oluşan bir
  // bento ızgarasında, her biri kendi rengiyle hafif renklendirilmiş bir
  // zeminde duruyor.
  Widget _buildTrustBar() {
    final items = [
      _BentoTrustItem(Icons.volunteer_activism_rounded,
          context.l10n.featureArtisan, AppColors.accent),
      _BentoTrustItem(Icons.verified_user_rounded,
          context.l10n.featureDelivery, AppColors.success),
      _BentoTrustItem(Icons.sentiment_very_satisfied_rounded,
          context.l10n.featureService, AppColors.warning),
      _BentoTrustItem(
          Icons.local_shipping_rounded, context.l10n.featureShipping,
          AppColors.info),
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: _homePad,
        child: context.isMobile
            ? Column(
                children: [
                  SizedBox(
                      height: 190,
                      child: _bentoTile(items[0], large: true, delayMs: 0)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                            child: _bentoTile(items[1],
                                large: false, delayMs: 70)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: _bentoTile(items[2],
                                large: false, delayMs: 140)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                      height: 120,
                      child:
                          _bentoTile(items[3], large: false, delayMs: 210)),
                ],
              )
            : SizedBox(
                height: 300,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        flex: 5,
                        child: _bentoTile(items[0], large: true, delayMs: 0)),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Expanded(
                              child: _bentoTile(items[1],
                                  large: false, delayMs: 70)),
                          const SizedBox(height: 16),
                          Expanded(
                              child: _bentoTile(items[2],
                                  large: false, delayMs: 140)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                        flex: 3,
                        child: _bentoTile(items[3],
                            large: false, delayMs: 210)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _bentoTile(final _BentoTrustItem item,
      {required final bool large, required final int delayMs}) {
    // NOT: Küçük kutular Column (flex) içinde sabit, dar bir yükseklik
    // alıyor — büyük kutuyla aynı iç boşluk/ikon/2 satır metin orada
    // RenderFlex taşmasına yol açtı. Küçük kutular için dolgu, ikon ve
    // metin satırı bilinçli olarak daha kompakt.
    final double iconBox =
        large ? context.iconMedium + 20 : context.iconMedium - 2;
    return RevealFade(
      delayMs: delayMs,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(large ? 24 : 14),
        decoration: BoxDecoration(
          color: item.color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(context.borderRadius()),
          border: Border.all(color: item.color.withOpacity(0.18)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconBox,
              height: iconBox,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    item.color,
                    Color.lerp(item.color, Colors.black, 0.24)!
                  ],
                ),
                borderRadius: BorderRadius.circular(large ? 14 : 11),
                boxShadow: [
                  BoxShadow(
                      color: item.color.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: Icon(item.icon,
                  color: Colors.white,
                  size: iconBox * (large ? 0.52 : 0.58)),
            ),
            SizedBox(height: large ? 16 : 8),
            Text(item.label,
                maxLines: large ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: large
                        ? context.h3Size * 0.56
                        : context.bodySize * 0.92)),
          ],
        ),
      ),
    );
  }

  /// 6 semtin tamamını değil, ilk ikisini + "ve çevresi" gösterir — akan
  /// şeritteki tek bir çipin devasa büyümesini önler. Tam liste hâlâ
  /// BusinessInfoShowcase / footer'daki konum kartında eksiksiz duruyor.
  String get _shortDeliveryZonesLabel {
    final zones = SaglamSpotCommunication.freeDeliveryZones;
    if (zones.length <= 2) return zones.join(', ');
    return context.l10n.deliveryZonesAndSurroundings(zones.take(2).join(', '));
  }

  /// Sonsuz kayan güven/marka şeridi — referans "Luma & Living" tasarımının
  /// `_buildBrandLogos` bölümünün karşılığı. Uydurma marka isimleri yerine
  /// gerçek güven/hizmet vurgularımızı aynı görsel dille kullanır.
  Widget _buildFeatureTicker() {
    final items = <TickerItem>[
      TickerItem(
          Icons.verified_rounded, context.l10n.productTrustBadgeVerified),
      TickerItem(
          Icons.handshake_rounded, context.l10n.productTrustBadgeNegotiate),
      TickerItem(
          Icons.local_shipping_rounded, context.l10n.productTrustBadgeDelivery),
      // Ücretsiz teslimat gerçek bir vaat, ama sınırsız değil — şeritte
      // genel "teslimat" rozetinin yanına, hangi bölgelerle sınırlı
      // olduğunu netleştiren ayrı bir not ekleniyor (yanlış beklenti
      // oluşmasın diye). TÜM 6 semti tek satırda saymak yerine (tek bir
      // devasa uzun çip, akışın ritmini bozuyordu) kısa bir özet
      // kullanılıyor — tam liste zaten Bize Uğra/footer kartlarında var.
      TickerItem(
        Icons.map_rounded,
        context.l10n.freeDeliveryZonesNote(_shortDeliveryZonesLabel),
      ),
      TickerItem(Icons.storefront_rounded, context.l10n.sellerTrustLine),
      TickerItem(Icons.workspace_premium_rounded, context.l10n.usp1Title),
      TickerItem(Icons.auto_awesome_rounded, context.l10n.qualityFurniture),
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: context.responsive(mobile: 20, desktop: 28)),
        child: InfiniteTicker(
            items: items, height: context.responsive(mobile: 64, desktop: 78)),
      ),
    );
  }

  // Önceden yalnız eyebrow+başlıktı, "Tümünü Gör" tek başına ızgaranın
  // altındaydı ve ürün sayısı hiç görünmüyordu — referans vitrindeki gibi
  // üstte aynı satırda bir sayı + hızlı "Tümünü Gör" bağlantısı eklendi
  // (alttaki buton aynen duruyor, bu sadece üstteki ilk izlenimi güçlendiriyor).
  Widget _buildProductsHeader(
          final int productCount, final ProductCategory? selectedCategory) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: _homePad.copyWith(
              top: context.spacingLarge, bottom: context.spacingLarge * 0.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeading(
                eyebrow: context.l10n.showcaseEyebrow,
                title: context.l10n.newCollection,
                seeAllLabel: context.l10n.viewAllButton,
                onSeeAll: productCount > 8
                    ? () => NavigationHandler.goToSearchWithCategory(
                        context, selectedCategory?.toFirestore())
                    : null,
              ),
              if (productCount > 0) ...[
                const SizedBox(height: 6),
                Text(
                  context.l10n.categoryProductCount(productCount),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: context.captionSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      );

  // Önceden burada düz ikon+etiket çipleri (DynamicCategoryChips) vardı —
  // "eski tip", görselsiz bir liste. Artık mobil uygulamanın vitrin
  // hissiyatına uygun, her kategorinin kendi fotoğrafını taşıyan, sık/yoğun
  // bir yatay kart şeridi. "Tümü" kartı fotoğrafsız, marka rengiyle ayrışan
  // sabit ilk kart olarak kalıyor.
  // Dairesel kategori rayı: vitrinin ilk "göz atma" hamlesi — ustanın
  // elindeki fotoğraf albümünü andıran yuvarlak uğraklar, alt tarafta
  // kategori adı. Rect kart + alt scrim yerine bu imza (minar'ın
  // circular kategori rayına benzer bir dağarcık, ama Atölye paletiyle —
  // indirim/fiyat rozeti yok, yalnızca gezinme).
  Widget _buildCategoriesSection() {
    final categories = ref.watch(orderedActiveCategoriesProvider);
    final selected = ref.watch(searchFiltersProvider).category;
    final double circleSize =
        context.responsive(mobile: 68.0, tablet: 78.0, desktop: 88.0);
    final double itemWidth = circleSize + 28;
    final double sectionHeight = circleSize + 48;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        height: sectionHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: _homePad.left),
          itemCount: categories.length + 1,
          separatorBuilder: (final _, final __) => const SizedBox(width: 14),
          itemBuilder: (final context, final index) {
            if (index == 0) {
              return _buildCircularCategoryItem(
                diameter: circleSize,
                width: itemWidth,
                title: context.l10n.conditionAll,
                imageUrl: null,
                isSelected: selected == null,
                onTap: () =>
                    ref.read(searchFiltersProvider.notifier).setCategory(null),
              );
            }
            final meta = categories[index - 1];
            return _buildCircularCategoryItem(
              diameter: circleSize,
              width: itemWidth,
              title: meta.customLabel ?? meta.category.label(context),
              imageUrl: _categoryPhotos[meta.category] ??
                  _categoryPhotos[ProductCategory.other],
              isSelected: selected == meta.category,
              onTap: () => ref
                  .read(searchFiltersProvider.notifier)
                  .setCategory(meta.category),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCircularCategoryItem({
    required final double diameter,
    required final double width,
    required final String title,
    required final String? imageUrl,
    required final bool isSelected,
    required final VoidCallback onTap,
  }) {
    final double innerSize = diameter - 10;
    return TactilePress(
      onTap: onTap,
      pressScale: 0.94,
      enableTilt: false,
      // Web'de fare üzerine gelince hafif büyüme — tilt bu küçük dairesel
      // avatara uymuyordu (bkz. enableTilt: false), ama hover'da hiçbir
      // geri bildirim de olmaması web'i mobildeki dokunsal hisse göre
      // "cansız" bırakıyordu.
      hoverScale: 1.07,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppMotion.normal,
              curve: Curves.easeOut,
              width: diameter,
              height: diameter,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected
                    ? LinearGradient(
                        colors: [AppColors.accentDark, AppColors.accent],
                      )
                    : null,
                color: isSelected ? null : AppColors.secondary,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.accentDark.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                ),
                child: imageUrl != null
                    ? OptimizedCachedImage(
                        imageUrl: imageUrl,
                        width: innerSize,
                        height: innerSize,
                        isCircular: true,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppColors.secondary),
                      )
                    : ClipOval(
                        child: Container(
                          width: innerSize,
                          height: innerSize,
                          color: AppColors.accentDark,
                          child: Icon(Icons.grid_view_rounded,
                              color: Colors.white.withOpacity(0.9),
                              size: innerSize * 0.36),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: context.responsive(mobile: 11.5, desktop: 12.5),
                color: isSelected ? AppColors.accentDark : AppColors.textPrimary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // "50+ Beautiful rooms inspiration" referansının bölünmüş panel düzeni:
  // solda sabit renkli metin bloğu + "Keşfet" CTA'sı, sağda kademeli
  // (staggered) yerleşimli oda fotoğrafları.
  // Firestore'dan beslenen 'Popüler Kategoriler' bölümünün ismini ve
  // dinamik veri altyapısını (orderedActiveCategoriesProvider) alıp, ayrı
  // bir bölüm olarak DEĞİL, bu daha şık bölünmüş-panel tasarımının sağ
  // tarafına aktif kategori sayısı kadar kart olarak yerleştiriyoruz. Ayrı
  // "Popüler Kategoriler" bölümü artık gösterilmiyor.
  static const Map<ProductCategory, String> _categoryPhotos = {
    ProductCategory.sofa:
        'https://images.unsplash.com/photo-1550254478-ead40cc54513?q=80&w=800',
    ProductCategory.chair:
        'https://images.unsplash.com/photo-1592078615290-033ee584e267?q=80&w=800',
    ProductCategory.table:
        'https://images.unsplash.com/photo-1617806118233-18e1de247200?q=80&w=800',
    ProductCategory.bed:
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=800',
    ProductCategory.wardrobe:
        'https://images.unsplash.com/photo-1595428774223-ef52624120d2?q=80&w=800',
    ProductCategory.white:
        'https://images.unsplash.com/photo-1556911220-bff31c812dba?q=80&w=800',
    ProductCategory.lighting:
        'https://images.unsplash.com/photo-1517991104123-1d56a6e81ed9?q=80&w=800',
    ProductCategory.homeTextile:
        'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?q=80&w=800',
    ProductCategory.decor:
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=800',
    ProductCategory.officeFurniture:
        'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?q=80&w=800',
    ProductCategory.outdoorGarden:
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?q=80&w=800',
    ProductCategory.kidsFurniture:
        'https://images.unsplash.com/photo-1522771930-78848d9293e8?q=80&w=800',
    ProductCategory.other:
        'https://images.unsplash.com/photo-1524758631624-e2822e304c36?q=80&w=800',
  };

  Widget _buildRoomsInspirationBanner() {
    final categories = ref.watch(orderedActiveCategoriesProvider);

    Widget room(final CategoryMeta meta) => RoomCard(
          title: meta.customLabel ?? meta.category.label(context),
          img: _categoryPhotos[meta.category] ??
              _categoryPhotos[ProductCategory.other]!,
          sub: context.l10n.byRoomSub,
          onTap: () => NavigationHandler.goToSearchWithCategory(
              context, meta.category.toFirestore()),
        );

    final textBlock = Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.responsive(mobile: 24, desktop: 40)),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(28),
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.byRoom,
              style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: context.h2Size,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.2)),
          const SizedBox(height: 12),
          Text(context.l10n.byRoomSub,
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: context.bodySize,
                  height: 1.5)),
          const SizedBox(height: 22),
          OutlinedButton.icon(
            onPressed: () => NavigationHandler.goToSearch(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            icon: const Icon(Icons.explore_outlined, size: 16),
            label: Text(context.l10n.exploreButton,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    // Kategori sayısı Firestore'a göre değişebileceği için sabit 2 kart
    // yerine yatay kaydırmalı bir şerit — aktif kaç kategori varsa o kadar
    // kart gösterir. Yükseklik tarayıcı penceresine (hp) değil sabit
    // piksele bağlı — kısa pencerelerde taşmayı önler.
    final collage = SizedBox(
      height: context.responsive(
          mobile: 240.0, tablet: 340.0, desktop: 400.0, largeDesktop: 440.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (final context, final i) => room(categories[i]),
      ),
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: _homePad,
        child: context.isMobile
            ? Column(
                children: [
                  textBlock,
                  const SizedBox(height: 16),
                  collage,
                ],
              )
            : SizedBox(
                height: context.responsive(
                    mobile: 340.0,
                    tablet: 340.0,
                    desktop: 400.0,
                    largeDesktop: 440.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 4, child: textBlock),
                    SizedBox(width: context.spacingLarge),
                    Expanded(flex: 7, child: collage),
                  ],
                ),
              ),
      ),
    );
  }

  // --- Önceki tasarımdan geri getirilen bölümler ---

  Widget _buildArtisanInfo() => SliverToBoxAdapter(
        child: Container(
          margin: context.sectionPadding,
          padding: EdgeInsets.all(context.responsive(mobile: 20, desktop: 60)),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(context.borderRadius(2)),
            border: Border.all(color: context.primaryColor.withOpacity(0.05)),
          ),
          child: Flex(
            direction: context.isMobile ? Axis.vertical : Axis.horizontal,
            children: [
              Expanded(
                flex: context.isMobile ? 0 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.whoWeAre,
                        style: TextStyle(
                            color: AppColors.accentDark,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2)),
                    const SizedBox(height: 15),
                    Text(context.l10n.artisanTitle,
                        style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: context.h2Size,
                            fontWeight: FontWeight.w600,
                            height: 1.2)),
                    const SizedBox(height: 15),
                    Text(context.l10n.artisanDesc,
                        style: TextStyle(
                            color: context.primaryColor.withOpacity(0.6),
                            fontSize: context.bodySize)),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () => NavigationHandler.goToAbout(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentDark),
                      child: Text(context.l10n.visitUsButton),
                    )
                  ],
                ),
              ),
              if (!context.isMobile) const SizedBox(width: 40),
              if (context.isMobile) const SizedBox(height: 30),
              Expanded(
                flex: context.isMobile ? 0 : 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                      "https://images.unsplash.com/photo-1540518614846-7eded433c457?q=80&w=800",
                      fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      );

  // Önceki sürümde burada uydurma pazarlama rakamları vardı ("2.5K+ mutlu
  // müşteri", "15K+ teslimat", "%100 güven" gibi hiçbir gerçek veriye
  // dayanmayan sayılar). Artık her rakam doğrudan Firestore'dan beslenen
  // Riverpod provider'larından geliyor: aktif ürün sayısı, aktif kategori
  // sayısı ve tamamlanmış (satılmış) ürün sayısı. Gerçek bir karşılığı
  // olmayan "mutlu müşteri sayısı" ve "%güven" rakamları uydurulmak yerine
  // tamamen kaldırıldı — 20 yıllık esnaflık ise uygulamanın başka
  // yerlerinde de (usp1Title/sellerTrustLine) kullanılan, gerçek ve
  // doğrulanabilir bir işletme bilgisi olduğu için korundu.
  Widget _buildStatsSection() {
    final productCount = ref.watch(availableProductsProvider).length;
    final categoryCount = ref.watch(orderedActiveCategoriesProvider).length;
    final deliveredCount = ref.watch(soldProductsProvider).length;

    final stats = [
      {
        "target": productCount.toDouble(),
        "decimals": 0,
        "suffix": "",
        "label": context.l10n.statProducts,
        "icon": Icons.inventory_2_outlined
      },
      {
        "target": categoryCount.toDouble(),
        "decimals": 0,
        "suffix": "",
        "label": context.l10n.sectionCategories,
        "icon": Icons.category_outlined
      },
      {
        "target": 20.0,
        "decimals": 0,
        "suffix": context.l10n.statYearsSuffix,
        "label": context.l10n.statExperience,
        "icon": Icons.workspace_premium_outlined
      },
      {
        "target": deliveredCount.toDouble(),
        "decimals": 0,
        "suffix": "",
        "label": context.l10n.statDelivery,
        "icon": Icons.local_shipping_outlined
      },
    ];

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.hp(5)),
        // Krem sayfa zemininden koyu şeride sert bir kesim yerine yumuşak
        // bir geçişle iniliyor — üst %18'lik dilim krem tondan koyu tona
        // erir, geri kalanı düz koyu renkte kalır (footer'la kesintisiz
        // birleşsin diye).
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.backgroundDark],
            stops: const [0.0, 0.18],
          ),
        ),
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: stats
                .map((final s) => _buildStatCard(
                      target: s["target"] as double,
                      decimals: s["decimals"] as int,
                      prefix: s["prefix"] as String? ?? "",
                      suffix: s["suffix"] as String,
                      label: s["label"] as String,
                      icon: s["icon"] as IconData,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required final double target,
    required final int decimals,
    required final String suffix,
    required final String label,
    required final IconData icon,
    final String prefix = "",
  }) =>
      Container(
        width: context.responsive(
            mobile: context.wp(42), tablet: 200, desktop: 250),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(context.borderRadius()),
          border: Border.all(color: Colors.white.withOpacity(0.09)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accentLight, size: 30),
            const SizedBox(height: 15),
            CountUpOnVisible(
              targetValue: target,
              prefix: prefix,
              suffix: suffix,
              decimalDigits: decimals,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: context.h3Size,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 5),
            Text(label.toUpperCase(),
                style: AppTextStyles.microLabel(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 10,
                    letterSpacing: 1.6)),
          ],
        ),
      );

  // --- Endüstriyel/gerçekçi footer ---
  // Üstte bir "tehlike şeridi" ayraç + fabrika levhası hissi veren
  // monospace etiketler. 4 sütun: marka + sosyal ikonlar (WhatsApp,
  // Instagram, Facebook, Telefon), menü linkleri, gerçek iletişim
  // bilgileri ve CANLI çalışma-saati/konum kartı (e-posta bülten
  // formunun yerini aldı — gerçek zamana göre "Açık/Kapalı" hesaplar).
  // Artık /new ve /spot sayfalarıyla paylaşılan tek footer — bkz.
  // shared/widgets/site_footer.dart.
  Widget _buildFooter() =>
      const SliverToBoxAdapter(child: SiteFooter());
}

class _BentoTrustItem {
  final IconData icon;
  final String label;
  final Color color;

  const _BentoTrustItem(this.icon, this.label, this.color);
}

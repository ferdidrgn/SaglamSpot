import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/core/theme/app_text_styles.dart';
import 'package:saglamspot/core/theme/catalog_theme.dart';
import 'package:saglamspot/core/widgets/business_info_showcase.dart';
import 'package:saglamspot/core/widgets/design_system/glass_surface.dart';
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
import '../../../../core/widgets/count_up_on_visible.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../../core/widgets/dynamic_category_chips.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../products/data/models/category_meta.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/category_meta_provider.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../search/presentation/providers/search_providers.dart';
import '../widgets/furniture_tips_section.dart';
import '../widgets/home_page_footer_widgets.dart';
import '../widgets/home_page_hero_widgets.dart';
import '../widgets/home_page_showcase_cards.dart';
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: productsAsync.when(
        loading: () => const FullPageShimmer(),
        error: (final err, final stack) =>
            Center(child: Text(context.l10n.productsLoadError('$err'))),
        data: (final _) => Stack(
          children: [
            ResponsiveUtils.maxWidthContainer(
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // --- BANT 1: krem zemin — hero'dan ürün ızgarasına kadar
                  // vitrinin "giriş" bölümü. Referans görsellerdeki gibi
                  // section'lar arasında belirgin ama yumuşak (aynı sıcak
                  // aile içinde) zemin geçişleri için sayfa artık tek
                  // düz krem yerine ayrı renkli bantlara bölündü.
                  DecoratedSliver(
                    decoration: BoxDecoration(color: AppColors.background),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        _buildHeroBanner(availableProducts),
                        _buildFeatureRow(),
                        _buildMottoStrip(),
                        _buildFeatureTicker(),
                        _buildCatalogGateway(),
                        _buildTrustBar(),
                        _buildCategoriesSection(),
                        _buildProductsHeader(),
                        _buildDynamicFeaturedGrid(
                          availableProducts
                              .where((final p) =>
                                  selectedCategory == null ||
                                  p.category == selectedCategory)
                              .toList(),
                          selectedCategory,
                        ),
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
                  ),
                  // --- BANT 2: kırık-beyaz zemin (surface) ---
                  DecoratedSliver(
                    decoration: BoxDecoration(color: AppColors.surface),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        _buildRoomsInspirationBanner(),
                        // Sayfanın tam ortasına — canlı Google Haritalar +
                        // Açık/Kapalı durumu, gerçek çalışma saatleri ve
                        // iletişim aksiyonlarıyla, ziyaretçinin "gerçek bir
                        // işletme" olduğumuzu ilk bakışta gördüğü nokta.
                        const SliverToBoxAdapter(child: BusinessInfoShowcase()),
                        const FurnitureTipsSection(),
                      ],
                    ),
                  ),
                  // --- BANT 3: krem zemin ---
                  DecoratedSliver(
                    decoration: BoxDecoration(color: AppColors.background),
                    sliver: SliverMainAxisGroup(
                      slivers: [
                        const SocialShowcaseSection(),
                        // --- Önceki tasarımların bölümleri: kaldırılmadı,
                        // yeni vitrin düzeninin altına eklendi. "Popüler
                        // Kategoriler" artık ayrı bir bölüm değil — verisi
                        // yukarıdaki "Yaşam Alanına Göre" panelinde
                        // kullanılıyor. ---
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: AdsenseBanner(
                                type: AdUnitType.inArticle, height: 300),
                          ),
                        ),
                        const HowItWorksSection(),
                      ],
                    ),
                  ),
                  // --- BANT 4: kırık-beyaz zemin (surface) ---
                  DecoratedSliver(
                    decoration: BoxDecoration(color: AppColors.surface),
                    sliver: SliverMainAxisGroup(
                      slivers: [
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: AdsenseBanner(
                                type: AdUnitType.multiplex, height: 250),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatsSection(),
                  _buildFooter(),
                ],
              ),
            ),
            ScrollUpButton(scrollController: _scrollController),
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
      padding: context.pagePadding,
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

  // Bir esnaf uygulamasıyız — vitrin, çevrimiçi mağaza değil. Ziyaretçinin
  // hero'yu gördüğü ilk anda işin özünü anlaması için, dönen slaytlara
  // bağlı olmayan sabit bir motto şeridi: dükkâna gelmeden önce vitrini
  // gez, beğendiğinde dükkâna gel.
  Widget _buildMottoStrip() => SliverToBoxAdapter(
        child: Padding(
          padding: context.pagePadding.copyWith(
              top: context.spacingLarge, bottom: context.spacingLarge),
          child: Center(
            child: Column(
              children: [
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Icon(Icons.visibility_rounded,
                        size: context.iconMedium, color: AppColors.accentDark),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: context.responsive(mobile: 20, desktop: 26),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.2,
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
                const SizedBox(height: 8),
                Text(
                  context.l10n.mottoSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: context.captionSize),
                ),
              ],
            ),
          ),
        ),
      );

  // Tek parça, geniş banner hero: arka planda kaydırılabilir (ok + nokta
  // göstergeli) fotoğraflar, solda başlık + tek bir "keşfet" CTA'sı, sağ
  // altta gerçek bir ürünü tanıtan yüzen kart. Satın alma değil, ürün
  // detayına ya da WhatsApp'a yönlendirme.
  Widget _buildHeroBanner(final List<Product> availableProducts) {
    final featuredPool = availableProducts.take(9).toList();

    return SliverToBoxAdapter(
      child: Padding(
        padding: context.pagePadding,
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

  // Referans tasarımlardaki "hero altına taşan 3 kart" düzeni: hero'nun alt
  // kenarına hafifçe binen, beyaz/yuvarlak, ikon+başlık+açıklama+CTA
  // içeren 3 kart. CatalogGateway'deki Sıfır/Spot kartlarıyla ÇAKIŞMASIN
  // diye içerik bilerek farklı — burada genel güven/hizmet vurguları var.
  Widget _buildFeatureRow() {
    final items = [
      (
        image:
            'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?q=80&w=300',
        icon: Icons.workspace_premium_rounded,
        title: context.l10n.featureRow1Title,
        desc: context.l10n.featureRow1Desc,
        buttonLabel: context.l10n.exploreButton,
        onTap: () => NavigationHandler.goToAbout(context),
      ),
      (
        image:
            'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=300',
        icon: Icons.local_shipping_rounded,
        title: context.l10n.featureRow2Title,
        desc: context.l10n.featureRow2Desc,
        buttonLabel: context.l10n.exploreButton,
        onTap: () => NavigationHandler.goToSSS(context),
      ),
      (
        image:
            'https://images.unsplash.com/photo-1520201163981-8cc95007dd2a?q=80&w=300',
        icon: Icons.chat_bubble_rounded,
        title: context.l10n.featureRow3Title,
        desc: context.l10n.featureRow3Desc,
        buttonLabel: context.l10n.exploreButton,
        onTap: () => SaglamSpotCommunication.launchWhatsApp(),
      ),
    ];

    final overlap = context.responsive(mobile: 22.0, desktop: 40.0);

    return SliverToBoxAdapter(
      child: Transform.translate(
        offset: Offset(0, -overlap),
        child: Padding(
          padding: context.pagePadding.copyWith(top: 0, bottom: 0),
          child: context.isMobile
              ? Column(
                  children: [
                    for (int i = 0; i < items.length; i++) ...[
                      if (i > 0) const SizedBox(height: 14),
                      FeatureOverlapCard(
                        image: items[i].image,
                        icon: items[i].icon,
                        title: items[i].title,
                        desc: items[i].desc,
                        buttonLabel: items[i].buttonLabel,
                        onTap: items[i].onTap,
                      ),
                    ],
                  ],
                )
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < items.length; i++) ...[
                        if (i > 0) const SizedBox(width: 18),
                        Expanded(
                          child: FeatureOverlapCard(
                            image: items[i].image,
                            icon: items[i].icon,
                            title: items[i].title,
                            desc: items[i].desc,
                            buttonLabel: items[i].buttonLabel,
                            onTap: items[i].onTap,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // İki katalog, iki ayrı "kapı" — kullanıcı tıklamadan önce Sıfır
  // Koleksiyon'un sakin/butik ve Spot Fırsatlar'ın canlı/atölye kimliğini
  // burada görsel olarak öğreniyor (bkz. core/theme/catalog_theme.dart).
  Widget _buildCatalogGateway() {
    final newCount = ref.watch(newDealsProductsProvider).length;
    final spotCount = ref.watch(spotDealsProductsProvider).length;

    final newCard = GatewayCard(
      eyebrow: context.l10n.gatewayNewEyebrow,
      eyebrowColor: NewCollectionPalette.badgeGreen,
      title: context.l10n.gatewayNewTitle,
      subtitle: context.l10n.gatewayNewSubtitle,
      count: newCount,
      background: NewCollectionPalette.background,
      cardBorder: NewCollectionPalette.cardBorder,
      heading: NewCollectionPalette.heading,
      body: NewCollectionPalette.body,
      accent: NewCollectionPalette.accent,
      headingFontFamily: NewCollectionPalette.headingFont,
      icon: Icons.chair_rounded,
      buttonLabel: context.l10n.gatewayNewButton,
      onTap: () => NavigationHandler.goToNewProducts(context),
    );

    final spotCard = GatewayCard(
      eyebrow: context.l10n.gatewaySpotEyebrow,
      eyebrowColor: SpotPalette.accent,
      title: context.l10n.gatewaySpotTitle,
      subtitle: context.l10n.gatewaySpotSubtitle,
      count: spotCount,
      background: SpotPalette.background,
      cardBorder: SpotPalette.cardBorder,
      heading: SpotPalette.heading,
      body: SpotPalette.body,
      accent: SpotPalette.accent,
      headingFontFamily: null,
      icon: Icons.local_offer_rounded,
      buttonLabel: context.l10n.gatewaySpotButton,
      onTap: () => NavigationHandler.goToSpotProducts(context),
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: context.pagePadding.copyWith(bottom: context.spacingLarge),
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

  // Önceden 4'ü de aynı düz altın ikon rengindeydi ve hiçbirinde giriş
  // animasyonu yoktu. Her vurguya markanın kendi anlamlı paletinden
  // (accent/success/warning/info) ayrı bir renk + kademeli (staggered)
  // bir beliriş animasyonu verildi — sayfanın geri kalanındaki RevealFade
  // diliyle tutarlı.
  Widget _buildTrustBar() {
    final items = [
      _trustItem(Icons.volunteer_activism_rounded, context.l10n.featureArtisan,
          AppColors.accent, 0),
      _trustItem(Icons.verified_user_rounded, context.l10n.featureDelivery,
          AppColors.success, 70),
      _trustItem(Icons.sentiment_very_satisfied_rounded,
          context.l10n.featureService, AppColors.warning, 140),
      _trustItem(Icons.local_shipping_rounded, context.l10n.featureShipping,
          AppColors.info, 210),
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: context.pagePadding,
        child: GlassSurface(
          borderRadius: 20,
          chromaticEdge: true,
          padding: EdgeInsets.symmetric(
              vertical: context.responsive(mobile: 20, desktop: 26),
              horizontal: context.responsive(mobile: 16, desktop: 32)),
          child: context.isMobile
              ? Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 28,
                  runSpacing: 18,
                  children: items,
                )
              : IntrinsicHeight(
                  child: Row(
                    children: [
                      for (int i = 0; i < items.length; i++) ...[
                        if (i > 0)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: VerticalDivider(
                                color: AppColors.border, thickness: 1),
                          ),
                        Expanded(child: items[i]),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _trustItem(final IconData icon, final String text,
          final Color accentColor, final int delayMs) =>
      RevealFade(
        delayMs: delayMs,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.iconMedium + 14,
              height: context.iconMedium + 14,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor,
                    Color.lerp(accentColor, Colors.black, 0.24)!
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: accentColor.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6)),
                ],
              ),
              child: Icon(icon,
                  color: Colors.white, size: context.iconMedium * 0.62),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(text,
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: context.bodySize)),
            ),
          ],
        ),
      );

  /// 6 semtin tamamını değil, ilk ikisini + "ve çevresi" gösterir — akan
  /// şeritteki tek bir çipin devasa büyümesini önler. Tam liste hâlâ
  /// BusinessInfoShowcase / footer'daki konum kartında eksiksiz duruyor.
  String get _shortDeliveryZonesLabel {
    final zones = SaglamSpotCommunication.freeDeliveryZones;
    if (zones.length <= 2) return zones.join(', ');
    return '${zones.take(2).join(', ')} ve çevresi';
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

  Widget _buildProductsHeader() => SliverToBoxAdapter(
        child: Padding(
          padding: context.pagePadding.copyWith(
              top: context.spacingLarge, bottom: context.spacingLarge * 0.6),
          child: SectionHeading(
            eyebrow: context.l10n.showcaseEyebrow,
            title: context.l10n.newCollection,
          ),
        ),
      );

  Widget _buildCategoriesSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: DynamicCategoryChips(
          selected: ref.watch(searchFiltersProvider).category,
          onSelect: (final category) =>
              ref.read(searchFiltersProvider.notifier).setCategory(category),
          padding: EdgeInsets.symmetric(horizontal: context.pagePadding.left),
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
        padding: context.pagePadding,
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
  Widget _buildFooter() => SliverToBoxAdapter(
        child: Container(
          color: AppColors.backgroundDark,
          child: Column(
            children: [
              const HazardStripeBar(),
              Container(
                padding: EdgeInsets.fromLTRB(context.pagePadding.left, 56,
                    context.pagePadding.right, 32),
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 40,
                      runSpacing: 42,
                      children: [
                        SizedBox(
                          width: context.responsive(
                              mobile: double.infinity, desktop: 260),
                          child: Column(
                            crossAxisAlignment: context.isMobile
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.storefront_rounded,
                                      color: AppColors.accentLight, size: 20),
                                  const SizedBox(width: 8),
                                  Text(context.l10n.brand,
                                      style: const TextStyle(
                                          fontFamily: 'Fraunces',
                                          color: Colors.white,
                                          fontSize: 22,
                                          letterSpacing: 3,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                context.l10n.footerDesc,
                                textAlign: context.isMobile
                                    ? TextAlign.center
                                    : TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 13,
                                    height: 1.6),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FooterSocialIcon(
                                      icon: Icons.chat_bubble_outline_rounded,
                                      onTap: SaglamSpotCommunication
                                          .launchWhatsApp),
                                  const SizedBox(width: 10),
                                  FooterSocialIcon(
                                      icon: Icons.camera_alt_outlined,
                                      onTap: SaglamSpotCommunication
                                          .openInstagram),
                                  const SizedBox(width: 10),
                                  FooterSocialIcon(
                                      icon: Icons.facebook,
                                      onTap:
                                          SaglamSpotCommunication.openFacebook),
                                  const SizedBox(width: 10),
                                  FooterSocialIcon(
                                      icon: Icons.call_outlined,
                                      onTap: SaglamSpotCommunication.makeCall),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _footerColumn(context.l10n.explore, {
                          context.l10n.home: () =>
                              NavigationHandler.goToHome(context),
                          context.l10n.collections: () =>
                              NavigationHandler.goToSearch(context),
                          context.l10n.spotProducts: () =>
                              NavigationHandler.goToSpotProducts(context),
                          context.l10n.aboutUs: () =>
                              NavigationHandler.goToAbout(context),
                        }),
                        _footerColumn(context.l10n.contact, {
                          SaglamSpotCommunication.displayPhone:
                              SaglamSpotCommunication.makeCall,
                          context.l10n.whatsappCta:
                              SaglamSpotCommunication.launchWhatsApp,
                          context.l10n.storeAddress:
                              SaglamSpotCommunication.openStoreLocation,
                          context.l10n.sss: () =>
                              NavigationHandler.goToSSS(context),
                        }),
                        SizedBox(
                          width: context.responsive(
                              mobile: double.infinity, desktop: 260),
                          child: const FooterLocationCard(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Container(height: 1, color: Colors.white.withOpacity(0.08)),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 10,
                      children: [
                        Text(context.l10n.allRightsReserved,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.15),
                                fontSize: 10)),
                        Text(
                          context.l10n.footerWarehouseTagline,
                          style: AppTextStyles.microLabel(
                              fontSize: 9.5,
                              letterSpacing: 1.6,
                              color: Colors.white.withOpacity(0.15)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _footerColumn(
          final String title, final Map<String, VoidCallback> items) =>
      SizedBox(
        width: context.responsive(mobile: context.wp(40), desktop: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(),
                style: AppTextStyles.microLabel(
                    fontSize: 11.5,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(height: 25),
            ...items.entries.map((final entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: entry.value,
                    child: Text(entry.key,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 13)),
                  ),
                )),
          ],
        ),
      );
}

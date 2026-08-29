import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/core/theme/app_text_styles.dart';
import 'package:saglamspot/core/theme/catalog_theme.dart';
import 'package:saglamspot/core/widgets/design_system/glass_surface.dart';
import 'package:saglamspot/core/widgets/design_system/hud_corner_frame.dart';
import 'package:saglamspot/core/widgets/design_system/infinite_ticker.dart';
import 'package:saglamspot/core/widgets/design_system/kinetic_beam_skeleton.dart';
import 'package:saglamspot/core/widgets/design_system/tactile_press.dart';
import 'package:saglamspot/core/widgets/google_maps_embed.dart';
import 'package:saglamspot/core/widgets/shimmer_components.dart';
import 'package:saglamspot/features/products/presentation/providers/product_provider.dart';
import '../../../../core/ads/widgets/ad_grid_helper.dart';
import '../../../../core/ads/widgets/adsense_banner.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/util/responsive_utils.dart';
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
import '../widgets/how_it_works_section.dart';
import '../widgets/social_showcase_section.dart';
import '../widgets/testimonials_section.dart';
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
                  _buildHeroBanner(availableProducts),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child:
                            AdsenseBanner(type: AdUnitType.display, height: 250),
                      ),
                    ),
                  _buildRoomsInspirationBanner(),
                  // Sayfanın tam ortasına — canlı Google Haritalar + Açık/
                  // Kapalı durumu, gerçek çalışma saatleri ve iletişim
                  // aksiyonlarıyla, ziyaretçinin "gerçek bir işletme"
                  // olduğumuzu ilk bakışta gördüğü nokta.
                  const SliverToBoxAdapter(child: _VisitMapSection()),
                  const FurnitureTipsSection(),
                  const SocialShowcaseSection(),
                  // --- Önceki tasarımların bölümleri: kaldırılmadı, yeni
                  // vitrin düzeninin altına eklendi. "Popüler Kategoriler"
                  // artık ayrı bir bölüm değil — verisi yukarıdaki "Yaşam
                  // Alanına Göre" panelinde kullanılıyor. ---
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: AdsenseBanner(
                          type: AdUnitType.inArticle, height: 300),
                    ),
                  ),
                  const HowItWorksSection(),
                  _buildArtisanInfo(),
                  const WhyUsSection(),
                  const TestimonialsSection(),
                  _buildStatsSection(),
                  // Sayfanın en altına, footer'dan hemen önce ikinci bir
                  // reklam — kullanıcı sayfanın sonuna kadar geldiğinde de
                  // bir kazanım fırsatı olsun diye.
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: AdsenseBanner(
                          type: AdUnitType.multiplex, height: 250),
                    ),
                  ),
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
                          const TextSpan(text: "Gelmeden Gör, "),
                          TextSpan(
                            text: "Beğenince Gel.",
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
                  "Dükkâna gelmeden önce vitrinimizi gez, istediğini bulunca bize uğra.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: context.captionSize),
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
          child: _HeroBanner(images: _heroImages, featuredPool: featuredPool),
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

    final newCard = _GatewayCard(
      eyebrow: 'SIFIR KOLEKSİYON',
      eyebrowColor: NewCollectionPalette.badgeGreen,
      title: 'Zamansız Parçalar',
      subtitle: 'Hiç kullanılmamış, yeni gibi mobilyalar.',
      count: newCount,
      background: NewCollectionPalette.background,
      cardBorder: NewCollectionPalette.cardBorder,
      heading: NewCollectionPalette.heading,
      body: NewCollectionPalette.body,
      accent: NewCollectionPalette.accent,
      headingFontFamily: NewCollectionPalette.headingFont,
      icon: Icons.chair_rounded,
      buttonLabel: 'Koleksiyonu Gör',
      onTap: () => NavigationHandler.goToNewProducts(context),
    );

    final spotCard = _GatewayCard(
      eyebrow: 'SPOT FIRSATLAR',
      eyebrowColor: SpotPalette.accent,
      title: 'Kullanılmış, Sağlam',
      subtitle: 'İkinci el ama kullanışlı, cebe uygun fiyatlarla.',
      count: spotCount,
      background: SpotPalette.background,
      cardBorder: SpotPalette.cardBorder,
      heading: SpotPalette.heading,
      body: SpotPalette.body,
      accent: SpotPalette.accent,
      headingFontFamily: null,
      icon: Icons.local_offer_rounded,
      buttonLabel: 'Fırsatları Gör',
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

  Widget _buildTrustBar() {
    final items = [
      _trustItem(Icons.volunteer_activism_rounded, context.l10n.featureArtisan),
      _trustItem(Icons.verified_user_rounded, context.l10n.featureDelivery),
      _trustItem(
          Icons.sentiment_very_satisfied_rounded, context.l10n.featureService),
      _trustItem(Icons.local_shipping_rounded, context.l10n.featureShipping),
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

  Widget _trustItem(final IconData icon, final String text) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accent, size: context.iconMedium),
          const SizedBox(width: 10),
          Flexible(
            child: Text(text,
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: context.bodySize)),
          ),
        ],
      );

  /// Sonsuz kayan güven/marka şeridi — referans "Luma & Living" tasarımının
  /// `_buildBrandLogos` bölümünün karşılığı. Uydurma marka isimleri yerine
  /// gerçek güven/hizmet vurgularımızı aynı görsel dille kullanır.
  Widget _buildFeatureTicker() {
    final items = <TickerItem>[
      TickerItem(Icons.verified_rounded, context.l10n.productTrustBadgeVerified),
      TickerItem(Icons.handshake_rounded, context.l10n.productTrustBadgeNegotiate),
      TickerItem(Icons.local_shipping_rounded, context.l10n.productTrustBadgeDelivery),
      // Ücretsiz teslimat gerçek bir vaat, ama sınırsız değil — şeritte
      // genel "teslimat" rozetinin yanına, hangi bölgelerle sınırlı
      // olduğunu netleştiren ayrı bir not ekleniyor (yanlış beklenti
      // oluşmasın diye).
      TickerItem(
        Icons.map_rounded,
        'Ücretsiz teslimat sadece '
        '${SaglamSpotCommunication.freeDeliveryZones.join(', ')} '
        'bölgelerinde geçerlidir',
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
            items: items,
            height: context.responsive(mobile: 64, desktop: 78)),
      ),
    );
  }

  Widget _buildProductsHeader() => SliverToBoxAdapter(
        child: Padding(
          padding: context.pagePadding.copyWith(
              top: context.spacingLarge * 2, bottom: context.spacingLarge),
          child: Column(
            children: [
              Text(context.l10n.showcaseEyebrow,
                  style: AppTextStyles.microLabel(
                      color: AppColors.accent,
                      letterSpacing: 3,
                      fontSize: context.captionSize)),
              const SizedBox(height: 8),
              Text(context.l10n.newCollection,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: context.h2Size,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ],
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

    Widget room(final CategoryMeta meta) => _RoomCard(
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

  Widget _buildStatsSection() {
    final stats = [
      {
        "target": 2.5,
        "decimals": 1,
        "suffix": "K+",
        "label": context.l10n.statHappyCustomer,
        "icon": Icons.people_outline
      },
      {
        "target": 20.0,
        "decimals": 0,
        "suffix": context.l10n.statYearsSuffix,
        "label": context.l10n.statExperience,
        "icon": Icons.workspace_premium_outlined
      },
      {
        "target": 15.0,
        "decimals": 0,
        "suffix": "K+",
        "label": context.l10n.statDelivery,
        "icon": Icons.local_shipping_outlined
      },
      {
        "target": 100.0,
        "decimals": 0,
        "prefix": "%",
        "suffix": "",
        "label": context.l10n.statTrust,
        "icon": Icons.verified_user_outlined
      },
    ];

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: context.hp(8)),
        decoration: BoxDecoration(color: AppColors.backgroundDark),
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
              const _HazardStripeBar(),
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
                                  _FooterSocialIcon(
                                      icon: Icons.chat_bubble_outline_rounded,
                                      onTap: SaglamSpotCommunication
                                          .launchWhatsApp),
                                  const SizedBox(width: 10),
                                  _FooterSocialIcon(
                                      icon: Icons.camera_alt_outlined,
                                      onTap: SaglamSpotCommunication
                                          .openInstagram),
                                  const SizedBox(width: 10),
                                  _FooterSocialIcon(
                                      icon: Icons.facebook,
                                      onTap: SaglamSpotCommunication
                                          .openFacebook),
                                  const SizedBox(width: 10),
                                  _FooterSocialIcon(
                                      icon: Icons.call_outlined,
                                      onTap:
                                          SaglamSpotCommunication.makeCall),
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
                          child: const _FooterLocationCard(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Container(
                        height: 1, color: Colors.white.withOpacity(0.08)),
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
                          "MOBİLYA DEPOSU · İÇERENKÖY / ATAŞEHİR",
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

/// Fabrika/depo levhası hissi veren, ince bir "tehlike şeridi" ayraç —
/// footer ile içerik arasındaki sınırı endüstriyel bir imzayla çizer.
/// Statik desen: bir kez çizilir, animasyon YOK.
class _HazardStripeBar extends StatelessWidget {
  const _HazardStripeBar();

  @override
  Widget build(final BuildContext context) => SizedBox(
        height: 6,
        width: double.infinity,
        child: CustomPaint(painter: _HazardStripePainter()),
      );
}

class _HazardStripePainter extends CustomPainter {
  @override
  void paint(final Canvas canvas, final Size size) {
    const stripeWidth = 18.0;
    final darkPaint = Paint()..color = const Color(0xFF1A120C);
    final lightPaint = Paint()..color = AppColors.accentLight;
    canvas.drawRect(Offset.zero & size, darkPaint);

    final path = Path();
    for (double x = -size.height; x < size.width; x += stripeWidth * 2) {
      path
        ..moveTo(x, size.height)
        ..lineTo(x + size.height, 0)
        ..lineTo(x + size.height + stripeWidth, 0)
        ..lineTo(x + stripeWidth, size.height)
        ..close();
    }
    canvas.drawPath(path, lightPaint);
  }

  @override
  bool shouldRepaint(covariant final CustomPainter oldDelegate) => false;
}

/// CANLI çalışma-saati/konum kartı — e-posta bülten formunun yerini aldı.
/// Gerçek adres + gerçek saatlere göre "Açık şu an / Kapalı" rozetini her
/// dakika yeniden hesaplar (gerçek zamana bağlı, dinamik).
class _FooterLocationCard extends StatefulWidget {
  const _FooterLocationCard();

  @override
  State<_FooterLocationCard> createState() => _FooterLocationCardState();
}

class _FooterLocationCardState extends State<_FooterLocationCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Açık/kapalı rozeti dakikada bir kendini günceller.
    _timer = Timer.periodic(const Duration(minutes: 1), (final _) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final isOpen = SaglamSpotCommunication.isOpenNow;
    final crossAlign =
        context.isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: crossAlign,
      children: [
        Text("KONUM & ÇALIŞMA SAATİ",
            style: AppTextStyles.microLabel(
                fontSize: 11.5,
                letterSpacing: 1.6,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isOpen ? const Color(0xFF6FCF97) : const Color(0xFFE57373),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    isOpen ? "ŞU AN AÇIK" : "ŞU AN KAPALI",
                    style: TextStyle(
                        color: isOpen
                            ? const Color(0xFF9BE3B8)
                            : const Color(0xFFEDA0A0),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                        "· Bugün ${SaglamSpotCommunication.todayHoursLabel}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: SaglamSpotCommunication.openStoreLocation,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 16, color: AppColors.accentLight),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(context.l10n.storeAddress,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.55),
                              fontSize: 12,
                              height: 1.4)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: SaglamSpotCommunication.openStoreLocation,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.18)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.map_outlined, size: 16),
                  label: const Text("Haritada Aç",
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Ana sayfanın ortasındaki büyük "işletme bilgisi" vitrini — gerçek bir
/// Google Haritalar gömmesi, gerçek zamana göre canlı "Açık/Kapalı"
/// rozetiyle, haftalık çalışma saatleriyle, teslimat bölgeleri/otobüs
/// hatlarıyla ve birkaç yumuşakça süzülen mobilya motifiyle sanatsal bir
/// doku katıyor. Rozet dakikada bir kendini günceller.
class _VisitMapSection extends StatefulWidget {
  const _VisitMapSection();

  @override
  State<_VisitMapSection> createState() => _VisitMapSectionState();
}

class _VisitMapSectionState extends State<_VisitMapSection> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (final _) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final isOpen = SaglamSpotCommunication.isOpenNow;
    final mapHeight =
        context.responsive(mobile: 240.0, tablet: 340.0, desktop: 440.0);

    final mapCard = HudCornerFrame(
      armLength: 22,
      inset: 10,
      color: AppColors.accent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.borderRadius(1.4)),
        child: SizedBox(
          height: mapHeight,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: GoogleMapsEmbed(
                  latitude: SaglamSpotCommunication.placeLatitude,
                  longitude: SaglamSpotCommunication.placeLongitude,
                ),
              ),
              Positioned(left: 14, top: 14, child: _LiveOpenBadge(isOpen: isOpen)),
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Material(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: SaglamSpotCommunication.openStoreLocation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.travel_explore_rounded,
                                size: 15, color: Color(0xFF1A1A1A)),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text('Google Haritalar\'da Görüntüle',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A1A1A))),
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

    final infoColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.visitUsEyebrow,
            style: AppTextStyles.microLabel(
                color: AppColors.accentLight,
                letterSpacing: 2,
                fontSize: context.captionSize)),
        const SizedBox(height: 12),
        Text(context.l10n.visitUsHeading,
            style: TextStyle(
                fontFamily: 'Fraunces',
                color: Colors.white,
                fontSize: context.h2Size,
                fontWeight: FontWeight.w600,
                height: 1.2)),
        const SizedBox(height: 14),
        Text(
          SaglamSpotCommunication.workingHours.replaceAll('\n', '   ·   '),
          style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: context.bodySize,
              height: 1.5),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            ElevatedButton.icon(
              onPressed: SaglamSpotCommunication.launchWhatsApp,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              icon: const Icon(Icons.chat_bubble_outline, size: 16),
              label: const Text('WhatsApp'),
            ),
            OutlinedButton.icon(
              onPressed: SaglamSpotCommunication.makeCall,
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              icon: const Icon(Icons.call_outlined, size: 16),
              label: Text(SaglamSpotCommunication.displayPhone),
            ),
            OutlinedButton.icon(
              onPressed: SaglamSpotCommunication.openStoreLocation,
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              icon: const Icon(Icons.north_east, size: 16),
              label: Text(context.l10n.directionsButton),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _visitInfoRow(
                  Icons.local_shipping_outlined,
                  context.l10n.freeDeliveryLabel,
                  SaglamSpotCommunication.freeDeliveryZones.join(', ')),
              const SizedBox(height: 16),
              _visitInfoRow(
                  Icons.directions_bus_outlined,
                  context.l10n.busLinesLabel,
                  SaglamSpotCommunication.getBusLines()
                      .entries
                      .map((final e) => '${e.key}: ${e.value.join(', ')}')
                      .join('\n')),
            ],
          ),
        ),
      ],
    );

    return Container(
      margin: context.sectionPadding,
      padding: EdgeInsets.all(context.responsive(mobile: 20, desktop: 48)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(context.borderRadius(2)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: _FloatingMotifLayer()),
          context.isMobile
              ? Column(children: [mapCard, const SizedBox(height: 28), infoColumn])
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 6, child: mapCard),
                    const SizedBox(width: 40),
                    Expanded(flex: 5, child: infoColumn),
                  ],
                ),
        ],
      ),
    );
  }
}

Widget _visitInfoRow(
        final IconData icon, final String title, final String detail) =>
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.accentLight, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const SizedBox(height: 4),
              Text(detail,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                      height: 1.4)),
            ],
          ),
        ),
      ],
    );

/// Harita üzerine binen, canlı "Açık/Kapalı" rozeti — gerçek zamana göre.
class _LiveOpenBadge extends StatelessWidget {
  const _LiveOpenBadge({required this.isOpen});

  final bool isOpen;

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOpen ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
              ),
            ),
            const SizedBox(width: 7),
            Text(
              isOpen ? 'ŞU AN AÇIK' : 'ŞU AN KAPALI',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: isOpen ? const Color(0xFF2E7D32) : const Color(0xFFC62828)),
            ),
            const SizedBox(width: 6),
            Text('· ${SaglamSpotCommunication.todayHoursLabel}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF5A5A5A), fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

/// Ana sayfadaki "iki kapı" kartı — Sıfır Koleksiyon ve Spot Fırsatlar'ın
/// kendi renk/tipografi kimliğini (bkz. catalog_theme.dart) taşıyan,
/// tıklanınca ilgili sekmeye götüren büyük bir vitrin kartı.
class _GatewayCard extends StatelessWidget {
  const _GatewayCard({
    required this.eyebrow,
    required this.eyebrowColor,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.background,
    required this.cardBorder,
    required this.heading,
    required this.body,
    required this.accent,
    required this.headingFontFamily,
    required this.icon,
    required this.buttonLabel,
    required this.onTap,
  });

  final String eyebrow;
  final Color eyebrowColor;
  final String title;
  final String subtitle;
  final int count;
  final Color background;
  final Color cardBorder;
  final Color heading;
  final Color body;
  final Color accent;
  final String? headingFontFamily;
  final IconData icon;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => TactilePress(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.all(context.responsive(mobile: 24, desktop: 32)),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cardBorder),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.14),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Köşeden taşan renkli "glow" — düz arka plana canlılık
              // katan yumuşak bir radyal gradyan; LayoutBuilder KULLANMAZ
              // (masaüstünde bu kartlar IntrinsicHeight içinde eşit
              // yüksekliğe zorlanıyor, LayoutBuilder orada exception atar).
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(1.15, 1.25),
                      radius: 1.05,
                      colors: [accent.withOpacity(0.22), Colors.transparent],
                    ),
                  ),
                ),
              ),
              // İnce yörünge çizgisi + nokta kümesi: sanatsal, dokusal bir
              // dokunuş. CustomPaint boyutu doğrudan paint(size)'dan alır,
              // LayoutBuilder gerektirmez — bu yüzden IntrinsicHeight ile
              // güvenle bir arada kullanılabilir.
              Positioned.fill(
                child: CustomPaint(painter: _GatewayMotifPainter(accent: accent)),
              ),
              // Katmanlı ikon kompozisyonu: tek soluk ikon yerine, farklı
              // boyut/açı/opaklıkta üç ikon — "koleksiyon" hissi veren bir
              // mini kolaj.
              Positioned(
                right: -22,
                bottom: -22,
                child: Transform.rotate(
                  angle: -0.12,
                  child: Icon(icon, size: 132, color: accent.withOpacity(0.10)),
                ),
              ),
              Positioned(
                right: 34,
                bottom: 8,
                child: Transform.rotate(
                  angle: 0.22,
                  child: Icon(Icons.auto_awesome_rounded,
                      size: 30, color: accent.withOpacity(0.30)),
                ),
              ),
              Positioned(
                top: 14,
                right: 18,
                child: Icon(Icons.circle, size: 8, color: accent.withOpacity(0.24)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(eyebrow,
                      style: AppTextStyles.microLabel(
                          color: eyebrowColor, letterSpacing: 2.4, fontSize: 11)),
                  const SizedBox(height: 12),
                  Text(title,
                      style: TextStyle(
                          fontFamily: headingFontFamily,
                          fontSize: context.responsive(mobile: 22, desktop: 26),
                          fontWeight: FontWeight.w700,
                          color: heading,
                          height: 1.15)),
                  const SizedBox(height: 8),
                  Text(subtitle,
                      style: TextStyle(color: body, fontSize: 13, height: 1.45)),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text('$count ürün',
                            style: TextStyle(
                                color: accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                      ElevatedButton.icon(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 15),
                        label: Text(buttonLabel,
                            style: const TextStyle(
                                fontSize: 12.5, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

/// Kapı kartlarındaki ince yörünge çizgisi + nokta kümesi dokusu. Sabit bir
/// [CustomPainter] — [paint] doğrudan kendi [Size]'ını alır, bir üst
/// widget'tan constraints SORMAZ. Bu yüzden [_GatewayCard]'ın masaüstünde
/// sarıldığı [IntrinsicHeight] ile çakışmaz (bkz. [TactilePress] geçmişi:
/// aynı sebepten LayoutBuilder oradan tamamen kaldırıldı).
class _GatewayMotifPainter extends CustomPainter {
  const _GatewayMotifPainter({required this.accent});

  final Color accent;

  @override
  void paint(final Canvas canvas, final Size size) {
    final arcPaint = Paint()
      ..color = accent.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width * 0.12, size.height * 0.16),
        radius: 30,
      ),
      math.pi * 0.1,
      math.pi * 1.4,
      false,
      arcPaint,
    );

    final dotPaint = Paint()..color = accent.withOpacity(0.26);
    const dots = [
      (dx: 0.86, dy: 0.18, r: 3.2),
      (dx: 0.93, dy: 0.30, r: 2.0),
      (dx: 0.80, dy: 0.10, r: 1.6),
    ];
    for (final d in dots) {
      canvas.drawCircle(
          Offset(size.width * d.dx, size.height * d.dy), d.r, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant final _GatewayMotifPainter oldDelegate) =>
      oldDelegate.accent != accent;
}

/// Sanatsal doku: birkaç dev, çok soluk mobilya/motif ikonu yavaşça
/// yukarı-aşağı süzülüp hafifçe döner — "sihirbaz hareketi" hissi veren,
/// saf dekoratif bir katman. Erişilebilirlik ağacından ve dokunuşlardan
/// hariç tutulur; tek bir [AnimationController] ile sürülür.
class _FloatingMotifLayer extends StatefulWidget {
  const _FloatingMotifLayer();

  @override
  State<_FloatingMotifLayer> createState() => _FloatingMotifLayerState();
}

class _FloatingMotifLayerState extends State<_FloatingMotifLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  static const _motifs = [
    (icon: Icons.auto_awesome, size: 46.0, phase: 0.0, top: 0.06, right: 0.08),
    (icon: Icons.weekend_rounded, size: 96.0, phase: 0.33, top: 0.62, right: -0.03),
    (icon: Icons.chair_rounded, size: 64.0, phase: 0.66, top: 0.12, right: 0.42),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => ExcludeSemantics(
        child: IgnorePointer(
          child: ClipRect(
            child: LayoutBuilder(
              builder: (final context, final constraints) => AnimatedBuilder(
                animation: _controller,
                builder: (final context, final _) {
                  final t = _controller.value;
                  return Stack(
                    children: [
                      for (final m in _motifs)
                        Positioned(
                          top: constraints.maxHeight * m.top +
                              math.sin((t + m.phase) * 2 * math.pi) * 12,
                          right: constraints.maxWidth * m.right,
                          child: Transform.rotate(
                            angle: math.sin((t + m.phase) * 2 * math.pi) * 0.09,
                            child: Icon(m.icon,
                                size: m.size, color: Colors.white.withOpacity(0.05)),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
}

class _RoomCard extends StatefulWidget {
  final String title;
  final String img;
  final String sub;
  final VoidCallback onTap;

  const _RoomCard({
    required this.title,
    required this.img,
    required this.sub,
    required this.onTap,
  });

  @override
  State<_RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<_RoomCard> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          width: context.wp(context.isMobile ? 70 : 25),
          margin: const EdgeInsets.only(right: 20),
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -6.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.borderRadius(2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.22 : 0.08),
                blurRadius: _isHovered ? 24 : 12,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(context.borderRadius(2)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: _isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  child: Image.network(widget.img, fit: BoxFit.cover),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.75),
                          Colors.transparent
                        ]),
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.sub,
                          style: AppTextStyles.microLabel(
                              color: AppColors.accentLight,
                              letterSpacing: 1.4,
                              fontSize: 10)),
                      Text(widget.title,
                          style: TextStyle(
                              fontFamily: 'Fraunces',
                              color: Colors.white,
                              fontSize: context.h3Size,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      AnimatedOpacity(
                        opacity: _isHovered ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(context.l10n.viewButton,
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12)),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded,
                                  size: 14, color: AppColors.primary),
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
        ),
      ),
    );
  }
}

/// Tek parça hero banner arka planı: sayfalanabilir (PageView) fotoğraflar,
/// üzerinde sol/sağ ok düğmeleri ve sayfa noktaları — referans tasarımdaki
/// gibi elle de otomatik de gezilebilir. Sağ altta gerçek bir ürünü tanıtan
/// yüzen kart durur; satın alma değil, ürün detayına yönlendirir.
class _HeroBanner extends StatefulWidget {
  final List<String> images;
  final List<Product> featuredPool;

  const _HeroBanner({required this.images, required this.featuredPool});

  @override
  State<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<_HeroBanner> {
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
                        loadingBuilder: (final c, final child, final progress) =>
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
      child: Icon(Icons.chair_rounded,
          size: 18, color: AppColors.textTertiary));
}

class _FooterSocialIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FooterSocialIcon({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.white.withOpacity(0.08),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, color: Colors.white70, size: 16),
          ),
        ),
      );
}

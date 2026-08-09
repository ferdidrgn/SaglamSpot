import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/core/widgets/shimmer_components.dart';
import 'package:saglamspot/features/products/presentation/providers/product_provider.dart';
import '../../../../core/ads/widgets/adsense_banner.dart';
import '../../../../core/ads/widgets/web_ad_product_card.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/util/responsive_utils.dart';
import '../../../../core/widgets/count_up_on_visible.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../../core/widgets/dynamic_category_chips.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../search/presentation/providers/search_providers.dart';
import '../widgets/furniture_tips_section.dart';
import '../widgets/how_it_works_section.dart';
import '../widgets/newsletter_section.dart';
import '../widgets/popular_categories_showcase.dart';
import '../widgets/testimonials_section.dart';
import '../widgets/why_us_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin, ResponsiveUtils {
  late AnimationController _heroController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _heroController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15))
          ..repeat();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final availableProducts = ref.watch(availableProductsProvider);
    final selectedCategory = ref.watch(searchFiltersProvider).category;

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: productsAsync.when(
        loading: () => const FullPageShimmer(),
        error: (final err, final stack) =>
            Center(child: Text('Ürünler yüklenirken hata oluştu: $err')),
        data: (final _) => Stack(
          children: [
            _buildAnimatedBackground(),
            ResponsiveUtils.maxWidthContainer(
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeroSliderSection(),
                  _buildQuickFeatures(),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: AdsenseBanner(
                          type: AdUnitType.display, height: 250),
                    ),
                  ),
                  _buildCategoriesSection(),
                  PopularCategoriesShowcase(allProducts: availableProducts),
                  SliverToBoxAdapter(
                      child: _buildSectionHeader(
                    context.l10n.newCollection,
                    context.l10n.newCollectionSub,
                    actionLabel: 'Tümünü Gör',
                    onActionTap: () => NavigationHandler.goToSearchWithCategory(
                        context, selectedCategory?.toFirestore()),
                  )),
                  _buildDynamicFeaturedGrid(
                    availableProducts
                        .where((final p) =>
                            selectedCategory == null ||
                            p.category == selectedCategory)
                        .toList(),
                  ),
                  _buildRoomsSection(),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: AdsenseBanner(
                          type: AdUnitType.inArticle, height: 300),
                    ),
                  ),
                  const HowItWorksSection(),
                  _buildArtisanInfo(),
                  _buildVisitSection(),
                  const WhyUsSection(),
                  const TestimonialsSection(),
                  _buildStatsSection(),
                  const FurnitureTipsSection(),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: AdsenseBanner(
                          type: AdUnitType.multiplex, height: 320),
                    ),
                  ),
                  const NewsletterSection(),
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

  Widget _buildDynamicFeaturedGrid(final List availableProducts) {
    final latestTenProducts = availableProducts.take(10).toList();
    // 8 üründe bir reklam kartı — bu küçük vitrin ızgarasında en fazla 1 kez
    // görünür, kullanıcıyı boğmaz.
    final itemCount = latestTenProducts.length +
        (latestTenProducts.length ~/ 8);

    return SliverPadding(
      padding: context.pagePadding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.gridColumns(4),
          mainAxisSpacing: context.gridSpacing,
          crossAxisSpacing: context.gridSpacing,
          childAspectRatio: context.cardAspectRatio(),
        ),
        delegate: SliverChildBuilderDelegate(
          (final context, final index) {
            if (index > 0 && (index + 1) % 9 == 0) {
              return const WebAdProductCard();
            }
            final realIndex = index - (index ~/ 9);
            if (realIndex >= latestTenProducts.length) {
              return const SizedBox.shrink();
            }
            return CustomProductCard(product: latestTenProducts[realIndex]);
          },
          childCount: itemCount,
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() => AnimatedBuilder(
        animation: _heroController,
        builder: (final context, final child) => CustomPaint(
          painter: _OrbPainter(
            animation: _heroController.value,
            color1: context.primaryColor.withOpacity(0.05),
            color2: context.colors.secondary.withOpacity(0.03),
          ),
          child: const SizedBox.expand(),
        ),
      );

  static const List<String> _heroImages = [
    "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1600",
    "https://images.unsplash.com/photo-1581539250439-c96689b516dd?q=80&w=1600",
    "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1600",
  ];

  Widget _buildHeroSliderSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: context.hp(context.isMobile ? 52 : 66),
        margin: context.pagePadding,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.borderRadius(1.5)),
          child: Stack(
            children: [
              // Video hissi veren, gerçek video dosyası olmadan çalışan
              // "Ken Burns" arka plan: görseller yavaşça zoom+pan yaparak
              // birbirine crossfade olur, üzerine ince bir toz/ışık katmanı
              // eklenir.
              _KenBurnsHeroBackground(images: _heroImages),
              // Okunabilirlik için sabit, yumuşak bir vinyet.
              IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        AppColors.primaryVariant.withOpacity(0.80),
                        AppColors.primaryVariant.withOpacity(0.32),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ),
              // Başlık ve WhatsApp CTA'sı — hareketli arka planın üzerinde
              // her zaman sabit kalır, animasyondan etkilenmez.
              Padding(
                padding:
                    EdgeInsets.all(context.responsive(mobile: 20, desktop: 60)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              context.responsive(mobile: 10, desktop: 14),
                          vertical:
                              context.responsive(mobile: 5, desktop: 7)),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.accentLight.withOpacity(0.7)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(context.l10n.newSeason,
                          style: TextStyle(
                              color: AppColors.accentLight,
                              letterSpacing: context.isMobile ? 2 : 3,
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  context.responsive(mobile: 9, desktop: 12))),
                    ),
                    const SizedBox(height: 14),
                    Text(context.l10n.heroTitle,
                        style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: context.heroSize * 0.8,
                            height: 1.1)),
                    const SizedBox(height: 8),
                    Text(context.l10n.featureArtisan,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white.withOpacity(0.78),
                            fontStyle: FontStyle.italic,
                            fontSize:
                                context.responsive(mobile: 13, desktop: 16))),
                    SizedBox(height: context.responsive(mobile: 18, desktop: 26)),
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () =>
                              NavigationHandler.goToNewProducts(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: context.responsive(
                                      mobile: 18, desktop: 30),
                                  vertical: context.responsive(
                                      mobile: 12, desktop: 18))),
                          icon: const Icon(Icons.auto_awesome, size: 16),
                          label: Text(context.l10n.conditionNew,
                              style: TextStyle(
                                  fontSize: context.captionSize,
                                  fontWeight: FontWeight.w600)),
                        ),
                        ElevatedButton.icon(
                          onPressed: SaglamSpotCommunication.launchWhatsApp,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: context.responsive(
                                      mobile: 18, desktop: 30),
                                  vertical: context.responsive(
                                      mobile: 12, desktop: 18))),
                          icon: const Icon(Icons.chat_bubble_outline, size: 16),
                          label: Text('WhatsApp\'tan Sor',
                              style: TextStyle(
                                  fontSize: context.captionSize,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Esnaf dükkânı kimliğini yansıtan, sol altta yüzen "cam" rozet
              // — Samimi Esnaflık teması, "Ustanın Notu" hissiyle uyumlu.
              Positioned(
                left: context.responsive(mobile: 16, desktop: 32),
                bottom: context.responsive(mobile: 16, desktop: 32),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.borderRadius(1)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              context.responsive(mobile: 12, desktop: 18),
                          vertical:
                              context.responsive(mobile: 8, desktop: 12)),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius:
                            BorderRadius.circular(context.borderRadius(1)),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.35)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.volunteer_activism_rounded,
                              size: context.iconSmall,
                              color: AppColors.accentLight),
                          const SizedBox(width: 8),
                          Text(context.l10n.featureArtisan,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: context.captionSize)),
                        ],
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
  }

  Widget _buildQuickFeatures() => SliverToBoxAdapter(
        child: Padding(
          padding: context.sectionPadding,
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: context.responsive(mobile: 12, tablet: 20, desktop: 28),
              runSpacing: 14,
              children: [
                _featureItem(Icons.volunteer_activism_rounded,
                    context.l10n.featureArtisan),
                _featureItem(
                    Icons.verified_user_rounded, context.l10n.featureDelivery),
                _featureItem(Icons.sentiment_very_satisfied_rounded,
                    context.l10n.featureService),
                _featureItem(
                    Icons.local_shipping_rounded, context.l10n.featureShipping),
              ],
            ),
          ),
        ),
      );

  // Önceki sürümde düz bir ikon+metin satırıydı; artık yumuşak kenarlıklı,
  // hafif gölgeli bir "hap" kart — diğer premium rozet/etiketlerle
  // tutarlı bir dokunsal dil oluşturuyor.
  Widget _featureItem(final IconData icon, final String text) => Container(
        padding: EdgeInsets.symmetric(
            horizontal: context.responsive(mobile: 12, desktop: 16),
            vertical: context.responsive(mobile: 8, desktop: 10)),
        decoration: BoxDecoration(
          color: context.colors.secondary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: context.primaryColor, size: context.iconMedium),
            const SizedBox(width: 8),
            Text(text,
                style: TextStyle(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: context.bodySize)),
          ],
        ),
      );

  Widget _buildCategoriesSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: DynamicCategoryChips(
          selected: ref.watch(searchFiltersProvider).category,
          onSelect: (final category) => ref
              .read(searchFiltersProvider.notifier)
              .setCategory(category),
          padding: EdgeInsets.symmetric(horizontal: context.pagePadding.left),
        ),
      ),
    );
  }

  Widget _buildRoomsSection() {
    final List<Map<String, dynamic>> rooms = [
      {
        "title": context.l10n.roomLivingRoom,
        "img":
            "https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?q=80&w=800",
        "sub": context.l10n.roomLivingRoomSub,
        "category": ProductCategory.sofa,
      },
      {
        "title": context.l10n.roomBedroom,
        "img":
            "https://images.unsplash.com/photo-1505691723518-36a5ac3be353?q=80&w=800",
        "sub": context.l10n.roomBedroomSub,
        "category": ProductCategory.bed,
      },
      {
        "title": context.l10n.roomKitchen,
        "img":
            "https://images.unsplash.com/photo-1556912178-8f4df6d97a33?q=80&w=800",
        "sub": context.l10n.roomKitchenSub,
        "category": ProductCategory.white,
      },
      {
        "title": context.l10n.roomOffice,
        "img":
            "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=800",
        "sub": context.l10n.roomOfficeSub,
        "category": ProductCategory.table,
      },
    ];

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context.l10n.byRoom, context.l10n.byRoomSub),
          SizedBox(
            height: context.hp(context.isMobile ? 35 : 45),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  EdgeInsets.symmetric(horizontal: context.pagePadding.left),
              itemCount: rooms.length,
              itemBuilder: (final context, final index) => _roomCard(
                  rooms[index]["title"] as String,
                  rooms[index]["img"] as String,
                  rooms[index]["sub"] as String,
                  rooms[index]["category"] as ProductCategory),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roomCard(final String title, final String img, final String sub,
      final ProductCategory category) {
    return _RoomCard(
      title: title,
      img: img,
      sub: sub,
      onTap: () => NavigationHandler.goToSearchWithCategory(
          context, category.toFirestore()),
    );
  }

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

  Widget _buildVisitSection() => SliverToBoxAdapter(
        child: Container(
          margin: context.sectionPadding,
          padding: EdgeInsets.all(context.responsive(mobile: 20, desktop: 48)),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(context.borderRadius(2)),
          ),
          child: Flex(
            direction: context.isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: context.isMobile ? 0 : 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BİZE UĞRA',
                        style: TextStyle(
                            color: AppColors.accentLight,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: context.captionSize)),
                    const SizedBox(height: 12),
                    Text('Bir Selam Ver, Yeter',
                        style: TextStyle(
                            fontFamily: 'Fraunces',
                            color: Colors.white,
                            fontSize: context.h2Size,
                            fontWeight: FontWeight.w600,
                            height: 1.2)),
                    const SizedBox(height: 14),
                    Text(
                      'Kapımız her zaman açık. ${SaglamSpotCommunication.workingHours}',
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
                          label: const Text('Yol Tarifi'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!context.isMobile) const SizedBox(width: 40),
              if (context.isMobile) const SizedBox(height: 28),
              Expanded(
                flex: context.isMobile ? 0 : 4,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _visitInfoRow(Icons.local_shipping_outlined,
                          'Ücretsiz Teslimat',
                          SaglamSpotCommunication.freeDeliveryZones.join(', ')),
                      const SizedBox(height: 16),
                      _visitInfoRow(
                          Icons.directions_bus_outlined,
                          'Otobüs Hatları',
                          SaglamSpotCommunication.getBusLines()
                              .entries
                              .map((final e) => '${e.key}: ${e.value.join(', ')}')
                              .join('\n')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _visitInfoRow(final IconData icon, final String title, final String detail) =>
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
                        color: Colors.white.withOpacity(0.6), fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
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
        "suffix": "+ Yıl",
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
        decoration: const BoxDecoration(color: AppColors.backgroundDark),
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
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(context.borderRadius()),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
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
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _buildFooter() => SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              context.pagePadding.left, 80, context.pagePadding.right, 40),
          color: AppColors.backgroundDark,
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 40,
                runSpacing: 50,
                children: [
                  SizedBox(
                    width: context.responsive(
                        mobile: double.infinity, desktop: 300),
                    child: Column(
                      crossAxisAlignment: context.isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        const Text("SAĞLAM SPOT",
                            style: TextStyle(
                                fontFamily: 'Fraunces',
                                color: Colors.white,
                                fontSize: 24,
                                letterSpacing: 4,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),
                        Text(
                          context.l10n.footerDesc,
                          textAlign: context.isMobile
                              ? TextAlign.center
                              : TextAlign.start,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  _footerColumn(context.l10n.explore, {
                    context.l10n.collections: () =>
                        NavigationHandler.goToSearch(context),
                    context.l10n.spotProducts: () =>
                        NavigationHandler.goToSpotProducts(context),
                  }),
                  _footerColumn(context.l10n.corporate, {
                    context.l10n.aboutUs: () =>
                        NavigationHandler.goToAbout(context),
                    'Sıkça Sorulan Sorular': () =>
                        NavigationHandler.goToSSS(context),
                    context.l10n.contact: () =>
                        SaglamSpotCommunication.launchWhatsApp(),
                  }),
                  SizedBox(
                    width: context.responsive(
                        mobile: double.infinity, desktop: 250),
                    child: Column(
                      crossAxisAlignment: context.isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.end,
                      children: [
                        Text(context.l10n.contactUs,
                            style: TextStyle(
                                color: AppColors.accentLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        const SizedBox(height: 10),
                        Text(SaglamSpotCommunication.email,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Text(context.l10n.allRightsReserved,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.15), fontSize: 10)),
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
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            const SizedBox(height: 25),
            ...items.entries.map((final entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: entry.value,
                    child: Text(entry.key,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3), fontSize: 13)),
                  ),
                )),
          ],
        ),
      );

  Widget _buildSectionHeader(final String title, final String sub,
          {final VoidCallback? onActionTap, final String? actionLabel}) =>
      Padding(
        padding: context.pagePadding.copyWith(bottom: 20, top: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: context.h2Size,
                          fontWeight: FontWeight.w600,
                          color: context.primaryColor)),
                  const SizedBox(height: 4),
                  Container(
                      height: 3, width: 40, color: AppColors.accent),
                  const SizedBox(height: 8),
                  Text(sub,
                      style: TextStyle(
                          color: context.primaryColor.withOpacity(0.5),
                          fontSize: context.captionSize)),
                ],
              ),
            ),
            if (onActionTap != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 6),
                child: TextButton.icon(
                  onPressed: onActionTap,
                  style: TextButton.styleFrom(
                    foregroundColor: context.primaryColor,
                    backgroundColor: context.colors.secondary.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.grid_view_rounded, size: 16),
                  label: Text(actionLabel ?? 'Tümünü Gör',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ),
          ],
        ),
      );
}

/// Oda kartı: tıklanınca ilgili kategoriyle arama sayfasına götürür.
/// Web'de fare üzerine gelince görsel hafifçe büyür ve bir "İncele" rozeti
/// belirir — tıklanabilir olduğunu netleştirmek için.
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
                          style: TextStyle(
                              color: AppColors.accentLight,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
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
                            children: const [
                              Text('İncele',
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12)),
                              SizedBox(width: 4),
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

class _OrbPainter extends CustomPainter {
  final double animation;
  final Color color1;
  final Color color2;

  _OrbPainter(
      {required this.animation, required this.color1, required this.color2});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint1 = Paint()
      ..color = color1
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);
    final paint2 = Paint()
      ..color = color2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    canvas.drawCircle(
        Offset(size.width * 0.2 + animation * 40, size.height * 0.3),
        size.width * 0.2,
        paint1);
    canvas.drawCircle(
        Offset(size.width * 0.8 - animation * 30, size.height * 0.7),
        size.width * 0.25,
        paint2);
  }

  @override
  bool shouldRepaint(final _OrbPainter oldDelegate) => true;
}

/// Gerçek bir video dosyası olmadan "video hissi" veren hero arka planı:
/// 2-3 görsel, AnimationController ile yavaşça zoom+pan (Ken Burns efekti)
/// yaparak birbirine crossfade olur. Üzerine çok sübtil, yavaş hareket eden
/// bir ışık/toz parçacığı katmanı eklenir.
class _KenBurnsHeroBackground extends StatefulWidget {
  final List<String> images;

  const _KenBurnsHeroBackground({required this.images});

  @override
  State<_KenBurnsHeroBackground> createState() =>
      _KenBurnsHeroBackgroundState();
}

class _KenBurnsHeroBackgroundState extends State<_KenBurnsHeroBackground>
    with TickerProviderStateMixin {
  // Her görsel ekranda yaklaşık bu kadar kalır (crossfade süresi dahil).
  static const double _secondsPerImage = 9;
  static const double _crossfadeSeconds = 1.6;
  static const List<Alignment> _panTargets = [
    Alignment(-0.35, -0.25),
    Alignment(0.35, 0.3),
    Alignment(0.2, -0.35),
  ];

  late final AnimationController _kenBurnsController;
  late final AnimationController _dustController;

  @override
  void initState() {
    super.initState();
    _kenBurnsController = AnimationController(
      vsync: this,
      duration:
          Duration(seconds: (_secondsPerImage * widget.images.length).round()),
    )..repeat();
    _dustController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 26),
    )..repeat();
  }

  @override
  void dispose() {
    _kenBurnsController.dispose();
    _dustController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final int total = widget.images.length;
    final double segment = 1.0 / total;
    final double fadeFraction = (_crossfadeSeconds / _secondsPerImage).clamp(
        0.0, 0.45);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Toplam animasyon boyunca hiçbir karede tam saydamlık oluşmasın
        // diye altta sabit, koyu bir zemin.
        Container(color: AppColors.primaryVariant),
        AnimatedBuilder(
          animation: _kenBurnsController,
          builder: (final context, final _) {
            final double raw = _kenBurnsController.value;
            return Stack(
              fit: StackFit.expand,
              children: List.generate(total, (final i) {
                final double d =
                    ((raw - i * segment) % 1.0 + 1.0) % 1.0;
                if (d >= segment) {
                  return const SizedBox.shrink();
                }
                final double local = (d / segment).clamp(0.0, 1.0);
                double opacity;
                if (local < fadeFraction) {
                  opacity = local / fadeFraction;
                } else if (local > 1 - fadeFraction) {
                  opacity = (1 - local) / fadeFraction;
                } else {
                  opacity = 1.0;
                }
                final double scale = 1.0 + 0.14 * local;
                final Alignment align = Alignment.lerp(
                    Alignment.center, _panTargets[i % _panTargets.length], local)!;
                return Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: scale,
                    alignment: align,
                    child: Image.network(
                      widget.images[i],
                      fit: BoxFit.cover,
                      errorBuilder: (final c, final e, final s) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                );
              }),
            );
          },
        ),
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _dustController,
            builder: (final context, final _) => CustomPaint(
              painter: _DustPainter(progress: _dustController.value),
            ),
          ),
        ),
      ],
    );
  }
}

/// Sabit bir tohumla üretilmiş, sayfa her yeniden çizildiğinde aynı kalan
/// parçacık koordinatları — hafif yukarı sürüklenen, çok düşük opasiteli
/// ışık/toz efekti.
class _DustParticle {
  final double x;
  final double y;
  final double radius;
  final double phase;
  final double speed;

  const _DustParticle(
      {required this.x,
      required this.y,
      required this.radius,
      required this.phase,
      required this.speed});
}

final List<_DustParticle> _dustParticles = List.generate(26, (final i) {
  final random = math.Random(i * 97);
  return _DustParticle(
    x: random.nextDouble(),
    y: random.nextDouble(),
    radius: 1.0 + random.nextDouble() * 2.2,
    phase: random.nextDouble(),
    speed: 0.4 + random.nextDouble() * 0.6,
  );
});

class _DustPainter extends CustomPainter {
  final double progress;

  _DustPainter({required this.progress});

  @override
  void paint(final Canvas canvas, final Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

    for (final particle in _dustParticles) {
      final double travel = (particle.y - progress * particle.speed) % 1.0;
      final double y = (travel < 0 ? travel + 1.0 : travel) * size.height;
      final double twinkle =
          0.5 + 0.5 * math.sin(2 * math.pi * (progress * 1.4 + particle.phase));
      final double opacity = 0.05 + 0.07 * twinkle;
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(
          Offset(particle.x * size.width, y), particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(final _DustPainter oldDelegate) => true;
}

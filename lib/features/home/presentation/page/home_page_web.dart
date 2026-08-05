import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/core/widgets/shimmer_components.dart';
import 'package:saglamspot/features/products/presentation/providers/product_provider.dart';
import '../../../../core/ads/widgets/adsense_banner.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/util/responsive_utils.dart';
import '../../../../core/widgets/count_up_on_visible.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../../core/widgets/dynamic_category_chips.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../search/presentation/providers/search_providers.dart';
import '../widgets/furniture_tips_section.dart';
import '../widgets/newsletter_section.dart';
import '../widgets/testimonials_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin, ResponsiveUtils {
  late AnimationController _heroController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  int _currentHeroPage = 0;
  Timer? _heroTimer;
  final PageController _heroPageController = PageController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _heroController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15))
          ..repeat();
    _floatingController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _startHeroTimer();
  }

  void _startHeroTimer() {
    _heroTimer = Timer.periodic(const Duration(seconds: 6), (final timer) {
      if (mounted && _heroPageController.hasClients) {
        _currentHeroPage = (_currentHeroPage + 1) % 3;
        _heroPageController.animateToPage(_currentHeroPage,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutQuint);
      }
    });
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _heroController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _heroPageController.dispose();
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
                  _buildArtisanInfo(),
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
            final product = latestTenProducts[index];
            return CustomProductCard(product: product);
          },
          childCount: latestTenProducts.length,
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

  Widget _buildHeroSliderSection() {
    const double parallaxRange = 30; // px cinsinden, her iki yönde de güvenli sınır

    return SliverToBoxAdapter(
      child: Container(
        height: context.hp(context.isMobile ? 50 : 65),
        margin: context.pagePadding,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.borderRadius(1.5)),
          child: AnimatedBuilder(
            animation: _scrollController,
            builder: (final context, final child) {
              // Parallax: hero görseli sayfa kaydırmasına göre hafifçe,
              // güvenli (±30px) bir aralıkta sürükleniyor — derinlik hissi
              // veren "scroll-triggered depth" efekti. Görsel, taşma
              // olmaması için baştan +2*parallaxRange kadar büyük tutuluyor.
              final double raw =
                  _scrollController.hasClients ? _scrollController.offset : 0;
              final double drift =
                  (raw * 0.08).clamp(-parallaxRange, parallaxRange);
              return Transform.translate(
                offset: Offset(0, drift - parallaxRange),
                child: SizedBox(
                  height: context.hp(context.isMobile ? 50 : 65) +
                      parallaxRange * 2,
                  child: child,
                ),
              );
            },
            child: PageView.builder(
              controller: _heroPageController,
              itemCount: 3,
              itemBuilder: (final context, final index) => _heroSlide(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _heroSlide(final int index) {
    final List<String> images = [
      "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1600",
      "https://images.unsplash.com/photo-1581539250439-c96689b516dd?q=80&w=1600",
      "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1600"
    ];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(images[index]), fit: BoxFit.cover),
      ),
      child: Container(
        padding: EdgeInsets.all(context.responsive(mobile: 20, desktop: 60)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [context.primaryColor.withOpacity(0.8), Colors.transparent],
            begin: Alignment.centerLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.newSeason,
                style: TextStyle(
                    color: context.colors.secondary,
                    letterSpacing: context.isMobile ? 2 : 4,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsive(mobile: 10, desktop: 14))),
            const SizedBox(height: 10),
            Text(context.l10n.heroTitle,
                style: AppTextStyles.webTextTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: context.heroSize * 0.8,
                    height: 1.1)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.secondary,
                  padding: EdgeInsets.symmetric(
                      horizontal: context.responsive(mobile: 20, desktop: 40),
                      vertical: context.responsive(mobile: 12, desktop: 20))),
              child: Text(context.l10n.viewCollection,
                  style: TextStyle(fontSize: context.captionSize)),
            ),
          ],
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
              spacing: context.responsive(mobile: 20, tablet: 40, desktop: 60),
              runSpacing: 20,
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

  Widget _featureItem(final IconData icon, final String text) => Row(
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
                            color: context.colors.secondary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2)),
                    const SizedBox(height: 15),
                    Text(context.l10n.artisanTitle,
                        style: TextStyle(
                            fontSize: context.h2Size,
                            fontWeight: FontWeight.w900,
                            height: 1.2)),
                    const SizedBox(height: 15),
                    Text(context.l10n.artisanDesc,
                        style: TextStyle(
                            color: context.primaryColor.withOpacity(0.6),
                            fontSize: context.bodySize)),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {},
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
            Icon(icon, color: context.colors.secondary, size: 30),
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
                                color: Colors.white,
                                fontSize: 24,
                                letterSpacing: 4,
                                fontWeight: FontWeight.w900)),
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
                  _footerColumn(context.l10n.explore,
                      [context.l10n.collections, context.l10n.spotProducts]),
                  _footerColumn(context.l10n.corporate,
                      [context.l10n.aboutUs, context.l10n.contact]),
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
                                color: context.colors.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        const SizedBox(height: 10),
                        Text("info@saglamspot.com",
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

  Widget _footerColumn(final String title, final List<String> items) =>
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
            ...items.map((final item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(item,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.3), fontSize: 13)),
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
                          fontSize: context.h2Size,
                          fontWeight: FontWeight.w900,
                          color: context.primaryColor)),
                  const SizedBox(height: 4),
                  Container(
                      height: 3, width: 40, color: context.colors.secondary),
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
                              color: context.colors.secondary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                      Text(widget.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: context.h3Size,
                              fontWeight: FontWeight.bold)),
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

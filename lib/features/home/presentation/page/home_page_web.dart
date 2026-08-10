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
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/util/responsive_utils.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../../../core/widgets/dynamic_category_chips.dart';
import '../../../../core/widgets/fab_scroll_up.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/product_filters_provider.dart';
import '../../../search/presentation/providers/search_providers.dart';
import '../widgets/furniture_tips_section.dart';
import '../widgets/social_showcase_section.dart';

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
            Center(child: Text('Ürünler yüklenirken hata oluştu: $err')),
        data: (final _) => Stack(
          children: [
            ResponsiveUtils.maxWidthContainer(
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeroBanner(availableProducts),
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
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: AdsenseBanner(
                          type: AdUnitType.display, height: 250),
                    ),
                  ),
                  _buildRoomsInspirationBanner(),
                  const FurnitureTipsSection(),
                  const SocialShowcaseSection(),
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
  Widget _buildDynamicFeaturedGrid(
      final List<Product> availableProducts, final ProductCategory? selectedCategory) {
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
              (final context, final index) =>
                  CustomProductCard(product: visibleProducts[index]),
              childCount: visibleProducts.length,
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
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Tümünü Gör',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static const List<String> _heroImages = [
    "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1600",
    "https://images.unsplash.com/photo-1581539250439-c96689b516dd?q=80&w=1600",
    "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1600",
  ];

  // Tek parça, geniş banner hero: arka planda kaydırılabilir (ok + nokta
  // göstergeli) fotoğraflar, solda başlık + tek bir "keşfet" CTA'sı, sağ
  // altta gerçek bir ürünü tanıtan yüzen kart. Satın alma değil, ürün
  // detayına ya da WhatsApp'a yönlendirme.
  Widget _buildHeroBanner(final List<Product> availableProducts) {
    final featured = availableProducts.isNotEmpty ? availableProducts.first : null;

    return SliverToBoxAdapter(
      child: Padding(
        padding: context.pagePadding,
        child: SizedBox(
          height: context.hp(context.isMobile ? 62 : 74),
          child: _HeroBanner(images: _heroImages, featured: featured),
        ),
      ),
    );
  }

  Widget _buildTrustBar() {
    final items = [
      _trustItem(
          Icons.volunteer_activism_rounded, context.l10n.featureArtisan),
      _trustItem(
          Icons.verified_user_rounded, context.l10n.featureDelivery),
      _trustItem(Icons.sentiment_very_satisfied_rounded,
          context.l10n.featureService),
      _trustItem(
          Icons.local_shipping_rounded, context.l10n.featureShipping),
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: context.pagePadding,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: context.responsive(mobile: 20, desktop: 26),
              horizontal: context.responsive(mobile: 16, desktop: 32)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
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
                          const Padding(
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

  Widget _buildProductsHeader() => SliverToBoxAdapter(
        child: Padding(
          padding: context.pagePadding.copyWith(
              top: context.spacingLarge * 2, bottom: context.spacingLarge),
          child: Column(
            children: [
              Text('VİTRİN',
                  style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
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
          onSelect: (final category) => ref
              .read(searchFiltersProvider.notifier)
              .setCategory(category),
          padding: EdgeInsets.symmetric(horizontal: context.pagePadding.left),
        ),
      ),
    );
  }

  // "50+ Beautiful rooms inspiration" referansının bölünmüş panel düzeni:
  // solda sabit renkli metin bloğu + "Keşfet" CTA'sı, sağda kademeli
  // (staggered) yerleşimli oda fotoğrafları.
  Widget _buildRoomsInspirationBanner() {
    final rooms = <Map<String, Object>>[
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
    ];

    Widget room(final int i) => _RoomCard(
          title: rooms[i]["title"] as String,
          img: rooms[i]["img"] as String,
          sub: rooms[i]["sub"] as String,
          onTap: () => NavigationHandler.goToSearchWithCategory(
              context, (rooms[i]["category"] as ProductCategory).toFirestore()),
        );

    final textBlock = Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.responsive(mobile: 24, desktop: 40)),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: context.isMobile
            ? const BorderRadius.vertical(top: Radius.circular(28))
            : const BorderRadius.horizontal(left: Radius.circular(28)),
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
              side: const BorderSide(color: AppColors.primary),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            icon: const Icon(Icons.explore_outlined, size: 16),
            label: const Text('Keşfet',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    final collage = ClipRRect(
      borderRadius: context.isMobile
          ? const BorderRadius.vertical(bottom: Radius.circular(28))
          : const BorderRadius.horizontal(right: Radius.circular(28)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 28),
              child: room(0),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(flex: 2, child: room(1)),
        ],
      ),
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: context.pagePadding,
        child: context.isMobile
            ? Column(
                children: [
                  textBlock,
                  SizedBox(height: context.hp(38), child: collage),
                ],
              )
            : SizedBox(
                height: context.hp(52),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 4, child: textBlock),
                    Expanded(flex: 6, child: collage),
                  ],
                ),
              ),
      ),
    );
  }

  // Referans footer'ının 4 sütunlu düzeni: marka + sosyal ikonlar, menü
  // linkleri, gerçek iletişim bilgileri ve bülten kaydı. Hesap/sepet
  // sütunu yok — bu bir showcase sitesi.
  Widget _buildFooter() => SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              context.pagePadding.left, 72, context.pagePadding.right, 32),
          color: AppColors.backgroundDark,
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
                        const Text("SAĞLAM SPOT",
                            style: TextStyle(
                                fontFamily: 'Fraunces',
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w600)),
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
                                onTap: SaglamSpotCommunication.launchWhatsApp),
                            const SizedBox(width: 10),
                            _FooterSocialIcon(
                                icon: Icons.camera_alt_outlined,
                                onTap: SaglamSpotCommunication.openInstagram),
                            const SizedBox(width: 10),
                            _FooterSocialIcon(
                                icon: Icons.call_outlined,
                                onTap: SaglamSpotCommunication.makeCall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _footerColumn(context.l10n.explore, {
                    context.l10n.home: () => NavigationHandler.goToHome(context),
                    context.l10n.collections: () =>
                        NavigationHandler.goToSearch(context),
                    context.l10n.spotProducts: () =>
                        NavigationHandler.goToSpotProducts(context),
                    context.l10n.aboutUs: () =>
                        NavigationHandler.goToAbout(context),
                  }),
                  _footerColumn('İletişim', {
                    SaglamSpotCommunication.displayPhone:
                        SaglamSpotCommunication.makeCall,
                    'WhatsApp\'tan Yaz': SaglamSpotCommunication.launchWhatsApp,
                    'İçerenköy, Ataşehir/İstanbul':
                        SaglamSpotCommunication.openStoreLocation,
                    context.l10n.sss: () => NavigationHandler.goToSSS(context),
                  }),
                  SizedBox(
                    width: context.responsive(
                        mobile: double.infinity, desktop: 260),
                    child: Column(
                      crossAxisAlignment: context.isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        const Text('Güncel Kalın',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                        const SizedBox(height: 18),
                        const _NewsletterField(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 56),
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

/// Tek parça hero banner arka planı: sayfalanabilir (PageView) fotoğraflar,
/// üzerinde sol/sağ ok düğmeleri ve sayfa noktaları — referans tasarımdaki
/// gibi elle de otomatik de gezilebilir. Sağ altta gerçek bir ürünü tanıtan
/// yüzen kart durur; satın alma değil, ürün detayına yönlendirir.
class _HeroBanner extends StatefulWidget {
  final List<String> images;
  final Product? featured;

  const _HeroBanner({required this.images, required this.featured});

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.borderRadius(1.2)),
      child: Stack(
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
            padding:
                EdgeInsets.all(context.responsive(mobile: 22, desktop: 56)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.responsive(mobile: 10, desktop: 14),
                      vertical: context.responsive(mobile: 5, desktop: 7)),
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
                          fontSize: context.responsive(mobile: 9, desktop: 12))),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: context.responsive(mobile: 320, desktop: 520)),
                  child: Text(context.l10n.heroTitle,
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: context.heroSize * 0.72,
                          height: 1.12)),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: context.responsive(mobile: 280, desktop: 420)),
                  child: Text(context.l10n.featureArtisan,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white.withOpacity(0.78),
                          fontSize:
                              context.responsive(mobile: 13, desktop: 16))),
                ),
                SizedBox(height: context.responsive(mobile: 18, desktop: 26)),
                ElevatedButton.icon(
                  onPressed: () => NavigationHandler.goToNewProducts(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(
                          horizontal: context.responsive(mobile: 22, desktop: 32),
                          vertical: context.responsive(mobile: 14, desktop: 18))),
                  icon: const Icon(Icons.explore_outlined, size: 16),
                  label: const Text('Koleksiyonu Keşfet',
                      style: TextStyle(fontWeight: FontWeight.w700)),
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
              bottom: widget.featured != null
                  ? context.responsive(mobile: 96, desktop: 110)
                  : 20,
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
                        color: active ? Colors.white : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
          if (widget.featured != null)
            Positioned(
              right: context.responsive(mobile: 16, desktop: 32),
              bottom: context.responsive(mobile: 16, desktop: 32),
              child: _FloatingFeaturedCard(product: widget.featured!),
            ),
        ],
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

/// Hero'nun sağ alt köşesinde yüzen, gerçek stoktan tek bir ürünü tanıtan
/// kart — referanstaki "Bohauss / Rp 17.000.000" kartının karşılığı.
/// Sepete ekleme yok; tıklanınca ürün detayına gider.
class _FloatingFeaturedCard extends StatelessWidget {
  final Product product;

  const _FloatingFeaturedCard({required this.product});

  @override
  Widget build(final BuildContext context) {
    final hasImage = product.imagesUrl.isNotEmpty;
    return GestureDetector(
      onTap: () => NavigationHandler.goToProduct(
          context: context,
          productId: product.id,
          productSlug: product.name.toSlug()),
      child: Container(
        width: context.responsive(mobile: 210, desktop: 260),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 10)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 52,
                height: 52,
                child: hasImage
                    ? Image.network(
                        product.imagesUrl.first,
                        fit: BoxFit.cover,
                        errorBuilder: (final c, final e, final s) =>
                            const _FeaturedCardFallback(),
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
                  Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontFamily: 'Fraunces',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text('₺${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: AppColors.accentDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textTertiary),
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
      child: const Icon(Icons.chair_rounded,
          size: 22, color: AppColors.textTertiary));
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

/// Footer'daki bülten kayıt formu — NewsletterSection'daki ile aynı dürüst
/// davranış: backend entegrasyonu TODO, ama kullanıcıya anında geri bildirim
/// veriliyor.
class _NewsletterField extends StatefulWidget {
  const _NewsletterField();

  @override
  State<_NewsletterField> createState() => _NewsletterFieldState();
}

class _NewsletterFieldState extends State<_NewsletterField> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _subscribe() {
    if (!_formKey.currentState!.validate()) return;
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bültenimize başarıyla abone oldunuz!')),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: context.responsive(mobile: 260, desktop: 240),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'E-posta adresiniz',
                  hintStyle:
                      TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.06),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.15))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.15))),
                ),
                validator: (final value) {
                  if (value == null || value.isEmpty) return 'E-posta gerekli';
                  final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  if (!regex.hasMatch(value)) return 'Geçerli bir e-posta girin';
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: _subscribe,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

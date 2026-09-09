import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/providers/notification_inbox_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/catalog_theme.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/widgets/design_system/glass_surface.dart';
import '../../../../core/widgets/design_system/hud_corner_frame.dart';
import '../../../../core/widgets/design_system/infinite_ticker.dart';
import '../../../../core/widgets/design_system/reveal_fade.dart';
import '../../../../core/widgets/design_system/tactile_press.dart';
import '../../../../core/widgets/google_maps_embed.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../features/cart/presentation/providers/cart_provider.dart';
import '../../../../features/products/domain/entites/product.dart';
import '../../../../features/products/presentation/providers/category_meta_provider.dart';
import '../../../../features/products/presentation/providers/favorites_provider.dart';
import '../../../../features/products/presentation/providers/product_filters_provider.dart';
import '../../../../shared/navigation/widgets/back_navigation_guards.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// Bu sayfaya özgü marka kimliği — web'in sıcak kahve/krem paletinden
/// BİLİNÇLİ olarak ayrı tutulur: web ve mobil app aynı vitrin değil, iki
/// ayrı deneyim. `AppColors.mobile*` (diğer tüm mobil ekranlarda hâlâ
/// kullanılan) web ile birebir aynı kahve tonun takma adı olduğu için
/// BURADA kullanılmıyor; onun yerine, bu sınıfın da belgelediği "Furnishify"
/// referansındaki adaçayı/sage yeşili kullanılıyor.
class _StorePalette {
  _StorePalette._();
  static Color get primary => AppColors.sage;
  static Color get primaryDark => AppColors.sageDark;
  static Color get primaryLight => AppColors.sageLight;
}

/// Müşteri odaklı, sıfırdan tasarlanmış mobil ana sayfa — "Furnishify"
/// referansından ilham alan sage renk paleti (bkz. [_StorePalette]), arama
/// çubuğu, kategori çipleri ve gerçek Firestore ürünlerinden beslenen bir
/// "Öne Çıkanlar" ızgarası. Eski yönetici panelinin yerini alır; panel
/// artık /admin altında ayrı olarak erişilebilir (bkz. SettingsPage).
class HomeStorePage extends ConsumerWidget {
  const HomeStorePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final available = ref.watch(availableProductsProvider);
    final featured = available.take(8).toList();

    final scaffold = Scaffold(
      backgroundColor: AppColors.mobileBackground,
      bottomNavigationBar: const MobileBottomNav(),
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Referans "Discover" ekranındaki düzen: ince ikon satırı →
                // büyük başlık+alt yazı → kategori hapları → doğrudan liste.
                // Aradaki "Kategoriler" etiketi bilerek yok — hem gerçek
                // referansta öyle, hem de haplar zaten kendini anlatıyor.
                SliverToBoxAdapter(child: _buildTopBar(context, ref)),
                SliverToBoxAdapter(child: _buildDiscoverHeading(context)),
                SliverToBoxAdapter(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _CategoryRow())),
                SliverToBoxAdapter(
                  child: _buildSectionTitle(
                    context,
                    context.l10n.sectionBestSellers,
                    onSeeAll: () => NavigationHandler.goToSearch(context),
                  ),
                ),
                if (featured.isEmpty)
                  SliverToBoxAdapter(child: _buildEmptyCatalogNotice(context))
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.68,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        // Kartlar sayfa açılır açılmaz hepsi birden değil,
                        // kuşak kuşak (cascade) belirir — daha "canlı", mobil
                        // uygulama hissi için.
                        (final context, final index) => RevealFade(
                          delayMs: 60 * (index % 8),
                          child:
                              _ProductGridCard(product: featured[index]),
                        ),
                        childCount: featured.length,
                      ),
                    ),
                  ),
                SliverToBoxAdapter(child: _buildSearchBar(context)),
                const SliverToBoxAdapter(child: _HomeHeroSlider()),
                SliverToBoxAdapter(child: _buildMottoStrip(context)),
                const SliverToBoxAdapter(child: _MobileCatalogGateway()),
                SliverToBoxAdapter(child: _buildFeatureTicker(context)),
                SliverToBoxAdapter(
                    child: _buildSectionTitle(
                        context, context.l10n.visitUsHeading)),
                const SliverToBoxAdapter(child: _MobileBusinessCard()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        ],
      ),
    );

    return kIsWeb ? scaffold : HomeExitGuard(child: scaffold);
  }

  // Referans tasarımdaki gibi ince bir ikon satırı — profil zaten alt
  // navigasyonda var (bkz. MobileBottomNav), burada tekrarlanmıyor.
  // Bildirim zili gerçek okunmamış sayısını, sepet gerçek ürün adedini
  // gösteriyor.
  Widget _buildTopBar(final BuildContext context, final WidgetRef ref) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NotificationBellButton(
              unreadCount: ref.watch(unreadNotificationCountProvider),
              onTap: () => NavigationHandler.goToNotifications(context),
            ),
            _CartIconButton(
              count: ref.watch(cartProvider).length,
              onTap: () => NavigationHandler.goToCart(context),
            ),
          ],
        ),
      );

  Widget _buildDiscoverHeading(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.storeHeroTitle,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 1.15,
                color: AppColors.mobileTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.storeHeroSubtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.mobileTextTertiary,
                height: 1.35,
              ),
            ),
          ],
        ),
      );

  Widget _buildSearchBar(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: TactilePress(
          onTap: () => NavigationHandler.goToSearch(context),
          pressScale: 0.98,
          child: GlassSurface(
            height: 50,
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.search_rounded,
                    color: AppColors.mobileTextTertiary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.searchHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: AppColors.mobileTextTertiary, fontSize: 13.5),
                  ),
                ),
                Icon(Icons.tune_rounded,
                    color: AppColors.mobileTextTertiary, size: 18),
              ],
            ),
          ),
        ),
      );

  /// Bir esnaf uygulamasıyız — vitrin, çevrimiçi mağaza değil. Hero
  /// kaydırıcının hemen altında, kaymayan/sabit bir motto: dükkâna
  /// gelmeden önce vitrini gez, beğendiğinde dükkâna gel.
  Widget _buildMottoStrip(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Icon(Icons.visibility_rounded,
                    size: 20, color: _StorePalette.primary),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.mobileTextPrimary,
                    ),
                    children: [
                      TextSpan(text: context.l10n.mottoTitlePart1),
                      TextSpan(
                        text: context.l10n.mottoTitlePart2,
                        style: TextStyle(color: _StorePalette.primary),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.mottoSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.mobileTextTertiary, fontSize: 11.5),
            ),
          ],
        ),
      );

  /// Sonsuz kayan güven/özellik şeridi — referans tasarımların kayan marka
  /// şeridi motifinin gerçek güven metinleriyle mobil karşılığı.
  Widget _buildFeatureTicker(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        child: InfiniteTicker(
          height: 62,
          items: [
            TickerItem(
                Icons.verified_rounded, context.l10n.productTrustBadgeVerified),
            TickerItem(Icons.handshake_rounded,
                context.l10n.productTrustBadgeNegotiate),
            TickerItem(Icons.local_shipping_rounded,
                context.l10n.productTrustBadgeDelivery),
            TickerItem(Icons.storefront_rounded, context.l10n.sellerTrustLine),
            TickerItem(Icons.workspace_premium_rounded, context.l10n.usp1Title),
            TickerItem(
                Icons.auto_awesome_rounded, context.l10n.qualityFurniture),
          ],
        ),
      );

  Widget _buildSectionTitle(final BuildContext context, final String title,
      {final VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.mobileTextPrimary,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                context.l10n.seeAll,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: _StorePalette.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Ürün ızgarası boşsa (stokta satılabilir ürün yoksa) sessizce hiçbir şey
  // göstermek yerine dürüst, sakin bir bildirim — uydurma ürün/veri YOK.
  Widget _buildEmptyCatalogNotice(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.mobileSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.mobileBorder),
          ),
          child: Column(
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 30, color: _StorePalette.primary),
              const SizedBox(height: 10),
              Text('Şu anda vitrinde ürün yok',
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.mobileTextPrimary)),
              const SizedBox(height: 4),
              Text('Yeni parçalar eklendiğinde burada göreceksiniz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12, color: AppColors.mobileTextTertiary)),
            ],
          ),
        ),
      );
}

/// Otomatik ilerleyen görsel slider — web'deki hero banner'ın (aynı 3
/// fotoğraf, aynı 6 saniyelik döngü) mobil karşılığı. PageView + Timer
/// ile web'deki `_HeroBanner` deseniyle birebir aynı mantığı kullanır.
class _HomeHeroSlider extends StatefulWidget {
  const _HomeHeroSlider();

  static const List<String> _images = [
    'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1200',
    'https://images.unsplash.com/photo-1581539250439-c96689b516dd?q=80&w=1200',
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1200',
  ];

  @override
  State<_HomeHeroSlider> createState() => _HomeHeroSliderState();
}

class _HomeHeroSliderState extends State<_HomeHeroSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (final _) {
      if (!mounted) return;
      final next = (_currentPage + 1) % _HomeHeroSlider._images.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Kullanıcı daha "etkileşimli", daha koyu/canlı bir açılış hissi istedi
  // (referans: koyu yeşil gradyanlı "Make Space For Something Better"
  // kartı). Boy uzatıldı, alt gradyan koyulaştırıldı, büyük kalın başlık
  // eklendi ve artık gerçekten dokunulabilir bir "Keşfet" CTA butonu var
  // (öncesinde bu alan tamamen dekoratifti).
  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
        child: HudCornerFrame(
          armLength: 18,
          inset: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: SizedBox(
              height: 250,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _HomeHeroSlider._images.length,
                    onPageChanged: (final index) =>
                        setState(() => _currentPage = index),
                    itemBuilder: (final context, final index) =>
                        OptimizedCachedImage(
                      imageUrl: _HomeHeroSlider._images[index],
                      height: 250,
                      width: double.infinity,
                      borderRadius: 0,
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              _StorePalette.primaryDark.withOpacity(0.92),
                              _StorePalette.primaryDark.withOpacity(0.55),
                              _StorePalette.primaryDark.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 18,
                    child: IgnorePointer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Text(
                          context.l10n.storeHeroEyebrow,
                          style: AppTextStyles.microLabel(
                            color: Colors.white,
                            fontSize: 10.5,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 66,
                    child: IgnorePointer(
                      child: Text(
                        context.l10n.storeHeroTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 18,
                    child: Row(
                      children: [
                        Expanded(
                          child: TactilePress(
                            onTap: () => NavigationHandler.goToSearch(context),
                            pressScale: 0.97,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    context.l10n.exploreButton,
                                    style: TextStyle(
                                        color: _StorePalette.primaryDark,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(Icons.arrow_forward_rounded,
                                      size: 16,
                                      color: _StorePalette.primaryDark),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            for (int i = 0;
                                i < _HomeHeroSlider._images.length;
                                i++)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.only(left: 5),
                                width: i == _currentPage ? 16 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(
                                      i == _currentPage ? 0.95 : 0.5),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                          ],
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

// Referans tasarımdaki "All / Furniture / Decor / Lighting" hap (pill)
// satırı — önceki ikon-daire+etiket sütunu yerine, tek satırlık, seçili
// olanın dolu (koyu sage) göründüğü bir filtre çipi grubu. "Tümü" dışındaki
// her hap dokununca ilgili kategoriyle arama sayfasına gerçekten götürür
// (önceki davranış korunuyor); seçili görünüm sadece dokunulan hapı yerel
// olarak işaretler.
class _CategoryRow extends ConsumerStatefulWidget {
  @override
  ConsumerState<_CategoryRow> createState() => _CategoryRowState();
}

class _CategoryRowState extends ConsumerState<_CategoryRow> {
  int _selected = 0;

  @override
  Widget build(final BuildContext context) {
    final categories = ref.watch(orderedActiveCategoriesProvider);

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length + 1,
        separatorBuilder: (final _, final __) => const SizedBox(width: 8),
        itemBuilder: (final context, final index) {
          final bool isAll = index == 0;
          final String label = isAll
              ? context.l10n.conditionAll
              : categories[index - 1].customLabel ??
                  categories[index - 1].category.label(context);
          // Referans tasarımdaki gibi her hapın kendi kategori ikonu var —
          // "Tümü" için ızgara ikonu, diğerleri için gerçek CategoryMeta
          // ikonu (aynı ikon web'de de, kategori sayfalarında da kullanılır).
          final IconData icon =
              isAll ? Icons.grid_view_rounded : categories[index - 1].icon;
          final bool isActive = index == _selected;

          return TactilePress(
            onTap: () {
              setState(() => _selected = index);
              if (isAll) {
                NavigationHandler.goToSearch(context);
              } else {
                NavigationHandler.goToSearchWithCategory(
                    context, categories[index - 1].category.name);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    isActive ? _StorePalette.primaryDark : AppColors.mobileSurface,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isActive
                      ? _StorePalette.primaryDark
                      : AppColors.mobileBorder,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon,
                      size: 15,
                      color:
                          isActive ? Colors.white : AppColors.mobileTextSecondary),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color:
                          isActive ? Colors.white : AppColors.mobileTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Referans "Discover the Best Furniture" ekranındaki 2 sütunlu ızgara
/// kartı — büyük görsel üstte, sol üstte durum rozeti (referansta "NEW"
/// yazan kırmızı rozetin karşılığı, ama uydurma değil: gerçekten SIFIR mı
/// yoksa İKİNCİ EL mi, bkz. isSpotProduct), sağ üstte gerçek favori kalbi,
/// altta isim + fiyat + gerçek sepete ekleme düğmesi.
class _ProductGridCard extends ConsumerWidget {
  final Product product;

  const _ProductGridCard({required this.product});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isFavorite =
        ref.watch(favoritesProvider).any((final p) => p.id == product.id);
    final inCart =
        ref.watch(cartProvider).any((final i) => i.product.id == product.id);
    final isNew = !product.isSpotProduct;
    final conditionColor =
        isNew ? NewCollectionPalette.accent : SpotPalette.accent;
    final conditionLabel =
        isNew ? context.l10n.conditionNew : context.l10n.conditionUsed;

    return TactilePress(
      onTap: () => NavigationHandler.goToProduct(
        context: context,
        productId: product.id,
        productSlug: product.name.toSlug(),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mobileSurface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: OptimizedCachedImage(
                      imageUrl: product.imagesUrl.isNotEmpty
                          ? product.imagesUrl.first
                          : '',
                      fit: BoxFit.cover,
                      borderRadius: 0,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: conditionColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        conditionLabel.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(favoritesProvider.notifier).toggle(product),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          shape: BoxShape.circle,
                        ),
                        // Kalp artık sadece renk değiştirmiyor — dokununca
                        // hafifçe "zıplayarak" büyüyüp yerine oturuyor.
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 320),
                          switchInCurve: Curves.elasticOut,
                          switchOutCurve: Curves.easeOut,
                          transitionBuilder: (final child, final animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            key: ValueKey(isFavorite),
                            size: 14,
                            color: isFavorite
                                ? AppColors.error
                                : AppColors.mobileTextSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mobileTextPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.category.label(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 10.5, color: AppColors.mobileTextTertiary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${product.price.toStringAsFixed(0)}₺',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.mobileTextPrimary),
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            ref.read(cartProvider.notifier).toggle(product),
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: inCart
                                ? _StorePalette.primaryDark
                                : _StorePalette.primaryDark.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            inCart
                                ? Icons.shopping_bag_rounded
                                : Icons.add_rounded,
                            size: 14,
                            color: inCart
                                ? Colors.white
                                : _StorePalette.primaryDark,
                          ),
                        ),
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
  }
}

/// Ana sayfa başlığındaki bildirim (bell) ikonu — okunmamış sayısını
/// gösteren kırmızı rozetle. NotificationsPage'e yönlendirir.
class _NotificationBellButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationBellButton(
      {required this.unreadCount, required this.onTap});

  @override
  Widget build(final BuildContext context) => TactilePress(
        onTap: onTap,
        child: GlassSurface(
          width: 44,
          height: 44,
          borderRadius: 22,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Icon(Icons.notifications_none_rounded,
                    color: AppColors.mobileTextPrimary, size: 22),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    constraints:
                        const BoxConstraints(minWidth: 15, minHeight: 15),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}

/// Referans tasarımdaki sağ üst sepet ikonu — gerçek [cartProvider] adedini
/// gösterir (uydurma bir nokta/rozet değil).
class _CartIconButton extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _CartIconButton({required this.count, required this.onTap});

  @override
  Widget build(final BuildContext context) => TactilePress(
        onTap: onTap,
        child: GlassSurface(
          width: 44,
          height: 44,
          borderRadius: 22,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Icon(Icons.shopping_bag_outlined,
                    color: AppColors.mobileTextPrimary, size: 21),
              ),
              if (count > 0)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    constraints:
                        const BoxConstraints(minWidth: 15, minHeight: 15),
                    decoration: BoxDecoration(
                      color: _StorePalette.primaryDark,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}

/// Mobil ana sayfadaki kompakt "işletme bilgisi" kartı — web'deki büyük
/// harita bölümünün tek-sütunlu karşılığı. Gerçek bir harita önizlemesi +
/// gerçek zamana göre canlı "Açık/Kapalı" rozeti (dakikada bir kendini
/// günceller) + WhatsApp/yol tarifi aksiyonları.
class _MobileBusinessCard extends StatefulWidget {
  const _MobileBusinessCard();

  @override
  State<_MobileBusinessCard> createState() => _MobileBusinessCardState();
}

class _MobileBusinessCardState extends State<_MobileBusinessCard> {
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: HudCornerFrame(
        armLength: 18,
        inset: 10,
        color: _StorePalette.primary,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: GoogleMapsEmbed(
                        latitude: SaglamSpotCommunication.placeLatitude,
                        longitude: SaglamSpotCommunication.placeLongitude,
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.16),
                                blurRadius: 8,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isOpen
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFFC62828),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isOpen
                                  ? context.l10n.openNowLabel
                                  : context.l10n.closedNowLabel,
                              style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  color: isOpen
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFC62828)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                color: AppColors.mobileSurface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 16, color: _StorePalette.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(context.l10n.storeAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mobileTextPrimary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                        context.l10n.todayHoursPrefix(
                            SaglamSpotCommunication.todayHoursLabel),
                        style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.mobileTextTertiary)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TactilePress(
                            onTap: SaglamSpotCommunication.launchWhatsApp,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _StorePalette.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text('WhatsApp',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TactilePress(
                            onTap: SaglamSpotCommunication.openStoreLocation,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: _StorePalette.primary),
                              ),
                              child: Center(
                                child: Text(context.l10n.directionsButton,
                                    style: TextStyle(
                                        color: _StorePalette.primary,
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mobil ana sayfadaki "iki kapı" — web'deki dual-gateway kartlarının
/// tek-sütunlu karşılığı. Sıfır Koleksiyon ve Spot Fırsatlar'ın kendi
/// renk kimliğini (bkz. catalog_theme.dart) taşır, canlı ürün sayısı
/// gösterir ve ilgili sekmeye götürür.
class _MobileCatalogGateway extends ConsumerWidget {
  const _MobileCatalogGateway();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final newCount = ref.watch(newDealsProductsProvider).length;
    final spotCount = ref.watch(spotDealsProductsProvider).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _MobileGatewayTile(
              eyebrow: context.l10n.gatewayNewEyebrowShort,
              eyebrowColor: NewCollectionPalette.badgeGreen,
              title: context.l10n.gatewayNewTitleShort,
              count: newCount,
              background: NewCollectionPalette.background,
              border: NewCollectionPalette.cardBorder,
              heading: NewCollectionPalette.heading,
              accent: NewCollectionPalette.accent,
              headingFontFamily: NewCollectionPalette.headingFont,
              icon: Icons.chair_rounded,
              onTap: () => NavigationHandler.goToNewProducts(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _MobileGatewayTile(
              eyebrow: context.l10n.gatewaySpotEyebrowShort,
              eyebrowColor: SpotPalette.accent,
              title: context.l10n.gatewaySpotTitleShort,
              count: spotCount,
              background: SpotPalette.background,
              border: SpotPalette.cardBorder,
              heading: SpotPalette.heading,
              accent: SpotPalette.accent,
              headingFontFamily: null,
              icon: Icons.local_offer_rounded,
              onTap: () => NavigationHandler.goToSpotProducts(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileGatewayTile extends StatelessWidget {
  const _MobileGatewayTile({
    required this.eyebrow,
    required this.eyebrowColor,
    required this.title,
    required this.count,
    required this.background,
    required this.border,
    required this.heading,
    required this.accent,
    required this.headingFontFamily,
    required this.icon,
    required this.onTap,
  });

  final String eyebrow;
  final Color eyebrowColor;
  final String title;
  final int count;
  final Color background;
  final Color border;
  final Color heading;
  final Color accent;
  final String? headingFontFamily;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) => TactilePress(
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -12,
                bottom: -12,
                child: Icon(icon, size: 64, color: accent.withOpacity(0.08)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(eyebrow,
                      style: AppTextStyles.microLabel(
                          color: eyebrowColor,
                          letterSpacing: 1.6,
                          fontSize: 9.5)),
                  const SizedBox(height: 6),
                  Text(title,
                      style: TextStyle(
                          fontFamily: headingFontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: heading)),
                  const SizedBox(height: 10),
                  Text(context.l10n.gatewayProductCount(count),
                      style: TextStyle(
                          color: accent,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ),
      );
}

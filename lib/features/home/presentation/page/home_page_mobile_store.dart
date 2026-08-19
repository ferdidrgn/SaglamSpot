import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/providers/notification_inbox_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/design_system/glass_surface.dart';
import '../../../../core/widgets/design_system/hud_corner_frame.dart';
import '../../../../core/widgets/design_system/infinite_ticker.dart';
import '../../../../core/widgets/design_system/tactile_press.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../features/cart/presentation/providers/cart_provider.dart';
import '../../../../features/products/data/models/category_meta.dart';
import '../../../../features/products/domain/entites/product.dart';
import '../../../../features/products/presentation/providers/category_meta_provider.dart';
import '../../../../features/products/presentation/providers/product_filters_provider.dart';
import '../../../../shared/navigation/widgets/back_navigation_guards.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// Müşteri odaklı, sıfırdan tasarlanmış mobil ana sayfa — "Furnishify"
/// referansından ilham alan teal/sage renk paleti, arama çubuğu,
/// kategori çipleri ve gerçek Firestore ürünlerinden beslenen bir
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
                SliverToBoxAdapter(child: _buildHeader(context, ref)),
                SliverToBoxAdapter(child: _buildSearchBar(context)),
                const SliverToBoxAdapter(child: _HomeHeroSlider()),
                SliverToBoxAdapter(child: _buildFeatureTicker(context)),
                SliverToBoxAdapter(child: _buildSectionTitle(context, context.l10n.sectionCategories)),
                SliverToBoxAdapter(child: _CategoryRow()),
                SliverToBoxAdapter(
                  child: _buildSectionTitle(
                    context,
                    context.l10n.sectionBestSellers,
                    onSeeAll: () => NavigationHandler.goToSearch(context),
                  ),
                ),
                if (featured.isEmpty)
                  const SliverToBoxAdapter(child: SizedBox.shrink())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (final context, final index) =>
                            _ProductCard(product: featured[index]),
                        childCount: featured.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
              ],
            ),
          ),
        ],
      ),
    );

    return kIsWeb ? scaffold : HomeExitGuard(child: scaffold);
  }

  Widget _buildHeader(final BuildContext context, final WidgetRef ref) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                context.l10n.storeHeroTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  color: AppColors.mobileTextPrimary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            _NotificationBellButton(
              unreadCount: ref.watch(unreadNotificationCountProvider),
              onTap: () => NavigationHandler.goToNotifications(context),
            ),
            const SizedBox(width: 10),
            TactilePress(
              onTap: () => NavigationHandler.goToSettings(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.mobilePrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
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
                Icon(Icons.search_rounded, color: AppColors.mobileTextTertiary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.searchHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.mobileTextTertiary, fontSize: 13.5),
                  ),
                ),
                Icon(Icons.tune_rounded, color: AppColors.mobileTextTertiary, size: 18),
              ],
            ),
          ),
        ),
      );

  /// Sonsuz kayan güven/özellik şeridi — referans tasarımların kayan marka
  /// şeridi motifinin gerçek güven metinleriyle mobil karşılığı.
  Widget _buildFeatureTicker(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        child: InfiniteTicker(
          height: 62,
          items: [
            TickerItem(Icons.verified_rounded, context.l10n.productTrustBadgeVerified),
            TickerItem(Icons.handshake_rounded, context.l10n.productTrustBadgeNegotiate),
            TickerItem(Icons.local_shipping_rounded, context.l10n.productTrustBadgeDelivery),
            TickerItem(Icons.storefront_rounded, context.l10n.sellerTrustLine),
            TickerItem(Icons.workspace_premium_rounded, context.l10n.usp1Title),
            TickerItem(Icons.auto_awesome_rounded, context.l10n.qualityFurniture),
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
                  color: AppColors.mobilePrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
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

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
        child: HudCornerFrame(
          armLength: 18,
          inset: 10,
          child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            height: 170,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: _HomeHeroSlider._images.length,
                  onPageChanged: (final index) => setState(() => _currentPage = index),
                  itemBuilder: (final context, final index) => OptimizedCachedImage(
                    imageUrl: _HomeHeroSlider._images[index],
                    height: 170,
                    width: double.infinity,
                    borderRadius: 0,
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            AppColors.mobilePrimaryDark.withOpacity(0.75),
                            AppColors.mobilePrimaryDark.withOpacity(0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.storeHeroEyebrow,
                        style: AppTextStyles.microLabel(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 11,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        context.l10n.storeHeroSubtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 12,
                  child: Row(
                    children: [
                      for (int i = 0; i < _HomeHeroSlider._images.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(left: 5),
                          width: i == _currentPage ? 16 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(i == _currentPage ? 0.95 : 0.5),
                            borderRadius: BorderRadius.circular(3),
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

class _CategoryRow extends ConsumerWidget {
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final categories = ref.watch(orderedActiveCategoriesProvider);

    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (final _, final __) => const SizedBox(width: 14),
        itemBuilder: (final context, final index) {
          final CategoryMeta meta = categories[index];
          return TactilePress(
            onTap: () => NavigationHandler.goToSearchWithCategory(
                context, meta.category.name),
            child: Column(
              children: [
                GlassSurface(
                  width: 56,
                  height: 56,
                  borderRadius: 18,
                  alignment: Alignment.center,
                  child: Icon(meta.icon, color: AppColors.mobilePrimary, size: 24),
                ),
                const SizedBox(height: 6),
                Text(
                  meta.customLabel ?? meta.category.label(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.mobileTextSecondary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final inCart = ref.watch(cartProvider).any((final i) => i.product.id == product.id);
    final meta = defaultCategoryMeta[product.category] ?? defaultCategoryMeta[ProductCategory.other]!;

    return TactilePress(
      onTap: () => NavigationHandler.goToProduct(
        context: context,
        productId: product.id,
        productSlug: product.name.toSlug(),
      ),
      // Kategori renkli "radiant" glow — web'deki CustomProductCard ile
      // aynı canlı dil.
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: meta.color.withOpacity(0.28), blurRadius: 22, spreadRadius: -4, offset: const Offset(0, 10)),
          ],
        ),
        child: GlassSurface(
        borderRadius: 18,
        chromaticEdge: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                    child: OptimizedCachedImage(
                      imageUrl: product.imagesUrl.isNotEmpty ? product.imagesUrl.first : '',
                      fit: BoxFit.cover,
                      borderRadius: 0,
                    ),
                  ),
                  if (!product.isSpotProduct)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.mobileAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          context.l10n.newProductBadge,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: GestureDetector(
                      onTap: () => ref.read(cartProvider.notifier).toggle(product),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          inCart ? Icons.shopping_bag_rounded : Icons.add_rounded,
                          size: 16,
                          color: AppColors.mobilePrimary,
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
                        fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.mobileTextPrimary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${product.price.toStringAsFixed(0)}₺',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.mobilePrimary),
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

/// Ana sayfa başlığındaki bildirim (bell) ikonu — okunmamış sayısını
/// gösteren kırmızı rozetle. NotificationsPage'e yönlendirir.
class _NotificationBellButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationBellButton({required this.unreadCount, required this.onTap});

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
                    constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}

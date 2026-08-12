import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../features/cart/presentation/providers/cart_provider.dart';
import '../../../../features/products/data/models/category_meta.dart';
import '../../../../features/products/domain/entites/product.dart';
import '../../../../features/products/presentation/providers/category_meta_provider.dart';
import '../../../../features/products/presentation/providers/product_filters_provider.dart';
import '../../../../shared/navigation/widgets/mobile_bottom_nav.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// Müşteri odaklı, sıfırdan tasarlanmış mobil ana sayfa — "Furnishify"
/// referansından ilham alan teal/sage renk paleti, arama çubuğu,
/// kategori çipleri ve gerçek Firestore ürünlerinden beslenen bir
/// "Öne Çıkanlar" ızgarası. Eski yönetici panelinin yerini alır; panel
/// artık /admin altında ayrı olarak erişilebilir (bkz. SettingsPage).
class HomeStorePage extends ConsumerWidget {
  const HomeStorePage({super.key});

  static const String _heroImage =
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1200';

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final available = ref.watch(availableProductsProvider);
    final featured = available.take(8).toList();

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      bottomNavigationBar: const MobileBottomNav(),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverToBoxAdapter(child: _buildSearchBar(context)),
            SliverToBoxAdapter(child: _buildHeroBanner(context)),
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
    );
  }

  Widget _buildHeader(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                context.l10n.storeHeroTitle,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  color: AppColors.mobileTextPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () => NavigationHandler.goToSettings(context),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
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
        child: InkWell(
          onTap: () => NavigationHandler.goToSearch(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.mobileCardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.mobileBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.mobileTextTertiary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.searchHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.mobileTextTertiary, fontSize: 13.5),
                  ),
                ),
                const Icon(Icons.tune_rounded, color: AppColors.mobileTextTertiary, size: 18),
              ],
            ),
          ),
        ),
      );

  Widget _buildHeroBanner(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              OptimizedCachedImage(
                imageUrl: _heroImage,
                height: 170,
                width: double.infinity,
                borderRadius: 24,
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
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
              Positioned(
                left: 20,
                right: 20,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.storeHeroEyebrow,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
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
            ],
          ),
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
            style: const TextStyle(
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
                style: const TextStyle(
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
          return GestureDetector(
            onTap: () => NavigationHandler.goToSearchWithCategory(
                context, meta.category.name),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.mobileCardBg,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(meta.icon, color: AppColors.mobilePrimary, size: 24),
                ),
                const SizedBox(height: 6),
                Text(
                  meta.customLabel ?? meta.category.label(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
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

    return GestureDetector(
      onTap: () => NavigationHandler.goToProduct(
        context: context,
        productId: product.id,
        productSlug: product.name.toSlug(),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.mobileBorder),
        ),
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
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.mobileTextPrimary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${product.price.toStringAsFixed(0)}₺',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.mobilePrimary),
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

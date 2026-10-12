import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/catalog_theme.dart';
import '../../../../core/widgets/design_system/atelier_components.dart';
import '../../../../core/widgets/design_system/tactile_press.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../features/products/data/models/category_meta.dart';
import '../../../../features/products/domain/entites/product.dart';
import '../../../../features/products/presentation/providers/category_meta_provider.dart';
import '../../../../features/products/presentation/providers/product_filters_provider.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

String _priceLabel(final Product product) =>
    '${product.price.toStringAsFixed(0)}₺';

String _productImage(final Product product) {
  if (product.studioImagesUrl.isNotEmpty &&
      product.studioImagesUrl.first.isNotEmpty) {
    return product.studioImagesUrl.first;
  }
  return product.imagesUrl.isNotEmpty ? product.imagesUrl.first : '';
}

/// Üst yatay vitrin — gerçek ürünlerden dikey kart şeridi.
class HomeFeaturedProductRail extends StatelessWidget {
  const HomeFeaturedProductRail({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(final BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 236,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl, AppSpacing.md, AppSpacing.xl, 0),
        itemCount: products.length.clamp(0, 10),
        separatorBuilder: (final _, final __) =>
            const SizedBox(width: AppSpacing.md),
        itemBuilder: (final context, final index) {
          final product = products[index];
          return SizedBox(
            width: 148,
            child: TactilePress(
              onTap: () => NavigationHandler.goToProduct(
                context: context,
                productId: product.id,
                productSlug: product.name.toSlug(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: ColoredBox(
                        color: AppColors.mobileSecondaryBg,
                        child: OptimizedCachedImage(
                          imageUrl: _productImage(product),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          borderRadius: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mobileTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _priceLabel(product),
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      color: AppColors.mobileAccentDark,
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

/// Soft “yeni koleksiyon” tanıtım bandı — solda metin, sağda dairesel
/// ürün görseli. Ürün yoksa gizlenir.
class HomeCollectionPromoBanner extends StatelessWidget {
  const HomeCollectionPromoBanner({super.key, this.spotlight});

  final Product? spotlight;

  @override
  Widget build(final BuildContext context) {
    if (spotlight == null) {
      return const SizedBox.shrink();
    }
    final product = spotlight!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.section, AppSpacing.xl, 0),
      child: TactilePress(
        onTap: () => NavigationHandler.goToProduct(
          context: context,
          productId: product.id,
          productSlug: product.name.toSlug(),
        ),
        pressScale: 0.985,
        child: Container(
          height: 132,
          decoration: BoxDecoration(
            color: AppColors.mobileSecondaryBg,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '| ${context.l10n.newCollection}'.toUpperCase(),
                      style: AppTextStyles.microLabel(
                        fontSize: 10,
                        letterSpacing: 1.4,
                        color: AppColors.mobileTextTertiary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.promoHangoutTitle,
                      style: AppTextStyles.serif(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mobileTextPrimary,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.mobileTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.mobileSurface,
                  boxShadow: AppShadows.level2(AppColors.mobilePrimary),
                ),
                clipBehavior: Clip.antiAlias,
                child: OptimizedCachedImage(
                  imageUrl: _productImage(product),
                  fit: BoxFit.cover,
                  borderRadius: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// “Önerilen” yatay liste — sol küçük görsel, sağ ad + fiyat.
class HomeRecommendedStrip extends StatelessWidget {
  const HomeRecommendedStrip({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(final BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AtelierSectionHeader(
          title: context.l10n.sectionRecommended,
          actionLabel: context.l10n.showAllButton,
          onAction: () => NavigationHandler.goToSearch(context),
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, AppSpacing.section, AppSpacing.xl, AppSpacing.sm),
        ),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            itemCount: products.length.clamp(0, 8),
            separatorBuilder: (final _, final __) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (final context, final index) {
              final product = products[index];
              return SizedBox(
                width: 220,
                child: TactilePress(
                  onTap: () => NavigationHandler.goToProduct(
                    context: context,
                    productId: product.id,
                    productSlug: product.name.toSlug(),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.mobileSurface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: AppColors.mobileBorder.withValues(alpha: 0.7),
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: OptimizedCachedImage(
                            imageUrl: _productImage(product),
                            width: 68,
                            height: 68,
                            fit: BoxFit.cover,
                            borderRadius: 0,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                  color: AppColors.mobileTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _priceLabel(product),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.mobileAccentDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Sıfır / Spot büyük tanıtım kartları — gerçek ürün sayısı + örnek görsel.
class HomeTopCollectionPromos extends ConsumerWidget {
  const HomeTopCollectionPromos({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final newProducts = ref.watch(newDealsProductsProvider);
    final spotProducts = ref.watch(spotDealsProductsProvider);
    if (newProducts.isEmpty && spotProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AtelierSectionHeader(
          title: context.l10n.sectionTopCollection,
          actionLabel: context.l10n.showAllButton,
          onAction: () => NavigationHandler.goToDiscover(context),
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, AppSpacing.section, AppSpacing.xl, AppSpacing.sm),
        ),
        if (newProducts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.md),
            child: _CollectionPromoCard(
              eyebrow: context.l10n.gatewayNewEyebrow,
              title: context.l10n.promoNewLivingTitle,
              subtitle: context.l10n.gatewayProductCount(newProducts.length),
              background: NewCollectionPalette.background,
              border: NewCollectionPalette.cardBorder,
              titleColor: NewCollectionPalette.heading,
              eyebrowColor: NewCollectionPalette.badgeGreen,
              imageUrl: _productImage(newProducts.first),
              onTap: () =>
                  NavigationHandler.goToDiscover(context, isSpot: false),
            ),
          ),
        if (spotProducts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl, 0, AppSpacing.xl, 0),
            child: _CollectionPromoCard(
              eyebrow: context.l10n.gatewaySpotEyebrow,
              title: context.l10n.promoSpotLivingTitle,
              subtitle: context.l10n.gatewayProductCount(spotProducts.length),
              background: SpotPalette.background,
              border: SpotPalette.cardBorder,
              titleColor: SpotPalette.heading,
              eyebrowColor: SpotPalette.accent,
              imageUrl: _productImage(spotProducts.first),
              onTap: () =>
                  NavigationHandler.goToDiscover(context, isSpot: true),
              tall: true,
            ),
          ),
      ],
    );
  }
}

class _CollectionPromoCard extends StatelessWidget {
  const _CollectionPromoCard({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.background,
    required this.border,
    required this.titleColor,
    required this.eyebrowColor,
    required this.imageUrl,
    required this.onTap,
    this.tall = false,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Color background;
  final Color border;
  final Color titleColor;
  final Color eyebrowColor;
  final String imageUrl;
  final VoidCallback onTap;
  final bool tall;

  @override
  Widget build(final BuildContext context) {
    return TactilePress(
      onTap: onTap,
      pressScale: 0.985,
      child: Container(
        height: tall ? 168 : 132,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 8, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '| $eyebrow',
                      style: AppTextStyles.microLabel(
                        fontSize: 10,
                        letterSpacing: 1.2,
                        color: eyebrowColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.serif(
                        fontSize: tall ? 20 : 17,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: eyebrowColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: OptimizedCachedImage(
                imageUrl: imageUrl,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                borderRadius: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// İki sütun kategori tanıtımı — en dolu iki kategoriden görsel + etiket.
class HomeCategoryPromoPair extends ConsumerWidget {
  const HomeCategoryPromoPair({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final categories = ref.watch(orderedActiveCategoriesProvider);
    final available = ref.watch(availableProductsProvider);
    if (categories.length < 2 || available.isEmpty) {
      return const SizedBox.shrink();
    }

    // En çok ürünü olan iki kategori — boş tanıtım kartı olmasın.
    final ranked = [...categories]..sort((final a, final b) {
        final ac =
            available.where((final p) => p.category == a.category).length;
        final bc =
            available.where((final p) => p.category == b.category).length;
        return bc.compareTo(ac);
      });
    final pair = ranked.take(2).toList();

    Product? sampleFor(final CategoryMeta meta) {
      for (final p in available) {
        if (p.category == meta.category) {
          return p;
        }
      }
      return null;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.section, AppSpacing.xl, 0),
      child: Row(
        children: [
          for (var i = 0; i < pair.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _CategoryPromoTile(
                meta: pair[i],
                sample: sampleFor(pair[i]),
                subtitle: i == 0
                    ? context.l10n.categoryPromoSubtitleA
                    : context.l10n.categoryPromoSubtitleB,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryPromoTile extends StatelessWidget {
  const _CategoryPromoTile({
    required this.meta,
    required this.sample,
    required this.subtitle,
  });

  final CategoryMeta meta;
  final Product? sample;
  final String subtitle;

  @override
  Widget build(final BuildContext context) {
    final label = meta.customLabel ?? meta.category.label(context);
    return TactilePress(
      onTap: () => NavigationHandler.goToSearchWithCategory(
          context, meta.category.name),
      child: Container(
        height: 148,
        decoration: BoxDecoration(
          color: AppColors.mobileSecondaryBg,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (sample != null)
              OptimizedCachedImage(
                imageUrl: _productImage(sample!),
                fit: BoxFit.cover,
                borderRadius: 0,
              ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.mobilePrimaryDark.withValues(alpha: 0.78),
                    AppColors.mobilePrimaryDark.withValues(alpha: 0.15),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11.5,
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/design_system/tactile_press.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../features/cart/presentation/providers/cart_provider.dart';
import '../../../../features/products/data/models/category_meta.dart';
import '../../../../features/products/domain/entites/product.dart';
import '../../../../features/products/presentation/providers/category_meta_provider.dart';
import '../../../../features/products/presentation/providers/favorites_provider.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

/// Soft welcome row — greeting + circular search, brand colors only.
class HomeWelcomeHeader extends StatelessWidget {
  const HomeWelcomeHeader({super.key});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.homeWelcomeGreeting,
                  style: AppTextStyles.serif(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mobileAccent,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  context.l10n.homeWelcomeTagline,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.35,
                    color: AppColors.mobileTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          TactilePress(
            onTap: () => NavigationHandler.goToSearch(context),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.mobileAccent, width: 1.4),
              ),
              child: Icon(Icons.search_rounded,
                  color: AppColors.mobileAccent, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}

/// Special-pick carousel — lifestyle photos + authentic Sağlam Spot copy
/// (no fake discount percentages).
class HomeSpecialOfferBanner extends StatefulWidget {
  const HomeSpecialOfferBanner({super.key});

  static const List<String> images = [
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1200',
    'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1200',
    'https://images.unsplash.com/photo-1581539250439-c96689b516dd?q=80&w=1200',
  ];

  @override
  State<HomeSpecialOfferBanner> createState() => _HomeSpecialOfferBannerState();
}

class _HomeSpecialOfferBannerState extends State<HomeSpecialOfferBanner> {
  final PageController _controller = PageController();
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (final _) {
      if (!mounted) {
        return;
      }
      final next = (_index + 1) % HomeSpecialOfferBanner.images.length;
      _controller.animateToPage(
        next,
        duration: AppMotion.slow,
        curve: AppMotion.move,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.md, AppSpacing.xl, 0),
      child: Column(
        children: [
          TactilePress(
            onTap: () => NavigationHandler.goToDiscover(context),
            pressScale: 0.985,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: SizedBox(
                height: 168,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _controller,
                      itemCount: HomeSpecialOfferBanner.images.length,
                      onPageChanged: (final i) => setState(() => _index = i),
                      itemBuilder: (final context, final i) => Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: OptimizedCachedImage(
                              imageUrl: HomeSpecialOfferBanner.images[i],
                              height: 168,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              borderRadius: 0,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              color: AppColors.mobileAccent
                                  .withValues(alpha: 0.22),
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    context.l10n.specialOfferLabel,
                                    style: AppTextStyles.microLabel(
                                      color: AppColors.mobileAccentDark,
                                      fontSize: 10,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    context.l10n.specialOfferTitle,
                                    style: AppTextStyles.serif(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.mobileTextPrimary,
                                      height: 1.15,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    context.l10n.specialOfferBody,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      height: 1.35,
                                      color: AppColors.mobileTextSecondary,
                                    ),
                                  ),
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
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(HomeSpecialOfferBanner.images.length,
                (final i) {
              final active = i == _index;
              return AnimatedContainer(
                duration: AppMotion.fast,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 18 : 7,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.mobileAccent
                      : AppColors.mobileMuted.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Horizontal rounded-square category tiles with soft active fill.
class HomeCategoryChips extends ConsumerStatefulWidget {
  const HomeCategoryChips({super.key});

  @override
  ConsumerState<HomeCategoryChips> createState() => _HomeCategoryChipsState();
}

class _HomeCategoryChipsState extends ConsumerState<HomeCategoryChips> {
  int? _selected;

  @override
  Widget build(final BuildContext context) {
    final categories = ref.watch(orderedActiveCategoriesProvider);

    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        itemCount: categories.length,
        separatorBuilder: (final _, final __) =>
            const SizedBox(width: AppSpacing.md),
        itemBuilder: (final context, final index) {
          final CategoryMeta meta = categories[index];
          final selected = _selected == index;
          return TactilePress(
            onTap: () {
              setState(() => _selected = index);
              NavigationHandler.goToSearchWithCategory(
                  context, meta.category.name);
            },
            child: Column(
              children: [
                AnimatedContainer(
                  duration: AppMotion.normal,
                  curve: AppMotion.standard,
                  width: 58,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.mobileAccent
                        : AppColors.mobileAccent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: selected
                          ? AppColors.mobileAccent
                          : AppColors.mobileAccent.withValues(alpha: 0.28),
                    ),
                  ),
                  child: Icon(
                    meta.icon,
                    color: selected
                        ? Colors.white
                        : AppColors.mobileAccentDark,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 64,
                  child: Text(
                    meta.customLabel ?? meta.category.label(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          selected ? FontWeight.w800 : FontWeight.w600,
                      color: AppColors.mobileTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Wide accent "best seller" feature card with product cutout feel.
class HomeBestSellerCard extends ConsumerWidget {
  const HomeBestSellerCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, 0),
      child: TactilePress(
        onTap: () => NavigationHandler.goToProduct(
          context: context,
          productId: product.id,
          productSlug: product.name.toSlug(),
        ),
        pressScale: 0.985,
        child: Container(
          height: 168,
          decoration: BoxDecoration(
            color: AppColors.mobileAccent.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          clipBehavior: Clip.none,
          child: Stack(
            children: [
              Positioned(
                right: -8,
                top: 10,
                bottom: 10,
                width: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: OptimizedCachedImage(
                    imageUrl: product.imagesUrl.isNotEmpty
                        ? product.imagesUrl.first
                        : '',
                    fit: BoxFit.cover,
                    borderRadius: 0,
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 150, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.serif(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mobileTextPrimary,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.category.label(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: AppColors.mobileTextSecondary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.mobileSurface,
                          borderRadius:
                              BorderRadius.circular(AppRadius.pill),
                          boxShadow: AppShadows.level1(
                              AppColors.mobilePrimary),
                        ),
                        child: Text(
                          context.l10n.shopNow,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.mobileTextPrimary,
                          ),
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
    );
  }
}

/// Two-column new-collection product cards with heart + cart actions.
class HomeNewCollectionGrid extends ConsumerWidget {
  const HomeNewCollectionGrid({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, 0),
      child: LayoutBuilder(
        builder: (final context, final constraints) {
          final crossAxisCount = constraints.maxWidth >= 720 ? 3 : 2;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length.clamp(0, crossAxisCount == 3 ? 6 : 4),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.lg,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (final context, final index) =>
                _CollectionCard(product: products[index]),
          );
        },
      ),
    );
  }
}

class _CollectionCard extends ConsumerWidget {
  const _CollectionCard({required this.product});

  final Product product;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isFavorite =
        ref.watch(favoritesProvider).any((final p) => p.id == product.id);
    final inCart =
        ref.watch(cartProvider).any((final i) => i.product.id == product.id);

    return TactilePress(
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
              child: OptimizedCachedImage(
                imageUrl: product.imagesUrl.isNotEmpty
                    ? product.imagesUrl.first
                    : '',
                width: double.infinity,
                fit: BoxFit.cover,
                borderRadius: 0,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: AppColors.mobileAccentDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            product.category.label(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.mobileTextTertiary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${product.price.toStringAsFixed(0)}₺',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.mobileTextPrimary,
                  ),
                ),
              ),
              _RoundAction(
                icon: isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                onTap: () =>
                    ref.read(favoritesProvider.notifier).toggle(product),
              ),
              const SizedBox(width: 6),
              _RoundAction(
                icon: inCart
                    ? Icons.shopping_bag_rounded
                    : Icons.add_rounded,
                onTap: () => ref.read(cartProvider.notifier).toggle(product),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.mobileAccent.withValues(alpha: 0.14),
        ),
        child: Icon(icon, size: 15, color: AppColors.mobileAccentDark),
      ),
    );
  }
}

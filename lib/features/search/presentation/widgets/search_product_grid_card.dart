import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/common/extentions/product_wear_tier_ex.dart';
import '../../../../core/common/extentions/reg_exp_extentions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/catalog_theme.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../../core/services/deeplink/deeplink_service.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../products/data/models/category_meta.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/favorites_provider.dart';

/// Arama sayfasının IZGARA kartı — uygulamanın yeni asimetrik köşe/camsı
/// taban şeridi diliyle (bkz. CustomProductCard) hizalandı: görsel artık
/// kartın tamamını kaplıyor, isim/kategori/fiyat görselin üstündeki camsı
/// bir şeritte. Favori ve paylaş burada GERÇEK işlevli kalmaya devam
/// ediyor (CustomProductCard'ta bilerek yok) — arama sonuçlarında hızlı
/// favorileme beklenen bir davranış.
class SearchProductGridCard extends ConsumerStatefulWidget {
  const SearchProductGridCard({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<SearchProductGridCard> createState() =>
      _SearchProductGridCardState();
}

class _SearchProductGridCardState extends ConsumerState<SearchProductGridCard> {
  bool _isHovered = false;

  static const BorderRadius _shape = BorderRadius.only(
    topLeft: Radius.circular(30),
    topRight: Radius.circular(8),
    bottomLeft: Radius.circular(8),
    bottomRight: Radius.circular(30),
  );

  @override
  Widget build(final BuildContext context) {
    final product = widget.product;
    final meta = defaultCategoryMeta[product.category] ??
        defaultCategoryMeta[ProductCategory.other]!;
    final isFavorite =
        ref.watch(favoritesProvider).any((final p) => p.id == product.id);

    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => NavigationHandler.goToProduct(
            context: context,
            productId: product.id,
            productSlug: product.name.toSlug()),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -3.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: _shape,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.14 : 0.08),
                blurRadius: _isHovered ? 22 : 14,
                offset: Offset(0, _isHovered ? 12 : 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: _shape,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: AppColors.secondary),
                if (product.imagesUrl.isNotEmpty)
                  OptimizedCachedImage(
                    imageUrl: product.imagesUrl.first,
                    fit: BoxFit.cover,
                    borderRadius: 0,
                  )
                else
                  Center(
                      child: Icon(Icons.chair_rounded,
                          size: 36, color: AppColors.textTertiary)),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.72),
                            Colors.transparent
                          ],
                          stops: const [0.0, 0.6],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: _CornerTag(isSpotProduct: product.isSpotProduct),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Column(
                    children: [
                      _RoundGlassButton(
                        icon: isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        iconColor: isFavorite ? SpotPalette.accent : null,
                        onTap: () => ref
                            .read(favoritesProvider.notifier)
                            .toggle(product),
                      ),
                      const SizedBox(height: 6),
                      _RoundGlassButton(
                        icon: Icons.ios_share_rounded,
                        onTap: () => FurnitureShareService.shareProduct(
                          productId: product.id,
                          productName: product.name,
                          price: product.price.toStringAsFixed(0),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontFamily: 'Fraunces',
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(meta.icon, size: 11, color: meta.color),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              product.category.label(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: meta.color,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          if (product.isSpotProduct &&
                              product.wearTier != null) ...[
                            const SizedBox(width: 6),
                            Icon(product.wearTier!.icon,
                                size: 11, color: Colors.white70),
                            const SizedBox(width: 3),
                            Text(product.wearTier!.label,
                                style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '₺${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900),
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

/// Kartın keskin köşesine flush oturan durum etiketi — CustomProductCard'la
/// aynı görsel imza.
class _CornerTag extends StatelessWidget {
  const _CornerTag({required this.isSpotProduct});

  final bool isSpotProduct;

  @override
  Widget build(final BuildContext context) {
    final color =
        isSpotProduct ? SpotPalette.accent : NewCollectionPalette.badgeGreen;
    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 12, 9),
        color: color,
        child: Text(
          (isSpotProduct
                  ? context.l10n.usedProductBadge
                  : context.l10n.productCardNewBadge)
              .toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

/// Görselin üstünde yüzen, buzlu-cam hissi veren yuvarlak ikon butonu —
/// kalp (favori) ve paylaş için.
class _RoundGlassButton extends StatelessWidget {
  const _RoundGlassButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.white.withOpacity(0.85),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(icon, size: 16, color: iconColor ?? AppColors.primary),
          ),
        ),
      );
}

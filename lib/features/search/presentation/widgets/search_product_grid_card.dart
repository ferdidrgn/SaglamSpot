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

/// Search sayfasının IZGARA görünümü için, referans "The Shop" tasarımından
/// esinlenen sade/temiz kart: büyük görsel üstte, kalp (favori) ve paylaş
/// ikonları görselin üstünde — ama ikisi de GERÇEK işlev yapıyor (sahte
/// dekor değil). Altta isim/kategori/fiyat + bizim gerçek rozetlerimiz
/// (Sıfır/İkinci El, yıpranma seviyesi). Yalnızca search sayfasında
/// kullanılır — CustomProductCard (home/new/spot'ta kullanılan paylaşılan
/// kart) BİLEREK değiştirilmedi.
class SearchProductGridCard extends ConsumerStatefulWidget {
  const SearchProductGridCard({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<SearchProductGridCard> createState() =>
      _SearchProductGridCardState();
}

class _SearchProductGridCardState extends ConsumerState<SearchProductGridCard> {
  bool _isHovered = false;

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
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border.withOpacity(0.6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.04),
                blurRadius: _isHovered ? 18 : 10,
                offset: Offset(0, _isHovered ? 10 : 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(17)),
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
                      Positioned(
                        top: 10,
                        left: 10,
                        child: _ConditionPill(
                            isSpotProduct: product.isSpotProduct),
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          color: AppColors.textPrimary,
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
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    if (product.isSpotProduct && product.wearTier != null) ...[
                      const SizedBox(height: 3),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(product.wearTier!.icon,
                              size: 11, color: product.wearTier!.color),
                          const SizedBox(width: 4),
                          Text(product.wearTier!.label,
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: product.wearTier!.color)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      '₺${product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 16,
                          fontWeight: FontWeight.w900),
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

class _ConditionPill extends StatelessWidget {
  const _ConditionPill({required this.isSpotProduct});

  final bool isSpotProduct;

  @override
  Widget build(final BuildContext context) {
    final color =
        isSpotProduct ? SpotPalette.accent : NewCollectionPalette.badgeGreen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isSpotProduct ? Colors.white.withOpacity(0.9) : color,
        borderRadius: BorderRadius.circular(30),
        border: isSpotProduct ? Border.all(color: color, width: 1.2) : null,
      ),
      child: Text(
        isSpotProduct
            ? context.l10n.usedProductBadge
            : context.l10n.productCardNewBadge,
        style: TextStyle(
          color: isSpotProduct ? color : Colors.white,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// Görselin üstünde yüzen, buzlu-cam hissi veren yuvarlak ikon butonu —
/// kalp (favori) ve paylaş için. Referans tasarımdaki kalp/sepet
/// ikonlarının karşılığı, ama GERÇEK işlevle (favorilere ekler/paylaşır).
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

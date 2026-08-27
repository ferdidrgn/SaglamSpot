import 'package:flutter/material.dart';
import '../../features/products/data/models/category_meta.dart';
import '../../features/products/domain/entites/product.dart';
import '../../shared/navigation/widgets/nav_handler.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../common/extentions/product_category_ex.dart';
import '../common/extentions/reg_exp_extentions.dart';
import '../theme/app_colors.dart';
import '../theme/catalog_theme.dart';
import 'optimized_cached_image.dart';

/// Işaret görselindeki liste görünümü için: yatay, geniş, tek satırlık
/// ürün kartı. Işıklık kartla (CustomProductCard) aynı marka dilini
/// (yuvarlak köşe, yumuşak gölge) korur, sadece yerleşimi farklıdır.
class ProductListCard extends StatefulWidget {
  final Product product;

  const ProductListCard({super.key, required this.product});

  @override
  State<ProductListCard> createState() => _ProductListCardState();
}

class _ProductListCardState extends State<ProductListCard> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    final product = widget.product;
    final meta = defaultCategoryMeta[product.category];

    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => NavigationHandler.goToProduct(
          context: context,
          productId: product.id,
          productSlug: product.name.toSlug(),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: const EdgeInsets.only(bottom: 14),
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -3.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(_isHovered ? 0.09 : 0.05),
                  blurRadius: _isHovered ? 22 : 14,
                  offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            children: [
              // Kategori renginde ince bir vurgu şeridi — premium his için.
              Container(
                width: 4,
                height: 96,
                decoration: BoxDecoration(
                  color: meta?.color ?? AppColors.primary,
                  borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(22)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: product.imagesUrl.isNotEmpty
                        ? OptimizedCachedImage(
                            imageUrl: product.imagesUrl.first,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            borderRadius: 0,
                          )
                        : Container(
                            color: AppColors.secondary,
                            child: Icon(Icons.chair_alt_rounded,
                                color: AppColors.textTertiary)),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12).copyWith(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (meta != null) ...[
                            Icon(meta.icon, size: 12, color: meta.color),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            product.category.label(context).toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: meta?.color ?? AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15.5, fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('₺${product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              // Sıfır/Spot vitrinleriyle aynı renk dili
                              // (bkz. catalog_theme.dart) — yeşil/turuncu
                              // ayrımı sitedeki her yerde tutarlı.
                              color: (product.isSpotProduct
                                      ? SpotPalette.accent
                                      : NewCollectionPalette.badgeGreen)
                                  .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.isSpotProduct
                                  ? context.l10n.conditionUsed
                                  : context.l10n.conditionNew,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: product.isSpotProduct
                                    ? SpotPalette.accent
                                    : NewCollectionPalette.badgeGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_rounded,
                    size: 18,
                    color: _isHovered
                        ? AppColors.primary
                        : AppColors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

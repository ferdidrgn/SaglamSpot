import 'package:flutter/material.dart';
import '../../features/products/data/models/category_meta.dart';
import '../../features/products/domain/entites/product.dart';
import '../../shared/navigation/widgets/nav_handler.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../common/extentions/product_category_ex.dart';
import '../common/extentions/reg_exp_extentions.dart';
import '../theme/app_colors.dart';

/// Işaret görselindeki liste görünümü için: yatay, geniş, tek satırlık
/// ürün kartı. Işıklık kartla (CustomProductCard) aynı marka dilini
/// (yuvarlak köşe, yumuşak gölge) korur, sadece yerleşimi farklıdır.
class ProductListCard extends StatelessWidget {
  final Product product;

  const ProductListCard({super.key, required this.product});

  @override
  Widget build(final BuildContext context) {
    final meta = defaultCategoryMeta[product.category];

    return GestureDetector(
      onTap: () => NavigationHandler.goToProduct(
        context: context,
        productId: product.id,
        productSlug: product.name.toSlug(),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 14,
                offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 96,
                height: 96,
                child: product.imagesUrl.isNotEmpty
                    ? Image.network(product.imagesUrl.first, fit: BoxFit.cover)
                    : Container(
                        color: AppColors.secondary,
                        child: const Icon(Icons.chair_alt_rounded,
                            color: AppColors.textTertiary)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
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
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('₺${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary)),
                      const SizedBox(width: 8),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (product.isSpotProduct
                                  ? AppColors.accentDark
                                  : AppColors.success)
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
                                ? AppColors.accentDark
                                : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

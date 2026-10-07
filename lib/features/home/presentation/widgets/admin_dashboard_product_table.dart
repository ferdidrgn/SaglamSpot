import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/pages/edit_product_page.dart';

/// Yönetici listesinin tablo hali. Ürün kartına dokunmaz; aynı süzülmüş
/// listeyi ad, kategori, fiyat ve stok olarak taratır. Satır düzenlemeyi açar.
class AdminProductTable extends StatelessWidget {
  const AdminProductTable({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(final BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded,
                size: 48, color: AppColors.mobileTextTertiary),
            const SizedBox(height: AppSpacing.sm + 2),
            Text(context.l10n.emptyCategoryProducts,
                style: TextStyle(color: AppColors.mobileTextTertiary)),
          ],
        ),
      );
    }

    final wide = context.isDesktop;
    return Column(
      children: [
        _TableHeader(wide: wide),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: AppSpacing.huge),
            itemCount: products.length,
            itemBuilder: (final context, final index) => _TableRow(
              product: products[index],
              wide: wide,
            ),
          ),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.wide});

  final bool wide;

  @override
  Widget build(final BuildContext context) {
    final style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.mobileTextTertiary,
    );
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.mobileBorder)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 56),
          Expanded(flex: 3, child: Text(context.l10n.adminColumnProduct, style: style)),
          if (wide)
            Expanded(flex: 2, child: Text(context.l10n.category, style: style)),
          SizedBox(
            width: wide ? 96 : 72,
            child: Text(context.l10n.price, style: style),
          ),
          SizedBox(
            width: wide ? 88 : 72,
            child: Text(context.l10n.stock, style: style),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.product, required this.wide});

  final Product product;
  final bool wide;

  bool get _incomplete =>
      product.imagesUrl.isEmpty ||
      product.desc.trim().length < 24 ||
      product.price <= 0;

  @override
  Widget build(final BuildContext context) {
    final condition = product.isSpotProduct
        ? context.l10n.conditionUsed
        : context.l10n.conditionNew;
    final details = <String>[
      product.category.label(context),
      condition,
      if (product.dimensions != null && product.dimensions!.trim().isNotEmpty)
        product.dimensions!.trim(),
    ].join(' · ');
    final status = product.isSold
        ? context.l10n.sold
        : product.isReserved
            ? context.l10n.reservedBadge
            : context.l10n.stock;
    final statusColor = product.isSold
        ? AppColors.error
        : product.isReserved
            ? AppColors.info
            : AppColors.success;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (final _) => EditProductPage(
                productId: product.id,
                product: product,
              ),
            ),
          );
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.mobileBorder)),
          ),
          child: Row(
            children: [
              _thumb(),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.mobileTextPrimary,
                            ),
                          ),
                        ),
                        if (_incomplete) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Icon(Icons.error_outline_rounded,
                              size: 16, color: AppColors.warning),
                        ],
                      ],
                    ),
                    Text(
                      details,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.mobileTextTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (wide)
                Expanded(
                  flex: 2,
                  child: Text(
                    product.category.label(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.mobileTextSecondary),
                  ),
                ),
              SizedBox(
                width: wide ? 96 : 72,
                child: Text(
                  '${product.price.toStringAsFixed(0)} ₺',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.mobileTextPrimary,
                  ),
                ),
              ),
              SizedBox(
                width: wide ? 88 : 72,
                child: Text(
                  status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ),
              SizedBox(
                width: 48,
                height: 48,
                child: Icon(Icons.edit_rounded,
                    size: 20, color: AppColors.mobilePrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumb() {
    final url = product.imagesUrl.isEmpty ? null : product.imagesUrl.first;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox(
        width: 48,
        height: 48,
        child: url == null
            ? ColoredBox(
                color: AppColors.secondary,
                child: Icon(Icons.chair_alt_rounded,
                    color: AppColors.mobileTextTertiary),
              )
            : OptimizedCachedImage(imageUrl: url, width: 48, height: 48),
      ),
    );
  }
}

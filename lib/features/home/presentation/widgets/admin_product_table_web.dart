import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../products/data/models/category_meta.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/pages/edit_product_page.dart';
import '../../../products/presentation/providers/product_mutation_provider.dart';

/// Admin panelinin masaüstü (web) ürün listesi — mobildeki
/// `AdminProductGrid` ızgarasının TASARIMI DEĞİŞMEDEN, sadece web
/// varyantı geniş ekranda sıkışık görünmesin diye TicketApp'in
/// `/yonetim` liste tablosuna benzer kompakt bir `DataTable`. Aynı
/// `Product` listesini ve `productMutationProvider`'ı kullanır.
class AdminProductTableWeb extends ConsumerWidget {
  const AdminProductTableWeb({
    super.key,
    required this.products,
    this.selectionMode = false,
    this.selectedIds = const {},
    this.onToggleSelect,
  });

  final List<Product> products;
  final bool selectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String>? onToggleSelect;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 48, color: AppColors.mobileTextTertiary),
            const SizedBox(height: 10),
            Text(context.l10n.emptyCategoryProducts,
                style: TextStyle(color: AppColors.mobileTextTertiary)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: context.screenWidth - 280),
          child: DataTable(
            showCheckboxColumn: selectionMode,
            columnSpacing: 20,
            headingRowHeight: 40,
            dataRowMinHeight: 60,
            dataRowMaxHeight: 68,
            columns: [
              const DataColumn(label: SizedBox(width: 48)),
              DataColumn(label: Text(context.l10n.productNameLabel)),
              DataColumn(label: Text(context.l10n.category)),
              DataColumn(label: Text(context.l10n.price), numeric: true),
              DataColumn(label: Text(context.l10n.statusLabel)),
              const DataColumn(label: SizedBox.shrink()),
            ],
            rows: products
                .map((final p) => _row(context, ref, p))
                .toList(growable: false),
          ),
        ),
      ),
    );
  }

  DataRow _row(
      final BuildContext context, final WidgetRef ref, final Product p) {
    final meta = defaultCategoryMeta[p.category];
    return DataRow(
      selected: selectedIds.contains(p.id),
      onSelectChanged:
          selectionMode ? (final _) => onToggleSelect?.call(p.id) : null,
      cells: [
        DataCell(
          ClipRRect(
            borderRadius: AppRadius.all(AppRadius.xs),
            child: SizedBox(
              width: 40,
              height: 40,
              child: p.imagesUrl.isNotEmpty
                  ? OptimizedCachedImage(
                      imageUrl: p.imagesUrl.first, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.mobileSecondaryBg,
                      child: Icon(Icons.chair_alt_rounded,
                          size: 18, color: AppColors.mobileTextTertiary),
                    ),
            ),
          ),
        ),
        DataCell(Text(p.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (meta != null) ...[
              Icon(meta.icon, size: 14, color: meta.color),
              const SizedBox(width: 6),
            ],
            Text(p.category.label(context),
                style: TextStyle(color: meta?.color ?? AppColors.mobileTextSecondary)),
          ],
        )),
        DataCell(Text('${p.price.toStringAsFixed(0)} ₺')),
        DataCell(_statusChip(context, p)),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!p.isSold)
              IconButton(
                icon: const Icon(Icons.edit_rounded, size: 18),
                color: AppColors.mobilePrimary,
                tooltip: context.l10n.editProductTitle,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (final _) =>
                            EditProductPage(productId: p.id, product: p))),
              ),
            IconButton(
              icon: const Icon(Icons.delete_rounded, size: 18),
              color: AppColors.error,
              tooltip: context.l10n.deleteProductTitle,
              onPressed: () => _confirmDelete(context, ref, p),
            ),
          ],
        )),
      ],
    );
  }

  Widget _statusChip(final BuildContext context, final Product p) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: (p.isSold ? AppColors.mobileAccentDark : AppColors.success)
              .withValues(alpha: 0.14),
          borderRadius: AppRadius.all(AppRadius.pill),
        ),
        child: Text(
          p.isSold ? context.l10n.sold : context.l10n.stock,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: p.isSold ? AppColors.mobileAccentDark : AppColors.success,
          ),
        ),
      );

  void _confirmDelete(
      final BuildContext context, final WidgetRef ref, final Product p) {
    showDialog(
      context: context,
      builder: (final _) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.l10n.deleteProductTitle),
        content: Text('${p.name} ${context.l10n.deleteProductConfirmSuffix}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel)),
          TextButton(
            onPressed: () {
              ref.read(productMutationProvider.notifier).delete(p.id);
              Navigator.pop(context);
            },
            child: Text(context.l10n.yesDelete,
                style: TextStyle(
                    color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

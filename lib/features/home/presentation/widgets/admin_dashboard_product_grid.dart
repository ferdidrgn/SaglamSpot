import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gallery_section.dart';
import '../../../../core/widgets/optimized_cached_image.dart';
import '../../../products/data/models/category_meta.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/pages/edit_product_page.dart';
import '../../../products/presentation/providers/gallery_provider.dart';
import '../../../products/presentation/providers/product_mutation_provider.dart';

/// Yönetici panelindeki "Stok / Satıldı" sekmelerinin ızgarası. Boşsa basit
/// bir bilgi mesajı, doluysa hafif bir giriş animasyonuyla `LuxuryProductCard`
/// listesi gösterir. `AdminDashboardPage`'den taşındı (eskiden `_ProductGrid`).
class AdminProductGrid extends StatelessWidget {
  final List<Product> products;

  const AdminProductGrid({super.key, required this.products});

  @override
  Widget build(final BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded,
                size: 48, color: AppColors.mobileTextTertiary),
            const SizedBox(height: 10),
            Text(context.l10n.emptyCategoryProducts,
                style: TextStyle(color: AppColors.mobileTextTertiary)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // Önceden masaüstünde de sabit 2 sütun kalıyordu (context.gridColumns(2)
        // → isMobile:2, isTablet:3, desktop parametresi=2), yani geniş
        // ekranlarda mobildekiyle AYNI dar ızgara görünüyordu. Varsayılan
        // (4) masaüstünde daha fazla ürünü aynı anda göstererek diğer
        // ürün ızgaralarıyla (bkz. ResponsiveProductGrid) tutarlı hale getirir.
        crossAxisCount: context.gridColumns(),
        childAspectRatio: 0.58,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (final context, final index) {
        return TweenAnimationBuilder<double>(
          key: ValueKey(products[index].id),
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (index % 6) * 60),
          curve: Curves.easeOutCubic,
          builder: (final context, final t, final child) => Opacity(
            opacity: t,
            child: Transform.translate(
                offset: Offset(0, (1 - t) * 16), child: child),
          ),
          child: LuxuryProductCard(product: products[index]),
        );
      },
    );
  }
}

/// Tek bir ürünü gösteren "lüks" kart: görsel + durum rozeti, isim/kategori/
/// fiyat ve düzenle/sil aksiyonları. `AdminDashboardPage`'den taşındı.
class LuxuryProductCard extends ConsumerStatefulWidget {
  final Product product;

  const LuxuryProductCard({super.key, required this.product});

  @override
  ConsumerState<LuxuryProductCard> createState() => _LuxuryProductCardState();
}

class _LuxuryProductCardState extends ConsumerState<LuxuryProductCard> {
  bool _isPressed = false;

  @override
  Widget build(final BuildContext context) {
    final product = widget.product;
    return GestureDetector(
      onTapDown: (final _) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (final _) => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.mobileCardBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: AppColors.mobilePrimary.withOpacity(0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 12)),
              BoxShadow(
                  color: AppColors.mobileTextPrimary.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _ImageArea(product: product)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoArea(product: product),
                    const SizedBox(height: 8),
                    _ActionBar(product: product),
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

class _ImageArea extends ConsumerWidget {
  final Product product;

  const _ImageArea({required this.product});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              ref
                  .read(galleryProvider(product.imagesUrl.length).notifier)
                  .setCurrentIndex(0);
              showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.95),
                builder: (final _) => GalleryViewerDialog(
                    images: product.imagesUrl, isMobile: context.isMobile),
              );
            },
            child: product.imagesUrl.isNotEmpty
                ? OptimizedCachedImage(
                    imageUrl: product.imagesUrl.first, fit: BoxFit.cover)
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: AppColors.mobileSecondaryBg,
                    child: Icon(Icons.chair_alt_rounded,
                        size: 48, color: AppColors.mobileTextTertiary),
                  ),
          ),
          Positioned(top: 10, left: 10, child: _StatusBadge(product: product)),
        ],
      );
}

class _InfoArea extends StatelessWidget {
  final Product product;

  const _InfoArea({required this.product});

  @override
  Widget build(final BuildContext context) {
    final meta = defaultCategoryMeta[product.category];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.mobileTextPrimary),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (meta != null) ...[
              Icon(meta.icon, size: 12, color: meta.color),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                product.category.label(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: meta?.color ?? AppColors.mobileTextSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '${product.price.toStringAsFixed(0)} ₺',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.mobilePrimary),
        ),
      ],
    );
  }
}

class _ActionBar extends ConsumerWidget {
  final Product product;

  const _ActionBar({required this.product});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!product.isSold) ...[
          _actionBtn(
            icon: Icons.edit_rounded,
            color: AppColors.mobilePrimary,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (final _) =>
                      EditProductPage(productId: product.id, product: product),
                )),
          ),
          const SizedBox(width: 8),
        ],
        _actionBtn(
          icon: Icons.delete_rounded,
          color: AppColors.error,
          onTap: () => _confirmDelete(context, ref),
        ),
      ],
    );
  }

  Widget _actionBtn(
      {required final IconData icon,
      required final Color color,
      required final VoidCallback onTap}) {
    return Material(
      color: AppColors.mobileSurface,
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: color.withOpacity(0.35),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }

  void _confirmDelete(final BuildContext context, final WidgetRef ref) {
    showDialog(
      context: context,
      builder: (final _) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(context.l10n.deleteProductTitle),
        content:
            Text('${product.name} ${context.l10n.deleteProductConfirmSuffix}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel)),
          TextButton(
            onPressed: () {
              ref.read(productMutationProvider.notifier).delete(product.id);
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

class _StatusBadge extends StatelessWidget {
  final Product product;

  const _StatusBadge({required this.product});

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: product.isSold
            ? AppColors.mobilePrimaryGradient
            : AppColors.mobileAccentGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        product.isSold ? context.l10n.sold : context.l10n.stock,
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
      ),
    );
  }
}

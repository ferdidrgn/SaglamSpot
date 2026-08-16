import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saglamspot/features/products/domain/entites/product.dart';
import '../../features/products/presentation/providers/category_meta_provider.dart';
import '../common/enum/enums.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../common/extentions/product_category_ex.dart';
import '../common/extentions/reg_exp_extentions.dart';
import '../theme/app_colors.dart';
import '../../shared/navigation/widgets/nav_handler.dart';
import 'gallery_section.dart';

/// EDİTORYAL KATALOG DİLİ — "Sıfır Ürünler" ve "İkinci El" sayfalarına
/// özel, geri kalan uygulamadan (CustomProductCard / DynamicCategoryChips /
/// ProductListCard) bilinçli olarak AYRIŞTIRILMIŞ bir görsel dil: renkli
/// gradyanlı çip yerine düz metin sekmeler, ağır gölge yerine ince tel
/// kenarlık, yuvarlatılmış rozet yerine tek renkli nokta+etiket. Marka
/// renkleri (AppColors) korunuyor — sadece ŞEKİL DİLİ değişiyor.
class EditorialCategoryRail extends ConsumerWidget {
  final ProductCategory? selected;
  final ValueChanged<ProductCategory?> onSelect;
  final String allLabel;
  final EdgeInsets? padding;

  const EditorialCategoryRail({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.allLabel,
    this.padding,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final categories = ref.watch(orderedActiveCategoriesProvider);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding ?? EdgeInsets.symmetric(horizontal: context.pagePadding.left),
        itemCount: categories.length + 1,
        separatorBuilder: (final _, final __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('•', style: TextStyle(color: AppColors.border, fontSize: 13)),
        ),
        itemBuilder: (final context, final index) {
          if (index == 0) {
            return _RailTab(label: allLabel, isSelected: selected == null, onTap: () => onSelect(null));
          }
          final meta = categories[index - 1];
          final label = meta.customLabel ?? meta.category.label(context);
          return _RailTab(
            label: label,
            isSelected: selected == meta.category,
            onTap: () => onSelect(meta.category),
          );
        },
      ),
    );
  }
}

class _RailTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RailTab({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
            color: isSelected ? AppColors.textPrimary : AppColors.textTertiary,
            letterSpacing: 0.2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 2,
                width: isSelected ? 18 : 0,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      );
}

/// Izgara görünümü kartı — kenarlık odaklı, gölgesiz, serif ürün adı.
class EditorialProductCard extends StatefulWidget {
  final Product product;

  const EditorialProductCard({super.key, required this.product});

  @override
  State<EditorialProductCard> createState() => _EditorialProductCardState();
}

class _EditorialProductCardState extends State<EditorialProductCard> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    final hasImage = widget.product.imagesUrl.isNotEmpty;

    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => NavigationHandler.goToProduct(
          context: context,
          productId: widget.product.id,
          productSlug: widget.product.name.toSlug(),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _isHovered
                  ? AppColors.textPrimary.withOpacity(0.45)
                  : AppColors.border,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: AppColors.secondary),
                      Hero(
                        tag: 'prod_img_${widget.product.id}',
                        child: AnimatedScale(
                          scale: _isHovered ? 1.04 : 1.0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          child: hasImage
                              ? Image.network(
                                  widget.product.imagesUrl.first,
                                  fit: BoxFit.cover,
                                  errorBuilder: (final c, final e, final s) =>
                                      const _ImageFallback(),
                                )
                              : const _ImageFallback(),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: AnimatedOpacity(
                          opacity: _isHovered ? 1 : 0,
                          duration: const Duration(milliseconds: 180),
                          child: _RoundGhostButton(
                            icon: Icons.fullscreen_rounded,
                            onTap: () => _openGallery(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.category.label(context).toUpperCase(),
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.product.name,
                      style: GoogleFonts.fraunces(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Text(
                          '₺${widget.product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        _ConditionDot(isSpotProduct: widget.product.isSpotProduct),
                      ],
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

  void _openGallery(final BuildContext context) => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (final context) => GalleryViewerDialog(
            images: widget.product.imagesUrl, isMobile: context.screenWidth < 900),
      );
}

/// Liste görünümü satırı — kart yerine ince ayraçlı, katalog defteri hissi.
class EditorialProductRow extends StatelessWidget {
  final Product product;

  const EditorialProductRow({super.key, required this.product});

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: () => NavigationHandler.goToProduct(
          context: context,
          productId: product.id,
          productSlug: product.name.toSlug(),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 84,
                  height: 84,
                  color: AppColors.secondary,
                  child: product.imagesUrl.isNotEmpty
                      ? Image.network(product.imagesUrl.first, fit: BoxFit.cover)
                      : const _ImageFallback(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category.label(context).toUpperCase(),
                      style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: AppColors.textTertiary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fraunces(
                          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text('₺${product.price.toStringAsFixed(0)}',
                            style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary)),
                        const SizedBox(width: 10),
                        _ConditionDot(isSpotProduct: product.isSpotProduct),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.textTertiary),
            ],
          ),
        ),
      );
}

class _ConditionDot extends StatelessWidget {
  final bool isSpotProduct;
  const _ConditionDot({required this.isSpotProduct});

  @override
  Widget build(final BuildContext context) {
    final color = isSpotProduct ? AppColors.accentDark : AppColors.success;
    final label =
        isSpotProduct ? context.l10n.usedProductBadge : context.l10n.productCardNewBadge;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

class _RoundGhostButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundGhostButton({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.black.withOpacity(0.4),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
        ),
      );
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(final BuildContext context) =>
      Center(child: Icon(Icons.chair_rounded, size: 34, color: AppColors.textTertiary));
}

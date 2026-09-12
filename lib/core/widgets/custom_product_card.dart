import 'package:flutter/material.dart';
import 'package:saglamspot/core/common/extentions/app_context_ui_extension.dart';
import 'package:saglamspot/features/products/domain/entites/product.dart';
import '../../features/products/data/models/category_meta.dart';
import '../../shared/navigation/widgets/nav_handler.dart';
import '../common/enum/enums.dart';
import '../common/extentions/product_category_ex.dart';
import '../common/extentions/reg_exp_extentions.dart';
import '../theme/app_colors.dart';
import '../theme/catalog_theme.dart';
import 'design_system/product_image_switcher.dart';
import 'gallery_section.dart';
import 'optimized_cached_image.dart';

/// "Sakin Vitrin" kartı — kullanıcının paylaştığı referans (sıcak/krem
/// tonlu, sade, bol boşluklu premium mobilya vitrini) doğrultusunda
/// sadeleştirildi: tek tip, geniş yuvarlak köşe; görsel kendi çerçevesinde
/// üstte, isim/kategori/fiyat görselin ÜSTÜNE değil ALTINA, aynı kartın
/// sakin krem/beyaz gövdesine oturuyor. Görsel-üstü yazı, keskin köşe,
/// renkli parıltı gibi "gürültülü" öğeler kasıtlı olarak kaldırıldı.
class CustomProductCard extends StatefulWidget {
  final Product product;

  const CustomProductCard({super.key, required this.product});

  @override
  State<CustomProductCard> createState() => _CustomProductCardState();
}

class _CustomProductCardState extends State<CustomProductCard> {
  bool _isHovered = false;

  static const BorderRadius _shape = BorderRadius.all(Radius.circular(20));

  @override
  Widget build(final BuildContext context) {
    final meta = defaultCategoryMeta[widget.product.category] ??
        defaultCategoryMeta[ProductCategory.other]!;

    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _navigateToProductDetail(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -2.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: _shape,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.09 : 0.05),
                blurRadius: _isHovered ? 22 : 14,
                offset: Offset(0, _isHovered ? 10 : 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
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
                          child: ProductImageSwitcher(
                            images: widget.product.imagesUrl,
                            dotsAtTop: true,
                            imageBuilder: (final url) => OptimizedCachedImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              borderRadius: 0,
                              errorBuilder: (final c, final u, final e) =>
                                  const _ImageFallback(),
                            ),
                            fallback: const _ImageFallback(),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: _ConditionTag(
                            isSpotProduct: widget.product.isSpotProduct),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: _CircleIconButton(
                          icon: Icons.fullscreen_rounded,
                          onTap: () => _openGallery(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.product.category.label(context),
                      style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '₺${widget.product.price.toStringAsFixed(0)}',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
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

  void _navigateToProductDetail(final BuildContext context) =>
      NavigationHandler.goToProduct(
          context: context,
          productId: widget.product.id,
          productSlug: widget.product.name.toSlug());

  void _openGallery(final BuildContext context) => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (final context) => GalleryViewerDialog(
            images: widget.product.imagesUrl,
            isMobile: context.screenWidth < 900),
      );
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(final BuildContext context) => Center(
      child:
          Icon(Icons.chair_rounded, size: 40, color: AppColors.textTertiary));
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.white.withOpacity(0.9),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(icon, color: AppColors.textPrimary, size: 16),
          ),
        ),
      );
}

/// Sade, düz-renk durum etiketi — referanstaki minimal, tek satırlık
/// rozetlerle aynı sakinlikte. Sıfır = yeşil, Spot = turuncu (marka rengi
/// aynı kaldı, sadece görsel-üstü büyük bloktan küçük hap'e döndü).
class _ConditionTag extends StatelessWidget {
  final bool isSpotProduct;
  const _ConditionTag({required this.isSpotProduct});

  @override
  Widget build(final BuildContext context) {
    final Color color =
        isSpotProduct ? SpotPalette.accent : NewCollectionPalette.badgeGreen;
    final String label = isSpotProduct
        ? context.l10n.usedProductBadge
        : context.l10n.productCardNewBadge;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

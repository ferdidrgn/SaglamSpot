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
import 'gallery_section.dart';
import 'optimized_cached_image.dart';

/// Temiz, ferah "vitrin katalog" kartı: fotoğraf üstte, isim/kategori/fiyat
/// altta ayrı bir beyaz blokta — editoryal fotoğraf-üstü-metin stili yerine
/// klasik ürün kataloğu okunabilirliği. Sepete ekleme YOK; hover'da beliren
/// tek eylem "İncele" (ürün detayına gider).
class CustomProductCard extends StatefulWidget {
  final Product product;

  const CustomProductCard({super.key, required this.product});

  @override
  State<CustomProductCard> createState() => _CustomProductCardState();
}

class _CustomProductCardState extends State<CustomProductCard> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    final hasImage = widget.product.imagesUrl.isNotEmpty;
    final meta = defaultCategoryMeta[widget.product.category] ??
        defaultCategoryMeta[ProductCategory.other]!;

    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _navigateToProductDetail(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              // Kategori renkli "radiant" glow — /new ve /spot'taki canlı
              // kart diliyle tutarlı.
              BoxShadow(
                color: meta.color.withOpacity(_isHovered ? 0.42 : 0.24),
                blurRadius: _isHovered ? 32 : 18,
                spreadRadius: -6,
                offset: Offset(0, _isHovered ? 16 : 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.04),
                blurRadius: _isHovered ? 18 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(22)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: AppColors.secondary),
                      Hero(
                        tag: 'prod_img_${widget.product.id}',
                        child: AnimatedScale(
                          scale: _isHovered ? 1.06 : 1.0,
                          duration: const Duration(milliseconds: 450),
                          curve: Curves.easeOutCubic,
                          child: hasImage
                              ? OptimizedCachedImage(
                                  imageUrl: widget.product.imagesUrl.first,
                                  fit: BoxFit.cover,
                                  borderRadius: 0,
                                  errorBuilder: (final c, final u, final e) =>
                                      const _ImageFallback(),
                                )
                              : const _ImageFallback(),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: _ConditionBadge(
                            isSpotProduct: widget.product.isSpotProduct),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: _CircleIconButton(
                          icon: Icons.fullscreen_rounded,
                          onTap: () => _openGallery(context),
                        ),
                      ),
                      // Hover'da beliren, tek ve dürüst eylem: "İncele".
                      // Sahte favori/paylaş ikonları yerine gerçek işlevi
                      // olan tek bir yönlendirme.
                      AnimatedOpacity(
                        opacity: _isHovered ? 1 : 0,
                        duration: const Duration(milliseconds: 220),
                        child: IgnorePointer(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.45),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.65],
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 9),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(context.l10n.viewButton,
                                      style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.5)),
                                  const SizedBox(width: 6),
                                  Icon(Icons.arrow_forward_rounded,
                                      size: 14, color: AppColors.primary),
                                ],
                              ),
                            ),
                          ),
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(meta.icon, size: 11, color: meta.color),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.product.category.label(context),
                            style: TextStyle(
                                color: meta.color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '₺${widget.product.price.toStringAsFixed(0)}',
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
      child: Icon(Icons.chair_rounded, size: 40, color: AppColors.textTertiary));
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.black.withOpacity(0.35),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      );
}

/// "Sıfır" (dolgun/solid) ve "İkinci El" (ince kenarlıklı/outlined) rozet
/// ayrımı — ikinci_sans_furniture prototipinden entegre edildi.
/// `isSpotProduct == true` -> ikinci el/spot ürün.
class _ConditionBadge extends StatelessWidget {
  final bool isSpotProduct;
  const _ConditionBadge({required this.isSpotProduct});

  @override
  Widget build(final BuildContext context) {
    if (!isSpotProduct) {
      // Yeni/Spot vitrinleriyle AYNI renk dili: yeşil = Sıfır Koleksiyon
      // (bkz. NewCollectionPalette.badgeGreen, o sayfadaki "SIFIR"
      // rozetiyle aynı renk) — kullanıcı bu rengi ana sayfadaki "iki kapı"
      // kartından tanıyor.
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: NewCollectionPalette.badgeGreen,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          context.l10n.productCardNewBadge,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      );
    }
    // Turuncu = Spot Fırsatlar (bkz. SpotPalette.accent) — aynı mantıkla,
    // ana sayfadaki "iki kapı" kartındaki turuncuyla aynı.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: SpotPalette.accent, width: 1.2),
      ),
      child: Text(
        context.l10n.usedProductBadge,
        style: TextStyle(
          color: SpotPalette.accent,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

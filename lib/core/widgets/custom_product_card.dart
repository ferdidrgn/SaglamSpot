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

/// "Asimetrik Vitrin Kartı" — uygulamanın YENİ, tek ve tutarlı ürün kartı
/// dili. Eski "fotoğraf üstte / düz beyaz blok altta" kataloğ diline
/// kasıtlı olarak veda edildi: fotoğraf artık kartın TAMAMINI kaplıyor,
/// bilgi camsı bir taban şeritte görselin üstüne oturuyor, köşeler
/// simetrik değil — tek bir köşe (sağ üst) keskin/"kesik", karşı köşe (sol
/// alt) belirgin şekilde yuvarlak. Bu keskin/yuvarlak köşe zıtlığı ve
/// köşeye oturan durum etiketi, uygulamanın her yerinde (ana sayfa, Sıfır/
/// Spot, Keşfet, arama) tekrar eden yeni bir görsel imza. Sepete ekleme
/// YOK; tek dürüst eylem yine ürün detayına gitmek.
class CustomProductCard extends StatefulWidget {
  final Product product;

  const CustomProductCard({super.key, required this.product});

  @override
  State<CustomProductCard> createState() => _CustomProductCardState();
}

class _CustomProductCardState extends State<CustomProductCard> {
  bool _isHovered = false;

  static const BorderRadius _shape = BorderRadius.only(
    topLeft: Radius.circular(8),
    topRight: Radius.circular(34),
    bottomLeft: Radius.circular(34),
    bottomRight: Radius.circular(8),
  );

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
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: _shape,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.10 : 0.06),
                blurRadius: _isHovered ? 26 : 18,
                offset: Offset(0, _isHovered ? 16 : 10),
              ),
              // Kategori renkli "radiant" glow — /new ve /spot'taki canlı
              // kart diliyle tutarlı.
              BoxShadow(
                color: meta.color.withOpacity(_isHovered ? 0.38 : 0.22),
                blurRadius: _isHovered ? 34 : 26,
                spreadRadius: -8,
                offset: Offset(0, _isHovered ? 22 : 16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: _shape,
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
                // Görseli her zaman biraz karartan sabit bir alt gradyan —
                // camsı bilgi şeridinin okunurluğunu garanti eder, hover'a
                // bağlı değil.
                const Positioned.fill(
                  child: IgnorePointer(child: _BottomScrim()),
                ),
                // Durum etiketi — keskin (sağ üst) köşeye flush oturan,
                // eski hap-rozetin yerini alan köşe etiketi.
                Positioned(
                  top: 0,
                  right: 0,
                  child: _CornerConditionTag(
                      isSpotProduct: widget.product.isSpotProduct),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _GlassIconButton(
                    icon: Icons.fullscreen_rounded,
                    onTap: () => _openGallery(context),
                  ),
                ),
                // Taban bilgi şeridi — camsı, görselin üstüne oturan, isim +
                // kategori + fiyatı TEK şeritte toplayan yeni bilgi bloğu.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _InfoStrip(product: widget.product, meta: meta),
                ),
              ],
            ),
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

class _BottomScrim extends StatelessWidget {
  const _BottomScrim();

  @override
  Widget build(final BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.72), Colors.transparent],
            stops: const [0.0, 0.62],
          ),
        ),
      );
}

class _InfoStrip extends StatelessWidget {
  final Product product;
  final CategoryMeta meta;

  const _InfoStrip({required this.product, required this.meta});

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontFamily: 'Fraunces',
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(meta.icon, size: 11, color: meta.color),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          product.category.label(context),
                          style: TextStyle(
                              color: meta.color,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
      );
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(final BuildContext context) => Center(
      child:
          Icon(Icons.chair_rounded, size: 40, color: AppColors.textTertiary));
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.white.withOpacity(0.22),
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

/// Kartın keskin (sağ üst) köşesine flush oturan durum etiketi — eski
/// yüzen hap-rozetin yerini alıyor. Sıfır = dolgun yeşil, Spot = dolgun
/// turuncu (bkz. catalog_theme.dart) — sadece ŞEKLİ değişti, renk dili
/// sitenin geri kalanıyla (iki kapı kartı, filtre çipleri) aynı kaldı.
class _CornerConditionTag extends StatelessWidget {
  final bool isSpotProduct;
  const _CornerConditionTag({required this.isSpotProduct});

  @override
  Widget build(final BuildContext context) {
    final Color color =
        isSpotProduct ? SpotPalette.accent : NewCollectionPalette.badgeGreen;
    final String label = isSpotProduct
        ? context.l10n.usedProductBadge
        : context.l10n.productCardNewBadge;

    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 14, 9),
        color: color,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:saglamspot/core/common/extentions/app_context_ui_extension.dart';
import 'package:saglamspot/features/products/domain/entites/product.dart';
import '../../shared/navigation/widgets/nav_handler.dart';
import '../common/extentions/reg_exp_extentions.dart';
import '../theme/app_colors.dart';
import 'gallery_section.dart';

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
    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform:
            _isHovered ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
        margin: const EdgeInsets.only(right: 20, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.05),
              blurRadius: _isHovered ? 20 : 12,
              offset: Offset(0, _isHovered ? 10 : 6),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => _openGallery(context),
                  child: Hero(
                    tag: 'prod_img_${widget.product.id}',
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AnimatedScale(
                          scale: _isHovered ? 1.08 : 1.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutCubic,
                          child: Image.network(
                            widget.product.imagesUrl.first,
                            fit: BoxFit.cover,
                            errorBuilder: (final c, final e, final s) =>
                                Container(
                                    color: AppColors.secondary,
                                    child: const Icon(Icons.chair, size: 40)),
                          ),
                        ),
                        // İkinci bir fotoğraf varsa, hover'da yumuşak geçişle
                        // gösteriyoruz (endüstriyel e-ticaret sitelerinin
                        // ürün kartlarında yaygın kullandığı bir mikro-etkileşim).
                        if (widget.product.imagesUrl.length > 1)
                          AnimatedOpacity(
                            opacity: _isHovered ? 1 : 0,
                            duration: const Duration(milliseconds: 400),
                            child: AnimatedScale(
                              scale: _isHovered ? 1.08 : 1.0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                              child: Image.network(
                                widget.product.imagesUrl[1],
                                fit: BoxFit.cover,
                                errorBuilder: (final c, final e, final s) =>
                                    const SizedBox.shrink(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: _ConditionBadge(isSpotProduct: widget.product.isSpotProduct),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: IconButton(
                  icon: const Icon(Icons.fullscreen_rounded,
                      color: Colors.white, size: 24),
                  style: IconButton.styleFrom(backgroundColor: Colors.white12),
                  onPressed: () => _openGallery(context),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _navigateToProductDetail(context),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₺${widget.product.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
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

/// "Sıfır" (dolgun/solid) ve "İkinci El" (ince kenarlıklı/outlined) rozet
/// ayrımı — ikinci_sans_furniture prototipinden entegre edildi.
/// `isSpotProduct == true` -> ikinci el/spot ürün.
class _ConditionBadge extends StatelessWidget {
  final bool isSpotProduct;
  const _ConditionBadge({required this.isSpotProduct});

  @override
  Widget build(final BuildContext context) {
    if (!isSpotProduct) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text(
          'SIFIR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.accentDark, width: 1.2),
      ),
      child: const Text(
        'İKİNCİ EL',
        style: TextStyle(
          color: AppColors.accentDark,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

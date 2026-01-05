import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/product.dart';
import '../util/responsive_utils.dart';
import 'gallery_section.dart';

class CustomProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;

  const CustomProductCard({super.key, required this.product, this.onTap});

  @override
  State<CustomProductCard> createState() => _CustomProductCardState();
}

class _CustomProductCardState extends State<CustomProductCard> {
  bool _isHovered = false;

  void _openGallery(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: GallerySection(photos: widget.product.imagesUrl),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 280,
        margin: const EdgeInsets.only(right: 20, bottom: 20),
        transform: _isHovered
            ? Matrix4.translationValues(0, -12, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F7F5), // Görseldeki iç kart rengi
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.03),
              blurRadius: _isHovered ? 35 : 20,
              offset: Offset(0, _isHovered ? 15 : 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // GÖRSEL ALANI
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () => _openGallery(context),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Hero(
                          tag: 'prod_${widget.product.id}',
                          child: Image.network(
                            widget.product.imagesUrl.first,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.product.isSpotProduct)
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Text('✨ SPOT',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            ),
            // BİLGİ ALANI
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 18)),
                        Text(widget.product.category,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text('₺${widget.product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 22)),
                      ],
                    ),
                  ),
                  // Görseldeki Siyah Buton (Hover'da renk değiştirebilir)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          _isHovered ? const Color(0xFF6366F1) : Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageArea extends StatelessWidget {
  final Product product;

  const _ImageArea({required this.product});

  void _openGallery(final BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (final context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child:
              GallerySection(photos: product.imagesUrl), // Senin kodun çalışır
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Ürün Görseli (Görseldeki gibi havada duran/floating efekt)
        GestureDetector(
          onTap: () => _openGallery(context),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Hero(
              tag: 'product_${product.id}',
              child: Image.network(
                product.imagesUrl.isNotEmpty ? product.imagesUrl.first : '',
                fit: BoxFit.contain,
                errorBuilder: (final context, final error, final stackTrace) =>
                    const Icon(Icons.chair_rounded,
                        size: 60, color: Colors.grey),
              ),
            ),
          ),
        ),

        // Spot Badge (Görselde kaybolmaması için Siyah-Beyaz Tasarım)
        if (product.isSpotProduct)
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black, // Yüksek okunabilirlik
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '✨ SPOT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),

        // Galeri İkonu (Sağ üstte küçük bir ipucu)
        if (product.imagesUrl.length > 1)
          Positioned(
            top: 16,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.8),
              radius: 16,
              child: const Icon(Icons.collections_rounded,
                  size: 16, color: Colors.black),
            ),
          ),
      ],
    );
  }
}

class _InfoArea extends StatelessWidget {
  final Product product;

  const _InfoArea({required this.product});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Başlık ve Kategori
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: TextStyle(
                  fontSize: context.responsive(mobile: 16.0, desktop: 18.0),
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                product.category,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Fiyat ve Modern Sepet Butonu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₺${product.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: context.responsive(mobile: 18.0, desktop: 20.0),
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              // Görseldeki meşhur siyah yuvarlak buton
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

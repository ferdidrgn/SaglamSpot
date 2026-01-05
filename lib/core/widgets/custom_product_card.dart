import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/product.dart';
import '../util/responsive_utils.dart';
import 'gallery_section.dart';

class CustomProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap; // Dışarıdan gelen tıklama (Detay sayfası vb.)

  const CustomProductCard({super.key, required this.product, this.onTap});

  @override
  State<CustomProductCard> createState() => _CustomProductCardState();
}

class _CustomProductCardState extends State<CustomProductCard> {
  bool _isHovered = false;

  // Görsele tıklandığında Galeri açan fonksiyon
  void _openGallery(final BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (final context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: GallerySection(
              photos: widget.product.imagesUrl), // Senin galeri widget'ın
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        // Tüm karta basınca dışarıdan gelen aksiyon çalışır
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.08 : 0.02),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Üst Kısım: Görsel (Tıklayınca Galeri Açılır)
              Expanded(
                flex: 5,
                child: GestureDetector(
                  onTap: () => _openGallery(context),
                  // Sadece görsele basınca galeri
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAF9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Hero(
                            tag: 'prod_${widget.product.id}',
                            child: Image.network(
                              widget.product.imagesUrl.first,
                              fit: BoxFit.contain,
                              errorBuilder: (final c, final e, final s) =>
                                  const Icon(Icons.chair, size: 40),
                            ),
                          ),
                        ),
                        if (widget.product.isSpotProduct)
                          Positioned(
                            top: 12,
                            left: 12,
                            child: _buildBadge('✨ SPOT'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Alt Kısım: Bilgiler ve Siyah Buton
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₺${widget.product.price.toStringAsFixed(0)}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 20),
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

  Widget _buildBadge(final String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}

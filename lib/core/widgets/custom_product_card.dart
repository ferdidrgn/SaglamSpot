import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/domain/entities/product.dart';
import '../../presentation/pages/product_detail_page.dart';
import 'gallery_section.dart';

class CustomProductCard extends StatelessWidget {
  final Product product;

  const CustomProductCard({super.key, required this.product});

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // ÜST KISIM: Görsel Alanı (Tıklayınca GALERİ açılır)
          Expanded(
            child: GestureDetector(
              onTap: () => _openGallery(context),
              child: Container(
                margin: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F7F6), // Görseldeki soft mint
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Hero(
                        tag: 'prod_img_${product.id}',
                        child: Image.network(
                          product.imagesUrl.first,
                          fit: BoxFit.contain,
                          errorBuilder: (final c, final e, final s) =>
                              const Icon(Icons.chair, size: 40),
                        ),
                      ),
                    ),
                    // Galeri İpucu İkonu
                    Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        child: const Icon(Icons.fullscreen_rounded,
                            size: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ALT KISIM: Bilgi Alanı (Tıklayınca DETAY sayfasına gider)
          GestureDetector(
            onTap: () => context.push('/product/${product.id}'),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₺${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  // Detay Sayfasına Git Butonu (Görseldeki siyah yuvarlak buton)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openGallery(final BuildContext context) => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (final context) => GalleryViewerDialog(
            images: product.imagesUrl,
            isMobile: MediaQuery.of(context).size.width < 900),
      );
}

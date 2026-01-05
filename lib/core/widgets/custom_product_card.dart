import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import 'gallery_section.dart'; // GallerySection'ın olduğu yer

class CustomProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap; // Dışarıdan gelen tıklama (Detay sayfası vb.)

  const CustomProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ??
            () {
              // Varsayılan hareket: Galeri Dialog'unu tetikle
              _openGallery(context);
            },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10))
            ],
          ),
          child: Column(
            children: [
              // Ürün Görsel Alanı
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F7F6), // Soft mint arka plan
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Hero(
                          tag: 'product_image_${product.id}',
                          child: Image.network(
                            product.imagesUrl.first,
                            fit: BoxFit.contain,
                            errorBuilder: (final c, final e, final s) =>
                                const Icon(Icons.chair,
                                    size: 50, color: Colors.black12),
                          ),
                        ),
                      ),
                      // Sağ üst köşeye "Galeri" ikonu ekleyerek kullanıcıyı yönlendiriyoruz
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.photo_library_outlined,
                              size: 18, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bilgi Alanı
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Text('₺${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600)),
                          ]),
                    ),
                    // Detay/Aç butonu
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: const Icon(Icons.fullscreen_rounded,
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

  // Galeri tetikleyici fonksiyon
  void _openGallery(final BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (final context) => GalleryViewerDialog(
        images: product.imagesUrl, // Ürünün tüm resim listesi gidiyor
        isMobile: MediaQuery.of(context).size.width < 900,
      ),
    );
  }
}

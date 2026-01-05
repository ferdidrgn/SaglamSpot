import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/domain/entities/product.dart';
import 'gallery_section.dart';

class CustomProductCard extends StatelessWidget {
  final Product product;

  const CustomProductCard({super.key, required this.product});

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28), // Daha kibar bir kavis
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // 1. ARKA PLAN GÖRSELİ
              Positioned.fill(
                child: Hero(
                  tag: 'prod_img_${product.id}',
                  child: Image.network(
                    product.imagesUrl.first,
                    fit: BoxFit.cover,
                    errorBuilder: (final c, final e, final s) => Container(
                        color: const Color(0xFFF3F7F6),
                        child: const Icon(Icons.chair, size: 40)),
                  ),
                ),
              ),

              // 2. GRADYAN (Okunabilirlik için alt gölge)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                        Colors.black.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. ÜST GALERİ İKONU (Daha ufak ve şeffaf)
              Positioned(
                top: 15,
                right: 15,
                child: GestureDetector(
                  onTap: () => _openGallery(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.fullscreen_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),

              // 4. ALT BİLGİ ALANI (Küçültülmüş ve Düzenlenmiş Yazılar)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₺${product.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Minimal Ok İkonu
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white.withOpacity(0.6),
                      size: 14,
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
            images: product.imagesUrl,
            isMobile: MediaQuery.of(context).size.width < 900),
      );
}

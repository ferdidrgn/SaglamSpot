import 'dart:ui'; // BackdropFilter için eklendi
import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../util/responsive_utils.dart'; // Extension'lar için import

/// Modern, responsive ve performans odaklı product card
/// SOLID prensipleriyle tasarlanmış, tek sorumluluk prensibi uygulanmış
class CustomProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const CustomProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    // getCardMargin yerine responsive()
    final cardMargin = context.responsive(
        mobile: const EdgeInsets.all(4.0), desktop: const EdgeInsets.all(6.0));

    return Container(
      margin: cardMargin,
      decoration: _buildCardDecoration(context),
      child: ClipRRect(
        // getBorderRadius yerine borderRadius()
        borderRadius: BorderRadius.circular(context.borderRadius(1.25)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: const Color(0xFF6366F1).withOpacity(0.1),
            highlightColor: const Color(0xFF6366F1).withOpacity(0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _ImageSection artık galeriyi yönetiyor
                _ImageSection(product: product),
                // Expanded, _InfoSection'ın kalan tüm alanı doldurmasını sağlar.
                Expanded(
                  child: _InfoSection(product: product),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration(final BuildContext context) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        context.borderRadius(1.25), // Extension
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}

// ===================================================================
// GÖRSEL BÖLÜMÜ (GALERİ OLARAK GÜNCELLENDİ)
// ===================================================================

/// Image bölümü - Artık galeriyi yöneten bir StatefulWidget
class _ImageSection extends StatefulWidget {
  final Product product;

  const _ImageSection({required this.product});

  @override
  State<_ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<_ImageSection> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Tam ekran galeri gösterimi
  void _showFullscreenGallery(
      final BuildContext context, final int initialIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8), // Arka planı koyulaştır
      builder: (final BuildContext context) {
        return _FullscreenImageGallery(
          imageUrls: widget.product.imagesUrl,
          initialIndex: initialIndex,
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    // --- DEĞİŞİKLİK BURADA ---
    // Masaüstü görselini daha uzun yapmak için 180.0 -> 210.0 yapıldı.
    // Bu, grid'deki (desktop: 0.72) oranıyla uyumlu çalışacaktır.
    final imageHeight =
        context.responsive(mobile: 140.0, tablet: 160.0, desktop: 230.0);
    // --- DEĞİŞİKLİK SONU ---

    final hasMultipleImages = widget.product.imagesUrl.length > 1;

    return SizedBox(
      height: imageHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Resim Galerisi (PageView)
          PageView.builder(
            controller: _pageController,
            itemCount: widget.product.imagesUrl.isEmpty
                ? 1
                : widget.product.imagesUrl.length,
            onPageChanged: (final index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (final context, final index) {
              final String? imageUrl = widget.product.imagesUrl.isEmpty
                  ? null
                  : widget.product.imagesUrl[index];
              return GestureDetector(
                onTap: () {
                  // Sadece geçerli resim varsa tam ekran aç
                  if (imageUrl != null)
                    _showFullscreenGallery(context, index);
                },
                child: _buildProductImage(context, imageUrl, imageHeight),
              );
            },
          ),

          // 2. Diğer Arayüz Elemanları
          _buildGradientOverlay(context),
          Positioned(
            top: context.responsive(mobile: 6.0, desktop: 8.0),
            right: context.responsive(mobile: 6.0, desktop: 8.0),
            child: _StatusBadge(product: widget.product),
          ),
          if (widget.product.isSpotProduct)
            Positioned(
              top: context.responsive(mobile: 6.0, desktop: 8.0),
              left: context.responsive(mobile: 6.0, desktop: 8.0),
              child: const _SpotBadge(),
            ),

          // 3. Galeri Navigasyonu (Sadece 1'den fazla resim varsa)
          if (hasMultipleImages) ...[
            // Sayfa Göstergeleri (Noktalar)
            Positioned(
              bottom: 8.0,
              left: 0,
              right: 0,
              child: _buildIndicators(),
            ),
            // Navigasyon Okları
            _buildNavigationArrow(
              context,
              isLeft: true,
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
            ),
            _buildNavigationArrow(
              context,
              isLeft: false,
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  /// Resim widget'ını oluşturan yardımcı metot
  Widget _buildProductImage(final BuildContext context, final String? imageUrl,
      final double imageHeight) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cacheHeight = (imageHeight * pixelRatio).round();

    if (imageUrl == null || imageUrl.isEmpty)
      return _buildPlaceholder(context);

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      cacheHeight: cacheHeight,
      errorBuilder: (final context, final error, final stackTrace) =>
          _buildPlaceholder(context),
      loadingBuilder: (final context, final child, final loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildPlaceholder(context); // Yüklenirken de placeholder
      },
    );
  }

  /// Placeholder widget'ı
  Widget _buildPlaceholder(final BuildContext context) {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: Icon(
        Icons.image_outlined,
        size: context.responsive(mobile: 40.0, desktop: 48.0),
        color: const Color(0xFF94A3B8).withOpacity(0.5),
      ),
    );
  }

  /// Alttaki gölge
  Widget _buildGradientOverlay(final BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: context.responsive(mobile: 40.0, desktop: 50.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.25),
            ],
          ),
        ),
      ),
    );
  }

  /// Galeri noktalarını oluşturan metot
  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.product.imagesUrl.length, (final index) {
        final bool isSelected = _currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: isSelected ? 8.0 : 6.0,
          width: isSelected ? 8.0 : 6.0,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ],
          ),
        );
      }),
    );
  }

  /// Navigasyon oklarını oluşturan metot
  Widget _buildNavigationArrow(final BuildContext context,
      {required final bool isLeft, required final VoidCallback onPressed}) {
    // İlk ve son resimde ilgili oku gizle
    if (isLeft && _currentIndex == 0)
      return const SizedBox.shrink();
    if (!isLeft && _currentIndex == widget.product.imagesUrl.length - 1)
      return const SizedBox.shrink();

    return Positioned(
      top: 0,
      bottom: 0,
      left: isLeft ? 4.0 : null,
      right: isLeft ? null : 4.0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              isLeft ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16.0,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// TAM EKRAN GALERİ WIDGET'I (YENİ)
// ===================================================================

class _FullscreenImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const _FullscreenImageGallery({
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<_FullscreenImageGallery> createState() =>
      _FullscreenImageGalleryState();
}

class _FullscreenImageGalleryState extends State<_FullscreenImageGallery> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Bulanık arka plan
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Resim Galerisi
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (final index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (final context, final index) {
              return InteractiveViewer(
                // Zoom yapabilmek için
                child: Image.network(
                  widget.imageUrls[index],
                  fit: BoxFit.contain, // Tam ekran için 'contain'
                  loadingBuilder:
                      (final context, final child, final loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              );
            },
          ),
          // Kapatma Butonu
          Positioned(
            top: 40.0,
            right: 20.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          // Sayfa Göstergesi (Noktalar)
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 30.0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageUrls.length, (final index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    height: 8.0,
                    width: 8.0,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

// ===================================================================
// DİĞER WIDGET'LAR (OVERFLOW İÇİN GÜNCELLENDİ)
// ===================================================================

/// Status badge widget
class _StatusBadge extends StatelessWidget {
  final Product product;

  const _StatusBadge({required this.product});

  @override
  Widget build(final BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: context.responsive(mobile: 6.0, desktop: 8.0),
      vertical: context.responsive(mobile: 3.0, desktop: 4.0),
    );
    final iconSize =
        context.responsive(mobile: 20.0 * 0.6, desktop: 24.0 * 0.6);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color:
            product.isSold ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        borderRadius: BorderRadius.circular(context.borderRadius(0.75)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            product.isSold
                ? Icons.check_circle_rounded
                : Icons.inventory_2_rounded,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(
            width: context.responsive(mobile: 3.0, desktop: 4.0),
          ),
          Text(
            product.isSold ? 'Satıldı' : 'Stokta',
            style: TextStyle(
              color: Colors.white,
              fontSize: context.captionSize, // Extension
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Spot badge widget
class _SpotBadge extends StatelessWidget {
  const _SpotBadge();

  @override
  Widget build(final BuildContext context) {
    final padding = EdgeInsets.symmetric(
      horizontal: context.responsive(mobile: 6.0, desktop: 8.0),
      vertical: context.responsive(mobile: 3.0, desktop: 4.0),
    );
    final iconSize =
        context.responsive(mobile: 20.0 * 0.6, desktop: 24.0 * 0.6);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ),
        borderRadius: BorderRadius.circular(context.borderRadius(0.75)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC4899).withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(
            width: context.responsive(mobile: 3.0, desktop: 4.0),
          ),
          Text(
            'Spot',
            style: TextStyle(
              color: Colors.white,
              fontSize: context.captionSize, // Extension
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Info section - Product details
class _InfoSection extends StatelessWidget {
  final Product product;

  const _InfoSection({required this.product});

  @override
  Widget build(final BuildContext context) {
    // getCardPadding yerine responsive()
    final padding =
        context.responsive(mobile: 12.0, tablet: 14.0, desktop: 16.0);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- DÜZELTME: OVERFLOW HATASI İÇİN ---
          // Yazı grubu (Kategori, Başlık, Açıklama) bir Flexible widget
          // ile sarıldı. Bu, fiyatın taşmasını engeller.
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              // Sadece gerektiği kadar yer kapla
              children: [
                _CategoryChip(category: product.category),
                SizedBox(height: context.responsive(mobile: 4.0, desktop: 6.0)),
                _ProductTitle(title: product.name),
                SizedBox(height: context.responsive(mobile: 2.0, desktop: 4.0)),
                _ProductDescription(description: product.desc),
              ],
            ),
          ),
          // --- DÜZELTME SONU ---

          // 2. Grup: Fiyat
          _PriceSection(price: product.price),
        ],
      ),
    );
  }
}

/// Category chip
class _CategoryChip extends StatelessWidget {
  final String category;

  const _CategoryChip({required this.category});

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive(mobile: 6.0, desktop: 8.0),
        vertical: context.responsive(mobile: 2.0, desktop: 3.0),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(context.borderRadius(0.25)),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          fontSize: context.captionSize, // Extension
          fontWeight: FontWeight.w700,
          color: const Color(0xFF6366F1),
          letterSpacing: 0.5,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Product title
class _ProductTitle extends StatelessWidget {
  final String title;

  const _ProductTitle({required this.title});

  @override
  Widget build(final BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: context.titleSize,
        // Extension
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1E293B),
        height: 1.2,
        letterSpacing: 0.1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Product description
class _ProductDescription extends StatelessWidget {
  final String description;

  const _ProductDescription({required this.description});

  @override
  Widget build(final BuildContext context) {
    return Text(
      description,
      style: TextStyle(
        fontSize: context.bodySize, // Extension
        color: const Color(0xFF64748B),
        height: 1.3,
        letterSpacing: 0.1,
      ),
      // Overflow düzeltmesi (1 satır)
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Price section with action button
class _PriceSection extends StatelessWidget {
  final double price;

  const _PriceSection({required this.price});

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsive(mobile: 8.0, desktop: 10.0),
              vertical: context.responsive(mobile: 6.0, desktop: 8.0),
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B87EA)],
              ),
              borderRadius: BorderRadius.circular(context.borderRadius(0.5)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '₺${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: context.priceSize, // Extension
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          width: context.responsive(mobile: 6.0, desktop: 8.0),
        ),
        Container(
          padding: EdgeInsets.all(
            context.responsive(mobile: 6.0, desktop: 8.0),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEC4899).withOpacity(0.1),
            borderRadius: BorderRadius.circular(context.borderRadius(0.5)),
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            // getIconSize yerine responsive()
            size: context.responsive(mobile: 20.0 * 0.9, desktop: 24.0 * 0.9),
            color: const Color(0xFFEC4899),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../util/responsive_utils.dart'; // Extension'lar için import

/// Modern, responsive ve performans odaklı product card
/// SOLID prensipleriyle tasarlanmış, tek sorumluluk prensibi uygulanmış
// Mixin kaldırıldı
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
            // DÜZELTME: IntrinsicHeight kaldırıldı.
            // Bu, 'Expanded' ile birlikte layout'u bozuyordu.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

/// Image bölümü - Ayrı widget olarak separation of concerns
// Mixin kaldırıldı
class _ImageSection extends StatelessWidget {
  final Product product;

  const _ImageSection({required this.product});

  @override
  Widget build(final BuildContext context) {
    // getCardImageHeight yerine responsive()
    final imageHeight =
        context.responsive(mobile: 140.0, tablet: 160.0, desktop: 180.0);

    // Cihazın piksel yoğunluğunu al (retina ekranlar için)
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Yüksek çözünürlüklü ekranlar için cache boyutunu ayarla
    // Max yükseklik 180 * 3 (yüksek pixelRatio) = 540
    // Bu, 4K bir resmi decode etmek yerine 540px'lik bir resmi decode etmeyi sağlar.
    final cacheHeight = (imageHeight * pixelRatio).round();

    return SizedBox(
      height: imageHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildProductImage(context, cacheHeight), // DÜZELTME
          _buildGradientOverlay(context),
          Positioned(
            top: context.responsive(mobile: 6.0, desktop: 8.0),
            right: context.responsive(mobile: 6.0, desktop: 8.0),
            child: _StatusBadge(product: product),
          ),
          if (product.isSpotProduct)
            Positioned(
              top: context.responsive(mobile: 6.0, desktop: 8.0),
              left: context.responsive(mobile: 6.0, desktop: 8.0),
              child: const _SpotBadge(),
            ),
        ],
      ),
    );
  }

  Widget _buildProductImage(BuildContext context, int cacheHeight) {
    // DÜZELTME
    return product.imagesUrl.isNotEmpty
        ? Image.network(
            product.imagesUrl.first,
            fit: BoxFit.cover,

            // --- PERFORMANS DÜZELTMESİ ---
            // Resmi bu piksel yüksekliğinde işle, bu UI donmasını engeller.
            cacheHeight: cacheHeight,
            // ---------------------------------

            errorBuilder: (final context, final error, final stackTrace) =>
                _buildPlaceholder(context),
            loadingBuilder:
                (final context, final child, final loadingProgress) {
              if (loadingProgress == null) return child;
              // Yüklenirken de placeholder göster
              return _buildPlaceholder(context);
            },
          )
        : _buildPlaceholder(context);
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: Icon(
        Icons.image_outlined,
        size: context.responsive(mobile: 40.0, desktop: 48.0),
        color: const Color(0xFF94A3B8).withOpacity(0.5),
      ),
    );
  }

  Widget _buildGradientOverlay(BuildContext context) {
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
}

/// Status badge widget
// Mixin kaldırıldı
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
// Mixin kaldırıldı
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
// Mixin kaldırıldı
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
        // DÜZELTME: Bu, fiyatı en alta itecek.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Grup: Başlık ve açıklama
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Sadece gerektiği kadar yer kapla
            children: [
              _CategoryChip(category: product.category),
              SizedBox(height: context.responsive(mobile: 4.0, desktop: 6.0)),
              _ProductTitle(title: product.name),
              SizedBox(height: context.responsive(mobile: 2.0, desktop: 4.0)),
              // DÜZELTME: 'Flexible' sarmalayıcıları kaldırıldı.
              // Bu, overflow hatasını düzeltir.
              _ProductDescription(description: product.desc),
            ],
          ),

          // 2. Grup: Fiyat (Aradaki SizedBox kaldırıldı)
          _PriceSection(price: product.price),
        ],
      ),
    );
  }
}

/// Category chip
// Mixin kaldırıldı
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
// Mixin kaldırıldı
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
// Mixin kaldırıldı
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
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Price section with action button
// Mixin kaldırıldı
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

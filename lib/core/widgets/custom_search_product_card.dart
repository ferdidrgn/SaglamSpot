import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../util/responsive_utils.dart';

/// Modern, responsive ve performans odaklı product card
/// SOLID prensipleriyle tasarlanmış, tek sorumluluk prensibi uygulanmış
class ModernProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ModernProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: ResponsiveUtils.getCardMargin(context),
      decoration: _buildCardDecoration(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(context, scale: 1.25),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: const Color(0xFF6366F1).withOpacity(0.1),
            highlightColor: const Color(0xFF6366F1).withOpacity(0.05),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ImageSection(product: product),
                  Expanded(
                    child: _InfoSection(product: product),
                  ),
                ],
              ),
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
        ResponsiveUtils.getBorderRadius(context, scale: 1.25),
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
class _ImageSection extends StatelessWidget {
  final Product product;

  const _ImageSection({required this.product});

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: ResponsiveUtils.getCardImageHeight(context),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildProductImage(),
          _buildGradientOverlay(),
          Positioned(
            top: ResponsiveUtils.getValueForDevice(
              context,
              mobile: 6.0,
              desktop: 8.0,
            ),
            right: ResponsiveUtils.getValueForDevice(
              context,
              mobile: 6.0,
              desktop: 8.0,
            ),
            child: _StatusBadge(product: product),
          ),
          if (product.isSpotProduct)
            Positioned(
              top: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 6.0,
                desktop: 8.0,
              ),
              left: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 6.0,
                desktop: 8.0,
              ),
              child: const _SpotBadge(),
            ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return product.imagesUrl.isNotEmpty
        ? Image.network(
            product.imagesUrl.first,
            fit: BoxFit.cover,
            errorBuilder: (final context, final error, final stackTrace) =>
                _buildPlaceholder(),
            loadingBuilder:
                (final context, final child, final loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildPlaceholder();
            },
          )
        : _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: Icon(
        Icons.image_outlined,
        size: 48,
        color: const Color(0xFF94A3B8).withOpacity(0.5),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 50,
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
class _StatusBadge extends StatelessWidget {
  final Product product;

  const _StatusBadge({required this.product});

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: ResponsiveUtils.getBadgePadding(context),
      decoration: BoxDecoration(
        color:
            product.isSold ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        borderRadius: BorderRadius.circular(12),
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
            size: ResponsiveUtils.getIconSize(context, scale: 0.6),
            color: Colors.white,
          ),
          SizedBox(
            width: ResponsiveUtils.getValueForDevice(
              context,
              mobile: 3.0,
              desktop: 4.0,
            ),
          ),
          Text(
            product.isSold ? 'Satıldı' : 'Stokta',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveUtils.getCaptionFontSize(context),
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
    return Container(
      padding: ResponsiveUtils.getBadgePadding(context),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ),
        borderRadius: BorderRadius.circular(12),
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
            size: ResponsiveUtils.getIconSize(context, scale: 0.6),
            color: Colors.white,
          ),
          SizedBox(
            width: ResponsiveUtils.getValueForDevice(
              context,
              mobile: 3.0,
              desktop: 4.0,
            ),
          ),
          Text(
            'Spot',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveUtils.getCaptionFontSize(context),
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
    return Padding(
      padding: ResponsiveUtils.getCardPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _CategoryChip(category: product.category),
                SizedBox(
                  height: ResponsiveUtils.getValueForDevice(
                    context,
                    mobile: 4.0,
                    desktop: 6.0,
                  ),
                ),
                _ProductTitle(title: product.name),
                SizedBox(
                  height: ResponsiveUtils.getValueForDevice(
                    context,
                    mobile: 2.0,
                    desktop: 4.0,
                  ),
                ),
                Flexible(
                  child: _ProductDescription(description: product.desc),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ResponsiveUtils.getValueForDevice(
              context,
              mobile: 6.0,
              desktop: 8.0,
            ),
          ),
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
        horizontal: ResponsiveUtils.getValueForDevice(
          context,
          mobile: 6.0,
          desktop: 8.0,
        ),
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          fontSize: ResponsiveUtils.getCaptionFontSize(context),
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
        fontSize: ResponsiveUtils.getTitleFontSize(context),
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
        fontSize: ResponsiveUtils.getBodyFontSize(context),
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
              horizontal: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 8.0,
                desktop: 10.0,
              ),
              vertical: ResponsiveUtils.getValueForDevice(
                context,
                mobile: 6.0,
                desktop: 8.0,
              ),
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B87EA)],
              ),
              borderRadius: BorderRadius.circular(8),
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
                fontSize: ResponsiveUtils.getPriceFontSize(context),
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
          width: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 6.0,
            desktop: 8.0,
          ),
        ),
        Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.getValueForDevice(
              context,
              mobile: 6.0,
              desktop: 8.0,
            ),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEC4899).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: ResponsiveUtils.getIconSize(context, scale: 0.9),
            color: const Color(0xFFEC4899),
          ),
        ),
      ],
    );
  }
}

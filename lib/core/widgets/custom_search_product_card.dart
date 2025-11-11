import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class ModernProductCard extends StatelessWidget {
  final Product product;
  final bool isMobile;
  final VoidCallback? onTap;

  const ModernProductCard({
    super.key,
    required this.product,
    required this.isMobile,
    this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: const Color(0xFF6366F1).withOpacity(0.1),
            highlightColor: const Color(0xFF6366F1).withOpacity(0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildProductImage(),
                      _buildGradientOverlay(),
                      _buildStatusBadge(),
                      if (product.isSpotProduct) _buildSpotBadge(),
                    ],
                  ),
                ),
                // Info Section
                Expanded(
                  flex: 2,
                  child: _buildProductInfo(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return product.imagesUrl.isNotEmpty
        ? Image.network(
      product.imagesUrl.first,
      fit: BoxFit.cover,
      errorBuilder: (final context, final error, final stackTrace) {
        return _buildPlaceholder();
      },
    )
        : _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: const Icon(
        Icons.image_outlined,
        size: 48,
        color: Color(0xFF94A3B8),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: product.isSold ? const Color(0xFFEF4444) : const Color(0xFF10B981),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              product.isSold ? Icons.check_circle : Icons.inventory_2,
              size: 12,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              product.isSold ? 'Satıldı' : 'Stokta',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotBadge() {
    return Positioned(
      top: 12,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEC4899).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: 10, color: Colors.white),
            SizedBox(width: 3),
            Text(
              'Öne Çıkan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCategory(),
          const SizedBox(height: 6),
          _buildProductName(),
          const SizedBox(height: 4),
          _buildDescription(),
          const Spacer(),
          _buildPriceAndAction(),
        ],
      ),
    );
  }

  Widget _buildCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        product.category.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6366F1),
          letterSpacing: 0.5,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildProductName() {
    return Text(
      product.name,
      style: TextStyle(
        fontSize: isMobile ? 14 : 15,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1E293B),
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      product.desc,
      style: TextStyle(
        fontSize: isMobile ? 11 : 12,
        color: const Color(0xFF64748B),
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceAndAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B87EA)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '₺${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: isMobile ? 14 : 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFEC4899).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            size: 18,
            color: Color(0xFFEC4899),
          ),
        ),
      ],
    );
  }
}
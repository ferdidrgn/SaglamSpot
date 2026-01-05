import 'package:flutter/material.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/domain/entities/product.dart';

class WebProductDetailPage extends StatefulWidget {
  final Product product;

  const WebProductDetailPage({super.key, required this.product});

  @override
  State<WebProductDetailPage> createState() => _WebProductDetailPageState();
}

class _WebProductDetailPageState extends State<WebProductDetailPage> {
  int _quantity = 1;
  int _selectedImageIndex = 0;
  Color _selectedColor = const Color(0xFFD4A574);

  final List<Color> _availableColors = const [
    Color(0xFFD4A574), // Tan
    Color(0xFFF4E5D3), // Cream
    Color(0xFFB8B8B8), // Gray
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F5),
      body: CustomScrollView(
        slivers: [
          // App Bar
          _buildAppBar(context),

          // Main Content
          context.isDesktop
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),

          // Related Products
          _buildRelatedProducts(context),

          // Spacing
          SliverToBoxAdapter(
            child: SizedBox(height: context.spacingLarge * 2),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
      ),
      title: Text(
        'Product Details',
        style: TextStyle(
          fontSize: context.h4Size,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite_border, color: AppColors.textPrimary),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share, color: AppColors.textPrimary),
        ),
        SizedBox(width: context.responsive(mobile: 8.0, desktop: 16.0)),
      ],
    );
  }

  // DESKTOP LAYOUT (Side by side)
  SliverToBoxAdapter _buildDesktopLayout(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1440),
        padding: EdgeInsets.symmetric(
          horizontal: context.responsive(
            mobile: 16.0,
            tablet: 32.0,
            desktop: 48.0,
            largeDesktop: 64.0,
          ),
          vertical: context.spacingLarge,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left - Image Gallery (60%)
            Expanded(
              flex: 6,
              child: _buildImageSection(context),
            ),

            SizedBox(width: context.spacingLarge),

            // Right - Product Info (40%)
            Expanded(
              flex: 4,
              child: _buildProductInfo(context),
            ),
          ],
        ),
      ),
    );
  }

  // MOBILE LAYOUT (Stacked)
  SliverToBoxAdapter _buildMobileLayout(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(context.spacing),
        child: Column(
          children: [
            _buildImageSection(context),
            SizedBox(height: context.spacingLarge),
            _buildProductInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Column(
      children: [
        // Main Image
        Container(
          height: context.responsive(
            mobile: 350.0,
            tablet: 450.0,
            desktop: 550.0,
            largeDesktop: 650.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.borderRadius(1.5)),
            boxShadow: [
              BoxShadow(
                color: _selectedColor.withOpacity(0.15),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background watermark
              Center(
                child: Opacity(
                  opacity: 0.03,
                  child: Text(
                    'Astra Chair',
                    style: TextStyle(
                      fontSize: context.responsive(
                        mobile: 48.0,
                        tablet: 64.0,
                        desktop: 80.0,
                      ),
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // Product Image
              Center(
                child: Padding(
                  padding: EdgeInsets.all(
                    context.responsive(mobile: 40.0, desktop: 60.0),
                  ),
                  child: widget.product.imagesUrl.isNotEmpty
                      ? Image.network(
                          widget.product.imagesUrl[_selectedImageIndex],
                          fit: BoxFit.contain,
                        )
                      : Icon(
                          Icons.chair_rounded,
                          size:
                              context.responsive(mobile: 120.0, desktop: 200.0),
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                ),
              ),

              // 3D View Button
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.threed_rotation,
                    size: context.iconMedium,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: context.spacing),

        // Thumbnail Gallery
        if (widget.product.imagesUrl.length > 1)
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.product.imagesUrl.length,
              separatorBuilder: (_, __) => SizedBox(width: context.spacing),
              itemBuilder: (context, index) {
                final isSelected = _selectedImageIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedImageIndex = index),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(context.borderRadius()),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : AppColors.border,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(context.borderRadius()),
                      child: Image.network(
                        widget.product.imagesUrl[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Container(
      padding: context.isDesktop
          ? EdgeInsets.all(context.cardPadding.left)
          : EdgeInsets.zero,
      decoration: context.isDesktop
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(context.borderRadius(1.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.product.category,
              style: TextStyle(
                fontSize: context.captionSize,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),

          SizedBox(height: context.spacing),

          // Product Name
          Text(
            widget.product.name,
            style: TextStyle(
              fontSize: context.h2Size,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: context.spacing),

          // Rating & Reviews
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '+112',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: context.captionSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.spacing),
              const Icon(Icons.star, color: Color(0xFFFFC107), size: 20),
              const SizedBox(width: 4),
              Text(
                '4.0 Stars',
                style: TextStyle(
                  fontSize: context.bodySize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          SizedBox(height: context.spacingLarge),

          // Price
          Row(
            children: [
              Text(
                '₺${widget.product.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: context.h2Size,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: context.spacing),
              if (widget.product.isSpotProduct)
                Text(
                  '₺${(widget.product.price * 1.4).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: context.h4Size,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),

          SizedBox(height: context.spacingLarge),

          // Color Selector
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Renk Seçimi',
                style: TextStyle(
                  fontSize: context.bodySize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: context.spacing),
              Row(
                children: _availableColors.map((color) {
                  final isSelected = color == _selectedColor;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: isSelected ? 56 : 48,
                        height: isSelected ? 56 : 48,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected ? Colors.black : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: isSelected ? 15 : 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          SizedBox(height: context.spacingLarge),

          // Quantity Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Miktar',
                style: TextStyle(
                  fontSize: context.bodySize,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(context.borderRadius()),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_quantity > 1) setState(() => _quantity--);
                      },
                      icon: const Icon(Icons.remove, size: 20),
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: Text(
                        '$_quantity',
                        style: TextStyle(
                          fontSize: context.h4Size,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _quantity++),
                      icon: const Icon(Icons.add, size: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: context.spacingLarge),

          // Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Açıklama',
                style: TextStyle(
                  fontSize: context.h4Size,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: context.spacing),
              Text(
                widget.product.desc.isNotEmpty
                    ? widget.product.desc
                    : 'Astra Chair combines modern elegance with ultimate comfort. Crafted with premium wood and soft fabric, it\'s perfect for cozy corners.',
                style: TextStyle(
                  fontSize: context.bodySize,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          SizedBox(height: context.spacingLarge),

          // CTA Buttons
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: context.responsive(mobile: 16.0, desktop: 20.0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(context.borderRadius()),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, size: 22),
                      SizedBox(width: context.spacing),
                      Text(
                        'Sepete Ekle',
                        style: TextStyle(
                          fontSize: context.bodySize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: context.spacing),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsive(mobile: 20.0, desktop: 28.0),
                    vertical: context.responsive(mobile: 16.0, desktop: 20.0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.borderRadius()),
                  ),
                ),
                child: Text(
                  'Hemen Al',
                  style: TextStyle(
                    fontSize: context.bodySize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildRelatedProducts(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1440),
        padding: EdgeInsets.symmetric(
          horizontal: context.responsive(
            mobile: 16.0,
            tablet: 32.0,
            desktop: 48.0,
            largeDesktop: 64.0,
          ),
          vertical: context.spacingLarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Benzer Ürünler',
              style: TextStyle(
                fontSize: context.h2Size,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: context.spacingLarge),
            SizedBox(
              height: context.responsive(mobile: 300.0, desktop: 380.0),
              child: Center(
                child: Text(
                  'Benzer ürünler yüklenecek...',
                  style: TextStyle(
                    fontSize: context.bodySize,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

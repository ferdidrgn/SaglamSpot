import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/data/providers/product/product_provider.dart';
import 'package:saglamspot/domain/entities/product.dart';
import '../../core/widgets/ad_sense_banner.dart';
import '../../core/widgets/gallery_section.dart';

class WebProductDetailPage extends ConsumerStatefulWidget {
  final String productId;

  const WebProductDetailPage({super.key, required this.productId});

  @override
  ConsumerState<WebProductDetailPage> createState() =>
      _WebProductDetailPageState();
}

class _WebProductDetailPageState extends ConsumerState<WebProductDetailPage> {
  int _quantity = 1;
  int _selectedImageIndex = 0;
  Color _selectedColor = const Color(0xFFD4A574);
  bool _isFavorite = false;

  final List<Color> _availableColors = const [
    Color(0xFFD4A574),
    Color(0xFFF4E5D3),
    Color(0xFFB8B8B8),
  ];

  @override
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider);
    final product = productState.dataList?.firstWhere(
      (final p) => p.id == widget.productId,
      orElse: () => throw Exception("Ürün bulunamadı"),
    );

    if (product == null)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9), // Daha ferah bir zemin
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, product),
          _buildResponsiveLayout(context, product),
          _buildRelatedProducts(context),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(final BuildContext context, final Product product) {
    return SliverAppBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 0,
      pinned: true,
      stretch: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.black, size: 20),
      ),
      title: Text(
        product.name,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () => setState(() => _isFavorite = !_isFavorite),
          icon: Icon(
            _isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: _isFavorite ? Colors.red : Colors.black,
          ),
        ),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, color: Colors.black)),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildResponsiveLayout(
      final BuildContext context, final Product product) {
    if (context.isDesktop)
      return _buildDesktopLayout(context, product);
    else if (context.isTablet)
      return _buildTabletLayout(context, product);
    else
      return _buildMobileLayout(context, product);
  }

  // TABLET LAYOUT (Side-by-side but tighter)
  SliverToBoxAdapter _buildTabletLayout(
      final BuildContext context, final Product product) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 5,
                child: _buildImageSection(context, product, height: 450)),
            const SizedBox(width: 32),
            Expanded(
                flex: 5,
                child: _buildProductInfo(context, product, compact: true)),
          ],
        ),
      ),
    );
  }

  // MOBILE LAYOUT (Stacked with improved spacing)
  SliverToBoxAdapter _buildMobileLayout(
      final BuildContext context, final Product product) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          _buildImageSection(context, product, height: 380, isMobile: true),
          _buildProductInfo(context, product, isMobile: true),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildDesktopLayout(
      final BuildContext context, final Product product) {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 6,
                  child: _buildImageSection(context, product, height: 600)),
              const SizedBox(width: 64),
              Expanded(flex: 4, child: _buildProductInfo(context, product)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(final BuildContext context, final Product product,
      {required final double height, final bool isMobile = false}) {
    return Padding(
      padding: isMobile ? const EdgeInsets.all(16.0) : EdgeInsets.zero,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: _selectedColor.withOpacity(0.08),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 1,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Watermark Text Animation
                Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: 0.03,
                    child: FittedBox(
                      // Taşmayı önlemek için eklendi
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          product.category.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -5),
                        ),
                      ),
                    ),
                  ),
                ),
                // Main Product Image with Hero
                Center(
                  child: GestureDetector(
                    onTap: () => _openFullscreenGallery(product.imagesUrl),
                    child: Hero(
                      tag: 'prod_img_${product.id}',
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Padding(
                          key: ValueKey(_selectedImageIndex),
                          padding: const EdgeInsets.all(40.0),
                          child: Image.network(
                            product.imagesUrl[_selectedImageIndex],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // 3D/Zoom Badge
                Positioned(
                  bottom: 24,
                  right: 24,
                  child: _buildGlassButton(Icons.zoom_in_rounded,
                      () => _openFullscreenGallery(product.imagesUrl)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildThumbnailList(product),
        ],
      ),
    );
  }

  Widget _buildProductInfo(final BuildContext context, final Product product,
      {final bool compact = false, final bool isMobile = false}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 40),
      decoration: isMobile
          ? null
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 30,
                    offset: const Offset(0, 10))
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryBadge(product.category),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: TextStyle(
              fontSize: compact ? 28 : 40,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          _buildRatingRow(),
          const SizedBox(height: 32),
          _buildPriceSection(product),
          const SizedBox(height: 32),
          _buildColorSelector(),
          const SizedBox(height: 32),
          _buildQuantityAndDescription(product),
          const SizedBox(height: 48),
          _buildActionButtons(isMobile),
        ],
      ),
    );
  }

  Widget _buildGlassButton(final IconData icon, final VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10))
          ],
        ),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
    );
  }

  Widget _buildThumbnailList(final Product product) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: product.imagesUrl.length,
        separatorBuilder: (final _, final __) => const SizedBox(width: 16),
        itemBuilder: (final context, final index) {
          final isSelected = _selectedImageIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedImageIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 15)
                      ]
                    : [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 5)
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child:
                    Image.network(product.imagesUrl[index], fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPriceSection(final Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Fiyat",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "₺${product.price.toStringAsFixed(0)}",
              style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A1A)),
            ),
            if (product.isSpotProduct) ...[
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  "₺${(product.price * 1.3).toStringAsFixed(0)}",
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(final bool isMobile) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildPrimaryButton(
            "Sepete Ekle",
            Colors.black,
            Colors.white,
            Icons.shopping_bag_outlined,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _buildPrimaryButton(
            "Hemen Al",
            AppColors.primary,
            Colors.white,
            null,
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(
      final String text, final Color bg, final Color fg, final IconData? icon) {
    return Container(
      height: 60, // Yüksekliği biraz optimize ettik
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: bg.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            // İç boşluk eklendi
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: fg, size: 18),
                  const SizedBox(width: 8)
                ],
                Flexible(
                  // Metnin taşmasını engeller
                  child: FittedBox(
                    // Metin sığmazsa küçülmesini sağlar
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text,
                      style: TextStyle(
                          color: fg, fontWeight: FontWeight.w700, fontSize: 15),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reuse logic from previous implementation with aesthetic enhancements
  Widget _buildCategoryBadge(final String cat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: const Color(0xFFF1F5F2),
          borderRadius: BorderRadius.circular(12)),
      child: Text(cat.toUpperCase(),
          style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              fontSize: 12,
              letterSpacing: 1)),
    );
  }

  Widget _buildRatingRow() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          ...List.generate(
              5,
              (final index) => const Icon(Icons.star_rounded,
                  color: Color(0xFFFFC107), size: 22)),
          const SizedBox(width: 8),
          const Text("4.9",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 8),
          Text("(124 Değerlendirme)",
              style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Renk Seçimi",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 16),
        Row(
          children: _availableColors.map((final c) {
            final isSelected = _selectedColor == c;
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => setState(() => _selectedColor = c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 48 : 40,
                  height: isSelected ? 48 : 40,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? c.withOpacity(0.5)
                            : Colors.black.withOpacity(0.1),
                        blurRadius: isSelected ? 12 : 4,
                        spreadRadius: isSelected ? 2 : 0,
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantityAndDescription(final Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Miktar",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            _quantitySelector(),
          ],
        ),
        const SizedBox(height: 32),
        const Text("Ürün Açıklaması",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        const SizedBox(height: 12),
        Text(
          product.desc,
          style: TextStyle(
              color: Colors.grey[700],
              height: 1.7,
              fontSize: 15,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _quantitySelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          _qButton(Icons.remove,
              () => setState(() => _quantity > 1 ? _quantity-- : null)),
          SizedBox(
              width: 40,
              child: Center(
                  child: Text("$_quantity",
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16)))),
          _qButton(Icons.add, () => setState(() => _quantity++)),
        ],
      ),
    );
  }

  Widget _qButton(final IconData icon, final VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
            ]),
        child: Icon(icon, size: 18),
      ),
    );
  }

  void _openFullscreenGallery(final List<String> images) {
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (final context) => GalleryViewerDialog(
            images: images, isMobile: MediaQuery.of(context).size.width < 600));
  }

  SliverToBoxAdapter _buildRelatedProducts(final BuildContext context) =>
      const SliverToBoxAdapter(child: SizedBox());
}

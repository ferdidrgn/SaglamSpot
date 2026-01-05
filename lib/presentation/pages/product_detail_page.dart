import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/theme/app_colors.dart'; //
import 'package:saglamspot/core/util/responsive_utils.dart'; //
import 'package:saglamspot/data/providers/product/product_provider.dart'; //
import 'package:saglamspot/domain/entities/product.dart';

import '../../core/widgets/gallery_section.dart'; //

class WebProductDetailPage extends ConsumerStatefulWidget {
  final String productId; // Artık nesne değil, sadece ID alıyoruz

  const WebProductDetailPage({super.key, required this.productId});

  @override
  ConsumerState<WebProductDetailPage> createState() =>
      _WebProductDetailPageState();
}

class _WebProductDetailPageState extends ConsumerState<WebProductDetailPage> {
  int _quantity = 1;
  int _selectedImageIndex = 0;
  Color _selectedColor = const Color(0xFFD4A574);

  final List<Color> _availableColors = const [
    Color(0xFFD4A574),
    Color(0xFFF4E5D3),
    Color(0xFFB8B8B8),
  ];

  @override
  Widget build(BuildContext context) {
    // Riverpod üzerinden tüm ürünleri dinle ve ilgili ID'yi bul
    final productState = ref.watch(productProvider);
    final product = productState.dataList?.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => throw Exception("Ürün bulunamadı"),
    );

    if (product == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F5), // Görseldeki soft mint zemin
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, product),
          context.isDesktop
              ? _buildDesktopLayout(context, product)
              : _buildMobileLayout(context, product),
          _buildRelatedProducts(context),
          SliverToBoxAdapter(child: SizedBox(height: context.spacingLarge * 2)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, Product product) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
      ),
      title: Text(
        product.name,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        const SizedBox(width: 16),
      ],
    );
  }

  // DESKTOP LAYOUT (Görseldeki Astra Chair Sayfası Yapısı)
  SliverToBoxAdapter _buildDesktopLayout(
      BuildContext context, Product product) {
    return SliverToBoxAdapter(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1440),
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sol: Galeri ve Görsel (60%)
            Expanded(flex: 6, child: _buildImageSection(context, product)),
            const SizedBox(width: 48),
            // Sağ: Ürün Bilgileri (40%)
            Expanded(flex: 4, child: _buildProductInfo(context, product)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, Product product) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _openFullscreenGallery(product.imagesUrl),
          child: Container(
            height: 550,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                    color: _selectedColor.withOpacity(0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 20)),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: 0.03,
                    child: Text(product.name,
                        style: const TextStyle(
                            fontSize: 80, fontWeight: FontWeight.w900)),
                  ),
                ),
                Center(
                  child: Hero(
                    tag: 'prod_img_${product.id}',
                    child: Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Image.network(
                          product.imagesUrl[_selectedImageIndex],
                          fit: BoxFit.contain),
                    ),
                  ),
                ),
                Positioned(bottom: 20, right: 20, child: _build3DButton()),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildThumbnailList(product),
      ],
    );
  }

  Widget _buildProductInfo(BuildContext context, Product product) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 30)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryBadge(product.category),
          const SizedBox(height: 20),
          Text(product.name,
              style:
                  const TextStyle(fontSize: 36, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          _buildRatingRow(),
          const SizedBox(height: 30),
          _buildPriceSection(product),
          const SizedBox(height: 30),
          _buildColorSelector(),
          const SizedBox(height: 30),
          _buildQuantityAndDescription(product),
          const SizedBox(height: 40),
          _buildActionButtons(),
        ],
      ),
    );
  }

  // --- YARDIMCI WIDGETLAR ---

  void _openFullscreenGallery(List<String> images) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) =>
          GalleryViewerDialog(images: images, isMobile: false),
    );
  }

  Widget _build3DButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)]),
      child: const Icon(Icons.threed_rotation, color: Colors.black),
    );
  }

  Widget _buildThumbnailList(Product product) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: product.imagesUrl.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => setState(() => _selectedImageIndex = index),
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: _selectedImageIndex == index
                      ? AppColors.primary
                      : AppColors.border,
                  width: 2),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child:
                    Image.network(product.imagesUrl[index], fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String cat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Text(cat,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.primary)),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(20)),
          child: const Row(children: [
            Icon(Icons.person, color: Colors.white, size: 14),
            SizedBox(width: 4),
            Text('+112', style: TextStyle(color: Colors.white, fontSize: 12))
          ]),
        ),
        const SizedBox(width: 16),
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const Text(" 4.0 Stars", style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPriceSection(Product product) {
    return Row(
      children: [
        Text("₺${product.price.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
        const SizedBox(width: 16),
        if (product.isSpotProduct)
          Text("₺${(product.price * 1.3).toStringAsFixed(0)}",
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough)),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Renk Seçimi",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: _availableColors
              .map((c) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedColor = c),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: _selectedColor == c
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 3)),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildQuantityAndDescription(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Miktar", style: TextStyle(fontWeight: FontWeight.bold)),
            _quantitySelector(),
          ],
        ),
        const SizedBox(height: 30),
        const Text("Açıklama",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 10),
        Text(product.desc,
            style: const TextStyle(color: Colors.black54, height: 1.6)),
      ],
    );
  }

  Widget _quantitySelector() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          IconButton(
              onPressed: () =>
                  setState(() => _quantity > 1 ? _quantity-- : null),
              icon: const Icon(Icons.remove)),
          Text("$_quantity",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
              onPressed: () => setState(() => _quantity++),
              icon: const Icon(Icons.add)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
          child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined),
                SizedBox(width: 10),
                Text("Sepete Ekle")
              ]),
        )),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
          child: const Text("Hemen Al"),
        ),
      ],
    );
  }

  // Mobile Layout ve Related Products metodları benzer mantıkla (product ID dinleyerek) eklenebilir.
  Widget _buildMobileLayout(BuildContext context, Product product) =>
      const SliverToBoxAdapter(child: Center(child: Text("Mobil Görünüm")));

  SliverToBoxAdapter _buildRelatedProducts(BuildContext context) =>
      const SliverToBoxAdapter(child: SizedBox());
}

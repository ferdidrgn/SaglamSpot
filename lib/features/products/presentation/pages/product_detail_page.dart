import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/features/products/domain/entites/product.dart';

import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/gallery_section.dart';
import '../providers/product_notifier.dart'; //
import '../providers/product_provider.dart'; //

class WebProductDetailPage extends ConsumerStatefulWidget {
  final String productId;

  const WebProductDetailPage({super.key, required this.productId});

  @override
  ConsumerState<WebProductDetailPage> createState() =>
      _WebProductDetailPageState();
}

class _WebProductDetailPageState extends ConsumerState<WebProductDetailPage> {
  int _selectedImageIndex = 0;
  bool _isFavorite = false;

  @override
  Widget build(final BuildContext context) {
    final productState = ref.watch(productProvider); //
    final product = productState.dataList?.firstWhere(
      (final p) => p.id == widget.productId,
      orElse: () => throw Exception("Ürün bulunamadı"),
    );

    if (product == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD), // Daha temiz bir beyaz
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, product),
          _buildResponsiveLayout(context, product),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
          const SliverToBoxAdapter(child: AdsenseBanner(height: 100)),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(final BuildContext context, final Product product) {
    return SliverAppBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 0,
      pinned: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close_rounded, color: Colors.black, size: 24),
      ),
      title: Text(
        product.category.toUpperCase(),
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.grey,
            letterSpacing: 2),
      ),
      centerTitle: true,
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
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildResponsiveLayout(
      final BuildContext context, final Product product) {
    if (context.isDesktop) {
      return _buildDesktopLayout(context, product);
    } else {
      return _buildMobileLayout(context, product);
    }
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
                  flex: 7,
                  child: _buildShowroomGallery(context, product, height: 700)),
              const SizedBox(width: 80),
              Expanded(flex: 4, child: _buildShowroomInfo(context, product)),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildMobileLayout(
      final BuildContext context, final Product product) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          _buildShowroomGallery(context, product, height: 450, isMobile: true),
          _buildShowroomInfo(context, product, isMobile: true),
        ],
      ),
    );
  }

  Widget _buildShowroomGallery(
      final BuildContext context, final Product product,
      {required final double height, final bool isMobile = false}) {
    return Column(
      children: [
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Stack(
            children: [
              // Showroom Tasarım Elemanı
              Positioned(
                top: 40,
                left: 40,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    "COLLECTION 2026",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.black.withOpacity(0.1),
                        letterSpacing: 4),
                  ),
                ),
              ),
              Center(
                child: Hero(
                  tag: 'prod_img_${product.id}',
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: Padding(
                      key: ValueKey(_selectedImageIndex),
                      padding: const EdgeInsets.all(60.0),
                      child: Image.network(
                        product.imagesUrl[_selectedImageIndex],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildMinimalThumbnails(product),
      ],
    );
  }

  Widget _buildMinimalThumbnails(final Product product) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: product.imagesUrl.length,
        separatorBuilder: (final _, final __) => const SizedBox(width: 12),
        itemBuilder: (final context, final index) {
          final isSelected = _selectedImageIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedImageIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    Image.network(product.imagesUrl[index], fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShowroomInfo(final BuildContext context, final Product product,
      {final bool isMobile = false}) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 24 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("ÖZEL TASARIM",
              style: TextStyle(
                  letterSpacing: 2,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary)),
          const SizedBox(height: 12),
          Text(
            product.name,
            style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                letterSpacing: -2,
                height: 1),
          ),
          const SizedBox(height: 32),
          Text(
            "EST. VALUE",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400]),
          ),
          const SizedBox(height: 8),
          Text(
            "₺${product.price.toStringAsFixed(0)}",
            style: const TextStyle(
                fontSize: 32, fontWeight: FontWeight.w300, color: Colors.black),
          ),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 40),
          const Text("ÜRÜN HİKAYESİ",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
          const SizedBox(height: 16),
          Text(
            product.desc,
            style: TextStyle(
                color: Colors.grey[700],
                height: 1.8,
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 60),
          _buildShowroomActions(),
        ],
      ),
    );
  }

  Widget _buildShowroomActions() {
    return Column(
      children: [
        _buildLargeButton(
          "SHOWROOMDA İNCELE",
          Colors.black,
          Colors.white,
          Icons.location_on_outlined,
        ),
        const SizedBox(height: 16),
        _buildLargeButton(
          "UZMANA DANIŞ",
          Colors.white,
          Colors.black,
          Icons.chat_bubble_outline_rounded,
          hasBorder: true,
        ),
      ],
    );
  }

  Widget _buildLargeButton(
      final String text, final Color bg, final Color fg, final IconData icon,
      {final bool hasBorder = false}) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border:
            hasBorder ? Border.all(color: Colors.black.withOpacity(0.1)) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: 20),
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

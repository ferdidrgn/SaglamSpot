import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/features/products/domain/entites/product.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../providers/product_provider.dart';

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
    final productsAsync = ref.watch(productsProvider);

    return productsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (final e, final _) => Scaffold(
        body: Center(child: Text(e.toString())),
      ),
      data: (final products) {
        final product = products.firstWhere(
          (final p) => p.id == widget.productId,
          orElse: () => throw Exception('Ürün bulunamadı'),
        );

        return Scaffold(
          backgroundColor: const Color(0xFFFDFDFD),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, product),
              _buildResponsiveLayout(context, product),
              SliverToBoxAdapter(child: SizedBox(height: context.spacingLarge)),
              const SliverToBoxAdapter(child: AdsenseBanner(height: 100)),
              SliverToBoxAdapter(
                  child: SizedBox(height: context.spacingLarge * 2)),
            ],
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------------

  SliverAppBar _buildAppBar(final BuildContext context, final Product product) {
    return SliverAppBar(
      backgroundColor: Colors.white.withOpacity(0.9),
      elevation: 0,
      pinned: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close_rounded, color: Colors.black),
      ),
      title: Text(
        product.category.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.grey,
          letterSpacing: 2,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => setState(() => _isFavorite = !_isFavorite),
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.black,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildResponsiveLayout(
      final BuildContext context, final Product product) {
    return context.responsive(
      mobile: _buildMobileLayout(context, product),
      desktop: _buildDesktopLayout(context, product),
    );
  }

  SliverToBoxAdapter _buildDesktopLayout(
      final BuildContext context, final Product product) {
    return SliverToBoxAdapter(
      child: Center(
        child: context.maxWidth(
          width: 1400,
          child: Padding(
            padding: context.sectionPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child:
                      _buildGallery(context, product, height: context.hp(60)),
                ),
                SizedBox(width: context.spacingLarge),
                Expanded(
                  flex: 4,
                  child: _buildInfo(context, product),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildMobileLayout(
      final BuildContext context, final Product product) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: context.pagePadding,
        child: Column(
          children: [
            _buildGallery(context, product, height: context.hp(50)),
            SizedBox(height: context.spacingLarge),
            _buildInfo(context, product, isMobile: true),
          ],
        ),
      ),
    );
  }

  // ----------------- GALLERY -----------------

  Widget _buildGallery(final BuildContext context, final Product product,
      {required final double height}) {
    return Column(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(context.borderRadius()),
          ),
          child: Center(
            child: Image.network(
              product.imagesUrl[_selectedImageIndex],
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: context.spacing),
        SizedBox(
          height: context.hp(10),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: product.imagesUrl.length,
            separatorBuilder: (final _, final __) =>
                SizedBox(width: context.spacing),
            itemBuilder: (final _, final i) => GestureDetector(
              onTap: () => setState(() => _selectedImageIndex = i),
              child: Container(
                width: context.wp(10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: i == _selectedImageIndex
                          ? Colors.black
                          : Colors.transparent),
                ),
                child: Image.network(
                  product.imagesUrl[i],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ----------------- INFO -----------------

  Widget _buildInfo(final BuildContext context, final Product product,
      {final bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name,
            style: TextStyle(
                fontSize: context.h1Size, fontWeight: FontWeight.w900)),
        SizedBox(height: context.spacing),
        Text(
          "₺${product.price.toStringAsFixed(0)}",
          style: TextStyle(
              fontSize: context.priceSize, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: context.spacingLarge),
        Text(
          product.desc,
          style: TextStyle(
              fontSize: context.bodySize, height: 1.6, color: Colors.grey[700]),
        ),
        SizedBox(height: context.spacingLarge * 2),
        _buildActionButton("SHOWROOMDA İNCELE"),
        SizedBox(height: context.spacing),
        _buildActionButton("UZMANA DANIŞ", inverted: true),
      ],
    );
  }

  Widget _buildActionButton(final String text, {final bool inverted = false}) {
    return Container(
      height: context.hp(7),
      decoration: BoxDecoration(
        color: inverted ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(context.borderRadius()),
        border: inverted ? Border.all(color: Colors.black12) : null,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: inverted ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

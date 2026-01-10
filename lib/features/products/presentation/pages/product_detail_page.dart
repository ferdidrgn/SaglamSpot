import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/theme/app_colors.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/features/products/domain/entites/product.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../providers/product_notifier.dart';

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
    final productState = ref.watch(productProvider);
    final product = productState.dataList?.firstWhere(
      (final p) => p.id == widget.productId,
      orElse: () => throw Exception("Ürün bulunamadı"),
    );

    if (product == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, product),
          _buildResponsiveLayout(context, product),
          SliverToBoxAdapter(child: SizedBox(height: context.spacingLarge)),
          const SliverToBoxAdapter(child: AdsenseBanner(height: 100)),
          SliverToBoxAdapter(child: SizedBox(height: context.spacingLarge * 2)),
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
                  child: _buildShowroomGallery(context, product,
                      height: context.hp(60)),
                ),
                SizedBox(width: context.spacingLarge),
                Expanded(flex: 4, child: _buildShowroomInfo(context, product)),
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
            _buildShowroomGallery(context, product,
                height: context.hp(50), isMobile: true),
            SizedBox(height: context.spacingLarge),
            _buildShowroomInfo(context, product, isMobile: true),
          ],
        ),
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
            borderRadius: BorderRadius.circular(context.borderRadius()),
          ),
          child: Stack(
            children: [
              Positioned(
                top: context.spacing,
                left: context.spacing,
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
                      padding: EdgeInsets.all(context.spacingLarge),
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
        SizedBox(height: context.spacing),
        _buildMinimalThumbnails(product),
      ],
    );
  }

  Widget _buildMinimalThumbnails(final Product product) {
    return SizedBox(
      height: context.hp(10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: product.imagesUrl.length,
        separatorBuilder: (_, __) => SizedBox(width: context.spacing),
        itemBuilder: (context, index) {
          final isSelected = _selectedImageIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedImageIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: context.wp(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.borderRadius(0.8)),
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 1.5,
                ),
              ),
              padding: EdgeInsets.all(context.spacing / 3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.borderRadius(0.6)),
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
      padding: EdgeInsets.all(isMobile ? context.spacing : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ÖZEL TASARIM",
              style: TextStyle(
                  letterSpacing: 2,
                  fontSize: context.captionSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary)),
          SizedBox(height: context.spacing),
          Text(
            product.name,
            style: TextStyle(
                fontSize: context.h1Size,
                fontWeight: FontWeight.w900,
                letterSpacing: -2,
                height: 1),
          ),
          SizedBox(height: context.spacingLarge),
          Text(
            "EST. VALUE",
            style: TextStyle(
                fontSize: context.captionSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey[400]),
          ),
          SizedBox(height: context.spacing / 2),
          Text(
            "₺${product.price.toStringAsFixed(0)}",
            style: TextStyle(
                fontSize: context.priceSize,
                fontWeight: FontWeight.w300,
                color: Colors.black),
          ),
          SizedBox(height: context.spacingLarge),
          const Divider(),
          SizedBox(height: context.spacingLarge),
          Text("ÜRÜN HİKAYESİ",
              style: TextStyle(
                  fontSize: context.h3Size,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1)),
          SizedBox(height: context.spacing),
          Text(
            product.desc,
            style: TextStyle(
                color: Colors.grey[700],
                height: 1.8,
                fontSize: context.bodySize,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(height: context.spacingLarge * 2),
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
        SizedBox(height: context.spacing),
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
      height: context.hp(7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.borderRadius()),
        border:
            hasBorder ? Border.all(color: Colors.black.withOpacity(0.1)) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(context.borderRadius()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: context.iconMedium),
              SizedBox(width: context.spacing),
              Text(
                text,
                style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w900,
                    fontSize: context.bodySize,
                    letterSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

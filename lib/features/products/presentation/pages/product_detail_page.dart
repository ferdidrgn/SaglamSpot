import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saglamspot/core/util/responsive_utils.dart';
import 'package:saglamspot/features/products/domain/entites/product.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/product_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';


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
  bool _showMoreDescription = false;

  @override
  Widget build(final BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return productsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body:
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (final e, final _) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
            child: Text(e.toString(),
                style: const TextStyle(color: AppColors.textPrimary))),
      ),
      data: (final products) {
        final product = products.firstWhere(
          (final p) => p.id == widget.productId,
          orElse: () => throw Exception('Ürün bulunamadı'),
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildHeroAppBar(context, product),
              _buildResponsiveLayout(context, product),
              _buildAdditionalInfo(context, product),
              _buildSimilarProducts(context),
              SliverToBoxAdapter(
                  child: SizedBox(height: context.spacingLarge * 3)),
            ],
          ),
          floatingActionButton: _buildFloatingActions(context, product),
        );
      },
    );
  }

  // ----------------------------------------------------------------

  SliverAppBar _buildHeroAppBar(
      BuildContext context, Product product) {
    return SliverAppBar(
      pinned: true,
      toolbarHeight: 64,
      collapsedHeight: 64,
      expandedHeight: context.responsive(mobile: 160, desktop: 240),
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 8),
        title: Text(
          product.category.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 2,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
      child: Padding(
        padding: context.sectionPadding,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: _buildGallerySection(context, product,
                    height: context.hp(65)),
              ),
              SizedBox(width: context.spacingLarge * 2),
              Expanded(
                flex: 4,
                child: _buildInfoSection(context, product),
              ),
            ],
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
            _buildGallerySection(context, product,
                height: context.hp(45), isMobile: true),
            SizedBox(height: context.spacingLarge * 2),
            _buildInfoSection(context, product, isMobile: true),
          ],
        ),
      ),
    );
  }

  // ----------------- GALLERY SECTION -----------------

  Widget _buildGallerySection(final BuildContext context, final Product product,
      {required final double height, final bool isMobile = false}) {
    return Column(
      children: [
        // Main Image with Decorative Frame
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withOpacity(0.05),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Mozaik Pattern Background
              _buildMosaicPattern(),
              // Main Image
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      product.imagesUrl[_selectedImageIndex],
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
              // Navigation Arrows
              if (product.imagesUrl.length > 1)
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavigationArrow(context, isLeft: true),
                      _buildNavigationArrow(context, isLeft: false),
                    ],
                  ),
                ),
              // Image Counter
              Positioned(
                bottom: 20,
                right: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    '${_selectedImageIndex + 1}/${product.imagesUrl.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.spacingLarge),
        // Thumbnail Gallery
        Container(
          height: context.hp(12),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: product.imagesUrl.length,
            separatorBuilder: (final _, final __) =>
                SizedBox(width: context.spacing),
            itemBuilder: (final _, final i) => GestureDetector(
              onTap: () => setState(() => _selectedImageIndex = i),
              child: Container(
                width: context.wp(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: i == _selectedImageIndex
                        ? AppColors.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: i == _selectedImageIndex
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.imagesUrl[i],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMosaicPattern() {
    return Opacity(
      opacity: 0.03,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1550686041-366ad85a1355?auto=format&fit=crop&w=1600&q=80'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.modulate,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationArrow(final BuildContext context,
      {required final bool isLeft}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface.withOpacity(0.9),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          isLeft ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
          color: AppColors.textPrimary,
          size: 28,
        ),
      ),
    );
  }

  // ----------------- INFO SECTION -----------------

  Widget _buildInfoSection(final BuildContext context, final Product product,
      {final bool isMobile = false}) {
    final shortDesc = product.desc.length > 150
        ? '${product.desc.substring(0, 150)}...'
        : product.desc;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.03),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Title with Badge
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ÖZEL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.spacing),

          // Price with Elegant Design
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  '₺',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  product.price.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: isMobile ? 48 : 56,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textPrimary,
                    height: 0.9,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.spacingLarge * 1.5),

          // Description with Expand/Collapse
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AÇIKLAMA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedCrossFade(
                firstChild: Text(
                  shortDesc,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    color: AppColors.textPrimary.withOpacity(0.9),
                  ),
                ),
                secondChild: Text(
                  product.desc,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.7,
                    color: AppColors.textPrimary.withOpacity(0.9),
                  ),
                ),
                crossFadeState: _showMoreDescription
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
              if (product.desc.length > 150)
                TextButton(
                  onPressed: () => setState(
                      () => _showMoreDescription = !_showMoreDescription),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _showMoreDescription
                            ? 'DAHA AZ GÖSTER'
                            : 'DEVAMINI OKU',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _showMoreDescription
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: context.spacingLarge * 2),

          // Action Buttons
          Column(
            children: [
              _buildActionButton(
                context,
                label: 'ŞİMDİ SATIN AL',
                icon: Icons.shopping_bag_rounded,
                isPrimary: true,
                onTap: () {},
              ),
              SizedBox(height: context.spacing),
              _buildActionButton(
                context,
                label: 'KOLEKSİYONDA İNCELE',
                icon: Icons.remove_red_eye_rounded,
                isPrimary: false,
                onTap: () {},
              ),
              if (isMobile) SizedBox(height: context.spacingLarge * 2),
            ],
          ),

          // Details Grid
          if (!isMobile) ...[
            SizedBox(height: context.spacingLarge * 2),
            _buildDetailsGrid(product),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    final BuildContext context, {
    required final String label,
    required final IconData icon,
    required final bool isPrimary,
    required final VoidCallback onTap,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: isPrimary ? AppColors.primaryGradient : null,
        color: isPrimary ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border:
            isPrimary ? null : Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    color: isPrimary ? Colors.white : AppColors.textPrimary,
                    size: 20),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isPrimary ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(final Product product) {
    final details = [
      {
        'icon': Icons.category_rounded,
        'label': 'Kategori',
        'value': product.category
      },
      {
        'icon': Icons.flag_rounded,
        'label': 'Durum',
        'value': (product.isSpotProduct ? "İkinci El" : "Sıfır")
      },
      {'icon': Icons.calendar_today_rounded, 'label': 'Yıl', 'value': '2023'},
      {
        'icon': Icons.location_on_rounded,
        'label': 'Konum',
        'value': 'İstanbul'
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3,
      ),
      itemCount: details.length,
      itemBuilder: (final context, final index) {
        final detail = details[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(detail['icon'] as IconData,
                  size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    detail['label'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    detail['value'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ----------------- ADDITIONAL SECTIONS -----------------

  SliverToBoxAdapter _buildAdditionalInfo(
      final BuildContext context, final Product product) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: context.sectionPadding,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DETAYLAR',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: context.spacingLarge),
              Container(
                width: context.screenWidth,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Expanded(
                    child: Text(
                      product.desc,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildSimilarProducts(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: context.sectionPadding,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'BENZER ÜRÜNLER',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Text(
                          'TÜMÜNÜ GÖR',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded,
                            size: 16, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.spacingLarge),
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Text(
                    'Benzer ürünler burada gösterilecek',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActions(
      final BuildContext context, final Product product) {
    if (MediaQuery.sizeOf(context).width < 768) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 32, right: 32),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () {},
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: AppColors.border),
            ),
            icon: const Icon(Icons.share_rounded),
            label: const Text('PAYLAŞ'),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            child: const Icon(Icons.message_rounded),
          ),
        ],
      ),
    );
  }
}

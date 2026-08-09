import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/common/extentions/product_category_ex.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import '../../../products/data/models/category_meta.dart';
import '../../../products/domain/entites/product.dart';
import '../../../products/presentation/providers/category_meta_provider.dart';

/// Küçük filtre chip'lerinden farklı, her kategori için büyük görsel
/// karo (tile) gösteren zengin bir vitrin. Her karo o kategorideki canlı
/// ürün sayısını gösterir ve tıklanınca arama sayfasına o kategoriyle gider.
class PopularCategoriesShowcase extends ConsumerWidget {
  final List<Product> allProducts;

  const PopularCategoriesShowcase({super.key, required this.allProducts});

  static const Map<ProductCategory, String> _images = {
    ProductCategory.sofa:
        'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?q=80&w=800',
    ProductCategory.chair:
        'https://images.unsplash.com/photo-1503602642458-232111445657?q=80&w=800',
    ProductCategory.table:
        'https://images.unsplash.com/photo-1449247709967-d4461a6a6103?q=80&w=800',
    ProductCategory.bed:
        'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?q=80&w=800',
    ProductCategory.wardrobe:
        'https://images.unsplash.com/photo-1595428774223-ef52624120d2?q=80&w=800',
    ProductCategory.white:
        'https://images.unsplash.com/photo-1556911220-bff31c812dba?q=80&w=800',
    ProductCategory.other:
        'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?q=80&w=800',
  };

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final categories = ref.watch(orderedActiveCategoriesProvider);
    final isMobile = MediaQuery.of(context).size.width < 900;

    return SliverPadding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 60, vertical: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Popüler Kategoriler',
                style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: context.h2Size,
                    fontWeight: FontWeight.w600,
                    color: context.primaryColor)),
            const SizedBox(height: 4),
            Container(height: 3, width: 40, color: AppColors.accent),
            const SizedBox(height: 8),
            Text('İhtiyacına uygun mobilyayı tek tıkla bul',
                style: TextStyle(
                    color: context.primaryColor.withOpacity(0.5),
                    fontSize: context.captionSize)),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isMobile ? 0.95 : 1.05,
              ),
              itemCount: categories.length,
              itemBuilder: (final context, final index) {
                final meta = categories[index];
                final count = allProducts
                    .where((final p) => p.category == meta.category && !p.isSold)
                    .length;
                return _CategoryTile(
                  meta: meta,
                  count: count,
                  imageUrl: _images[meta.category] ?? _images[ProductCategory.other]!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatefulWidget {
  final CategoryMeta meta;
  final int count;
  final String imageUrl;

  const _CategoryTile(
      {required this.meta, required this.count, required this.imageUrl});

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _isHovered = false;

  @override
  Widget build(final BuildContext context) {
    final label = widget.meta.customLabel ?? widget.meta.category.label(context);

    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => NavigationHandler.goToSearchWithCategory(
            context, widget.meta.category.toFirestore()),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -4.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.meta.color.withOpacity(_isHovered ? 0.35 : 0.12),
                blurRadius: _isHovered ? 24 : 14,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: _isHovered ? 1.08 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  child: Image.network(widget.imageUrl, fit: BoxFit.cover),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.meta.color.withOpacity(0.15),
                        Colors.black.withOpacity(0.75),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(widget.meta.icon,
                        color: widget.meta.color, size: 20),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16)),
                      const SizedBox(height: 2),
                      Text('${widget.count} ürün',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

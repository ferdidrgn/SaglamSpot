import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saglamspot/features/products/domain/entites/product.dart';
import '../../features/products/data/models/category_meta.dart';
import '../../features/products/presentation/providers/category_meta_provider.dart';
import '../common/enum/enums.dart';
import '../common/extentions/app_context_ui_extension.dart';
import '../common/extentions/product_category_ex.dart';
import '../common/extentions/reg_exp_extentions.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../shared/navigation/widgets/nav_handler.dart';
import 'design_system/tactile_press.dart';
import 'gallery_section.dart';
import 'optimized_cached_image.dart';

/// EDİTORYAL KATALOG DİLİ — "Sıfır Ürünler" ve "İkinci El" sayfalarına
/// özel, geri kalan uygulamadan (CustomProductCard / DynamicCategoryChips /
/// ProductListCard) bilinçli olarak AYRIŞTIRILMIŞ bir görsel dil: renkli
/// gradyanlı çip yerine düz metin sekmeler, ağır gölge yerine ince tel
/// kenarlık, yuvarlatılmış rozet yerine tek renkli nokta+etiket. Marka
/// renkleri (AppColors) korunuyor — sadece ŞEKİL DİLİ değişiyor.
///
/// Saf beyaz/boş bir sayfa "taslak kağıdı" gibi durmasın diye — çok soluk,
/// büyük mobilya silüetlerinden oluşan sanatsal bir doku katmanı. İçerik
/// DEĞİL, saf dekorasyon: erişilebilirlik ağacından ve dokunma
/// olaylarından hariç tutulur.
class FurnitureMotifBackdrop extends StatelessWidget {
  final bool dense;

  const FurnitureMotifBackdrop({super.key, this.dense = false});

  @override
  Widget build(final BuildContext context) => ExcludeSemantics(
        child: IgnorePointer(
          child: Stack(
            children: [
              Positioned(
                top: -36,
                right: -24,
                child: Transform.rotate(
                  angle: -0.16,
                  child: Icon(Icons.weekend_rounded,
                      size: dense ? 120 : 200,
                      color: AppColors.textPrimary.withOpacity(0.045)),
                ),
              ),
              Positioned(
                bottom: -18,
                left: -28,
                child: Transform.rotate(
                  angle: 0.14,
                  child: Icon(Icons.local_florist_rounded,
                      size: dense ? 70 : 130,
                      color: AppColors.accentDark.withOpacity(0.07)),
                ),
              ),
              if (!dense)
                Positioned(
                  top: 54,
                  right: 210,
                  child: Transform.rotate(
                    angle: 0.22,
                    child: Icon(Icons.light_rounded,
                        size: 64, color: AppColors.textTertiary.withOpacity(0.09)),
                  ),
                ),
              if (!dense)
                Positioned(
                  bottom: 24,
                  right: 40,
                  child: Icon(Icons.table_bar_rounded,
                      size: 80, color: AppColors.textTertiary.withOpacity(0.06)),
                ),
            ],
          ),
        ),
      );
}

/// İnce, tekrarlayan mobilya glifi şeridi — bölümler arası kalın çizgi
/// yerine kumaş desenine benzeyen sanatsal bir ayraç.
class FurnitureMotifDivider extends StatelessWidget {
  const FurnitureMotifDivider({super.key});

  static const _glyphs = [
    Icons.chair_rounded,
    Icons.local_florist_outlined,
    Icons.light_rounded,
    Icons.table_bar_rounded,
  ];

  @override
  Widget build(final BuildContext context) => ExcludeSemantics(
        child: SizedBox(
          height: 22,
          child: LayoutBuilder(
            builder: (final context, final constraints) {
              const step = 46.0;
              final count = (constraints.maxWidth / step).ceil() + 1;
              return ClipRect(
                child: Row(
                  children: List.generate(
                    count,
                    (final i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11),
                      child: Icon(_glyphs[i % _glyphs.length],
                          size: 13, color: AppColors.border),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}

class EditorialCategoryRail extends ConsumerWidget {
  final ProductCategory? selected;
  final ValueChanged<ProductCategory?> onSelect;
  final String allLabel;
  final EdgeInsets? padding;

  const EditorialCategoryRail({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.allLabel,
    this.padding,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final categories = ref.watch(orderedActiveCategoriesProvider);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding ?? EdgeInsets.symmetric(horizontal: context.pagePadding.left),
        itemCount: categories.length + 1,
        separatorBuilder: (final _, final __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('•', style: TextStyle(color: AppColors.border, fontSize: 13)),
        ),
        itemBuilder: (final context, final index) {
          if (index == 0) {
            return _RailTab(label: allLabel, isSelected: selected == null, onTap: () => onSelect(null));
          }
          final meta = categories[index - 1];
          final label = meta.customLabel ?? meta.category.label(context);
          return _RailTab(
            label: label,
            isSelected: selected == meta.category,
            onTap: () => onSelect(meta.category),
          );
        },
      ),
    );
  }
}

class _RailTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RailTab({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
            color: isSelected ? AppColors.textPrimary : AppColors.textTertiary,
            letterSpacing: 0.2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 2,
                width: isSelected ? 18 : 0,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      );
}

/// Izgara görünümü kartı — canlı, kategori rengiyle "ışıyan" (radiant) bir
/// gölgesi olan, yüksek köşe yarıçaplı Material tarzı bir kart. Kenarlık
/// odaklı eski soluk dile veda edip her kategorinin kendi rengiyle
/// tanınabildiği, hover'da gölgesi ve görseli büyüyen daha "canlı" bir his
/// hedefler — marka renkleri (AppColors) ve kategori paleti değişmedi,
/// sadece şekil dili.
class EditorialProductCard extends StatefulWidget {
  final Product product;

  const EditorialProductCard({super.key, required this.product});

  @override
  State<EditorialProductCard> createState() => _EditorialProductCardState();
}

class _EditorialProductCardState extends State<EditorialProductCard> {
  bool _isHovered = false;

  CategoryMeta get _meta =>
      defaultCategoryMeta[widget.product.category] ??
      defaultCategoryMeta[ProductCategory.other]!;

  @override
  Widget build(final BuildContext context) {
    final hasImage = widget.product.imagesUrl.isNotEmpty;
    final meta = _meta;

    return MouseRegion(
      onEnter: (final _) => setState(() => _isHovered = true),
      onExit: (final _) => setState(() => _isHovered = false),
      child: TactilePress(
        onTap: () => NavigationHandler.goToProduct(
          context: context,
          productId: widget.product.id,
          productSlug: widget.product.name.toSlug(),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              // Kategori renkli "radiant" glow — kartın kimliği.
              BoxShadow(
                color: meta.color.withOpacity(_isHovered ? 0.4 : 0.22),
                blurRadius: _isHovered ? 34 : 20,
                spreadRadius: -6,
                offset: const Offset(0, 16),
              ),
              // Zemine oturtan nötr, ince ikinci gölge.
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: ColoredBox(
              color: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: AppColors.secondary),
                        Hero(
                          tag: 'prod_img_${widget.product.id}',
                          child: AnimatedScale(
                            scale: _isHovered ? 1.06 : 1.0,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                            child: hasImage
                                ? OptimizedCachedImage(
                                    imageUrl: widget.product.imagesUrl.first,
                                    fit: BoxFit.cover,
                                    borderRadius: 0,
                                    errorBuilder: (final c, final u, final e) =>
                                        const _ImageFallback(),
                                  )
                                : const _ImageFallback(),
                          ),
                        ),
                        Positioned(top: 10, left: 10, child: _CategoryChip(meta: meta)),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: AnimatedOpacity(
                            opacity: _isHovered ? 1 : 0,
                            duration: const Duration(milliseconds: 180),
                            child: _RoundGhostButton(
                              icon: Icons.fullscreen_rounded,
                              onTap: () => _openGallery(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: GoogleFonts.fraunces(
                            color: AppColors.textPrimary,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '₺${widget.product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Spacer(),
                            _ConditionDot(isSpotProduct: widget.product.isSpotProduct),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openGallery(final BuildContext context) => showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (final context) => GalleryViewerDialog(
            images: widget.product.imagesUrl, isMobile: context.screenWidth < 900),
      );
}

/// Görselin sol üst köşesine oturan, kategori rengiyle boyanmış küçük
/// beyaz-zeminli rozet — ikon + kısaltılmış kategori adı.
class _CategoryChip extends StatelessWidget {
  final CategoryMeta meta;

  const _CategoryChip({required this.meta});

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.14), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(meta.icon, size: 11, color: meta.color),
            const SizedBox(width: 4),
            Text(
              (meta.customLabel ?? meta.category.label(context)).toUpperCase(),
              style: AppTextStyles.microLabel(fontSize: 9, letterSpacing: 0.5, color: meta.color),
            ),
          ],
        ),
      );
}

/// Liste görünümü satırı — kart yerine ince ayraçlı, katalog defteri hissi.
class EditorialProductRow extends StatelessWidget {
  final Product product;

  const EditorialProductRow({super.key, required this.product});

  @override
  Widget build(final BuildContext context) {
    final meta = defaultCategoryMeta[product.category] ?? defaultCategoryMeta[ProductCategory.other]!;

    return TactilePress(
      onTap: () => NavigationHandler.goToProduct(
        context: context,
        productId: product.id,
        productSlug: product.name.toSlug(),
      ),
      pressScale: 0.98,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: meta.color.withOpacity(0.16), blurRadius: 18, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 84,
                height: 84,
                color: AppColors.secondary,
                child: product.imagesUrl.isNotEmpty
                    ? OptimizedCachedImage(
                        imageUrl: product.imagesUrl.first,
                        width: 84,
                        height: 84,
                        fit: BoxFit.cover,
                        borderRadius: 0,
                      )
                    : const _ImageFallback(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(meta.icon, size: 11, color: meta.color),
                      const SizedBox(width: 4),
                      Text(
                        product.category.label(context).toUpperCase(),
                        style: AppTextStyles.microLabel(
                            fontSize: 9.5, letterSpacing: 1.1, color: meta.color),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fraunces(
                        fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('₺${product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: AppColors.accent)),
                      const SizedBox(width: 10),
                      _ConditionDot(isSpotProduct: product.isSpotProduct),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _ConditionDot extends StatelessWidget {
  final bool isSpotProduct;
  const _ConditionDot({required this.isSpotProduct});

  @override
  Widget build(final BuildContext context) {
    final color = isSpotProduct ? AppColors.accentDark : AppColors.success;
    final label =
        isSpotProduct ? context.l10n.usedProductBadge : context.l10n.productCardNewBadge;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(label, style: AppTextStyles.microLabel(fontSize: 10, letterSpacing: 0.4, color: color)),
        ],
      ),
    );
  }
}

class _RoundGhostButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundGhostButton({required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) => Material(
        color: Colors.black.withOpacity(0.4),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
        ),
      );
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(final BuildContext context) =>
      Center(child: Icon(Icons.chair_rounded, size: 34, color: AppColors.textTertiary));
}

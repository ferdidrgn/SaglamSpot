import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entites/product.dart';

/// Ürünün İKİNCİ EL/SIFIR ayrımına göre doğru bileşeni gösterir:
/// - Sıfır ürün + renk seçenekleri tanımlıysa -> tıklanabilir renk paleti
/// - İkinci el (spot) ürünse -> "Tek Parça" rozeti (çünkü fiziksel olarak
///   satılan tek bir ürün var, renk seçimi anlamsız/yanıltıcı olur)
/// - Sıfır ürün ama renk tanımlı değilse -> hiçbir şey göstermez
class ProductColorSection extends StatefulWidget {
  final Product product;
  final ValueChanged<String>? onColorSelected;

  const ProductColorSection(
      {super.key, required this.product, this.onColorSelected});

  @override
  State<ProductColorSection> createState() => _ProductColorSectionState();
}

class _ProductColorSectionState extends State<ProductColorSection> {
  String? _selectedHex;

  @override
  void initState() {
    super.initState();
    if (widget.product.availableColors.isNotEmpty) {
      _selectedHex = widget.product.availableColors.first;
    }
  }

  @override
  Widget build(final BuildContext context) {
    final product = widget.product;

    // İkinci el / spot ürün: tek parça olduğunu netleştiren bir bilgi rozeti.
    final bool isMobile = context.isMobile;
    final Color accent = isMobile ? AppColors.mobileAccent : AppColors.accent;
    final Color accentDark = isMobile ? AppColors.mobileAccentDark : AppColors.accentDark;
    final Color textPrimary = isMobile ? AppColors.mobileTextPrimary : AppColors.textPrimary;

    if (product.isSpotProduct) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: accent.withOpacity(0.16),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.inventory_2_rounded, color: accentDark, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Bu, ikinci el / spot bir üründür — stokta tek parça vardır, '
                'renk ve görsel tamamen fotoğraflardaki gibidir.',
                style: TextStyle(
                    fontSize: 12.5,
                    color: textPrimary.withOpacity(0.8),
                    height: 1.4,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    }

    // Sıfır ürün ama renk seçeneği tanımlanmamışsa hiçbir şey gösterme.
    if (product.availableColors.isEmpty) return const SizedBox.shrink();

    // Sıfır ürün + renk seçenekleri var: seçilebilir renk paleti.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Renk Seçenekleri',
                style: TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 14, color: textPrimary)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('SIFIR ÜRÜN',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.success)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (final hex in product.availableColors) ...[
              _ColorSwatch(
                hex: hex,
                isSelected: _selectedHex == hex,
                onTap: () {
                  setState(() => _selectedHex = hex);
                  widget.onColorSelected?.call(hex);
                },
              ),
              const SizedBox(width: 12),
            ],
          ],
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String hex;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorSwatch(
      {required this.hex, required this.isSelected, required this.onTap});

  Color get _color {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.mediumGrey;
    }
  }

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _color,
          border: Border.all(
            color: isSelected
                ? (context.isMobile ? AppColors.mobilePrimary : AppColors.primary)
                : Colors.white,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _color.withOpacity(isSelected ? 0.5 : 0.25),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isSelected
            ? Icon(Icons.check_rounded,
                size: 16,
                color: _color.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white)
            : null,
      ),
    );
  }
}

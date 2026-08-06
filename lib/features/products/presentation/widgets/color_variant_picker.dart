import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Sıfır ürünler için opsiyonel renk seçeneği ataması. İkinci el ürünlerde
/// tek bir fiziksel parça olduğu için bu alan admin formunda gösterilmez
/// (bkz. product_color_section.dart — vitrin tarafında aynı mantık geçerli).
class ColorVariantPicker extends StatelessWidget {
  final List<String> selectedHexColors;
  final ValueChanged<List<String>> onChanged;

  const ColorVariantPicker({
    super.key,
    required this.selectedHexColors,
    required this.onChanged,
  });

  static const List<String> _palette = [
    '#0F302A', // Zümrüt (marka)
    '#C5A358', // Altın
    '#8B5E3C', // Ceviz
    '#5A6E6A', // Gri-yeşil
    '#3E6B8A', // Petrol mavisi
    '#B2673E', // Sıcak ahşap
    '#6B5CA5', // Lila-indigo
    '#1A1A1A', // Siyah
    '#E5E0D8', // Krem
    '#D32F2F', // Kırmızı
  ];

  void _toggle(final String hex) {
    final current = List<String>.from(selectedHexColors);
    if (current.contains(hex)) {
      current.remove(hex);
    } else {
      current.add(hex);
    }
    onChanged(current);
  }

  @override
  Widget build(final BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _palette.map((final hex) {
        final isSelected = selectedHexColors.contains(hex);
        final color = Color(int.parse(hex.replaceFirst('#', '0xFF')));
        return GestureDetector(
          onTap: () => _toggle(hex),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.accent : Colors.white,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(isSelected ? 0.45 : 0.2),
                  blurRadius: isSelected ? 10 : 5,
                ),
              ],
            ),
            child: isSelected
                ? Icon(Icons.check_rounded,
                    size: 18,
                    color: color.computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }
}

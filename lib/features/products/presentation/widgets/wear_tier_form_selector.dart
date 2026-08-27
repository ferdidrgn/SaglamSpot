import 'package:flutter/material.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/product_wear_tier_ex.dart';
import '../../../../core/theme/app_colors.dart';

/// Spot ürün ekleme/düzenleme formunda kullanılan, tek seçimli yıpranma
/// seviyesi seçici — [CategoryFormSelector] ile aynı görsel dili kullanır.
/// Esnafın kendi elle girdiği dürüst bilgi; boş bırakılabilir.
class WearTierFormSelector extends StatelessWidget {
  final ProductWearTier? selected;
  final ValueChanged<ProductWearTier> onSelect;

  const WearTierFormSelector(
      {super.key, required this.selected, required this.onSelect});

  @override
  Widget build(final BuildContext context) => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: ProductWearTier.values.map((final tier) {
          final isSelected = selected == tier;
          return GestureDetector(
            onTap: () => onSelect(tier),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? tier.color : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? tier.color : AppColors.border,
                  width: 1.4,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: tier.color.withOpacity(0.3), blurRadius: 10)]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(tier.icon,
                      size: 16, color: isSelected ? Colors.white : tier.color),
                  const SizedBox(width: 6),
                  Text(
                    tier.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
}

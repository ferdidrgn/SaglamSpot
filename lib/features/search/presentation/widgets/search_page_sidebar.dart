import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/search_providers.dart';

/// `SearchPage`'in masaüstü kalıcı yan panelinde kullandığı küçük widget'lar
/// — eskiden sayfa dosyasının sonunda duruyordu, okunabilirlik için ayrı
/// dosyaya taşındı. Davranış/görünüm AYNI kaldı.

/// Üst çubuktaki geri butonu — sade, yuvarlak, ikon tabanlı.
class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const RoundIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(final BuildContext context) => Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: SizedBox(
            width: context.responsive(mobile: 46.0, desktop: 50.0),
            height: context.responsive(mobile: 46.0, desktop: 50.0),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
        ),
      );
}

/// Yan paneldeki kategori satırı: ikon + isim + adet, seçiliyse vurgulanır.
class SidebarCategoryRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const SidebarCategoryRow({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 18, color: selected ? color : AppColors.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              Text('$count',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary)),
            ],
          ),
        ),
      );
}

/// Yan paneldeki durum seçici — üç eşit segment (Tümü / Sıfır / İkinci El).
class SidebarConditionSelector extends ConsumerWidget {
  final dynamic filters;

  const SidebarConditionSelector({super.key, required this.filters});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final notifier = ref.read(searchFiltersProvider.notifier);
    final current = filters.condition ?? ProductCondition.all;

    return Row(
      children: ProductCondition.values.map((final cond) {
        final isSelected = current == cond;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                right: cond == ProductCondition.values.last ? 0 : 8),
            child: InkWell(
              onTap: () => notifier.setCondition(cond),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  cond.label(context),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Yan paneldeki fiyat aralığı — eski dialog+metin kutuları yerine tek
/// bakışta anlaşılan bir RangeSlider.
class SidebarPriceRange extends ConsumerStatefulWidget {
  final dynamic filters;

  const SidebarPriceRange({super.key, required this.filters});

  @override
  ConsumerState<SidebarPriceRange> createState() => _SidebarPriceRangeState();
}

class _SidebarPriceRangeState extends ConsumerState<SidebarPriceRange> {
  static const double _cap = 100000;
  late RangeValues _localValues;

  @override
  void initState() {
    super.initState();
    _localValues = RangeValues(
      widget.filters.minPrice.toDouble().clamp(0, _cap),
      widget.filters.maxPrice.toDouble().clamp(0, _cap),
    );
  }

  @override
  void didUpdateWidget(covariant final SidebarPriceRange oldWidget) {
    super.didUpdateWidget(oldWidget);
    _localValues = RangeValues(
      widget.filters.minPrice.toDouble().clamp(0, _cap),
      widget.filters.maxPrice.toDouble().clamp(0, _cap),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('₺${_localValues.start.toInt()}',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text(
                '₺${_localValues.end.toInt()}${_localValues.end >= _cap ? '+' : ''}',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: AppColors.border,
            thumbColor: AppColors.accent,
            overlayColor: AppColors.accent.withOpacity(0.15),
            rangeThumbShape:
                const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 3,
          ),
          child: RangeSlider(
            values: _localValues,
            min: 0,
            max: _cap,
            divisions: 100,
            onChanged: (final values) => setState(() => _localValues = values),
            onChangeEnd: (final values) => ref
                .read(searchFiltersProvider.notifier)
                .setPriceRange(values.start, values.end),
          ),
        ),
      ],
    );
  }
}

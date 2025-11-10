import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/search/search_providers.dart';
import '../../data/providers/search/search_filters_notifier.dart';
import '../../data/providers/search/search_state.dart';

class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);
    final notifier = ref.read(searchFiltersProvider.notifier);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandleBar(),
          const SizedBox(height: 16),
          _buildTitleRow(context),
          const SizedBox(height: 24),
          _buildConditionSection(filters.condition, notifier),
          const SizedBox(height: 28),
          _buildPriceSection(filters, notifier),
          const SizedBox(height: 36),
          _buildActionButtons(context, notifier),
        ],
      ),
    );
  }

  Widget _buildHandleBar() => Center(
        child: Container(
          width: 48,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  Widget _buildTitleRow(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Filtrele',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }

  Widget _buildConditionSection(
      final String? selected, final SearchFiltersNotifier notifier) {
    const conditions = ['Hepsi', 'Sıfır', 'İkinci El'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ürün Durumu',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: conditions.map((final c) {
            final isSelected =
                selected == c || (c == 'Hepsi' && selected == null);
            return ChoiceChip(
              label: Text(c),
              selected: isSelected,
              onSelected: (final _) => notifier.setCondition(c),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              ),
              backgroundColor: AppColors.background,
              selectedColor: AppColors.primary.withOpacity(0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceSection(
      final SearchState filters, final SearchFiltersNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Fiyat Aralığı',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildPriceField('Min ₺', filters.minPrice, (final v) {
                notifier.setPriceRange(v, filters.maxPrice);
              }),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPriceField('Max ₺', filters.maxPrice, (final v) {
                notifier.setPriceRange(filters.minPrice, v);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceField(final String label, final double value,
      final ValueChanged<double> onChanged) {
    return TextField(
      controller: TextEditingController(
          text: value > 0 ? value.toStringAsFixed(0) : ''),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: TextInputType.number,
      onChanged: (final text) => onChanged(double.tryParse(text) ?? 0),
    );
  }

  Widget _buildActionButtons(
      final BuildContext context, final SearchFiltersNotifier notifier) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: notifier.reset,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Temizle'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Uygula'),
          ),
        ),
      ],
    );
  }
}

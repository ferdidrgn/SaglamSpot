import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_providers.dart';

class FilterSheet extends ConsumerWidget {
  final VoidCallback onApplyFilters;
  final VoidCallback onResetFilters;

  const FilterSheet({
    super.key,
    required this.onApplyFilters,
    required this.onResetFilters,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // Yeni Record tabanlı provider'ı izliyoruz
    final filters = ref.watch(searchFiltersProvider);
    final filtersNotifier = ref.read(searchFiltersProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),

          // Durum Filtresi
          _buildFilterDropdown(
            'Durum',
            filters.condition ?? 'Hepsi',
            const ['Hepsi', 'Sıfır', 'İkinci El'],
            (final value) {
              filtersNotifier.setCondition(value);
            },
          ),
          const SizedBox(height: 20),

          // Fiyat Aralığı Filtresi
          _buildPriceRangeFilter(filters, filtersNotifier),
          const SizedBox(height: 32),

          _buildActionButtons(context),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildHeader(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Filtrele',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  Widget _buildActionButtons(final BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              onResetFilters();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Temizle'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFEC4899),
              side: const BorderSide(color: Color(0xFFEC4899)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              onApplyFilters();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.check_rounded, size: 18),
            label: const Text('Uygula'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
    final String label,
    final String value,
    final List<String> items,
    final Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((final item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter(final dynamic filters, final dynamic notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fiyat Aralığı',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPriceField(
              hint: 'Min',
              initialValue: filters.minPrice,
              onChanged: (final val) =>
                  notifier.setPriceRange(val, filters.maxPrice),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            _buildPriceField(
              hint: 'Max',
              initialValue: filters.maxPrice,
              onChanged: (final val) =>
                  notifier.setPriceRange(filters.minPrice, val),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceField({
    required final String hint,
    required final double initialValue,
    required final Function(double) onChanged,
  }) {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: TextInputType.number,
        controller: TextEditingController(
          text: initialValue > 0 && initialValue < 100000
              ? initialValue.toStringAsFixed(0)
              : '',
        )..selection = TextSelection.fromPosition(
            TextPosition(offset: initialValue.toStringAsFixed(0).length),
          ),
        onChanged: (final val) =>
            onChanged(double.tryParse(val) ?? (hint == 'Min' ? 0 : 100000)),
      ),
    );
  }
}

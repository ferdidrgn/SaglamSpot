import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/search/search_filters_notifier.dart';
import '../../data/providers/search/search_providers.dart';
import '../../data/providers/search/search_state.dart';

/// Mobil cihazlar için filtreleme arayüzünü gösteren Modal Bottom Sheet.
/// Bu widget, `search_page.dart` üzerindeki `_DesktopFilters` ile aynı
/// provider'ları ve fonksiyonları kullanarak tutarlı bir deneyim sağlar.
class FilterSheet extends ConsumerWidget {
  /// search_page.dart'tan gelen ana filtre uygulama fonksiyonu
  final VoidCallback onApplyFilters;

  /// search_page.dart'tan gelen ana filtre sıfırlama fonksiyonu
  final VoidCallback onResetFilters;

  const FilterSheet({
    super.key,
    required this.onApplyFilters,
    required this.onResetFilters,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
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
          // Başlık
          Row(
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
          ),
          const SizedBox(height: 24),

          // Durum Filtresi
          // search_page.dart'taki _buildFilterDropdown'un kopyası
          _buildFilterDropdown(
            'Durum',
            filters.condition ?? 'Hepsi',
            const ['Hepsi', 'Sıfır', 'İkinci El'],
            (final value) {
              filtersNotifier.setCondition(value == 'Hepsi' ? null : value);
            },
          ),
          const SizedBox(height: 20),

          // Fiyat Aralığı Filtresi
          // search_page.dart'taki _buildPriceRangeFilter'ın kopyası
          _buildPriceRangeFilter(filters, filtersNotifier),
          const SizedBox(height: 32),

          // Butonlar
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    onResetFilters(); // Ana sayfadaki fonksiyonu çağır
                    Navigator.pop(context); // Sheet'i kapat
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Temizle'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEC4899),
                    side: const BorderSide(color: Color(0xFFEC4899)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    onApplyFilters(); // Ana sayfadaki fonksiyonu çağır
                    Navigator.pop(context); // Sheet'i kapat
                  },
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: const Text('Uygula'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
        ],
      ),
    );
  }

  // search_page.dart / _DesktopFilters'tan kopyalandı
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
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // search_page.dart / _DesktopFilters'tan kopyalandı
  Widget _buildPriceRangeFilter(
      final SearchState filters, final SearchFiltersNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fiyat Aralığı',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Min',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                // Başlangıç değerini ayarla
                controller: TextEditingController(
                  text: filters.minPrice > 0
                      ? filters.minPrice.toStringAsFixed(0)
                      : '',
                )..selection = TextSelection.fromPosition(
                    TextPosition(
                        offset: (filters.minPrice > 0
                                ? filters.minPrice.toStringAsFixed(0)
                                : '')
                            .length),
                  ),
                onChanged: (final value) {
                  notifier.setPriceRange(
                      double.tryParse(value) ?? 0, filters.maxPrice);
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Max',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
                // Başlangıç değerini ayarla
                controller: TextEditingController(
                  text: filters.maxPrice < 50000
                      ? filters.maxPrice.toStringAsFixed(0)
                      : '',
                )..selection = TextSelection.fromPosition(
                    TextPosition(
                        offset: (filters.maxPrice < 50000
                                ? filters.maxPrice.toStringAsFixed(0)
                                : '')
                            .length),
                  ),
                onChanged: (final value) {
                  notifier.setPriceRange(
                      filters.minPrice, double.tryParse(value) ?? 50000);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

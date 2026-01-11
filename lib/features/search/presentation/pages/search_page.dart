import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/util/responsive_utils.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../../../../core/widgets/filter_sheet.dart';
import '../../../../core/widgets/responsive_product_grid.dart';
import '../../../products/domain/entites/product.dart';
import '../providers/search_filters_notifier.dart';
import '../providers/search_notifier.dart';
import '../providers/search_state.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  final _categories = const [
    'Tümü',
    'Elektronik',
    'Mobilya',
    'Giyim',
    'Kitap',
    'Spor',
  ];

  void _resetAll() {
    _searchController.clear();
    ref.read(searchProvider.notifier).resetFilters();
    ref.read(searchFiltersProvider.notifier).reset();
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(searchProvider);
    final isMobile = context.isMobile;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildShowroomAppBar(context),

          /// 🔍 SEARCH + FILTER BAR
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchDelegate(
              child: _SearchAndFilterSection(
                isMobile: isMobile,
                searchController: _searchController,
                onSearchChanged:
                    ref.read(searchProvider.notifier).onQueryChanged,
                categories: _categories,
                selectedCategory: state.selectedCategory ?? 'Tümü',
                onCategorySelected:
                    ref.read(searchProvider.notifier).filterByCategory,
                onFiltersReset: _resetAll,
                onApplyFilters: () {
                  final f = ref.read(searchFiltersProvider);
                  ref.read(searchProvider.notifier).setCondition(f.condition);
                  ref
                      .read(searchProvider.notifier)
                      .setPriceRange(f.minPrice, f.maxPrice);
                },
              ),
            ),
          ),

          /// 🧩 ACTIVE FILTERS
          if (state.isFiltered)
            SliverToBoxAdapter(
              child: _ActiveFiltersSection(
                selectedCategory: state.selectedCategory ?? 'Tümü',
                categories: _categories,
                onCategoryFilterRemoved: () =>
                    ref.read(searchProvider.notifier).filterByCategory('Tümü'),
                onFilterRemoved: (final _) => _resetAll(),
              ),
            ),

          /// 📢 NATIVE AD
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: AdsenseBanner(height: 120),
            ),
          ),

          /// 🛍 PRODUCTS
          if (state.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.filteredProducts.isEmpty)
            const SliverFillRemaining(
              child: Center(child: Text('Sonuç bulunamadı')),
            )
          else
            ResponsiveProductSliverGrid(
              products: state.filteredProducts,
              onProductTap: (final p) => context.push('/product/${p.id}'),
            ),

          /// 📢 FOOTER AD
          const SliverToBoxAdapter(child: AdsenseBanner(height: 250)),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton.extended(
              onPressed: () => _showFilterSheet(context),
              icon: const Icon(Icons.tune),
              label: const Text('Filtrele'),
            )
          : null,
    );
  }

  void _showFilterSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (final _) => FilterSheet(
        onApplyFilters: () {
          final f = ref.read(searchFiltersProvider);
          ref.read(searchProvider.notifier).setCondition(f.condition);
          ref
              .read(searchProvider.notifier)
              .setPriceRange(f.minPrice, f.maxPrice);
        },
        onResetFilters: _resetAll,
      ),
    );
  }
}

// --- SUB-WIDGETS & DELEGATES ---

class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickySearchDelegate({required this.child});

  @override
  Widget build(final context, final shrinkOffset, final overlapsContent) =>
      Container(color: Colors.white, child: child);

  @override
  double get maxExtent => 160;

  @override
  double get minExtent => 160;

  @override
  bool shouldRebuild(
          covariant final SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _CreativeAppBar extends StatelessWidget {
  const _CreativeAppBar();

  @override
  Widget build(final BuildContext context) {
    return SliverAppBar(
      expandedHeight: context.responsive(mobile: 180.0, desktop: 230.0),
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0F172A),
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
        title: Text(
          'Aradığını Keşfet',
          style: TextStyle(
            fontSize: context.responsive(mobile: 16, desktop: 18),
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1519710164239-da123dc03ef4',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.85),
                    Colors.black.withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================================
// --- DİĞER WIDGET'LAR (DEĞİŞİKLİK YOK) ---
// ===================================================================

// --- 2. ARAMA VE FİLTRE BÖLÜMÜ ---
class _SearchAndFilterSection extends StatelessWidget {
  final bool isMobile;
  final TextEditingController searchController;
  final void Function(String) onSearchChanged;
  final List<String> categories;
  final String selectedCategory;
  final void Function(String) onCategorySelected;
  final VoidCallback onFiltersReset;
  final VoidCallback onApplyFilters;

  const _SearchAndFilterSection({
    required this.isMobile,
    required this.searchController,
    required this.onSearchChanged,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onFiltersReset,
    required this.onApplyFilters,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      // context.responsive kullanımı
      margin: EdgeInsets.all(context.responsive(mobile: 16.0, desktop: 24.0)),
      child: Column(
        children: [
          _SearchBar(
            // Ayıklanmış alt widget
            controller: searchController,
            onChanged: onSearchChanged,
            isMobile: isMobile,
          ),
          const SizedBox(height: 16),
          _CategoryChips(
            // Ayıklanmış alt widget
            categories: categories,
            selectedCategory: selectedCategory,
            onSelected: onCategorySelected,
          ),
          if (!isMobile) ...[
            const SizedBox(height: 16),
            _DesktopFilters(
              // Ayıklanmış alt widget
              onFiltersReset: onFiltersReset,
              onApplyFilters: onApplyFilters,
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  final bool isMobile;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.isMobile,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: isMobile ? 54 : 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Ürün, kategori veya marka ara…',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Icon(
              Icons.search_rounded,
              size: 24,
              color: Colors.grey.shade600,
            ),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}

// --- 2b. KATEGORİ ÇİPLERİ ---
class _CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final void Function(String) onSelected;

  const _CategoryChips({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (final _, final __) => const SizedBox(width: 8),
        itemBuilder: (final context, final index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => onSelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B87EA)],
                      )
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.black.withOpacity(0.06),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- 2c. DESKTOP FİLTRELERİ (ConsumerWidget) ---
class _DesktopFilters extends ConsumerWidget {
  final VoidCallback onFiltersReset;
  final VoidCallback onApplyFilters;

  const _DesktopFilters({
    required this.onFiltersReset,
    required this.onApplyFilters,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // _buildDesktopFilters'ın içeriği
    final filters = ref.watch(searchFiltersProvider);
    final filtersNotifier = ref.read(searchFiltersProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterDropdown(
              // İç metot
              'Durum',
              filters.condition ?? 'Hepsi',
              const ['Hepsi', 'Sıfır', 'İkinci El'],
              (final value) {
                filtersNotifier.setCondition(value == 'Hepsi' ? null : value);
                onApplyFilters(); // Ana sayfaya haber ver
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildPriceRangeFilter(filters, filtersNotifier), // İç metot
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: onFiltersReset, // Ana sayfadan gelen fonksiyon
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Temizle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEC4899),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // _buildFilterDropdown metodunu _DesktopFilters'ın içine taşıdık
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

  // _buildPriceRangeFilter metodunu _DesktopFilters'ın içine taşıdık
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

// --- 3. AKTİF FİLTRELER BÖLÜMÜ (ConsumerWidget) ---
class _ActiveFiltersSection extends ConsumerWidget {
  final String selectedCategory;
  final List<String> categories;
  final VoidCallback onCategoryFilterRemoved;
  final Function(String) onFilterRemoved;

  const _ActiveFiltersSection({
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryFilterRemoved,
    required this.onFilterRemoved,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    // _buildActiveFiltersSection'ın içeriği
    final searchState = ref.watch(searchProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Aktif Filtreler:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              fontSize: 13,
            ),
          ),
          if (searchState.condition != null)
            _buildFilterChip(context, searchState.condition!), // İç metot
          if (searchState.minPrice > 0)
            _buildFilterChip(context,
                'Min: ₺${searchState.minPrice.toStringAsFixed(0)}'), // İç metot
          if (searchState.maxPrice < 50000)
            _buildFilterChip(context,
                'Max: ₺${searchState.maxPrice.toStringAsFixed(0)}'), // İç metot
          if (selectedCategory != 'Tümü')
            _buildFilterChip(context, selectedCategory), // İç metot
        ],
      ),
    );
  }

  // _buildFilterChip metodunu _ActiveFiltersSection'ın içine taşıdık
  Widget _buildFilterChip(final BuildContext context, final String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B87EA)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () {
              // Ana sayfaya (controller'a) haber ver
              if (categories.contains(label))
                onCategoryFilterRemoved();
              else
                onFilterRemoved(label);
            },
            child: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// --- 5. YÜZEN FİLTRE BUTONU (FAB) ---
class _FilterFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const _FilterFAB({required this.onPressed});

  @override
  Widget build(final BuildContext context) {
    // _buildFloatingFilterButton'ın içeriği
    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF6366F1),
      elevation: 4,
      icon: const Icon(Icons.tune_rounded, color: Colors.white),
      label: const Text(
        'Filtrele',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

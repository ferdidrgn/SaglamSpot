import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saglamspot/core/theme/app_colors.dart';

import '../../../../core/util/responsive_utils.dart';
import '../../../../core/widgets/ad_sense_banner.dart';
import '../widgets/filter_sheet.dart';
import '../../../../core/widgets/responsive_product_grid.dart';
import '../../../../core/widgets/shimmer_components.dart'; // Senin shimmer kitin
import '../../../products/domain/entites/product.dart';
import '../providers/search_providers.dart'; // Yeni yazdığımız merkezi providerlar

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

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _resetAll() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).update('');
    ref.read(searchFiltersProvider.notifier).reset();
  }

  @override
  Widget build(final BuildContext context) {
    // 1. REAKTİF VERİLERİ İZLE
    final searchResultsAsync = ref.watch(searchedProductsProvider);
    final currentFilters = ref.watch(searchFiltersProvider);
    final isMobile = context.isMobile;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // --- SHOWROOM APPBAR ---
          const _ShowroomAppBar(),

          // --- STICKY SEARCH & FILTER ---
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickySearchDelegate(
              child: _SearchAndFilterSection(
                isMobile: isMobile,
                searchController: _searchController,
                onSearchChanged: (val) =>
                    ref.read(searchQueryProvider.notifier).update(val),
                categories: _categories,
                selectedCategory: currentFilters.category ?? 'Tümü',
                onCategorySelected: (cat) =>
                    ref.read(searchFiltersProvider.notifier).setCategory(cat),
                onFiltersReset: _resetAll,
                onApplyFilters: () {}, // Reactive yapıda otomatik tetiklenir
              ),
            ),
          ),

          // --- ACTIVE FILTERS WRAP ---
          _buildActiveFiltersSliver(currentFilters),

          // --- PRODUCT SHOWCASE (ASYNCVALUE.WHEN) ---
          searchResultsAsync.when(
            loading: () => const SliverFillRemaining(child: FullPageShimmer()),
            error: (err, _) => SliverFillRemaining(
              child: Center(child: Text('Hata oluştu: $err')),
            ),
            data: (products) {
              if (products.isEmpty) return _buildEmptyState();
              return SliverPadding(
                padding: const EdgeInsets.only(bottom: 50),
                sliver: SliverMainAxisGroup(
                  slivers: _buildProductGrids(context, products),
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: AdsenseBanner(height: 250)),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton.extended(
              onPressed: () => _showFilterSheet(context),
              backgroundColor: const Color(0xFF0F172A),
              icon: const Icon(Icons.tune, color: Colors.white),
              label:
                  const Text('Filtrele', style: TextStyle(color: Colors.white)),
            )
          : null,
    );
  }

  Widget _buildActiveFiltersSliver(final dynamic filters) {
    final bool hasFilters = filters.category != null ||
        filters.condition != null ||
        filters.minPrice > 0 ||
        filters.maxPrice < 100000;

    if (!hasFilters) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: _ActiveFiltersSection(
        filters: filters,
        onReset: _resetAll,
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('Aradığınız kriterde ürün bulunamadı',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            TextButton(
                onPressed: _resetAll, child: const Text('Filtreleri Temizle')),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProductGrids(
      final BuildContext context, final List<Product> products) {
    final available = products.where((final p) => !p.isSold).toList();
    final sold = products.where((final p) => p.isSold).toList();

    return [
      if (available.isNotEmpty) ...[
        _buildSectionHeader(
            'MEVCUT KOLEKSİYON', available.length, const Color(0xFF10B981)),
        ResponsiveProductSliverGrid(
          products: available,
          onProductTap: (final p) => context.push('/product/${p.id}'),
        ),
      ],
      if (sold.isNotEmpty) ...[
        _buildSectionHeader(
            'GEÇMİŞ SEÇKİLER (SATILDI)', sold.length, const Color(0xFF64748B)),
        ResponsiveProductSliverGrid(
          products: sold,
          onProductTap: (final p) => context.push('/product/${p.id}'),
        ),
      ],
    ];
  }

  Widget _buildSectionHeader(
      final String title, final int count, final Color accentColor) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
        child: Row(
          children: [
            Container(width: 4, height: 24, color: accentColor),
            const SizedBox(width: 12),
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2)),
            const Spacer(),
            Text('$count Parça',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final _) => FilterSheet(
        // FilterSheet artık doğrudan searchFiltersProvider'ı manipüle edecek
        onApplyFilters: () => Navigator.pop(context),
        onResetFilters: _resetAll,
      ),
    );
  }
}

// --- SUB-WIDGETS ---

class _StickySearchDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickySearchDelegate({required this.child});

  @override
  Widget build(final context, final shrinkOffset, final overlapsContent) =>
      Material(elevation: shrinkOffset > 0 ? 4 : 0, child: child);

  @override
  double get maxExtent => 180;

  @override
  double get minExtent => 180;

  @override
  bool shouldRebuild(covariant final _StickySearchDelegate oldDelegate) => true;
}

class _ShowroomAppBar extends StatelessWidget {
  const _ShowroomAppBar();

  @override
  Widget build(final BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      stretch: true,
      backgroundColor: const Color(0xFF0F172A),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
        titlePadding: const EdgeInsets.only(left: 24, bottom: 20),
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SHOWROOM',
                style: TextStyle(
                    fontSize: 10, letterSpacing: 4, color: Colors.white70)),
            Text('Koleksiyonu Keşfet',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white)),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6',
              fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Color(0xFF0F172A), Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      color: Colors.white,
      padding: EdgeInsets.all(context.responsive(mobile: 16.0, desktop: 24.0)),
      child: Column(
        children: [
          _SearchBar(
            controller: searchController,
            onChanged: onSearchChanged,
            isMobile: isMobile,
          ),
          const SizedBox(height: 16),
          _CategoryChips(
            categories: categories,
            selectedCategory: selectedCategory,
            onSelected: onCategorySelected,
          ),
          if (!isMobile) ...[
            const SizedBox(height: 16),
            _DesktopFilters(
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
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Ürün, kategori veya marka ara…',
          prefixIcon:
              const Icon(Icons.search_rounded, color: AppColors.surface),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded),
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
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => onSelected(category),
            selectedColor: const Color(0xFF6366F1),
            labelStyle:
                TextStyle(color: isSelected ? Colors.white : Colors.black87),
          );
        },
      ),
    );
  }
}

class _DesktopFilters extends ConsumerWidget {
  final VoidCallback onFiltersReset;
  final VoidCallback onApplyFilters;

  const _DesktopFilters(
      {required this.onFiltersReset, required this.onApplyFilters});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);
    final notifier = ref.read(searchFiltersProvider.notifier);

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: filters.condition ?? 'Hepsi',
            items: ['Hepsi', 'Sıfır', 'İkinci El']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => notifier.setCondition(val),
            decoration: const InputDecoration(
                labelText: 'Durum', border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(onPressed: onFiltersReset, child: const Text('Temizle')),
      ],
    );
  }
}

class _ActiveFiltersSection extends StatelessWidget {
  final dynamic filters;
  final VoidCallback onReset;

  const _ActiveFiltersSection({required this.filters, required this.onReset});

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Wrap(
        spacing: 8,
        children: [
          if (filters.category != null) Chip(label: Text(filters.category!)),
          if (filters.condition != null) Chip(label: Text(filters.condition!)),
          ActionChip(label: const Text('Tümünü Temizle'), onPressed: onReset),
        ],
      ),
    );
  }
}

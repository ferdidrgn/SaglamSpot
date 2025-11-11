import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/custom_search_product_card.dart';
import '../../core/widgets/filter_sheet.dart';
import '../../data/providers/search/search_filters_notifier.dart';
import '../../data/providers/search/search_providers.dart';
import '../../data/providers/search/search_state.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _showFilters = false;
  String _selectedCategory = 'Tümü';
  final List<String> _categories = [
    'Tümü',
    'Elektronik',
    'Mobilya',
    'Giyim',
    'Kitap',
    'Spor'
  ];

  // Build metodunda ilk yükleme kontrolü yapacağız
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    // Alternatif -- Microtask ile build tamamlandıktan sonra çalıştır
    //Future.microtask(() {ref.read(searchProvider.notifier).loadProducts();});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _loadInitialProducts() =>
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        ref.read(searchProvider.notifier).loadProducts();
      });

  void _filterByCategory(final String category) {
    if (category == 'Tümü')
      ref.read(searchProvider.notifier).resetFilters();
    else
      ref.read(searchProvider.notifier).filterByCategory(category);

    setState(() {
      _showFilters = category != 'Tümü';
    });
  }

  void _applyFiltersFromDialog() {
    final filters = ref.read(searchFiltersProvider);
    ref.read(searchProvider.notifier).setCondition(filters.condition);
    ref
        .read(searchProvider.notifier)
        .setPriceRange(filters.minPrice, filters.maxPrice);
  }

  void _resetFilters() {
    ref.read(searchProvider.notifier).resetFilters();
    ref.read(searchFiltersProvider.notifier).reset();
    setState(() {
      _selectedCategory = 'Tümü';
      _showFilters = false;
      _searchController.clear();
    });
  }

  void _onSearchChanged(final String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchProvider.notifier).onQueryChanged(query);
    });
  }

  @override
  Widget build(final BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1024;

    // İlk build'de ürünleri yükle
    if (_isInitialLoad && !searchState.isLoading) {
      _isInitialLoad = false;
      _loadInitialProducts();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildModernAppBar(context, isMobile),
          SliverToBoxAdapter(
            child: _buildSearchAndFilters(context, isMobile),
          ),
          if (_showFilters)
            SliverToBoxAdapter(
              child:
                  _buildActiveFiltersSection(context), // Parametre kaldırıldı
            ),
          _buildProductGrid(context, searchState, isMobile, isTablet),
        ],
      ),
      floatingActionButton:
          isMobile ? _buildFloatingFilterButton(context) : null,
    );
  }

  Widget _buildModernAppBar(final BuildContext context, final bool isMobile) {
    return SliverAppBar(
      expandedHeight: isMobile ? 140 : 180,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6366F1), Color(0xFF8B87EA), Color(0xFFEC4899)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Premium Koleksiyon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 28 : 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Özel tasarım ürünler keşfedin',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w400,
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

  Widget _buildSearchAndFilters(
      final BuildContext context, final bool isMobile) {
    return Container(
      margin: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          _buildSearchBar(context, isMobile),
          const SizedBox(height: 16),
          _buildCategoryChips(context, isMobile),
          if (!isMobile) ...[
            const SizedBox(height: 16),
            _buildDesktopFilters(context),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar(final BuildContext context, final bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Lüks ürünler ara...',
          hintStyle: TextStyle(
            color: const Color(0xFF64748B).withOpacity(0.6),
            fontSize: isMobile ? 14 : 16,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF6366F1),
            size: 24,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 20,
            vertical: isMobile ? 16 : 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(final BuildContext context, final bool isMobile) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (final context, final index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                  _filterByCategory(category);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B87EA)],
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : const Color(0xFF64748B),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopFilters(final BuildContext context) {
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
              'Durum',
              filters.condition ?? 'Hepsi',
              const ['Hepsi', 'Sıfır', 'İkinci El'],
              (final value) {
                filtersNotifier.setCondition(value);
                setState(() {
                  _showFilters = true;
                });
                _applyFiltersFromDialog();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildPriceRangeFilter(filters, filtersNotifier),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _resetFilters,
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

  Widget _buildActiveFiltersSection(final BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
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
            _buildFilterChip(searchState.condition!),
          if (searchState.minPrice > 0)
            _buildFilterChip(
                'Min: ₺${searchState.minPrice.toStringAsFixed(0)}'),
          if (searchState.maxPrice < 50000)
            _buildFilterChip(
                'Max: ₺${searchState.maxPrice.toStringAsFixed(0)}'),
          if (_selectedCategory != 'Tümü') _buildFilterChip(_selectedCategory),
        ],
      ),
    );
  }

  Widget _buildFilterChip(final String label) {
    // ref.read yerine ref.watch kullanıyoruz ve Consumer ile sarmalıyoruz
    return Consumer(
      builder: (context, ref, child) {
        final searchState = ref.watch(searchProvider);

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
                  if (label == searchState.condition) {
                    ref.read(searchProvider.notifier).setCondition(null);
                  } else if (label.startsWith('Min:')) {
                    ref
                        .read(searchProvider.notifier)
                        .setPriceRange(0, searchState.maxPrice);
                  } else if (label.startsWith('Max:')) {
                    ref
                        .read(searchProvider.notifier)
                        .setPriceRange(searchState.minPrice, 50000);
                  } else if (_categories.contains(label)) {
                    setState(() {
                      _selectedCategory = 'Tümü';
                    });
                    _filterByCategory('Tümü');
                  }
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
      },
    );
  }

  Widget _buildProductGrid(final BuildContext context,
      final SearchState searchState, final bool isMobile, final bool isTablet) {
    if (searchState.isLoading) {
      return SliverFillRemaining(
        child: _buildLoadingState(),
      );
    }

    if (searchState.errorMessage != null) {
      return SliverFillRemaining(
        child: _buildErrorState(searchState.errorMessage!),
      );
    }

    final products = searchState.filteredProducts.isNotEmpty
        ? searchState.filteredProducts
        : searchState.products;

    if (products.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(),
      );
    }

    final availableProducts = products.where((final p) => !p.isSold).toList();
    final soldProducts = products.where((final p) => p.isSold).toList();

    int crossAxisCount;
    if (isMobile) {
      crossAxisCount = 2;
    } else if (isTablet) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
    }

    return SliverPadding(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          if (availableProducts.isNotEmpty) ...[
            _buildSectionHeader('Mevcut Ürünler', availableProducts.length,
                const Color(0xFF10B981)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.75,
                crossAxisSpacing: isMobile ? 12 : 20,
                mainAxisSpacing: isMobile ? 12 : 20,
              ),
              itemCount: availableProducts.length,
              itemBuilder: (final context, final index) => ModernProductCard(
                product: availableProducts[index],
                isMobile: isMobile,
              ),
            ),
          ],
          if (soldProducts.isNotEmpty) ...[
            const SizedBox(height: 40),
            _buildSectionHeader('Satılmış Ürünler', soldProducts.length,
                const Color(0xFF64748B)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.75,
                crossAxisSpacing: isMobile ? 12 : 20,
                mainAxisSpacing: isMobile ? 12 : 20,
              ),
              itemCount: soldProducts.length,
              itemBuilder: (final context, final index) => ModernProductCard(
                product: soldProducts[index],
                isMobile: isMobile,
              ),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _buildSectionHeader(
      final String title, final int count, final Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B87EA)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Premium Ürünler Yükleniyor...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lüks koleksiyonunuz hazırlanıyor',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF64748B).withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 64,
                color: const Color(0xFF6366F1).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sonuç Bulunamadı',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Arama kriterlerinizi değiştirerek\ntekrar deneyebilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: const Color(0xFF64748B).withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _resetFilters,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tüm Ürünleri Göster'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(final String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bir Hata Oluştu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(searchProvider.notifier).loadProducts();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Tekrar Dene'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingFilterButton(final BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _showFilterDialog,
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

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final context) => const FilterSheet(),
    );
  }
}

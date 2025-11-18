import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/util/responsive_utils.dart'; // Extension'lar için import
import '../../core/widgets/filter_sheet.dart';
import '../../core/widgets/responsive_product_grid.dart';
import '../../data/providers/search/search_filters_notifier.dart';
import '../../data/providers/search/search_providers.dart';
import '../../data/providers/search/search_state.dart';
import '../../domain/entities/product.dart'; // Product eklendi

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  // --- STATE & CONTROLLERS ---
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
  bool _isInitialLoad = true;

  // --- LIFECYCLE ---
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

  // --- LOGIC METHODS (CONTROLLER) ---
  void _loadInitialProducts() =>
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        if (mounted) ref.read(searchProvider.notifier).loadProducts();
      });

  void _filterByCategory(final String category) {
    if (category == 'Tümü') {
      // Artık sadece provider'ı değil, arama çubuğu dahil her şeyi sıfırlar.
      _resetFilters();
    } else {
      ref.read(searchProvider.notifier).filterByCategory(category);
      setState(() {
        _selectedCategory = category;
        _showFilters = category != 'Tümü' ||
            ref.read(searchProvider).condition != null ||
            ref.read(searchProvider).minPrice > 0 ||
            ref.read(searchProvider).maxPrice < 50000;
      });
    }
  }

  void _applyFiltersFromDialog() {
    final filters = ref.read(searchFiltersProvider);
    ref.read(searchProvider.notifier).setCondition(filters.condition);
    ref
        .read(searchProvider.notifier)
        .setPriceRange(filters.minPrice, filters.maxPrice);

    // Filtrelerin uygulanıp uygulanmadığını kontrol et
    setState(() {
      _showFilters = _selectedCategory != 'Tümü' ||
          filters.condition != null ||
          filters.minPrice > 0 ||
          filters.maxPrice < 50000;
    });
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
      if (mounted) ref.read(searchProvider.notifier).onQueryChanged(query);
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final context) => FilterSheet(
        onApplyFilters: _applyFiltersFromDialog,
        onResetFilters: _resetFilters,
      ),
    );
  }

  // --- MAIN BUILD METHOD ---
  @override
  Widget build(final BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final isMobile = context.isMobile; // Extension kullanımı

    // İlk build'de ürünleri yükle
    if (_isInitialLoad && !searchState.isLoading) {
      _isInitialLoad = false;
      _loadInitialProducts();
    }

    // Yüklenecek ürün listesini belirle
    final products = searchState.filteredProducts.isNotEmpty
        ? searchState.filteredProducts
        : searchState.products;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // --- DÜZELTME: YARATICI VE ANİMASYONLU APPBAR ---
          const _CreativeAppBar(),
          // --- DÜZELTME SONU ---

          // 2. Arama ve Filtreler
          SliverToBoxAdapter(
            child: _SearchAndFilterSection(
              isMobile: isMobile,
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: _filterByCategory,
              onFiltersReset: _resetFilters,
              onApplyFilters: _applyFiltersFromDialog,
            ),
          ),

          // 3. Aktif Filtreler
          if (_showFilters)
            SliverToBoxAdapter(
              child: _ActiveFiltersSection(
                selectedCategory: _selectedCategory,
                categories: _categories,
                onCategoryFilterRemoved: () => _filterByCategory('Tümü'),
                onFilterRemoved: (final String label) {
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
                  }
                },
              ),
            ),

          // --- 4. ÜRÜN GRID ---
          if (searchState.isLoading)
            _buildLoadingSliver(context)
          else if (searchState.errorMessage != null)
            _buildErrorSliver(context, searchState.errorMessage!)
          else if (products.isEmpty)
            _buildEmptyStateSliver(context, _resetFilters)
          else
            ..._buildProductGrids(context, products),
        ],
      ),

      // 5. FAB
      floatingActionButton:
          isMobile ? _FilterFAB(onPressed: _showFilterDialog) : null,
    );
  }

  // --- YARDIMCI METOTLAR (YÜKLEME, HATA, BOŞ DURUM) ---

  Widget _buildLoadingSliver(final BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Container(
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
      ),
    );
  }

  Widget _buildErrorSliver(final BuildContext context, final String message) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
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
                onPressed: _loadInitialProducts,
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
      ),
    );
  }

  Widget _buildEmptyStateSliver(
      final BuildContext context, final VoidCallback onResetFilters) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
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
                onPressed: onResetFilters,
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
      ),
    );
  }

  // --- _buildProductGrids Metodu ---
  List<Widget> _buildProductGrids(
      final BuildContext context, final List<Product> products) {
    final availableProducts = products.where((final p) => !p.isSold).toList();
    final soldProducts = products.where((final p) => p.isSold).toList();

    final screenPadding = context.responsive(
        mobile: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        desktop: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0));

    List<Widget> slivers = [];

    // Mevcut Ürünler Grid'i
    if (availableProducts.isNotEmpty) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: screenPadding.copyWith(bottom: 0, top: 0),
            child: _buildSectionHeader('Mevcut Ürünler',
                availableProducts.length, const Color(0xFF10B981)),
          ),
        ),
      );
      // -----------------------------------------------------------------
      //  DEĞİŞİKLİK BURADA: Karmaşık SliverGrid yerine artık
      //  ResponsiveProductSliverGrid widget'ını kullanıyoruz.
      // -----------------------------------------------------------------
      slivers.add(
        ResponsiveProductSliverGrid(
          products: availableProducts,
          onProductTap: (final product) {
            // Ürüne tıklama olayı
            // print('${product.name} tıklandı!');
            // Navigator.push(...);
          },
        ),
      );
    }

    // Satılmış Ürünler Grid'i
    if (soldProducts.isNotEmpty) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: screenPadding.copyWith(bottom: 0, top: 25.0),
            child: _buildSectionHeader('Satılmış Ürünler', soldProducts.length,
                const Color(0xFF64748B)),
          ),
        ),
      );
      slivers.add(
        ResponsiveProductSliverGrid(
          products: soldProducts,
          onProductTap: (final product) {
            // print('${product.name} tıklandı!');
          },
        ),
      );
    }

    // Alttaki boşluk
    slivers
        .add(SliverToBoxAdapter(child: SizedBox(height: screenPadding.bottom)));

    return slivers;
  }

  // --- İç Helper Metot (_buildProductGrids'e ait) ---
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
} // _SearchPageState sonu

// ===================================================================
// --- YENİ EKLENEN WIDGET ---
// ===================================================================

class _CreativeAppBar extends StatelessWidget {
  const _CreativeAppBar();

  @override
  Widget build(final BuildContext context) {
    return SliverAppBar(
      expandedHeight: context.responsive(mobile: 200.0, desktop: 250.0),
      floating: false,
      pinned: true,
      // Geri okunun beyaz olmasını sağlar
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: const Color(0xFF334155),
      // Resim yüklenemezse fallback

      flexibleSpace: FlexibleSpaceBar(
        // Başlık (kaydırınca küçülen)
        title: Text(
          'İlham Veren Parçalar',
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsive(mobile: 16.0, desktop: 18.0),
            fontWeight: FontWeight.bold,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
        centerTitle: false,

        // Arka plan (Resim + Gradient)
        background: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Arka Plan Resmi
            Image.network(
              // "Ahşap" ve "Sanatsal" temasına uygun bir resim
              'https://images.unsplash.com/photo-1511401332200-038b5093b79f?q=80&w=1974&auto=format&fit=crop',
              fit: BoxFit.cover,
              // Yüklenirken animasyon
              loadingBuilder: (final context, final child, final progress) {
                if (progress == null) return child;
                return Container(color: const Color(0xFF334155));
              },
              // Hata durumunda
              errorBuilder: (final context, final error, final stackTrace) {
                return Container(
                  color: const Color(0xFF334155),
                  child: const Icon(Icons.palette_outlined,
                      color: Colors.white54, size: 50),
                );
              },
            ),

            // 2. Gradient (Metnin okunabilirliği için)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.1),
                  ],
                  stops: const [0.0, 0.7], // Alttan %70'e kadar
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

// --- 2a. ARAMA ÇUBUĞU ---
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
    // _buildSearchBar'ın içeriği
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
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Lüks ürünler ara...',
          hintStyle: TextStyle(
            color: const Color(0xFF64748B).withOpacity(0.6),
            // context.responsive kullanımı
            fontSize: context.responsive(mobile: 14.0, desktop: 16.0),
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF6366F1),
            size: 24,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 20),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            // context.responsive kullanımı
            horizontal: context.responsive(mobile: 16.0, desktop: 20.0),
            vertical: context.responsive(mobile: 16.0, desktop: 20.0),
          ),
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
    // _buildCategoryChips'in içeriği
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (final context, final index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelected(category),
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

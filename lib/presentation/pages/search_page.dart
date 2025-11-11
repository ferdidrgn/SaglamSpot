import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/util/responsive_utils.dart';
import '../../core/widgets/responsive_product_grid.dart';
import '../../data/providers/search/search_providers.dart';

/// Modern search page with filters
/// Responsive design ve clean architecture
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // İlk yükleme
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      ref.read(searchProvider.notifier).loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final notifier = ref.read(searchProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(context, notifier),
      body: Column(
        children: [
          _buildSearchBar(context, notifier),
          _buildFilterChips(context, notifier),
          _buildResultsHeader(context, searchState, notifier),
          Expanded(
            child: _buildProductGrid(context, searchState),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    final BuildContext context,
    final dynamic notifier,
  ) {
    final hasFilters = notifier.hasActiveFilters;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Ürünler',
        style: TextStyle(
          fontSize: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 20.0,
            desktop: 24.0,
          ),
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E293B),
        ),
      ),
      actions: [
        if (hasFilters)
          TextButton.icon(
            onPressed: () => notifier.resetFilters(),
            icon: const Icon(Icons.clear_all, size: 20),
            label: const Text('Temizle'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6366F1),
            ),
          ),
        IconButton(
          icon: const Icon(Icons.tune_rounded),
          onPressed: () => _showFilterBottomSheet(context),
          color: const Color(0xFF6366F1),
        ),
        SizedBox(
            width: ResponsiveUtils.getValueForDevice(
          context,
          mobile: 8.0,
          desktop: 16.0,
        )),
      ],
    );
  }

  Widget _buildSearchBar(final BuildContext context, final dynamic notifier) {
    return Container(
      margin: ResponsiveUtils.getScreenPadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.getBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: notifier.onQueryChanged,
        decoration: InputDecoration(
          hintText: 'Ürün ara...',
          hintStyle: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: ResponsiveUtils.getBodyFontSize(context) + 2,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: const Color(0xFF6366F1),
            size: ResponsiveUtils.getIconSize(context) + 4,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    size: ResponsiveUtils.getIconSize(context),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    notifier.onQueryChanged('');
                  },
                  color: const Color(0xFF94A3B8),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getValueForDevice(
              context,
              mobile: 16.0,
              desktop: 20.0,
            ),
            vertical: ResponsiveUtils.getValueForDevice(
              context,
              mobile: 12.0,
              desktop: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(final BuildContext context, final dynamic notifier) {
    final searchState = ref.watch(searchProvider);

    return Container(
      height: ResponsiveUtils.getValueForDevice(
        context,
        mobile: 50.0,
        desktop: 60.0,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getValueForDevice(
          context,
          mobile: 12.0,
          desktop: 32.0,
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            context,
            label: 'Tümü',
            isSelected: searchState.selectedCategory == null,
            onTap: () => notifier.filterByCategory('Tümü'),
          ),
          _buildFilterChip(
            context,
            label: 'Sıfır',
            isSelected: searchState.condition == 'Sıfır',
            onTap: () => notifier.setCondition('Sıfır'),
          ),
          _buildFilterChip(
            context,
            label: 'İkinci El',
            isSelected: searchState.condition == 'İkinci El',
            onTap: () => notifier.setCondition('İkinci El'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    final BuildContext context, {
    required final String label,
    required final bool isSelected,
    required final VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        right: ResponsiveUtils.getValueForDevice(
          context,
          mobile: 8.0,
          desktop: 12.0,
        ),
      ),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (final _) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF6366F1).withOpacity(0.1),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF64748B),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: ResponsiveUtils.getBodyFontSize(context),
        ),
        side: BorderSide(
          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
        ),
      ),
    );
  }

  Widget _buildResultsHeader(
    final BuildContext context,
    final dynamic searchState,
    final dynamic notifier,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getValueForDevice(
          context,
          mobile: 16.0,
          desktop: 32.0,
        ),
        vertical: ResponsiveUtils.getValueForDevice(
          context,
          mobile: 8.0,
          desktop: 12.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            searchState.statusMessage,
            style: TextStyle(
              fontSize: ResponsiveUtils.getBodyFontSize(context),
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (notifier.hasActiveFilters)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getValueForDevice(
                  context,
                  mobile: 8.0,
                  desktop: 10.0,
                ),
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${notifier.getActiveFilterCount()} filtre',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getCaptionFontSize(context),
                  color: const Color(0xFF6366F1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(
      final BuildContext context, final dynamic searchState) {
    if (searchState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF6366F1),
        ),
      );
    }

    return ResponsiveProductGrid(
      products: searchState.filteredProducts,
      onProductTap: (final product) {
        // Navigate to product detail
        // Navigator.push(...)
      },
    );
  }

  void _showFilterBottomSheet(final BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (final context) => _FilterBottomSheet(),
    );
  }
}

/// Filter bottom sheet widget
class _FilterBottomSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    final searchState = ref.read(searchProvider);
    _priceRange = RangeValues(
      searchState.minPrice,
      searchState.maxPrice,
    );
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            ResponsiveUtils.getBorderRadius(context) * 1.5,
          ),
        ),
      ),
      padding: ResponsiveUtils.getScreenPadding(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(
              height: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 20.0,
            desktop: 24.0,
          )),
          _buildPriceFilter(context),
          SizedBox(
              height: ResponsiveUtils.getValueForDevice(
            context,
            mobile: 20.0,
            desktop: 24.0,
          )),
          _buildApplyButton(context),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildHeader(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filtreler',
          style: TextStyle(
            fontSize: ResponsiveUtils.getValueForDevice(
              context,
              mobile: 18.0,
              desktop: 20.0,
            ),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
          color: const Color(0xFF64748B),
        ),
      ],
    );
  }

  Widget _buildPriceFilter(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fiyat Aralığı',
          style: TextStyle(
            fontSize: ResponsiveUtils.getTitleFontSize(context),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        SizedBox(
            height: ResponsiveUtils.getValueForDevice(
          context,
          mobile: 12.0,
          desktop: 16.0,
        )),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 50000,
          divisions: 100,
          activeColor: const Color(0xFF6366F1),
          labels: RangeLabels(
            '₺${_priceRange.start.round()}',
            '₺${_priceRange.end.round()}',
          ),
          onChanged: (final values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₺${_priceRange.start.round()}',
              style: TextStyle(
                fontSize: ResponsiveUtils.getBodyFontSize(context),
                color: const Color(0xFF64748B),
              ),
            ),
            Text(
              '₺${_priceRange.end.round()}',
              style: TextStyle(
                fontSize: ResponsiveUtils.getBodyFontSize(context),
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildApplyButton(final BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: ResponsiveUtils.getButtonHeight(context),
      child: ElevatedButton(
        onPressed: () {
          ref.read(searchProvider.notifier).setPriceRange(
                _priceRange.start,
                _priceRange.end,
              );
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ResponsiveUtils.getBorderRadius(context),
            ),
          ),
        ),
        child: Text(
          'Uygula',
          style: TextStyle(
            fontSize: ResponsiveUtils.getTitleFontSize(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

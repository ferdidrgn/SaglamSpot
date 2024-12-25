import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../core/widgets/custom_search.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _selectedCondition;
  double _minPrice = 0;
  double _maxPrice = 50000;
  final List<String> _conditions = ['Hepsi', 'Sıfır', 'İkinci El'];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _showChips = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    _resetFilters();
    return true; // Geri dönüşü onayla
  }

  void _loadProducts() {
    context.read<ProductBloc>().add(const LoadProducts());
  }

  void _filterProducts() {
    context.read<ProductBloc>().add(FilterProducts(
          condition: _selectedCondition,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
        ));
  }

  void _resetFilters() {
    context.read<ProductBloc>().add(ResetFilters()); // Filtreleri sıfırla
    _searchController.clear(); // Arama çubuğunu temizle
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrele'),
        content: SingleChildScrollView(child: _buildFilterDialogContent()),
        actions: [
          _buildDialogActions(),
        ],
      ),
    );
  }

  Widget _buildDialogActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDialogButton('Uygula', () {
          Navigator.pop(context);
          _filterProducts();
          setState(() {
            _showChips = true; // Chip'leri göstermek için flag
          });
        }),
        _buildDialogButton('Temizle', () {
          _resetFilters();
          Navigator.pop(context);
        }),
      ],
    );
  }

  TextButton _buildDialogButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildFilterDialogContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildConditionDropdown(),
        const SizedBox(height: 20),
        _buildPriceTextField('Minimum Fiyat', (value) {
          _minPrice = double.tryParse(value) ?? 0;
        }),
        const SizedBox(height: 20),
        _buildPriceTextField('Maksimum Fiyat', (value) {
          _maxPrice = double.tryParse(value) ?? 50000;
        }),
      ],
    );
  }

  Widget _buildConditionDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCondition,
      hint: const Text('Ürün Durumu'),
      items: _conditions.map((condition) {
        return DropdownMenuItem(value: condition, child: Text(condition));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCondition = value == 'Hepsi' ? null : value;
        });
      },
    );
  }

  Widget _buildPriceTextField(String label, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        _loadProducts();
      } else {
        context.read<ProductBloc>().add(SearchProducts(query: query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 1200;
    final isMediumScreen = screenWidth > 800 && screenWidth <= 1200;

    return WillPopScope(
      onWillPop: _onWillPop, // Geri butonuna tıklandığında filtreleri sıfırla
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    _buildSearchSection(),
                    Expanded(
                      child: BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          if (state is ProductLoading)
                            return _buildLoadingState();
                          if (state is ProductLoaded)
                            return _buildLoadedState(
                                state.products, isWideScreen, isMediumScreen);
                          if (state is ProductError)
                            return _buildErrorState(state.message);
                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          CustomSearchBar(
            controller: _searchController,
            onSearchChanged: _onSearchChanged,
          ),
          if (_showChips)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _buildActiveFilters(),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ürün Kataloğu',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('İhtiyacınız olan tüm ürünler burada',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey[600])),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _showFilterDialog,
          icon: const Icon(Icons.filter_list),
          label: const Text('Filtrele'),
        ),
      ],
    );
  }

  Widget _buildLoadedState(
      List<Product> products, bool isWideScreen, bool isMediumScreen) {
    if (products.isEmpty) return _buildEmptyState();

    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
            maxWidth: isWideScreen
                ? 1500
                : isMediumScreen
                    ? 900
                    : 600),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategorySection(
                'Mevcut Ürünler',
                products.where((p) => !p.isSold).toList(),
                isWideScreen,
                isMediumScreen),
            const SizedBox(height: 32),
            _buildCategorySection(
                'Satılmış Ürünler',
                products.where((p) => p.isSold).toList(),
                isWideScreen,
                isMediumScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Product> products,
      bool isWideScreen, bool isMediumScreen) {
    if (products.isEmpty) return const SizedBox();

    final crossAxisCount = isWideScreen
        ? 4
        : isMediumScreen
            ? 3
            : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.9,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) =>
              ProductCard(product: products[index]),
        ),
      ],
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          Text('Aktif Filtreler:',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          if (_selectedCondition != null) _buildFilterChip(_selectedCondition!),
          if (_minPrice > 0)
            _buildFilterChip('Min: ₺${_minPrice.toStringAsFixed(2)}'),
          if (_maxPrice < 50000)
            _buildFilterChip('Max: ₺${_maxPrice.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Chip(
      label: Text(label,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      backgroundColor: Theme.of(context).colorScheme.primary,
      deleteIcon: Icon(Icons.close,
          size: 18, color: Theme.of(context).colorScheme.onPrimary),
      onDeleted: () {
        setState(() {
          if (label == _selectedCondition) {
            _selectedCondition = null;
          } else if (label.startsWith('Min:')) {
            _minPrice = 0;
          } else if (label.startsWith('Max:')) {
            _maxPrice = 50000;
          }
          // Chip'leri gizle
          _showChips =
              _selectedCondition != null || _minPrice > 0 || _maxPrice < 50000;
        });
        _filterProducts();
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text('Ürünler Yükleniyor',
              style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
          const SizedBox(height: 24),
          Text('Sonuç Bulunamadı',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text(
              'Arama kriterlerinizi değiştirerek tekrar deneyebilirsiniz.',
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _resetFilters();
              _searchController.clear();
              _loadProducts();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Tüm Ürünleri Göster'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              size: 64, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text('Bir hata oluştu',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

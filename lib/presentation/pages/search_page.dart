import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_product_card.dart';
import '../../core/widgets/custom_search.dart';
import '../../core/widgets/custom_title.dart';
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

  void _loadProducts() {
    context.read<ProductBloc>().add(const LoadProducts());
  }

  void _filterProducts() {
    context.read<ProductBloc>().add(
      FilterProducts(
        condition: _selectedCondition,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrele'),
        content: SingleChildScrollView(child: _buildFilterDialogContent()),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _filterProducts();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  'Uygula',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: _clearFilters,
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: const Text(
                  'Temizle',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
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

  void _clearFilters() {
    _debounce?.cancel();
    setState(() {
      _selectedCondition = null;
      _minPrice = 0;
      _maxPrice = 50000;
      _searchController.clear();
      _onSearchChanged('');
    });
    _loadProducts();
    Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arama'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomSearchBar(
                  controller: _searchController,
                  onSearchTap: () {},
                  onSearchChanged: _onSearchChanged,
                ),
                const SizedBox(height: 10),
                if (_selectedCondition != null || _minPrice > 0 || _maxPrice < 50000)
                  _buildActiveFilters(),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return _buildLoadingState();
                } else if (state is ProductLoaded) {
                  return _buildLoadedState(state.products);
                } else if (state is ProductError) {
                  return _buildErrorState(state.message);
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Wrap(
      spacing: 8,
      children: [
        if (_selectedCondition != null)
          _buildFilterChip(_selectedCondition!),
        if (_minPrice > 0)
          _buildFilterChip('Min: ₺${_minPrice.toStringAsFixed(2)}'),
        if (_maxPrice < 50000)
          _buildFilterChip('Max: ₺${_maxPrice.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: () {
        setState(() {
          if (label == _selectedCondition) {
            _selectedCondition = null;
          } else if (label.startsWith('Min:')) {
            _minPrice = 0;
          } else if (label.startsWith('Max:')) {
            _maxPrice = 50000;
          }
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
          const SizedBox(height: 20),
          Text(
            'Ürünler yükleniyor...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(List<Product> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Ürün bulunamadı.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Farklı arama kriterleri deneyebilirsiniz.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _buildProductsByCategory(products),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Bir hata oluştu',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadProducts,
            icon: const Icon(Icons.refresh),
            label: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsByCategory(List<Product> products) {
    final soldProducts = products.where((p) => p.isSold).toList();
    final availableProducts = products.where((p) => !p.isSold).toList();

    return Column(
      children: [
        if (availableProducts.isNotEmpty)
          _buildProductSection('Mevcut Ürünler', availableProducts),
        if (soldProducts.isNotEmpty)
          _buildProductSection('Satılmış Ürünler', soldProducts),
        if (products.isEmpty)
          const Center(
            child: Text('Ürün bulunamadı.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
          ),
      ],
    );
  }

  Widget _buildProductSection(String title, List<Product> products) {
    final ScrollController scrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSectionTitle(title: title),
        SizedBox(
          height: 400,
          child: Row(
            children: [
              _buildScrollButton(scrollController, -1),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 300,
                      padding: const EdgeInsets.only(right: 16),
                      child: ProductCard(product: products[index]),
                    );
                  },
                ),
              ),
              _buildScrollButton(scrollController, 1),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScrollButton(ScrollController controller, int direction) {
    return IconButton(
      icon: Icon(
        direction == -1 ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
      ),
      onPressed: () => _scrollList(controller, direction),
    );
  }

  void _scrollList(ScrollController controller, int direction) {
    const double scrollAmount = 300;
    final double offset = controller.offset + (direction * scrollAmount);
    controller.animateTo(
      offset.clamp(0.0, controller.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
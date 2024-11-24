import 'package:flutter/material.dart';
import 'package:saglamspot/core/custom_views/custom_search.dart';
import 'package:saglamspot/data/model/product.dart';
import 'package:saglamspot/data/repository/product_service.dart';
import '../../../core/custom_views/custom_product_card.dart'; // Ürün kartı bileşeni

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ProductService _productService = ProductService();
  List<Product> products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;

  // Filtre değişkenleri
  String? _selectedCondition;
  double _minPrice = 0;
  double _maxPrice = 10000; // Varsayılan maksimum fiyat
  List<String> conditions = ['Sıfır', 'İkinci El', 'Temizle'];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);

    try {
      final fetchedProducts = await _productService.fetchFilteredProducts();
      setState(() {
        products = fetchedProducts;
        _filteredProducts = fetchedProducts; // İlk başta tüm ürünleri göster
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Veriler getirilemedi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _filterProducts() async {
    setState(() => _isLoading = true); // Yükleme göstergesini aç

    try {
      final filteredProducts = _selectedCondition == 'Temizle'
          ? products
          : await _productService.fetchFilteredProducts(
        condition: _selectedCondition,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
      );

      setState(() {
        _filteredProducts = filteredProducts; // Filtrelenmiş ürünleri güncelle
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Filtreleme sırasında hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false); // Yükleme göstergesini kapat
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrele'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  hint: const Text('Ürün Durumu'),
                  items: conditions.map((condition) {
                    return DropdownMenuItem(
                      value: condition,
                      child: Text(condition),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCondition = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(labelText: 'Minimum Fiyat'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _minPrice = double.tryParse(value) ?? 0;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Maksimum Fiyat'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _maxPrice = double.tryParse(value) ?? 10000;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Dialog kapat
                await _filterProducts(); // Ürünleri filtrele
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue, // Buton arka plan rengi
              ),
              child: Text('Uygula',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
            ),
          ],
        );
      },
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredProducts = products
          .where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arama', style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchBar(onSearchChanged: _onSearchChanged),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: _buildProductScrollableSection(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductScrollableSection() {
    final ScrollController scrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ürünler',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: Row(
            children: [
              // Sol Ok
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  _scrollList(scrollController, -1);
                },
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(right: 16, bottom: 16),
                      child: ProductCard(product: _filteredProducts[index]),
                    );
                  },
                ),
              ),
              // Sağ Ok
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  _scrollList(scrollController, 1);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _scrollList(ScrollController controller, int direction) {
    const double itemWidth = 300; // Kart genişliği
    final double offset = direction * itemWidth;
    controller.animateTo(
      controller.offset + offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
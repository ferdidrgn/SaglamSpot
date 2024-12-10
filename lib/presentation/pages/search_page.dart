import 'package:flutter/material.dart';
import 'package:saglamspot/data/model/product.dart';
import 'package:saglamspot/data/repository/product_service.dart';

import '../../core/widgets/custom_product_card.dart';
import '../../core/widgets/custom_search.dart';
import '../../core/widgets/custom_title.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;

  // Filtre değişkenleri
  String? _selectedCondition;
  double _minPrice = 0;
  double _maxPrice = 50000; // Varsayılan maksimum fiyat
  final List<String> _conditions = ['Hepsi', 'Sıfır', 'İkinci El'];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      _products = await _productService.fetchFilteredProducts();
      _filteredProducts = List.from(_products);
    } catch (e) {
      _showErrorSnackbar('Veriler getirilemedi: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _filterProducts() async {
    setState(() => _isLoading = true);
    try {
      List<Product> filteredProducts =
          await _productService.fetchFilteredProducts(
        condition: _selectedCondition,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
      );

      setState(() {
        _filteredProducts = filteredProducts;
      });
    } catch (e) {
      _showErrorSnackbar('Filtreleme sırasında hata oluştu: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrele'),
          content: SingleChildScrollView(child: _buildFilterDialogContent()),
          actions: [
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Dialog kapat
                      await _filterProducts(); // Ürünleri filtrele
                    },
                    style: TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.errorContainer),
                    child: const Text("Uygula",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () {
                      _clearFilters();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.errorContainer),
                    child: const Text(
                      "Temizle",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildFilterDialogContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildConditionDropdown(),
        const SizedBox(height: 20),
        _buildPriceTextField('Minimum Fiyat', (value) {
          setState(() {
            _minPrice = double.tryParse(value) ?? 0;
          });
        }),
        const SizedBox(height: 20),
        _buildPriceTextField('Maksimum Fiyat', (value) {
          setState(() {
            _maxPrice = double.tryParse(value) ?? 10000;
          });
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
          _selectedCondition = (value == "Hepsi" ? null : value);
        });
      },
    );
  }

  Widget _buildPriceTextField(String label, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.red), // Odaklandığında kırmızı çizgi
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.grey), // Varsayılan durumda gri çizgi
        ),
      ),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts =
            List.from(_products); // Arama kutusu boşsa, tüm ürünleri geri getir
      } else {
        _filteredProducts = _products.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedCondition = null; // Seçilen durumu temizle
      _minPrice = 0; // Minimum fiyatı varsayılan değere ayarla
      _maxPrice = 10000; // Maksimum fiyatı varsayılan değere ayarla
      _filteredProducts = List.from(_products); // Tüm ürünleri göster
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchBar(onSearchChanged: _onSearchChanged),
                  _buildProductsByCategory(),
                ],
              ),
            ),
    );
  }

  Widget _buildProductsByCategory() {
    final soldProducts = _filteredProducts.where((p) => p.isSold).toList();
    final newProducts =
        _filteredProducts.where((p) => !p.isSold && !p.isSpotProduct).toList();
    final spotProducts =
        _filteredProducts.where((p) => !p.isSold && p.isSpotProduct).toList();

    return Column(
      children: [
        if (newProducts.isNotEmpty)
          _buildHorizontalListWithArrows('Sıfır Ürünler', newProducts),
        if (spotProducts.isNotEmpty)
          _buildHorizontalListWithArrows('İkinci El Ürünler', spotProducts),
        if (soldProducts.isNotEmpty)
          _buildHorizontalListWithArrows('Satılmış Ürünler', soldProducts),
      ],
    );
  }

  Widget _buildHorizontalListWithArrows(String title, List<Product> products) {
    final scrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        CustomSectionTitle(title: title),
        SizedBox(
          height: 405,
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
                      padding: const EdgeInsets.only(right: 16, bottom: 16),
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
          direction == -1 ? Icons.arrow_back_ios : Icons.arrow_forward_ios),
      onPressed: () => _scrollList(controller, direction),
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

import 'package:flutter/material.dart';
import 'package:saglamspot/data/model/product.dart';
import 'package:saglamspot/data/repository/product_service.dart';
import '../../../core/custom_views/custom_product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productService.fetchProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      // Hata durumunda bir işlem yapabilirsiniz.
      setState(() {
        _isLoading = false;
      });
      print('Ürünler yüklenirken hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Ürün ara...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 16),

              // Yeni Gelen Ürünler
              const Text(
                'Yeni Gelen Ürünler',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: _products[index]);
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Satılmış Ürünler
              const Text(
                '3 Ay İçinde Satılmış Ürünler',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _products
                      .where((p) => p.isSold)
                      .toList()
                      .length,
                  itemBuilder: (context, index) {
                    final soldProducts =
                    _products.where((p) => p.isSold).toList();
                    return ProductCard(product: soldProducts[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

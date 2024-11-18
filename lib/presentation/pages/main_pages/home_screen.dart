import 'package:flutter/material.dart';
import 'package:saglamspot/core/custom_views/custom_title.dart';
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
      setState(() {
        _isLoading = false;
      });
      debugPrint('Ürünler yüklenirken hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 32),
                  const CustomSectionTitle(title: 'Yeni Gelen Ürünler'),
                  _buildHorizontalProductList(
                      products: _products.where((p) => !p.isSold).toList()),
                  const SizedBox(height: 32),
                  const CustomSectionTitle(title: '3 Ay İçinde Satılmış Ürünler'),
                  _buildHorizontalProductList(
                      products: _products.where((p) => p.isSold).toList()),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  // Search Bar
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Ürün ara...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  // Yatay Ürün Listesi
  Widget _buildHorizontalProductList({required List<Product> products}) {
    return SizedBox(
      height: 250,
      child: products.isEmpty
          ? const Center(child: Text('Ürün bulunamadı.'))
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              // Kartlar arası boşluk
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
    );
  }
}

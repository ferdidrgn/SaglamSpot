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
            _buildHorizontalListWithArrows(
                products: _products.where((p) => !p.isSold).toList()),
            const SizedBox(height: 32),
            const CustomSectionTitle(
                title: '3 Ay İçinde Satılmış Ürünler'),
            _buildHorizontalListWithArrows(
                products: _products.where((p) => p.isSold).toList()),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

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

  Widget _buildHorizontalListWithArrows({required List<Product> products}) {
    final ScrollController scrollController = ScrollController();

    return SizedBox(
      height: 300,
      child: Row(
        children: [
          // Sol Ok
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                _scrollList(scrollController, -1);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ProductCard(product: products[index]),
                );
              },
            ),
          ),
          // Sağ Ok
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                _scrollList(scrollController, 1);
              },
            ),
          ),
        ],
      ),
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

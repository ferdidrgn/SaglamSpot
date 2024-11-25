import 'package:flutter/material.dart';
import 'package:saglamspot/core/custom_views/custom_title.dart';
import 'package:saglamspot/data/model/product.dart';
import 'package:saglamspot/data/repository/product_service.dart';
import '../../../core/custom_views/custom_product_card.dart';
import '../../../core/custom_views/custom_search.dart';
import '../search_page.dart';

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
      if (mounted) {
        setState(() => _isLoading = false);
        // Hata durumunda Snackbar göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ürünler yüklenirken hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchBar(onSearchTap: _navigateToSearch),
                  _buildHorizontalListWithArrows('Yeni Gelen Ürünler',
                      _products.where((p) => !p.isSold).toList()),
                  _buildHorizontalListWithArrows(
                      'Satılmış Ürünler (3 Ay İçinde)',
                      _products.where((p) => p.isSold).toList()),
                ],
              ),
            ),
    );
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchPage()),
    );
  }

  Widget _buildHorizontalListWithArrows(String title, List<Product> products) {
    final ScrollController scrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        CustomSectionTitle(title: title),
        SizedBox(
          height: 405,
          child: Row(
            children: [
              // Sol Ok
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
              // Sağ Ok
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

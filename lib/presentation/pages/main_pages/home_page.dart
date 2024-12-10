import 'package:flutter/material.dart';
import 'package:saglamspot/data/model/product.dart';
import 'package:saglamspot/data/repository/product_service.dart';
import '../../../core/widgets/custom_footer.dart';
import '../../../core/widgets/custom_product_card.dart';
import '../../../core/widgets/custom_search.dart';
import '../../../core/widgets/custom_title.dart';
import '../search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: CustomSearchBar(onSearchTap: _navigateToSearch)),
                  const SizedBox(height: 20),
                  _buildHeroSection(),
                  const SizedBox(height: 20),
                  _buildHorizontalListWithArrows('Yeni Gelen Ürünler',
                      _products.where((p) => !p.isSold).toList()),
                  _buildHorizontalListWithArrows(
                      'Satılmış Ürünler (3 Ay İçinde)',
                      _products.where((p) => p.isSold).toList()),
                  const SizedBox(height: 40),
                  const CustomFooter(),
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

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF8B4513),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.all(40),
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const Text(
            'Hayalinizdeki Ürünler Burada!',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'En yeni ve en kaliteli ürünleri keşfedin.',
            style: TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Image.network(
            'https://example.com/hero-image.jpg',
            // Buraya uygun bir görsel URL'si ekleyin
            height: 200,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListWithArrows(String title, List<Product> products) {
    final ScrollController scrollController = ScrollController();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            CustomSectionTitle(title: title),
            SizedBox(
              height: 375,
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
                          width: 350,
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
        ));
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

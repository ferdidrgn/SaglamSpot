import 'package:flutter/material.dart';
import '../../../data/repository/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  late Future<List<Map<String, dynamic>>> _productsFuture;
  late Future<List<Map<String, dynamic>>> _soldProductsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.fetchProducts();
    _soldProductsFuture = _productService.fetchSoldProducts(
      DateTime.now().subtract(const Duration(days: 90)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobilya Dükkânı')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Ürün ara...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),

          // Mevcut Ürünler
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Hata: ${snapshot.error}');
              }
              final products = snapshot.data ?? [];
              return Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(product['imageUrl'], fit: BoxFit.cover),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(product['name'], style: const TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('${product['price']} TL', style: const TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Satılmış Ürünler
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _soldProductsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Hata: ${snapshot.error}');
              }
              final soldProducts = snapshot.data ?? [];
              return SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: soldProducts.length,
                  itemBuilder: (context, index) {
                    final product = soldProducts[index];
                    return Card(
                      child: Column(
                        children: [
                          Image.network(product['imageUrl'], fit: BoxFit.cover, width: 100),
                          Text(product['name']),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sağlam Spot - Mobilya Satışı'),
        backgroundColor: Colors.brown,
        actions: [
          TextButton(onPressed: () => _navigate(context, '/'), child: const Text('Anasayfa')),
          TextButton(onPressed: () => _navigate(context, '/urunler'), child: const Text('Ürünler')),
          TextButton(onPressed: () => _navigate(context, '/sifir'), child: const Text('Sıfır')),
          TextButton(onPressed: () => _navigate(context, '/ikinciel'), child: const Text('2. El')),
          TextButton(onPressed: () => _navigate(context, '/sss'), child: const Text('SSS')),
          TextButton(onPressed: () => _navigate(context, '/hakkinda'), child: const Text('Hakkında')),
          TextButton(onPressed: () => _navigate(context, '/ulasim'), child: const Text('Ulaşım')),
          TextButton(onPressed: () => _navigate(context, '/iletisim'), child: const Text('İletişim')),
        ],
      ),
      body: const HomeContent(),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Hoş Geldiniz Sağlam Spot!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 400,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Mobilya Ara',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Yeni Eklenen Ürünler',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10, // Dinamik olarak veritabanından gelen yeni ürün sayısı
              itemBuilder: (context, index) => _buildProductCard('Yeni Ürün $index', 'https://via.placeholder.com/150'),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Son 3 Ayda Satılanlar',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10, // Dinamik olarak veritabanından gelen satılan ürün sayısı
              itemBuilder: (context, index) => _buildProductCard('Satılan Ürün $index', 'https://via.placeholder.com/150'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String imageUrl) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

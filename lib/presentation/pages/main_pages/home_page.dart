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
          TextButton(
              onPressed: () => _navigate(context, '/'),
              child: const Text('Anasayfa')),
          TextButton(
              onPressed: () => _navigate(context, '/urunler'),
              child: const Text('Ürünler')),
          TextButton(
              onPressed: () => _navigate(context, '/sifir'),
              child: const Text('Sıfır')),
          TextButton(
              onPressed: () => _navigate(context, '/ikinciel'),
              child: const Text('2. El')),
          TextButton(
              onPressed: () => _navigate(context, '/sss'),
              child: const Text('SSS')),
          TextButton(
              onPressed: () => _navigate(context, '/hakkinda'),
              child: const Text('Hakkında')),
          TextButton(
              onPressed: () => _navigate(context, '/ulasim'),
              child: const Text('Ulaşım')),
          TextButton(
              onPressed: () => _navigate(context, '/iletisim'),
              child: const Text('İletişim')),
        ],
      ),
      body: const HomeContent(),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
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
              'Hoş Geldiniz Sağlam Spot',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.height * 0.8,
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
            height: 350,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              // Dinamik olarak veritabanından gelen yeni ürün sayısı
              itemBuilder: (context, index) => ProductCard(
                title: 'Yeni Ürün $index',
                imageUrl:
                    "https://www.outletmobilya.net/img/urunler/b/557_1491738949_RITA-KOLTUK-TAKIMI.jpg",
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Son 3 Ayda Satılanlar',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 350,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              // Dinamik olarak veritabanından gelen satılan ürün sayısı
              itemBuilder: (context, index) => ProductCard(
                title: 'Satılan Ürün $index',
                imageUrl:
                    "https://media.licdn.com/dms/image/v2/C5603AQHzQm0FyYnqgg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1623939651768?e=2147483647&v=beta&t=fBt_4py5deqYIqZDEuuWAuNuCGlLLri-e-GYTCcdFd8",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const ProductCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        child: Card(
            elevation: 8,
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Image.network(
                      'https://i.ytimg.com/vi/tzPpkRLf9a8/hq720.jpg?sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AH-CYAC0AWKAgwIABABGHIgWyg9MA8=&rs=AOn4CLCBnYXpB7USjvYDePL64AaVI7Epyw',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(title, style: const TextStyle(fontSize: 16)))
                ]))));
  }
}

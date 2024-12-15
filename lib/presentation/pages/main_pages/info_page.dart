import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobilya Dükkanı Bilgi Sayfası'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDecoratedCard(
              context,
              title: 'İş Yeri Bilgileri',
              content:
                  'Kuruluşumuz, kaliteli mobilya hizmetleri sunarak müşterilerimizin memnuniyetini ön planda tutmaktadır.',
              color: Colors.brown[300]!,
              imageUrl: 'assets/images/furniture_shop.png',
            ),
            _buildDecoratedCard(
              context,
              title: 'Taşıma Hizmeti',
              content:
                  '1. İçerenköy Mahallesi\n2. İçerenköy Mah yakın çevreleri',
              color: Colors.orange[300]!,
              imageUrl: 'assets/images/volvo_transport.jpg',
            ),
            _buildDecoratedCard(
              context,
              title: 'Ulaşım',
              content:
                  'Otobüs Hatları ve Durakları:\nZiyapaşa Durağı Kadıköy Yönü: 19, 19F, 19FB',
              color: Colors.green[300]!,
              imageUrl: 'assets/images/taksim_train.jpg',
            ),
            _buildDecoratedCard(
              context,
              title: 'Harita',
              content: 'Harita burada gösterilecek.',
              color: Colors.blue[300]!,
              imageUrl: 'assets/images/map.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecoratedCard(
    BuildContext context, {
    required String title,
    required String content,
    required Color color,
    required String imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern or shape
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageUrl), // Add a furniture pattern image
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.5),
                      BlendMode.dstATop), // Optional overlay for better contrast
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Full-width image with appropriate height
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageUrl,
              height: MediaQuery.of(context).size.height * 0.3, // Set height to 30% of the screen
              fit: BoxFit.cover,
            ),
          ),
          // Overlay text centered
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
                crossAxisAlignment: CrossAxisAlignment.center, // Center text horizontally
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24, // Increased font size for title
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center, // Center text
                  ),
                  const SizedBox(height: 10),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16, // Adjusted font size for content
                      color: Colors.white,
                      height: 1.5, // Increased line height for better readability
                    ),
                    textAlign: TextAlign.center, // Center text
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
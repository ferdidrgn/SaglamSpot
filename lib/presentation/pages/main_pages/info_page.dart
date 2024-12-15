import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobilya Dükkanı Bilgi Sayfası'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFullWidthCard(
              context,
              title: 'İş Yeri Bilgileri',
              content: 'Kuruluşumuz, kaliteli mobilya hizmetleri sunarak müşterilerimizin memnuniyetini ön planda tutmaktadır.',
              color: Colors.brown[200]!,
              imageUrl: 'assets/images/furniture_shop.png',
            ),
            const SizedBox(height: 20), // Space between cards
            _buildFullWidthCard(
              context,
              title: 'Taşıma Hizmeti',
              content: '1. İçerenköy Mahallesi\n2. İçerenköy Mah yakın çevreleri',
              color: Colors.orange[200]!,
              imageUrl: 'assets/images/volvo_transport.jpg',
            ),
            const SizedBox(height: 20), // Space between cards
            _buildFullWidthCard(
              context,
              title: 'Ulaşım',
              content: 'Otobüs Hatları ve Durakları:\nZiyapaşa Durağı Kadıköy Yönü: 19, 19F, 19FB',
              color: Colors.green[200]!,
              imageUrl: 'assets/images/taksim_train.jpg',
            ),
            _buildFullWidthCard(
              context,
              title: 'Harita',
              content: 'Harita burada gösterilecek.',
              color: Colors.blue[200]!,
              imageUrl: 'assets/images/map.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthCard(
    BuildContext context, {
    required String title,
    required String content,
    required Color color,
    required String imageUrl,
  }) {
    return Stack(
      children: [
        // Full-width image with 75% screen height
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.75, // Set height to 75% of the screen
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        // Overlay text centered
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 100, // Set width to full screen minus margins
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
                    fontSize: 20, // Increased font size for content
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center, // Center text
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
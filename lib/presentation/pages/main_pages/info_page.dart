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
            _buildInfoRow(
              context,
              title: 'İş Yeri Bilgileri',
              content: 'Kuruluşumuz, kaliteli mobilya hizmetleri sunarak müşterilerimizin memnuniyetini ön planda tutmaktadır.',
              color: Colors.brown[200]!, // Nostalgic brown color
              imageUrl: 'assets/images/furniture_shop.png', // İş Yeri Görseli
              isImageFirst: true, // New parameter to control layout
            ),
            _buildInfoRow(
              context,
              title: 'Taşıma Hizmeti',
              content: '1. İçerenköy Mahallesi\n2. İçerenköy Mah yakın çevreleri',
              color: Colors.orange[200]!, // Nostalgic orange color
              imageUrl: 'assets/images/volvo_transport.jpg', // Taşıma Hizmeti Görseli
              isImageFirst: false, // New parameter to control layout
            ),
            _buildInfoRow(
              context,
              title: 'Ulaşım',
              content: 'Otobüs Hatları ve Durakları:\nZiyapaşa Durağı Kadıköy Yönü: 19, 19F, 19FB',
              color: Colors.green[200]!, // Nostalgic green color
              imageUrl: 'assets/images/volvo_transport.jpg', // Ulaşım Görseli
              isImageFirst: true, // New parameter to control layout
            ),
            _buildInfoRow(
              context,
              title: 'Harita',
              content: 'Harita burada gösterilecek.',
              color: Colors.blue[200]!, // Nostalgic blue color
              imageUrl: 'assets/images/furniture_shop.png', // Harita Görseli
              isImageFirst: false, // New parameter to control layout
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String title,
    required String content,
    required Color color,
    required String imageUrl,
    required bool isImageFirst, // New parameter to control layout
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          // Conditional layout based on isImageFirst
          if (isImageFirst) ...[
            // %30'lik Kart (Görsel)
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 250, // Set height limit to 150
              margin: const EdgeInsets.only(right: 8.0),
              child: Card(
                color: color,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // %70'lik Kart (Metin)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Card(
                  color: color.withOpacity(0.8), // Slightly transparent for effect
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          content,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ] else ...[
            // %70'lik Kart (Metin)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Card(
                  color: color.withOpacity(0.8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          content,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // %30'lik Kart (Görsel)
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 250, // Set height limit to 150
              margin: const EdgeInsets.only(left: 8.0),
              child: Card(
                color: color,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
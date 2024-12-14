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
              icon: Icons.business,
            ),
            _buildInfoRow(
              context,
              title: 'Taşıma Hizmeti',
              content: '1. İçerenköy Mahallesi\n2. İçerenköy Mah yakın çevreleri',
              color: Colors.orange[200]!, // Nostalgic orange color
              icon: Icons.local_shipping,
            ),
            _buildInfoRow(
              context,
              title: 'Ulaşım',
              content: 'Otobüs Hatları ve Durakları:\nZiyapaşa Durağı Kadıköy Yönü: 19, 19F, 19FB',
              color: Colors.green[200]!, // Nostalgic green color
              icon: Icons.map,
            ),
            _buildInfoRow(
              context,
              title: 'Harita',
              content: 'Harita burada gösterilecek.',
              color: Colors.blue[200]!, // Nostalgic blue color
              icon: Icons.place,
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
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          // %20'lik Kart (Görsel)
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            margin: const EdgeInsets.only(right: 8.0),
            child: Card(
              color: color,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(icon, size: 40, color: Colors.white),
              ),
            ),
          ),
          // %80'lik Kart (Metin)
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
        ],
      ),
    );
  }
}
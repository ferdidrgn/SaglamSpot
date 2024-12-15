import 'package:flutter/material.dart';

import '../../../core/widgets/custom_decorated_card.dart';

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
        child: Column(
          children: [
            CustomDecoratedCard(
              title: 'İş Yeri Bilgileri',
              content:
                  'Müşterilerimize en kaliteli ve şık mobilya çözümleri sunarak, yaşam alanlarını daha konforlu ve estetik hale getiriyoruz. Her bir ürünümüz, zarafet ve işlevselliği bir araya getirerek, evlerinizi ve ofislerinizi hayalinizdeki mekanlara dönüştürmeyi hedefliyor. Bizimle, sadece bir alışveriş değil, aynı zamanda bir yaşam tarzı deneyimi yaşıyorsunuz.',
              color: Colors.brown[200]!,
              imageUrl: 'assets/images/bicycle_france.jpg',
            ),
            CustomDecoratedCard(
              title: 'Taşıma Hizmeti',
              content:
                  '1. İçerenköy Mahallesi\n2. İçerenköy Mah yakın çevreleri',
              color: Colors.orange[300]!,
              imageUrl: 'assets/images/volvo_transport.jpg',
            ),
            CustomDecoratedCard(
              title: 'Ulaşım',
              content: 'Otobüs Hatları ve Durakları:\n'
                  'Ziyapaşa Durağı Kadıköy Yönü: 19, 19F, 19FB, 14KS, 18UK, KM46-1\n'
                  'İçerenköy Durağı Kayışdağı Yönü: 19, 19F, 19FB, 14KS, 18UK, KM46-1\n'
                  'İçerenköy Durağı Yeniyol\'dan: 10, 319, KM46, 13AB, 14T',
              color: Colors.green[200]!,
              imageUrl: 'assets/images/tram_bus.jpg',
            ),
            CustomDecoratedCard(
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
}

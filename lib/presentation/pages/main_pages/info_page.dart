import 'package:flutter/material.dart';
import '../../../core/widgets/custom_decorated_card.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  final List<Map<String, String>> infoCards = const [
    {
      'title': 'İş Yeri Bilgileri',
      'content':
          'Müşterilerimize en kaliteli ve şık mobilya çözümleri sunarak, yaşam alanlarını daha konforlu ve estetik hale getiriyoruz. Her bir ürünümüz, zarafet ve işlevselliği bir araya getirerek, evlerinizi ve ofislerinizi hayalinizdeki mekanlara dönüştürmeyi hedefliyor. Bizimle, sadece bir alışveriş değil, aynı zamanda bir yaşam tarzı deneyimi yaşıyorsunuz.',
      'color': 'brown',
      'imageUrl': 'assets/images/bicycle_france.jpg',
    },
    {
      'title': 'Taşıma Hizmeti',
      'content': '1. İçerenköy Mahallesi\n2. İçerenköy Mah yakın çevreleri',
      'color': 'orange',
      'imageUrl': 'assets/images/volvo_transport.jpg',
    },
    {
      'title': 'Ulaşım',
      'content': 'Otobüs Hatları ve Durakları:\n'
          'Ziyapaşa Durağı Kadıköy Yönü: 19, 19F, 19FB, 14KS, 18UK, KM46-1\n'
          'İçerenköy Durağı Kayışdağı Yönü: 19, 19F, 19FB, 14KS, 18UK, KM46-1\n'
          'İçerenköy Durağı Yeniyol\'dan: 10, 319, KM46, 13AB, 14T',
      'color': 'green',
      'imageUrl': 'assets/images/tram_bus.jpg',
    },
    {
      'title': 'Harita',
      'content': 'Harita burada gösterilecek.',
      'color': 'blue',
      'imageUrl': 'assets/images/map.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: infoCards.map((info) {
            return CustomDecoratedCard(
              title: info['title']!,
              content: info['content']!,
              color: _getColor(info['color']!),
              imageUrl: info['imageUrl']!,
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'brown':
        return Colors.brown[200]!;
      case 'orange':
        return Colors.orange[200]!;
      case 'green':
        return Colors.green[200]!;
      case 'blue':
        return Colors.blue[200]!;
      default:
        return Colors.black26;
    }
  }
}

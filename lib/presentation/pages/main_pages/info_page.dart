import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/widgets/custom_decorated_card.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  final List<Map<String, String>> infoCards = const [
    {
      'title': 'İş Yeri Bilgileri',
      'content':
          'Müşterilerimize en kaliteli ve şık mobilya çözümleri sunarak, yaşam alanlarını daha konforlu ve estetik hale getiriyoruz.',
      'color': 'brown',
      'imageUrl': 'assets/images/bicycle_france.jpg',
    },
    {
      'title': 'Ustamızın Geçmişi ve Yetenekleri',
      'content': "Ustamız, 1992 yılından beri bu sektörde aktif olarak çalışmaktadır. "
          "Kariyerine ilk adımlarını attığı günden itibaren sürekli bir gelişim göstermiştir. "
          "Çalışma hayatı boyunca, sürücülük, taşıma, montaj, müşteri karşılama gibi birçok iş pozisyonunda görev alarak çok yönlü bir deneyim kazanmıştır. "
          "Özellikle 2010 yılına kadar İstikbal'de çalışmış ve bu süreçte ürünlerin özellikleri, parçaları ve püf noktaları hakkında derinlemesine bilgi sahibi olmuştur. "
          "2010'dan sonra, yakın civardaki Işık Çeyiz'de çalışarak sektördeki yetkinliğini artırmıştır. "
          "2012 yılında ise kendi esnaf dükkanını açma kararı almış ve bu süreçte kaliteli hizmet anlayışını ön planda tutarak, sektördeki deneyimlerini müşterilerine en iyi şekilde aktarmayı hedeflemiştir.",
      'color': 'purple',
      'imageUrl': 'assets/images/man_walk.jpg',
    },
    {
      'title': 'Taşıma Hizmeti',
      'content': '1. İçerenköy Mahallesi\n2. İçerenköy Mah yakın çevreleri',
      'color': 'orange',
      'imageUrl': 'assets/images/volvo_transport.jpg',
    },
    {
      'title': 'Ulaşım',
      'content':
          'Otobüs Hatları ve Durakları:\nZiyapaşa Durağı Kadıköy Yönü: 19, 19F, 19FB, 14KS, 18UK, KM46-1\nİçerenköy Durağı Kayışdağı Yönü: 19, 19F, 19FB, 14KS, 18UK, KM46-1\nİçerenköy Durağı Yeniyol\'dan: 10, 319, KM46, 13AB, 14T',
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
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: infoCards.map((final info) {
                return CustomDecoratedCard(
                  title: info['title']!,
                  content: info['content']!,
                  color: _getColor(info['color']!),
                  imageUrl: info['imageUrl']!,
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                const phoneNumber = 'tel:+9055392019961';
                if (await canLaunch(phoneNumber)) {
                  await launch(phoneNumber);
                }
              },
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.phone, size: 40),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                const facebookUrl =
                    'https://www.google.com/maps/place/Sa%C4%9Flam+Spot/@40.9699248,29.1146853,21z/data=!4m6!3m5!1s0x14cac64216b4ccb7:0x49124944b40496f6!8m2!3d40.9699196!4d29.1148379!16s%2Fg%2F11dxc20095?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoASAFQAw%3D%3D';
                if (await canLaunch(facebookUrl)) {
                  await launch(facebookUrl);
                }
              },
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.map, size: 40),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(final String colorName) {
    switch (colorName) {
      case 'brown':
        return Colors.brown[200]!;
      case 'orange':
        return Colors.orange[200]!;
      case 'green':
        return Colors.green[200]!;
      case 'blue':
        return Colors.blue[200]!;
      case 'purple':
        return Colors.purple[200]!;
      default:
        return Colors.black26;
    }
  }
}

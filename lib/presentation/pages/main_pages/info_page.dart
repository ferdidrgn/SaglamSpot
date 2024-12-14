import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobilya Dükkanı Bilgi Sayfası'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hakkımızda',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Mobilya dükkanımız, kaliteli ve şık mobilyalar sunarak evlerinizi güzelleştirmeyi amaçlamaktadır. '
              'Bütün ürünlerimiz, müşteri memnuniyeti ön planda tutularak tasarlanmıştır.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'İletişim',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Telefon: +90 123 456 7890',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'E-posta: info@mobilyadukkanı.com',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Ulaşım',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Otobüs Hatları: 45, 67, 89\n'
              'İnmesi gereken durak: Mobilya Durağı',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Taşımacılık Hizmetleri',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Ürünlerimizi şu mahallelere ulaştırıyoruz:\n'
              '- Mahalle 1\n'
              '- Mahalle 2\n'
              '- Mahalle 3',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Harita',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
          ],),            
      ),
    );
  }
}
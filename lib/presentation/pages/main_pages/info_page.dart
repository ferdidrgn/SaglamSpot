import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobilya Dükkanı Bilgi Sayfası'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hakkımızda',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mobilya dükkanımız, kaliteli ve şık mobilyalar sunarak evlerinizi güzelleştirmeyi amaçlamaktadır. '
              'Bütün ürünlerimiz, müşteri memnuniyeti ön planda tutularak tasarlanmıştır.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            const Text(
              'İletişim',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Telefon: +90 123 456 7890',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'E-posta: info@mobilyadukkanı.com',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            const Text(
              'Ulaşım',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Otobüs Hatları: 45, 67, 89\n'
              'İnmesi gereken durak: Mobilya Durağı',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            const Text(
              'Taşımacılık Hizmetleri',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ürünlerimizi şu mahallelere ulaştırıyoruz:\n'
              '- Mahalle 1\n'
              '- Mahalle 2\n'
              '- Mahalle 3',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            const Text(
              'Harita',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(40.7128, -74.0060), // Örnek koordinatlar
                  zoom: 14,
                ),
                markers: <Marker>{
                    const Marker(
                      markerId: MarkerId('mobilyaDukani'),
                      position: LatLng(40.7128, -74.0060),
                      infoWindow: InfoWindow(
                        title: 'Mobilya Dükkanı',
                        snippet: 'Burada bizi ziyaret edebilirsiniz.',
                      ),
                    ),
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
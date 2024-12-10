import 'package:flutter/material.dart';
import '../add_product_page.dart';

class SSSPage extends StatelessWidget {
  const SSSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SSS (Sıkça Sorulan Sorular)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sıkça Sorulan Sorular",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text("1. Ürün nasıl eklenir?"),
            const Text("Cevap: Ürün eklemek için 'Ürün Ekle' butonuna tıklayın."),
            const SizedBox(height: 16),
            const Text("2. Görsel nasıl yüklenir?"),
            const Text("Cevap: Görsel seçmek için 'Görsel Seç' butonuna tıklayın."),
            const SizedBox(height: 16),
            const Text("3. Ürün satıldı mı? Nasıl belirlenir?"),
            const Text("Cevap: 'Ürün Satıldı mı?' kutucuğuna tıklayın."),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // AddProductPage sayfasına yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddProductPage()),
                );
              },
              child: const Text('Ürün Ekle Sayfasına Git'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/widgets/custom_decorated_card.dart';
import '../add_product_page.dart';

class SSSPage extends StatelessWidget {
  const SSSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDecoratedCard(
                title: "Sıkça Sorulan Sorular",
                content: "",
                color: Colors.blue[200]!,
                imageUrl: 'assets/images/book_room.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuestionAnswerCard(
                "1. Ustanın çalışma hayatı ve tecrübesi hakkında bilgi verebilir misiniz?",
                "Ustamız, 1992 yılından beri bu sektörde aktif olarak çalışmaktadır. "
                    "Kariyerine ilk adımlarını attığı günden itibaren sürekli bir gelişim göstermiştir. "
                    "Çalışma hayatı boyunca, sürücülük, taşıma, montaj, müşteri karşılama gibi birçok iş pozisyonunda görev alarak çok yönlü bir deneyim kazanmıştır. "
                    "Özellikle 2010 yılına kadar İstikbal'de çalışmış ve bu süreçte ürünlerin özellikleri, parçaları ve püf noktaları hakkında derinlemesine bilgi sahibi olmuştur. "
                    "2010'dan sonra, yakın civardaki Işık Çeyiz'de çalışarak sektördeki yetkinliğini artırmıştır. "
                    "2012 yılında ise kendi esnaf dükkanını açma kararı almış ve bu süreçte kaliteli hizmet anlayışını ön planda tutarak, sektördeki deneyimlerini müşterilerine en iyi şekilde aktarmayı hedeflemiştir.",
                Icons.work,
              ),
              _buildQuestionAnswerCard(
                "5. Ürün fiyatları nasıl belirleniyor?",
                "Cevap: Benzer ürünlerin piyasa fiyatlarına göre rekabetçi bir fiyat belirliyoruz.",
                Icons.attach_money,
              ),
              _buildQuestionAnswerCard(
                "6. Taşıma hizmeti sağlıyor musunuz?",
                "Cevap: Evet, yakın bölgelere taşıma hizmeti sunuyoruz.",
                Icons.local_shipping,
              ),
              _buildQuestionAnswerCard(
                "7. Ürün iade politikası nedir?",
                "Cevap: Ürün iade politikamız bulunmamaktadır.",
                Icons.undo,
              ),
              _buildQuestionAnswerCard(
                "9. Mobilyaları nasıl monte edebilirim?",
                "Cevap: Mobilyalarınızı montaj ve kurulumu bizler yapabiliyoruz.",
                Icons.build,
              ),
              _buildQuestionAnswerCard(
                "10. Ürünlerin garanti süresi var mı?",
                "Cevap: Hayır, garantimiz yoktur.",
                Icons.info,
              ),
              _buildQuestionAnswerCard(
                "12. Mobilyaların malzeme kalitesi nedir?",
                "Cevap: Ürünlerimizin açıklamalarında bilgiler yer almaktadır.",
                Icons.check_circle,
              ),
              _buildQuestionAnswerCard(
                "13. Ürünlerinizde renk seçenekleri var mı?",
                "Cevap: Hayır, seçenek sunamayız.",
                Icons.color_lens,
              ),
              _buildQuestionAnswerCard(
                "15. Ürünleri incelemek için mağazanıza gelebilir miyim?",
                "Cevap: Evet, ürünleri görmek için mağazamıza gelebilirsiniz.",
                Icons.store,
              ),
              _buildQuestionAnswerCard(
                "18. Ürün açıklamalarında nelere dikkat etmeliyim?",
                "Cevap: Ürünün kapladığı alan bilgilerini evinizin ölçüleri ile karşılaştırın.",
                Icons.assignment,
              ),
              _buildQuestionAnswerCard(
                "19. Mobilya siparişi ne kadar sürede teslim edilir?",
                "Cevap: Siparişiniz, ödemeden sonra en uygun vakitte teslim edilir.",
                Icons.timer,
              ),
              _buildQuestionAnswerCard(
                "20. Özel sipariş alıyor musunuz?",
                "Cevap: Hayır, özel tasarım siparişler almıyoruz.",
                Icons.cancel,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddProductPage(),
                    ),
                  );
                },
                child: const Text('Ürün Ekle Sayfasına Git'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionAnswerCard(
      String question, String answer, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    answer,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

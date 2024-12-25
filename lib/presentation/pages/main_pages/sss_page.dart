import 'package:flutter/material.dart';
import '../../../core/widgets/custom_decorated_card.dart';
import '../add_product_page.dart';

class SSSPage extends StatelessWidget {
  const SSSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'), // Arka plan görseli
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
                    "Kariyerine ilk adımlarını attığı günden itibaren sürekli bir gelişim göstermiştir.",
                Icons.work, // İkon ekleniyor
              ),
              _buildQuestionAnswerCard(
                "5. Ürün fiyatları nasıl belirleniyor?",
                "Cevap: Benzer ürünlerin piyasa fiyatlarına göre rekabetçi bir fiyat belirliyoruz.",
                Icons.attach_money, // İkon ekleniyor
              ),
              _buildQuestionAnswerCard(
                "6. Taşıma hizmeti sağlıyor musunuz?",
                "Cevap: Evet, yakın bölgelere taşıma hizmeti sunuyoruz.",
                Icons.local_shipping, // İkon ekleniyor
              ),
              _buildQuestionAnswerCard(
                "7. Ürün iade politikası nedir?",
                "Cevap: Ürün iade politikamız bulunmamaktadır. Elektronik ürünler, karmaşık bileşenlerden oluştuğundan her an bozulabilme kapasitesine sahiptir.",
                Icons.undo, // İkon ekleniyor
              ),
              _buildQuestionAnswerCard(
                "9. Mobilyaları nasıl monte edebilirim?",
                "Cevap: Mobilyalarınızı, mağazamıza yakın bölgelerde iseniz montaj ve kurulumu bizler yapabiliyoruz.",
                Icons.build, // İkon ekleniyor
              ),
              _buildQuestionAnswerCard(
                "10. Ürünlerin garanti süresi var mı?",
                "Cevap: Hayır, garantimiz yoktur. Ürünü gelip gözlemlemeniz sizler için daha iyi olacaktır.",
                Icons.info, // İkon ekleniyor
              ),
              _buildQuestionAnswerCard(
                "12. Mobilyaların malzeme kalitesi nedir?",
                "Cevap: Bazı ürünlerimizin açıklamalarında kullanılan malzeme ve kalitesi hakkında bilgiler yer almaktadır.",
                Icons.check_circle, // İkon ekleniyor
              ),
              _buildQuestionAnswerCard(
                "13. Ürünlerinizde renk seçenekleri var mı?",
                "Cevap: Hayır, İkinci el ürünlerimizi üretmediğimiz için seçenek sunamayız.",
                Icons.color_lens, // İkon ekleniyor
              ),
              _buildQuestionAnswerCard(
                "15. Ürünleri incelemek için mağazanıza gelebilir miyim?",
                "Cevap: Evet, ürünleri görmek için mağazamıza gelebilirsiniz.",
                Icons.store, // İkon ekleniyor
              ),
              _buildQuestionAnswerCard(
                "18. Ürün açıklamalarında nelere dikkat etmeliyim?",
                "Cevap: Ürünün kapladığı alan bilgilerini evinizin ölçüleri ile karşılaştırmaya dikkat ediniz.",
                Icons.assignment, // İkon ekleniyor
              ),
              _buildQuestionAnswerCard(
                "19. Mobilya siparişi ne kadar sürede teslim edilir?",
                "Cevap: Siparişiniz, ödemeden sonra en uygun vakitte teslim veya kurulum yapıyoruz.",
                Icons.timer, // İkon ekleniyor
              ),
              _buildQuestionAnswerCard(
                "20. Özel sipariş alıyor musunuz?",
                "Cevap: Hayır, özel tasarım siparişler almıyoruz.",
                Icons.cancel, // İkon ekleniyor
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // AddProductPage sayfasına yönlendirme
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

  Widget _buildQuestionAnswerCard(String question, String answer, IconData icon) {
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
            Icon(icon, size: 30, color: Colors.blue), // İkon
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
import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(final BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return SliverPadding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 60, vertical: 40),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Müşterilerimiz Ne Diyor?',
                style: TextStyle(
                    fontSize: context.h2Size,
                    fontWeight: FontWeight.w900,
                    color: context.primaryColor)),
            const SizedBox(height: 4),
            Container(height: 3, width: 40, color: context.colors.secondary),
            const SizedBox(height: 8),
            Text(
              '20 yılı aşkın süredir Ankara ve çevresinde binlerce eve dokunduk',
              style: TextStyle(
                  color: context.primaryColor.withOpacity(0.5),
                  fontSize: context.captionSize),
            ),
            const SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 3,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                mainAxisExtent: 240,
              ),
              itemCount: _testimonials.length,
              itemBuilder: (final context, final index) =>
                  _TestimonialCard(data: _testimonials[index]),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final _Testimonial data;

  const _TestimonialCard({required this.data});

  @override
  Widget build(final BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(
                5,
                (final i) => Icon(
                  i < data.rating ? Icons.star_rounded : Icons.star_border_rounded,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Text(
                data.comment,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 14, height: 1.5),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(height: 24),
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.secondary,
                  child: Text(
                    data.name.characters.first,
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(data.location,
                          style: const TextStyle(
                              color: AppColors.textTertiary, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _Testimonial {
  final String name;
  final String location;
  final String comment;
  final int rating;

  const _Testimonial({
    required this.name,
    required this.location,
    required this.comment,
    required this.rating,
  });
}

const List<_Testimonial> _testimonials = [
  _Testimonial(
    name: 'Elif Yıldız',
    location: 'Çankaya, Ankara',
    comment:
        'Koltuk takımını çok uygun fiyata aldık, hem de sıfır gibi. Teslimat aynı gün elden ele yapıldı, esnaf usulü güven tam anlamıyla buradaydı.',
    rating: 5,
  ),
  _Testimonial(
    name: 'Mehmet Kaya',
    location: 'Etimesgut, Ankara',
    comment:
        'Yatak odası takımını spot fiyatına buradan aldım. Ürün açıklamasıyla birebir aynıydı, hiçbir sürpriz yaşamadım. Kesinlikle tavsiye ederim.',
    rating: 5,
  ),
  _Testimonial(
    name: 'Ayşe Demir',
    location: 'Keçiören, Ankara',
    comment:
        'Ofis için toplu mobilya alımı yaptık, hem fiyat hem kalite beklentimizin üzerindeydi. İlgili ve sabırlı bir ekip, teşekkürler Sağlam Spot.',
    rating: 4,
  ),
  _Testimonial(
    name: 'Burak Şahin',
    location: 'Mamak, Ankara',
    comment:
        'Yemek masası setini pazarlıksız, dürüst bir fiyata satın aldık. Nakliye konusunda da yardımcı oldular, gönül rahatlığıyla alışveriş yaptık.',
    rating: 5,
  ),
  _Testimonial(
    name: 'Zeynep Arslan',
    location: 'Yenimahalle, Ankara',
    comment:
        'İkinci el gardırop aradık, hem sağlam hem şık bir ürün bulduk. Fiyat/performans olarak piyasadaki en iyi seçenekti.',
    rating: 5,
  ),
  _Testimonial(
    name: 'Can Öztürk',
    location: 'Sincan, Ankara',
    comment:
        'Showroom ziyaretimizde ürünleri yerinde görme şansımız oldu, bu güveni artırdı. Satış sonrası da bize her zaman ulaşılabilir oldular.',
    rating: 4,
  ),
];

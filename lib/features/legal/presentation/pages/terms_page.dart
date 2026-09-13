import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import 'legal_page_scaffold.dart';

/// Kullanım Koşulları — Türkçe (esas metin) ve İngilizce (çeviri) olarak
/// hazırlanmıştır. Diğer diller şimdilik Türkçe içeriğe düşer (bkz.
/// LegalPageScaffold'daki "sadece Türkçe/İngilizce" uyarı şeridi).
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(final BuildContext context) {
    final bool isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return LegalPageScaffold(
      title: context.l10n.settingsTerms,
      onBack: () => NavigationHandler.smartGoBack(context),
      children: isEnglish ? _englishSections() : _turkishSections(),
    );
  }

  List<Widget> _turkishSections() => [
        const _Section(
          title: '1. Hizmetin Niteliği',
          body:
              'Sağlam Spot uygulaması, mağazamızdaki sıfır ve ikinci el (spot) '
              'mobilyaları tanıtan bir katalog/vitrin uygulamasıdır. Uygulama '
              'üzerinden çevrimiçi ödeme veya sipariş tamamlama yapılmaz; '
              'satış, ürünü mağazada inceledikten sonra veya telefon/WhatsApp '
              'üzerinden anlaşarak tamamlanır.',
        ),
        const _Section(
          title: '2. Ürün Bilgileri',
          body:
              'Ürün görselleri, açıklamaları ve fiyatları bilgilendirme '
              'amaçlıdır; özellikle ikinci el ürünlerde gerçek durum '
              '(çizik, leke, aşınma vb.) fotoğraflarla birebir örtüşmeyebilir. '
              'Satın almadan önce ürünü mağazada incelemenizi tavsiye ederiz. '
              'Fiyatlar önceden haber verilmeksizin değişebilir; kesin fiyat '
              'satış anında teyit edilir.',
        ),
        const _Section(
          title: '3. Teslimat ve Montaj',
          body:
              'Belirli bölgelere (İçerenköy ve yakın çevresi) ücretsiz '
              'teslimat sağlanır; büyük ürünlerin montajı ek ücret alınmadan '
              'yapılır. Asansörü olmayan binalarda yüksek katlara taşıma '
              'hizmeti verilemez — sipariş öncesi bu konunun netleştirilmesi '
              'gerekir. Güncel teslimat bölgeleri ve koşulları için Sık '
              'Sorulan Sorular sayfamıza bakabilir veya bizimle iletişime '
              'geçebilirsiniz.',
        ),
        const _Section(
          title: '4. Garanti ve İade Politikası',
          body:
              'Sağlam Spot, büyük bir zincir mağaza değil, İçerenköy\'de '
              'yerleşik bir esnaf işletmesidir. Sattığımız ürünlerin önemli '
              'bir kısmı ikinci el (spot) mobilya ve eşyadır. Bu nedenle:\n\n'
              '• Ürünler "mevcut hâliyle" satılır; ikinci el ürünlerde '
              'zamanla oluşmuş kullanım izleri, çizik, solma veya küçük '
              'kusurlar bulunabilir.\n\n'
              '• Elektronik aksam içeren ürünler (motor, sürgü mekanizması, '
              'aydınlatma vb.) ikinci el olduğundan her an arıza yapabilir; '
              'bu tür ürünlerde üretici garantisi genellikle sona ermiştir '
              've tarafımızca ayrıca bir garanti verilmez.\n\n'
              '• Satış sonrası iade ve değişim kabul edilmez. Bu nedenle '
              'satın almadan önce ürünü mağazamızda bizzat görmenizi, '
              'elektronik/mekanik aksamı varsa çalıştığını yerinde kontrol '
              'etmenizi önemle tavsiye ederiz.\n\n'
              '• Sıfır (yeni) ürünlerde üretici garantisi varsa, bu garanti '
              'üretici/tedarikçi koşullarına tabidir; doğrudan tarafımızca '
              'sağlanan ek bir garanti değildir.\n\n'
              'Kısacası: küçük bir esnaf işletmesi olarak çalışıyoruz ve '
              'büyük zincir mağazaların sunduğu türde garanti/iade '
              'güvenceleri sunamıyoruz.',
        ),
        const _Section(
          title: '5. Ödeme',
          body:
              'Veresiye/sonra ödeme uygulanmaz; ürün bedeli teslimat '
              'sırasında peşin olarak tahsil edilir.',
        ),
        const _Section(
          title: '6. Fikri Mülkiyet',
          body:
              'Uygulamadaki logo, marka adı, görsel tasarım ve içerikler '
              'Sağlam Spot\'a aittir; izinsiz kopyalanamaz veya ticari amaçla '
              'kullanılamaz.',
        ),
        const _Section(
          title: '7. Sorumluluğun Sınırlandırılması',
          body:
              'Uygulama "olduğu gibi" sunulur; bağlantı/erişim sorunları veya '
              'içerikteki olası güncel olmayan bilgilerden doğabilecek '
              'dolaylı zararlardan sorumlu tutulamayız.',
        ),
        const _Section(
          title: '8. Uygulanacak Hukuk',
          body:
              'Bu koşullar Türkiye Cumhuriyeti yasalarına tabidir; '
              'uyuşmazlıklarda İstanbul mahkemeleri ve icra daireleri '
              'yetkilidir.',
        ),
        _Section(
          title: '9. İletişim',
          body:
              'Sorularınız için ${SaglamSpotCommunication.email} adresinden veya '
              '${SaglamSpotCommunication.displayPhone} numarasından bize ulaşabilirsiniz.',
        ),
      ];

  List<Widget> _englishSections() => [
        const _Section(
          title: '1. Nature of the Service',
          body:
              'The Sağlam Spot app is a catalog/showcase app presenting new '
              'and second-hand (spot) furniture available in our store. No '
              'online payment or order completion takes place through the '
              'app; a sale is completed after inspecting the product in '
              'store or by agreement over phone/WhatsApp.',
        ),
        const _Section(
          title: '2. Product Information',
          body:
              'Product photos, descriptions and prices are for informational '
              'purposes only; for second-hand items in particular, the '
              'actual condition (scratches, stains, wear, etc.) may not '
              'exactly match the photos. We recommend inspecting the product '
              'in store before purchasing. Prices may change without prior '
              'notice; the final price is confirmed at the time of sale.',
        ),
        const _Section(
          title: '3. Delivery and Assembly',
          body:
              'Free delivery is provided to certain areas (İçerenköy and '
              'nearby); assembly of large items is done at no extra charge. '
              'We are unable to carry items to upper floors in buildings '
              'without an elevator — this must be clarified before ordering. '
              'For current delivery areas and conditions, see our FAQ page '
              'or contact us.',
        ),
        const _Section(
          title: '4. Warranty and Return Policy',
          body:
              'Sağlam Spot is not a large chain store — we are a small shop '
              'based in İçerenköy. A significant part of what we sell is '
              'second-hand (spot) furniture and goods. Because of this:\n\n'
              '• Products are sold "as is"; second-hand items may show wear, '
              'scratches, fading, or minor defects that accumulated over '
              'time.\n\n'
              '• Products with electronic parts (motors, sliding '
              'mechanisms, lighting, etc.) are second-hand and can fail at '
              'any time; manufacturer warranty on such items has usually '
              'expired, and we do not provide an additional warranty '
              'ourselves.\n\n'
              '• Returns and exchanges after a sale are not accepted. We '
              'strongly recommend inspecting the product in person at our '
              'store before buying, and testing any electronic/mechanical '
              'parts on the spot.\n\n'
              '• If a new (zero) product still has manufacturer warranty, '
              'that warranty is governed by the manufacturer\'s/supplier\'s '
              'own terms — it is not an additional warranty provided '
              'directly by us.\n\n'
              'In short: we operate as a small local shop and cannot offer '
              'the kind of warranty/return guarantees that large chain '
              'stores provide.',
        ),
        const _Section(
          title: '5. Payment',
          body:
              'We do not offer store credit or pay-later options; the '
              'product price is collected in full at the time of delivery.',
        ),
        const _Section(
          title: '6. Intellectual Property',
          body:
              'The logo, brand name, visual design, and content in the app '
              'belong to Sağlam Spot; they may not be copied or used '
              'commercially without permission.',
        ),
        const _Section(
          title: '7. Limitation of Liability',
          body:
              'The app is provided "as is"; we are not liable for indirect '
              'damages arising from connectivity/access issues or possibly '
              'outdated information in the content.',
        ),
        const _Section(
          title: '8. Governing Law',
          body:
              'These terms are governed by the laws of the Republic of '
              'Türkiye; courts and enforcement offices of Istanbul have '
              'jurisdiction over any disputes.',
        ),
        _Section(
          title: '9. Contact',
          body:
              'For questions, you can reach us at ${SaglamSpotCommunication.email} '
              'or ${SaglamSpotCommunication.displayPhone}.',
        ),
      ];
}

class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: AppColors.mobileTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: TextStyle(
                fontSize: 13.5,
                color: AppColors.mobileTextSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      );
}

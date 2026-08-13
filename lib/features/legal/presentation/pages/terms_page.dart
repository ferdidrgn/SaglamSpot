import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import 'legal_page_scaffold.dart';

/// Kullanım Koşulları — şu an yalnızca Türkçe (bkz. privacy_policy_page.dart
/// üzerindeki not, aynı gerekçe geçerli).
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return LegalPageScaffold(
      title: context.l10n.settingsTerms,
      onBack: () => NavigationHandler.smartGoBack(context),
      children: [
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
          title: '4. İade Politikası',
          body:
              'İkinci el ürünlerin doğası ve esnaf usulü çalışma modelimiz '
              'gereği satış sonrası iade kabul edilmemektedir. Bu nedenle '
              'satın almadan önce ürünü mağazada incelemenizi öneririz.',
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
      ],
    );
  }
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

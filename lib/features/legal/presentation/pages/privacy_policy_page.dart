import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import 'legal_page_scaffold.dart';

/// Gizlilik Politikası — şu an yalnızca Türkçe. Hukuki metin olduğu için
/// diğer dillere makine çevirisiyle aktarılmadı (bkz. üstteki uyarı notu),
/// yeni pazarlar için profesyonel çeviri önerilir.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return LegalPageScaffold(
      title: context.l10n.settingsPrivacyPolicy,
      onBack: () => NavigationHandler.smartGoBack(context),
      children: [
        const _Section(
          title: '1. Topladığımız Bilgiler',
          body:
              'Sağlam Spot uygulamasında müşteri hesabı/üyelik sistemi bulunmaz; '
              'ürünleri görüntülemek için giriş yapmanız gerekmez. Uygulama, '
              'hizmet kalitesini iyileştirmek amacıyla Firebase altyapısı '
              'üzerinden şu bilgileri toplayabilir: uygulama kullanım '
              'istatistikleri (Firebase Analytics), çökme/hata raporları '
              '(Firebase Crashlytics) ve bildirim gönderebilmek için cihaz '
              'bildirim belirteci (Firebase Cloud Messaging). Bu veriler '
              'kimliğinizi doğrudan hedeflemez.',
        ),
        _Section(
          title: '2. WhatsApp ve Telefon İletişimi',
          body:
              'Bir ürünle ilgilenip "WhatsApp\'tan Yaz" veya "Ara" butonuna '
              'dokunduğunuzda, sizi WhatsApp veya telefon uygulamanıza '
              'yönlendiririz; bu iletişim doğrudan sizinle ${SaglamSpotCommunication.displayPhone} '
              'numarası arasında gerçekleşir ve WhatsApp/telefon '
              'operatörünüzün kendi gizlilik politikalarına tabidir.',
        ),
        const _Section(
          title: '3. Ödeme Bilgisi Toplamayız',
          body:
              'Uygulama üzerinden çevrimiçi ödeme veya sipariş tamamlama '
              'işlemi yapılmaz; "sepet" özelliği yalnızca ilgilendiğiniz '
              'ürünleri not edip mağazaya toplu olarak sormanızı sağlayan bir '
              'istek listesidir. Kredi kartı, banka bilgisi gibi ödeme '
              'verileri hiçbir şekilde toplanmaz veya saklanmaz.',
        ),
        const _Section(
          title: '4. Konum ve Diğer İzinler',
          body:
              'Uygulama konumunuzu takip etmez. Bazı özellikler (örn. ürün '
              'görseli seçimi) için cihazınızdan izin isteyebiliriz; bu '
              'izinler yalnızca ilgili özellik kullanılırken devreye girer.',
        ),
        const _Section(
          title: '5. Verilerin Saklanması ve Güvenliği',
          body:
              'Toplanan sınırlı kullanım verileri Google Firebase '
              'altyapısında endüstri standardı güvenlik önlemleriyle '
              'saklanır. Verileriniz üçüncü taraflara satılmaz.',
        ),
        _Section(
          title: '6. Haklarınız ve İletişim',
          body:
              'Gizlilikle ilgili sorularınız için bize ${SaglamSpotCommunication.email} '
              'adresinden ulaşabilirsiniz.',
        ),
        const _Section(
          title: '7. Değişiklikler',
          body:
              'Bu politika zaman zaman güncellenebilir; önemli değişiklikler '
              'uygulama içinde duyurulur.',
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
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                color: AppColors.mobileTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.mobileTextSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      );
}

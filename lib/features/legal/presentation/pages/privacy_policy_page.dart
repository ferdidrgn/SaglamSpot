import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';
import 'legal_page_scaffold.dart';

/// Gizlilik Politikası — Türkçe (esas metin) ve İngilizce (çeviri) olarak
/// hazırlanmıştır. Diğer diller şimdilik Türkçe içeriğe düşer (bkz.
/// LegalPageScaffold'daki "sadece Türkçe/İngilizce" uyarı şeridi).
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(final BuildContext context) {
    final bool isEnglish = Localizations.localeOf(context).languageCode == 'en';

    return LegalPageScaffold(
      title: context.l10n.settingsPrivacyPolicy,
      onBack: () => NavigationHandler.smartGoBack(context),
      children: isEnglish ? _englishSections() : _turkishSections(),
    );
  }

  List<Widget> _turkishSections() => [
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
        const _Section(
          title: '6. Reklamlar (Google AdMob / AdSense)',
          body:
              'Uygulamada ve web sitemizde, Sağlam Spot\'un ücretsiz '
              'kalabilmesine katkı sağlayan reklamlar Google AdMob (mobil '
              'uygulama) ve Google AdSense (web sitesi) aracılığıyla '
              'gösterilir. Bu kapsamda:\n\n'
              '• Google, ilginizi çekebilecek reklamlar gösterebilmek için '
              'cihaz reklam kimliği (Advertising ID), IP adresi ve genel '
              'kullanım verileri gibi bilgileri işleyebilir; buna '
              '"kişiselleştirilmiş reklamcılık" denir.\n\n'
              '• Bu verileri biz doğrudan görmeyiz veya saklamayız; işleme '
              'Google\'ın kendi gizlilik politikasına '
              '(policies.google.com/privacy) tabidir.\n\n'
              '• Kişiselleştirilmiş reklamları cihazınızın ayarlarından '
              '(Android: Ayarlar > Google > Reklamlar; iOS: Ayarlar > '
              'Gizlilik > İzleme) kapatabilirsiniz; bu durumda reklamlar '
              'kişiselleştirilmemiş olarak gösterilmeye devam edebilir.\n\n'
              '• Uygulamamız 13 yaş altı çocuklara özel olarak '
              'yönlendirilmemiştir; bilerek çocuklardan veri toplamayız.\n\n'
              '• Web sitemizde Google AdSense çerez (cookie) kullanabilir; '
              'tarayıcı ayarlarınızdan çerezleri yönetebilirsiniz.',
        ),
        _Section(
          title: '7. Haklarınız ve İletişim',
          body:
              'Gizlilikle ilgili sorularınız için bize ${SaglamSpotCommunication.email} '
              'adresinden ulaşabilirsiniz.',
        ),
        const _Section(
          title: '8. Değişiklikler',
          body:
              'Bu politika zaman zaman güncellenebilir; önemli değişiklikler '
              'uygulama içinde duyurulur.',
        ),
      ];

  List<Widget> _englishSections() => [
        const _Section(
          title: '1. Information We Collect',
          body:
              'The Sağlam Spot app has no customer account/membership '
              'system; you do not need to log in to browse products. To '
              'improve service quality, the app may collect the following '
              'through Firebase infrastructure: app usage statistics '
              '(Firebase Analytics), crash/error reports (Firebase '
              'Crashlytics), and a device notification token to send '
              'notifications (Firebase Cloud Messaging). This data does not '
              'directly target your identity.',
        ),
        _Section(
          title: '2. WhatsApp and Phone Communication',
          body:
              'When you tap "Message on WhatsApp" or "Call" for a product '
              'you are interested in, we redirect you to your WhatsApp or '
              'phone app; this communication happens directly between you '
              'and ${SaglamSpotCommunication.displayPhone}, and is subject '
              'to your WhatsApp/phone carrier\'s own privacy policies.',
        ),
        const _Section(
          title: '3. We Do Not Collect Payment Information',
          body:
              'No online payment or order completion takes place through '
              'the app; the "cart" feature is only a wish list that lets '
              'you note items you are interested in and ask about them all '
              'at once at the store. Payment data such as credit card or '
              'bank information is never collected or stored.',
        ),
        const _Section(
          title: '4. Location and Other Permissions',
          body:
              'The app does not track your location. We may request device '
              'permissions for certain features (e.g., selecting a product '
              'photo); these permissions only activate while the relevant '
              'feature is being used.',
        ),
        const _Section(
          title: '5. Data Storage and Security',
          body:
              'The limited usage data we collect is stored on Google '
              'Firebase infrastructure with industry-standard security '
              'measures. Your data is not sold to third parties.',
        ),
        const _Section(
          title: '6. Advertising (Google AdMob / AdSense)',
          body:
              'Ads that help keep Sağlam Spot free are shown in the app and '
              'on our website via Google AdMob (mobile app) and Google '
              'AdSense (website). As part of this:\n\n'
              '• Google may process information such as your device\'s '
              'advertising ID, IP address, and general usage data to show '
              'ads that may interest you; this is called "personalized '
              'advertising."\n\n'
              '• We do not directly see or store this data; processing is '
              'subject to Google\'s own privacy policy '
              '(policies.google.com/privacy).\n\n'
              '• You can turn off personalized ads from your device '
              'settings (Android: Settings > Google > Ads; iOS: Settings > '
              'Privacy > Tracking); ads may still be shown, but '
              'non-personalized.\n\n'
              '• Our app is not specifically directed at children under 13; '
              'we do not knowingly collect data from children.\n\n'
              '• Our website may use Google AdSense cookies; you can manage '
              'cookies from your browser settings.',
        ),
        _Section(
          title: '7. Your Rights and Contact',
          body:
              'For privacy-related questions, you can reach us at '
              '${SaglamSpotCommunication.email}.',
        ),
        const _Section(
          title: '8. Changes',
          body:
              'This policy may be updated from time to time; significant '
              'changes will be announced within the app.',
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

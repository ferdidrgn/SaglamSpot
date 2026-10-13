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
        const _LastUpdated(text: 'Son güncelleme: 13 Ekim 2026'),
        _Section(
          title: '1. Veri Sorumlusu',
          body:
              'Bu uygulama ve saglamspotcu.web.app web sitesi, İçerenköy '
              'Mahallesi, Buket Sokak No:6, Ataşehir/İstanbul adresinde '
              'faaliyet gösteren Sağlam Spot tarafından işletilir. Kişisel '
              'verilerinizin işlenmesine ilişkin veri sorumlusu sıfatıyla '
              'bize ${SaglamSpotCommunication.email} adresinden veya '
              '${SaglamSpotCommunication.displayPhone} numarasından '
              'ulaşabilirsiniz.',
        ),
        const _Section(
          title: '2. Topladığımız Bilgiler',
          body:
              'Sağlam Spot uygulamasında müşteri hesabı/üyelik sistemi bulunmaz; '
              'ürünleri görüntülemek için giriş yapmanız gerekmez. Uygulama, '
              'hizmet kalitesini iyileştirmek amacıyla Google Firebase '
              'altyapısı üzerinden şu bilgileri toplayabilir:\n\n'
              '• Firebase Analytics — anonim uygulama kullanım istatistikleri '
              '(hangi ekranların ziyaret edildiği, genel cihaz/bölge bilgisi '
              'gibi).\n\n'
              '• Firebase Crashlytics — çökme ve hata raporları (cihaz '
              'modeli, işletim sistemi sürümü, hatanın oluştuğu kod '
              'noktası); uygulamayı daha kararlı hâle getirmek için '
              'kullanılır.\n\n'
              '• Firebase Cloud Messaging — bildirim gönderebilmemiz için '
              'cihazınıza özgü bir bildirim belirteci (token).\n\n'
              '• Firebase Cloud Firestore — ürün katalog verisi ve (varsa) '
              'favori/sepet listeniz gibi uygulama içi tercihleriniz cihazda '
              'veya bulutta saklanır; bu veriler kimliğinizle '
              'ilişkilendirilmez.\n\n'
              '• Firebase Remote Config ve App Check — uygulamanın hangi '
              'özelliklerin açık/kapalı olacağını belirlemesi ve '
              'isteklerin gerçek uygulamadan geldiğini doğrulaması için '
              'kullanılır; kişisel veri içermez.\n\n'
              '• Uygulama ve web sitesi Firebase Hosting ve Cloud Functions '
              'altyapısında barındırılır; bu hizmetler standart sunucu '
              'günlükleri (IP adresi, erişim zamanı gibi) tutabilir.\n\n'
              'Bu veriler kimliğinizi doğrudan hedeflemez ve üçüncü kişilerle '
              'pazarlama amacıyla paylaşılmaz.',
        ),
        const _Section(
          title: '3. Google Haritalar (Google Maps)',
          body:
              'Mağaza konumumuzu ve yol tarifini göstermek için ana sayfada, '
              'Hakkımızda ve SSS sayfalarında Google Haritalar gömülü '
              'harita (embed) olarak kullanılır. Harita yüklendiğinde '
              'Google, kendi gizlilik politikasına (policies.google.com/privacy) '
              'tabi olarak IP adresiniz gibi teknik verileri işleyebilir; bu '
              'işleme bizim kontrolümüzde değildir.',
        ),
        _Section(
          title: '4. WhatsApp ve Telefon İletişimi',
          body:
              'Bir ürünle ilgilenip "WhatsApp\'tan Yaz" veya "Ara" butonuna '
              'dokunduğunuzda, sizi WhatsApp veya telefon uygulamanıza '
              'yönlendiririz; bu iletişim doğrudan sizinle ${SaglamSpotCommunication.displayPhone} '
              'numarası arasında gerçekleşir ve WhatsApp/telefon '
              'operatörünüzün kendi gizlilik politikalarına tabidir.',
        ),
        const _Section(
          title: '5. Ödeme Bilgisi Toplamayız',
          body:
              'Uygulama üzerinden çevrimiçi ödeme veya sipariş tamamlama '
              'işlemi yapılmaz; "sepet" özelliği yalnızca ilgilendiğiniz '
              'ürünleri not edip mağazaya toplu olarak sormanızı sağlayan bir '
              'istek listesidir. Kredi kartı, banka bilgisi gibi ödeme '
              'verileri hiçbir şekilde toplanmaz veya saklanmaz.',
        ),
        const _Section(
          title: '6. Konum ve Diğer Cihaz İzinleri',
          body:
              'Uygulama konumunuzu arka planda takip etmez. Bazı özellikler '
              '(örn. ürün fotoğrafı ekleme, bildirim gösterme) için '
              'cihazınızdan galeri/kamera veya bildirim izni isteyebiliriz; '
              'bu izinler yalnızca ilgili özellik kullanılırken devreye '
              'girer ve istediğiniz zaman cihaz ayarlarından geri '
              'alabilirsiniz.',
        ),
        const _Section(
          title: '7. Çerezler ve Web Sitesi Analitiği',
          body:
              'saglamspotcu.web.app web sitesi; oturum/tercih bilgilerinizi '
              'hatırlamak, site trafiğini ölçmek (Google Analytics/Firebase '
              'Analytics) ve reklam göstermek (Google AdSense) amacıyla '
              'çerez (cookie) ve benzeri teknolojiler kullanabilir. Tarayıcı '
              'ayarlarınızdan çerezleri silebilir veya engelleyebilirsiniz; '
              'ancak bu durumda sitenin bazı bölümleri beklendiği gibi '
              'çalışmayabilir.',
        ),
        const _Section(
          title: '8. Verilerin Saklanması, Güvenliği ve Saklama Süresi',
          body:
              'Toplanan sınırlı kullanım verileri Google Firebase '
              'altyapısında (sunucular Google\'ın veri merkezlerinde) '
              'endüstri standardı güvenlik önlemleriyle saklanır. '
              'Analytics ve Crashlytics verileri Google\'ın kendi '
              'varsayılan saklama süreleri boyunca (genellikle birkaç ay '
              'ile 14 ay arası) tutulur; bu süre sonunda otomatik olarak '
              'silinir. Verileriniz üçüncü taraflara satılmaz.',
        ),
        const _Section(
          title: '9. Reklamlar (Google AdSense / AdMob)',
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
              'Gizlilik > İzleme) ya da adssettings.google.com '
              'üzerinden kapatabilirsiniz; bu durumda reklamlar '
              'kişiselleştirilmemiş olarak gösterilmeye devam edebilir.\n\n'
              '• Web sitemizde Google AdSense çerez (cookie) ve benzer '
              'tanımlayıcılar kullanabilir; tarayıcı ayarlarınızdan '
              'çerezleri yönetebilirsiniz.',
        ),
        const _Section(
          title: '10. Avrupa Ekonomik Alanı (EEA), İngiltere ve İsviçre',
          body:
              'Avrupa Ekonomik Alanı, Birleşik Krallık veya İsviçre\'den web '
              'sitemizi ziyaret ediyorsanız, Google\'ın reklam ortakları '
              'politikası gereği kişiselleştirilmiş reklam gösterilmeden '
              'önce onayınız alınır; bu onay akışı Google\'ın kendi '
              'reklam/çerez onay mekanizması üzerinden yönetilir. Onay '
              'tercihlerinizi istediğiniz zaman değiştirebilirsiniz.',
        ),
        const _Section(
          title: '11. KVKK Kapsamındaki Haklarınız',
          body:
              '6698 sayılı Kişisel Verilerin Korunması Kanunu (KVKK) '
              'madde 11 uyarınca; kişisel verilerinizin işlenip '
              'işlenmediğini öğrenme, işlenmişse buna ilişkin bilgi talep '
              'etme, işlenme amacını ve amacına uygun kullanılıp '
              'kullanılmadığını öğrenme, yurt içinde/yurt dışında '
              'aktarıldığı üçüncü kişileri bilme, eksik/yanlış işlenmişse '
              'düzeltilmesini isteme, kanuni şartlar çerçevesinde silinmesini '
              'veya yok edilmesini isteme ve bu işlemlerin verilerin '
              'aktarıldığı üçüncü kişilere bildirilmesini isteme hakkına '
              'sahipsiniz. Bu haklarınızı kullanmak için '
              '${SaglamSpotCommunication.email} adresinden bize '
              'ulaşabilirsiniz; talepleriniz en kısa sürede ve her hâlükârda '
              'kanuni süre içinde yanıtlanır.',
        ),
        const _Section(
          title: '12. Çocukların Gizliliği',
          body:
              'Uygulamamız ve web sitemiz 13 yaş altı çocuklara özel olarak '
              'yönlendirilmemiştir; bilerek çocuklardan kişisel veri '
              'toplamayız. Bir çocuğun bize bilmeden veri sağladığını '
              'düşünüyorsanız lütfen bizimle iletişime geçin, ilgili '
              'veriyi sileriz.',
        ),
        _Section(
          title: '13. Haklarınız ve İletişim',
          body:
              'Gizlilikle ilgili sorularınız için bize ${SaglamSpotCommunication.email} '
              'adresinden ulaşabilirsiniz.',
        ),
        const _Section(
          title: '14. Değişiklikler',
          body:
              'Bu politika zaman zaman güncellenebilir; önemli değişiklikler '
              'uygulama içinde duyurulur ve bu sayfanın başındaki '
              '"son güncelleme" tarihi güncellenir.',
        ),
      ];

  List<Widget> _englishSections() => [
        const _LastUpdated(text: 'Last updated: October 13, 2026'),
        _Section(
          title: '1. Data Controller',
          body:
              'This app and the saglamspotcu.web.app website are operated '
              'by Sağlam Spot, based at İçerenköy Mahallesi, Buket Sokak '
              'No:6, Ataşehir/Istanbul, Türkiye. As the data controller for '
              'any personal data processed here, you can reach us at '
              '${SaglamSpotCommunication.email} or '
              '${SaglamSpotCommunication.displayPhone}.',
        ),
        const _Section(
          title: '2. Information We Collect',
          body:
              'The Sağlam Spot app has no customer account/membership '
              'system; you do not need to log in to browse products. To '
              'improve service quality, the app may collect the following '
              'through Google Firebase infrastructure:\n\n'
              '• Firebase Analytics — anonymous app usage statistics '
              '(which screens are visited, general device/region info).\n\n'
              '• Firebase Crashlytics — crash and error reports (device '
              'model, OS version, the code location where the error '
              'occurred); used to make the app more stable.\n\n'
              '• Firebase Cloud Messaging — a device-specific notification '
              'token so we can send you push notifications.\n\n'
              '• Firebase Cloud Firestore — the product catalog and (where '
              'applicable) your in-app preferences such as favorites/cart; '
              'this data is not linked to your identity.\n\n'
              '• Firebase Remote Config and App Check — used to control '
              'which features are enabled and to verify that requests come '
              'from the genuine app; neither contains personal data.\n\n'
              '• The app and website are hosted on Firebase Hosting and '
              'Cloud Functions, which may keep standard server logs (such '
              'as IP address and access time).\n\n'
              'This data does not directly target your identity and is not '
              'shared with third parties for marketing purposes.',
        ),
        const _Section(
          title: '3. Google Maps',
          body:
              'We embed Google Maps on the home, About, and FAQ pages to '
              'show our store location and directions. When the map loads, '
              'Google may process technical data such as your IP address, '
              'subject to its own privacy policy '
              '(policies.google.com/privacy); this processing is outside '
              'our control.',
        ),
        _Section(
          title: '4. WhatsApp and Phone Communication',
          body:
              'When you tap "Message on WhatsApp" or "Call" for a product '
              'you are interested in, we redirect you to your WhatsApp or '
              'phone app; this communication happens directly between you '
              'and ${SaglamSpotCommunication.displayPhone}, and is subject '
              'to your WhatsApp/phone carrier\'s own privacy policies.',
        ),
        const _Section(
          title: '5. We Do Not Collect Payment Information',
          body:
              'No online payment or order completion takes place through '
              'the app; the "cart" feature is only a wish list that lets '
              'you note items you are interested in and ask about them all '
              'at once at the store. Payment data such as credit card or '
              'bank information is never collected or stored.',
        ),
        const _Section(
          title: '6. Location and Other Device Permissions',
          body:
              'The app does not track your location in the background. We '
              'may request device permissions for certain features (e.g., '
              'gallery/camera access to add a product photo, or '
              'notifications); these permissions only activate while the '
              'relevant feature is being used, and you can revoke them at '
              'any time from your device settings.',
        ),
        const _Section(
          title: '7. Cookies and Website Analytics',
          body:
              'The saglamspotcu.web.app website may use cookies and similar '
              'technologies to remember your session/preferences, measure '
              'site traffic (Google Analytics/Firebase Analytics), and '
              'serve ads (Google AdSense). You can delete or block cookies '
              'from your browser settings, though some parts of the site '
              'may not work as expected if you do.',
        ),
        const _Section(
          title: '8. Data Storage, Security, and Retention',
          body:
              'The limited usage data we collect is stored on Google '
              'Firebase infrastructure (servers in Google\'s data centers) '
              'with industry-standard security measures. Analytics and '
              'Crashlytics data is kept for Google\'s own default retention '
              'periods (typically a few months up to 14 months) and is '
              'automatically deleted afterward. Your data is not sold to '
              'third parties.',
        ),
        const _Section(
          title: '9. Advertising (Google AdSense / AdMob)',
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
              'Privacy > Tracking) or at adssettings.google.com; ads may '
              'still be shown, but non-personalized.\n\n'
              '• Our website may use Google AdSense cookies and similar '
              'identifiers; you can manage cookies from your browser '
              'settings.',
        ),
        const _Section(
          title: '10. EEA, UK, and Switzerland',
          body:
              'If you visit our website from the European Economic Area, '
              'the United Kingdom, or Switzerland, Google\'s advertising '
              'partner policies require your consent before personalized '
              'ads are shown; this consent flow is managed through Google\'s '
              'own advertising/cookie consent mechanism. You can change '
              'your consent choices at any time.',
        ),
        const _Section(
          title: '11. Your Rights (Turkish Data Protection Law – KVKK)',
          body:
              'Under Article 11 of Turkish Law No. 6698 on the Protection '
              'of Personal Data (KVKK), you have the right to learn whether '
              'your personal data is being processed, request information '
              'about it, learn the purpose of processing and whether it is '
              'used accordingly, know the third parties to whom it is '
              'transferred domestically or abroad, request correction of '
              'incomplete/inaccurate data, request its deletion or '
              'destruction within the legal framework, and request that '
              'such actions be notified to third parties the data was '
              'transferred to. You can exercise these rights by contacting '
              'us at ${SaglamSpotCommunication.email}; requests are '
              'answered as soon as possible and in any case within the '
              'legal time limit.',
        ),
        const _Section(
          title: '12. Children\'s Privacy',
          body:
              'Our app and website are not specifically directed at '
              'children under 13; we do not knowingly collect personal '
              'data from children. If you believe a child has provided us '
              'with data without your knowledge, please contact us and we '
              'will delete it.',
        ),
        _Section(
          title: '13. Your Rights and Contact',
          body:
              'For privacy-related questions, you can reach us at '
              '${SaglamSpotCommunication.email}.',
        ),
        const _Section(
          title: '14. Changes',
          body:
              'This policy may be updated from time to time; significant '
              'changes will be announced within the app and the '
              '"last updated" date at the top of this page will be revised.',
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

class _LastUpdated extends StatelessWidget {
  final String text;

  const _LastUpdated({required this.text});

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.mobileTextTertiary,
          ),
        ),
      );
}

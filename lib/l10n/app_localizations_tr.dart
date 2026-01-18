// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get brand => 'SAĞLAM SPOT';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get searchHint => 'Ürün, kategori arayın...';

  @override
  String get collection => 'KOLEKSİYON';

  @override
  String get eleganceAndComfort => 'Zarafet & Konfor';

  @override
  String productsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ürün Bulundu',
      one: '1 Ürün Bulundu',
      zero: 'Ürün bulunamadı',
    );
    return '$_temp0';
  }

  @override
  String resultsFor(String query) {
    return '\"$query\" için sonuçlar';
  }

  @override
  String get category => 'Kategori';

  @override
  String get categorySofa => 'Oturma Grupları';

  @override
  String get categoryChair => 'Sandalye';

  @override
  String get categoryTable => 'Yemek Odası';

  @override
  String get categoryBed => 'Yatak Odası';

  @override
  String get categoryWardrobe => 'Gardırop';

  @override
  String get categoryWhite => 'Beyaz Eşya';

  @override
  String get categoryOther => 'Diğer';

  @override
  String get condition => 'Durum';

  @override
  String get conditionAll => 'Tümü';

  @override
  String get conditionNew => 'Sıfır';

  @override
  String get conditionUsed => 'İkinci El';

  @override
  String get priceRange => 'Fiyat Aralığı';

  @override
  String get clear => 'Temizle';

  @override
  String get filter => 'Filtrele';

  @override
  String get apply => 'Uygula';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get newSeason => 'YENİ SEZON';

  @override
  String get heroTitle => 'Minimalist\nKonforun Zirvesi';

  @override
  String get viewCollection => 'KOLEKSİYONU GÖR';

  @override
  String get featureArtisan => 'Samimi Esnaflık';

  @override
  String get featureDelivery => 'Güvenli Teslimat';

  @override
  String get featureService => 'Güler Yüzlü Hizmet';

  @override
  String get featureShipping => 'Hızlı Nakliye';

  @override
  String get newCollection => 'Yeni Koleksiyon';

  @override
  String get newCollectionSub => 'En yeni ürünler';

  @override
  String get spotProducts => 'Spot Ürünler';

  @override
  String get spotProductsSub => 'Fırsat Ürünleri';

  @override
  String get spotProductsDesc => 'Kaliteli ürünlerde inanılmaz fiyatlar';

  @override
  String get currentCollection => 'MEVCUT KOLEKSİYON';

  @override
  String get soldProducts => 'SATILMIŞ ÜRÜNLER';

  @override
  String pieces(int count) {
    return '$count Parça';
  }

  @override
  String get inStock => 'STOKTA';

  @override
  String get sold => 'SATILDI';

  @override
  String get byRoom => 'Yaşam Alanına Göre';

  @override
  String get byRoomSub => 'Evinizin her köşesi için özel seçimler';

  @override
  String get roomLivingRoom => 'Salon';

  @override
  String get roomLivingRoomSub => 'Konforun Merkezi';

  @override
  String get roomBedroom => 'Yatak';

  @override
  String get roomBedroomSub => 'Huzurlu Uykular';

  @override
  String get roomKitchen => 'Mutfak';

  @override
  String get roomKitchenSub => 'Pratik Çözümler';

  @override
  String get roomOffice => 'Ofis';

  @override
  String get roomOfficeSub => 'Verimli Çalışma';

  @override
  String get whoWeAre => 'BİZ KİMİZ?';

  @override
  String get artisanTitle => '20 Yıllık Samimi Esnaflık,\nModern Hizmet.';

  @override
  String get artisanDesc =>
      'Mağazamıza gelin, bir çayımızı için; size en uygun mobilyayı birlikte seçelim.';

  @override
  String get visitUsButton => 'BİZİ ZİYARET EDİN';

  @override
  String get statHappyCustomer => 'Mutlu Müşteri';

  @override
  String get statExperience => 'Tecrübe';

  @override
  String get statDelivery => 'Teslimat';

  @override
  String get statTrust => 'Güven';

  @override
  String get explore => 'KEŞFET';

  @override
  String get collections => 'Koleksiyonlar';

  @override
  String get corporate => 'KURUMSAL';

  @override
  String get aboutUs => 'Hakkımızda';

  @override
  String get contact => 'İletişim';

  @override
  String get contactUs => 'BİZE ULAŞIN';

  @override
  String get sss => 'SSS';

  @override
  String get footerDesc =>
      '20 yılı aşkın tecrübemizle İstanbul\'un her noktasına kaliteyi ve güveni taşıyoruz.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT TİCARET. TÜM HAKLARI SAKLIDIR.';

  @override
  String get ourStoryTitle => 'Biz Kimiz? (Hikayemiz)';

  @override
  String get ourStoryDesc1 =>
      'Amacımız, evinize sıcaklık katacak, kaliteli ve içinize sinen mobilyaları bulmanıza yardımcı olmak. Yaşam alanlarınızı güzelleştirmek bizim işimiz.';

  @override
  String get ourStoryDesc2 =>
      'Her şey 2012\'de, İçerenköy\'deki bu dükkanda başladı. O günden beri konuk olduğumuz ev sayısı daha da arttı.';

  @override
  String get ourStoryDesc3 =>
      'Bugün, hem sıfır hem de özenle seçtiğimiz ikinci el ürünlerimizle, binlerce komşumuzun evine konuk olduk. Sizin güveninizle büyüyoruz.';

  @override
  String get storyHighlightStart => 'Başlangıç';

  @override
  String get storyHighlightExperience => 'Yıllık Tecrübe';

  @override
  String get storyHighlightSmiles => 'Gülen Yüz';

  @override
  String get ourPrinciples => 'İlkelerimiz';

  @override
  String get principlesSub => 'Esnaflıktan ödün vermediğimiz prensiplerimiz';

  @override
  String get valueQualityTitle => 'Kalite ve Titizlik';

  @override
  String get valueQualityDesc =>
      'İster sıfır ister ikinci el olsun titizlikle seçer, size öyle sunarız.';

  @override
  String get valueSmileTitle => 'Gülen Yüz';

  @override
  String get valueSmileDesc =>
      'Bizim için en büyük kazanç, dükkandan mutlu ayrılan bir komşumuzdur.';

  @override
  String get valueLaborTitle => 'Emeğe Saygı';

  @override
  String get valueLaborDesc =>
      'İkinci el ürünlere yeniden hayat vererek hem bütçenizi hem de doğayı koruruz.';

  @override
  String get valueTrustTitle => 'Dürüstlük ve Güven';

  @override
  String get valueTrustDesc =>
      'Şeffaf ve dürüst esnaflık en büyük değerimizdir. Yıllardır aynı konumdayız.';

  @override
  String get masterHistoryTitle => 'Ustamızı Tanıyın';

  @override
  String get masterHistoryDesc =>
      'Ustamız, 1995\'ten beri bu işin içinde. Sektörün tozunu yutmuş, İstikbal gibi markalarda mobilyanın püf noktalarını öğrenmiştir. Sürücülükten montaja her alanda kazanılan tecrübeyi 2012\'de Sağlam Spot\'a taşımıştır. Amacı, kurumsal kaliteyi esnaf samimiyetiyle birleştirmektir.';

  @override
  String get deliveryServiceTitle => 'Nakliye ve Montaj Hizmetimiz';

  @override
  String get freeShipping => 'Ücretsiz Nakliye ve Montaj';

  @override
  String get deliveryServiceSub => 'Ücretsiz Hizmet Bölgelerimiz:';

  @override
  String get deliveryRegions =>
      '• İçerenköy Mahallemiz\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• İnönü ve Bostancı Sanayi';

  @override
  String get deliveryWarning =>
      'Önemli Not: Ustamızın sağlığını korumak için, asansör olmayan binalarda yüksek katlara hizmet veremiyoruz.';

  @override
  String get deliveryOnTime => '⏰ Sizinle sözleştiğimiz saatte kapınızdayız!';

  @override
  String get transportationTitle => 'Dükkanımıza Nasıl Gelirsiniz?';

  @override
  String get busArrival => 'Otobüsle Gelirseniz:';

  @override
  String get busStopZiyapasa => 'Ziyapaşa Durağı (Kadıköy Yönü):';

  @override
  String get busStopIcerenkoyKayisdagi => 'İçerenköy Durağı (Kayışdağı Yönü):';

  @override
  String get busStopIcerenkoyYeniyol => 'İçerenköy Durağı (Yeniyol):';

  @override
  String get callNow => 'Hemen Ara';

  @override
  String get seeOnMap => 'Haritada Gör';

  @override
  String get phoneQuickSolution => 'Telefon (Hızlı Çözüm)';

  @override
  String get addressTeaInvitation => 'Adres (Çaya Bekleriz)';

  @override
  String get workingHours => 'Çalışma Saatlerimiz';

  @override
  String get workingDays => 'Pzt-Cmt: 09:00 - 22:00\nPazar: 10:00 - 20:00';

  @override
  String get shopLocationTitle => 'Dükkanımız Tam Burada';

  @override
  String get getDirectionsDesc => 'Yol tarifi almak için haritaya dokunun';

  @override
  String get similarProducts => 'BENZER ÜRÜNLER';

  @override
  String get customerReviews => 'MÜŞTERİ GÖRÜŞLERİ';

  @override
  String get viewAll => 'Tümünü Gör';

  @override
  String get features => 'ÖZELLİKLER';

  @override
  String get description => 'AÇIKLAMA';

  @override
  String get detailsTab => 'DETAYLAR';

  @override
  String get shippingTab => 'TESLİMAT';

  @override
  String get reviewsTab => 'DEĞERLENDİRMELER';

  @override
  String get readMore => 'DEVAMINI OKU';

  @override
  String get showLess => 'DAHA AZ GÖSTER';

  @override
  String get buyNow => 'ŞİMDİ SATIN AL';

  @override
  String get addToCart => 'SEPETE EKLE';

  @override
  String get sendMessage => 'MESAJ GÖNDER';

  @override
  String get guaranteeNone => 'Garantimiz Yoktur';

  @override
  String get assemblyFree => 'Ücretsiz Montaj';

  @override
  String get returnNone => 'İade Yoktur';

  @override
  String get supportFull => '16/6 Destek';

  @override
  String get confirmedSeller => 'Onaylı Satıcı';

  @override
  String get productName => 'Ürün Adı';

  @override
  String get price => 'Fiyat';

  @override
  String get addProduct => 'Ürün Ekle';

  @override
  String get editProduct => 'Ürünü Düzenle';

  @override
  String get saveChanges => 'Değişiklikleri Kaydet';

  @override
  String get productImages => 'Ürün Görselleri';

  @override
  String get generalInfo => 'Genel Bilgiler';

  @override
  String get statusAndCategory => 'Durum ve Kategori';

  @override
  String get isSold => 'Ürün Satıldı';

  @override
  String get isSpot => 'Spot / İkinci El';

  @override
  String get deleteProduct => 'Ürünü Sil';

  @override
  String get deleteConfirm => 'Bu ürün silinecek. Emin misiniz?';

  @override
  String get yesDelete => 'Evet, Sil';

  @override
  String get productNotFound => 'Ürün bulunamadı';

  @override
  String get errorOccurred => 'Bir hata oluştu';

  @override
  String get noImages => 'Görsel Yok';

  @override
  String get furnitureTipsTitle => 'Uzmanından Püf Noktaları';

  @override
  String get tipBalanceTitle => 'Terazi Kontrolü Yapın';

  @override
  String get tipBalanceDesc =>
      'Mobilyanızın ayaklarının zemine tam bastığından emin olun. Eğimli zeminlerde keçe kullanın.';

  @override
  String get tipWallGapTitle => 'Duvarla Mesafe Bırakın';

  @override
  String get tipWallGapDesc =>
      'Hava sirkülasyonu için 1-2 cm boşluk bırakın. Rutubeti engeller.';

  @override
  String get tipHeatTitle => 'Isıdan Uzak Tutun';

  @override
  String get tipHeatDesc =>
      'Soba ve kaloriferden 30 cm uzak tutun. Ahşap çatlamasını önler.';

  @override
  String get tipSunTitle => 'Güneşten Koruyun';

  @override
  String get tipSunDesc =>
      'Direkt güneş ışığı renk soldurur. Perdelerle filtreleyin.';

  @override
  String get tipCleaningTitle => 'Nemli Temizlik';

  @override
  String get sessionClosed => 'Oturum kapalı';

  @override
  String get authDeniedAdminOnly =>
      'Yetki Reddedildi: Bu e-posta yönetici listesinde bulunamadı.';

  @override
  String get fillRequiredFields =>
      'Lütfen ürün adı, fiyat ve en az bir görsel ekleyin!';

  @override
  String get productAddedSuccess => 'Ürün başarıyla eklendi';

  @override
  String get authOrConnectionError => 'Yetki veya bağlantı hatası oluştu';

  @override
  String get accountDisabled => 'Bu kullanıcı hesabı devre dışı bırakılmış.';

  @override
  String get adminNotFound => 'Bu e-posta ile kayıtlı yönetici bulunamadı.';

  @override
  String get wrongPassword => 'Şifre hatalı, lütfen kontrol edin.';

  @override
  String get invalidEmailOrPassword => 'E-posta veya şifre hatalı.';

  @override
  String get tooManyAttempts =>
      'Çok fazla deneme yaptınız. Lütfen sonra tekrar deneyin.';

  @override
  String get loginFailed => 'Giriş başarısız';

  @override
  String get adminPanel => 'Yönetici Paneli';

  @override
  String get adminLogin => 'Yönetici Paneli Girişi';

  @override
  String get quickOptions => 'Hızlı Seçenekler';

  @override
  String get addImages => 'Görsel Ekle';

  @override
  String get changeImages => 'Görselleri Değiştir';

  @override
  String get noImagesFound => 'Görsel yok';

  @override
  String get tipCleaningDesc =>
      'Hafif nemli bezle silip kurulayın. Islak bez ahşabı şişirir.';
}

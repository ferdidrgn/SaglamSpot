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
  String get searchHint => 'Eviniz için ne aramıştınız?...';

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
  String get seoHomeTitle => 'Sağlam Spot | Spot & Sıfır Mobilya';

  @override
  String get seoHomeDesc =>
      'Spot ve sıfır mobilyalarda en uygun fiyatlar. 20 yıllık esnaf güvencesiyle.';

  @override
  String get seoNewTitle => 'Sıfır Ürünler | Sağlam Spot';

  @override
  String get seoNewDesc => 'Garantili ve kaliteli sıfır mobilya koleksiyonu.';

  @override
  String get seoSpotTitle => 'Spot Ürünler | Sağlam Spot';

  @override
  String get seoSpotDesc => 'Ekonomik ve kaliteli spot mobilya seçenekleri.';

  @override
  String get seoAboutTitle => 'Hakkımızda | Sağlam Spot';

  @override
  String get seoAboutDesc =>
      '20 yıllık tecrübemizle mobilya sektöründe güvenin adresi.';

  @override
  String get seoProductDetailSuffix => 'Ürünü İncele | Sağlam Spot';

  @override
  String get category => 'Kategori';

  @override
  String get categorySofa => 'Oturma Grupları';

  @override
  String get categoryChair => 'Sandalye';

  @override
  String get categoryTable => 'Masa';

  @override
  String get categoryBed => 'Yatak Odası';

  @override
  String get categoryWardrobe => 'Dolap';

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
  String get price => 'Fiyat';

  @override
  String get save => 'Kaydet';

  @override
  String get explanation => 'Açıklama';

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
  String get quickOptions => 'Hızlı Seçenekler';

  @override
  String get easyFind => 'Aradığınız ürünü kolayca bulun';

  @override
  String get mottoBrand => 'Eskiyi Yeniler, Yeniyi Değerlendirir';

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
  String get stock => 'STOKTA';

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
  String get qualityFurniture => '\'Kaliteli mobilyanın adresi Sağlam Spot\'';

  @override
  String get footerDesc =>
      '20 yılı aşkın tecrübemizle İstanbul\'un her noktasına kaliteyi ve güveni taşıyoruz.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT TİCARET. TÜM HAKLARI SAKLIDIR.';

  @override
  String get errorOccurred => 'Bir hata oluştu';

  @override
  String get productNotFound => 'Ürün bulunamadı';

  @override
  String get noImages => 'Görsel Yok';

  @override
  String get error_check_connection => 'İnternet bağlantınızı kontrol edin.';

  @override
  String get error_server_no_response => 'Sunucu şu an yanıt vermiyor.';

  @override
  String get error_connection => 'Bağlantı hatası';

  @override
  String get error_connection_lost => 'Bağlantı Kesildi';

  @override
  String get status_waiting_connection => 'Bağlantı bekleniyor...';

  @override
  String get error_no_internet_auto_retry =>
      'İnternet bağlantınız yok.\nBağlantı sağlandığında otomatik olarak devam edeceksiniz.';

  @override
  String get goBack => 'Geri Dön';

  @override
  String get galleryEmpty => 'Galeri boş';

  @override
  String get month_1 => 'Ocak';

  @override
  String get month_2 => 'Şubat';

  @override
  String get month_3 => 'Mart';

  @override
  String get month_4 => 'Nisan';

  @override
  String get month_5 => 'Mayıs';

  @override
  String get month_6 => 'Haziran';

  @override
  String get month_7 => 'Temmuz';

  @override
  String get month_8 => 'Ağustos';

  @override
  String get month_9 => 'Eylül';

  @override
  String get month_10 => 'Ekim';

  @override
  String get month_11 => 'Kasım';

  @override
  String get month_12 => 'Aralık';

  @override
  String get noProductFoundTitle => 'Aradığınız Kriterde Ürün Bulunamadı';

  @override
  String get noProductFoundDescription =>
      'Farklı filtreler deneyebilir veya arama teriminizi değiştirebilirsiniz';

  @override
  String get adminPanelTitle => 'Yönetici Paneli';

  @override
  String get totalCount => 'Toplam';

  @override
  String get productAddedSuccess => 'Ürün başarıyla eklendi';

  @override
  String get authOrConnectionError => 'Yetki veya bağlantı hatası oluştu';

  @override
  String get fillRequiredFields =>
      'Lütfen ürün adı, fiyat ve en az bir görsel ekleyin!';

  @override
  String get sessionClosed => 'Oturum kapalı';

  @override
  String get addNewProduct => 'Yeni Ürün Ekle';

  @override
  String get productImages => 'Ürün Görselleri';

  @override
  String get generalInfo => 'Genel Bilgiler';

  @override
  String get productNameLabel => 'Ürün Adı';

  @override
  String get descriptionLabel => 'Açıklama';

  @override
  String get statusLabel => 'Durum';

  @override
  String get spotSecondHand => 'Spot / İkinci El';

  @override
  String get secondHandHint => 'Tek parça — renk seçeneği gösterilmeyecek';

  @override
  String get newProductHint => 'Sıfır ürün — renk seçeneği ekleyebilirsin';

  @override
  String get colorOptionsOptional => 'Renk Seçenekleri (opsiyonel)';

  @override
  String get noImagesYet => 'Henüz görsel eklenmedi';

  @override
  String get addImage => 'Görsel Ekle';

  @override
  String get editProductTitle => 'Ürünü Düzenle';

  @override
  String get changeImages => 'Görselleri Değiştir';

  @override
  String get saveChanges => 'Değişiklikleri Kaydet';

  @override
  String get deleteProductTitle => 'Ürünü Sil';

  @override
  String get deleteProductConfirmSuffix => 'silinecek. Emin misiniz?';

  @override
  String get yesDelete => 'Evet, Sil';

  @override
  String get emptyCategoryProducts => 'Bu kategoride ürün bulunamadı';

  @override
  String get adminLoginSubtitle => 'Yönetici Paneline Giriş';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get loginButton => 'Giriş Yap';

  @override
  String get sponsored => 'Sponsorlu';

  @override
  String get addProductFab => 'Ürün Ekle';

  @override
  String get singlePieceNotice =>
      'Bu, ikinci el / spot bir üründür — stokta tek parça vardır, renk ve görsel tamamen fotoğraflardaki gibidir.';

  @override
  String get colorOptionsTitle => 'Renk Seçenekleri';

  @override
  String get newProductBadge => 'SIFIR ÜRÜN';

  @override
  String get usedProductBadge => 'İKİNCİ EL';

  @override
  String get readMore => 'Devamını oku';

  @override
  String get readLess => 'Daha az göster';

  @override
  String get specDelivery => 'Teslimat';

  @override
  String get specDeliveryValue => '1-2 Gün İçinde';

  @override
  String get specLocation => 'Konum';

  @override
  String get sellerTrustLine => '20 yıllık esnaf güvencesi · İçerenköy';

  @override
  String get whatsappCta => 'WhatsApp\'tan Yaz';

  @override
  String get callCta => 'Ara';

  @override
  String get similarProducts => 'Benzer Ürünler';

  @override
  String get conditionShowcase => 'Vitrin';

  @override
  String get productDescriptionTitle => 'Açıklama';

  @override
  String get loginBrand => 'Sağlam Spot';

  @override
  String get logout => 'Oturumu Kapat';

  @override
  String get logoutConfirm =>
      'Hesabınızdan güvenli bir şekilde çıkış yapmak istediğinize emin misiniz?';
}

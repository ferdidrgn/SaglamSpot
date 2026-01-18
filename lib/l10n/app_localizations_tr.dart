// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get searchHint => 'Ürün, kategori veya stil arayın...';

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
  String get priceRange => 'Fiyat Aralığı';

  @override
  String get clear => 'Temizle';

  @override
  String get filter => 'Filtrele';

  @override
  String get currentCollection => 'MEVCUT KOLEKSİYON';

  @override
  String get soldProducts => 'SATILMIŞ ÜRÜNLER';

  @override
  String pieces(int count) {
    return '$count Parça';
  }

  @override
  String get conditionAll => 'Tümü';

  @override
  String get conditionNew => 'Sıfır';

  @override
  String get conditionUsed => 'İkinci El';

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
  String get visitUs => 'BİZİ ZİYARET EDİN';

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
  String get corporate => 'KURUMSAL';

  @override
  String get contactUs => 'BİZE ULAŞIN';

  @override
  String get footerDesc =>
      '20 yılı aşkın tecrübemizle İstanbul\'un her noktasına kaliteyi ve güveni taşıyoruz.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT TİCARET. TÜM HAKLARI SAKLIDIR.';
}

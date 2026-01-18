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
}

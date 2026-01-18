// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get searchHint => 'Search for products, styles...';

  @override
  String get collection => 'COLLECTION';

  @override
  String get eleganceAndComfort => 'Elegance & Comfort';

  @override
  String productsFound(int count) {
    return '$count Products Found';
  }
}

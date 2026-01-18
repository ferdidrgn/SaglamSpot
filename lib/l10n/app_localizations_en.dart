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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Products Found',
      one: '1 Product Found',
      zero: 'No products found',
    );
    return '$_temp0';
  }

  @override
  String resultsFor(String query) {
    return 'Results for \"$query\"';
  }

  @override
  String get category => 'Category';

  @override
  String get categorySofa => 'Sofa Sets';

  @override
  String get categoryChair => 'Chairs';

  @override
  String get categoryTable => 'Dining Room';

  @override
  String get categoryBed => 'Bedroom';

  @override
  String get categoryWardrobe => 'Wardrobe';

  @override
  String get categoryWhite => 'White Goods';

  @override
  String get categoryOther => 'Other';

  @override
  String get condition => 'Condition';

  @override
  String get priceRange => 'Price Range';

  @override
  String get clear => 'Clear';

  @override
  String get filter => 'Filter';

  @override
  String get currentCollection => 'CURRENT COLLECTION';

  @override
  String get soldProducts => 'SOLD PRODUCTS';

  @override
  String pieces(int count) {
    return '$count Pieces';
  }
}

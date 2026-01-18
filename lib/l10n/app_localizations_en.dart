// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get brand => 'Sağlam Spot';

  @override
  String get home => 'Home';

  @override
  String get searchHint => 'Search for products, categories...';

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

  @override
  String get conditionAll => 'All';

  @override
  String get conditionNew => 'New';

  @override
  String get conditionUsed => 'Used';

  @override
  String get newSeason => 'NEW SEASON';

  @override
  String get heroTitle => 'The Peak of\nMinimalist Comfort';

  @override
  String get viewCollection => 'VIEW COLLECTION';

  @override
  String get featureArtisan => 'Friendly Artisan';

  @override
  String get featureDelivery => 'Secure Delivery';

  @override
  String get featureService => 'Friendly Service';

  @override
  String get featureShipping => 'Fast Shipping';

  @override
  String get newCollection => 'New Collection';

  @override
  String get newCollectionSub => 'Our latest products';

  @override
  String get byRoom => 'By Living Space';

  @override
  String get byRoomSub => 'Special selections for every corner of your home';

  @override
  String get roomLivingRoom => 'Living Room';

  @override
  String get roomLivingRoomSub => 'Center of Comfort';

  @override
  String get roomBedroom => 'Bedroom';

  @override
  String get roomBedroomSub => 'Peaceful Sleep';

  @override
  String get roomKitchen => 'Kitchen';

  @override
  String get roomKitchenSub => 'Practical Solutions';

  @override
  String get roomOffice => 'Office';

  @override
  String get roomOfficeSub => 'Productive Work';

  @override
  String get whoWeAre => 'WHO ARE WE?';

  @override
  String get artisanTitle => '20 Years of Friendly Trade,\nModern Service.';

  @override
  String get artisanDesc =>
      'Come to our store, have a tea with us; let\'s choose the most suitable furniture together.';

  @override
  String get visitUs => 'VISIT US';

  @override
  String get statHappyCustomer => 'Happy Customers';

  @override
  String get statExperience => 'Experience';

  @override
  String get statDelivery => 'Deliveries';

  @override
  String get statTrust => 'Trust';

  @override
  String get explore => 'EXPLORE';

  @override
  String get corporate => 'CORPORATE';

  @override
  String get contactUs => 'CONTACT US';

  @override
  String get footerDesc =>
      'With over 20 years of experience, we bring quality and trust to every point in Istanbul.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT TRADE. ALL RIGHTS RESERVED.';

  @override
  String get qualityFurniture => '\'Kaliteli mobilyanın adresi Sağlam Spot\'';

  @override
  String get collections => 'Collections';

  @override
  String get spotProducts => 'Spot Products';

  @override
  String get aboutUs => 'About Us';

  @override
  String get sss => 'SSS';

  @override
  String get contact => 'Communication';
}

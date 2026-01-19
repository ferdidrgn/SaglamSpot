// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get brand => 'SAGLAM SPOT';

  @override
  String get home => 'Home';

  @override
  String get searchHint => 'What were you looking for your home?...';

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
  String get categoryChair => 'Chair';

  @override
  String get categoryTable => 'Table';

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
  String get conditionAll => 'All';

  @override
  String get conditionNew => 'New';

  @override
  String get conditionUsed => 'Used';

  @override
  String get priceRange => 'Price Range';

  @override
  String get clear => 'Clear';

  @override
  String get filter => 'Filter';

  @override
  String get apply => 'Apply';

  @override
  String get cancel => 'Cancel';

  @override
  String get newSeason => 'NEW SEASON';

  @override
  String get heroTitle => 'The Peak of\nMinimalist Comfort';

  @override
  String get viewCollection => 'VIEW COLLECTION';

  @override
  String get featureArtisan => 'Friendly Craftsmanship';

  @override
  String get featureDelivery => 'Secure Delivery';

  @override
  String get featureService => 'Friendly Service';

  @override
  String get featureShipping => 'Fast Shipping';

  @override
  String get newCollection => 'New Collection';

  @override
  String get newCollectionSub => 'Latest products';

  @override
  String get spotProducts => 'Spot Products';

  @override
  String get spotProductsSub => 'Special Deals';

  @override
  String get spotProductsDesc => 'Unbelievable prices on quality products';

  @override
  String get currentCollection => 'CURRENT COLLECTION';

  @override
  String get soldProducts => 'SOLD PRODUCTS';

  @override
  String pieces(int count) {
    return '$count Pieces';
  }

  @override
  String get inStock => 'IN STOCK';

  @override
  String get sold => 'SOLD';

  @override
  String get byRoom => 'By Living Area';

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
  String get roomOfficeSub => 'Efficient Work';

  @override
  String get whoWeAre => 'WHO ARE WE?';

  @override
  String get artisanTitle =>
      '20 Years of Friendly Craftsmanship,\nModern Service.';

  @override
  String get artisanDesc =>
      'Visit our store, have a tea with us; let\'s choose the best furniture for you together.';

  @override
  String get visitUsButton => 'VISIT US';

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
  String get collections => 'Collections';

  @override
  String get corporate => 'CORPORATE';

  @override
  String get aboutUs => 'About Us';

  @override
  String get contact => 'Contact';

  @override
  String get contactUs => 'CONTACT US';

  @override
  String get sss => 'FAQ';

  @override
  String get qualityFurniture =>
      '\"The address of quality furniture is Saglam Spot\"';

  @override
  String get footerDesc =>
      'With over 20 years of experience, we bring quality and trust to every corner of Istanbul.';

  @override
  String get allRightsReserved =>
      '© 2026 SAGLAM SPOT TRADE. ALL RIGHTS RESERVED.';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get noImages => 'No Images';

  @override
  String get error_check_connection => 'Please check your internet connection.';

  @override
  String get error_server_no_response =>
      'The server is currently not responding.';

  @override
  String get error_critical => 'A critical error occurred.';

  @override
  String get error_connection => 'Connection error';

  @override
  String get error_connection_lost => 'Connection Lost';

  @override
  String get status_waiting_connection => 'Waiting for connection...';

  @override
  String get error_no_internet_auto_retry =>
      'No internet connection.\nThe app will continue automatically once the connection is restored.';

  @override
  String get goBack => 'Go Back';

  @override
  String get galleryEmpty => 'Gallery is empty';

  @override
  String get month_1 => 'January';

  @override
  String get month_2 => 'February';

  @override
  String get month_3 => 'March';

  @override
  String get month_4 => 'April';

  @override
  String get month_5 => 'May';

  @override
  String get month_6 => 'June';

  @override
  String get month_7 => 'July';

  @override
  String get month_8 => 'August';

  @override
  String get month_9 => 'September';

  @override
  String get month_10 => 'October';

  @override
  String get month_11 => 'November';

  @override
  String get month_12 => 'December';
}

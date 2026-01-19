// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get brand => 'SAĞLAM SPOT';

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
  String get categorySofa => 'Living Room Groups';

  @override
  String get categoryChair => 'Chairs';

  @override
  String get categoryTable => 'Dining Room';

  @override
  String get categoryBed => 'Bedroom';

  @override
  String get categoryWardrobe => 'Wardrobes';

  @override
  String get categoryWhite => 'Home Appliances';

  @override
  String get categoryOther => 'Other';

  @override
  String get condition => 'Condition';

  @override
  String get conditionAll => 'All';

  @override
  String get conditionNew => 'Brand New';

  @override
  String get conditionUsed => 'Second Hand';

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
  String get spotProducts => 'Spot Products';

  @override
  String get spotProductsSub => 'Deal Products';

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
  String get byRoom => 'By Living Space';

  @override
  String get byRoomSub => 'Special selections for every corner of your home';

  @override
  String get roomLivingRoom => 'Living Room';

  @override
  String get roomLivingRoomSub => 'The Center of Comfort';

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
  String get sss => 'SSS';

  @override
  String get qualityFurniture => '\'Kaliteli mobilyanın adresi Sağlam Spot\'';

  @override
  String get footerDesc =>
      'With over 20 years of experience, we bring quality and trust to every corner of Istanbul.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT TRADE. ALL RIGHTS RESERVED.';

  @override
  String get ourStoryTitle => 'Who Are We? (Our Story)';

  @override
  String get ourStoryDesc1 =>
      'Our goal is to help you find quality furniture that adds warmth to your home and suits your taste. Beautifying your living spaces is our business.';

  @override
  String get ourStoryDesc2 =>
      'It all started in 2012 in this shop in Icerenkoy. Since then, the number of homes we have been guests in has grown steadily.';

  @override
  String get ourStoryDesc3 =>
      'Today, we have been guests in thousands of our neighbors\' homes with both our brand new and carefully selected second-hand products. We grow with your trust.';

  @override
  String get storyHighlightStart => 'Start';

  @override
  String get storyHighlightExperience => 'Years Experience';

  @override
  String get storyHighlightSmiles => 'Smiling Faces';

  @override
  String get ourPrinciples => 'Our Principles';

  @override
  String get principlesSub =>
      'Our principles that we do not compromise from artisan trade';

  @override
  String get valueQualityTitle => 'Quality and Diligence';

  @override
  String get valueQualityDesc =>
      'Whether brand new or second hand, we select with diligence and present it to you as such.';

  @override
  String get valueSmileTitle => 'Smiling Face';

  @override
  String get valueSmileDesc =>
      'For us, the greatest profit is a neighbor leaving our shop happy. Your satisfaction comes first.';

  @override
  String get valueLaborTitle => 'Respect for Labor';

  @override
  String get valueLaborDesc =>
      'Furniture is a valuable labor. By giving second-hand products a second life, we protect both your budget and nature.';

  @override
  String get valueTrustTitle => 'Honesty and Trust';

  @override
  String get valueTrustDesc =>
      'Transparent and honest trade is our greatest value. We have been with you in the same location for years.';

  @override
  String get masterHistoryTitle => 'Meet Our Master';

  @override
  String get masterHistoryDesc =>
      'Our master has been in this business since 1995. He has learned the tricks of the trade working for top brands like Istikbal. He brought the experience gained in every field from driving to assembly to Saglam Spot in 2012. His goal is to combine corporate quality with artisan sincerity.';

  @override
  String get deliveryServiceTitle => 'Our Shipping and Assembly Service';

  @override
  String get freeShipping => 'Free Shipping and Assembly';

  @override
  String get deliveryServiceSub => 'Our Free Service Areas:';

  @override
  String get deliveryRegions =>
      '• Icerenkoy Neighborhood\n• Findikli, Kayisdagi, Kucukbakkalkoy\n• Nearby neighbors like Inonu and Bostanci Sanayi';

  @override
  String get deliveryWarning =>
      'Important Note: To protect our master\'s health, we unfortunately cannot provide service to high floors in buildings without elevators.';

  @override
  String get deliveryOnTime => '⏰ We are at your door at the agreed time!';

  @override
  String get transportationTitle => 'How to Get to Our Store?';

  @override
  String get busArrival => 'If You Come by Bus:';

  @override
  String get busStopZiyapasa => 'Ziyapaşa Stop (Towards Kadikoy):';

  @override
  String get busStopIcerenkoyKayisdagi => 'İçerenköy Stop (Towards Kayisdagi):';

  @override
  String get busStopIcerenkoyYeniyol => 'İçerenköy Stop (Yeniyol):';

  @override
  String get callNow => 'Call Now';

  @override
  String get seeOnMap => 'See on Map';

  @override
  String get phoneQuickSolution => 'Phone (Quick Solution)';

  @override
  String get addressTeaInvitation => 'Address (Welcome for Tea)';

  @override
  String get workingHours => 'Our Working Hours';

  @override
  String get workingDays => 'Mon-Sat: 09:00 - 22:00\nSunday: 10:00 - 20:00';

  @override
  String get shopLocationTitle => 'Our Shop is Right Here';

  @override
  String get getDirectionsDesc => 'Tap the map to get directions';

  @override
  String get similarProducts => 'SIMILAR PRODUCTS';

  @override
  String get customerReviews => 'CUSTOMER REVIEWS';

  @override
  String get viewAll => 'View All';

  @override
  String get features => 'FEATURES';

  @override
  String get description => 'DESCRIPTION';

  @override
  String get detailsTab => 'DETAILS';

  @override
  String get shippingTab => 'SHIPPING';

  @override
  String get reviewsTab => 'REVIEWS';

  @override
  String get readMore => 'READ MORE';

  @override
  String get showLess => 'SHOW LESS';

  @override
  String get buyNow => 'BUY NOW';

  @override
  String get addToCart => 'ADD TO CART';

  @override
  String get sendMessage => 'SEND MESSAGE';

  @override
  String get guaranteeNone => 'No Warranty';

  @override
  String get assemblyFree => 'Free Assembly';

  @override
  String get returnNone => 'No Returns';

  @override
  String get supportFull => '16/6 Support';

  @override
  String get confirmedSeller => 'Verified Seller';

  @override
  String get productName => 'Product Name';

  @override
  String get price => 'Price';

  @override
  String get addProduct => 'Add Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get productImages => 'Product Images';

  @override
  String get generalInfo => 'General Information';

  @override
  String get statusAndCategory => 'Status and Category';

  @override
  String get isSold => 'Product Sold';

  @override
  String get isSpot => 'Spot / Second Hand';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String get deleteConfirm => 'This product will be deleted. Are you sure?';

  @override
  String get yesDelete => 'Yes, Delete';

  @override
  String get productNotFound => 'Product not found';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get noImages => 'No Images';

  @override
  String get furnitureTipsTitle => 'Tips from the Expert';

  @override
  String get tipBalanceTitle => 'Check the Level';

  @override
  String get tipBalanceDesc =>
      'Ensure all legs of your furniture press firmly on the floor. Use felt for balance on sloped floors.';

  @override
  String get tipWallGapTitle => 'Leave Distance from the Wall';

  @override
  String get tipWallGapDesc =>
      'Leave 1-2 cm gap for air circulation. Prevents humidity and mold.';

  @override
  String get tipHeatTitle => 'Keep Away from Heat';

  @override
  String get tipHeatDesc =>
      'Position at least 30 cm away from heaters and stoves. Proximity causes wood to crack.';

  @override
  String get tipSunTitle => 'Protect from Sunlight';

  @override
  String get tipSunDesc =>
      'Direct sunlight causes color fading and wood deformation. Filter light with curtains.';

  @override
  String get tipCleaningTitle => 'Moist Cleaning';

  @override
  String get sessionClosed => 'Session closed';

  @override
  String get authDeniedAdminOnly =>
      'Access Denied: This email was not found in the admin list.';

  @override
  String get fillRequiredFields =>
      'Please add product name, price, and at least one image!';

  @override
  String get productAddedSuccess => 'Product added successfully';

  @override
  String get authOrConnectionError =>
      'Authorization or connection error occurred';

  @override
  String get accountDisabled => 'This user account has been disabled.';

  @override
  String get adminNotFound => 'No admin registered with this email was found.';

  @override
  String get wrongPassword => 'Incorrect password, please check again.';

  @override
  String get invalidEmailOrPassword => 'Invalid email or password.';

  @override
  String get tooManyAttempts => 'Too many attempts. Please try again later.';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get adminLogin => 'Admin Panel Login';

  @override
  String get quickOptions => 'Quick Options';

  @override
  String get addImages => 'Add Images';

  @override
  String get changeImages => 'Change Images';

  @override
  String get noImagesFound => 'No images';

  @override
  String get tipCleaningDesc =>
      'Wipe with a slightly damp cloth and dry immediately. A soaking wet cloth causes wood to swell.';

  @override
  String get helpCenter => 'YARDIM MERKEZİ';

  @override
  String get faqTitle => 'Sıkça Sorulan Sorular';

  @override
  String get faqSub => 'Merak ettiğiniz her şeyin cevabı burada';

  @override
  String get seoHomeTitle => 'Saglam Spot | Spot & New Furniture';

  @override
  String get seoHomeDesc =>
      'Best prices on spot and new furniture. 20 years of experience.';

  @override
  String get seoNewTitle => 'New Products | Saglam Spot';

  @override
  String get seoNewDesc =>
      'Guaranteed and high-quality new furniture collection.';

  @override
  String get seoSpotTitle => 'Spot Products | Saglam Spot';

  @override
  String get seoSpotDesc => 'Affordable and quality spot furniture options.';

  @override
  String get seoAboutTitle => 'About Us | Saglam Spot';

  @override
  String get seoAboutDesc =>
      'The address of trust in the furniture industry with 20 years of experience.';

  @override
  String get seoProductDetailSuffix => 'View Product | Saglam Spot';
}

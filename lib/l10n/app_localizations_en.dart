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
  String get seoHomeTitle => 'Saglam Spot | Spot & New Furniture';

  @override
  String get seoHomeDesc =>
      'Best prices on spot and new furniture with 20 years of trusted craftsmanship.';

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
      'The trusted name in furniture with over 20 years of experience.';

  @override
  String get seoProductDetailSuffix => 'View Product | Saglam Spot';

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
  String get price => 'Price';

  @override
  String get save => 'Save';

  @override
  String get explanation => 'Explanation';

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
  String get quickOptions => 'Quick Options';

  @override
  String get easyFind => 'Easily find the product you are looking for';

  @override
  String get mottoBrand => 'Renews the Old, Evaluates the New';

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
  String get stock => 'IN STOCK';

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

  @override
  String get noProductFoundTitle => 'No Products Found for Your Criteria';

  @override
  String get noProductFoundDescription =>
      'You can try different filters or change your search term';

  @override
  String get adminPanelTitle => 'Admin Panel';

  @override
  String get totalCount => 'Total';

  @override
  String get productAddedSuccess => 'Product added successfully';

  @override
  String get authOrConnectionError =>
      'Authorization or connection error occurred';

  @override
  String get fillRequiredFields =>
      'Please add a product name, price, and at least one image!';

  @override
  String get sessionClosed => 'Session closed';

  @override
  String get addNewProduct => 'Add New Product';

  @override
  String get productImages => 'Product Images';

  @override
  String get generalInfo => 'General Information';

  @override
  String get productNameLabel => 'Product Name';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get statusLabel => 'Status';

  @override
  String get spotSecondHand => 'Spot / Second-Hand';

  @override
  String get secondHandHint => 'Single piece — color options won\'t be shown';

  @override
  String get newProductHint => 'New product — you can add color options';

  @override
  String get colorOptionsOptional => 'Color Options (optional)';

  @override
  String get noImagesYet => 'No images added yet';

  @override
  String get addImage => 'Add Image';

  @override
  String get editProductTitle => 'Edit Product';

  @override
  String get changeImages => 'Change Images';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get deleteProductTitle => 'Delete Product';

  @override
  String get deleteProductConfirmSuffix => 'will be deleted. Are you sure?';

  @override
  String get yesDelete => 'Yes, Delete';

  @override
  String get emptyCategoryProducts => 'No products found in this category';

  @override
  String get adminLoginSubtitle => 'Admin Panel Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Log In';

  @override
  String get sponsored => 'Sponsored';

  @override
  String get addProductFab => 'Add Product';

  @override
  String get singlePieceNotice =>
      'This is a second-hand / spot item — only one piece is in stock, and the color/appearance is exactly as shown in the photos.';

  @override
  String get colorOptionsTitle => 'Color Options';

  @override
  String get newProductBadge => 'NEW PRODUCT';

  @override
  String get usedProductBadge => 'SECOND-HAND';

  @override
  String get readMore => 'Read more';

  @override
  String get readLess => 'Show less';

  @override
  String get specDelivery => 'Delivery';

  @override
  String get specDeliveryValue => 'Within 1-2 Days';

  @override
  String get specLocation => 'Location';

  @override
  String get sellerTrustLine =>
      '20 years of trusted local business · İçerenköy';

  @override
  String get whatsappCta => 'Message on WhatsApp';

  @override
  String get callCta => 'Call';

  @override
  String get similarProducts => 'Similar Products';

  @override
  String get conditionShowcase => 'Showcase';

  @override
  String get productDescriptionTitle => 'Description';

  @override
  String get loginBrand => 'Sağlam Spot';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutConfirm =>
      'Are you sure you want to safely log out of your account?';

  @override
  String get testimonialsHeading => 'What Our Customers Say';

  @override
  String get testimonialsSubheading =>
      'For over 20 years we\'ve touched thousands of homes in İçerenköy and beyond';

  @override
  String get testimonial1Comment =>
      'We got the sofa set at a great price, almost like new. Delivered the same day, hand to hand — the trust of a real local business was there from the start.';

  @override
  String get testimonial2Comment =>
      'I bought the bedroom set at spot price here. It matched the product description exactly, no surprises at all. I definitely recommend it.';

  @override
  String get testimonial3Comment =>
      'We did a bulk furniture purchase for our office, and both the price and quality exceeded our expectations. A caring, patient team — thank you, Sağlam Spot.';

  @override
  String get testimonial4Comment =>
      'We bought the dining table set at an honest, no-haggling price. They also helped with transport — we shopped with real peace of mind.';

  @override
  String get testimonial5Comment =>
      'We were looking for a second-hand wardrobe and found something sturdy and stylish. Best value for money on the market.';

  @override
  String get testimonial6Comment =>
      'We got to see the products in person during our showroom visit, which built even more trust. They\'ve always stayed reachable after the sale too.';

  @override
  String get howItWorksHeading => 'How It Works';

  @override
  String get step1Title => 'Browse & Filter';

  @override
  String get step1Desc =>
      'Find what you love among thousands of products by category and price range.';

  @override
  String get step2Title => 'Reach Out to Us';

  @override
  String get step2Desc =>
      'Get in touch with our team on WhatsApp or by phone straight from the product page.';

  @override
  String get step3Title => 'Confirm the Price';

  @override
  String get step3Desc =>
      'See it at our showroom or confirm it with photos, then agree on a fair, honest price.';

  @override
  String get step4Title => 'Delivered to Your Door';

  @override
  String get step4Desc =>
      'Fast, insured delivery to İçerenköy and the Anatolian side gets your furniture home safely.';

  @override
  String get tipsEyebrow => 'TIPS';

  @override
  String get tipsHeading => 'Care Tips From Our Expert';

  @override
  String get tip1Title => 'Make Your Living Room Lovable';

  @override
  String get tip1Desc =>
      'Leave a 1-2 cm gap between your sofa and the wall — it helps air circulate and makes the room feel airier.';

  @override
  String get tip1Category => 'Placement';

  @override
  String get tip2Title => 'A Desk That Always Looks Clean';

  @override
  String get tip2Desc =>
      'Tidy cables with organizers and wipe with a microfiber cloth in circular motions — your desk stays looking new.';

  @override
  String get tip2Category => 'Cleaning';

  @override
  String get tip3Title => 'A Kitchen Setup You\'ll Enjoy';

  @override
  String get tip3Desc =>
      'Put heavy items on lower shelves and everyday items at eye level — both practical and safe.';

  @override
  String get tip3Category => 'Organization';

  @override
  String get tip4Title => 'Set Up a Comfortable Sleep Corner';

  @override
  String get tip4Desc =>
      'Position the headboard away from the window to minimize light — a small change for noticeably deeper sleep.';

  @override
  String get tip4Category => 'Comfort';

  @override
  String get tip5Title => 'Freshen Up Your Closet';

  @override
  String get tip5Desc =>
      'Separate seasonal clothes and hang everything facing the same way — it saves space and makes picking outfits easier every morning.';

  @override
  String get tip5Category => 'Organization';

  @override
  String get tip6Title => 'Add Years to Your Wood Furniture';

  @override
  String get tip6Desc =>
      'Keep it out of direct sunlight and wipe with a nourishing oil a few times a year — the most effective care against scratches and fading.';

  @override
  String get tip6Category => 'Care';

  @override
  String get tip7Title => 'Make Fabric Sofas Last Longer';

  @override
  String get tip7Desc =>
      'Vacuum weekly and blot stains immediately with a damp cloth — waiting lets stains set into the fabric.';

  @override
  String get tip7Category => 'Care';

  @override
  String get tip8Title => 'Choose the Right Lighting';

  @override
  String get tip8Desc =>
      'Use layered lighting instead of a single ceiling lamp: ambient, task, and accent light together make a room feel warmer.';

  @override
  String get tip8Category => 'Lighting';

  @override
  String get tip9Title => 'Make Smart Use of Small Spaces';

  @override
  String get tip9Desc =>
      'Choose foldable, multi-purpose furniture; wall-mounted shelves free up floor space.';

  @override
  String get tip9Category => 'Organization';

  @override
  String get tip10Title => 'Turn Your Balcony Into a Living Space';

  @override
  String get tip10Desc =>
      'A weather-resistant seating set and a few potted plants make the balcony the coziest corner of the home.';

  @override
  String get tip10Category => 'Outdoor';

  @override
  String get popularCategoriesHeading => 'Popular Categories';

  @override
  String get popularCategoriesSub => 'Find the furniture you need in one click';

  @override
  String categoryProductCount(int count) {
    return '$count items';
  }

  @override
  String get newsletterSubscribeSuccess =>
      'You\'ve successfully subscribed to our newsletter!';

  @override
  String get newsletterHeading => 'Be the First to Know About New Products';

  @override
  String get newsletterDesc =>
      'Get spot deals, new collections and campaigns straight to your inbox. No spam, just deals worth your time.';

  @override
  String get emailHint => 'Your email address';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get whyUsHeading => 'Why Sağlam Spot?';

  @override
  String get usp1Title => '20 Years of Trusted Local Business';

  @override
  String get usp1Desc =>
      'Over twenty years as a local business in İçerenköy, and thousands of happy customers.';

  @override
  String get usp2Title => 'Below-Market Pricing';

  @override
  String get usp2Desc =>
      'With no middlemen, we offer the best prices on spot and new furniture.';

  @override
  String get usp3Title => 'Checked Product Quality';

  @override
  String get usp3Desc =>
      'Every product goes through a structural and fabric/finish check before it goes on sale.';

  @override
  String get usp4Title => 'After-Sales Support';

  @override
  String get usp4Desc =>
      'A real team you can reach even after delivery, that solves your problem.';

  @override
  String get socialShowcaseEyebrow => 'SHARE';

  @override
  String get socialShowcaseHeading => 'Share Your Setup with #SağlamSpot';

  @override
  String productsLoadError(String error) {
    return 'An error occurred while loading products: $error';
  }

  @override
  String get viewAllButton => 'View All';

  @override
  String get showcaseEyebrow => 'SHOWCASE';

  @override
  String get exploreButton => 'Explore';

  @override
  String get visitUsEyebrow => 'VISIT US';

  @override
  String get visitUsHeading => 'Just Say Hello';

  @override
  String visitUsOpenLine(String hours) {
    return 'Our door is always open. $hours';
  }

  @override
  String get directionsButton => 'Get Directions';

  @override
  String get freeDeliveryLabel => 'Free Delivery';

  @override
  String get busLinesLabel => 'Bus Lines';

  @override
  String get statYearsSuffix => '+ Years';

  @override
  String get storeAddress => 'İçerenköy, Ataşehir/İstanbul';

  @override
  String get stayUpdated => 'Stay Updated';

  @override
  String get viewButton => 'View';

  @override
  String get heroSlide2Eyebrow => 'SECOND-HAND';

  @override
  String get heroSlide2Title => 'Furniture With a Story';

  @override
  String get heroSlide2Subtitle =>
      'Carefully selected, sturdy second-hand pieces with character.';

  @override
  String get heroSlide3Title => 'Explore the Whole Collection';

  @override
  String get aboutBadge => 'WITH YOU SINCE 2012';

  @override
  String get aboutHeroTitle => 'Sağlam Spot\nThe Trust You Know';

  @override
  String get aboutHeroSubtitle =>
      'We serve our neighborhood with love and care in everything we do.';

  @override
  String get aboutStoryHeading => 'Who Are We? (Our Story)';

  @override
  String get aboutStoryPara1 =>
      'Our goal is to help you find quality furniture that brings warmth to your home and truly feels right. Beautifying your living spaces is our job.';

  @override
  String get aboutStoryPara2 =>
      'It all started in 2012, in this very shop in İçerenköy. Since then, the number of homes we\'ve been welcomed into has only grown.';

  @override
  String get aboutStoryPara3 =>
      'Today, with both new and carefully selected second-hand pieces, we\'ve become guests in thousands of our neighbors\' homes. We grow through your trust.';

  @override
  String get aboutStoryStartLabel => 'Founded';

  @override
  String get aboutStoryExperienceLabel => 'Years of Experience';

  @override
  String get aboutStorySmilesLabel => 'Happy Faces';

  @override
  String get aboutValuesHeading => 'Our Principles';

  @override
  String get aboutValuesSubheading =>
      'The principles we never compromise on as a local business';

  @override
  String get aboutValue1Title => 'Quality & Care';

  @override
  String get aboutValue1Desc =>
      'Whether new or second-hand, we choose carefully and present it to you just the same way.';

  @override
  String get aboutValue2Title => 'Happy Faces';

  @override
  String get aboutValue2Desc =>
      'For us, the greatest reward is a neighbor leaving the shop happy. Your satisfaction comes before anything else.';

  @override
  String get aboutValue3Title => 'Respect for Craftsmanship';

  @override
  String get aboutValue3Desc =>
      'Furniture is valuable labor. By giving second-hand pieces new life, we protect both your budget and the environment.';

  @override
  String get aboutValue4Title => 'Honesty & Trust';

  @override
  String get aboutValue4Desc =>
      'Transparent, honest local business is our greatest value. We\'ve been with you in the same location for years.';

  @override
  String get aboutMasterHeading => 'Meet Our Craftsman';

  @override
  String get aboutMasterBody =>
      'Our craftsman has been active in this trade since 1995 — more than a quarter century. He\'s seen it all, having worked at leading brands (İstikbal), gaining deep knowledge of furniture features, parts, and the finer details.\n\nFrom driving deliveries to assembly to customer service, he\'s worked hands-on in every role, building all-round experience. In 2012, deciding it was time for \'my own shop,\' he brought that experience to Sağlam Spot.\n\nHis goal is to combine the quality he learned at those big companies with the warmth and care of a neighborhood business, to give you the best possible service.';

  @override
  String get aboutDeliveryHeading => 'Our Delivery & Assembly Service';

  @override
  String get aboutDeliveryFreeTitle => 'Free Delivery & Assembly';

  @override
  String get aboutDeliveryZonesLabel => 'Our Free Service Areas:';

  @override
  String get aboutDeliveryZonesList =>
      '• Our İçerenköy neighborhood\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• Nearby neighbors like İnönü and Bostancı Sanayi';

  @override
  String get aboutDeliveryNote =>
      'Important Note: To protect our craftsman\'s health, we unfortunately cannot carry items up to high floors in buildings without an elevator. Thank you for your understanding.';

  @override
  String get aboutDeliveryPunctual =>
      '⏰ We\'re at your door at the time we agreed on!';

  @override
  String get aboutTransportHeading => 'How to Reach Our Shop';

  @override
  String get aboutTransportBusIntro => 'If You\'re Coming by Bus:';

  @override
  String get aboutBusStop1 => 'Ziyapaşa Stop (Towards Kadıköy):';

  @override
  String get aboutBusStop2 => 'İçerenköy Stop (Towards Kayışdağı):';

  @override
  String get aboutBusStop3 => 'İçerenköy Stop (Yeniyol):';

  @override
  String get aboutContactPhoneLabel => 'Phone (Quick Answers)';

  @override
  String get aboutContactAddressLabel => 'Address (Come for Tea)';

  @override
  String get aboutContactAddressValue =>
      'İçerenköy Mahallesi\nBuket Sokak No:6';

  @override
  String get aboutContactHoursLabel => 'Our Working Hours';

  @override
  String get aboutContactHoursValue =>
      'Mon-Sat: 09:00 - 22:00\nSun: 10:00 - 20:00';

  @override
  String get aboutContactHeading => 'Get in Touch';

  @override
  String get aboutCallNowButton => 'Call Now';

  @override
  String get aboutViewMapButton => 'View on Map';

  @override
  String get aboutMapHeading => 'Our Shop Is Right Here';

  @override
  String get aboutMapSubtext => 'Tap the map for directions';

  @override
  String get newProductsBadgeEyebrow => 'NEW COLLECTION';

  @override
  String get newProductsTitle => 'New\nCollection';

  @override
  String get productsBadgeLabel => 'PRODUCTS';

  @override
  String get breadcrumbHome => 'Home';

  @override
  String get statTotalProducts => 'TOTAL PRODUCTS';

  @override
  String get statCategoryLabel => 'CATEGORIES';

  @override
  String get statConditionValueNew => 'NEW';

  @override
  String get statConditionLabel => 'CONDITION';

  @override
  String get statRatingLabel => 'RATING';

  @override
  String get searchBarRichPrefix => 'For a detailed product search press ';

  @override
  String get searchBarRichOr => ' or click ';

  @override
  String get searchBarRichHereLink => 'HERE';

  @override
  String get searchBarRichSuffix => '.';

  @override
  String get sortNewProductsDefault => 'Newest';

  @override
  String get sortSpotProductsDefault => 'Newest';

  @override
  String get sortPriceLowHigh => 'Price: Low to High';

  @override
  String get sortPriceHighLow => 'Price: High to Low';

  @override
  String get sortMostPopular => 'Most Popular';

  @override
  String get spotBadgeEyebrow => 'SPOT PRODUCTS';

  @override
  String get spotHeroTitle => 'Deal\nProducts';

  @override
  String get spotDiscountLabel => 'DISCOUNT';

  @override
  String get statSpotProductLabel => 'Spot Products';

  @override
  String get statDiscountLabel => 'Discount';

  @override
  String get statSupportLabel => 'Support';

  @override
  String get statFreeLabel => 'Free';

  @override
  String get statFreeShippingNote => 'For Nearby Areas Only, Shipping';

  @override
  String get statFreeShippingShort => 'Shipping';

  @override
  String get filtersPanelTitle => 'FILTERS';

  @override
  String get dragToRotateHint => 'Swipe for more photos';

  @override
  String get studioQuotaExceededNotice =>
      'Monthly studio image limit reached — photos were added in their original form.';

  @override
  String get studioPreparingWait => 'Preparing studio photo, please wait...';

  @override
  String get retry => 'Retry';

  @override
  String get studioGenerationFailed => 'Couldn\'t generate studio photo';

  @override
  String get storePhotoLabel => 'Store';

  @override
  String get studioPhotoLabel => 'Studio';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingStart => 'Get Started';

  @override
  String get onboardingPage1Eyebrow => 'WELCOME TO SAĞLAM SPOT';

  @override
  String get onboardingPage1Title => 'The Right Place\nFor Your Home';

  @override
  String get onboardingPage1Desc =>
      'With over 20 years of trusted craftsmanship, we bring quality furniture straight to your pocket.';

  @override
  String get onboardingPage2Eyebrow => 'PRE-OWNED & BRAND NEW, TOGETHER';

  @override
  String get onboardingPage2Title => 'Options For\nEvery Budget';

  @override
  String get onboardingPage2Desc =>
      'From great second-hand finds to our brand-new collection — easily find exactly what you\'re looking for.';

  @override
  String get onboardingPage3Eyebrow => 'SHOP WITH CONFIDENCE';

  @override
  String get onboardingPage3Title => 'Found\nSomething? Ask Now';

  @override
  String get onboardingPage3Desc =>
      'Reach us instantly on WhatsApp, ask about pricing, and negotiate directly — no middlemen.';

  @override
  String get favoritesTitle => 'My Favorites';

  @override
  String get favoritesEmptyTitle => 'Your Favorites List Is Empty';

  @override
  String get favoritesEmptyDesc =>
      'Tap the heart icon on products you like to add them to your favorites.';

  @override
  String get sortPanelTitle => 'SORT';

  @override
  String get priceRangeSectionTitle => 'PRICE RANGE';

  @override
  String get clearFiltersButton => 'CLEAR FILTERS';

  @override
  String get tryDifferentFiltersShort => 'You can try different filters';

  @override
  String get spotBadgeTag => 'SPOT';

  @override
  String productLoadError(String error) {
    return 'Product could not be loaded: $error';
  }

  @override
  String get productSpecConditionNew => 'New Product';

  @override
  String get productLocationValue => 'İçerenköy, İstanbul';

  @override
  String get sortFeatured => 'Featured';

  @override
  String get sortPriceAsc => 'Price: Ascending';

  @override
  String get sortPriceDesc => 'Price: Descending';

  @override
  String get languageSelectorTitle => 'Language';

  @override
  String get languageTooltip => 'Language';

  @override
  String get galleryEmptyMessage =>
      'No photos have been added to this product yet.';

  @override
  String get productCardNewBadge => 'NEW';

  @override
  String get sssHelpCenterBadge => 'HELP CENTER';

  @override
  String get sssHeroTitle => 'Frequently Asked\nQuestions';

  @override
  String get sssHeroSubtitle => 'Answers to everything you\'re curious about';

  @override
  String get sssCategoryAll => 'All';

  @override
  String get sssCategoryGeneral => 'General';

  @override
  String get sssCategoryProductService => 'Product & Service';

  @override
  String get sssCategoryDelivery => 'Delivery & Assembly';

  @override
  String get sssCategoryPayment => 'Payment & Orders';

  @override
  String get sssCategoryReturns => 'Returns & Warranty';

  @override
  String get sssCategorySecondHandBuying => 'Second-Hand Buying Process';

  @override
  String get sssPhoneSupportTitle => 'Phone Support';

  @override
  String get sssWorkingHoursTitle => 'Working Hours';

  @override
  String get sssWorkingHoursValue => '09:00 - 22:00';

  @override
  String get sssStoreAddressTitle => 'Store Address';

  @override
  String get sssStoreAddressValue => 'İçerenköy Mahallesi Buket Sok. No:6';

  @override
  String get sssNoAnswerTitle => 'Didn\'t Find Your Answer?';

  @override
  String get sssNoAnswerSubtitle => 'You Can Reach Us';

  @override
  String get sssVisitStoreButton => 'Visit the Store';

  @override
  String get sssQ1 =>
      'Can you tell us about the craftsman\'s work life and experience?';

  @override
  String get sssA1 =>
      'Our craftsman has been actively working in this trade since 1995. He has kept developing continuously since his very first steps in his career. Throughout his working life, he\'s held many roles — driving for deliveries, transport, assembly, customer greeting — gaining well-rounded experience. He worked at İstikbal until 2010 in particular, and during that time gained deep knowledge of product features, parts, and finer details. After 2010, he worked at nearby Işık Çeyiz, further sharpening his skills in the trade. In 2012, he decided to open his own local shop, and since then he\'s aimed to put quality service first and pass on his industry experience to customers in the best possible way.';

  @override
  String get sssQ2 => 'Is Sağlam Spot reliable?';

  @override
  String get sssA2 =>
      'We\'ve been serving our neighbors in İçerenköy since 2012. We\'ve been welcomed into countless homes, and we still are.';

  @override
  String get sssQ3 => 'Can I come to your store to look at the products?';

  @override
  String get sssA3 =>
      'Of course! In fact, we especially recommend it. Seeing the products in person over a cup of tea, touching them, and making sure they feel right is the healthiest way. We always welcome you to our shop in İçerenköy Mahallesi.';

  @override
  String get sssQ4 => 'How is the condition of second-hand products checked?';

  @override
  String get sssA4 =>
      'To us, second-hand doesn\'t mean second-rate. Every product goes through our craftsman\'s careful inspection — cleaning, maintenance and any needed repairs are done in full. What you see in the photos is what you get, but we still say \'come see it for yourself.\' Seeing it with your own eyes is always best.';

  @override
  String get sssQ5 => 'What is the material quality of the furniture?';

  @override
  String get sssA5 =>
      'We care about transparency. Every product has its own story and materials. That\'s why we clearly write out all the details, material quality and features in the product description. If anything\'s on your mind, don\'t hesitate to ask.';

  @override
  String get sssQ6 => 'How are product prices determined?';

  @override
  String get sssA6 =>
      'When setting our prices, we look fairly at both the product\'s quality and market conditions. Our goal is to help you get quality, long-lasting products without straining your budget. We charge what\'s fair, nothing more.';

  @override
  String get sssQ7 => 'Do your products come in color options?';

  @override
  String get sssA7 =>
      'Since our products are usually one-off, single pieces, we offer them in whatever color they come in. Unfortunately we can\'t offer different color options. The color you see is the color you get.';

  @override
  String get sssQ8 => 'Do you take custom orders?';

  @override
  String get sssA8 =>
      'We wish we could! But we focus mainly on our existing, carefully selected products. We unfortunately can\'t take custom manufacturing or design orders at the moment. We recommend browsing what we already have in stock.';

  @override
  String get sssQ9 => 'What should I pay attention to in product descriptions?';

  @override
  String get sssA9 =>
      'Our most important tip: grab a tape measure! Please carefully compare the measurements in the product description with the spot you plan to put it in at home. Solving the \'will it fit?\' question upfront prevents headaches later. Also, don\'t forget the hallway when measuring — measure not just where the furniture will go, but how it will get through the door, hallway, and stairs. Also make sure to read the material and condition details.';

  @override
  String get sssQ10 =>
      'Do you deliver to buildings without an elevator or to high floors?';

  @override
  String get sssA10 =>
      'This is one of the most sensitive and important topics for us. We\'re a small local business that does the work ourselves. Since our craftsman isn\'t getting any younger after years of experience, we also have to think about his health. With your understanding, we simply cannot carry items up or down high floors (for example, 2nd floor and above) in buildings without an elevator. Please let\'s clarify this before you place your order — we don\'t want to leave you disappointed.';

  @override
  String get sssQ11 => 'Do you provide a transport service?';

  @override
  String get sssA11 =>
      'Of course, we help our neighbors out. We offer free delivery to nearby areas, especially İçerenköy, as well as Fındıklı, Kayışdağı, Küçükbakkalköy, İnönü and Bostancı Sanayi. (Except for some parts of Bostancı and Kozyatağı, and due to our craftsman\'s age we can\'t carry items up high floors without an elevator — we\'ll discuss that separately.)';

  @override
  String get sssQ12 => 'How long does delivery take?';

  @override
  String get sssA12 =>
      'The moment you place an order, we get in touch with you. We ask \'when works for you?\' and agree on a time that suits us both. We usually complete delivery and assembly within 1-3 days, at the time we agreed on.';

  @override
  String get sssQ13 => 'Do you provide an assembly service?';

  @override
  String get sssA13 =>
      'Of course. Dropping furniture off at your door isn\'t our style. Our craftsman personally assembles all large items, and we don\'t charge extra for this service. You just show us where it goes — the rest is on us.';

  @override
  String get sssQ14 => 'How long does it take to deliver a furniture order?';

  @override
  String get sssA14 =>
      'If the product is ready, we\'re at your door as soon as possible, at a time we agree on together. Don\'t worry about assembly either — we set it up just as we brought it and deliver it that way. Usually everything is done within the same day.';

  @override
  String get sssQ15 => 'Can I order on credit / pay later?';

  @override
  String get sssA15 =>
      'We ask for your understanding on this. As a local business, to stay afloat we unfortunately can\'t work with \'buy now, pay later\' or similar methods. We need to receive the agreed amount in cash when the product is delivered. We prefer to state this rule upfront so there\'s no awkwardness later.';

  @override
  String get sssQ16 => 'How can I place an order?';

  @override
  String get sssA16 =>
      'The most reliable way is always in person. Note down the product you like on the site, then come to our shop. See the product in person, ask any questions on your mind, and if it feels right, let\'s complete your order there. That way there\'s no doubt left.';

  @override
  String get sssQ17 => 'What is your return policy?';

  @override
  String get sssA17 =>
      'Due to the nature of second-hand products and the way local businesses operate, we unfortunately cannot accept returns. That\'s why we insist you \'come, see it, have some tea with us.\' It\'s best to examine the product closely and measure it carefully before buying. Let\'s not complete a purchase unless you\'re sure.';

  @override
  String get sssQ18 => 'Do the products come with a warranty period?';

  @override
  String get sssA18 =>
      'Since our products are second-hand, we unfortunately don\'t offer an official warranty period like a brand would. But we\'re not the type to say \'sold, done.\' We make sure everything works properly during delivery and assembly.';

  @override
  String get sssQ19 =>
      'I want to sell items from my home — do you buy second-hand?';

  @override
  String get sssA19 =>
      'Yes, we buy select items that are clean and resellable, ones we believe we can display in our shop. However, since our shop space is genuinely very small, we unfortunately have to be quite selective about this.\n\nWe like to be upfront about this: the offer you get from us may be somewhat lower than what you could get selling it yourself on platforms like Letgo. Here\'s why: as a local business, we spend fuel to pick it up, put in effort to transport it, and — most importantly — we handle the entire customer process of displaying and selling it in our shop (haggling, questions, etc.).\n\nWhen you sell on those platforms yourself, you take on all of that yourself. We\'re taking that hassle off your hands instead. Our offer reflects that service too. Thank you for your understanding.';

  @override
  String get sssQ20 =>
      'Do you buy complete furniture sets (bedroom, living room set, etc.)?';

  @override
  String get sssA20 =>
      'Because our shop is small, we unfortunately can\'t take complete sets like a full bedroom or living room set — big sets. Our space is very limited. We focus more on single pieces that are easier to sell, like consoles, wardrobes, tables, and chairs.';

  @override
  String get sssQ21 =>
      'My items are on a high floor and the building has no elevator. Would you still buy them?';

  @override
  String get sssA21 =>
      'Just like with delivery, this is our clearest rule. Due to our craftsman\'s health, we simply cannot carry items down from high floors in buildings without an elevator. We can only consider it if your items are near the ground/entrance floor, or if the building has a freight elevator.';

  @override
  String get sssQ22 => 'Do you always buy items?';

  @override
  String get sssA22 =>
      'It entirely depends on the space we have in our shop at the time. Since our shop is small, we operate on a \'sell one, buy one\' balance. Sometimes we really like an item but can\'t take it because we don\'t have room. The best approach is to send us photos of what you\'d like to sell — we\'ll honestly tell you whether \'we have room right now\' or \'unfortunately we\'re full at the moment.\'';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navCart => 'Cart';

  @override
  String get navProfile => 'Profile';

  @override
  String get storeHeroEyebrow => 'NEW COLLECTION';

  @override
  String get storeHeroTitle => 'Furniture That\nFeels Like Home';

  @override
  String get storeHeroSubtitle =>
      'Quality new and second-hand furniture, delivered to your door at prices you\'ll love.';

  @override
  String get storeHeroCta => 'Start Shopping';

  @override
  String get sectionCategories => 'Categories';

  @override
  String get sectionBestSellers => 'Best Sellers';

  @override
  String get sectionNewArrivals => 'New Arrivals';

  @override
  String get seeAll => 'See All';

  @override
  String get cartTitle => 'My Cart';

  @override
  String get cartEmptyTitle => 'Your Cart is Empty';

  @override
  String get cartEmptyDesc =>
      'Add items you like, then ask about them all in one message.';

  @override
  String get cartTotalLabel => 'Total';

  @override
  String get cartWhatsappCta => 'Send Cart via WhatsApp';

  @override
  String get cartItemRemoved => 'Removed from cart';

  @override
  String get addToCartCta => 'Add to Cart';

  @override
  String get addedToCartMessage => 'Added to cart';

  @override
  String get alreadyInCartMessage => 'Already in your cart';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get settingsGeneralSection => 'General';

  @override
  String get settingsContact => 'Contact';

  @override
  String get settingsCallUs => 'Call Us';

  @override
  String get settingsAdminLogin => 'Admin Login';

  @override
  String get settingsAppVersion => 'App Version';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'Cart is empty',
    );
    return '$_temp0';
  }

  @override
  String get settingsRateApp => 'Rate the App';

  @override
  String get settingsShareApp => 'Share the App';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTerms => 'Terms & Conditions';

  @override
  String get legalContentTurkishOnly =>
      'This content is currently available in Turkish only.';

  @override
  String get doubleBackToExit => 'Press back again to exit';

  @override
  String get productLinkLabel => 'Product link';

  @override
  String get settingsAppSection => 'App';

  @override
  String get settingsLegalSection => 'Legal';

  @override
  String get recentlyViewedTitle => 'Recently Viewed';

  @override
  String get productTrustBadgeVerified => 'Verified Seller';

  @override
  String get productTrustBadgeNegotiate => 'Negotiate on WhatsApp';

  @override
  String get productTrustBadgeDelivery => 'On-site Delivery';

  @override
  String get howToBuyTitle => 'How to Buy?';

  @override
  String get howToBuyStep1Title => 'Message on WhatsApp';

  @override
  String get howToBuyStep1Desc => 'If you like the item, reach us on WhatsApp.';

  @override
  String get howToBuyStep2Title => 'Discuss the Price';

  @override
  String get howToBuyStep2Desc =>
      'Agree on price and delivery details together.';

  @override
  String get howToBuyStep3Title => 'Get It Delivered';

  @override
  String get howToBuyStep3Desc => 'Once agreed, receive your item safely.';

  @override
  String get listedToday => 'Listed today';

  @override
  String listedDaysAgo(int days) {
    return 'Listed $days days ago';
  }

  @override
  String listedWeeksAgo(int weeks) {
    return 'Listed $weeks weeks ago';
  }

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmptyTitle => 'No notifications yet';

  @override
  String get notificationsEmptyDesc =>
      'New campaigns and announcements will appear here';

  @override
  String get markAllReadAction => 'Mark all as read';

  @override
  String get clearAllAction => 'Clear all';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours hr ago';
  }

  @override
  String timeDaysAgoGeneric(int days) {
    return '$days days ago';
  }

  @override
  String get catalogCategoryTitleSofa => 'Sofa & Couch';

  @override
  String get catalogCategoryTitleChair => 'Chair & Armchair';

  @override
  String get catalogCategoryTitleTable => 'Dining Table';

  @override
  String get catalogCategoryTitleBed => 'Bed & Base';

  @override
  String get catalogCategoryTitleWardrobe => 'Wardrobe & Cabinet';

  @override
  String get catalogCategoryTitleWhite => 'Appliances';

  @override
  String get catalogCategoryTitleOther => 'Decor';

  @override
  String get mottoTitlePart1 => 'See Before You Come, ';

  @override
  String get mottoTitlePart2 => 'Come When You Like It.';

  @override
  String get mottoSubtitle =>
      'Browse our showcase before visiting the shop, then drop by once you\'ve found what you like.';

  @override
  String get gatewayNewEyebrow => 'NEW COLLECTION';

  @override
  String get gatewayNewTitle => 'Timeless Pieces';

  @override
  String get gatewayNewSubtitle => 'Brand-new, never-used furniture.';

  @override
  String get gatewayNewButton => 'View Collection';

  @override
  String get gatewaySpotEyebrow => 'SPOT DEALS';

  @override
  String get gatewaySpotTitle => 'Used, But Solid';

  @override
  String get gatewaySpotSubtitle =>
      'Secondhand but practical, at wallet-friendly prices.';

  @override
  String get gatewaySpotButton => 'View Deals';

  @override
  String freeDeliveryZonesNote(String zones) {
    return 'Free delivery is only available in $zones';
  }

  @override
  String get footerWarehouseTagline =>
      'FURNITURE WAREHOUSE · İÇERENKÖY / ATAŞEHİR';

  @override
  String get locationAndHoursLabel => 'LOCATION & HOURS';

  @override
  String get openNowLabel => 'OPEN NOW';

  @override
  String get closedNowLabel => 'CLOSED NOW';

  @override
  String todayHoursPrefix(String hours) {
    return '· Today $hours';
  }

  @override
  String get openInMapsButton => 'Open in Maps';

  @override
  String get viewOnGoogleMapsButton => 'View on Google Maps';

  @override
  String gatewayProductCount(int count) {
    return '$count products';
  }

  @override
  String get gatewayNewEyebrowShort => 'NEW';

  @override
  String get gatewayNewTitleShort => 'Collection';

  @override
  String get gatewaySpotEyebrowShort => 'SPOT';

  @override
  String get gatewaySpotTitleShort => 'Deals';

  @override
  String get spotHeroEyebrow => 'DEAL WAREHOUSE';

  @override
  String get spotHeroSubtitle =>
      'Used but practical. Like-new items for every budget. Room to negotiate.';

  @override
  String spotHeroDealCount(int count) {
    return '$count+ Deals';
  }

  @override
  String get spotStatNegotiable => 'Room to Negotiate';

  @override
  String get spotStatUsed => 'Used';

  @override
  String get spotShowcaseBadgeTitle => 'Fully Refurbished';

  @override
  String get spotShowcaseBadgeSubtitle =>
      'Every item is individually checked before delivery.';

  @override
  String get spotBreadcrumbLabel => 'Spot & Secondhand';

  @override
  String get aphorismEyebrow => 'WE HAVE A SAYING';

  @override
  String get aphorismQuote =>
      'Not worn out, well-loved.\nGood furniture never gets old — it just changes homes.';

  @override
  String get aphorismBody =>
      'That\'s exactly why we\'re here: to bring pieces that still have life left in them to a new home that will value them.';

  @override
  String get spotSearchHint => 'Search deals...';

  @override
  String get priceRangeLabel => 'Price Range';

  @override
  String get filtersSheetTitle => 'FILTERS';

  @override
  String get applyFiltersButton => 'Apply Filters';

  @override
  String get priceRangeSheetTitle => 'PRICE RANGE';

  @override
  String get applyButton => 'Apply';

  @override
  String get sortSheetTitle => 'SORT';

  @override
  String get sortNewest => 'Newest Deals';

  @override
  String get sortPopular => 'Most Viewed';

  @override
  String get spotEmptyStateTitle => 'We couldn\'t find deals matching this';

  @override
  String get spotEmptyStateSubtitle =>
      'Try clearing the filters or a different category.';

  @override
  String get newHeroTitleLine1 => 'For Your Living Space\n';

  @override
  String get newHeroTitleEmphasis => 'Timeless ';

  @override
  String get newHeroButtonCollection => 'Browse Collection';

  @override
  String get newHeroButtonQuickFilter => 'Quick Filter';

  @override
  String get newStatActiveProductLabel => 'ACTIVE PRODUCTS';

  @override
  String get newStatControlledStockLabel => 'QUALITY-CHECKED STOCK';

  @override
  String get shopByCategoryTitlePrefix => 'Shop by ';

  @override
  String get shopByCategoryTitleEmphasis => 'Explore';

  @override
  String get showAllButton => 'Show All';

  @override
  String get newEmptyStateTitle => 'No Furniture Found Matching Your Search';

  @override
  String get newEmptyStateSubtitle =>
      'Try changing your search term or clearing the filters.';

  @override
  String get sortOptionsSheetTitle => 'Sort Options';

  @override
  String get newSortNewest => 'Newest';

  @override
  String get newSortPopular => 'Most Viewed';

  @override
  String get cartWhatsappGreeting =>
      'Hello, I\'d like some information about these products:\n\n';

  @override
  String cartWhatsappAllProductsLine(String url) {
    return 'All products: $url';
  }

  @override
  String get defaultWhatsappGreeting =>
      'Hello, I\'d like some information about the furniture.';

  @override
  String get spotHeroPageTitle => 'Secondhand & Spot';

  @override
  String get sortByPriceLowHigh => 'Price: Low to High';

  @override
  String get sortByPriceHighLow => 'Price: High to Low';
}

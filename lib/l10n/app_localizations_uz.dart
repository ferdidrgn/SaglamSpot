// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get brand => 'SAĞLAM SPOT';

  @override
  String get home => 'Bosh sahifa';

  @override
  String get searchHint => 'Uyingiz uchun nima izlayapsiz?...';

  @override
  String get collection => 'KOLLEKSIYA';

  @override
  String get eleganceAndComfort => 'Nafislik va qulaylik';

  @override
  String productsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mahsulot topildi',
      one: '1 mahsulot topildi',
      zero: 'Mahsulot topilmadi',
    );
    return '$_temp0';
  }

  @override
  String resultsFor(String query) {
    return '«$query» uchun natijalar';
  }

  @override
  String get seoHomeTitle => 'Sağlam Spot | Ishlatilgan va yangi mebel';

  @override
  String get seoHomeDesc =>
      'Ishlatilgan va yangi mebelda eng maqbul narxlar. 20 yillik biznes kafolati bilan.';

  @override
  String get seoNewTitle => 'Yangi mahsulotlar | Sağlam Spot';

  @override
  String get seoNewDesc => 'Kafolatlangan va sifatli yangi mebel kolleksiyasi.';

  @override
  String get seoSpotTitle => 'Ishlatilgan mahsulotlar | Sağlam Spot';

  @override
  String get seoSpotDesc =>
      'Iqtisodiy va sifatli ishlatilgan mebel variantlari.';

  @override
  String get seoAboutTitle => 'Biz haqimizda | Sağlam Spot';

  @override
  String get seoAboutDesc =>
      '20 yillik tajribamiz bilan mebel sohasida ishonch manzili.';

  @override
  String get seoProductDetailSuffix => 'Mahsulotni ko\'rish | Sağlam Spot';

  @override
  String get category => 'Toifa';

  @override
  String get categorySofa => 'O\'tirish to\'plamlari';

  @override
  String get categoryChair => 'Stul';

  @override
  String get categoryTable => 'Stol';

  @override
  String get categoryBed => 'Yotoqxona';

  @override
  String get categoryWardrobe => 'Shkaf';

  @override
  String get categoryWhite => 'Maishiy texnika';

  @override
  String get categoryOther => 'Boshqa';

  @override
  String get condition => 'Holati';

  @override
  String get conditionAll => 'Barchasi';

  @override
  String get conditionNew => 'Yangi';

  @override
  String get conditionUsed => 'Ishlatilgan';

  @override
  String get priceRange => 'Narx oralig\'i';

  @override
  String get price => 'Narx';

  @override
  String get save => 'Saqlash';

  @override
  String get explanation => 'Tavsif';

  @override
  String get clear => 'Tozalash';

  @override
  String get filter => 'Filtrlash';

  @override
  String get apply => 'Qo\'llash';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get newSeason => 'YANGI MAVSUM';

  @override
  String get heroTitle => 'Minimalist\nQulaylik cho\'qqisi';

  @override
  String get viewCollection => 'KOLLEKSIYANI KO\'RISH';

  @override
  String get featureArtisan => 'Samimiy hunarmandchilik';

  @override
  String get featureDelivery => 'Xavfsiz yetkazib berish';

  @override
  String get featureService => 'Do\'stona xizmat';

  @override
  String get featureShipping => 'Tezkor yetkazib berish';

  @override
  String get quickOptions => 'Tezkor variantlar';

  @override
  String get easyFind => 'Qidirgan mahsulotingizni oson toping';

  @override
  String get mottoBrand => 'Eskini yangilaydi, yangini qadrlaydi';

  @override
  String get newCollection => 'Yangi kolleksiya';

  @override
  String get newCollectionSub => 'Eng so\'nggi mahsulotlar';

  @override
  String get spotProducts => 'Ishlatilgan mahsulotlar';

  @override
  String get spotProductsSub => 'Chegirmali mahsulotlar';

  @override
  String get spotProductsDesc => 'Sifatli mahsulotlarda ajoyib narxlar';

  @override
  String get currentCollection => 'HOZIRGI KOLLEKSIYA';

  @override
  String get soldProducts => 'SOTILGAN MAHSULOTLAR';

  @override
  String pieces(int count) {
    return '$count Dona';
  }

  @override
  String get stock => 'OMBORDA';

  @override
  String get sold => 'SOTILDI';

  @override
  String get byRoom => 'Xona bo\'yicha';

  @override
  String get byRoomSub => 'Uyingizning har bir burchagi uchun maxsus tanlovlar';

  @override
  String get roomLivingRoom => 'Mehmonxona';

  @override
  String get roomLivingRoomSub => 'Qulaylik markazi';

  @override
  String get roomBedroom => 'Yotoqxona';

  @override
  String get roomBedroomSub => 'Tinch uyqu';

  @override
  String get roomKitchen => 'Oshxona';

  @override
  String get roomKitchenSub => 'Amaliy yechimlar';

  @override
  String get roomOffice => 'Ofis';

  @override
  String get roomOfficeSub => 'Samarali ish';

  @override
  String get whoWeAre => 'BIZ KIMMIZ?';

  @override
  String get artisanTitle =>
      '20 yillik samimiy hunarmandchilik,\nzamonaviy xizmat.';

  @override
  String get artisanDesc =>
      'Do\'konimizga tashrif buyuring, choy ichamiz; sizga eng mos mebelni birgalikda tanlaymiz.';

  @override
  String get visitUsButton => 'BIZGA TASHRIF BUYURING';

  @override
  String get statHappyCustomer => 'Mamnun mijoz';

  @override
  String get statExperience => 'Tajriba';

  @override
  String get statDelivery => 'Yetkazib berish';

  @override
  String get statTrust => 'Ishonch';

  @override
  String get explore => 'KO\'RIB CHIQISH';

  @override
  String get collections => 'Kolleksiyalar';

  @override
  String get corporate => 'KORXONA';

  @override
  String get aboutUs => 'Biz haqimizda';

  @override
  String get contact => 'Aloqa';

  @override
  String get contactUs => 'BIZ BILAN BOG\'LANING';

  @override
  String get sss => 'Ko\'p so\'raladigan savollar';

  @override
  String get qualityFurniture => '\'Sifatli mebel manzili — Sağlam Spot\'';

  @override
  String get footerDesc =>
      '20 yildan ortiq tajribamiz bilan Istanbulning har bir nuqtasiga sifat va ishonch olib kelamiz.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT TİCARET. BARCHA HUQUQLAR HIMOYALANGAN.';

  @override
  String get errorOccurred => 'Xatolik yuz berdi';

  @override
  String get productNotFound => 'Mahsulot topilmadi';

  @override
  String get noImages => 'Rasm yo\'q';

  @override
  String get error_check_connection => 'Internet aloqangizni tekshiring.';

  @override
  String get error_server_no_response => 'Server hozircha javob bermayapti.';

  @override
  String get error_connection => 'Ulanish xatosi';

  @override
  String get error_connection_lost => 'Ulanish uzildi';

  @override
  String get status_waiting_connection => 'Ulanish kutilmoqda...';

  @override
  String get error_no_internet_auto_retry =>
      'Internet aloqasi yo\'q.\nUlanish tiklanganda avtomatik davom etadi.';

  @override
  String get goBack => 'Orqaga qaytish';

  @override
  String get galleryEmpty => 'Galereya bo\'sh';

  @override
  String get month_1 => 'Yanvar';

  @override
  String get month_2 => 'Fevral';

  @override
  String get month_3 => 'Mart';

  @override
  String get month_4 => 'Aprel';

  @override
  String get month_5 => 'May';

  @override
  String get month_6 => 'Iyun';

  @override
  String get month_7 => 'Iyul';

  @override
  String get month_8 => 'Avgust';

  @override
  String get month_9 => 'Sentabr';

  @override
  String get month_10 => 'Oktabr';

  @override
  String get month_11 => 'Noyabr';

  @override
  String get month_12 => 'Dekabr';

  @override
  String get noProductFoundTitle => 'Bu mezonlarda mahsulot topilmadi';

  @override
  String get noProductFoundDescription =>
      'Boshqa filtrlarni sinab ko\'ring yoki qidiruv so\'zini o\'zgartiring';

  @override
  String get adminPanelTitle => 'Boshqaruv paneli';

  @override
  String get totalCount => 'Jami';

  @override
  String get productAddedSuccess => 'Mahsulot muvaffaqiyatli qo\'shildi';

  @override
  String get authOrConnectionError => 'Ruxsat yoki ulanish xatosi yuz berdi';

  @override
  String get fillRequiredFields =>
      'Mahsulot nomi, narxi va kamida bitta rasm qo\'shing!';

  @override
  String get sessionClosed => 'Sessiya yopiq';

  @override
  String get addNewProduct => 'Yangi mahsulot qo\'shish';

  @override
  String get productImages => 'Mahsulot rasmlari';

  @override
  String get generalInfo => 'Umumiy ma\'lumot';

  @override
  String get productNameLabel => 'Mahsulot nomi';

  @override
  String get descriptionLabel => 'Tavsif';

  @override
  String get statusLabel => 'Holat';

  @override
  String get spotSecondHand => 'Spot / Ishlatilgan';

  @override
  String get secondHandHint =>
      'Yagona nusxa — rang variantlari ko\'rsatilmaydi';

  @override
  String get newProductHint =>
      'Yangi mahsulot — rang variantlarini qo\'shishingiz mumkin';

  @override
  String get colorOptionsOptional => 'Rang variantlari (ixtiyoriy)';

  @override
  String get noImagesYet => 'Hali rasm qo\'shilmagan';

  @override
  String get addImage => 'Rasm qo\'shish';

  @override
  String get editProductTitle => 'Mahsulotni tahrirlash';

  @override
  String get changeImages => 'Rasmlarni o\'zgartirish';

  @override
  String get saveChanges => 'O\'zgarishlarni saqlash';

  @override
  String get deleteProductTitle => 'Mahsulotni o\'chirish';

  @override
  String get deleteProductConfirmSuffix =>
      'o\'chiriladi. Ishonchingiz komilmi?';

  @override
  String get yesDelete => 'Ha, o\'chirish';

  @override
  String get emptyCategoryProducts => 'Bu toifada mahsulot topilmadi';

  @override
  String get adminLoginSubtitle => 'Boshqaruv paneliga kirish';

  @override
  String get emailLabel => 'Elektron pochta';

  @override
  String get passwordLabel => 'Parol';

  @override
  String get loginButton => 'Kirish';

  @override
  String get sponsored => 'Reklama';

  @override
  String get addProductFab => 'Mahsulot qo\'shish';

  @override
  String get singlePieceNotice =>
      'Bu ishlatilgan/spot mahsulot — omborda faqat bitta nusxa mavjud, rang va ko\'rinish rasmlardagi bilan bir xil.';

  @override
  String get colorOptionsTitle => 'Rang variantlari';

  @override
  String get newProductBadge => 'YANGI MAHSULOT';

  @override
  String get usedProductBadge => 'ISHLATILGAN';

  @override
  String get readMore => 'Davomini o\'qish';

  @override
  String get readLess => 'Kamroq ko\'rsatish';

  @override
  String get specDelivery => 'Yetkazib berish';

  @override
  String get specDeliveryValue => '1-2 kun ichida';

  @override
  String get specLocation => 'Joylashuv';

  @override
  String get sellerTrustLine =>
      '20 yillik ishonchli mahalliy biznes · İçerenköy';

  @override
  String get whatsappCta => 'WhatsApp orqali yozish';

  @override
  String get callCta => 'Qo\'ng\'iroq qilish';

  @override
  String get similarProducts => 'O\'xshash mahsulotlar';

  @override
  String get conditionShowcase => 'Ko\'rgazma';

  @override
  String get productDescriptionTitle => 'Tavsif';

  @override
  String get loginBrand => 'Sağlam Spot';

  @override
  String get logout => 'Chiqish';

  @override
  String get logoutConfirm =>
      'Hisobingizdan xavfsiz chiqishga ishonchingiz komilmi?';
}

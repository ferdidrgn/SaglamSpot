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

  @override
  String get testimonialsHeading => 'Mijozlarimiz Nima Deydi';

  @override
  String get testimonialsSubheading =>
      '20 yildan ortiq vaqt davomida İçerenköy va atrofidagi minglab uylarga qo\'l tekkizdik';

  @override
  String get testimonial1Comment =>
      'Divan to\'plamini juda qulay narxda oldik, deyarli yangidek. Yetkazib berish o\'sha kuniyoq qo\'ldan-qo\'lga bo\'ldi, haqiqiy hunarmand ishonchi boshidanoq sezildi.';

  @override
  String get testimonial2Comment =>
      'Yotoqxona to\'plamini shu yerdan aksiya narxida sotib oldim. Mahsulot tavsifiga aynan mos keldi, hech qanday kutilmagan narsa bo\'lmadi. Albatta tavsiya qilaman.';

  @override
  String get testimonial3Comment =>
      'Ofisimiz uchun ko\'p miqdorda mebel sotib oldik, narx ham, sifat ham kutganimizdan yaxshiroq bo\'ldi. G\'amxo\'r, sabrli jamoa — rahmat, Sağlam Spot.';

  @override
  String get testimonial4Comment =>
      'Ovqat stoli to\'plamini savdolashmasdan, halol narxda sotib oldik. Tashishda ham yordam berishdi, xotirjam xarid qildik.';

  @override
  String get testimonial5Comment =>
      'Ishlatilgan kiyim shkafi qidirayotgan edik, mustahkam va zamonaviy narsa topdik. Bozordagi eng yaxshi narx-sifat nisbati edi.';

  @override
  String get testimonial6Comment =>
      'Ko\'rgazma zaliga tashrif chog\'ida mahsulotlarni jonli ko\'rishga muvaffaq bo\'ldik, bu ishonchimizni yanada mustahkamladi. Sotuvdan keyin ham doim aloqada bo\'lishdi.';

  @override
  String get howItWorksHeading => 'Qanday Ishlaydi';

  @override
  String get step1Title => 'Ko\'rib Chiqing va Saralang';

  @override
  String get step1Desc =>
      'Kategoriya va narx oralig\'i bo\'yicha minglab mahsulotlar orasidan yoqqanini toping.';

  @override
  String get step2Title => 'Biz Bilan Bog\'laning';

  @override
  String get step2Desc =>
      'Mahsulot sahifasidan to\'g\'ridan-to\'g\'ri WhatsApp yoki telefon orqali jamoamiz bilan bog\'laning.';

  @override
  String get step3Title => 'Narxni Aniqlashtiring';

  @override
  String get step3Desc =>
      'Ko\'rgazma zalida ko\'ring yoki suratlar bilan tasdiqlang, adolatli narxga kelishing.';

  @override
  String get step4Title => 'Eshigingizga Yetkazib Berish';

  @override
  String get step4Desc =>
      'İçerenköy va Anadolu tomoniga tez, sug\'urtalangan tashish mebelingizni xavfsiz uyingizga yetkazadi.';

  @override
  String get tipsEyebrow => 'MASLAHATLAR';

  @override
  String get tipsHeading => 'Mutaxassisdan Parvarish Maslahatlari';

  @override
  String get tip1Title => 'Mehmonxonangizni Yoqimliroq Qiling';

  @override
  String get tip1Desc =>
      'Divan bilan devor orasida 1-2 sm bo\'shliq qoldiring — bu havo aylanishini yaxshilaydi va xonani kengroq ko\'rsatadi.';

  @override
  String get tip1Category => 'Joylashtirish';

  @override
  String get tip2Title => 'Har Doim Toza Ko\'rinadigan Ish Stoli';

  @override
  String get tip2Desc =>
      'Kabellarni tartibga soluvchilar bilan tartibga soling va mikrofibrali mato bilan aylanma harakatlar bilan artib turing — stolingiz doim yangidek qoladi.';

  @override
  String get tip2Category => 'Tozalik';

  @override
  String get tip3Title => 'Qulay Oshxona Tartibi';

  @override
  String get tip3Desc =>
      'Og\'ir buyumlarni pastki javonlarga, tez-tez ishlatiladiganlarini ko\'z darajasiga joylashtiring — ham qulay, ham xavfsiz.';

  @override
  String get tip3Category => 'Tashkil etish';

  @override
  String get tip4Title => 'Qulay Uyqu Burchagini Tashkil Qiling';

  @override
  String get tip4Desc =>
      'Karavot boshini derazadan uzoqroqqa, yorug\'likni kamaytiradigan tarzda joylashtiring — chuqurroq uyqu uchun kichik, lekin samarali o\'zgarish.';

  @override
  String get tip4Category => 'Qulaylik';

  @override
  String get tip5Title => 'Shkafingizni Yangilang';

  @override
  String get tip5Desc =>
      'Mavsumiy kiyimlarni ajratib qo\'ying, ilgichlarni bir yo\'nalishda osing — joy tejaydi va har kuni tanlashni osonlashtiradi.';

  @override
  String get tip5Category => 'Tashkil etish';

  @override
  String get tip6Title => 'Yog\'och Mebelingizga Umr Qo\'shing';

  @override
  String get tip6Desc =>
      'To\'g\'ridan-to\'g\'ri quyosh nuridan himoya qiling, yiliga bir necha marta ozuqali moy bilan arting — chiziqlar va rangi o\'chishiga qarshi eng samarali parvarish.';

  @override
  String get tip6Category => 'Parvarish';

  @override
  String get tip7Title => 'Mato Divanlarni Uzoq Umr Ko\'radigan Qiling';

  @override
  String get tip7Desc =>
      'Haftasiga bir marta changyutgich bilan tozalang, dog\'larni darhol nam mato bilan artib tashlang — kutish dog\'ning matoga singishiga sabab bo\'ladi.';

  @override
  String get tip7Category => 'Parvarish';

  @override
  String get tip8Title => 'To\'g\'ri Yoritishni Tanlang';

  @override
  String get tip8Desc =>
      'Bitta shift chirog\'i o\'rniga qatlamli yoritishdan foydalaning: umumiy, vazifaviy va muhit yorug\'ligi birgalikda xonani yanada issiqroq ko\'rsatadi.';

  @override
  String get tip8Category => 'Yoritish';

  @override
  String get tip9Title => 'Kichik Joylardan Aqlli Foydalaning';

  @override
  String get tip9Desc =>
      'Yig\'iladigan, ko\'p maqsadli mebellarni tanlang; devorga o\'rnatilgan javonlar yer maydonini bo\'shatadi.';

  @override
  String get tip9Category => 'Tashkil etish';

  @override
  String get tip10Title => 'Balkoningizni Yashash Maydoniga Aylantiring';

  @override
  String get tip10Desc =>
      'Ob-havoga chidamli o\'tirish to\'plami va bir necha guldon o\'simliklari balkonni uyning eng sevimli burchagiga aylantiradi.';

  @override
  String get tip10Category => 'Tashqi maydon';

  @override
  String get popularCategoriesHeading => 'Mashhur Toifalar';

  @override
  String get popularCategoriesSub => 'Sizga mos mebelni bir bosishda toping';

  @override
  String categoryProductCount(int count) {
    return '$count mahsulot';
  }

  @override
  String get newsletterSubscribeSuccess =>
      'Siz bulletinimizga muvaffaqiyatli obuna bo\'ldingiz!';

  @override
  String get newsletterHeading =>
      'Yangi Mahsulotlar Haqida Birinchi Bo\'lib Biling';

  @override
  String get newsletterDesc =>
      'Aksiya takliflari, yangi kolleksiyalar va kampaniyalar to\'g\'ridan-to\'g\'ri elektron pochtangizga kelsin. Spam yo\'q, faqat foydali takliflar.';

  @override
  String get emailHint => 'Elektron pochta manzilingiz';

  @override
  String get emailRequired => 'Elektron pochta talab qilinadi';

  @override
  String get emailInvalid => 'Haqiqiy elektron pochta manzilini kiriting';

  @override
  String get whyUsHeading => 'Nega Sağlam Spot?';

  @override
  String get usp1Title => '20 Yillik Ishonchli Hunarmandchilik';

  @override
  String get usp1Desc =>
      'İçerenköy\'da yigirma yildan ortiq hunarmandchilik tajribasi va minglab mamnun mijozlar.';

  @override
  String get usp2Title => 'Bozordan Past Narxlar';

  @override
  String get usp2Desc =>
      'Vositachilarsiz ish modelimiz bilan aksiya va yangi mebelda eng qulay narxlar bizda.';

  @override
  String get usp3Title => 'Tekshirilgan Mahsulot Sifati';

  @override
  String get usp3Desc =>
      'Har bir mahsulot sotuvga chiqishdan oldin tuzilishi va mato/qoplama tekshiruvidan o\'tadi.';

  @override
  String get usp4Title => 'Sotuvdan Keyingi Yordam';

  @override
  String get usp4Desc =>
      'Yetkazib berishdan keyin ham murojaat qilishingiz mumkin bo\'lgan, muammoingizni hal qiladigan haqiqiy jamoa.';

  @override
  String get socialShowcaseEyebrow => 'ULASHING';

  @override
  String get socialShowcaseHeading => 'Uyingizni #SağlamSpot Bilan Ulashing';

  @override
  String productsLoadError(String error) {
    return 'Mahsulotlarni yuklashda xatolik yuz berdi: $error';
  }

  @override
  String get viewAllButton => 'Barchasini Ko\'rish';

  @override
  String get showcaseEyebrow => 'VITRINA';

  @override
  String get exploreButton => 'Kashf Eting';

  @override
  String get visitUsEyebrow => 'BIZGA TASHRIF BUYURING';

  @override
  String get visitUsHeading => 'Shunchaki Salom Bering';

  @override
  String visitUsOpenLine(String hours) {
    return 'Eshigimiz doim ochiq. $hours';
  }

  @override
  String get directionsButton => 'Yo\'nalishni Olish';

  @override
  String get freeDeliveryLabel => 'Bepul Yetkazib Berish';

  @override
  String get busLinesLabel => 'Avtobus Yo\'nalishlari';

  @override
  String get statYearsSuffix => '+ Yil';

  @override
  String get storeAddress => 'İçerenköy, Ataşehir/İstanbul';

  @override
  String get stayUpdated => 'Yangiliklardan Xabardor Bo\'ling';

  @override
  String get viewButton => 'Ko\'rish';

  @override
  String get heroSlide2Eyebrow => 'IKKINCHI QO\'L';

  @override
  String get heroSlide2Title => 'O\'z Hikoyasi Bor Mebel';

  @override
  String get heroSlide2Subtitle =>
      'Diqqat bilan tanlangan, mustahkam va xarakterli ishlatilgan buyumlar.';

  @override
  String get heroSlide3Title => 'Butun Kolleksiyani Kashf Eting';

  @override
  String get aboutBadge => '2012-YILDAN BERI SIZLAR BILAN';

  @override
  String get aboutHeroTitle => 'Sağlam Spot\nSiz Biladigan Ishonch';

  @override
  String get aboutHeroSubtitle =>
      'Biz mahallamizga qilgan har bir ishimizda sevgi va g\'amxo\'rlik bilan xizmat qilamiz.';

  @override
  String get aboutStoryHeading => 'Biz Kimmiz? (Bizning Hikoyamiz)';

  @override
  String get aboutStoryPara1 =>
      'Maqsadimiz — uyingizga issiqlik qo\'shadigan, sifatli va chindan ham yoqadigan mebellarni topishga yordam berish. Turar joyingizni chiroyli qilish bizning ishimiz.';

  @override
  String get aboutStoryPara2 =>
      'Hammasi 2012-yilda, İçerenköy\'dagi aynan shu do\'konda boshlandi. O\'shandan beri mehmon bo\'lgan uylarimiz soni yanada ko\'paydi.';

  @override
  String get aboutStoryPara3 =>
      'Bugun, ham yangi, ham diqqat bilan tanlangan ishlatilgan mahsulotlarimiz bilan minglab qo\'shnilarimizning uyiga mehmon bo\'ldik. Sizning ishonchingiz bilan o\'sib boramiz.';

  @override
  String get aboutStoryStartLabel => 'Boshlanishi';

  @override
  String get aboutStoryExperienceLabel => 'Yillik Tajriba';

  @override
  String get aboutStorySmilesLabel => 'Mamnun Yuzlar';

  @override
  String get aboutValuesHeading => 'Bizning Tamoyillarimiz';

  @override
  String get aboutValuesSubheading =>
      'Hunarmandchilikda hech qachon murosaga bormaydigan tamoyillarimiz';

  @override
  String get aboutValue1Title => 'Sifat va Diqqat';

  @override
  String get aboutValue1Desc =>
      'Yangi bo\'lsin, ishlatilgan bo\'lsin, uni diqqat bilan tanlab, sizga aynan shunday taqdim etamiz.';

  @override
  String get aboutValue2Title => 'Mamnun Yuzlar';

  @override
  String get aboutValue2Desc =>
      'Biz uchun eng katta yutuq — do\'kondan mamnun bo\'lib ketayotgan qo\'shni. Sizning mamnuningiz hamma narsadan oldin keladi.';

  @override
  String get aboutValue3Title => 'Mehnatga Hurmat';

  @override
  String get aboutValue3Desc =>
      'Mebel — qadrli mehnat. Ishlatilgan mahsulotlarga yangi hayot berish orqali biz ham byudjetingizni, ham tabiatni asraymiz.';

  @override
  String get aboutValue4Title => 'Halollik va Ishonch';

  @override
  String get aboutValue4Desc =>
      'Shaffof, halol hunarmandchilik bizning eng katta qadriyatimiz. Yillar davomida siz bilan bir joyda birgamiz.';

  @override
  String get aboutMasterHeading => 'Ustamiz Bilan Tanishing';

  @override
  String get aboutMasterBody =>
      'Ustamiz 1995-yildan beri, ya\'ni chorak asrdan ortiq vaqtdan beri bu sohada faol ishlab kelmoqda. Yetakchi brendlarda (İstikbal) ishlab, mebelning xususiyatlari, qismlari va nozik jihatlari haqida chuqur bilim olgan.\n\nYetkazib berish uchun haydovchilikdan tortib yig\'ish, mijozlarni kutib olishdan tortib tashishgacha har bir sohada bevosita ishlab, to\'liq tajriba orttirgan. 2012-yilda esa \'endi o\'z do\'konim\' deb qaror qilib, bu tajribasini Sağlam Spot\'ga olib kelgan.\n\nUning maqsadi — o\'sha katta kompaniyalarda o\'rgangan sifatni mahalla hunarmandchiligining samimiyligi va diqqati bilan birlashtirib, sizga eng yaxshi xizmatni taqdim etish.';

  @override
  String get aboutDeliveryHeading => 'Yetkazib Berish va Yig\'ish Xizmatimiz';

  @override
  String get aboutDeliveryFreeTitle => 'Bepul Yetkazib Berish va Yig\'ish';

  @override
  String get aboutDeliveryZonesLabel =>
      'Bepul Xizmat Ko\'rsatiladigan Hududlarimiz:';

  @override
  String get aboutDeliveryZonesList =>
      '• Mahallamiz İçerenköy\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• İnönü va Bostancı Sanayi kabi yaqin qo\'shnilar';

  @override
  String get aboutDeliveryNote =>
      'Muhim Eslatma: Ustamizning sog\'lig\'ini himoya qilish uchun, liftsiz binolarda yuqori qavatlarga afsuski buyumlarni ko\'tarib bera olmaymiz. Tushunganingiz uchun rahmat.';

  @override
  String get aboutDeliveryPunctual =>
      '⏰ Siz bilan kelishilgan vaqtda eshigingizdamiz!';

  @override
  String get aboutTransportHeading => 'Do\'konimizga Qanday Yetib Kelasiz';

  @override
  String get aboutTransportBusIntro => 'Avtobusda Kelsangiz:';

  @override
  String get aboutBusStop1 => 'Ziyapaşa Bekati (Kadıköy Tomon):';

  @override
  String get aboutBusStop2 => 'İçerenköy Bekati (Kayışdağı Tomon):';

  @override
  String get aboutBusStop3 => 'İçerenköy Bekati (Yeniyol):';

  @override
  String get aboutContactPhoneLabel => 'Telefon (Tezkor Yechim)';

  @override
  String get aboutContactAddressLabel => 'Manzil (Choy Uchun Kutamiz)';

  @override
  String get aboutContactAddressValue =>
      'İçerenköy Mahallesi\nBuket Sokak No:6';

  @override
  String get aboutContactHoursLabel => 'Ish Vaqtimiz';

  @override
  String get aboutContactHoursValue =>
      'Dush-Shan: 09:00 - 22:00\nYaksh: 10:00 - 20:00';

  @override
  String get aboutContactHeading => 'Biz Bilan Bog\'laning';

  @override
  String get aboutCallNowButton => 'Hozir Qo\'ng\'iroq Qiling';

  @override
  String get aboutViewMapButton => 'Xaritada Ko\'rish';

  @override
  String get aboutMapHeading => 'Do\'konimiz Aynan Shu Yerda';

  @override
  String get aboutMapSubtext => 'Yo\'nalish olish uchun xaritaga bosing';

  @override
  String get newProductsBadgeEyebrow => 'YANGI KOLLEKSIYA';

  @override
  String get newProductsTitle => 'Yangi\nKolleksiya';

  @override
  String get productsBadgeLabel => 'MAHSULOT';

  @override
  String get breadcrumbHome => 'Bosh Sahifa';

  @override
  String get statTotalProducts => 'JAMI MAHSULOT';

  @override
  String get statCategoryLabel => 'TOIFALAR';

  @override
  String get statConditionValueNew => 'YANGI';

  @override
  String get statConditionLabel => 'HOLAT';

  @override
  String get statRatingLabel => 'REYTING';

  @override
  String get searchBarRichPrefix => 'Batafsil mahsulot qidiruvi uchun ';

  @override
  String get searchBarRichOr => ' bosing yoki ';

  @override
  String get searchBarRichHereLink => 'BU YERGA';

  @override
  String get searchBarRichSuffix => ' bosing.';

  @override
  String get sortNewProductsDefault => 'Yangilar';

  @override
  String get sortSpotProductsDefault => 'Eng Yangi';

  @override
  String get sortPriceLowHigh => 'Narx: O\'sish Bo\'yicha';

  @override
  String get sortPriceHighLow => 'Narx: Kamayish Bo\'yicha';

  @override
  String get sortMostPopular => 'Eng Mashhur';

  @override
  String get spotBadgeEyebrow => 'AKSIYA MAHSULOTLARI';

  @override
  String get spotHeroTitle => 'Aksiya\nMahsulotlari';

  @override
  String get spotDiscountLabel => 'CHEGIRMA';

  @override
  String get statSpotProductLabel => 'Aksiya Mahsuloti';

  @override
  String get statDiscountLabel => 'Chegirma';

  @override
  String get statSupportLabel => 'Yordam';

  @override
  String get statFreeLabel => 'Bepul';

  @override
  String get statFreeShippingNote => 'Faqat Yaqin Hududlar Uchun, Yetkazish';

  @override
  String get statFreeShippingShort => 'Yetkazish';

  @override
  String get filtersPanelTitle => 'FILTRLAR';

  @override
  String get dragToRotateHint => 'Boshqa fotolar uchun torting';

  @override
  String get studioQuotaExceededNotice =>
      'Oylik studiya rasm limiti to\'ldi — fotolar asl holida qo\'shildi.';

  @override
  String get studioPreparingWait => 'Studiya rasmi tayyorlanmoqda, kuting...';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get studioGenerationFailed => 'Studiya rasmini yaratib bo\'lmadi';

  @override
  String get storePhotoLabel => 'Do\'kon';

  @override
  String get studioPhotoLabel => 'Studiya';

  @override
  String get onboardingSkip => 'O\'tkazib yuborish';

  @override
  String get onboardingStart => 'Boshlash';

  @override
  String get onboardingPage1Eyebrow => 'SAĞLAM SPOT\'GA XUSH KELIBSIZ';

  @override
  String get onboardingPage1Title => 'Uyingiz Uchun\nTo\'g\'ri Manzil';

  @override
  String get onboardingPage1Desc =>
      '20 yildan ortiq tajriba bilan sifatli mebelni cho\'ntagingizga olib kelamiz.';

  @override
  String get onboardingPage2Eyebrow => 'ISHLATILGAN VA YANGI BIRGALIKDA';

  @override
  String get onboardingPage2Title => 'Har Qanday Byudjet\nUchun Variantlar';

  @override
  String get onboardingPage2Desc =>
      'Ajoyib ishlatilgan takliflardan yangi kolleksiyagacha — izlaganingizni osongina toping.';

  @override
  String get onboardingPage3Eyebrow => 'ISHONCH BILAN XARID QILING';

  @override
  String get onboardingPage3Title => 'Yoqdimi?\nHozir Yozing';

  @override
  String get onboardingPage3Desc =>
      'WhatsApp orqali bir bosishda bog\'laning, narxni so\'rang, to\'g\'ridan-to\'g\'ri kelishing.';

  @override
  String get favoritesTitle => 'Sevimlilarim';

  @override
  String get favoritesEmptyTitle => 'Sevimlilar ro\'yxatingiz bo\'sh';

  @override
  String get favoritesEmptyDesc =>
      'Yoqqan mahsulotlarni sevimlilarga qo\'shish uchun yurak belgisiga bosing.';

  @override
  String get sortPanelTitle => 'SARALASH';

  @override
  String get priceRangeSectionTitle => 'NARX ORALIG\'I';

  @override
  String get clearFiltersButton => 'FILTRLARNI TOZALASH';

  @override
  String get tryDifferentFiltersShort =>
      'Boshqa filtrlarni sinab ko\'rishingiz mumkin';

  @override
  String get spotBadgeTag => 'AKSIYA';

  @override
  String productLoadError(String error) {
    return 'Mahsulot yuklanmadi: $error';
  }

  @override
  String get productSpecConditionNew => 'Yangi Mahsulot';

  @override
  String get productLocationValue => 'İçerenköy, İstanbul';

  @override
  String get sortFeatured => 'Tavsiya Etilgan';

  @override
  String get sortPriceAsc => 'Narx: O\'sish Bo\'yicha';

  @override
  String get sortPriceDesc => 'Narx: Kamayish Bo\'yicha';

  @override
  String get languageSelectorTitle => 'Til Tanlash';

  @override
  String get languageTooltip => 'Til';

  @override
  String get galleryEmptyMessage => 'Bu mahsulotga hali rasm qo\'shilmagan.';

  @override
  String get productCardNewBadge => 'YANGI';

  @override
  String get sssHelpCenterBadge => 'YORDAM MARKAZI';

  @override
  String get sssHeroTitle => 'Tez-Tez Beriladigan\nSavollar';

  @override
  String get sssHeroSubtitle => 'Sizni qiziqtirgan hamma narsaga javoblar';

  @override
  String get sssCategoryAll => 'Barchasi';

  @override
  String get sssCategoryGeneral => 'Umumiy';

  @override
  String get sssCategoryProductService => 'Mahsulot va Xizmat';

  @override
  String get sssCategoryDelivery => 'Yetkazib Berish va Yig\'ish';

  @override
  String get sssCategoryPayment => 'To\'lov va Buyurtma';

  @override
  String get sssCategoryReturns => 'Qaytarish va Kafolat';

  @override
  String get sssCategorySecondHandBuying =>
      'Ikkinchi Qo\'l Sotib Olish Jarayoni';

  @override
  String get sssPhoneSupportTitle => 'Telefon Orqali Yordam';

  @override
  String get sssWorkingHoursTitle => 'Ish Vaqti';

  @override
  String get sssWorkingHoursValue => '09:00 - 22:00';

  @override
  String get sssStoreAddressTitle => 'Do\'kon Manzili';

  @override
  String get sssStoreAddressValue => 'İçerenköy Mahallesi Buket Sok. No:6';

  @override
  String get sssNoAnswerTitle => 'Savolingizga Javob Topa Olmadingizmi?';

  @override
  String get sssNoAnswerSubtitle => 'Biz Bilan Bog\'lanishingiz Mumkin';

  @override
  String get sssVisitStoreButton => 'Do\'konga Tashrif Buyuring';

  @override
  String get sssQ1 =>
      'Usta ish faoliyati va tajribasi haqida ma\'lumot bera olasizmi?';

  @override
  String get sssA1 =>
      'Ustamiz 1995-yildan beri bu sohada faol ishlab kelmoqda. Kasbiy faoliyatining birinchi qadamlaridan boshlab doimiy rivojlanish ko\'rsatgan. Ish faoliyati davomida yetkazib berish uchun haydovchilik, tashish, yig\'ish, mijozlarni kutib olish kabi ko\'plab lavozimlarda ishlab, ko\'p qirrali tajriba orttirgan. Xususan, 2010-yilgacha İstikbal\'da ishlagan va bu davrda mahsulotlarning xususiyatlari, qismlari va nozik jihatlari haqida chuqur bilim olgan. 2010-yildan keyin yaqin atrofdagi Işık Çeyiz\'da ishlab, sohadagi mahoratini oshirgan. 2012-yilda o\'z hunarmandchilik do\'konini ochish qarorini qabul qilib, o\'shandan beri sifatli xizmatni birinchi o\'ringa qo\'yib, sohadagi tajribasini mijozlariga eng yaxshi tarzda yetkazishga intilgan.';

  @override
  String get sssQ2 => 'Sağlam Spot ishonchlimi?';

  @override
  String get sssA2 =>
      '2012-yildan beri İçerenköy\'da qo\'shnilarimizga xizmat ko\'rsatib kelmoqdamiz. Son-sanoqsiz uylarga mehmon bo\'ldik va hozir ham bo\'lishda davom etyapmiz.';

  @override
  String get sssQ3 =>
      'Mahsulotlarni ko\'rish uchun do\'koningizga kela olamanmi?';

  @override
  String get sssA3 =>
      'Albatta! Hatto buni alohida tavsiya qilamiz. Choy ichib turib mahsulotlarni jonli ko\'rish, ushlab ko\'rish va yoqadimi-yo\'qmi his qilish eng to\'g\'risi. İçerenköy mahallasidagi do\'konimizda sizni har doim kutamiz.';

  @override
  String get sssQ4 => 'Ishlatilgan mahsulotlarning holati qanday tekshiriladi?';

  @override
  String get sssA4 =>
      'Biz uchun ishlatilgan degani \'ikkinchi darajali sifat\' degani emas. Har bir mahsulot ustamizning diqqatli tekshiruvidan o\'tadi; tozalash, parvarish va zarur ta\'mirlash to\'liq amalga oshiriladi. Rasmlarda ko\'rganingiz — olganingiz, lekin biz baribir \'kelib, o\'zingiz ko\'ring\' deymiz. O\'z ko\'zingiz bilan ko\'rish har doim eng yaxshisi.';

  @override
  String get sssQ5 => 'Mebellarning material sifati qanday?';

  @override
  String get sssA5 =>
      'Biz shaffoflikni qadrlaymiz. Har bir mahsulotning o\'z hikoyasi va materiali bor. Shu sababli barcha tafsilotlarni, material sifatini va xususiyatlarni mahsulot tavsifiga aniq yozamiz. Agar biror narsa aqlingizga tegib qolsa, so\'rashdan tortinmang.';

  @override
  String get sssQ6 => 'Mahsulot narxlari qanday belgilanadi?';

  @override
  String get sssA6 =>
      'Narxlarimizni belgilashda ham mahsulot sifatiga, ham bozor sharoitiga adolatli qaraymiz. Maqsadimiz — byudjetingizni qiynamasdan sifatli va uzoq umr ko\'radigan mahsulotlarga ega bo\'lishingizni ta\'minlash. Adolatli bo\'lgan narxni so\'raymiz, undan ortiq emas.';

  @override
  String get sssQ7 => 'Mahsulotlaringizda rang tanlash imkoniyati bormi?';

  @override
  String get sssA7 =>
      'Mahsulotlarimiz odatda tasodifiy va yagona nusxalar bo\'lgani uchun, ularni mavjud rangda taqdim etamiz. Afsuski turli rang variantlarini qila olmaymiz. Yoqqan mahsulotning rangi — ko\'rgan rangingizdir.';

  @override
  String get sssQ8 => 'Maxsus buyurtma qabul qilasizmi?';

  @override
  String get sssA8 =>
      'Qani edi qila olsak! Ammo biz ko\'proq mavjud, diqqat bilan tanlangan mahsulotlarimizga e\'tibor qaratamiz. Maxsus ishlab chiqarish yoki dizayn buyurtmasini hozircha afsuski qabul qila olmaymiz. Tayyor mahsulotlarimizni ko\'rib chiqishingizni tavsiya qilamiz.';

  @override
  String get sssQ9 =>
      'Mahsulot tavsiflarida nimalarga e\'tibor berishim kerak?';

  @override
  String get sssA9 =>
      'Eng muhim maslahatimiz: o\'lchov tasmasi! Iltimos, mahsulot tavsifidagi o\'lchamlarni uyingizga qo\'yiladigan joy bilan diqqat bilan solishtiring. \'Sig\'armikan?\' savolini oldindan hal qilish keyingi muammolarning oldini oladi. Shuningdek, o\'lchayotganda yo\'lakni unutmang: faqat mebel qo\'yiladigan joyni emas, balki uning eshik, yo\'lak va zinapoyadan qanday o\'tishini ham o\'lchang. Material va holat haqidagi ma\'lumotlarni ham albatta o\'qing.';

  @override
  String get sssQ10 =>
      'Liftsiz binolarga yoki yuqori qavatlarga yetkazib berasizmi?';

  @override
  String get sssA10 =>
      'Bu biz uchun eng nozik va muhim mavzulardan biri. Biz ishni o\'zi bajaradigan kichik hunarmandmiz. Ustamiz yillar tajribasi bilan endi yosh emas, shuning uchun uning sog\'lig\'ini ham o\'ylashimiz kerak. Tushunganingizni so\'raymiz: liftsiz binolarda yuqori qavatlarga (masalan, 2-qavat va undan yuqori) buyumlarni ko\'tarib chiqish va tushirish xizmatini mutlaqo bera olmaymiz. Iltimos, buyurtma berishdan oldin bu masalani aniqlashtiraylik, sizni noqulay ahvolga qoldirishni xohlamaymiz.';

  @override
  String get sssQ11 => 'Tashish xizmatini ko\'rsatasizmi?';

  @override
  String get sssA11 =>
      'Albatta, qo\'shnilarimizga yordam beramiz. Asosan İçerenköy, shuningdek Fındıklı, Kayışdağı, Küçükbakkalköy, İnönü va Bostancı Sanayi kabi yaqin hududlarga bepul tashish xizmatimiz bor. (Bostancı va Kozyatağı\'ning ayrim qismlaridan tashqari, va yosh sababli liftsiz yuqori qavatlarga tasha olmaymiz, buni alohida gaplashamiz).';

  @override
  String get sssQ12 => 'Yetkazib berish qancha vaqt oladi?';

  @override
  String get sssA12 =>
      'Buyurtma berishingiz bilanoq siz bilan bog\'lanamiz. \'Qachon bo\'shsiz?\' deb so\'raymiz. Ikkalamizga ham mos keladigan eng yaqin vaqtga kelishamiz. Odatda 1-3 kun ichida, kelishilgan vaqtda yetkazib berish va yig\'ishni yakunlaymiz.';

  @override
  String get sssQ13 => 'Yig\'ish xizmatini beradasizmi?';

  @override
  String get sssA13 =>
      'Albatta. Mebelni olib, eshik oldiga qo\'yib ketish bizning uslubimiz emas. Katta mahsulotlarning barchasini ustamiz shaxsan yig\'adi va bu xizmat uchun qo\'shimcha haq talab qilmaymiz. Siz faqat joyini ko\'rsating, qolgani bizda.';

  @override
  String get sssQ14 => 'Mebel buyurtmasi qancha vaqtda yetkazib beriladi?';

  @override
  String get sssA14 =>
      'Agar mahsulot tayyor bo\'lsa, birgalikda belgilagan vaqtda imkon qadar tezroq eshigingizdamiz. Yig\'ish haqida ham tashvishlanmang; uni olib kelganimizdek yig\'ib, shunday tayyor holda topshiramiz. Odatda hammasi bir kun ichida tugaydi.';

  @override
  String get sssQ15 => 'Nasiyaga buyurtma bera olamanmi?';

  @override
  String get sssA15 =>
      'Bu masalada tushunishingizni so\'raymiz. Hunarmand sifatida omon qolishimiz uchun \'nasiya\' yoki \'keyin to\'lash\' kabi usullar bilan afsuski ishlay olmaymiz. Kelishilgan summani mahsulotni topshirishda naqd olishimiz kerak. Sizni noqulay ahvolga qoldirmaslik uchun bu qoidamizni boshidanoq aytishni afzal ko\'ramiz.';

  @override
  String get sssQ16 => 'Qanday buyurtma bera olaman?';

  @override
  String get sssA16 =>
      'Eng ishonchli usul har doim yuzma-yuz uchrashuvdir. Saytdan yoqqan mahsulotni belgilab qo\'ying, so\'ng do\'konimizga keling. Mahsulotni jonli ko\'ring, aqlingizdagi savollarni bering, agar yoqsa, buyurtmangizni o\'sha yerda yakunlaylik. Shunda hech qanday shubha qolmaydi.';

  @override
  String get sssQ17 => 'Mahsulot qaytarish siyosatingiz qanday?';

  @override
  String get sssA17 =>
      'Ishlatilgan mahsulotlarning tabiati va hunarmandchilik uslubimiz sababli, afsuski qaytarishni qabul qila olmaymiz. Shuning uchun \'kelib ko\'ring, choyimizni iching\' deb turib olamiz. Sotib olishdan oldin mahsulotni batafsil ko\'rib, o\'lchab chiqish eng to\'g\'risi. Ishonch hosil qilmasdan xaridni yakunlamaylik.';

  @override
  String get sssQ18 => 'Mahsulotlarda kafolat muddati bormi?';

  @override
  String get sssA18 =>
      'Mahsulotlarimiz ishlatilgan bo\'lgani uchun, brend taklif qiladigan kabi rasmiy kafolat muddatimiz afsuski yo\'q. Ammo biz \'sotdik, tamom\' deydiganlardan emasmiz. Yetkazib berish va yig\'ish paytida hammasi to\'g\'ri ishlashiga ishonch hosil qilamiz.';

  @override
  String get sssQ19 =>
      'Uyimdagi buyumlarni sotmoqchiman, ishlatilganini sotib olasizmi?';

  @override
  String get sssA19 =>
      'Ha, do\'konimizda ko\'rgazmaga qo\'ya olamiz deb ishongan, toza va qayta sotiladigan tanlangan mahsulotlarni sotib olamiz. Ammo do\'konimizning joyi haqiqatan ham juda kichik bo\'lgani uchun, bu masalada afsuski juda tanlab-tanlab ish yuritishga majburmiz.\n\nBu masalada boshidanoq halol bo\'lishni yaxshi ko\'ramiz: sizga beradigan taklifimiz, ehtimol, Letgo kabi platformalarda o\'zingiz sota oladigan summadan biroz past bo\'lishi mumkin. Buning sababi shunda: hunarmand sifatida biz o\'sha buyumni olib kelish uchun benzin sarflaymiz, tashish uchun mehnat qilamiz va eng muhimi, uni sotish uchun do\'konimizda ko\'rgazmaga qo\'yib, butun mijozlar jarayoni (savdolashish, savollar va h.k.) bilan o\'zimiz shug\'ullanamiz.\n\nSiz o\'sha platformalarda o\'zingiz sotganingizda bu jarayonlarning barchasini o\'zingiz zimmangizga olasiz. Biz esa bu tashvishni sizdan olib qo\'yamiz. Taklifimiz shu xizmatni ham o\'z ichiga oladi. Tushunganingiz uchun rahmat.';

  @override
  String get sssQ20 =>
      'To\'liq mebel to\'plamlarini (yotoqxona, mehmonxona to\'plami va h.k.) sotib olasizmi?';

  @override
  String get sssA20 =>
      'Do\'konimiz kichik bo\'lgani uchun, afsuski to\'liq yotoqxona yoki divan to\'plami kabi katta to\'plamlarni sotib ololmaymiz. Joyimiz juda cheklangan. Biz ko\'proq sotilishi osonroq bo\'lgan yakka buyumlarga (konsol, shkaf, stol, stul kabi) e\'tibor qaratamiz.';

  @override
  String get sssQ21 =>
      'Buyumlarim yuqori qavatda va binoda lift yo\'q. Baribir sotib olasizmi?';

  @override
  String get sssA21 =>
      'Xuddi yetkazib berish masalasidagidek, bu bizning eng aniq qoidamiz. Ustamizning sog\'lig\'i sababli, liftsiz binolarda yuqori qavatlardan buyumlarni mutlaqo tushira olmaymiz. Buyumlaringiz yer/kirish qavatiga yaqin bo\'lsa yoki binoda yuk lifti bo\'lsa, faqat o\'shanda ko\'rib chiqishimiz mumkin.';

  @override
  String get sssQ22 => 'Har doim buyum sotib olasizmi?';

  @override
  String get sssA22 =>
      'Bu to\'liq do\'konimizdagi bo\'sh joyga bog\'liq. Do\'konimiz kichik bo\'lgani uchun \'sot-ol\' muvozanati bilan ishlaymiz. Ba\'zan mahsulot juda yoqib qolsa ham, joy yo\'qligi sababli ololmasligimiz mumkin. Eng to\'g\'risi — sotmoqchi bo\'lgan mahsulotingiz rasmlarini bizga yuborishingiz. Sizga \'hozir joyimiz bor\' yoki \'afsuski hozircha to\'liqmiz\' deb halol ma\'lumot beramiz.';

  @override
  String get navDiscover => 'Kashf qilish';

  @override
  String get navCart => 'Savat';

  @override
  String get navProfile => 'Profil';

  @override
  String get storeHeroEyebrow => 'YANGI KOLLEKSIYA';

  @override
  String get storeHeroTitle => 'Uyingizga mos\nmebel';

  @override
  String get storeHeroSubtitle =>
      'Sifatli yangi va ishlatilgan mebel, siz yoqtiradigan narxlarda uyingizga yetkaziladi.';

  @override
  String get storeHeroCta => 'Xarid qilishni boshlash';

  @override
  String get sectionCategories => 'Toifalar';

  @override
  String get sectionBestSellers => 'Ko\'p sotilganlar';

  @override
  String get sectionNewArrivals => 'Yangi mahsulotlar';

  @override
  String get seeAll => 'Barchasini ko\'rish';

  @override
  String get cartTitle => 'Mening savatim';

  @override
  String get cartEmptyTitle => 'Savatingiz bo\'sh';

  @override
  String get cartEmptyDesc =>
      'Yoqqan mahsulotlarni savatga qo\'shing, keyin barchasi haqida bitta xabar bilan so\'rang.';

  @override
  String get cartTotalLabel => 'Jami';

  @override
  String get cartWhatsappCta => 'Savatni WhatsApp orqali yuborish';

  @override
  String get cartItemRemoved => 'Savatdan olib tashlandi';

  @override
  String get addToCartCta => 'Savatga qo\'shish';

  @override
  String get addedToCartMessage => 'Savatga qo\'shildi';

  @override
  String get alreadyInCartMessage => 'Allaqachon savatda';

  @override
  String get settingsTitle => 'Sozlamalar';

  @override
  String get settingsLanguageLabel => 'Til';

  @override
  String get settingsAccountSection => 'Hisob';

  @override
  String get settingsGeneralSection => 'Umumiy';

  @override
  String get settingsContact => 'Aloqa';

  @override
  String get settingsCallUs => 'Bizga qo\'ng\'iroq qiling';

  @override
  String get settingsAdminLogin => 'Administrator kirishi';

  @override
  String get settingsAppVersion => 'Ilova versiyasi';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mahsulot',
      one: '1 mahsulot',
      zero: 'Savat bo\'sh',
    );
    return '$_temp0';
  }

  @override
  String get settingsRateApp => 'Ilovani baholang';

  @override
  String get settingsShareApp => 'Ilovani ulashish';

  @override
  String get settingsPrivacyPolicy => 'Maxfiylik siyosati';

  @override
  String get settingsTerms => 'Foydalanish shartlari';

  @override
  String get legalContentTurkishOnly =>
      'Ushbu kontent hozircha faqat turk tilida mavjud.';

  @override
  String get doubleBackToExit => 'Chiqish uchun yana orqaga bosing';

  @override
  String get productLinkLabel => 'Mahsulot havolasi';

  @override
  String get settingsAppSection => 'Ilova';

  @override
  String get settingsLegalSection => 'Huquqiy';

  @override
  String get recentlyViewedTitle => 'Yaqinda ko\'rilganlar';

  @override
  String get productTrustBadgeVerified => 'Tasdiqlangan Sotuvchi';

  @override
  String get productTrustBadgeNegotiate => 'WhatsApp orqali kelishish';

  @override
  String get productTrustBadgeDelivery => 'Joyida yetkazib berish';

  @override
  String get howToBuyTitle => 'Qanday sotib olaman?';

  @override
  String get howToBuyStep1Title => 'WhatsApp\'ga yozing';

  @override
  String get howToBuyStep1Desc =>
      'Mahsulot yoqqan bo\'lsa, biz bilan WhatsApp orqali bog\'laning.';

  @override
  String get howToBuyStep2Title => 'Narxni muhokama qiling';

  @override
  String get howToBuyStep2Desc =>
      'Narx va yetkazib berish tafsilotlarini birga kelishing.';

  @override
  String get howToBuyStep3Title => 'Mahsulotni oling';

  @override
  String get howToBuyStep3Desc =>
      'Kelishuvdan so\'ng mahsulotingizni xavfsiz oling.';

  @override
  String get listedToday => 'Bugun qo\'shildi';

  @override
  String listedDaysAgo(int days) {
    return '$days kun oldin qo\'shildi';
  }

  @override
  String listedWeeksAgo(int weeks) {
    return '$weeks hafta oldin qo\'shildi';
  }

  @override
  String get settingsAppearanceSection => 'Ko\'rinish';

  @override
  String get settingsThemeLight => 'Yorug\'';

  @override
  String get settingsThemeSystem => 'Tizim';

  @override
  String get settingsThemeDark => 'Qorong\'u';

  @override
  String get notificationsTitle => 'Bildirishnomalar';

  @override
  String get notificationsEmptyTitle => 'Hozircha bildirishnoma yo\'q';

  @override
  String get notificationsEmptyDesc =>
      'Yangi aksiyalar va e\'lonlar shu yerda ko\'rinadi';

  @override
  String get markAllReadAction => 'Barchasini o\'qilgan deb belgilash';

  @override
  String get clearAllAction => 'Barchasini tozalash';

  @override
  String get timeJustNow => 'Hozirgina';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes daqiqa oldin';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours soat oldin';
  }

  @override
  String timeDaysAgoGeneric(int days) {
    return '$days kun oldin';
  }

  @override
  String get catalogCategoryTitleSofa => 'Divan va kanape';

  @override
  String get catalogCategoryTitleChair => 'Stul va kreslo';

  @override
  String get catalogCategoryTitleTable => 'Oshxona stoli';

  @override
  String get catalogCategoryTitleBed => 'Krovat va asos';

  @override
  String get catalogCategoryTitleWardrobe => 'Garderob va shkaf';

  @override
  String get catalogCategoryTitleWhite => 'Maishiy texnika';

  @override
  String get catalogCategoryTitleOther => 'Dekor';

  @override
  String get mottoTitlePart1 => 'Kelishdan oldin ko\'ring, ';

  @override
  String get mottoTitlePart2 => 'Yoqqanda keling.';

  @override
  String get mottoSubtitle =>
      'Do\'konga kelishdan oldin vitrinamizni ko\'ring, yoqqan narsani topganingizda bizga keling.';

  @override
  String get gatewayNewEyebrow => 'YANGI KOLLEKSIYA';

  @override
  String get gatewayNewTitle => 'Vaqtsiz buyumlar';

  @override
  String get gatewayNewSubtitle => 'Hech qachon ishlatilmagan, yangi mebel.';

  @override
  String get gatewayNewButton => 'Kolleksiyani ko\'rish';

  @override
  String get gatewaySpotEyebrow => 'SPOT TAKLIFLAR';

  @override
  String get gatewaySpotTitle => 'Ishlatilgan, ammo mustahkam';

  @override
  String get gatewaySpotSubtitle =>
      'Ikkinchi qo\'l, ammo foydali, hamyonbop narxlarda.';

  @override
  String get gatewaySpotButton => 'Takliflarni ko\'rish';

  @override
  String freeDeliveryZonesNote(String zones) {
    return 'Bepul yetkazib berish faqat $zones hududlarida amal qiladi';
  }

  @override
  String get footerWarehouseTagline => 'MEBEL OMBORI · İÇERENKÖY / ATAŞEHİR';

  @override
  String get locationAndHoursLabel => 'MANZIL VA ISH VAQTI';

  @override
  String get openNowLabel => 'HOZIR OCHIQ';

  @override
  String get closedNowLabel => 'HOZIR YOPIQ';

  @override
  String todayHoursPrefix(String hours) {
    return '· Bugun $hours';
  }

  @override
  String get openInMapsButton => 'Xaritada ochish';

  @override
  String get viewOnGoogleMapsButton => 'Google Xaritada ko\'rish';

  @override
  String gatewayProductCount(int count) {
    return '$count ta mahsulot';
  }

  @override
  String get gatewayNewEyebrowShort => 'YANGI';

  @override
  String get gatewayNewTitleShort => 'Kolleksiya';

  @override
  String get gatewaySpotEyebrowShort => 'SPOT';

  @override
  String get gatewaySpotTitleShort => 'Takliflar';

  @override
  String get spotHeroEyebrow => 'TAKLIFLAR OMBORI';

  @override
  String get spotHeroSubtitle =>
      'Ishlatilgan, ammo foydali. Har qanday byudjet uchun yangidek mahsulotlar. Kelishish imkoniyati bor.';

  @override
  String spotHeroDealCount(int count) {
    return '$count+ taklif';
  }

  @override
  String get spotStatNegotiable => 'Kelishish mumkin';

  @override
  String get spotStatUsed => 'Ishlatilgan';

  @override
  String get spotShowcaseBadgeTitle => 'To\'liq yangilangan';

  @override
  String get spotShowcaseBadgeSubtitle =>
      'Har bir mahsulot yetkazishdan oldin alohida tekshiriladi.';

  @override
  String get spotBreadcrumbLabel => 'Spot va ikkinchi qo\'l';

  @override
  String get aphorismEyebrow => 'BIZDA BIR SO\'Z BOR';

  @override
  String get aphorismQuote =>
      'Eskirgan emas, mehr ko\'rgan.\nYaxshi mebel hech qachon eskirmaydi, faqat uy almashtiradi.';

  @override
  String get aphorismBody =>
      'Biz aynan shuning uchun shu yerdamiz: hali ham hayoti bor buyumlarni ularni qadrlaydigan yangi uyga yetkazish uchun.';

  @override
  String get spotSearchHint => 'Takliflarni qidirish...';

  @override
  String get priceRangeLabel => 'Narx oralig\'i';

  @override
  String get filtersSheetTitle => 'FILTRLAR';

  @override
  String get applyFiltersButton => 'Filtrlarni qo\'llash';

  @override
  String get priceRangeSheetTitle => 'NARX ORALIG\'I';

  @override
  String get applyButton => 'Qo\'llash';

  @override
  String get sortSheetTitle => 'SARALASH';

  @override
  String get sortNewest => 'Eng yangi takliflar';

  @override
  String get sortPopular => 'Eng ko\'p ko\'rilgan';

  @override
  String get spotEmptyStateTitle => 'Bu mezon bo\'yicha takliflar topilmadi';

  @override
  String get spotEmptyStateSubtitle =>
      'Filtrlarni tozalab yoki boshqa kategoriyani sinab ko\'ring.';

  @override
  String get newHeroTitleLine1 => 'Turar joyingiz uchun\n';

  @override
  String get newHeroTitleEmphasis => 'Vaqtsiz ';

  @override
  String get newHeroButtonCollection => 'Kolleksiyani ko\'rish';

  @override
  String get newHeroButtonQuickFilter => 'Tezkor filtr';

  @override
  String get newStatActiveProductLabel => 'FAOL MAHSULOTLAR';

  @override
  String get newStatControlledStockLabel => 'TEKSHIRILGAN ZAXIRA';

  @override
  String get shopByCategoryTitlePrefix => 'Kategoriya bo\'yicha ';

  @override
  String get shopByCategoryTitleEmphasis => 'Kashf eting';

  @override
  String get showAllButton => 'Barchasini ko\'rsatish';

  @override
  String get newEmptyStateTitle => 'Qidiruvingizga mos mebel topilmadi';

  @override
  String get newEmptyStateSubtitle =>
      'Qidiruv so\'zini o\'zgartiring yoki filtrlarni tozalang.';

  @override
  String get sortOptionsSheetTitle => 'Saralash parametrlari';

  @override
  String get newSortNewest => 'Eng yangilari';

  @override
  String get newSortPopular => 'Eng ko\'p ko\'rilganlar';

  @override
  String get cartWhatsappGreeting =>
      'Salom, quyidagi mahsulotlar haqida ma\'lumot olmoqchiman:\n\n';

  @override
  String cartWhatsappAllProductsLine(String url) {
    return 'Barcha mahsulotlar: $url';
  }

  @override
  String get defaultWhatsappGreeting =>
      'Salom, mebel haqida ma\'lumot olmoqchiman.';

  @override
  String get spotHeroPageTitle => 'Ikkinchi qo\'l va Spot';

  @override
  String get sortByPriceLowHigh => 'Narx: arzondan qimmatga';

  @override
  String get sortByPriceHighLow => 'Narx: qimmatdan arzonga';
}

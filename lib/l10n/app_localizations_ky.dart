// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String get brand => 'SAĞLAM SPOT';

  @override
  String get home => 'Башкы бет';

  @override
  String get searchHint => 'Үйүңүз үчүн эмнени издеп жатасыз?...';

  @override
  String get collection => 'КОЛЛЕКЦИЯ';

  @override
  String get eleganceAndComfort => 'Зарафат жана ыңгайлуулук';

  @override
  String productsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товар табылды',
      one: '1 товар табылды',
      zero: 'Товар табылган жок',
    );
    return '$_temp0';
  }

  @override
  String resultsFor(String query) {
    return '«$query» боюнча жыйынтыктар';
  }

  @override
  String get seoHomeTitle => 'Sağlam Spot | Колдонулган жана жаңы эмерек';

  @override
  String get seoHomeDesc =>
      'Колдонулган жана жаңы эмеректе эң ыңгайлуу баалар. 20 жылдык бизнес кепилдиги менен.';

  @override
  String get seoNewTitle => 'Жаңы товарлар | Sağlam Spot';

  @override
  String get seoNewDesc =>
      'Кепилдендирилген жана сапаттуу жаңы эмерек коллекциясы.';

  @override
  String get seoSpotTitle => 'Колдонулган товарлар | Sağlam Spot';

  @override
  String get seoSpotDesc =>
      'Экономикалык жана сапаттуу колдонулган эмерек варианттары.';

  @override
  String get seoAboutTitle => 'Биз жөнүндө | Sağlam Spot';

  @override
  String get seoAboutDesc =>
      '20 жылдык тажрыйбабыз менен эмерек тармагында ишеним дареги.';

  @override
  String get seoProductDetailSuffix => 'Товарды көрүү | Sağlam Spot';

  @override
  String get category => 'Категория';

  @override
  String get categorySofa => 'Диван топтомдору';

  @override
  String get categoryChair => 'Отургуч';

  @override
  String get categoryTable => 'Стол';

  @override
  String get categoryBed => 'Уктоочу бөлмө';

  @override
  String get categoryWardrobe => 'Шкаф';

  @override
  String get categoryWhite => 'Тиричилик техникасы';

  @override
  String get categoryOther => 'Башка';

  @override
  String get condition => 'Абалы';

  @override
  String get conditionAll => 'Баары';

  @override
  String get conditionNew => 'Жаңы';

  @override
  String get conditionUsed => 'Колдонулган';

  @override
  String get priceRange => 'Баа диапазону';

  @override
  String get price => 'Баасы';

  @override
  String get save => 'Сактоо';

  @override
  String get explanation => 'Сүрөттөмө';

  @override
  String get clear => 'Тазалоо';

  @override
  String get filter => 'Чыпкалоо';

  @override
  String get apply => 'Колдонуу';

  @override
  String get cancel => 'Жокко чыгаруу';

  @override
  String get newSeason => 'ЖАҚЫ СЕЗОН';

  @override
  String get heroTitle => 'Минималисттик\nЫңгайлуулуктун чокусу';

  @override
  String get viewCollection => 'КОЛЛЕКЦИЯНЫ КӨРҲҲ';

  @override
  String get featureArtisan => 'Чынчыл чеберчилик';

  @override
  String get featureDelivery => 'Коопсуз жеткирүү';

  @override
  String get featureService => 'Достук тейлөө';

  @override
  String get featureShipping => 'Тез жеткирүү';

  @override
  String get quickOptions => 'Тез варианттар';

  @override
  String get easyFind => 'Издеген товарыңызды оңой табыңыз';

  @override
  String get mottoBrand => 'Эскини жаңылайт, жаңыны баалайт';

  @override
  String get newCollection => 'Жаңы коллекция';

  @override
  String get newCollectionSub => 'Эң жаңы товарлар';

  @override
  String get spotProducts => 'Колдонулган товарлар';

  @override
  String get spotProductsSub => 'Арзандатылган товарлар';

  @override
  String get spotProductsDesc => 'Сапаттуу товарларда укмуштуудай баалар';

  @override
  String get currentCollection => 'УЧУРДАГЫ КОЛЛЕКЦИЯ';

  @override
  String get soldProducts => 'САТЫЛГАН ТОВАРЛАР';

  @override
  String pieces(int count) {
    return '$count даана';
  }

  @override
  String get stock => 'КАМПАДА';

  @override
  String get sold => 'САТЫЛДЫ';

  @override
  String get byRoom => 'Бөлмө боюнча';

  @override
  String get byRoomSub => 'Үйүңүздүн ар бир бурчу үчүн өзгөчө тандоолор';

  @override
  String get roomLivingRoom => 'Конок бөлмө';

  @override
  String get roomLivingRoomSub => 'Ыңгайлуулуктун борбору';

  @override
  String get roomBedroom => 'Уктоочу бөлмө';

  @override
  String get roomBedroomSub => 'Тынч уйку';

  @override
  String get roomKitchen => 'Ашкана';

  @override
  String get roomKitchenSub => 'Практикалык чечимдер';

  @override
  String get roomOffice => 'Кабинет';

  @override
  String get roomOfficeSub => 'Эффективдүү иш';

  @override
  String get whoWeAre => 'БИЗ КИМБИЗ?';

  @override
  String get artisanTitle =>
      '20 жылдык чынчыл чеберчилик,\nазыркы заманбап тейлөө.';

  @override
  String get artisanDesc =>
      'Дүкөнүбүзгө келиңиз, чай ичели; сизге эң ыңгайлуу эмеректи чогуу тандайлы.';

  @override
  String get visitUsButton => 'БИЗГЕ КЕЛИҲИЗ';

  @override
  String get statHappyCustomer => 'Ыраазы кардар';

  @override
  String get statExperience => 'Тажрыйба';

  @override
  String get statDelivery => 'Жеткирүү';

  @override
  String get statTrust => 'Ишеним';

  @override
  String get explore => 'КАРОО';

  @override
  String get collections => 'Коллекциялар';

  @override
  String get corporate => 'КОРПОРАТИВДИК';

  @override
  String get aboutUs => 'Биз жөнүндө';

  @override
  String get contact => 'Байланыш';

  @override
  String get contactUs => 'БИЗ МЕНЕН БАЙЛАНЫШЫҲЫЗ';

  @override
  String get sss => 'Көп берилүүчү суроолор';

  @override
  String get qualityFurniture => '\'Сапаттуу эмеректин дареги — Sağlam Spot\'';

  @override
  String get footerDesc =>
      '20 жылдан ашык тажрыйбабыз менен Стамбулдун ар бир чекитине сапат жана ишенимди алып келебиз.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT TİCARET. БАРДЫК УКУКТАР КОРГОЛГОН.';

  @override
  String get errorOccurred => 'Ката пайда болду';

  @override
  String get productNotFound => 'Товар табылган жок';

  @override
  String get noImages => 'Сүрөт жок';

  @override
  String get error_check_connection => 'Интернет байланышыңызды текшериңиз.';

  @override
  String get error_server_no_response => 'Сервер учурда жооп берип жаткан жок.';

  @override
  String get error_connection => 'Байланыш катасы';

  @override
  String get error_connection_lost => 'Байланыш үзүлдү';

  @override
  String get status_waiting_connection => 'Байланыш күтүлүп жатат...';

  @override
  String get error_no_internet_auto_retry =>
      'Интернет байланышы жок.\nБайланыш калыбына келгенде автоматтык түрдө улантылат.';

  @override
  String get goBack => 'Артка кайтуу';

  @override
  String get galleryEmpty => 'Галерея бош';

  @override
  String get month_1 => 'Январь';

  @override
  String get month_2 => 'Февраль';

  @override
  String get month_3 => 'Март';

  @override
  String get month_4 => 'Апрель';

  @override
  String get month_5 => 'Май';

  @override
  String get month_6 => 'Июнь';

  @override
  String get month_7 => 'Июль';

  @override
  String get month_8 => 'Август';

  @override
  String get month_9 => 'Сентябрь';

  @override
  String get month_10 => 'Октябрь';

  @override
  String get month_11 => 'Ноябрь';

  @override
  String get month_12 => 'Декабрь';

  @override
  String get noProductFoundTitle => 'Бул критерийлер боюнча товар табылган жок';

  @override
  String get noProductFoundDescription =>
      'Башка чыпкаларды сынап көрүңүз же издөө сөзүн өзгөртүңүз';

  @override
  String get adminPanelTitle => 'Башкаруу панели';

  @override
  String get totalCount => 'Жалпы';

  @override
  String get productAddedSuccess => 'Товар ийгиликтүү кошулду';

  @override
  String get authOrConnectionError => 'Уруксат же байланыш катасы пайда болду';

  @override
  String get fillRequiredFields =>
      'Товардын атын, баасын жана жок дегенде бир сүрөттү кошуңуз!';

  @override
  String get sessionClosed => 'Сессия жабылды';

  @override
  String get addNewProduct => 'Жаңы товар кошуу';

  @override
  String get productImages => 'Товар сүрөттөрү';

  @override
  String get generalInfo => 'Жалпы маалымат';

  @override
  String get productNameLabel => 'Товардын аты';

  @override
  String get descriptionLabel => 'Сүрөттөмө';

  @override
  String get statusLabel => 'Абал';

  @override
  String get spotSecondHand => 'Спот / Колдонулган';

  @override
  String get secondHandHint =>
      'Жападан жалгыз нуска — түс варианттары көрсөтүлбөйт';

  @override
  String get newProductHint => 'Жаңы товар — түс варианттарын кошо аласыз';

  @override
  String get colorOptionsOptional => 'Түс варианттары (милдеттүү эмес)';

  @override
  String get noImagesYet => 'Азырынча сүрөт кошулган эмес';

  @override
  String get addImage => 'Сүрөт кошуу';

  @override
  String get editProductTitle => 'Товарды түзөтүү';

  @override
  String get changeImages => 'Сүрөттөрдү өзгөртүү';

  @override
  String get saveChanges => 'Өзгөртүүлөрдү сактоо';

  @override
  String get deleteProductTitle => 'Товарды өчүрүү';

  @override
  String get deleteProductConfirmSuffix => 'өчүрүлөт. Ишенимдүүсүзбү?';

  @override
  String get yesDelete => 'Ооба, өчүрүү';

  @override
  String get emptyCategoryProducts => 'Бул категорияда товар табылган жок';

  @override
  String get adminLoginSubtitle => 'Башкаруу панелине кирүү';

  @override
  String get emailLabel => 'Электрондук почта';

  @override
  String get passwordLabel => 'Сырсөз';

  @override
  String get loginButton => 'Кирүү';

  @override
  String get sponsored => 'Жарнама';

  @override
  String get addProductFab => 'Товар кошуу';

  @override
  String get singlePieceNotice =>
      'Бул колдонулган/спот товар — кампада бир гана нуска бар, түсү жана көрүнүшү сүрөттөгүдөй так эле.';

  @override
  String get colorOptionsTitle => 'Түс варианттары';

  @override
  String get newProductBadge => 'ЖАҲЫ ТОВАР';

  @override
  String get usedProductBadge => 'КОЛДОНУЛГАН';

  @override
  String get readMore => 'Толугу менен окуу';

  @override
  String get readLess => 'Азыраак көрсөтүү';

  @override
  String get specDelivery => 'Жеткирүү';

  @override
  String get specDeliveryValue => '1-2 күн ичинде';

  @override
  String get specLocation => 'Жайгашкан жери';

  @override
  String get sellerTrustLine =>
      '20 жылдык ишенимдүү жергиликтүү бизнес · İçerenköy';

  @override
  String get whatsappCta => 'WhatsApp аркылуу жазуу';

  @override
  String get callCta => 'Чалуу';

  @override
  String get similarProducts => 'Окшош товарлар';

  @override
  String get conditionShowcase => 'Көргөзмө';

  @override
  String get productDescriptionTitle => 'Сүрөттөмө';

  @override
  String get loginBrand => 'Sağlam Spot';

  @override
  String get logout => 'Чыгуу';

  @override
  String get logoutConfirm =>
      'Каттоо эсебиңизден коопсуз чыгууга ишенимдүүсүзбү?';

  @override
  String get testimonialsHeading => 'Кардарларыбыз Эмне Дейт';

  @override
  String get testimonialsSubheading =>
      '20 жылдан ашык убакыттан бери İçerenköy жана анын тегерегиндеги миңдеген үйлөргө жеттик';

  @override
  String get testimonial1Comment =>
      'Диван топтомун абдан ыңгайлуу баада алдык, дээрлик жаңыдай. Жеткирүү дал ошол күнү колдон колго болду, чыныгы устанын ишеними башынан эле сезилди.';

  @override
  String get testimonial2Comment =>
      'Уктоочу бөлмө топтомун бул жерден акция баасына сатып алдым. Продукт сүрөттөлүшүнө так дал келди, эч кандай тосмо болгон жок. Толук сунуштайм.';

  @override
  String get testimonial3Comment =>
      'Офисибиз үчүн көп сандаган эмерек сатып алдык, баасы жана сапаты күткөндөн жогору болду. Кам көргөн, чыдамдуу команда — рахмат, Sağlam Spot.';

  @override
  String get testimonial4Comment =>
      'Ашкана столу топтомун соодалашпастан, адилет баада сатып алдык. Ташуу боюнча да жардам беришти, ынак соода кылдык.';

  @override
  String get testimonial5Comment =>
      'Колдонулган кийим шкафын издеп жүрдүк, бекем жана шыгы бар нерсе таптык. Баасы менен сапатынын катышы рыноктогу эң жакшысы болду.';

  @override
  String get testimonial6Comment =>
      'Шоурумга барганда буюмдарды өз көзүбүз менен көрө алдык, бул ишенимди дагы бекемдеди. Сатуудан кийин да ар дайым байланышта болушту.';

  @override
  String get howItWorksHeading => 'Кантип Иштейт';

  @override
  String get step1Title => 'Кара & Чыпка';

  @override
  String get step1Desc =>
      'Категория жана баа диапазону боюнча миңдеген продукттан жаккан нерсеңди тап.';

  @override
  String get step2Title => 'Биз Менен Байланыш';

  @override
  String get step2Desc =>
      'Продукт баракчасынан бир баскычта WhatsApp же телефон аркылуу командабызга жет.';

  @override
  String get step3Title => 'Баасын Так Кел';

  @override
  String get step3Desc =>
      'Шоурумда көр же сүрөттөр менен ырастат, чыныгы адилет баага макулдаш.';

  @override
  String get step4Title => 'Эшигиңе Жеткирүү';

  @override
  String get step4Desc =>
      'İçerenköy жана Анадолу тарабына тез, камсыздандырылган ташуу менен эмереги коопсуз үйгө жетет.';

  @override
  String get tipsEyebrow => 'КЕҢЕШТЕР';

  @override
  String get tipsHeading => 'Адистен Кам Көрүү Кеңештери';

  @override
  String get tip1Title => 'Мейманканаңызды Жагымдуу Кылыңыз';

  @override
  String get tip1Desc =>
      'Дивандын дубалдан 1-2 см аралыкта коюлушу аба айланышын жакшыртат жана бөлмөнү кеңири кылат.';

  @override
  String get tip1Category => 'Жайгаштыруу';

  @override
  String get tip2Title => 'Ар Дайым Таза Көрүнгөн Иш Столу';

  @override
  String get tip2Desc =>
      'Зымдарды тартипке келтирүүчүлөр менен иреттеп, микрофибра менен айлампалуу кыймылдар менен сүртүңүз — столуңуз жаңыдай сакталат.';

  @override
  String get tip2Category => 'Тазалык';

  @override
  String get tip3Title => 'Ыңгайлуу Ашкана Жайгаштыруусу';

  @override
  String get tip3Desc =>
      'Оор буюмдарды төмөнкү текчелерге, көп колдонулгандарды көз деңгээлине жайгаштырыңыз — практикалуу жана коопсуз.';

  @override
  String get tip3Category => 'Тартип';

  @override
  String get tip4Title => 'Ыңгайлуу Уктоочу Бурч Түзүңүз';

  @override
  String get tip4Desc =>
      'Керебеттин башын терезеден алыс, жарыкты минималдуу кылып жайгаштырыңыз — терең уйку үчүн кичине, бирок таасирдүү өзгөртүү.';

  @override
  String get tip4Category => 'Ыңгайлуулук';

  @override
  String get tip5Title => 'Шкафыңызды Тазалагыла';

  @override
  String get tip5Desc =>
      'Мезгилдик кийимдерди бөлүп, илгичтерди бир багытта илиңиз — орун үнөмдөйт жана эрте мененки тандоону жеңилдетет.';

  @override
  String get tip5Category => 'Тартип';

  @override
  String get tip6Title => 'Жыгач Эмеректериңизге Узак Өмүр Кошуңуз';

  @override
  String get tip6Desc =>
      'Түз күн нурунан коргоп, жылына бир нече жолу азыктуу май менен сүртүңүз — тырышы жана өчүшүнө каршы эң таасирдүү кам көрүү.';

  @override
  String get tip6Category => 'Кам көрүү';

  @override
  String get tip7Title => 'Кездеме Диванды Узакка Кылыңыз';

  @override
  String get tip7Desc =>
      'Жумасына бир жолу тазалагыч менен сорулуп, тактарды дароо нымдуу чүпүрөк менен сүртүңүз — күтүп калсаңыз так кездемеге сиңип калат.';

  @override
  String get tip7Category => 'Кам көрүү';

  @override
  String get tip8Title => 'Туура Жарыктандырууну Тандаңыз';

  @override
  String get tip8Desc =>
      'Бир шыпка чырак ордуна катмарланган жарыктандырууну колдонуңуз: жалпы, иштиктүү жана атмосфералык жарык чогуу бөлмөнү жылуураак көрсөтөт.';

  @override
  String get tip8Category => 'Жарыктандыруу';

  @override
  String get tip9Title => 'Кичине Мейкиндиктерди Акылдуу Колдонуңуз';

  @override
  String get tip9Desc =>
      'Бүктөлмө, көп максаттуу эмеректерди тандаңыз; дубалга бекитилген текчелер жер мейкиндигин бошотот.';

  @override
  String get tip9Category => 'Тартип';

  @override
  String get tip10Title => 'Балконуңузду Жашоо Мейкиндигине Айландырыңыз';

  @override
  String get tip10Desc =>
      'Аба ырайына чыдамдуу отургуч топтому жана бир нече чөйчөк өсүмдүктөр балконду үйдүн эң жаккан бурчуна айландырат.';

  @override
  String get tip10Category => 'Сырткы аймак';

  @override
  String get popularCategoriesHeading => 'Популярдуу Категориялар';

  @override
  String get popularCategoriesSub => 'Ыңгайлуу эмеректи бир баскычта тап';

  @override
  String categoryProductCount(int count) {
    return '$count даана';
  }

  @override
  String get newsletterSubscribeSuccess =>
      'Сиз бюллетенибизге ийгиликтүү жазылдыңыз!';

  @override
  String get newsletterHeading => 'Жаңы Продукттар Тууралуу Биринчи Билиңиз';

  @override
  String get newsletterDesc =>
      'Акция сунуштары, жаңы коллекциялар жана кампаниялар электрондук почтаңызга келсин. Спам жок, пайдалуу сунуштар гана.';

  @override
  String get emailHint => 'Электрондук почтаңыз';

  @override
  String get emailRequired => 'Электрондук почта зарыл';

  @override
  String get emailInvalid => 'Туура электрондук почта киргизиңиз';

  @override
  String get whyUsHeading => 'Эмне Үчүн Sağlam Spot?';

  @override
  String get usp1Title => '20 Жылдык Ишенимдүү Устачылык';

  @override
  String get usp1Desc =>
      'İçerenköy\'де жыйырма жылдан ашык устачылык тарыхы жана миңдеген канааттанган кардарлар.';

  @override
  String get usp2Title => 'Рыноктон Төмөн Баа';

  @override
  String get usp2Desc =>
      'Ортомчусуз иштөө моделибиз менен акция жана жаңы эмерек боюнча эң ыңгайлуу баалар бизде.';

  @override
  String get usp3Title => 'Текшерилген Продукт Сапаты';

  @override
  String get usp3Desc =>
      'Ар бир продукт сатууга чыгаардан мурун структуралык жана кездеме/каптоо текшерүүсүнөн өтөт.';

  @override
  String get usp4Title => 'Сатуудан Кийинки Колдоо';

  @override
  String get usp4Desc =>
      'Жеткирүүдөн кийин да жетүүгө болгон, көйгөйүңүздү чечүүчү чыныгы команда.';

  @override
  String get socialShowcaseEyebrow => 'БӨЛҮШ';

  @override
  String get socialShowcaseHeading =>
      'Орнотууңузду #SağlamSpot Менен Бөлүшүңүз';

  @override
  String productsLoadError(String error) {
    return 'Продукттарды жүктөөдө ката кетти: $error';
  }

  @override
  String get viewAllButton => 'Баарын Көрүү';

  @override
  String get showcaseEyebrow => 'ВИТРИНА';

  @override
  String get exploreButton => 'Изилде';

  @override
  String get visitUsEyebrow => 'БИЗГЕ КЕЛИҢИЗ';

  @override
  String get visitUsHeading => 'Жөн Гана Салам Айт';

  @override
  String visitUsOpenLine(String hours) {
    return 'Эшигибиз ар дайым ачык. $hours';
  }

  @override
  String get directionsButton => 'Багыт Алуу';

  @override
  String get freeDeliveryLabel => 'Акысыз Жеткирүү';

  @override
  String get busLinesLabel => 'Автобус Линиялары';

  @override
  String get statYearsSuffix => '+ Жыл';

  @override
  String get storeAddress => 'İçerenköy, Ataşehir/İstanbul';

  @override
  String get stayUpdated => 'Жаңылыктардан Кабардар Болуңуз';

  @override
  String get viewButton => 'Көрүү';

  @override
  String get heroSlide2Eyebrow => 'КОЛДОНУЛГАН';

  @override
  String get heroSlide2Title => 'Тарыхы Бар Эмеректер';

  @override
  String get heroSlide2Subtitle =>
      'Кылдаттык менен тандалган, бекем жана мүнөзгө ээ колдонулган буюмдар.';

  @override
  String get heroSlide3Title => 'Толук Коллекцияны Изилдеңиз';

  @override
  String get aboutBadge => '2012-ЖЫЛДАН БЕРИ СИЗДЕР МЕНЕН';

  @override
  String get aboutHeroTitle => 'Sağlam Spot\nСиз Билген Ишеним';

  @override
  String get aboutHeroSubtitle =>
      'Биз айланабызга бардык ишибизде сүйүү жана кам көрүү менен кызмат кылабыз.';

  @override
  String get aboutStoryHeading => 'Биз Кимбиз? (Тарыхыбыз)';

  @override
  String get aboutStoryPara1 =>
      'Максатыбыз — үйүңүзгө жылуулук кошуучу, сапаттуу жана чын дилден жаккан эмеректерди табууга жардам берүү. Жашоо мейкиндигиңизди көркөмдөө биздин ишибиз.';

  @override
  String get aboutStoryPara2 =>
      'Баары 2012-жылы, İçerenköy\'дөгү дал ушул дүкөндөн башталды. Ошондон бери биз конок болгон үйлөрдүн саны дагы да көбөйдү.';

  @override
  String get aboutStoryPara3 =>
      'Бүгүн жаңы жана кылдаттык менен тандалган колдонулган продукттар менен миңдеген кошуналарыбыздын үйүнө конок болдук. Сиздин ишениминиз менен өсүп жатабыз.';

  @override
  String get aboutStoryStartLabel => 'Башталышы';

  @override
  String get aboutStoryExperienceLabel => 'Жылдык Тажрыйба';

  @override
  String get aboutStorySmilesLabel => 'Жайнаган Жүздөр';

  @override
  String get aboutValuesHeading => 'Принциптерибиз';

  @override
  String get aboutValuesSubheading =>
      'Устачылыкта эч качан макулдашпаган принциптерибиз';

  @override
  String get aboutValue1Title => 'Сапат жана Кылдаттык';

  @override
  String get aboutValue1Desc =>
      'Жаңы болобу, колдонулган болобу, кылдаттык менен тандап, сизге дал ошондой сунуштайбыз.';

  @override
  String get aboutValue2Title => 'Жайнаган Жүздөр';

  @override
  String get aboutValue2Desc =>
      'Биз үчүн эң чоң табыш — дүкөндөн ыраазы кетүүчү кошуна. Сиздин канааттанууңуз баарынан мурда келет.';

  @override
  String get aboutValue3Title => 'Эмгекке Урмат';

  @override
  String get aboutValue3Desc =>
      'Эмерек — баалуу эмгек. Колдонулган продукттарга жаңы жашоо берүү менен биз сиздин бюджетиңизди да, айлана-чөйрөнү да коргойбуз.';

  @override
  String get aboutValue4Title => 'Чынчылдык жана Ишеним';

  @override
  String get aboutValue4Desc =>
      'Ачык жана чынчыл устачылык биздин эң чоң баалуулугубуз. Жылдар бою ошол эле жерде сиздер менен биргебиз.';

  @override
  String get aboutMasterHeading => 'Устабыз Менен Таанышыңыз';

  @override
  String get aboutMasterBody =>
      'Устабыз 1995-жылдан бери, башкача айтканда чейрек кылымдан ашык убакыттан бери бул тармакта иштеп келет. Алдыңкы бренддерде (İstikbal) иштеп, эмеректин өзгөчөлүктөрү, бөлүктөрү жана майда-чүйдөсүнө чейин терең билим алган.\n\nЖеткирүү үчүн айдоочулуктан баштап монтаждоого, кардарларды тосуп алуудан ташууга чейин ар бир багытта өзү иштеп, толук тажрыйба топтогон. 2012-жылы \'эми өз дүкөнүм\' деп чечим кабыл алып, бул тажрыйбасын Sağlam Spot\'ко алып келген.\n\nАнын максаты — ал чоң компанияларда үйрөнгөн сапатты кошуна устачылыгынын ынактыгы жана кылдаттыгы менен айкалыштырып, сизге эң мыкты кызматты сунуштоо.';

  @override
  String get aboutDeliveryHeading => 'Жеткирүү жана Монтаждоо Кызматыбыз';

  @override
  String get aboutDeliveryFreeTitle => 'Акысыз Жеткирүү жана Монтаждоо';

  @override
  String get aboutDeliveryZonesLabel => 'Акысыз Кызмат Көрсөтүү Аймактарыбыз:';

  @override
  String get aboutDeliveryZonesList =>
      '• İçerenköy аймагыбыз\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• İnönü жана Bostancı Sanayi сыяктуу жакын кошуналар';

  @override
  String get aboutDeliveryNote =>
      'Маанилүү Эскертүү: Устабыздын ден соолугун коргоо үчүн, лифти жок имараттарда бийик кабаттарга буюмдарды алып чыгуу кызматын өкүнүчтүө сунуштай албайбыз. Түшүнгөнүңүз үчүн рахмат.';

  @override
  String get aboutDeliveryPunctual =>
      '⏰ Сиз менен макулдашкан убакытта эшигиңизде болобуз!';

  @override
  String get aboutTransportHeading => 'Дүкөнүбүзгө Кантип Жетесиз';

  @override
  String get aboutTransportBusIntro => 'Автобус Менен Келсеңиз:';

  @override
  String get aboutBusStop1 => 'Ziyapaşa Аялдамасы (Kadıköy Багыты):';

  @override
  String get aboutBusStop2 => 'İçerenköy Аялдамасы (Kayışdağı Багыты):';

  @override
  String get aboutBusStop3 => 'İçerenköy Аялдамасы (Yeniyol):';

  @override
  String get aboutContactPhoneLabel => 'Телефон (Тез Чечим)';

  @override
  String get aboutContactAddressLabel => 'Дарек (Чайга Күтөбүз)';

  @override
  String get aboutContactAddressValue =>
      'İçerenköy Mahallesi\nBuket Sokak No:6';

  @override
  String get aboutContactHoursLabel => 'Иш Убактыбыз';

  @override
  String get aboutContactHoursValue =>
      'Дүй-Ишм: 09:00 - 22:00\nЖек: 10:00 - 20:00';

  @override
  String get aboutContactHeading => 'Биз Менен Байланышыңыз';

  @override
  String get aboutCallNowButton => 'Азыр Чалыңыз';

  @override
  String get aboutViewMapButton => 'Картадан Көрүү';

  @override
  String get aboutMapHeading => 'Дүкөнүбүз Так Ушул Жерде';

  @override
  String get aboutMapSubtext => 'Багыт алуу үчүн картаны басыңыз';

  @override
  String get newProductsBadgeEyebrow => 'ЖАҢЫ КОЛЛЕКЦИЯ';

  @override
  String get newProductsTitle => 'Жаңы\nКоллекция';

  @override
  String get productsBadgeLabel => 'ПРОДУКТ';

  @override
  String get breadcrumbHome => 'Башкы Бет';

  @override
  String get statTotalProducts => 'ЖАЛПЫ ПРОДУКТ';

  @override
  String get statCategoryLabel => 'КАТЕГОРИЯ';

  @override
  String get statConditionValueNew => 'ЖАҢЫ';

  @override
  String get statConditionLabel => 'АБАЛ';

  @override
  String get statRatingLabel => 'БАА';

  @override
  String get searchBarRichPrefix => 'Кеңири продукт издөө үчүн ';

  @override
  String get searchBarRichOr => ' басыңыз же ';

  @override
  String get searchBarRichHereLink => 'БУЛ ЖЕРГЕ';

  @override
  String get searchBarRichSuffix => ' чыкылдатыңыз.';

  @override
  String get sortNewProductsDefault => 'Жаңылар';

  @override
  String get sortSpotProductsDefault => 'Эң Жаңы';

  @override
  String get sortPriceLowHigh => 'Баасы: Өсүүчү';

  @override
  String get sortPriceHighLow => 'Баасы: Кемүүчү';

  @override
  String get sortMostPopular => 'Эң Популярдуу';

  @override
  String get spotBadgeEyebrow => 'АКЦИЯ ПРОДУКТТАРЫ';

  @override
  String get spotHeroTitle => 'Акция\nПродукттары';

  @override
  String get spotDiscountLabel => 'ЧЕГЕРИМ';

  @override
  String get statSpotProductLabel => 'Акция Продукту';

  @override
  String get statDiscountLabel => 'Чегерим';

  @override
  String get statSupportLabel => 'Колдоо';

  @override
  String get statFreeLabel => 'Акысыз';

  @override
  String get statFreeShippingNote => 'Жакын Аймактарга Гана, Ташуу';

  @override
  String get statFreeShippingShort => 'Ташуу';

  @override
  String get filtersPanelTitle => 'ЧЫПКАЛАР';

  @override
  String get priceRangeSectionTitle => 'БАА ДИАПАЗОНУ';

  @override
  String get clearFiltersButton => 'ЧЫПКАЛАРДЫ ТАЗАЛОО';

  @override
  String get tryDifferentFiltersShort =>
      'Башка чыпкаларды сынап көрсөңүз болот';

  @override
  String get spotBadgeTag => 'АКЦИЯ';

  @override
  String productLoadError(String error) {
    return 'Продукт жүктөлбөй калды: $error';
  }

  @override
  String get productSpecConditionNew => 'Жаңы Продукт';

  @override
  String get productLocationValue => 'İçerenköy, İstanbul';

  @override
  String get sortFeatured => 'Тандалма';

  @override
  String get sortPriceAsc => 'Баасы: Өсүүчү';

  @override
  String get sortPriceDesc => 'Баасы: Кемүүчү';

  @override
  String get languageSelectorTitle => 'Тил Тандоо';

  @override
  String get languageTooltip => 'Тил';

  @override
  String get galleryEmptyMessage =>
      'Бул продуктка азырынча сүрөт кошулган жок.';

  @override
  String get productCardNewBadge => 'ЖАҢЫ';

  @override
  String get sssHelpCenterBadge => 'ЖАРДАМ БОРБОРУ';

  @override
  String get sssHeroTitle => 'Көп Берилүүчү\nСуроолор';

  @override
  String get sssHeroSubtitle => 'Сизди кызыктырган бардык нерсеге жооп';

  @override
  String get sssCategoryAll => 'Баары';

  @override
  String get sssCategoryGeneral => 'Жалпы';

  @override
  String get sssCategoryProductService => 'Продукт & Кызмат';

  @override
  String get sssCategoryDelivery => 'Жеткирүү & Монтаждоо';

  @override
  String get sssCategoryPayment => 'Төлөм & Заказ';

  @override
  String get sssCategoryReturns => 'Кайтаруу & Кепилдик';

  @override
  String get sssCategorySecondHandBuying =>
      'Колдонулган Буюм Сатып Алуу Процесси';

  @override
  String get sssPhoneSupportTitle => 'Телефон Колдоосу';

  @override
  String get sssWorkingHoursTitle => 'Иш Убактысы';

  @override
  String get sssWorkingHoursValue => '09:00 - 22:00';

  @override
  String get sssStoreAddressTitle => 'Дүкөн Дареги';

  @override
  String get sssStoreAddressValue => 'İçerenköy Mahallesi Buket Sok. No:6';

  @override
  String get sssNoAnswerTitle => 'Суроонузга Жооп Табылган Жокпу?';

  @override
  String get sssNoAnswerSubtitle => 'Биз Менен Байланыша Аласыз';

  @override
  String get sssVisitStoreButton => 'Дүкөнгө Баруу';

  @override
  String get sssQ1 =>
      'Устанын иш тажрыйбасы жана кесиптик жолу тууралуу маалымат бере аласызбы?';

  @override
  String get sssA1 =>
      'Устабыз 1995-жылдан бери бул тармакта активдүү иштеп келет. Кесиптик жолунун баштапкы кадамдарынан баштап туруктуу өнүгүп келген. Иш жашоосунда жеткирүү үчүн айдоочулук, ташуу, монтаждоо, кардарларды тосуп алуу сыяктуу көптөгөн кызматтарда иштеп, көп кырдуу тажрыйба топтогон. Айрыкча 2010-жылга чейин İstikbal\'де иштеп, продукттардын өзгөчөлүктөрү, бөлүктөрү жана майда-чүйдөлөрү тууралуу терең билим алган. 2010-жылдан кийин жакын жердеги Işık Çeyiz\'де иштеп, тармактагы билимин арттырган. 2012-жылы өз устачылык дүкөнүн ачуу чечимин кабыл алып, ошондон бери сапаттуу кызматты биринчи планга коюп, тармактагы тажрыйбасын кардарларына эң мыкты түрдө жеткирүүгө умтулган.';

  @override
  String get sssQ2 => 'Sağlam Spot ишенимдүүбү?';

  @override
  String get sssA2 =>
      '2012-жылдан бери İçerenköy\'дө кошуналарыбызга кызмат кылып келебиз. Сансыз үйлөргө конок болдук жана азыр да конок болуп жатабыз.';

  @override
  String get sssQ3 => 'Продукттарды көрүү үчүн дүкөнүңүзгө кел алабы?';

  @override
  String get sssA3 =>
      'Албетте! Тескерисинче, биз да буга атайын сунуш кылабыз. Чай ичип жатып продукттарды өз көзүңүз менен көрүү, кол тийгизүү жана жагып жатабы деп сезүү эң туура. İçerenköy аймагындагы дүкөнүбүздө сизди ар дайым күтөбүз.';

  @override
  String get sssQ4 => 'Колдонулган продукттардын абалы кантип текшерилет?';

  @override
  String get sssA4 =>
      'Биз үчүн колдонулган дегени \'экинчи сорттук\' дегенди билдирбейт. Ар бир продукт устабыздын кылдат текшерүүсүнөн өтөт; тазалоо, кам көрүү жана керектүү оңдоолор толук аткарылат. Сүрөттөрдө эмнени көрсөңүз, дал ошону аласыз, бирок биз баары бир \'келип, өзүңүз көрүңүз\' дейбиз. Өз көзүңүз менен көрүү ар дайым эң жакшысы.';

  @override
  String get sssQ5 => 'Эмеректердин материал сапаты кандай?';

  @override
  String get sssA5 =>
      'Биз ачыктыкка маани беребиз. Ар бир продукттун өз тарыхы жана материалы бар. Ошондуктан бардык майда-чүйдөнү, материал сапатын жана өзгөчөлүктөрдү продукт сүрөттөлүшүнө так жазабыз. Эгер эмнегедир шек санасаңыз, сурактан тартынбаңыз.';

  @override
  String get sssQ6 => 'Продукттардын баасы кантип аныкталат?';

  @override
  String get sssA6 =>
      'Баа белгилегенде продукттун сапатын жана рыноктук шарттарды адилеттик менен эске алабыз. Максатыбыз — бюджетиңизге ооруу түшүрбөй, сапаттуу жана узак жашаган продукттарга жетишиңизге жардам берүү. Канчалык адилет болсо, ошончо алабыз.';

  @override
  String get sssQ7 => 'Продукттарыңызда түс тандоо барбы?';

  @override
  String get sssA7 =>
      'Продукттарыбыз көбүнчө бирдей эмес, жалгыз даана болгондуктан, аларды бар түсүндө сунуштайбыз. Тилекке каршы, ар башка түс тандоолорун жасай албайбыз. Жаккан продукттун түсү — көргөн түсүңүз.';

  @override
  String get sssQ8 => 'Атайын заказ кабыл аласызбы?';

  @override
  String get sssA8 =>
      'Кааласак дагы жасай алмак элек! Бирок биз көбүрөөк азыркы, кылдаттык менен тандалган продукттарыбызга көңүл бурабыз. Атайын өндүрүш же дизайн заказын учурда, тилекке каршы, кабыл ала албайбыз. Даяр продукттарды карап чыгууну сунуштайбыз.';

  @override
  String get sssQ9 => 'Продукт сүрөттөлүшүндө эмнеге көңүл буруш керек?';

  @override
  String get sssA9 =>
      'Эң маанилүү кеңешибиз: өлчөгүч тасма! Продукт сүрөттөлүшүндөгү өлчөмдөрдү үйүңүздөгү коё турган жерге кылдаттык менен салыштырыңыз. \'Сыярбы?\' деген суроону мурунтан чечүү кийинки көйгөйлөрдү алдын алат. Ошондой эле өлчөгөндө коридорду унутпаңыз: жалгыз коё турган жерди эмес, эмеректин эшиктен, коридордон жана баскычтан кантип өтөрүн да өлчөңүз. Материал жана абал маалыматтарын да сөзсүз окуп чыгыңыз.';

  @override
  String get sssQ10 =>
      'Лифти жок имараттарга же бийик кабаттарга жеткиресизби?';

  @override
  String get sssA10 =>
      'Бул биз үчүн эң сезимтал жана маанилүү маселелердин бири. Биз ишти өзүбүз аткарган кичине устачылык дүкөнбүз. Устабыз көп жылдык тажрыйбасы менен эми жаш эмес, ошондуктан анын ден соолугун да ойлошубуз керек. Түшүнгөнүңүздү өтүнөбүз: лифти жок имараттарда бийик кабаттарга (мисалы, 2-кабат жана андан жогору) буюм алып чыгуу жана түшүрүү кызматын такыр сунуштай албайбыз. Заказ бербестен мурун бул маселени тактап алалы, сизди уят абалда калтыргыбыз келбейт.';

  @override
  String get sssQ11 => 'Ташуу кызматын көрсөтөсүзбү?';

  @override
  String get sssA11 =>
      'Албетте, кошуналарыбызга жардам беребиз. Айрыкча İçerenköy жана анын тегерегиндеги Fındıklı, Kayışdağı, Küçükbakkalköy, İnönü жана Bostancı Sanayi сыяктуу жакын аймактарга акысыз ташуу кызматыбыз бар. (Bostancı жана Kozyatağı\'нын кээ бир бөлүктөрүн кошпогондо, жана жаш курагыбыздан улам лифти жок бийик кабаттарга ала албайбыз, аны өзүнчө сүйлөшөбүз).';

  @override
  String get sssQ12 => 'Жеткирүү канча убакыт алат?';

  @override
  String get sssA12 =>
      'Заказ бергениңизде эле сиз менен байланышабыз. \'Качан бошсуз?\' деп сурайбыз. Экөөбүзгө тең ыңгайлуу убакытка макулдашабыз. Адатта 1-3 күн ичинде, макулдашкан убакытта жеткирүү жана монтаждоону аяктайбыз.';

  @override
  String get sssQ13 => 'Монтаждоо кызматын берсизби?';

  @override
  String get sssA13 =>
      'Албетте. Эмеректи алып, эшикке коюп кетүү биздин стиль эмес. Чоң продукттардын баарын устабыз өзү монтаждайт жана бул кызмат үчүн кошумча акы талап кылбайбыз. Сиз жерин гана көрсөтөсүз, калганы бизде.';

  @override
  String get sssQ14 => 'Эмерек заказы канча убакытта жеткирилет?';

  @override
  String get sssA14 =>
      'Продукт даяр болсо, экөөбүз макулдашкан убакытта мүмкүн болушунча тез эшигиңизде болобуз. Монтаждоону да тынчсызданбаңыз; аны алып келгендей эле орнотуп, ошондой жеткиребиз. Адатта баары бир күндүн ичинде бүтөт.';

  @override
  String get sssQ15 => 'Карызга заказ бере алабы?';

  @override
  String get sssA15 =>
      'Бул маселеде түшүнүгүңүздү өтүнөбүз. Устачылык катары аман калышыбыз үчүн \'карызга\' же \'кийинчерээк төлөө\' сыяктуу жол менен, тилекке каршы, иштей албайбыз. Продуктту жеткиргенде макулдашылган акчаны накта алышыбыз керек. Сизди уят абалда калтырбоо үчүн бул эрежени баштан эле айтууну туура көрөбүз.';

  @override
  String get sssQ16 => 'Кантип заказ бере алам?';

  @override
  String get sssA16 =>
      'Эң ишенимдүү жол — ар дайым жүзмө-жүз жол. Сайттан жаккан продуктту белгилеп алып, анан дүкөнүбүзгө келиңиз. Продуктту өз көзүңүз менен көрүп, оюңуздагы суроолорду берип, жагып калса, заказды ошол жерде аяктайлы. Ошондо эч кандай шек калбайт.';

  @override
  String get sssQ17 => 'Продуктту кайтаруу саясатыңыз кандай?';

  @override
  String get sssA17 =>
      'Колдонулган продукттардын табиятынан жана устачылык менен иштегендигибизден улам, тилекке каршы, кайтарууну кабыл ала албайбыз. Ошондуктан \'келиңиз, көрүңүз, чай ичели\' деп ынандырабыз. Сатып алаардан мурун продуктту кылдаттык менен карап, өлчөп чыгуу эң туурасы. Ишенбей туруп сатып алууну аяктабайлы.';

  @override
  String get sssQ18 => 'Продукттарда кепилдик мөөнөтү барбы?';

  @override
  String get sssA18 =>
      'Продукттарыбыз колдонулган болгондуктан, бренддин сунуш кыла турганындай расмий кепилдик мөөнөтүбүз, тилекке каршы, жок. Бирок биз \'саттык, бүттү\' дегендерден эмеспиз. Жеткирүү жана монтаждоо учурунда баары туура иштээрине ынанабыз.';

  @override
  String get sssQ19 =>
      'Үйдөгү буюмдарымды сатууну каалайм, колдонулган буюм сатып аласызбы?';

  @override
  String get sssA19 =>
      'Ооба, дүкөнүбүздө көргөзө турганыбызга ишенген, таза жана кайра сатылуучу тандалма продукттарды сатып алабыз. Бирок дүкөнүбүздүн орду чындыгында абдан кичине болгондуктан, тилекке каршы, бул маселеде абдан тандамалуу мамиле кылабыз.\n\nБул маселеде баштан эле чынчыл болгонду жактырабыз: Биз сунуштаган баа, балким, Letgo сыяктуу платформдордо өзүңүз сата турган баадан бир аз төмөн болушу мүмкүн. Себеби: устачылык катары ошол буюмду алуу үчүн бензин жагабыз, ташуу үчүн эмгек коротобуз жана эң маанилүүсү, аны сатуу үчүн дүкөнүбүздө көргөзүп, бүт кардар процессин (соодалашуу, суроолор ж.б.) өзүбүз аткарабыз.\n\nСиз ошол платформдордо өзүңүз сатканда бул процесстердин баарын өзүңүз алып жүрөсүз. Биз болсо бул түйшүктү сизден алабыз. Сунушубуз ушул кызматты да камтыйт. Түшүнгөнүңүз үчүн рахмат.';

  @override
  String get sssQ20 =>
      'Толук эмерек топтомдорун (уктоочу бөлмө, конок бөлмө топтому ж.б.) сатып аласызбы?';

  @override
  String get sssA20 =>
      'Дүкөнүбүз кичине болгондуктан, тилекке каршы, толук уктоочу бөлмө же диван топтому сыяктуу чоң топтомдорду ала албайбыз. Орубуз абдан чектелген. Биз көбүрөөк сатуусу оңой болгон жалгыз буюмдарга (консоль, шкаф, стол, отургуч сыяктуу) басым жасайбыз.';

  @override
  String get sssQ21 =>
      'Буюмдарым бийик кабатта жана имаратта лифт жок. Барыпсатылабы?';

  @override
  String get sssA21 =>
      'Жеткирүү маселесиндегидей эле, бул биздин эң так эрежебиз. Устабыздын ден соолугуна байланыштуу, лифти жок имараттарда бийик кабаттардан буюм түшүрүүнү такыр аткара албайбыз. Буюмдарыңыз жер кабатына/кире беришине жакын болсо же имаратта жүк лифти болсо гана карай алабыз.';

  @override
  String get sssQ22 => 'Ар дайым буюм сатып аласызбы?';

  @override
  String get sssA22 =>
      'Бул толугу менен дүкөнүбүздөгү бош орунга байланыштуу. Дүкөнүбүз кичине болгондуктан, \'сат-ал\' балансы менен иштейбиз. Кээде продукт абдан жаксак дагы, орун жок болгондуктан ала албай калабыз. Эң туурасы — сатууну каалаган продуктуңуздун сүрөттөрүн бизге жиберүү. Сизге чынчылдык менен \'учурда орун бар\' же \'тилекке каршы, азыр толук\' деп маалымат беребиз.';

  @override
  String get navDiscover => 'Изилдөө';

  @override
  String get navCart => 'Себет';

  @override
  String get navProfile => 'Профиль';

  @override
  String get storeHeroEyebrow => 'ЖАҢЫ КОЛЛЕКЦИЯ';

  @override
  String get storeHeroTitle => 'Үйдөй жылуулук\nтартуулаган эмерек';

  @override
  String get storeHeroSubtitle =>
      'Сапаттуу жаңы жана колдонулган эмеректер, сиз жактырган баада эшигиңизге жеткирилет.';

  @override
  String get storeHeroCta => 'Соода баштоо';

  @override
  String get sectionCategories => 'Категориялар';

  @override
  String get sectionBestSellers => 'Көп сатылгандар';

  @override
  String get sectionNewArrivals => 'Жаңы келгендер';

  @override
  String get seeAll => 'Баарын көрүү';

  @override
  String get cartTitle => 'Себетим';

  @override
  String get cartEmptyTitle => 'Себетиңиз бош';

  @override
  String get cartEmptyDesc =>
      'Жаккан заттарды себетке кошуп, баарын бир билдирүү менен сураштырыңыз.';

  @override
  String get cartTotalLabel => 'Жалпы';

  @override
  String get cartWhatsappCta => 'Себетти WhatsApp аркылуу жөнөтүү';

  @override
  String get cartItemRemoved => 'Себеттен алынып салынды';

  @override
  String get addToCartCta => 'Себетке кошуу';

  @override
  String get addedToCartMessage => 'Себетке кошулду';

  @override
  String get alreadyInCartMessage => 'Бул зат себетте бар';

  @override
  String get settingsTitle => 'Жөндөөлөр';

  @override
  String get settingsLanguageLabel => 'Тил';

  @override
  String get settingsAccountSection => 'Аккаунт';

  @override
  String get settingsGeneralSection => 'Жалпы';

  @override
  String get settingsContact => 'Байланыш';

  @override
  String get settingsCallUs => 'Бизге чалыңыз';

  @override
  String get settingsAdminLogin => 'Админ кирүүсү';

  @override
  String get settingsAppVersion => 'Колдонмонун версиясы';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count зат',
      one: '1 зат',
      zero: 'Себет бош',
    );
    return '$_temp0';
  }
}

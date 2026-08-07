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
}

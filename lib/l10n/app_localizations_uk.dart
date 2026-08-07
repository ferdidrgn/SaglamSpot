// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get brand => 'SAĞLAM SPOT';

  @override
  String get home => 'Головна';

  @override
  String get searchHint => 'Що ви шукали для дому?...';

  @override
  String get collection => 'КОЛЕКЦІЯ';

  @override
  String get eleganceAndComfort => 'Елегантність і комфорт';

  @override
  String productsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Знайдено $count товарів',
      one: 'Знайдено 1 товар',
      zero: 'Товари не знайдено',
    );
    return '$_temp0';
  }

  @override
  String resultsFor(String query) {
    return 'Результати за запитом «$query»';
  }

  @override
  String get seoHomeTitle => 'Sağlam Spot | Вживані та нові меблі';

  @override
  String get seoHomeDesc =>
      'Найкращі ціни на нові та вживані меблі. З гарантією 20-річного бізнесу.';

  @override
  String get seoNewTitle => 'Нові товари | Sağlam Spot';

  @override
  String get seoNewDesc => 'Гарантована та якісна колекція нових меблів.';

  @override
  String get seoSpotTitle => 'Вживані товари | Sağlam Spot';

  @override
  String get seoSpotDesc => 'Економічні та якісні варіанти вживаних меблів.';

  @override
  String get seoAboutTitle => 'Про нас | Sağlam Spot';

  @override
  String get seoAboutDesc =>
      'Адреса довіри в меблевій галузі з нашим 20-річним досвідом.';

  @override
  String get seoProductDetailSuffix => 'Перегляд товару | Sağlam Spot';

  @override
  String get category => 'Категорія';

  @override
  String get categorySofa => 'Дивани та крісла';

  @override
  String get categoryChair => 'Стілець';

  @override
  String get categoryTable => 'Стіл';

  @override
  String get categoryBed => 'Спальня';

  @override
  String get categoryWardrobe => 'Шафа';

  @override
  String get categoryWhite => 'Побутова техніка';

  @override
  String get categoryOther => 'Інше';

  @override
  String get condition => 'Стан';

  @override
  String get conditionAll => 'Усі';

  @override
  String get conditionNew => 'Нове';

  @override
  String get conditionUsed => 'Вживане';

  @override
  String get priceRange => 'Діапазон цін';

  @override
  String get price => 'Ціна';

  @override
  String get save => 'Зберегти';

  @override
  String get explanation => 'Опис';

  @override
  String get clear => 'Очистити';

  @override
  String get filter => 'Фільтр';

  @override
  String get apply => 'Застосувати';

  @override
  String get cancel => 'Скасувати';

  @override
  String get newSeason => 'НОВИЙ СЕЗОН';

  @override
  String get heroTitle => 'Мінімалізм\nВершина комфорту';

  @override
  String get viewCollection => 'ПЕРЕГЛЯНУТИ КОЛЕКЦІЮ';

  @override
  String get featureArtisan => 'Щира майстерність';

  @override
  String get featureDelivery => 'Безпечна доставка';

  @override
  String get featureService => 'Доброзичливий сервіс';

  @override
  String get featureShipping => 'Швидка доставка';

  @override
  String get quickOptions => 'Швидкі варіанти';

  @override
  String get easyFind => 'Легко знайдіть потрібний товар';

  @override
  String get mottoBrand => 'Оновлює старе, цінує нове';

  @override
  String get newCollection => 'Нова колекція';

  @override
  String get newCollectionSub => 'Найновіші товари';

  @override
  String get spotProducts => 'Вживані товари';

  @override
  String get spotProductsSub => 'Товари зі знижкою';

  @override
  String get spotProductsDesc => 'Неймовірні ціни на якісні товари';

  @override
  String get currentCollection => 'ПОТОЧНА КОЛЕКЦІЯ';

  @override
  String get soldProducts => 'ПРОДАНІ ТОВАРИ';

  @override
  String pieces(int count) {
    return '$count шт.';
  }

  @override
  String get stock => 'В НАЯВНОСТІ';

  @override
  String get sold => 'ПРОДАНО';

  @override
  String get byRoom => 'За зонами будинку';

  @override
  String get byRoomSub => 'Особливий вибір для кожного кутка вашого дому';

  @override
  String get roomLivingRoom => 'Вітальня';

  @override
  String get roomLivingRoomSub => 'Центр комфорту';

  @override
  String get roomBedroom => 'Спальня';

  @override
  String get roomBedroomSub => 'Спокійний сон';

  @override
  String get roomKitchen => 'Кухня';

  @override
  String get roomKitchenSub => 'Практичні рішення';

  @override
  String get roomOffice => 'Офіс';

  @override
  String get roomOfficeSub => 'Ефективна робота';

  @override
  String get whoWeAre => 'ХТО МИ?';

  @override
  String get artisanTitle => '20 років щирої майстерності,\nсучасний сервіс.';

  @override
  String get artisanDesc =>
      'Завітайте до нашого магазину, випʼємо чаю; разом оберемо ідеальні меблі для вас.';

  @override
  String get visitUsButton => 'ВІДВІДАЙТЕ НАС';

  @override
  String get statHappyCustomer => 'Задоволений клієнт';

  @override
  String get statExperience => 'Досвід';

  @override
  String get statDelivery => 'Доставка';

  @override
  String get statTrust => 'Довіра';

  @override
  String get explore => 'Досліджувати';

  @override
  String get collections => 'Колекції';

  @override
  String get corporate => 'КОМПАНІЯ';

  @override
  String get aboutUs => 'Про нас';

  @override
  String get contact => 'Контакти';

  @override
  String get contactUs => 'ЗВ\'ЯЖІТЬСЯ З НАМИ';

  @override
  String get sss => 'ЧАПи';

  @override
  String get qualityFurniture => '\'Адреса якісних меблів — Sağlam Spot\'';

  @override
  String get footerDesc =>
      'Маючи понад 20 років досвіду, ми несемо якість і довіру в кожен куточок Стамбула.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT ТІКАРЕТ. УСІ ПРАВА ЗАХИЩЕНІ.';

  @override
  String get errorOccurred => 'Виникла помилка';

  @override
  String get productNotFound => 'Товар не знайдено';

  @override
  String get noImages => 'Немає фото';

  @override
  String get error_check_connection => 'Перевірте підключення до інтернету.';

  @override
  String get error_server_no_response => 'Сервер зараз не відповідає.';

  @override
  String get error_connection => 'Помилка з\'єднання';

  @override
  String get error_connection_lost => 'З\'єднання втрачено';

  @override
  String get status_waiting_connection => 'Очікування з\'єднання...';

  @override
  String get error_no_internet_auto_retry =>
      'Немає підключення до інтернету.\nПродовжиться автоматично після відновлення зв\'язку.';

  @override
  String get goBack => 'Назад';

  @override
  String get galleryEmpty => 'Галерея порожня';

  @override
  String get month_1 => 'Січень';

  @override
  String get month_2 => 'Лютий';

  @override
  String get month_3 => 'Березень';

  @override
  String get month_4 => 'Квітень';

  @override
  String get month_5 => 'Травень';

  @override
  String get month_6 => 'Червень';

  @override
  String get month_7 => 'Липень';

  @override
  String get month_8 => 'Серпень';

  @override
  String get month_9 => 'Вересень';

  @override
  String get month_10 => 'Жовтень';

  @override
  String get month_11 => 'Листопад';

  @override
  String get month_12 => 'Грудень';

  @override
  String get noProductFoundTitle => 'За вашими критеріями товари не знайдено';

  @override
  String get noProductFoundDescription =>
      'Спробуйте інші фільтри або змініть пошуковий запит';

  @override
  String get adminPanelTitle => 'Панель керування';

  @override
  String get totalCount => 'Всього';

  @override
  String get productAddedSuccess => 'Товар успішно додано';

  @override
  String get authOrConnectionError =>
      'Виникла помилка авторизації або з\'єднання';

  @override
  String get fillRequiredFields =>
      'Будь ласка, вкажіть назву товару, ціну та додайте хоча б одне фото!';

  @override
  String get sessionClosed => 'Сесію закрито';

  @override
  String get addNewProduct => 'Додати новий товар';

  @override
  String get productImages => 'Фото товару';

  @override
  String get generalInfo => 'Загальна інформація';

  @override
  String get productNameLabel => 'Назва товару';

  @override
  String get descriptionLabel => 'Опис';

  @override
  String get statusLabel => 'Статус';

  @override
  String get spotSecondHand => 'Спот / Вживане';

  @override
  String get secondHandHint =>
      'Єдиний екземпляр — варіанти кольору не показуються';

  @override
  String get newProductHint => 'Новий товар — можна додати варіанти кольору';

  @override
  String get colorOptionsOptional => 'Варіанти кольору (необов\'язково)';

  @override
  String get noImagesYet => 'Фото ще не додано';

  @override
  String get addImage => 'Додати фото';

  @override
  String get editProductTitle => 'Редагувати товар';

  @override
  String get changeImages => 'Змінити фото';

  @override
  String get saveChanges => 'Зберегти зміни';

  @override
  String get deleteProductTitle => 'Видалити товар';

  @override
  String get deleteProductConfirmSuffix => 'буде видалено. Ви впевнені?';

  @override
  String get yesDelete => 'Так, видалити';

  @override
  String get emptyCategoryProducts => 'У цій категорії товари не знайдено';

  @override
  String get adminLoginSubtitle => 'Вхід до панелі керування';

  @override
  String get emailLabel => 'Ел. пошта';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get loginButton => 'Увійти';

  @override
  String get sponsored => 'Реклама';

  @override
  String get addProductFab => 'Додати товар';

  @override
  String get singlePieceNotice =>
      'Це вживаний товар — в наявності лише один екземпляр, колір і зовнішній вигляд повністю відповідають фотографіям.';

  @override
  String get colorOptionsTitle => 'Варіанти кольору';

  @override
  String get newProductBadge => 'НОВИЙ ТОВАР';

  @override
  String get usedProductBadge => 'ВЖИВАНЕ';

  @override
  String get readMore => 'Читати далі';

  @override
  String get readLess => 'Згорнути';

  @override
  String get specDelivery => 'Доставка';

  @override
  String get specDeliveryValue => 'Протягом 1-2 днів';

  @override
  String get specLocation => 'Місцезнаходження';

  @override
  String get sellerTrustLine =>
      '20 років довіри місцевого бізнесу · Ічеренкьой';

  @override
  String get whatsappCta => 'Написати у WhatsApp';

  @override
  String get callCta => 'Зателефонувати';

  @override
  String get similarProducts => 'Схожі товари';

  @override
  String get conditionShowcase => 'Вітрина';

  @override
  String get productDescriptionTitle => 'Опис';

  @override
  String get loginBrand => 'Sağlam Spot';

  @override
  String get logout => 'Вийти';

  @override
  String get logoutConfirm =>
      'Ви впевнені, що хочете безпечно вийти зі свого облікового запису?';
}

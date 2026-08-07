// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get brand => 'SAĞLAM SPOT';

  @override
  String get home => 'Главная';

  @override
  String get searchHint => 'Что вы искали для дома?...';

  @override
  String get collection => 'КОЛЛЕКЦИЯ';

  @override
  String get eleganceAndComfort => 'Элегантность и комфорт';

  @override
  String productsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдено $count товаров',
      one: 'Найден 1 товар',
      zero: 'Товары не найдены',
    );
    return '$_temp0';
  }

  @override
  String resultsFor(String query) {
    return 'Результаты по запросу «$query»';
  }

  @override
  String get seoHomeTitle => 'Sağlam Spot | Б/у и новая мебель';

  @override
  String get seoHomeDesc =>
      'Лучшие цены на новую и б/у мебель. С гарантией 20-летнего бизнеса.';

  @override
  String get seoNewTitle => 'Новые товары | Sağlam Spot';

  @override
  String get seoNewDesc =>
      'Гарантированная и качественная коллекция новой мебели.';

  @override
  String get seoSpotTitle => 'Б/у товары | Sağlam Spot';

  @override
  String get seoSpotDesc => 'Экономичные и качественные варианты б/у мебели.';

  @override
  String get seoAboutTitle => 'О нас | Sağlam Spot';

  @override
  String get seoAboutDesc =>
      'Адрес доверия в мебельной отрасли с нашим 20-летним опытом.';

  @override
  String get seoProductDetailSuffix => 'Просмотр товара | Sağlam Spot';

  @override
  String get category => 'Категория';

  @override
  String get categorySofa => 'Диваны и кресла';

  @override
  String get categoryChair => 'Стул';

  @override
  String get categoryTable => 'Стол';

  @override
  String get categoryBed => 'Спальня';

  @override
  String get categoryWardrobe => 'Шкаф';

  @override
  String get categoryWhite => 'Бытовая техника';

  @override
  String get categoryOther => 'Другое';

  @override
  String get condition => 'Состояние';

  @override
  String get conditionAll => 'Все';

  @override
  String get conditionNew => 'Новое';

  @override
  String get conditionUsed => 'Б/у';

  @override
  String get priceRange => 'Диапазон цен';

  @override
  String get price => 'Цена';

  @override
  String get save => 'Сохранить';

  @override
  String get explanation => 'Описание';

  @override
  String get clear => 'Очистить';

  @override
  String get filter => 'Фильтр';

  @override
  String get apply => 'Применить';

  @override
  String get cancel => 'Отмена';

  @override
  String get newSeason => 'НОВЫЙ СЕЗОН';

  @override
  String get heroTitle => 'Минимализм\nВершина комфорта';

  @override
  String get viewCollection => 'СМОТРЕТЬ КОЛЛЕКЦИЮ';

  @override
  String get featureArtisan => 'Искреннее ремесло';

  @override
  String get featureDelivery => 'Безопасная доставка';

  @override
  String get featureService => 'Дружелюбный сервис';

  @override
  String get featureShipping => 'Быстрая доставка';

  @override
  String get quickOptions => 'Быстрые варианты';

  @override
  String get easyFind => 'Легко найдите нужный товар';

  @override
  String get mottoBrand => 'Обновляет старое, ценит новое';

  @override
  String get newCollection => 'Новая коллекция';

  @override
  String get newCollectionSub => 'Новейшие товары';

  @override
  String get spotProducts => 'Товары б/у';

  @override
  String get spotProductsSub => 'Товары со скидкой';

  @override
  String get spotProductsDesc => 'Невероятные цены на качественные товары';

  @override
  String get currentCollection => 'ТЕКУЩАЯ КОЛЛЕКЦИЯ';

  @override
  String get soldProducts => 'ПРОДАННЫЕ ТОВАРЫ';

  @override
  String pieces(int count) {
    return '$count шт.';
  }

  @override
  String get stock => 'В НАЛИЧИИ';

  @override
  String get sold => 'ПРОДАНО';

  @override
  String get byRoom => 'По зонам дома';

  @override
  String get byRoomSub => 'Особый выбор для каждого уголка вашего дома';

  @override
  String get roomLivingRoom => 'Гостиная';

  @override
  String get roomLivingRoomSub => 'Центр комфорта';

  @override
  String get roomBedroom => 'Спальня';

  @override
  String get roomBedroomSub => 'Спокойный сон';

  @override
  String get roomKitchen => 'Кухня';

  @override
  String get roomKitchenSub => 'Практичные решения';

  @override
  String get roomOffice => 'Офис';

  @override
  String get roomOfficeSub => 'Эффективная работа';

  @override
  String get whoWeAre => 'КТО МЫ?';

  @override
  String get artisanTitle => '20 лет искреннего ремесла,\nсовременный сервис.';

  @override
  String get artisanDesc =>
      'Приходите в наш магазин, выпьем чаю; вместе выберем идеальную мебель для вас.';

  @override
  String get visitUsButton => 'ПОСЕТИТЕ НАС';

  @override
  String get statHappyCustomer => 'Довольный клиент';

  @override
  String get statExperience => 'Опыт';

  @override
  String get statDelivery => 'Доставка';

  @override
  String get statTrust => 'Доверие';

  @override
  String get explore => 'Исследовать';

  @override
  String get collections => 'Коллекции';

  @override
  String get corporate => 'КОМПАНИЯ';

  @override
  String get aboutUs => 'О нас';

  @override
  String get contact => 'Контакты';

  @override
  String get contactUs => 'СВЯЖИТЕСЬ С НАМИ';

  @override
  String get sss => 'ЧАВО';

  @override
  String get qualityFurniture => '\'Адрес качественной мебели — Sağlam Spot\'';

  @override
  String get footerDesc =>
      'С более чем 20-летним опытом мы приносим качество и доверие в каждую точку Стамбула.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT ТИКАРЕТ. ВСЕ ПРАВА ЗАЩИЩЕНЫ.';

  @override
  String get errorOccurred => 'Произошла ошибка';

  @override
  String get productNotFound => 'Товар не найден';

  @override
  String get noImages => 'Нет фото';

  @override
  String get error_check_connection => 'Проверьте подключение к интернету.';

  @override
  String get error_server_no_response => 'Сервер сейчас не отвечает.';

  @override
  String get error_connection => 'Ошибка соединения';

  @override
  String get error_connection_lost => 'Соединение потеряно';

  @override
  String get status_waiting_connection => 'Ожидание подключения...';

  @override
  String get error_no_internet_auto_retry =>
      'Нет подключения к интернету.\nПродолжится автоматически при восстановлении связи.';

  @override
  String get goBack => 'Назад';

  @override
  String get galleryEmpty => 'Галерея пуста';

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
  String get noProductFoundTitle => 'По вашим критериям товары не найдены';

  @override
  String get noProductFoundDescription =>
      'Попробуйте другие фильтры или измените поисковый запрос';

  @override
  String get adminPanelTitle => 'Панель управления';

  @override
  String get totalCount => 'Всего';

  @override
  String get productAddedSuccess => 'Товар успешно добавлен';

  @override
  String get authOrConnectionError =>
      'Произошла ошибка авторизации или подключения';

  @override
  String get fillRequiredFields =>
      'Пожалуйста, укажите название товара, цену и добавьте хотя бы одно фото!';

  @override
  String get sessionClosed => 'Сессия закрыта';

  @override
  String get addNewProduct => 'Добавить новый товар';

  @override
  String get productImages => 'Фото товара';

  @override
  String get generalInfo => 'Общая информация';

  @override
  String get productNameLabel => 'Название товара';

  @override
  String get descriptionLabel => 'Описание';

  @override
  String get statusLabel => 'Статус';

  @override
  String get spotSecondHand => 'Спот / Б/у';

  @override
  String get secondHandHint =>
      'Единственный экземпляр — варианты цвета не показываются';

  @override
  String get newProductHint => 'Новый товар — можно добавить варианты цвета';

  @override
  String get colorOptionsOptional => 'Варианты цвета (необязательно)';

  @override
  String get noImagesYet => 'Фото ещё не добавлены';

  @override
  String get addImage => 'Добавить фото';

  @override
  String get editProductTitle => 'Редактировать товар';

  @override
  String get changeImages => 'Изменить фото';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get deleteProductTitle => 'Удалить товар';

  @override
  String get deleteProductConfirmSuffix => 'будет удалён. Вы уверены?';

  @override
  String get yesDelete => 'Да, удалить';

  @override
  String get emptyCategoryProducts => 'В этой категории товары не найдены';

  @override
  String get adminLoginSubtitle => 'Вход в панель управления';

  @override
  String get emailLabel => 'Эл. почта';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get loginButton => 'Войти';

  @override
  String get sponsored => 'Реклама';

  @override
  String get addProductFab => 'Добавить товар';

  @override
  String get singlePieceNotice =>
      'Это товар б/у — в наличии только один экземпляр, цвет и внешний вид полностью соответствуют фотографиям.';

  @override
  String get colorOptionsTitle => 'Варианты цвета';

  @override
  String get newProductBadge => 'НОВЫЙ ТОВАР';

  @override
  String get usedProductBadge => 'Б/У';

  @override
  String get readMore => 'Читать далее';

  @override
  String get readLess => 'Свернуть';

  @override
  String get specDelivery => 'Доставка';

  @override
  String get specDeliveryValue => 'В течение 1-2 дней';

  @override
  String get specLocation => 'Местоположение';

  @override
  String get sellerTrustLine => '20 лет доверия местного бизнеса · Ичеренкёй';

  @override
  String get whatsappCta => 'Написать в WhatsApp';

  @override
  String get callCta => 'Позвонить';

  @override
  String get similarProducts => 'Похожие товары';

  @override
  String get conditionShowcase => 'Витрина';

  @override
  String get productDescriptionTitle => 'Описание';

  @override
  String get loginBrand => 'Sağlam Spot';

  @override
  String get logout => 'Выйти';

  @override
  String get logoutConfirm =>
      'Вы уверены, что хотите безопасно выйти из своей учётной записи?';
}

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

  @override
  String get testimonialsHeading => 'Что Говорят Наши Клиенты';

  @override
  String get testimonialsSubheading =>
      'Более 20 лет мы прикоснулись к тысячам домов в İçerenköy и его окрестностях';

  @override
  String get testimonial1Comment =>
      'Купили диван по очень выгодной цене, почти как новый. Доставили в тот же день, из рук в руки — доверие настоящего мастера чувствовалось с самого начала.';

  @override
  String get testimonial2Comment =>
      'Купил здесь спальный гарнитур по акционной цене. Полностью соответствовал описанию, никаких сюрпризов. Однозначно рекомендую.';

  @override
  String get testimonial3Comment =>
      'Сделали оптовую закупку мебели для офиса, и цена, и качество превзошли ожидания. Внимательная, терпеливая команда — спасибо, Sağlam Spot.';

  @override
  String get testimonial4Comment =>
      'Купили обеденный гарнитур без торга, по честной цене. Помогли и с перевозкой, покупали с полным спокойствием.';

  @override
  String get testimonial5Comment =>
      'Искали подержанный шкаф и нашли крепкую, стильную вещь. Лучшее соотношение цены и качества на рынке.';

  @override
  String get testimonial6Comment =>
      'Во время визита в шоурум смогли увидеть товары вживую, это укрепило наше доверие. И после продажи они всегда оставались на связи.';

  @override
  String get howItWorksHeading => 'Как Это Работает';

  @override
  String get step1Title => 'Смотри и Фильтруй';

  @override
  String get step1Desc =>
      'Найди то, что тебе нравится, среди тысяч товаров по категории и ценовому диапазону.';

  @override
  String get step2Title => 'Свяжись с Нами';

  @override
  String get step2Desc =>
      'Свяжись с нашей командой в WhatsApp или по телефону прямо со страницы товара.';

  @override
  String get step3Title => 'Согласуй Цену';

  @override
  String get step3Desc =>
      'Посмотри товар в шоуруме или подтверди по фото, договоритесь о честной цене.';

  @override
  String get step4Title => 'Доставка к Твоей Двери';

  @override
  String get step4Desc =>
      'Быстрая застрахованная доставка в İçerenköy и на Анатолийскую сторону благополучно доставит твою мебель домой.';

  @override
  String get tipsEyebrow => 'СОВЕТЫ';

  @override
  String get tipsHeading => 'Советы по Уходу от Мастера';

  @override
  String get tip1Title => 'Сделайте Гостиную Уютнее';

  @override
  String get tip1Desc =>
      'Оставьте зазор 1-2 см между диваном и стеной — это улучшает циркуляцию воздуха и делает комнату просторнее.';

  @override
  String get tip1Category => 'Расстановка';

  @override
  String get tip2Title => 'Рабочий Стол, Который Всегда Выглядит Чисто';

  @override
  String get tip2Desc =>
      'Уберите кабели с помощью органайзеров и протирайте круговыми движениями микрофиброй — стол всегда будет как новый.';

  @override
  String get tip2Category => 'Уборка';

  @override
  String get tip3Title => 'Удобная Организация Кухни';

  @override
  String get tip3Desc =>
      'Тяжёлые предметы — на нижние полки, часто используемые — на уровень глаз: практично и безопасно.';

  @override
  String get tip3Category => 'Организация';

  @override
  String get tip4Title => 'Обустройте Уютный Уголок для Сна';

  @override
  String get tip4Desc =>
      'Расположите изголовье кровати подальше от окна, чтобы минимизировать свет — маленькое изменение для заметно более глубокого сна.';

  @override
  String get tip4Category => 'Комфорт';

  @override
  String get tip5Title => 'Освежите Свой Шкаф';

  @override
  String get tip5Desc =>
      'Разделите сезонную одежду, вешайте всё в одну сторону — экономит место и облегчает выбор каждое утро.';

  @override
  String get tip5Category => 'Организация';

  @override
  String get tip6Title => 'Продлите Жизнь Деревянной Мебели';

  @override
  String get tip6Desc =>
      'Защищайте от прямых солнечных лучей, несколько раз в год протирайте питательным маслом — самый эффективный уход от царапин и выцветания.';

  @override
  String get tip6Category => 'Уход';

  @override
  String get tip7Title => 'Сделайте Тканевые Диваны Более Долговечными';

  @override
  String get tip7Desc =>
      'Пылесосьте раз в неделю, сразу промакивайте пятна влажной тканью — если ждать, пятно въедается в ткань.';

  @override
  String get tip7Category => 'Уход';

  @override
  String get tip8Title => 'Выберите Правильное Освещение';

  @override
  String get tip8Desc =>
      'Используйте многоуровневое освещение вместо одной люстры: общий, рабочий и атмосферный свет вместе делают комнату теплее.';

  @override
  String get tip8Category => 'Освещение';

  @override
  String get tip9Title => 'Используйте Маленькие Пространства с Умом';

  @override
  String get tip9Desc =>
      'Выбирайте складную, многофункциональную мебель; настенные полки освобождают напольное пространство.';

  @override
  String get tip9Category => 'Организация';

  @override
  String get tip10Title => 'Превратите Свой Балкон в Жилое Пространство';

  @override
  String get tip10Desc =>
      'Устойчивый к погоде комплект мебели и несколько горшечных растений сделают балкон самым любимым уголком дома.';

  @override
  String get tip10Category => 'Улица';

  @override
  String get popularCategoriesHeading => 'Популярные Категории';

  @override
  String get popularCategoriesSub => 'Найди подходящую мебель в один клик';

  @override
  String categoryProductCount(int count) {
    return '$count товаров';
  }

  @override
  String get newsletterSubscribeSuccess =>
      'Вы успешно подписались на нашу рассылку!';

  @override
  String get newsletterHeading => 'Узнавайте о Новых Товарах Первыми';

  @override
  String get newsletterDesc =>
      'Получайте акционные предложения, новые коллекции и кампании прямо на почту. Никакого спама, только полезные предложения.';

  @override
  String get emailHint => 'Ваш адрес электронной почты';

  @override
  String get emailRequired => 'Требуется адрес электронной почты';

  @override
  String get emailInvalid => 'Введите корректный адрес электронной почты';

  @override
  String get whyUsHeading => 'Почему Sağlam Spot?';

  @override
  String get usp1Title => '20 Лет Надёжного Мастерства';

  @override
  String get usp1Desc =>
      'Более двадцати лет ремесленной работы в İçerenköy и тысячи довольных клиентов.';

  @override
  String get usp2Title => 'Цены Ниже Рыночных';

  @override
  String get usp2Desc =>
      'Благодаря работе без посредников у нас лучшие цены на акционную и новую мебель.';

  @override
  String get usp3Title => 'Проверенное Качество Товара';

  @override
  String get usp3Desc =>
      'Каждый товар проходит проверку конструкции и ткани/отделки перед продажей.';

  @override
  String get usp4Title => 'Поддержка После Продажи';

  @override
  String get usp4Desc =>
      'Настоящая команда, с которой можно связаться даже после доставки, решающая вашу проблему.';

  @override
  String get socialShowcaseEyebrow => 'ПОДЕЛИСЬ';

  @override
  String get socialShowcaseHeading =>
      'Поделитесь Своим Интерьером с #SağlamSpot';

  @override
  String productsLoadError(String error) {
    return 'Произошла ошибка при загрузке товаров: $error';
  }

  @override
  String get viewAllButton => 'Посмотреть Все';

  @override
  String get showcaseEyebrow => 'ВИТРИНА';

  @override
  String get exploreButton => 'Исследовать';

  @override
  String get visitUsEyebrow => 'ЗАЙДИТЕ К НАМ';

  @override
  String get visitUsHeading => 'Просто Скажите Привет';

  @override
  String visitUsOpenLine(String hours) {
    return 'Наша дверь всегда открыта. $hours';
  }

  @override
  String get directionsButton => 'Проложить Маршрут';

  @override
  String get freeDeliveryLabel => 'Бесплатная Доставка';

  @override
  String get busLinesLabel => 'Автобусные Маршруты';

  @override
  String get statYearsSuffix => '+ Лет';

  @override
  String get storeAddress => 'İçerenköy, Ataşehir/İstanbul';

  @override
  String get stayUpdated => 'Будьте в Курсе';

  @override
  String get viewButton => 'Смотреть';

  @override
  String get heroSlide2Eyebrow => 'Б/У';

  @override
  String get heroSlide2Title => 'Мебель со Своей Историей';

  @override
  String get heroSlide2Subtitle =>
      'Тщательно отобранные, крепкие подержанные вещи с характером.';

  @override
  String get heroSlide3Title => 'Исследуйте Всю Коллекцию';

  @override
  String get aboutBadge => 'С ВАМИ С 2012 ГОДА';

  @override
  String get aboutHeroTitle => 'Sağlam Spot\nДоверие, Которое Вы Знаете';

  @override
  String get aboutHeroSubtitle =>
      'Мы служим нашему району с любовью и заботой во всём, что делаем.';

  @override
  String get aboutStoryHeading => 'Кто Мы? (Наша История)';

  @override
  String get aboutStoryPara1 =>
      'Наша цель — помочь вам найти качественную мебель, которая привнесёт тепло в ваш дом и действительно придётся по душе. Украшать ваши жилые пространства — наша работа.';

  @override
  String get aboutStoryPara2 =>
      'Всё началось в 2012 году, именно в этом магазине в İçerenköy. С тех пор число домов, в которые нас приглашали, только росло.';

  @override
  String get aboutStoryPara3 =>
      'Сегодня, с новыми и тщательно отобранными подержанными товарами, мы побывали гостями в домах тысяч наших соседей. Мы растём благодаря вашему доверию.';

  @override
  String get aboutStoryStartLabel => 'Основание';

  @override
  String get aboutStoryExperienceLabel => 'Лет Опыта';

  @override
  String get aboutStorySmilesLabel => 'Счастливых Клиентов';

  @override
  String get aboutValuesHeading => 'Наши Принципы';

  @override
  String get aboutValuesSubheading =>
      'Принципы, которыми мы никогда не поступаемся как мастера своего дела';

  @override
  String get aboutValue1Title => 'Качество и Внимание';

  @override
  String get aboutValue1Desc =>
      'Новое или подержанное — мы выбираем тщательно и предлагаем вам именно таким.';

  @override
  String get aboutValue2Title => 'Счастливые Клиенты';

  @override
  String get aboutValue2Desc =>
      'Для нас самая большая награда — сосед, уходящий из магазина довольным. Ваше удовлетворение важнее всего.';

  @override
  String get aboutValue3Title => 'Уважение к Труду';

  @override
  String get aboutValue3Desc =>
      'Мебель — ценный труд. Давая подержанным товарам новую жизнь, мы бережём и ваш бюджет, и природу.';

  @override
  String get aboutValue4Title => 'Честность и Доверие';

  @override
  String get aboutValue4Desc =>
      'Прозрачное, честное мастерство — наша главная ценность. Мы годами остаёмся с вами на одном и том же месте.';

  @override
  String get aboutMasterHeading => 'Познакомьтесь с Нашим Мастером';

  @override
  String get aboutMasterBody =>
      'Наш мастер активно работает в этой сфере с 1995 года — более четверти века. Он работал в ведущих брендах (İstikbal), приобретя глубокие знания об особенностях, деталях и тонкостях мебели.\n\nОт вождения при доставке до сборки, от встречи клиентов до перевозки — он лично работал во всех направлениях, накопив всесторонний опыт. В 2012 году он решил открыть собственный магазин, перенеся этот опыт в Sağlam Spot.\n\nЕго цель — соединить качество, усвоенное в тех крупных компаниях, с теплотой и вниманием местного мастера, чтобы предложить вам лучший сервис.';

  @override
  String get aboutDeliveryHeading => 'Наша Услуга Доставки и Сборки';

  @override
  String get aboutDeliveryFreeTitle => 'Бесплатная Доставка и Сборка';

  @override
  String get aboutDeliveryZonesLabel => 'Наши Зоны Бесплатного Обслуживания:';

  @override
  String get aboutDeliveryZonesList =>
      '• Наш район İçerenköy\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• Соседние районы, такие как İnönü и Bostancı Sanayi';

  @override
  String get aboutDeliveryNote =>
      'Важное Примечание: Для сохранения здоровья нашего мастера мы, к сожалению, не можем поднимать вещи на верхние этажи зданий без лифта. Спасибо за понимание.';

  @override
  String get aboutDeliveryPunctual =>
      '⏰ Мы у вашей двери в согласованное время!';

  @override
  String get aboutTransportHeading => 'Как Добраться до Нашего Магазина';

  @override
  String get aboutTransportBusIntro => 'Если Вы Едете на Автобусе:';

  @override
  String get aboutBusStop1 => 'Остановка Ziyapaşa (в сторону Kadıköy):';

  @override
  String get aboutBusStop2 => 'Остановка İçerenköy (в сторону Kayışdağı):';

  @override
  String get aboutBusStop3 => 'Остановка İçerenköy (Yeniyol):';

  @override
  String get aboutContactPhoneLabel => 'Телефон (Быстрый Ответ)';

  @override
  String get aboutContactAddressLabel => 'Адрес (Ждём Вас на Чай)';

  @override
  String get aboutContactAddressValue =>
      'İçerenköy Mahallesi\nBuket Sokak No:6';

  @override
  String get aboutContactHoursLabel => 'Наши Часы Работы';

  @override
  String get aboutContactHoursValue =>
      'Пн-Сб: 09:00 - 22:00\nВс: 10:00 - 20:00';

  @override
  String get aboutContactHeading => 'Свяжитесь с Нами';

  @override
  String get aboutCallNowButton => 'Позвонить Сейчас';

  @override
  String get aboutViewMapButton => 'Посмотреть на Карте';

  @override
  String get aboutMapHeading => 'Наш Магазин Прямо Здесь';

  @override
  String get aboutMapSubtext => 'Нажмите на карту, чтобы получить маршрут';

  @override
  String get newProductsBadgeEyebrow => 'НОВАЯ КОЛЛЕКЦИЯ';

  @override
  String get newProductsTitle => 'Новая\nКоллекция';

  @override
  String get productsBadgeLabel => 'ТОВАРОВ';

  @override
  String get breadcrumbHome => 'Главная';

  @override
  String get statTotalProducts => 'ВСЕГО ТОВАРОВ';

  @override
  String get statCategoryLabel => 'КАТЕГОРИИ';

  @override
  String get statConditionValueNew => 'НОВОЕ';

  @override
  String get statConditionLabel => 'СОСТОЯНИЕ';

  @override
  String get statRatingLabel => 'РЕЙТИНГ';

  @override
  String get searchBarRichPrefix => 'Для детального поиска товаров нажмите ';

  @override
  String get searchBarRichOr => ' или кликните ';

  @override
  String get searchBarRichHereLink => 'ЗДЕСЬ';

  @override
  String get searchBarRichSuffix => '.';

  @override
  String get sortNewProductsDefault => 'Новинки';

  @override
  String get sortSpotProductsDefault => 'Новинки';

  @override
  String get sortPriceLowHigh => 'Цена: по возрастанию';

  @override
  String get sortPriceHighLow => 'Цена: по убыванию';

  @override
  String get sortMostPopular => 'Самые Популярные';

  @override
  String get spotBadgeEyebrow => 'АКЦИОННЫЕ ТОВАРЫ';

  @override
  String get spotHeroTitle => 'Акционные\nТовары';

  @override
  String get spotDiscountLabel => 'СКИДКА';

  @override
  String get statSpotProductLabel => 'Акционных Товаров';

  @override
  String get statDiscountLabel => 'Скидка';

  @override
  String get statSupportLabel => 'Поддержка';

  @override
  String get statFreeLabel => 'Бесплатно';

  @override
  String get statFreeShippingNote => 'Только для Близлежащих Районов, Доставка';

  @override
  String get statFreeShippingShort => 'Доставка';

  @override
  String get filtersPanelTitle => 'ФИЛЬТРЫ';

  @override
  String get dragToRotateHint => 'Проведите для других фото';

  @override
  String get studioQuotaExceededNotice =>
      'Достигнут месячный лимит студийных фото — фотографии добавлены в исходном виде.';

  @override
  String get studioPreparingWait =>
      'Подготовка студийного фото, пожалуйста, подождите...';

  @override
  String get retry => 'Повторить';

  @override
  String get studioGenerationFailed => 'Не удалось создать студийное фото';

  @override
  String get storePhotoLabel => 'Магазин';

  @override
  String get studioPhotoLabel => 'Студия';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingStart => 'Начать';

  @override
  String get onboardingPage1Eyebrow => 'ДОБРО ПОЖАЛОВАТЬ В SAĞLAM SPOT';

  @override
  String get onboardingPage1Title => 'Правильный Выбор\nДля Вашего Дома';

  @override
  String get onboardingPage1Desc =>
      'Более 20 лет проверенного мастерства — качественная мебель теперь у вас в кармане.';

  @override
  String get onboardingPage2Eyebrow => 'Б/У И НОВАЯ МЕБЕЛЬ ВМЕСТЕ';

  @override
  String get onboardingPage2Title => 'Варианты На\nЛюбой Бюджет';

  @override
  String get onboardingPage2Desc =>
      'От выгодных предложений б/у до новой коллекции — легко найдите то, что искали.';

  @override
  String get onboardingPage3Eyebrow => 'ПОКУПАЙТЕ С УВЕРЕННОСТЬЮ';

  @override
  String get onboardingPage3Title => 'Нашли Что-то?\nСпросите Сейчас';

  @override
  String get onboardingPage3Desc =>
      'Свяжитесь с нами в WhatsApp одним касанием, узнайте цену и договоритесь напрямую.';

  @override
  String get favoritesTitle => 'Мои Избранные';

  @override
  String get favoritesEmptyTitle => 'Ваш список избранного пуст';

  @override
  String get favoritesEmptyDesc =>
      'Нажмите на значок сердца на понравившихся товарах, чтобы добавить их в избранное.';

  @override
  String get sortPanelTitle => 'СОРТИРОВКА';

  @override
  String get priceRangeSectionTitle => 'ДИАПАЗОН ЦЕН';

  @override
  String get clearFiltersButton => 'СБРОСИТЬ ФИЛЬТРЫ';

  @override
  String get tryDifferentFiltersShort => 'Вы можете попробовать другие фильтры';

  @override
  String get spotBadgeTag => 'АКЦИЯ';

  @override
  String productLoadError(String error) {
    return 'Не удалось загрузить товар: $error';
  }

  @override
  String get productSpecConditionNew => 'Новый Товар';

  @override
  String get productLocationValue => 'İçerenköy, İstanbul';

  @override
  String get sortFeatured => 'Рекомендуемые';

  @override
  String get sortPriceAsc => 'Цена: по возрастанию';

  @override
  String get sortPriceDesc => 'Цена: по убыванию';

  @override
  String get languageSelectorTitle => 'Выбор Языка';

  @override
  String get languageTooltip => 'Язык';

  @override
  String get galleryEmptyMessage =>
      'К этому товару пока не добавлены фотографии.';

  @override
  String get productCardNewBadge => 'НОВОЕ';

  @override
  String get sssHelpCenterBadge => 'ЦЕНТР ПОМОЩИ';

  @override
  String get sssHeroTitle => 'Часто Задаваемые\nВопросы';

  @override
  String get sssHeroSubtitle => 'Ответы на всё, что вас интересует';

  @override
  String get sssCategoryAll => 'Все';

  @override
  String get sssCategoryGeneral => 'Общее';

  @override
  String get sssCategoryProductService => 'Товар и Услуга';

  @override
  String get sssCategoryDelivery => 'Доставка и Сборка';

  @override
  String get sssCategoryPayment => 'Оплата и Заказ';

  @override
  String get sssCategoryReturns => 'Возврат и Гарантия';

  @override
  String get sssCategorySecondHandBuying => 'Процесс Скупки Б/У Товаров';

  @override
  String get sssPhoneSupportTitle => 'Телефонная Поддержка';

  @override
  String get sssWorkingHoursTitle => 'Часы Работы';

  @override
  String get sssWorkingHoursValue => '09:00 - 22:00';

  @override
  String get sssStoreAddressTitle => 'Адрес Магазина';

  @override
  String get sssStoreAddressValue => 'İçerenköy Mahallesi Buket Sok. No:6';

  @override
  String get sssNoAnswerTitle => 'Не Нашли Ответ на Свой Вопрос?';

  @override
  String get sssNoAnswerSubtitle => 'Вы Можете Связаться с Нами';

  @override
  String get sssVisitStoreButton => 'Посетить Магазин';

  @override
  String get sssQ1 => 'Расскажите о трудовом пути и опыте мастера?';

  @override
  String get sssA1 =>
      'Наш мастер активно работает в этой сфере с 1995 года. С первых шагов своей карьеры он непрерывно развивался. За свою трудовую жизнь он занимал множество должностей — водитель при доставках, перевозка, сборка, встреча клиентов — приобретя разносторонний опыт. В частности, до 2010 года он работал в İstikbal и за это время глубоко изучил особенности продукции, детали и тонкости. После 2010 года работал в соседнем Işık Çeyiz, дополнительно повысив свою квалификацию в отрасли. В 2012 году он решил открыть собственный ремесленный магазин и с тех пор стремится ставить качественный сервис на первое место, передавая свой отраслевой опыт клиентам наилучшим образом.';

  @override
  String get sssQ2 => 'Можно ли доверять Sağlam Spot?';

  @override
  String get sssA2 =>
      'С 2012 года мы служим нашим соседям в İçerenköy. Мы были гостями бесчисленных домов и продолжаем ими быть.';

  @override
  String get sssQ3 =>
      'Могу ли я прийти в ваш магазин, чтобы посмотреть товары?';

  @override
  String get sssA3 =>
      'Конечно! Более того, мы это особенно рекомендуем. Увидеть товары вживую, потрогать их и почувствовать, подходят ли они вам, за чашкой чая — самый правильный способ. Мы всегда ждём вас в нашем магазине в районе İçerenköy.';

  @override
  String get sssQ4 => 'Как проверяется состояние подержанных товаров?';

  @override
  String get sssA4 =>
      'Для нас подержанное не означает \'второй сорт\'. Каждый товар проходит тщательную проверку нашего мастера; чистка, уход и необходимый ремонт выполняются в полном объёме. То, что вы видите на фото, это то, что вы получите, но мы всё равно говорим \'приходите и убедитесь сами\'. Увидеть своими глазами всегда лучше всего.';

  @override
  String get sssQ5 => 'Каково качество материалов мебели?';

  @override
  String get sssA5 =>
      'Для нас важна прозрачность. У каждого товара своя история и свой материал. Поэтому мы чётко указываем все детали, качество материала и характеристики в описании товара. Если у вас есть какие-либо сомнения, не стесняйтесь спрашивать.';

  @override
  String get sssQ6 => 'Как определяются цены на товары?';

  @override
  String get sssA6 =>
      'При определении цен мы справедливо учитываем и качество товара, и рыночные условия. Наша цель — дать вам возможность приобрести качественные, долговечные товары, не напрягая ваш бюджет. Мы просим ровно столько, сколько справедливо, не больше.';

  @override
  String get sssQ7 => 'Есть ли у ваших товаров варианты цвета?';

  @override
  String get sssA7 =>
      'Поскольку наши товары обычно являются единичными экземплярами, мы предлагаем их в том цвете, в котором они есть. К сожалению, мы не можем предложить разные варианты цвета. Цвет, который вам понравился, — это цвет, который вы видите.';

  @override
  String get sssQ8 => 'Принимаете ли вы индивидуальные заказы?';

  @override
  String get sssA8 =>
      'Хотели бы мы это делать! Но мы в основном сосредоточены на наших существующих, тщательно отобранных товарах. К сожалению, мы пока не можем принимать заказы на индивидуальное изготовление или дизайн. Рекомендуем ознакомиться с уже готовыми товарами.';

  @override
  String get sssQ9 => 'На что обратить внимание в описаниях товаров?';

  @override
  String get sssA9 =>
      'Наш самый важный совет: рулетка! Пожалуйста, тщательно сравните размеры в описании товара с местом, куда вы планируете его поставить дома. Заранее решить вопрос \'а поместится ли?\' предотвращает проблемы в дальнейшем. Также не забудьте про коридор при замере: измеряйте не только место установки, но и то, как мебель пройдёт через дверь, коридор и лестницу. Обязательно прочитайте и информацию о материале и состоянии.';

  @override
  String get sssQ10 =>
      'Доставляете ли вы в здания без лифта или на верхние этажи?';

  @override
  String get sssA10 =>
      'Это одна из самых деликатных и важных тем для нас. Мы небольшой мастерской бизнес, который выполняет работу лично. Наш мастер после многолетнего опыта уже не молод, поэтому мы также должны думать о его здоровье. Просим вашего понимания: в зданиях без лифта на верхние этажи (например, 2-й этаж и выше) мы совершенно не можем предложить услугу подъёма и спуска вещей. Пожалуйста, давайте проясним этот вопрос до оформления заказа, мы не хотим вас разочаровывать.';

  @override
  String get sssQ11 => 'Предоставляете ли вы услугу перевозки?';

  @override
  String get sssA11 =>
      'Конечно, мы помогаем нашим соседям. У нас есть бесплатная доставка прежде всего в İçerenköy, а также в близлежащие районы Fındıklı, Kayışdağı, Küçükbakkalköy, İnönü и Bostancı Sanayi. (За исключением некоторых частей Bostancı и Kozyatağı, и из-за возраста мы не можем поднимать вещи на верхние этажи без лифта, об этом поговорим отдельно).';

  @override
  String get sssQ12 => 'Сколько времени занимает доставка?';

  @override
  String get sssA12 =>
      'Как только вы оформите заказ, мы свяжемся с вами. Спросим \'когда вам удобно?\'. Договоримся о ближайшем времени, удобном для нас обоих. Обычно завершаем доставку и сборку в течение 1-3 дней, в согласованное время.';

  @override
  String get sssQ13 => 'Предоставляете ли вы услугу сборки?';

  @override
  String get sssA13 =>
      'Конечно. Забрать мебель и оставить у двери — не наш стиль. Все крупные товары лично собирает наш мастер, и мы не берём дополнительную плату за эту услугу. Вы просто покажите место, остальное на нас.';

  @override
  String get sssQ14 => 'Сколько времени занимает доставка заказа мебели?';

  @override
  String get sssA14 =>
      'Если товар готов, мы будем у вашей двери как можно скорее, в согласованное вместе время. Не переживайте и о сборке; мы соберём его так же, как привезли, и доставим готовым. Обычно всё завершается в тот же день.';

  @override
  String get sssQ15 => 'Можно ли заказать в кредит / с оплатой позже?';

  @override
  String get sssA15 =>
      'Просим вашего понимания в этом вопросе. Как ремесленники, чтобы удержаться на плаву, мы, к сожалению, не можем работать по схемам вроде \'в кредит\' или \'оплата позже\'. Мы должны получить согласованную сумму наличными при доставке товара. Мы предпочитаем сообщать об этом правиле заранее, чтобы не поставить вас в неловкое положение.';

  @override
  String get sssQ16 => 'Как я могу оформить заказ?';

  @override
  String get sssA16 =>
      'Самый надёжный способ — всегда личная встреча. Отметьте понравившийся товар на сайте, затем приходите в наш магазин. Посмотрите товар вживую, задайте интересующие вас вопросы, и если он вам подойдёт, завершим ваш заказ прямо там. Так не останется никаких сомнений.';

  @override
  String get sssQ17 => 'Какова ваша политика возврата товара?';

  @override
  String get sssA17 =>
      'Из-за природы подержанных товаров и нашего ремесленного стиля работы мы, к сожалению, не можем принимать возвраты. Именно поэтому мы настаиваем: \'приходите, посмотрите, выпейте с нами чаю\'. Правильнее всего тщательно осмотреть и измерить товар перед покупкой. Не будем завершать покупку, не будучи уверенными.';

  @override
  String get sssQ18 => 'Есть ли гарантийный срок на товары?';

  @override
  String get sssA18 =>
      'Поскольку наши товары подержанные, у нас, к сожалению, нет официального гарантийного срока, как у бренда. Но мы не из тех, кто говорит \'продали и всё\'. Мы убеждаемся, что всё работает исправно во время доставки и сборки.';

  @override
  String get sssQ19 => 'Хочу продать вещи из своего дома, скупаете ли вы б/у?';

  @override
  String get sssA19 =>
      'Да, мы скупаем отдельные чистые и пригодные для перепродажи товары, которые, как мы считаем, можем выставить в нашем магазине. Однако, поскольку площадь нашего магазина действительно очень мала, мы, к сожалению, вынуждены быть очень избирательными в этом вопросе.\n\nМы предпочитаем быть честными с самого начала: предложение, которое вы получите от нас, может быть немного ниже, чем сумма, которую вы могли бы выручить сами на таких платформах, как Letgo. Причина в следующем: как ремесленники, мы тратим бензин, чтобы забрать вещь, вкладываем труд в перевозку, и, что самое важное, берём на себя весь процесс работы с клиентом (торг, вопросы и т. д.), чтобы выставить и продать её в нашем магазине.\n\nКогда вы продаёте сами на этих платформах, вы берёте на себя все эти процессы. Мы же снимаем с вас эти хлопоты. Наше предложение включает и эту услугу. Спасибо за понимание.';

  @override
  String get sssQ20 =>
      'Скупаете ли вы полные комплекты мебели (спальня, гостиная и т. д.)?';

  @override
  String get sssA20 =>
      'Поскольку наш магазин небольшой, мы, к сожалению, не можем принимать полные крупные комплекты, такие как спальный или диванный гарнитур. Наше пространство очень ограничено. Мы больше сосредоточены на отдельных предметах, которые легче продать, таких как консоли, шкафы, столы и стулья.';

  @override
  String get sssQ21 =>
      'Мои вещи находятся на высоком этаже, а в здании нет лифта. Скупите ли вы их всё равно?';

  @override
  String get sssA21 =>
      'Точно так же, как и в вопросе доставки, это наше самое чёткое правило. Из-за состояния здоровья нашего мастера мы совершенно не можем спускать вещи с верхних этажей в зданиях без лифта. Мы можем рассмотреть это только в том случае, если ваши вещи находятся рядом с первым этажом/входом или в здании есть грузовой лифт.';

  @override
  String get sssQ22 => 'Всегда ли вы скупаете вещи?';

  @override
  String get sssA22 =>
      'Это полностью зависит от того, сколько места у нас есть в магазине на данный момент. Поскольку наш магазин небольшой, мы работаем по принципу баланса \'продать-купить\'. Иногда товар нам очень нравится, но мы не можем его взять из-за отсутствия места. Лучше всего прислать нам фотографии товара, который вы хотите продать. Мы честно сообщим вам, есть ли у нас сейчас место или мы, к сожалению, сейчас заполнены.';

  @override
  String get navDiscover => 'Обзор';

  @override
  String get navCart => 'Корзина';

  @override
  String get navProfile => 'Профиль';

  @override
  String get storeHeroEyebrow => 'НОВАЯ КОЛЛЕКЦИЯ';

  @override
  String get storeHeroTitle => 'Мебель, в которой\nуютно, как дома';

  @override
  String get storeHeroSubtitle =>
      'Качественная новая и б/у мебель с доставкой по ценам, которые вам понравятся.';

  @override
  String get storeHeroCta => 'Начать покупки';

  @override
  String get sectionCategories => 'Категории';

  @override
  String get sectionBestSellers => 'Хиты продаж';

  @override
  String get sectionNewArrivals => 'Новинки';

  @override
  String get seeAll => 'Смотреть все';

  @override
  String get cartTitle => 'Моя корзина';

  @override
  String get cartEmptyTitle => 'Ваша корзина пуста';

  @override
  String get cartEmptyDesc =>
      'Добавьте понравившиеся товары и уточните всё одним сообщением.';

  @override
  String get cartTotalLabel => 'Итого';

  @override
  String get cartWhatsappCta => 'Отправить корзину в WhatsApp';

  @override
  String get cartItemRemoved => 'Удалено из корзины';

  @override
  String get addToCartCta => 'В корзину';

  @override
  String get addedToCartMessage => 'Добавлено в корзину';

  @override
  String get alreadyInCartMessage => 'Уже в корзине';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguageLabel => 'Язык';

  @override
  String get settingsAccountSection => 'Аккаунт';

  @override
  String get settingsGeneralSection => 'Общее';

  @override
  String get settingsContact => 'Контакты';

  @override
  String get settingsCallUs => 'Позвонить нам';

  @override
  String get settingsAdminLogin => 'Вход для администратора';

  @override
  String get settingsAppVersion => 'Версия приложения';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товаров',
      one: '1 товар',
      zero: 'Корзина пуста',
    );
    return '$_temp0';
  }

  @override
  String get settingsRateApp => 'Оценить приложение';

  @override
  String get settingsShareApp => 'Поделиться приложением';

  @override
  String get settingsPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String get settingsTerms => 'Условия использования';

  @override
  String get legalContentTurkishOnly =>
      'Этот контент пока доступен только на турецком языке.';

  @override
  String get doubleBackToExit => 'Нажмите назад еще раз, чтобы выйти';

  @override
  String get productLinkLabel => 'Ссылка на товар';

  @override
  String get settingsAppSection => 'Приложение';

  @override
  String get settingsLegalSection => 'Правовая информация';

  @override
  String get recentlyViewedTitle => 'Недавно просмотренные';

  @override
  String get productTrustBadgeVerified => 'Проверенный продавец';

  @override
  String get productTrustBadgeNegotiate => 'Торг через WhatsApp';

  @override
  String get productTrustBadgeDelivery => 'Доставка на месте';

  @override
  String get howToBuyTitle => 'Как купить?';

  @override
  String get howToBuyStep1Title => 'Написать в WhatsApp';

  @override
  String get howToBuyStep1Desc =>
      'Если товар понравился, свяжитесь с нами через WhatsApp.';

  @override
  String get howToBuyStep2Title => 'Обсудите цену';

  @override
  String get howToBuyStep2Desc => 'Согласуйте цену и детали доставки вместе.';

  @override
  String get howToBuyStep3Title => 'Заберите товар';

  @override
  String get howToBuyStep3Desc =>
      'После договорённости безопасно заберите свой товар.';

  @override
  String get listedToday => 'Добавлено сегодня';

  @override
  String listedDaysAgo(int days) {
    return 'Добавлено $days дн. назад';
  }

  @override
  String listedWeeksAgo(int weeks) {
    return 'Добавлено $weeks нед. назад';
  }

  @override
  String get settingsAppearanceSection => 'Внешний вид';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeSystem => 'Системная';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get notificationsEmptyTitle => 'Пока нет уведомлений';

  @override
  String get notificationsEmptyDesc =>
      'Новые акции и объявления появятся здесь';

  @override
  String get markAllReadAction => 'Отметить все как прочитанные';

  @override
  String get clearAllAction => 'Очистить всё';

  @override
  String get timeJustNow => 'Только что';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes мин. назад';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours ч. назад';
  }

  @override
  String timeDaysAgoGeneric(int days) {
    return '$days дн. назад';
  }

  @override
  String get catalogCategoryTitleSofa => 'Диван и кушетка';

  @override
  String get catalogCategoryTitleChair => 'Стул и кресло';

  @override
  String get catalogCategoryTitleTable => 'Обеденный стол';

  @override
  String get catalogCategoryTitleBed => 'Кровать и основание';

  @override
  String get catalogCategoryTitleWardrobe => 'Гардероб и шкаф';

  @override
  String get catalogCategoryTitleWhite => 'Бытовая техника';

  @override
  String get catalogCategoryTitleOther => 'Декор';

  @override
  String get mottoTitlePart1 => 'Смотрите до визита, ';

  @override
  String get mottoTitlePart2 => 'Приходите, когда понравится.';

  @override
  String get mottoSubtitle =>
      'Просмотрите нашу витрину, прежде чем прийти в магазин — заходите, когда найдёте то, что вам понравится.';

  @override
  String get gatewayNewEyebrow => 'НОВАЯ КОЛЛЕКЦИЯ';

  @override
  String get gatewayNewTitle => 'Вечная классика';

  @override
  String get gatewayNewSubtitle => 'Абсолютно новая, неиспользованная мебель.';

  @override
  String get gatewayNewButton => 'Смотреть коллекцию';

  @override
  String get gatewaySpotEyebrow => 'СПОТ-ПРЕДЛОЖЕНИЯ';

  @override
  String get gatewaySpotTitle => 'Бывшая в употреблении, но крепкая';

  @override
  String get gatewaySpotSubtitle =>
      'Бывшие в употреблении, но практичные вещи по доступным ценам.';

  @override
  String get gatewaySpotButton => 'Смотреть предложения';

  @override
  String freeDeliveryZonesNote(String zones) {
    return 'Бесплатная доставка действует только в районах $zones';
  }

  @override
  String get footerWarehouseTagline => 'СКЛАД МЕБЕЛИ · İÇERENKÖY / ATAŞEHİR';

  @override
  String get locationAndHoursLabel => 'АДРЕС И ЧАСЫ РАБОТЫ';

  @override
  String get openNowLabel => 'СЕЙЧАС ОТКРЫТО';

  @override
  String get closedNowLabel => 'СЕЙЧАС ЗАКРЫТО';

  @override
  String todayHoursPrefix(String hours) {
    return '· Сегодня $hours';
  }

  @override
  String get openInMapsButton => 'Открыть на карте';

  @override
  String get viewOnGoogleMapsButton => 'Посмотреть на Google Картах';

  @override
  String gatewayProductCount(int count) {
    return '$count товаров';
  }

  @override
  String get gatewayNewEyebrowShort => 'НОВОЕ';

  @override
  String get gatewayNewTitleShort => 'Коллекция';

  @override
  String get gatewaySpotEyebrowShort => 'СПОТ';

  @override
  String get gatewaySpotTitleShort => 'Предложения';

  @override
  String get spotHeroEyebrow => 'СКЛАД ВЫГОДНЫХ ПРЕДЛОЖЕНИЙ';

  @override
  String get spotHeroSubtitle =>
      'Бывшие в употреблении, но практичные вещи. Товары как новые на любой бюджет. Возможен торг.';

  @override
  String spotHeroDealCount(int count) {
    return '$count+ предложений';
  }

  @override
  String get spotStatNegotiable => 'Возможен торг';

  @override
  String get spotStatUsed => 'Б/у';

  @override
  String get spotShowcaseBadgeTitle => 'Полностью восстановлено';

  @override
  String get spotShowcaseBadgeSubtitle =>
      'Каждый товар проверяется индивидуально перед доставкой.';

  @override
  String get spotBreadcrumbLabel => 'Спот и секонд-хенд';

  @override
  String get aphorismEyebrow => 'У НАС ЕСТЬ ДЕВИЗ';

  @override
  String get aphorismQuote =>
      'Не изношено, а прожито с любовью.\nХорошая мебель никогда не стареет — она просто меняет дом.';

  @override
  String get aphorismBody =>
      'Именно поэтому мы здесь: чтобы вещи, в которых ещё есть жизнь, нашли новый дом, где их оценят по достоинству.';

  @override
  String get spotSearchHint => 'Поиск предложений…';

  @override
  String get priceRangeLabel => 'Диапазон цен';

  @override
  String get filtersSheetTitle => 'ФИЛЬТРЫ';

  @override
  String get applyFiltersButton => 'Применить фильтры';

  @override
  String get priceRangeSheetTitle => 'ДИАПАЗОН ЦЕН';

  @override
  String get applyButton => 'Применить';

  @override
  String get sortSheetTitle => 'СОРТИРОВКА';

  @override
  String get sortNewest => 'Новые предложения';

  @override
  String get sortPopular => 'Самые просматриваемые';

  @override
  String get spotEmptyStateTitle => 'Мы не нашли предложений по этим критериям';

  @override
  String get spotEmptyStateSubtitle =>
      'Попробуйте сбросить фильтры или выбрать другую категорию.';

  @override
  String get newHeroTitleLine1 => 'Для вашего дома\n';

  @override
  String get newHeroTitleEmphasis => 'Вечные ';

  @override
  String get newHeroButtonCollection => 'Смотреть коллекцию';

  @override
  String get newHeroButtonQuickFilter => 'Быстрый фильтр';

  @override
  String get newStatActiveProductLabel => 'АКТИВНЫХ ТОВАРОВ';

  @override
  String get newStatControlledStockLabel => 'ПРОВЕРЕННЫЙ ЗАПАС';

  @override
  String get shopByCategoryTitlePrefix => 'По категории: ';

  @override
  String get shopByCategoryTitleEmphasis => 'Исследуйте';

  @override
  String get showAllButton => 'Показать все';

  @override
  String get newEmptyStateTitle => 'Мебель по вашему запросу не найдена';

  @override
  String get newEmptyStateSubtitle =>
      'Попробуйте изменить запрос или сбросить фильтры.';

  @override
  String get sortOptionsSheetTitle => 'Параметры сортировки';

  @override
  String get newSortNewest => 'Новые';

  @override
  String get newSortPopular => 'Самые просматриваемые';

  @override
  String get cartWhatsappGreeting =>
      'Здравствуйте, хочу узнать об этих товарах:\n\n';

  @override
  String cartWhatsappAllProductsLine(String url) {
    return 'Все товары: $url';
  }

  @override
  String get defaultWhatsappGreeting => 'Здравствуйте, хочу узнать о мебели.';

  @override
  String get spotHeroPageTitle => 'Секонд-хенд и спот';

  @override
  String get sortByPriceLowHigh => 'Цена: по возрастанию';

  @override
  String get sortByPriceHighLow => 'Цена: по убыванию';

  @override
  String get seoSssTitle => 'Частые вопросы | Sağlam Spot';

  @override
  String get seoSssDesc =>
      'Ответы на все вопросы о покупке, доставке и гарантии.';

  @override
  String get seoSearchTitle => 'Поиск товаров | Sağlam Spot';

  @override
  String get seoSearchDesc =>
      'Найдите нужную мебель, отфильтровав по категории, цене и состоянию.';

  @override
  String get seoPrivacyTitle => 'Политика конфиденциальности | Sağlam Spot';

  @override
  String get seoTermsTitle => 'Условия использования | Sağlam Spot';

  @override
  String get howItWorksEyebrow => 'ПРОЦЕСС';

  @override
  String get whyUsEyebrow => 'ПРЕИМУЩЕСТВА';
}

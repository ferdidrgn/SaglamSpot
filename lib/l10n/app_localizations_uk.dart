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

  @override
  String get testimonialsHeading => 'Що Кажуть Наші Клієнти';

  @override
  String get testimonialsSubheading =>
      'Понад 20 років ми торкаємось тисяч домівок в İçerenköy та околицях';

  @override
  String get testimonial1Comment =>
      'Купили диван за дуже вигідною ціною, майже як новий. Доставили того ж дня, з рук у руки — довіра справжнього майстра відчувалася з самого початку.';

  @override
  String get testimonial2Comment =>
      'Купив тут спальний гарнітур за акційною ціною. Повністю відповідав опису товару, жодних несподіванок. Однозначно рекомендую.';

  @override
  String get testimonial3Comment =>
      'Зробили оптову закупівлю меблів для офісу, ціна і якість перевершили очікування. Уважна, терпляча команда — дякуємо, Sağlam Spot.';

  @override
  String get testimonial4Comment =>
      'Купили обідній гарнітур без торгу, за чесною ціною. Допомогли й з перевезенням, купували з повним спокоєм.';

  @override
  String get testimonial5Comment =>
      'Шукали вживану шафу і знайшли міцну, стильну річ. Найкраще співвідношення ціни та якості на ринку.';

  @override
  String get testimonial6Comment =>
      'Під час візиту в шоурум змогли побачити товари наживо, це зміцнило нашу довіру. І після продажу вони завжди залишалися на зв\'язку.';

  @override
  String get howItWorksHeading => 'Як Це Працює';

  @override
  String get step1Title => 'Переглядай і Фільтруй';

  @override
  String get step1Desc =>
      'Знайди те, що тобі подобається, серед тисяч товарів за категорією та ціновим діапазоном.';

  @override
  String get step2Title => 'Зв\'яжись з Нами';

  @override
  String get step2Desc =>
      'Зв\'яжись з нашою командою у WhatsApp або по телефону прямо зі сторінки товару.';

  @override
  String get step3Title => 'Узгодь Ціну';

  @override
  String get step3Desc =>
      'Подивись товар у шоурумі або підтверди фото, домовтеся про чесну ціну.';

  @override
  String get step4Title => 'Доставка до Твоїх Дверей';

  @override
  String get step4Desc =>
      'Швидка застрахована доставка в İçerenköy та на Анатолійський бік безпечно доставить твої меблі додому.';

  @override
  String get tipsEyebrow => 'ПОРАДИ';

  @override
  String get tipsHeading => 'Поради з Догляду від Майстра';

  @override
  String get tip1Title => 'Зробіть Вітальню Затишнішою';

  @override
  String get tip1Desc =>
      'Залиште 1-2 см проміжку між диваном і стіною — це покращує циркуляцію повітря та робить кімнату просторішою.';

  @override
  String get tip1Category => 'Розташування';

  @override
  String get tip2Title => 'Робочий Стіл, Який Завжди Виглядає Чисто';

  @override
  String get tip2Desc =>
      'Впорядкуйте кабелі за допомогою органайзерів і протирайте мікрофіброю круговими рухами — стіл завжди буде як новий.';

  @override
  String get tip2Category => 'Прибирання';

  @override
  String get tip3Title => 'Зручна Організація Кухні';

  @override
  String get tip3Desc =>
      'Важкі речі — на нижні полиці, часто вживані — на рівень очей: практично і безпечно.';

  @override
  String get tip3Category => 'Організація';

  @override
  String get tip4Title => 'Облаштуйте Затишний Куточок для Сну';

  @override
  String get tip4Desc =>
      'Розташуйте узголів\'я ліжка подалі від вікна, щоб мінімізувати світло — невелика зміна для помітно глибшого сну.';

  @override
  String get tip4Category => 'Комфорт';

  @override
  String get tip5Title => 'Освіжіть Свою Шафу';

  @override
  String get tip5Desc =>
      'Розділіть сезонний одяг, вішайте все в один бік — економить місце й полегшує вибір щоранку.';

  @override
  String get tip5Category => 'Організація';

  @override
  String get tip6Title => 'Продовжте Життя Дерев\'яним Меблям';

  @override
  String get tip6Desc =>
      'Захищайте від прямих сонячних променів, кілька разів на рік протирайте живильною олією — найефективніший догляд від подряпин і вицвітання.';

  @override
  String get tip6Category => 'Догляд';

  @override
  String get tip7Title => 'Зробіть Тканинні Дивани Довговічнішими';

  @override
  String get tip7Desc =>
      'Пилососьте раз на тиждень, одразу промокайте плями вологою тканиною — якщо чекати, пляма вбирається у тканину.';

  @override
  String get tip7Category => 'Догляд';

  @override
  String get tip8Title => 'Оберіть Правильне Освітлення';

  @override
  String get tip8Desc =>
      'Використовуйте багаторівневе освітлення замість однієї люстри: загальне, робоче та атмосферне світло разом роблять кімнату теплішою.';

  @override
  String get tip8Category => 'Освітлення';

  @override
  String get tip9Title => 'Розумно Використовуйте Маленькі Простори';

  @override
  String get tip9Desc =>
      'Обирайте складні, багатофункціональні меблі; настінні полиці звільняють простір на підлозі.';

  @override
  String get tip9Category => 'Організація';

  @override
  String get tip10Title => 'Перетворіть Свій Балкон на Житловий Простір';

  @override
  String get tip10Desc =>
      'Стійкий до погоди комплект меблів і кілька рослин у горщиках зроблять балкон найулюбленішим куточком дому.';

  @override
  String get tip10Category => 'Вулиця';

  @override
  String get popularCategoriesHeading => 'Популярні Категорії';

  @override
  String get popularCategoriesSub => 'Знайди потрібні меблі в один клік';

  @override
  String categoryProductCount(int count) {
    return '$count товарів';
  }

  @override
  String get newsletterSubscribeSuccess =>
      'Ви успішно підписалися на нашу розсилку!';

  @override
  String get newsletterHeading => 'Дізнавайтесь про Нові Товари Першими';

  @override
  String get newsletterDesc =>
      'Отримуйте акційні пропозиції, нові колекції та кампанії прямо на пошту. Жодного спаму, лише корисні пропозиції.';

  @override
  String get emailHint => 'Ваша електронна пошта';

  @override
  String get emailRequired => 'Потрібна електронна пошта';

  @override
  String get emailInvalid => 'Введіть коректну електронну пошту';

  @override
  String get whyUsHeading => 'Чому Sağlam Spot?';

  @override
  String get usp1Title => '20 Років Надійної Майстерності';

  @override
  String get usp1Desc =>
      'Понад двадцять років ремісничої роботи в İçerenköy і тисячі задоволених клієнтів.';

  @override
  String get usp2Title => 'Ціни Нижчі за Ринкові';

  @override
  String get usp2Desc =>
      'Завдяки роботі без посередників у нас найкращі ціни на акційні та нові меблі.';

  @override
  String get usp3Title => 'Перевірена Якість Товару';

  @override
  String get usp3Desc =>
      'Кожен товар проходить перевірку конструкції та тканини/оздоблення перед продажем.';

  @override
  String get usp4Title => 'Підтримка Після Продажу';

  @override
  String get usp4Desc =>
      'Справжня команда, з якою можна зв\'язатися навіть після доставки, яка вирішує вашу проблему.';

  @override
  String get socialShowcaseEyebrow => 'ПОДІЛИСЬ';

  @override
  String get socialShowcaseHeading =>
      'Поділіться Своїм Інтер\'єром з #SağlamSpot';

  @override
  String productsLoadError(String error) {
    return 'Сталася помилка під час завантаження товарів: $error';
  }

  @override
  String get viewAllButton => 'Переглянути Всі';

  @override
  String get showcaseEyebrow => 'ВІТРИНА';

  @override
  String get exploreButton => 'Досліджувати';

  @override
  String get visitUsEyebrow => 'ЗАЙДІТЬ ДО НАС';

  @override
  String get visitUsHeading => 'Просто Скажіть Привіт';

  @override
  String visitUsOpenLine(String hours) {
    return 'Наші двері завжди відчинені. $hours';
  }

  @override
  String get directionsButton => 'Прокласти Маршрут';

  @override
  String get freeDeliveryLabel => 'Безкоштовна Доставка';

  @override
  String get busLinesLabel => 'Автобусні Маршрути';

  @override
  String get statYearsSuffix => '+ Років';

  @override
  String get storeAddress => 'İçerenköy, Ataşehir/İstanbul';

  @override
  String get stayUpdated => 'Будьте в Курсі';

  @override
  String get viewButton => 'Переглянути';

  @override
  String get heroSlide2Eyebrow => 'Б/В';

  @override
  String get heroSlide2Title => 'Меблі зі Своєю Історією';

  @override
  String get heroSlide2Subtitle =>
      'Ретельно відібрані, міцні вживані речі з характером.';

  @override
  String get heroSlide3Title => 'Досліджуйте Всю Колекцію';

  @override
  String get aboutBadge => 'З ВАМИ З 2012 РОКУ';

  @override
  String get aboutHeroTitle => 'Sağlam Spot\nДовіра, Яку Ви Знаєте';

  @override
  String get aboutHeroSubtitle =>
      'Ми служимо нашому району з любов\'ю та турботою в усьому, що робимо.';

  @override
  String get aboutStoryHeading => 'Хто Ми? (Наша Історія)';

  @override
  String get aboutStoryPara1 =>
      'Наша мета — допомогти вам знайти якісні меблі, які привнесуть тепло у ваш дім і дійсно припадуть до душі. Прикрашати ваші житлові простори — наша робота.';

  @override
  String get aboutStoryPara2 =>
      'Все почалося у 2012 році, саме в цьому магазині в İçerenköy. Відтоді кількість домівок, куди нас запрошували, лише зростала.';

  @override
  String get aboutStoryPara3 =>
      'Сьогодні, з новими та ретельно відібраними вживаними товарами, ми побували гостями в домівках тисяч наших сусідів. Ми зростаємо завдяки вашій довірі.';

  @override
  String get aboutStoryStartLabel => 'Заснування';

  @override
  String get aboutStoryExperienceLabel => 'Років Досвіду';

  @override
  String get aboutStorySmilesLabel => 'Задоволених Клієнтів';

  @override
  String get aboutValuesHeading => 'Наші Принципи';

  @override
  String get aboutValuesSubheading =>
      'Принципи, якими ми ніколи не поступаємося як майстри своєї справи';

  @override
  String get aboutValue1Title => 'Якість і Увага';

  @override
  String get aboutValue1Desc =>
      'Нове чи вживане — ми обираємо ретельно і пропонуємо вам саме таким.';

  @override
  String get aboutValue2Title => 'Задоволені Клієнти';

  @override
  String get aboutValue2Desc =>
      'Для нас найбільша нагорода — сусід, який виходить з магазину задоволеним. Ваше задоволення понад усе.';

  @override
  String get aboutValue3Title => 'Повага до Праці';

  @override
  String get aboutValue3Desc =>
      'Меблі — цінна праця. Даючи вживаним товарам нове життя, ми бережемо і ваш бюджет, і природу.';

  @override
  String get aboutValue4Title => 'Чесність і Довіра';

  @override
  String get aboutValue4Desc =>
      'Прозора, чесна майстерність — наша найбільша цінність. Ми роками залишаємося з вами на тому самому місці.';

  @override
  String get aboutMasterHeading => 'Познайомтеся з Нашим Майстром';

  @override
  String get aboutMasterBody =>
      'Наш майстер активно працює в цій сфері з 1995 року — понад чверть століття. Він працював у провідних брендах (İstikbal), набувши глибоких знань про особливості, деталі та тонкощі меблів.\n\nВід водіння під час доставки до збирання, від зустрічі клієнтів до перевезення — він особисто працював у всіх напрямках, накопичивши всебічний досвід. У 2012 році він вирішив відкрити власний магазин, перенісши цей досвід у Sağlam Spot.\n\nЙого мета — поєднати якість, засвоєну у тих великих компаніях, з теплотою та увагою місцевого майстра, щоб запропонувати вам найкращий сервіс.';

  @override
  String get aboutDeliveryHeading => 'Наша Послуга Доставки та Збирання';

  @override
  String get aboutDeliveryFreeTitle => 'Безкоштовна Доставка та Збирання';

  @override
  String get aboutDeliveryZonesLabel =>
      'Наші Зони Безкоштовного Обслуговування:';

  @override
  String get aboutDeliveryZonesList =>
      '• Наш район İçerenköy\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• Сусідні райони, такі як İnönü та Bostancı Sanayi';

  @override
  String get aboutDeliveryNote =>
      'Важлива Примітка: Для збереження здоров\'я нашого майстра ми, на жаль, не можемо підіймати речі на верхні поверхи будівель без ліфта. Дякуємо за розуміння.';

  @override
  String get aboutDeliveryPunctual =>
      '⏰ Ми біля ваших дверей у погоджений час!';

  @override
  String get aboutTransportHeading => 'Як Дістатися до Нашого Магазину';

  @override
  String get aboutTransportBusIntro => 'Якщо Ви Їдете Автобусом:';

  @override
  String get aboutBusStop1 => 'Зупинка Ziyapaşa (у напрямку Kadıköy):';

  @override
  String get aboutBusStop2 => 'Зупинка İçerenköy (у напрямку Kayışdağı):';

  @override
  String get aboutBusStop3 => 'Зупинка İçerenköy (Yeniyol):';

  @override
  String get aboutContactPhoneLabel => 'Телефон (Швидка Відповідь)';

  @override
  String get aboutContactAddressLabel => 'Адреса (Чекаємо на Чай)';

  @override
  String get aboutContactAddressValue =>
      'İçerenköy Mahallesi\nBuket Sokak No:6';

  @override
  String get aboutContactHoursLabel => 'Наші Години Роботи';

  @override
  String get aboutContactHoursValue =>
      'Пн-Сб: 09:00 - 22:00\nНд: 10:00 - 20:00';

  @override
  String get aboutContactHeading => 'Зв\'яжіться з Нами';

  @override
  String get aboutCallNowButton => 'Зателефонувати Зараз';

  @override
  String get aboutViewMapButton => 'Переглянути на Карті';

  @override
  String get aboutMapHeading => 'Наш Магазин Саме Тут';

  @override
  String get aboutMapSubtext => 'Натисніть на карту, щоб отримати маршрут';

  @override
  String get newProductsBadgeEyebrow => 'НОВА КОЛЕКЦІЯ';

  @override
  String get newProductsTitle => 'Нова\nКолекція';

  @override
  String get productsBadgeLabel => 'ТОВАРІВ';

  @override
  String get breadcrumbHome => 'Головна';

  @override
  String get statTotalProducts => 'ВСЬОГО ТОВАРІВ';

  @override
  String get statCategoryLabel => 'КАТЕГОРІЇ';

  @override
  String get statConditionValueNew => 'НОВЕ';

  @override
  String get statConditionLabel => 'СТАН';

  @override
  String get statRatingLabel => 'РЕЙТИНГ';

  @override
  String get searchBarRichPrefix => 'Для детального пошуку товарів натисніть ';

  @override
  String get searchBarRichOr => ' або клікніть ';

  @override
  String get searchBarRichHereLink => 'ТУТ';

  @override
  String get searchBarRichSuffix => '.';

  @override
  String get sortNewProductsDefault => 'Новинки';

  @override
  String get sortSpotProductsDefault => 'Новинки';

  @override
  String get sortPriceLowHigh => 'Ціна: за зростанням';

  @override
  String get sortPriceHighLow => 'Ціна: за спаданням';

  @override
  String get sortMostPopular => 'Найпопулярніші';

  @override
  String get spotBadgeEyebrow => 'АКЦІЙНІ ТОВАРИ';

  @override
  String get spotHeroTitle => 'Акційні\nТовари';

  @override
  String get spotDiscountLabel => 'ЗНИЖКА';

  @override
  String get statSpotProductLabel => 'Акційних Товарів';

  @override
  String get statDiscountLabel => 'Знижка';

  @override
  String get statSupportLabel => 'Підтримка';

  @override
  String get statFreeLabel => 'Безкоштовно';

  @override
  String get statFreeShippingNote => 'Лише для Найближчих Районів, Доставка';

  @override
  String get statFreeShippingShort => 'Доставка';

  @override
  String get filtersPanelTitle => 'ФІЛЬТРИ';

  @override
  String get dragToRotateHint => 'Проведіть для інших фото';

  @override
  String get studioQuotaExceededNotice =>
      'Досягнуто місячний ліміт студійних фото — фотографії додано в оригінальному вигляді.';

  @override
  String get studioPreparingWait => 'Підготовка студійного фото, зачекайте...';

  @override
  String get retry => 'Повторити';

  @override
  String get studioGenerationFailed => 'Не вдалося створити студійне фото';

  @override
  String get storePhotoLabel => 'Магазин';

  @override
  String get studioPhotoLabel => 'Студія';

  @override
  String get onboardingSkip => 'Пропустити';

  @override
  String get onboardingStart => 'Почати';

  @override
  String get onboardingPage1Eyebrow => 'ЛАСКАВО ПРОСИМО В SAĞLAM SPOT';

  @override
  String get onboardingPage1Title => 'Правильна Адреса\nДля Вашого Дому';

  @override
  String get onboardingPage1Desc =>
      'Понад 20 років перевіреної майстерності — якісні меблі тепер у вашій кишені.';

  @override
  String get onboardingPage2Eyebrow => 'Б/В ТА НОВІ МЕБЛІ РАЗОМ';

  @override
  String get onboardingPage2Title => 'Варіанти На\nБудь-Який Бюджет';

  @override
  String get onboardingPage2Desc =>
      'Від вигідних пропозицій б/в до нової колекції — легко знайдіть те, що шукали.';

  @override
  String get onboardingPage3Eyebrow => 'КУПУЙТЕ З ВПЕВНЕНІСТЮ';

  @override
  String get onboardingPage3Title => 'Знайшли Щось?\nЗапитайте Зараз';

  @override
  String get onboardingPage3Desc =>
      'Зв\'яжіться з нами у WhatsApp одним дотиком, дізнайтеся ціну та домовляйтеся напряму.';

  @override
  String get favoritesTitle => 'Мої Улюблені';

  @override
  String get favoritesEmptyTitle => 'Ваш список улюблених порожній';

  @override
  String get favoritesEmptyDesc =>
      'Натисніть на значок серця на товарах, які вам сподобались, щоб додати їх в улюблені.';

  @override
  String get sortPanelTitle => 'СОРТУВАННЯ';

  @override
  String get priceRangeSectionTitle => 'ДІАПАЗОН ЦІН';

  @override
  String get clearFiltersButton => 'СКИНУТИ ФІЛЬТРИ';

  @override
  String get tryDifferentFiltersShort => 'Ви можете спробувати інші фільтри';

  @override
  String get spotBadgeTag => 'АКЦІЯ';

  @override
  String productLoadError(String error) {
    return 'Не вдалося завантажити товар: $error';
  }

  @override
  String get productSpecConditionNew => 'Новий Товар';

  @override
  String get productLocationValue => 'İçerenköy, İstanbul';

  @override
  String get sortFeatured => 'Рекомендовані';

  @override
  String get sortPriceAsc => 'Ціна: за зростанням';

  @override
  String get sortPriceDesc => 'Ціна: за спаданням';

  @override
  String get languageSelectorTitle => 'Вибір Мови';

  @override
  String get languageTooltip => 'Мова';

  @override
  String get galleryEmptyMessage => 'До цього товару ще не додано фотографій.';

  @override
  String get productCardNewBadge => 'НОВЕ';

  @override
  String get sssHelpCenterBadge => 'ЦЕНТР ДОПОМОГИ';

  @override
  String get sssHeroTitle => 'Часті\nЗапитання';

  @override
  String get sssHeroSubtitle => 'Відповіді на все, що вас цікавить';

  @override
  String get sssCategoryAll => 'Усі';

  @override
  String get sssCategoryGeneral => 'Загальне';

  @override
  String get sssCategoryProductService => 'Товар і Послуга';

  @override
  String get sssCategoryDelivery => 'Доставка і Збирання';

  @override
  String get sssCategoryPayment => 'Оплата і Замовлення';

  @override
  String get sssCategoryReturns => 'Повернення і Гарантія';

  @override
  String get sssCategorySecondHandBuying => 'Процес Скупівлі Б/В Товарів';

  @override
  String get sssPhoneSupportTitle => 'Телефонна Підтримка';

  @override
  String get sssWorkingHoursTitle => 'Години Роботи';

  @override
  String get sssWorkingHoursValue => '09:00 - 22:00';

  @override
  String get sssStoreAddressTitle => 'Адреса Магазину';

  @override
  String get sssStoreAddressValue => 'İçerenköy Mahallesi Buket Sok. No:6';

  @override
  String get sssNoAnswerTitle => 'Не Знайшли Відповідь на Своє Запитання?';

  @override
  String get sssNoAnswerSubtitle => 'Ви Можете Зв\'язатися з Нами';

  @override
  String get sssVisitStoreButton => 'Відвідати Магазин';

  @override
  String get sssQ1 => 'Розкажіть про трудовий шлях та досвід майстра?';

  @override
  String get sssA1 =>
      'Наш майстер активно працює в цій галузі з 1995 року. З перших кроків своєї кар\'єри він постійно розвивався. Протягом трудового життя він обіймав багато посад — водій під час доставок, перевезення, збирання, зустріч клієнтів — набувши різнобічного досвіду. Зокрема, до 2010 року він працював в İstikbal і за цей час глибоко вивчив особливості продукції, деталі та тонкощі. Після 2010 року працював у сусідньому Işık Çeyiz, додатково підвищивши свою кваліфікацію в галузі. У 2012 році він вирішив відкрити власний ремісничий магазин і відтоді прагне ставити якісний сервіс на перше місце, передаючи свій галузевий досвід клієнтам якнайкраще.';

  @override
  String get sssQ2 => 'Чи можна довіряти Sağlam Spot?';

  @override
  String get sssA2 =>
      'З 2012 року ми служимо нашим сусідам в İçerenköy. Ми були гостями незліченних домівок і продовжуємо ними бути.';

  @override
  String get sssQ3 => 'Чи можу я прийти у ваш магазин, щоб переглянути товари?';

  @override
  String get sssA3 =>
      'Звичайно! Більше того, ми це особливо радимо. Побачити товари наживо, доторкнутися до них і відчути, чи підходять вони вам, за чашкою чаю — найправильніший спосіб. Ми завжди чекаємо на вас у нашому магазині в районі İçerenköy.';

  @override
  String get sssQ4 => 'Як перевіряється стан вживаних товарів?';

  @override
  String get sssA4 =>
      'Для нас вживане не означає \'другий сорт\'. Кожен товар проходить ретельну перевірку нашого майстра; чищення, догляд і необхідний ремонт виконуються в повному обсязі. Те, що ви бачите на фото, це те, що ви отримаєте, але ми все одно кажемо \'приходьте і переконайтеся самі\'. Побачити на власні очі завжди найкраще.';

  @override
  String get sssQ5 => 'Яка якість матеріалів меблів?';

  @override
  String get sssA5 =>
      'Для нас важлива прозорість. У кожного товару своя історія і свій матеріал. Тому ми чітко зазначаємо всі деталі, якість матеріалу і характеристики в описі товару. Якщо у вас є якісь сумніви, не соромтеся запитувати.';

  @override
  String get sssQ6 => 'Як визначаються ціни на товари?';

  @override
  String get sssA6 =>
      'При визначенні цін ми справедливо враховуємо і якість товару, і ринкові умови. Наша мета — дати вам змогу придбати якісні, довговічні товари, не обтяжуючи ваш бюджет. Ми просимо рівно стільки, скільки справедливо, не більше.';

  @override
  String get sssQ7 => 'Чи є у ваших товарів варіанти кольору?';

  @override
  String get sssA7 =>
      'Оскільки наші товари зазвичай є одиничними екземплярами, ми пропонуємо їх у тому кольорі, в якому вони є. На жаль, ми не можемо запропонувати різні варіанти кольору. Колір, який вам сподобався, — це колір, який ви бачите.';

  @override
  String get sssQ8 => 'Чи приймаєте ви індивідуальні замовлення?';

  @override
  String get sssA8 =>
      'Хотіли б ми це робити! Але ми переважно зосереджені на наших наявних, ретельно відібраних товарах. На жаль, ми поки не можемо приймати замовлення на індивідуальне виготовлення чи дизайн. Радимо ознайомитися з уже готовими товарами.';

  @override
  String get sssQ9 => 'На що звернути увагу в описах товарів?';

  @override
  String get sssA9 =>
      'Наша найважливіша порада: рулетка! Будь ласка, ретельно порівняйте розміри в описі товару з місцем, куди ви плануєте його поставити вдома. Заздалегідь вирішити питання \'а чи поміститься?\' запобігає проблемам у подальшому. Також не забудьте про коридор при вимірюванні: вимірюйте не тільки місце встановлення, а й те, як меблі пройдуть через двері, коридор і сходи. Обов\'язково прочитайте й інформацію про матеріал і стан.';

  @override
  String get sssQ10 =>
      'Чи доставляєте ви в будівлі без ліфта або на верхні поверхи?';

  @override
  String get sssA10 =>
      'Це одна з найделікатніших і найважливіших тем для нас. Ми невеликий ремісничий бізнес, який виконує роботу особисто. Наш майстер після багаторічного досвіду вже не молодий, тому ми маємо думати і про його здоров\'я. Просимо вашого розуміння: у будівлях без ліфта на верхні поверхи (наприклад, 2-й поверх і вище) ми зовсім не можемо запропонувати послугу підйому і спуску речей. Будь ласка, давайте проясним це питання до оформлення замовлення, ми не хочемо вас розчаровувати.';

  @override
  String get sssQ11 => 'Чи надаєте ви послугу перевезення?';

  @override
  String get sssA11 =>
      'Звичайно, ми допомагаємо нашим сусідам. У нас є безкоштовна доставка передусім в İçerenköy, а також у сусідні райони Fındıklı, Kayışdağı, Küçükbakkalköy, İnönü та Bostancı Sanayi. (За винятком деяких частин Bostancı та Kozyatağı, і через вік ми не можемо піднімати речі на верхні поверхи без ліфта, про це поговоримо окремо).';

  @override
  String get sssQ12 => 'Скільки часу займає доставка?';

  @override
  String get sssA12 =>
      'Щойно ви оформите замовлення, ми зв\'яжемося з вами. Запитаємо \'коли вам зручно?\'. Домовимося про найближчий час, зручний для нас обох. Зазвичай завершуємо доставку і збирання протягом 1-3 днів, у погоджений час.';

  @override
  String get sssQ13 => 'Чи надаєте ви послугу збирання?';

  @override
  String get sssA13 =>
      'Звичайно. Забрати меблі і залишити біля дверей — не наш стиль. Усі великі товари особисто збирає наш майстер, і ми не беремо додаткову плату за цю послугу. Ви просто покажіть місце, решта на нас.';

  @override
  String get sssQ14 => 'Скільки часу займає доставка замовлення меблів?';

  @override
  String get sssA14 =>
      'Якщо товар готовий, ми будемо біля ваших дверей якнайшвидше, у погоджений разом час. Не переймайтеся й через збирання; ми зберемо його так само, як привезли, і доставимо готовим. Зазвичай усе завершується того ж дня.';

  @override
  String get sssQ15 => 'Чи можна замовити в кредит / з оплатою пізніше?';

  @override
  String get sssA15 =>
      'Просимо вашого розуміння з цього питання. Як ремісники, щоб втриматися на плаву, ми, на жаль, не можемо працювати за схемами на кшталт \'у кредит\' чи \'оплата пізніше\'. Ми маємо отримати погоджену суму готівкою під час доставки товару. Ми надаємо перевагу повідомленню про це правило заздалегідь, щоб не поставити вас у незручне становище.';

  @override
  String get sssQ16 => 'Як я можу оформити замовлення?';

  @override
  String get sssA16 =>
      'Найнадійніший спосіб — завжди особиста зустріч. Занотуйте товар, який вам сподобався, на сайті, потім приходьте до нашого магазину. Подивіться товар наживо, поставте запитання, які вас цікавлять, і якщо він вам підійде, завершимо ваше замовлення прямо там. Так не залишиться жодних сумнівів.';

  @override
  String get sssQ17 => 'Яка ваша політика повернення товару?';

  @override
  String get sssA17 =>
      'Через природу вживаних товарів і наш ремісничий стиль роботи ми, на жаль, не можемо приймати повернення. Саме тому ми наполягаємо: \'приходьте, подивіться, випийте з нами чаю\'. Правильніше за все ретельно оглянути й виміряти товар перед покупкою. Не будемо завершувати покупку, не будучи впевненими.';

  @override
  String get sssQ18 => 'Чи є гарантійний термін на товари?';

  @override
  String get sssA18 =>
      'Оскільки наші товари вживані, у нас, на жаль, немає офіційного гарантійного терміну, як у бренду. Але ми не з тих, хто каже \'продали і все\'. Ми переконуємося, що все працює справно під час доставки і збирання.';

  @override
  String get sssQ19 =>
      'Хочу продати речі зі свого дому, чи скуповуєте ви вживане?';

  @override
  String get sssA19 =>
      'Так, ми скуповуємо окремі чисті й придатні для перепродажу товари, які, на нашу думку, можемо виставити в нашому магазині. Однак, оскільки площа нашого магазину справді дуже мала, ми, на жаль, змушені бути дуже вибірковими в цьому питанні.\n\nМи вважаємо за краще бути чесними з самого початку: пропозиція, яку ви отримаєте від нас, може бути трохи нижчою, ніж сума, яку ви могли б виручити самі на таких платформах, як Letgo. Причина в наступному: як ремісники, ми витрачаємо бензин, щоб забрати річ, вкладаємо працю в перевезення, і, що найважливіше, беремо на себе весь процес роботи з клієнтом (торг, запитання тощо), щоб виставити і продати її в нашому магазині.\n\nКоли ви продаєте самі на цих платформах, ви берете на себе всі ці процеси. Ми ж знімаємо з вас ці клопоти. Наша пропозиція включає й цю послугу. Дякуємо за розуміння.';

  @override
  String get sssQ20 =>
      'Чи скуповуєте ви повні комплекти меблів (спальня, вітальня тощо)?';

  @override
  String get sssA20 =>
      'Оскільки наш магазин невеликий, ми, на жаль, не можемо приймати повні великі комплекти, такі як спальний чи диванний гарнітур. Наш простір дуже обмежений. Ми більше зосереджені на окремих предметах, які легше продати, таких як консолі, шафи, столи і стільці.';

  @override
  String get sssQ21 =>
      'Мої речі на високому поверсі, а в будівлі немає ліфта. Чи скупите ви їх все одно?';

  @override
  String get sssA21 =>
      'Так само, як і в питанні доставки, це наше найчіткіше правило. Через стан здоров\'я нашого майстра ми зовсім не можемо спускати речі з верхніх поверхів у будівлях без ліфта. Ми можемо розглянути це лише в тому випадку, якщо ваші речі знаходяться поблизу першого поверху/входу або в будівлі є вантажний ліфт.';

  @override
  String get sssQ22 => 'Чи завжди ви скуповуєте речі?';

  @override
  String get sssA22 =>
      'Це повністю залежить від того, скільки місця у нас є в магазині наразі. Оскільки наш магазин невеликий, ми працюємо за принципом балансу \'продати-купити\'. Іноді товар нам дуже подобається, але ми не можемо його взяти через відсутність місця. Найкраще надіслати нам фотографії товару, який ви хочете продати. Ми чесно повідомимо вам, чи є у нас зараз місце, чи ми, на жаль, зараз заповнені.';

  @override
  String get navDiscover => 'Огляд';

  @override
  String get navCart => 'Кошик';

  @override
  String get navProfile => 'Профіль';

  @override
  String get storeHeroEyebrow => 'НОВА КОЛЕКЦІЯ';

  @override
  String get storeHeroTitle => 'Меблі, з якими\nвдома затишно';

  @override
  String get storeHeroSubtitle =>
      'Якісні нові та вживані меблі з доставкою за цінами, які вам сподобаються.';

  @override
  String get storeHeroCta => 'Почати покупки';

  @override
  String get sectionCategories => 'Категорії';

  @override
  String get sectionBestSellers => 'Хіти продажів';

  @override
  String get sectionNewArrivals => 'Новинки';

  @override
  String get seeAll => 'Переглянути все';

  @override
  String get cartTitle => 'Мій кошик';

  @override
  String get cartEmptyTitle => 'Ваш кошик порожній';

  @override
  String get cartEmptyDesc =>
      'Додайте товари, які вам сподобались, і запитайте про все одним повідомленням.';

  @override
  String get cartTotalLabel => 'Разом';

  @override
  String get cartWhatsappCta => 'Надіслати кошик у WhatsApp';

  @override
  String get cartItemRemoved => 'Видалено з кошика';

  @override
  String get addToCartCta => 'До кошика';

  @override
  String get addedToCartMessage => 'Додано до кошика';

  @override
  String get alreadyInCartMessage => 'Вже у кошику';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsLanguageLabel => 'Мова';

  @override
  String get settingsAccountSection => 'Обліковий запис';

  @override
  String get settingsGeneralSection => 'Загальні';

  @override
  String get settingsContact => 'Контакти';

  @override
  String get settingsCallUs => 'Зателефонуйте нам';

  @override
  String get settingsAdminLogin => 'Вхід адміністратора';

  @override
  String get settingsAppVersion => 'Версія додатку';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товарів',
      one: '1 товар',
      zero: 'Кошик порожній',
    );
    return '$_temp0';
  }

  @override
  String get settingsRateApp => 'Оцінити застосунок';

  @override
  String get settingsShareApp => 'Поділитися застосунком';

  @override
  String get settingsPrivacyPolicy => 'Політика конфіденційності';

  @override
  String get settingsTerms => 'Умови використання';

  @override
  String get legalContentTurkishOnly =>
      'Цей вміст наразі доступний лише турецькою мовою.';

  @override
  String get doubleBackToExit => 'Натисніть назад ще раз, щоб вийти';

  @override
  String get productLinkLabel => 'Посилання на товар';

  @override
  String get settingsAppSection => 'Застосунок';

  @override
  String get settingsLegalSection => 'Правова інформація';

  @override
  String get recentlyViewedTitle => 'Нещодавно переглянуті';

  @override
  String get productTrustBadgeVerified => 'Перевірений продавець';

  @override
  String get productTrustBadgeNegotiate => 'Торг через WhatsApp';

  @override
  String get productTrustBadgeDelivery => 'Доставка на місці';

  @override
  String get howToBuyTitle => 'Як купити?';

  @override
  String get howToBuyStep1Title => 'Написати у WhatsApp';

  @override
  String get howToBuyStep1Desc =>
      'Якщо товар сподобався, зв\'яжіться з нами через WhatsApp.';

  @override
  String get howToBuyStep2Title => 'Обговоріть ціну';

  @override
  String get howToBuyStep2Desc => 'Узгодьте ціну та деталі доставки разом.';

  @override
  String get howToBuyStep3Title => 'Отримайте товар';

  @override
  String get howToBuyStep3Desc =>
      'Після домовленості безпечно отримайте свій товар.';

  @override
  String get listedToday => 'Додано сьогодні';

  @override
  String listedDaysAgo(int days) {
    return 'Додано $days дн. тому';
  }

  @override
  String listedWeeksAgo(int weeks) {
    return 'Додано $weeks тижн. тому';
  }

  @override
  String get settingsAppearanceSection => 'Вигляд';

  @override
  String get settingsThemeLight => 'Світла';

  @override
  String get settingsThemeSystem => 'Системна';

  @override
  String get settingsThemeDark => 'Темна';

  @override
  String get notificationsTitle => 'Сповіщення';

  @override
  String get notificationsEmptyTitle => 'Поки що немає сповіщень';

  @override
  String get notificationsEmptyDesc =>
      'Нові акції та оголошення з\'являться тут';

  @override
  String get markAllReadAction => 'Позначити всі як прочитані';

  @override
  String get clearAllAction => 'Очистити все';

  @override
  String get timeJustNow => 'Щойно';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes хв тому';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours год тому';
  }

  @override
  String timeDaysAgoGeneric(int days) {
    return '$days дн тому';
  }

  @override
  String get catalogCategoryTitleSofa => 'Диван і канапа';

  @override
  String get catalogCategoryTitleChair => 'Стілець і крісло';

  @override
  String get catalogCategoryTitleTable => 'Обідній стіл';

  @override
  String get catalogCategoryTitleBed => 'Ліжко й основа';

  @override
  String get catalogCategoryTitleWardrobe => 'Гардероб і шафа';

  @override
  String get catalogCategoryTitleWhite => 'Побутова техніка';

  @override
  String get catalogCategoryTitleOther => 'Декор';

  @override
  String get mottoTitlePart1 => 'Побач перш ніж прийти, ';

  @override
  String get mottoTitlePart2 => 'Приходь, коли сподобається.';

  @override
  String get mottoSubtitle =>
      'Перегляньте нашу вітрину перед візитом до магазину, а тоді заходьте, коли знайдете те, що подобається.';

  @override
  String get gatewayNewEyebrow => 'НОВА КОЛЕКЦІЯ';

  @override
  String get gatewayNewTitle => 'Позачасові речі';

  @override
  String get gatewayNewSubtitle => 'Цілком нові, невживані меблі.';

  @override
  String get gatewayNewButton => 'Переглянути колекцію';

  @override
  String get gatewaySpotEyebrow => 'СПОТ-ПРОПОЗИЦІЇ';

  @override
  String get gatewaySpotTitle => 'Вживані, але міцні';

  @override
  String get gatewaySpotSubtitle =>
      'Вживані, але практичні, за доступними цінами.';

  @override
  String get gatewaySpotButton => 'Переглянути пропозиції';

  @override
  String freeDeliveryZonesNote(String zones) {
    return 'Безкоштовна доставка діє лише в районах $zones';
  }

  @override
  String get footerWarehouseTagline => 'СКЛАД МЕБЛІВ · İÇERENKÖY / ATAŞEHİR';

  @override
  String get locationAndHoursLabel => 'АДРЕСА ТА ГОДИНИ РОБОТИ';

  @override
  String get openNowLabel => 'ЗАРАЗ ВІДЧИНЕНО';

  @override
  String get closedNowLabel => 'ЗАРАЗ ЗАЧИНЕНО';

  @override
  String todayHoursPrefix(String hours) {
    return '· Сьогодні $hours';
  }

  @override
  String get openInMapsButton => 'Відкрити на карті';

  @override
  String get viewOnGoogleMapsButton => 'Переглянути на Google Картах';

  @override
  String gatewayProductCount(int count) {
    return '$count товарів';
  }

  @override
  String get gatewayNewEyebrowShort => 'НОВЕ';

  @override
  String get gatewayNewTitleShort => 'Колекція';

  @override
  String get gatewaySpotEyebrowShort => 'СПОТ';

  @override
  String get gatewaySpotTitleShort => 'Пропозиції';

  @override
  String get spotHeroEyebrow => 'СКЛАД ВИГІДНИХ ПРОПОЗИЦІЙ';

  @override
  String get spotHeroSubtitle =>
      'Вживані, але практичні. Майже нові товари для будь-якого бюджету. Можливий торг.';

  @override
  String spotHeroDealCount(int count) {
    return '$count+ пропозицій';
  }

  @override
  String get spotStatNegotiable => 'Можливий торг';

  @override
  String get spotStatUsed => 'Вживане';

  @override
  String get spotShowcaseBadgeTitle => 'Повністю відновлено';

  @override
  String get spotShowcaseBadgeSubtitle =>
      'Кожен товар індивідуально перевіряється перед доставкою.';

  @override
  String get spotBreadcrumbLabel => 'Спот і секонд-хенд';

  @override
  String get aphorismEyebrow => 'У НАС Є ГАСЛО';

  @override
  String get aphorismQuote =>
      'Не зношені, а виплекані.\nГарні меблі ніколи не старіють — вони просто змінюють дім.';

  @override
  String get aphorismBody =>
      'Саме тому ми тут: щоб принести речі, у яких ще є життя, у новий дім, який їх цінуватиме.';

  @override
  String get spotSearchHint => 'Пошук пропозицій…';

  @override
  String get priceRangeLabel => 'Діапазон цін';

  @override
  String get filtersSheetTitle => 'ФІЛЬТРИ';

  @override
  String get applyFiltersButton => 'Застосувати фільтри';

  @override
  String get priceRangeSheetTitle => 'ДІАПАЗОН ЦІН';

  @override
  String get applyButton => 'Застосувати';

  @override
  String get sortSheetTitle => 'СОРТУВАННЯ';

  @override
  String get sortNewest => 'Найновіші пропозиції';

  @override
  String get sortPopular => 'Найпопулярніші';

  @override
  String get spotEmptyStateTitle =>
      'Ми не знайшли пропозицій за цими критеріями';

  @override
  String get spotEmptyStateSubtitle =>
      'Спробуйте очистити фільтри або іншу категорію.';

  @override
  String get newHeroTitleLine1 => 'Для вашого простору\n';

  @override
  String get newHeroTitleEmphasis => 'Позачасова ';

  @override
  String get newHeroButtonCollection => 'Переглянути колекцію';

  @override
  String get newHeroButtonQuickFilter => 'Швидкий фільтр';

  @override
  String get newStatActiveProductLabel => 'АКТИВНІ ТОВАРИ';

  @override
  String get newStatControlledStockLabel => 'ПЕРЕВІРЕНИЙ ЗАПАС';

  @override
  String get shopByCategoryTitlePrefix => 'За категорією ';

  @override
  String get shopByCategoryTitleEmphasis => 'Досліджуй';

  @override
  String get showAllButton => 'Показати всі';

  @override
  String get newEmptyStateTitle => 'Меблів за вашим запитом не знайдено';

  @override
  String get newEmptyStateSubtitle =>
      'Спробуйте змінити пошуковий запит або очистити фільтри.';

  @override
  String get sortOptionsSheetTitle => 'Параметри сортування';

  @override
  String get newSortNewest => 'Найновіші';

  @override
  String get newSortPopular => 'Найпопулярніші';

  @override
  String get cartWhatsappGreeting => 'Вітаю, хочу дізнатися про ці товари:\n\n';

  @override
  String cartWhatsappAllProductsLine(String url) {
    return 'Усі товари: $url';
  }

  @override
  String get defaultWhatsappGreeting => 'Вітаю, хочу дізнатися про меблі.';

  @override
  String get spotHeroPageTitle => 'Секонд-хенд і спот';

  @override
  String get sortByPriceLowHigh => 'Ціна: за зростанням';

  @override
  String get sortByPriceHighLow => 'Ціна: за спаданням';

  @override
  String get seoSssTitle => 'Часті запитання | Sağlam Spot';

  @override
  String get seoSssDesc =>
      'Відповіді на всі запитання про купівлю, доставку та гарантію.';

  @override
  String get seoSearchTitle => 'Пошук товарів | Sağlam Spot';

  @override
  String get seoSearchDesc =>
      'Знайдіть потрібні меблі, фільтруючи за категорією, ціною та станом.';

  @override
  String get seoPrivacyTitle => 'Політика конфіденційності | Sağlam Spot';

  @override
  String get seoTermsTitle => 'Умови використання | Sağlam Spot';

  @override
  String get howItWorksEyebrow => 'ПРОЦЕС';

  @override
  String get whyUsEyebrow => 'ПЕРЕВАГИ';
}

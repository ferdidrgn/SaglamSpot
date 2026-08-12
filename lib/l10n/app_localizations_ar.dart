// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get brand => 'سالام سبوت';

  @override
  String get home => 'الرئيسية';

  @override
  String get searchHint => 'عن ماذا كنت تبحث لمنزلك؟...';

  @override
  String get collection => 'المجموعة';

  @override
  String get eleganceAndComfort => 'الأناقة والراحة';

  @override
  String productsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم العثور على $count منتج',
      one: 'تم العثور على منتج واحد',
      zero: 'لم يتم العثور على منتج',
    );
    return '$_temp0';
  }

  @override
  String resultsFor(String query) {
    return 'نتائج \"$query\"';
  }

  @override
  String get seoHomeTitle => 'سالام سبوت | أثاث مستعمل وجديد';

  @override
  String get seoHomeDesc =>
      'أفضل الأسعار في الأثاث المستعمل والجديد. بضمان حرفي لـ20 عامًا.';

  @override
  String get seoNewTitle => 'منتجات جديدة | سالام سبوت';

  @override
  String get seoNewDesc => 'مجموعة أثاث جديد مضمونة وعالية الجودة.';

  @override
  String get seoSpotTitle => 'منتجات مستعملة | سالام سبوت';

  @override
  String get seoSpotDesc => 'خيارات أثاث اقتصادية وعالية الجودة.';

  @override
  String get seoAboutTitle => 'من نحن | سالام سبوت';

  @override
  String get seoAboutDesc => 'عنوان الثقة في قطاع الأثاث بخبرتنا لـ20 عامًا.';

  @override
  String get seoProductDetailSuffix => 'عرض المنتج | سالام سبوت';

  @override
  String get category => 'الفئة';

  @override
  String get categorySofa => 'مجموعات الجلوس';

  @override
  String get categoryChair => 'كرسي';

  @override
  String get categoryTable => 'طاولة';

  @override
  String get categoryBed => 'غرفة النوم';

  @override
  String get categoryWardrobe => 'خزانة';

  @override
  String get categoryWhite => 'أجهزة منزلية';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get condition => 'الحالة';

  @override
  String get conditionAll => 'الكل';

  @override
  String get conditionNew => 'جديد';

  @override
  String get conditionUsed => 'مستعمل';

  @override
  String get priceRange => 'نطاق السعر';

  @override
  String get price => 'السعر';

  @override
  String get save => 'حفظ';

  @override
  String get explanation => 'الوصف';

  @override
  String get clear => 'مسح';

  @override
  String get filter => 'تصفية';

  @override
  String get apply => 'تطبيق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get newSeason => 'موسم جديد';

  @override
  String get heroTitle => 'البساطة\nقمة الراحة';

  @override
  String get viewCollection => 'عرض المجموعة';

  @override
  String get featureArtisan => 'حرفية صادقة';

  @override
  String get featureDelivery => 'توصيل آمن';

  @override
  String get featureService => 'خدمة ودودة';

  @override
  String get featureShipping => 'شحن سريع';

  @override
  String get quickOptions => 'خيارات سريعة';

  @override
  String get easyFind => 'اعثر على ما تبحث عنه بسهولة';

  @override
  String get mottoBrand => 'يجدد القديم، يقيّم الجديد';

  @override
  String get newCollection => 'المجموعة الجديدة';

  @override
  String get newCollectionSub => 'أحدث المنتجات';

  @override
  String get spotProducts => 'منتجات مستعملة';

  @override
  String get spotProductsSub => 'منتجات العروض';

  @override
  String get spotProductsDesc => 'أسعار مذهلة على منتجات عالية الجودة';

  @override
  String get currentCollection => 'المجموعة الحالية';

  @override
  String get soldProducts => 'المنتجات المباعة';

  @override
  String pieces(int count) {
    return '$count قطعة';
  }

  @override
  String get stock => 'متوفر';

  @override
  String get sold => 'تم البيع';

  @override
  String get byRoom => 'حسب مساحة المعيشة';

  @override
  String get byRoomSub => 'اختيارات خاصة لكل زاوية من منزلك';

  @override
  String get roomLivingRoom => 'الصالون';

  @override
  String get roomLivingRoomSub => 'مركز الراحة';

  @override
  String get roomBedroom => 'غرفة النوم';

  @override
  String get roomBedroomSub => 'نوم هادئ';

  @override
  String get roomKitchen => 'المطبخ';

  @override
  String get roomKitchenSub => 'حلول عملية';

  @override
  String get roomOffice => 'المكتب';

  @override
  String get roomOfficeSub => 'عمل فعّال';

  @override
  String get whoWeAre => 'من نحن؟';

  @override
  String get artisanTitle => '20 عامًا من الحرفية الصادقة،\nخدمة عصرية.';

  @override
  String get artisanDesc =>
      'تعالوا إلى متجرنا، تناولوا الشاي معنا؛ لنختار معًا الأثاث الأنسب لكم.';

  @override
  String get visitUsButton => 'زورونا';

  @override
  String get statHappyCustomer => 'عميل سعيد';

  @override
  String get statExperience => 'الخبرة';

  @override
  String get statDelivery => 'التوصيل';

  @override
  String get statTrust => 'الثقة';

  @override
  String get explore => 'استكشف';

  @override
  String get collections => 'المجموعات';

  @override
  String get corporate => 'الشركة';

  @override
  String get aboutUs => 'من نحن';

  @override
  String get contact => 'التواصل';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get sss => 'الأسئلة الشائعة';

  @override
  String get qualityFurniture => '\'عنوان الأثاث الجيد هو سالام سبوت\'';

  @override
  String get footerDesc =>
      'بخبرة تتجاوز 20 عامًا، ننقل الجودة والثقة إلى كل ركن من إسطنبول.';

  @override
  String get allRightsReserved =>
      '© 2026 سالام سبوت للتجارة. جميع الحقوق محفوظة.';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get productNotFound => 'المنتج غير موجود';

  @override
  String get noImages => 'لا توجد صور';

  @override
  String get error_check_connection => 'يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get error_server_no_response => 'الخادم لا يستجيب حاليًا.';

  @override
  String get error_connection => 'خطأ في الاتصال';

  @override
  String get error_connection_lost => 'انقطع الاتصال';

  @override
  String get status_waiting_connection => 'في انتظار الاتصال...';

  @override
  String get error_no_internet_auto_retry =>
      'لا يوجد اتصال بالإنترنت.\nسيتم الاستمرار تلقائيًا عند توفر الاتصال.';

  @override
  String get goBack => 'رجوع';

  @override
  String get galleryEmpty => 'المعرض فارغ';

  @override
  String get month_1 => 'يناير';

  @override
  String get month_2 => 'فبراير';

  @override
  String get month_3 => 'مارس';

  @override
  String get month_4 => 'أبريل';

  @override
  String get month_5 => 'مايو';

  @override
  String get month_6 => 'يونيو';

  @override
  String get month_7 => 'يوليو';

  @override
  String get month_8 => 'أغسطس';

  @override
  String get month_9 => 'سبتمبر';

  @override
  String get month_10 => 'أكتوبر';

  @override
  String get month_11 => 'نوفمبر';

  @override
  String get month_12 => 'ديسمبر';

  @override
  String get noProductFoundTitle => 'لم يتم العثور على منتج بهذه المعايير';

  @override
  String get noProductFoundDescription =>
      'يمكنك تجربة فلاتر مختلفة أو تغيير كلمة البحث';

  @override
  String get adminPanelTitle => 'لوحة التحكم';

  @override
  String get totalCount => 'الإجمالي';

  @override
  String get productAddedSuccess => 'تمت إضافة المنتج بنجاح';

  @override
  String get authOrConnectionError => 'حدث خطأ في التفويض أو الاتصال';

  @override
  String get fillRequiredFields =>
      'يرجى إضافة اسم المنتج والسعر وصورة واحدة على الأقل!';

  @override
  String get sessionClosed => 'الجلسة مغلقة';

  @override
  String get addNewProduct => 'إضافة منتج جديد';

  @override
  String get productImages => 'صور المنتج';

  @override
  String get generalInfo => 'معلومات عامة';

  @override
  String get productNameLabel => 'اسم المنتج';

  @override
  String get descriptionLabel => 'الوصف';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get spotSecondHand => 'مستعمل';

  @override
  String get secondHandHint => 'قطعة واحدة — لن تظهر خيارات الألوان';

  @override
  String get newProductHint => 'منتج جديد — يمكنك إضافة خيارات الألوان';

  @override
  String get colorOptionsOptional => 'خيارات الألوان (اختياري)';

  @override
  String get noImagesYet => 'لم تتم إضافة صور بعد';

  @override
  String get addImage => 'إضافة صورة';

  @override
  String get editProductTitle => 'تعديل المنتج';

  @override
  String get changeImages => 'تغيير الصور';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get deleteProductTitle => 'حذف المنتج';

  @override
  String get deleteProductConfirmSuffix => 'سيتم حذفه. هل أنت متأكد؟';

  @override
  String get yesDelete => 'نعم، حذف';

  @override
  String get emptyCategoryProducts => 'لا توجد منتجات في هذه الفئة';

  @override
  String get adminLoginSubtitle => 'تسجيل الدخول إلى لوحة التحكم';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get sponsored => 'ممول';

  @override
  String get addProductFab => 'إضافة منتج';

  @override
  String get singlePieceNotice =>
      'هذا منتج مستعمل — يوجد قطعة واحدة فقط في المخزون، واللون والمظهر مطابقان تمامًا للصور.';

  @override
  String get colorOptionsTitle => 'خيارات الألوان';

  @override
  String get newProductBadge => 'منتج جديد';

  @override
  String get usedProductBadge => 'مستعمل';

  @override
  String get readMore => 'قراءة المزيد';

  @override
  String get readLess => 'عرض أقل';

  @override
  String get specDelivery => 'التوصيل';

  @override
  String get specDeliveryValue => 'خلال 1-2 يوم';

  @override
  String get specLocation => 'الموقع';

  @override
  String get sellerTrustLine => '20 عامًا من الثقة المحلية · إتشرينكوي';

  @override
  String get whatsappCta => 'راسلنا على واتساب';

  @override
  String get callCta => 'اتصال';

  @override
  String get similarProducts => 'منتجات مشابهة';

  @override
  String get conditionShowcase => 'عرض';

  @override
  String get productDescriptionTitle => 'الوصف';

  @override
  String get loginBrand => 'سالام سبوت';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirm =>
      'هل أنت متأكد أنك تريد تسجيل الخروج بأمان من حسابك؟';

  @override
  String get testimonialsHeading => 'ماذا يقول عملاؤنا';

  @override
  String get testimonialsSubheading =>
      'منذ أكثر من 20 عامًا نلمس آلاف المنازل في إيچيرينكوي وما حولها';

  @override
  String get testimonial1Comment =>
      'اشترينا طقم الكنب بسعر ممتاز، وكأنه جديد تمامًا. تم التسليم في نفس اليوم يدًا بيد، وشعرنا بثقة الحرفي الحقيقي منذ البداية.';

  @override
  String get testimonial2Comment =>
      'اشتريت طقم غرفة النوم بسعر العرض من هنا. كان مطابقًا تمامًا لوصف المنتج، دون أي مفاجآت. أوصي به بشدة.';

  @override
  String get testimonial3Comment =>
      'اشترينا أثاثًا بكميات كبيرة لمكتبنا، وكان السعر والجودة أفضل من توقعاتنا. فريق مهتم وصبور، شكرًا لكم يا سالام سبوت.';

  @override
  String get testimonial4Comment =>
      'اشترينا طقم طاولة الطعام بسعر عادل دون مساومة. كما ساعدونا في النقل، تسوقنا وقلوبنا مرتاحة.';

  @override
  String get testimonial5Comment =>
      'كنا نبحث عن خزانة ملابس مستعملة ووجدنا قطعة متينة وأنيقة. كانت أفضل قيمة مقابل السعر في السوق.';

  @override
  String get testimonial6Comment =>
      'خلال زيارتنا لصالة العرض، تمكنا من رؤية المنتجات بأنفسنا مما زاد ثقتنا. وكانوا دائمًا متاحين للتواصل بعد البيع أيضًا.';

  @override
  String get howItWorksHeading => 'كيف يعمل الموقع؟';

  @override
  String get step1Title => 'تصفح وصفِّ';

  @override
  String get step1Desc =>
      'اعثر على ما يعجبك من بين آلاف المنتجات حسب الفئة ونطاق السعر.';

  @override
  String get step2Title => 'تواصل معنا';

  @override
  String get step2Desc =>
      'تواصل مع فريقنا عبر واتساب أو الهاتف مباشرة من صفحة المنتج.';

  @override
  String get step3Title => 'اتفق على السعر';

  @override
  String get step3Desc =>
      'شاهد المنتج في صالة العرض أو تأكد منه بالصور، واتفق على سعر عادل وصريح.';

  @override
  String get step4Title => 'التوصيل حتى باب منزلك';

  @override
  String get step4Desc =>
      'نقل سريع ومؤمَّن إلى إيچيرينكوي والجانب الأناضولي يوصل أثاثك إلى منزلك بأمان.';

  @override
  String get tipsEyebrow => 'نصائح';

  @override
  String get tipsHeading => 'نصائح العناية من خبيرنا';

  @override
  String get tip1Title => 'اجعل غرفة الجلوس أكثر جاذبية';

  @override
  String get tip1Desc =>
      'اترك مسافة 1-2 سم بين الكنبة والحائط؛ فهذا يحسّن دوران الهواء ويجعل الغرفة أكثر انفتاحًا.';

  @override
  String get tip1Category => 'الترتيب';

  @override
  String get tip2Title => 'مساحة عمل تبدو نظيفة دائمًا';

  @override
  String get tip2Desc =>
      'رتّب الكابلات بمنظمات، وامسح بقطعة قماش مايكروفايبر بحركات دائرية — تبقى طاولتك كالجديدة دائمًا.';

  @override
  String get tip2Category => 'التنظيف';

  @override
  String get tip3Title => 'ترتيب مطبخ ممتع';

  @override
  String get tip3Desc =>
      'ضع الأشياء الثقيلة في الأرفف السفلية، والأشياء المستخدمة كثيرًا على مستوى العين — عملي وآمن معًا.';

  @override
  String get tip3Category => 'التنظيم';

  @override
  String get tip4Title => 'أنشئ ركن نوم مريح';

  @override
  String get tip4Desc =>
      'ضع رأس السرير بعيدًا عن النافذة لتقليل الضوء — تغيير بسيط لنوم أعمق بشكل ملحوظ.';

  @override
  String get tip4Category => 'الراحة';

  @override
  String get tip5Title => 'أعطِ خزانتك نفسًا جديدًا';

  @override
  String get tip5Desc =>
      'افصل الملابس الموسمية، وعلّق كل شيء في نفس الاتجاه — يوفر مساحة ويسهّل الاختيار كل صباح.';

  @override
  String get tip5Category => 'التنظيم';

  @override
  String get tip6Title => 'أطِل عمر أثاثك الخشبي';

  @override
  String get tip6Desc =>
      'احمِه من أشعة الشمس المباشرة، وامسحه بزيت مغذٍّ عدة مرات في السنة — أفضل عناية ضد الخدوش والبهتان.';

  @override
  String get tip6Category => 'العناية';

  @override
  String get tip7Title => 'أطِل عمر الكنب القماشي';

  @override
  String get tip7Desc =>
      'نظّف بالمكنسة الكهربائية أسبوعيًا، وامسح البقع فورًا بقطعة قماش مبللة — الانتظار يجعل البقعة تتغلغل في القماش.';

  @override
  String get tip7Category => 'العناية';

  @override
  String get tip8Title => 'اختر الإضاءة المناسبة';

  @override
  String get tip8Desc =>
      'استخدم إضاءة متعددة المستويات بدلًا من مصباح سقف واحد: الإضاءة العامة والوظيفية والجوية معًا تجعل الغرفة أكثر دفئًا.';

  @override
  String get tip8Category => 'الإضاءة';

  @override
  String get tip9Title => 'استغل المساحات الصغيرة بذكاء';

  @override
  String get tip9Desc =>
      'اختر أثاثًا قابلًا للطي ومتعدد الاستخدامات؛ الأرفف المثبتة على الحائط تحرر مساحة الأرضية.';

  @override
  String get tip9Category => 'التنظيم';

  @override
  String get tip10Title => 'حوّل شرفتك إلى مساحة معيشة';

  @override
  String get tip10Desc =>
      'طقم جلوس مقاوم للطقس وبضع نباتات في أصص تجعل الشرفة أكثر ركن محبوب في المنزل.';

  @override
  String get tip10Category => 'الأماكن الخارجية';

  @override
  String get popularCategoriesHeading => 'الفئات الشائعة';

  @override
  String get popularCategoriesSub => 'اعثر على الأثاث المناسب لك بنقرة واحدة';

  @override
  String categoryProductCount(int count) {
    return '$count منتج';
  }

  @override
  String get newsletterSubscribeSuccess =>
      'لقد اشتركت بنجاح في نشرتنا الإخبارية!';

  @override
  String get newsletterHeading => 'كن أول من يعرف عن المنتجات الجديدة';

  @override
  String get newsletterDesc =>
      'اجعل عروض السبوت والمجموعات الجديدة والحملات تصل إلى بريدك الإلكتروني. بدون بريد مزعج، فقط عروض تستحق وقتك.';

  @override
  String get emailHint => 'بريدك الإلكتروني';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'أدخل بريدًا إلكترونيًا صالحًا';

  @override
  String get whyUsHeading => 'لماذا سالام سبوت؟';

  @override
  String get usp1Title => '20 عامًا من الثقة الحرفية';

  @override
  String get usp1Desc =>
      'أكثر من عشرين عامًا كحرفي في إيچيرينكوي، وآلاف العملاء الراضين.';

  @override
  String get usp2Title => 'أسعار أقل من السوق';

  @override
  String get usp2Desc =>
      'بفضل نموذج العمل بدون وسطاء، لدينا أفضل الأسعار في الأثاث الجديد والمستعمل.';

  @override
  String get usp3Title => 'جودة منتج مُراقَبة';

  @override
  String get usp3Desc =>
      'يخضع كل منتج لفحص هيكلي وفحص للقماش/التشطيب قبل عرضه للبيع.';

  @override
  String get usp4Title => 'دعم بعد البيع';

  @override
  String get usp4Desc =>
      'فريق حقيقي يمكنك الوصول إليه حتى بعد التسليم، يحل مشكلتك.';

  @override
  String get socialShowcaseEyebrow => 'شاركنا';

  @override
  String get socialShowcaseHeading => 'شارك ديكور منزلك مع #SağlamSpot';

  @override
  String productsLoadError(String error) {
    return 'حدث خطأ أثناء تحميل المنتجات: $error';
  }

  @override
  String get viewAllButton => 'عرض الكل';

  @override
  String get showcaseEyebrow => 'الواجهة';

  @override
  String get exploreButton => 'استكشف';

  @override
  String get visitUsEyebrow => 'زُرنا';

  @override
  String get visitUsHeading => 'فقط ألقِ التحية';

  @override
  String visitUsOpenLine(String hours) {
    return 'بابنا مفتوح دائمًا. $hours';
  }

  @override
  String get directionsButton => 'احصل على الاتجاهات';

  @override
  String get freeDeliveryLabel => 'توصيل مجاني';

  @override
  String get busLinesLabel => 'خطوط الحافلات';

  @override
  String get statYearsSuffix => '+ سنة';

  @override
  String get storeAddress => 'إيچيرينكوي، أتاشهير/إسطنبول';

  @override
  String get stayUpdated => 'ابقَ على اطلاع';

  @override
  String get viewButton => 'عرض';

  @override
  String get heroSlide2Eyebrow => 'مستعمل';

  @override
  String get heroSlide2Title => 'أثاث له قصة';

  @override
  String get heroSlide2Subtitle =>
      'قطع مستعملة متينة ومميزة تم اختيارها بعناية.';

  @override
  String get heroSlide3Title => 'استكشف المجموعة الكاملة';

  @override
  String get aboutBadge => 'معكم منذ 2012';

  @override
  String get aboutHeroTitle => 'سالام سبوت\nالثقة التي تعرفها';

  @override
  String get aboutHeroSubtitle => 'نخدم حينا بحب واهتمام في كل ما نقوم به.';

  @override
  String get aboutStoryHeading => 'من نحن؟ (قصتنا)';

  @override
  String get aboutStoryPara1 =>
      'هدفنا هو مساعدتك في العثور على أثاث عالي الجودة يضفي دفئًا على منزلك ويشعرك بالراحة الحقيقية. تجميل مساحات معيشتك هو عملنا.';

  @override
  String get aboutStoryPara2 =>
      'بدأ كل شيء عام 2012، في هذا المتجر بالذات في إيچيرينكوي. ومنذ ذلك الحين ازداد عدد المنازل التي استضفنا فيها.';

  @override
  String get aboutStoryPara3 =>
      'اليوم، بمنتجاتنا الجديدة والمستعملة المختارة بعناية، أصبحنا ضيوفًا في آلاف منازل جيراننا. ننمو بثقتكم.';

  @override
  String get aboutStoryStartLabel => 'التأسيس';

  @override
  String get aboutStoryExperienceLabel => 'سنوات الخبرة';

  @override
  String get aboutStorySmilesLabel => 'وجوه سعيدة';

  @override
  String get aboutValuesHeading => 'مبادئنا';

  @override
  String get aboutValuesSubheading => 'المبادئ التي لا نساوم عليها كحرفيين';

  @override
  String get aboutValue1Title => 'الجودة والدقة';

  @override
  String get aboutValue1Desc =>
      'سواء كان جديدًا أو مستعملًا، نختاره بعناية ونقدمه لكم كما هو.';

  @override
  String get aboutValue2Title => 'وجوه سعيدة';

  @override
  String get aboutValue2Desc =>
      'بالنسبة لنا، أكبر مكسب هو جار يغادر المتجر سعيدًا. رضاكم يأتي قبل كل شيء.';

  @override
  String get aboutValue3Title => 'احترام العمل اليدوي';

  @override
  String get aboutValue3Desc =>
      'الأثاث عمل ثمين. من خلال منح المنتجات المستعملة حياة جديدة، نحافظ على ميزانيتك وعلى البيئة معًا.';

  @override
  String get aboutValue4Title => 'الصدق والثقة';

  @override
  String get aboutValue4Desc =>
      'الحرفية الشفافة والصادقة هي أعظم قيمنا. نحن معكم منذ سنوات في نفس الموقع.';

  @override
  String get aboutMasterHeading => 'تعرّف على أستاذنا الحرفي';

  @override
  String get aboutMasterBody =>
      'يعمل أستاذنا الحرفي بنشاط في هذا المجال منذ عام 1995 — أي أكثر من ربع قرن. عمل في أفضل العلامات التجارية (İstikbal) واكتسب معرفة عميقة بخصائص المنتجات وأجزائها وتفاصيلها الدقيقة.\n\nعمل بنفسه في كل المجالات، من القيادة للتوصيل والنقل والتركيب واستقبال العملاء، مكتسبًا خبرة شاملة. وفي عام 2012 قرر فتح متجره الخاص، ناقلًا كل هذه الخبرة إلى سالام سبوت.\n\nهدفه هو الجمع بين الجودة التي تعلمها في تلك الشركات الكبرى وصدق واهتمام الحرفي المحلي، ليقدم لكم أفضل خدمة.';

  @override
  String get aboutDeliveryHeading => 'خدمة التوصيل والتركيب لدينا';

  @override
  String get aboutDeliveryFreeTitle => 'توصيل وتركيب مجاني';

  @override
  String get aboutDeliveryZonesLabel => 'مناطق خدمتنا المجانية:';

  @override
  String get aboutDeliveryZonesList =>
      '• حينا إيچيرينكوي\n• فِنديكلي، كايشداغي، كوچوك بكال كوي\n• جيراننا القريبون مثل إينونو وبوستانجي صنايي';

  @override
  String get aboutDeliveryNote =>
      'ملاحظة مهمة: للحفاظ على صحة أستاذنا الحرفي، لا يمكننا للأسف تقديم خدمة نقل الأثاث إلى الطوابق العليا في المباني بدون مصعد. شكرًا لتفهمكم.';

  @override
  String get aboutDeliveryPunctual =>
      '⏰ نصل إلى بابك في الموعد الذي اتفقنا عليه!';

  @override
  String get aboutTransportHeading => 'كيف تصل إلى متجرنا؟';

  @override
  String get aboutTransportBusIntro => 'إذا كنت قادمًا بالحافلة:';

  @override
  String get aboutBusStop1 => 'محطة زيابشا (باتجاه قاضي كوي):';

  @override
  String get aboutBusStop2 => 'محطة إيچيرينكوي (باتجاه كايشداغي):';

  @override
  String get aboutBusStop3 => 'محطة إيچيرينكوي (يني يول):';

  @override
  String get aboutContactPhoneLabel => 'الهاتف (حل سريع)';

  @override
  String get aboutContactAddressLabel => 'العنوان (ننتظرك على الشاي)';

  @override
  String get aboutContactAddressValue =>
      'İçerenköy Mahallesi\nBuket Sokak No:6';

  @override
  String get aboutContactHoursLabel => 'ساعات عملنا';

  @override
  String get aboutContactHoursValue =>
      'الإثنين-السبت: 09:00 - 22:00\nالأحد: 10:00 - 20:00';

  @override
  String get aboutContactHeading => 'تواصل معنا';

  @override
  String get aboutCallNowButton => 'اتصل الآن';

  @override
  String get aboutViewMapButton => 'عرض على الخريطة';

  @override
  String get aboutMapHeading => 'متجرنا هنا تمامًا';

  @override
  String get aboutMapSubtext => 'اضغط على الخريطة للحصول على الاتجاهات';

  @override
  String get newProductsBadgeEyebrow => 'مجموعة جديدة';

  @override
  String get newProductsTitle => 'مجموعة\nجديدة';

  @override
  String get productsBadgeLabel => 'منتج';

  @override
  String get breadcrumbHome => 'الرئيسية';

  @override
  String get statTotalProducts => 'إجمالي المنتجات';

  @override
  String get statCategoryLabel => 'الفئات';

  @override
  String get statConditionValueNew => 'جديد';

  @override
  String get statConditionLabel => 'الحالة';

  @override
  String get statRatingLabel => 'التقييم';

  @override
  String get searchBarRichPrefix => 'للبحث التفصيلي عن المنتجات اضغط ';

  @override
  String get searchBarRichOr => ' أو انقر ';

  @override
  String get searchBarRichHereLink => 'هنا';

  @override
  String get searchBarRichSuffix => '.';

  @override
  String get sortNewProductsDefault => 'الأحدث';

  @override
  String get sortSpotProductsDefault => 'الأحدث';

  @override
  String get sortPriceLowHigh => 'السعر: من الأقل للأعلى';

  @override
  String get sortPriceHighLow => 'السعر: من الأعلى للأقل';

  @override
  String get sortMostPopular => 'الأكثر شيوعًا';

  @override
  String get spotBadgeEyebrow => 'منتجات السبوت';

  @override
  String get spotHeroTitle => 'منتجات\nالعروض';

  @override
  String get spotDiscountLabel => 'خصم';

  @override
  String get statSpotProductLabel => 'منتج سبوت';

  @override
  String get statDiscountLabel => 'خصم';

  @override
  String get statSupportLabel => 'دعم';

  @override
  String get statFreeLabel => 'مجاني';

  @override
  String get statFreeShippingNote => 'للمناطق القريبة فقط، شحن';

  @override
  String get statFreeShippingShort => 'شحن';

  @override
  String get filtersPanelTitle => 'الفلاتر';

  @override
  String get priceRangeSectionTitle => 'نطاق السعر';

  @override
  String get clearFiltersButton => 'مسح الفلاتر';

  @override
  String get tryDifferentFiltersShort => 'يمكنك تجربة فلاتر مختلفة';

  @override
  String get spotBadgeTag => 'سبوت';

  @override
  String productLoadError(String error) {
    return 'تعذر تحميل المنتج: $error';
  }

  @override
  String get productSpecConditionNew => 'منتج جديد';

  @override
  String get productLocationValue => 'إيچيرينكوي، إسطنبول';

  @override
  String get sortFeatured => 'المميزة';

  @override
  String get sortPriceAsc => 'السعر: تصاعدي';

  @override
  String get sortPriceDesc => 'السعر: تنازلي';

  @override
  String get languageSelectorTitle => 'اختيار اللغة';

  @override
  String get languageTooltip => 'اللغة';

  @override
  String get galleryEmptyMessage => 'لم تتم إضافة صور لهذا المنتج بعد.';

  @override
  String get productCardNewBadge => 'جديد';

  @override
  String get sssHelpCenterBadge => 'مركز المساعدة';

  @override
  String get sssHeroTitle => 'الأسئلة\nالشائعة';

  @override
  String get sssHeroSubtitle => 'إجابات على كل ما يشغل بالك';

  @override
  String get sssCategoryAll => 'الكل';

  @override
  String get sssCategoryGeneral => 'عام';

  @override
  String get sssCategoryProductService => 'المنتج والخدمة';

  @override
  String get sssCategoryDelivery => 'التوصيل والتركيب';

  @override
  String get sssCategoryPayment => 'الدفع والطلبات';

  @override
  String get sssCategoryReturns => 'الإرجاع والضمان';

  @override
  String get sssCategorySecondHandBuying => 'عملية شراء المستعمل';

  @override
  String get sssPhoneSupportTitle => 'الدعم الهاتفي';

  @override
  String get sssWorkingHoursTitle => 'ساعات العمل';

  @override
  String get sssWorkingHoursValue => '09:00 - 22:00';

  @override
  String get sssStoreAddressTitle => 'عنوان المتجر';

  @override
  String get sssStoreAddressValue => 'İçerenköy Mahallesi Buket Sok. No:6';

  @override
  String get sssNoAnswerTitle => 'لم تجد إجابة لسؤالك؟';

  @override
  String get sssNoAnswerSubtitle => 'يمكنك التواصل معنا';

  @override
  String get sssVisitStoreButton => 'زيارة المتجر';

  @override
  String get sssQ1 => 'هل يمكنكم إخبارنا عن حياة الأستاذ المهنية وخبرته؟';

  @override
  String get sssA1 =>
      'يعمل أستاذنا الحرفي بنشاط في هذا القطاع منذ عام 1995. أظهر تطورًا مستمرًا منذ أولى خطواته في مسيرته المهنية. خلال حياته العملية، عمل في مواقع عديدة مثل القيادة للتوصيل والنقل والتركيب واستقبال العملاء، مكتسبًا خبرة متعددة الجوانب. عمل بشكل خاص حتى عام 2010 في شركة İstikbal واكتسب خلالها معرفة عميقة بخصائص المنتجات وأجزائها وأسرارها. بعد عام 2010، عمل في متجر Işık Çeyiz القريب مما زاد من كفاءته في القطاع. وفي عام 2012 قرر افتتاح متجره الحرفي الخاص، وسعى منذ ذلك الحين لتقديم خدمة عالية الجودة ونقل خبرته في القطاع إلى عملائه بأفضل شكل ممكن.';

  @override
  String get sssQ2 => 'هل سالام سبوت موثوق؟';

  @override
  String get sssA2 =>
      'منذ عام 2012 ونحن نخدم جيراننا في إيچيرينكوي. استضفنا عددًا لا يحصى من المنازل وما زلنا نستضيفها.';

  @override
  String get sssQ3 => 'هل يمكنني زيارة متجركم لمعاينة المنتجات؟';

  @override
  String get sssA3 =>
      'بالطبع! بل نحن ننصح بذلك تحديدًا. رؤية المنتجات على الطبيعة ولمسها والشعور بأنها مناسبة لك أثناء احتساء الشاي هو الأصح دائمًا. نرحب بكم دائمًا في متجرنا بحي إيچيرينكوي.';

  @override
  String get sssQ4 => 'كيف يتم فحص حالة المنتجات المستعملة؟';

  @override
  String get sssA4 =>
      'بالنسبة لنا، المستعمل لا يعني \'جودة أقل\'. يخضع كل منتج لفحص دقيق من أستاذنا الحرفي؛ يتم تنظيفه وصيانته وإجراء الإصلاحات اللازمة بالكامل. ما تراه في الصور هو ما ستحصل عليه، لكننا نقول دائمًا \'تعال وانظر بنفسك\'. رؤيته بعينك دائمًا أفضل.';

  @override
  String get sssQ5 => 'ما هي جودة مواد الأثاث؟';

  @override
  String get sssA5 =>
      'نهتم بالشفافية. لكل منتج قصته ومادته الخاصة. لذلك نكتب كل التفاصيل وجودة المواد والخصائص بوضوح في أقسام وصف المنتج. إذا كان لديك أي استفسار، لا تتردد في السؤال.';

  @override
  String get sssQ6 => 'كيف يتم تحديد أسعار المنتجات؟';

  @override
  String get sssA6 =>
      'عند تحديد أسعارنا، ننظر بعدالة إلى جودة المنتج وظروف السوق معًا. هدفنا هو تمكينك من الحصول على منتجات عالية الجودة وطويلة الأمد دون إرهاق ميزانيتك. نطلب ما هو عادل، لا أكثر.';

  @override
  String get sssQ7 => 'هل توجد خيارات ألوان لمنتجاتكم؟';

  @override
  String get sssA7 =>
      'بما أن منتجاتنا غالبًا ما تكون قطعًا فردية فورية، فإننا نعرضها باللون المتوفر كما هو. للأسف لا يمكننا توفير خيارات ألوان مختلفة. لون المنتج الذي أعجبك هو اللون الذي تراه.';

  @override
  String get sssQ8 => 'هل تقبلون الطلبات الخاصة؟';

  @override
  String get sssA8 =>
      'نتمنى لو استطعنا! لكننا نركز أكثر على منتجاتنا الحالية المختارة بعناية. لا يمكننا حاليًا للأسف قبول طلبات تصنيع أو تصميم خاصة. ننصحك بمعاينة منتجاتنا الجاهزة.';

  @override
  String get sssQ9 => 'ما الذي يجب أن أنتبه له في أوصاف المنتجات؟';

  @override
  String get sssA9 =>
      'أهم نصيحة لدينا: شريط القياس! يرجى مقارنة الأبعاد المذكورة في وصف المنتج بعناية مع المكان الذي ستضعه فيه بمنزلك. حل سؤال \'هل سيتسع؟\' مسبقًا يمنع المشاكل لاحقًا. كما لا تنسَ الممر عند القياس: قِس ليس فقط مكان وضع الأثاث، بل أيضًا كيف سيمر عبر الباب والممر والدرج. اقرأ أيضًا معلومات المادة والحالة.';

  @override
  String get sssQ10 => 'هل توصلون إلى المباني بدون مصعد أو الطوابق العليا؟';

  @override
  String get sssA10 =>
      'هذا من أكثر المواضيع حساسية وأهمية بالنسبة لنا. نحن حرفيون صغار ننفذ العمل بأنفسنا. أستاذنا الحرفي، بعد سنوات من الخبرة، لم يعد شابًا، لذا يجب أن نراعي صحته أيضًا. نطلب تفهمكم أننا لا نستطيع تقديم خدمة رفع أو إنزال الأغراض في المباني بدون مصعد إلى الطوابق العليا (مثل الطابق الثاني وما فوق) على الإطلاق. يرجى توضيح هذا الأمر معنا قبل تقديم طلبكم، فلا نريد إحراجكم.';

  @override
  String get sssQ11 => 'هل تقدمون خدمة نقل؟';

  @override
  String get sssA11 =>
      'بالطبع، نساعد جيراننا. لدينا خدمة نقل مجانية للمناطق القريبة مثل إيچيرينكوي بشكل أساسي، وفنديكلي وكايشداغي وكوچوك بكال كوي وإينونو وبوستانجي صنايي. (باستثناء بعض مناطق بوستانجي وكوزياتاغي، ولا يمكننا نقل الأغراض للطوابق العليا بدون مصعد بسبب كبر سن أستاذنا، وسنناقش ذلك بشكل منفصل).';

  @override
  String get sssQ12 => 'كم تستغرق مدة التوصيل؟';

  @override
  String get sssA12 =>
      'بمجرد تقديم طلبك، نتواصل معك. نسألك \'متى تكون متاحًا؟\'. نتفق على أقرب وقت مناسب لكلينا. عادة ما ننهي التوصيل والتركيب خلال 1-3 أيام في الموعد المتفق عليه.';

  @override
  String get sssQ13 => 'هل تقدمون خدمة التركيب؟';

  @override
  String get sssA13 =>
      'بالطبع. أخذ الأثاث وتركه عند الباب ليس أسلوبنا. يقوم أستاذنا الحرفي بنفسه بتركيب جميع المنتجات الكبيرة، ولا نطلب أي رسوم إضافية مقابل هذه الخدمة. أنت فقط أشر إلى المكان، والباقي علينا.';

  @override
  String get sssQ14 => 'كم يستغرق تسليم طلب الأثاث؟';

  @override
  String get sssA14 =>
      'إذا كان المنتج جاهزًا، نكون عند بابك في أقرب وقت في الموعد الذي نحدده معًا. لا تقلق بشأن التركيب أيضًا؛ نركبه كما أحضرناه ونسلمه جاهزًا. عادة ما ينتهي كل شيء في نفس اليوم.';

  @override
  String get sssQ15 => 'هل يمكنني الطلب بالدَّين؟';

  @override
  String get sssA15 =>
      'نرجو تفهمكم بهذا الخصوص. كحرفيين، لا يمكننا للأسف العمل بطرق مثل \'الدَّين\' أو \'الدفع لاحقًا\' حتى نستمر. يجب أن نستلم المبلغ المتفق عليه نقدًا عند تسليم المنتج. نفضل توضيح هذه القاعدة من البداية حتى لا نُحرجكم.';

  @override
  String get sssQ16 => 'كيف يمكنني تقديم طلب؟';

  @override
  String get sssA16 =>
      'أفضل طريقة هي دائمًا المعاينة وجهًا لوجه. دوّن المنتج الذي أعجبك من الموقع، ثم تعال إلى متجرنا. شاهد المنتج على الطبيعة، اسأل ما يدور في ذهنك، وإذا شعرت بالرضا، فلنكمل طلبك هناك. بهذه الطريقة لا يبقى أي شك.';

  @override
  String get sssQ17 => 'ما هي سياسة إرجاع المنتجات لديكم؟';

  @override
  String get sssA17 =>
      'نظرًا لطبيعة المنتجات المستعملة وأسلوب عملنا كحرفيين، لا يمكننا للأسف قبول الإرجاع. لهذا السبب نصرّ على \'تعال، شاهد، اشرب الشاي معنا\'. الأصح هو فحص المنتج بالتفصيل وقياسه قبل الشراء. دعونا لا نكمل عملية الشراء دون التأكد.';

  @override
  String get sssQ18 => 'هل توجد فترة ضمان للمنتجات؟';

  @override
  String get sssA18 =>
      'بما أن منتجاتنا مستعملة، لا نملك للأسف فترة ضمان رسمية كما تقدمها العلامات التجارية. لكننا لسنا ممن يقولون \'بِيع، وانتهى الأمر\'. نتأكد من أن كل شيء يعمل بشكل سليم أثناء التوصيل والتركيب.';

  @override
  String get sssQ19 => 'أريد بيع أغراض من منزلي، هل تشترون المستعمل؟';

  @override
  String get sssA19 =>
      'نعم، نشتري منتجات مختارة نظيفة وقابلة لإعادة البيع نعتقد أنه يمكننا عرضها في متجرنا. لكن نظرًا لأن مساحة متجرنا صغيرة جدًا فعليًا، فنحن مضطرون للأسف لأن نكون انتقائيين جدًا في هذا الشأن.\n\nنحب أن نكون صريحين معكم من البداية: العرض الذي ستحصلون عليه منا قد يكون أقل قليلًا مما يمكنكم بيعه بأنفسكم على منصات مثل Letgo. السبب هو: نحن كحرفيين ننفق البنزين لاستلام القطعة، ونبذل جهدًا في النقل، والأهم من ذلك، نتولى العملية الكاملة مع العملاء (المساومة، الأسئلة، إلخ) لعرضها وبيعها في متجرنا.\n\nعندما تبيعون بأنفسكم على تلك المنصات، تتحملون كل هذه العمليات بأنفسكم. أما نحن فنتولى عنكم هذا العناء. عرضنا يشمل هذه الخدمة أيضًا. شكرًا لتفهمكم.';

  @override
  String get sssQ20 => 'هل تشترون أطقم أثاث كاملة (غرفة نوم، طقم صالون، إلخ)؟';

  @override
  String get sssA20 =>
      'بسبب صغر متجرنا، لا يمكننا للأسف شراء أطقم كاملة كبيرة مثل غرفة نوم أو طقم كنب كامل. مساحتنا محدودة جدًا. نركز أكثر على القطع الفردية التي يسهل بيعها، مثل الكونسول والخزانة والطاولة والكرسي.';

  @override
  String get sssQ21 => 'أغراضي في طابق عالٍ والمبنى بدون مصعد. هل تشترونها؟';

  @override
  String get sssA21 =>
      'تمامًا كما في موضوع التوصيل، هذه أوضح قاعدة لدينا. بسبب الحالة الصحية لأستاذنا الحرفي، لا يمكننا على الإطلاق إنزال الأغراض من الطوابق العليا في المباني بدون مصعد. يمكننا فقط النظر في الأمر إذا كانت أغراضكم قريبة من الطابق الأرضي/المدخل أو إذا كان المبنى يحتوي على مصعد بضائع.';

  @override
  String get sssQ22 => 'هل تشترون الأغراض دائمًا؟';

  @override
  String get sssA22 =>
      'يعتمد هذا كليًا على المساحة المتوفرة في متجرنا. بما أن متجرنا صغير، نعمل وفق توازن \'بيع-شراء\'. أحيانًا نعجب كثيرًا بمنتج ما لكن لا نستطيع شراءه لعدم توفر المساحة. أفضل طريقة هي أن ترسلوا لنا صور المنتج الذي ترغبون في بيعه. سنخبركم بصدق إذا كان لدينا مساحة الآن أو أننا للأسف ممتلئون في هذه الفترة.';

  @override
  String get navDiscover => 'استكشف';

  @override
  String get navCart => 'السلة';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get storeHeroEyebrow => 'تشكيلة جديدة';

  @override
  String get storeHeroTitle => 'أثاث يجعل بيتك\nأكثر دفئًا';

  @override
  String get storeHeroSubtitle =>
      'أثاث جديد ومستعمل عالي الجودة، يصل إلى بابك بأسعار ستعجبك.';

  @override
  String get storeHeroCta => 'ابدأ التسوق';

  @override
  String get sectionCategories => 'الفئات';

  @override
  String get sectionBestSellers => 'الأكثر مبيعًا';

  @override
  String get sectionNewArrivals => 'وصل حديثًا';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get cartTitle => 'سلتي';

  @override
  String get cartEmptyTitle => 'سلتك فارغة';

  @override
  String get cartEmptyDesc =>
      'أضف المنتجات التي تعجبك، ثم استفسر عنها جميعًا برسالة واحدة.';

  @override
  String get cartTotalLabel => 'الإجمالي';

  @override
  String get cartWhatsappCta => 'إرسال السلة عبر واتساب';

  @override
  String get cartItemRemoved => 'تمت الإزالة من السلة';

  @override
  String get addToCartCta => 'أضف إلى السلة';

  @override
  String get addedToCartMessage => 'تمت الإضافة إلى السلة';

  @override
  String get alreadyInCartMessage => 'هذا المنتج موجود بالفعل في السلة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLanguageLabel => 'اللغة';

  @override
  String get settingsAccountSection => 'الحساب';

  @override
  String get settingsGeneralSection => 'عام';

  @override
  String get settingsContact => 'التواصل';

  @override
  String get settingsCallUs => 'اتصل بنا';

  @override
  String get settingsAdminLogin => 'دخول المسؤول';

  @override
  String get settingsAppVersion => 'إصدار التطبيق';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتج',
      one: 'منتج واحد',
      zero: 'السلة فارغة',
    );
    return '$_temp0';
  }

  @override
  String get settingsRateApp => 'قيّم التطبيق';

  @override
  String get settingsShareApp => 'شارك التطبيق';

  @override
  String get settingsPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get settingsTerms => 'الشروط والأحكام';

  @override
  String get legalContentTurkishOnly =>
      'هذا المحتوى متاح حاليًا باللغة التركية فقط.';

  @override
  String get doubleBackToExit => 'اضغط رجوع مرة أخرى للخروج';

  @override
  String get productLinkLabel => 'رابط المنتج';

  @override
  String get settingsAppSection => 'التطبيق';

  @override
  String get settingsLegalSection => 'قانوني';

  @override
  String get recentlyViewedTitle => 'شوهد مؤخرًا';

  @override
  String get productTrustBadgeVerified => 'بائع موثّق';

  @override
  String get productTrustBadgeNegotiate => 'التفاوض عبر واتساب';

  @override
  String get productTrustBadgeDelivery => 'التسليم في الموقع';

  @override
  String get howToBuyTitle => 'كيف أشتري؟';

  @override
  String get howToBuyStep1Title => 'راسلنا عبر واتساب';

  @override
  String get howToBuyStep1Desc => 'إذا أعجبك المنتج، تواصل معنا عبر واتساب.';

  @override
  String get howToBuyStep2Title => 'ناقش السعر';

  @override
  String get howToBuyStep2Desc => 'اتفقا معًا على السعر وتفاصيل التسليم.';

  @override
  String get howToBuyStep3Title => 'استلم المنتج';

  @override
  String get howToBuyStep3Desc => 'بعد الاتفاق، استلم منتجك بأمان.';

  @override
  String get listedToday => 'أُضيف اليوم';

  @override
  String listedDaysAgo(int days) {
    return 'أُضيف قبل $days أيام';
  }

  @override
  String listedWeeksAgo(int weeks) {
    return 'أُضيف قبل $weeks أسابيع';
  }
}

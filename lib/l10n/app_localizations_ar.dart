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
}

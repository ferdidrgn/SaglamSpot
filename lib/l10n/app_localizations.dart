import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @brand.
  ///
  /// In tr, this message translates to:
  /// **'SAĞLAM SPOT'**
  String get brand;

  /// No description provided for @home.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get home;

  /// No description provided for @searchHint.
  ///
  /// In tr, this message translates to:
  /// **'Eviniz için ne aramıştınız?...'**
  String get searchHint;

  /// No description provided for @collection.
  ///
  /// In tr, this message translates to:
  /// **'KOLEKSİYON'**
  String get collection;

  /// No description provided for @eleganceAndComfort.
  ///
  /// In tr, this message translates to:
  /// **'Zarafet & Konfor'**
  String get eleganceAndComfort;

  /// No description provided for @productsFound.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Ürün bulunamadı} =1{1 Ürün Bulundu} other{{count} Ürün Bulundu}}'**
  String productsFound(int count);

  /// No description provided for @resultsFor.
  ///
  /// In tr, this message translates to:
  /// **'\"{query}\" için sonuçlar'**
  String resultsFor(String query);

  /// No description provided for @seoHomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sağlam Spot | Spot & Sıfır Mobilya'**
  String get seoHomeTitle;

  /// No description provided for @seoHomeDesc.
  ///
  /// In tr, this message translates to:
  /// **'Spot ve sıfır mobilyalarda en uygun fiyatlar. 20 yıllık esnaf güvencesiyle.'**
  String get seoHomeDesc;

  /// No description provided for @seoNewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sıfır Ürünler | Sağlam Spot'**
  String get seoNewTitle;

  /// No description provided for @seoNewDesc.
  ///
  /// In tr, this message translates to:
  /// **'Garantili ve kaliteli sıfır mobilya koleksiyonu.'**
  String get seoNewDesc;

  /// No description provided for @seoSpotTitle.
  ///
  /// In tr, this message translates to:
  /// **'Spot Ürünler | Sağlam Spot'**
  String get seoSpotTitle;

  /// No description provided for @seoSpotDesc.
  ///
  /// In tr, this message translates to:
  /// **'Ekonomik ve kaliteli spot mobilya seçenekleri.'**
  String get seoSpotDesc;

  /// No description provided for @seoAboutTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hakkımızda | Sağlam Spot'**
  String get seoAboutTitle;

  /// No description provided for @seoAboutDesc.
  ///
  /// In tr, this message translates to:
  /// **'20 yıllık tecrübemizle mobilya sektöründe güvenin adresi.'**
  String get seoAboutDesc;

  /// No description provided for @seoProductDetailSuffix.
  ///
  /// In tr, this message translates to:
  /// **'Ürünü İncele | Sağlam Spot'**
  String get seoProductDetailSuffix;

  /// No description provided for @category.
  ///
  /// In tr, this message translates to:
  /// **'Kategori'**
  String get category;

  /// No description provided for @categorySofa.
  ///
  /// In tr, this message translates to:
  /// **'Oturma Grupları'**
  String get categorySofa;

  /// No description provided for @categoryChair.
  ///
  /// In tr, this message translates to:
  /// **'Sandalye'**
  String get categoryChair;

  /// No description provided for @categoryTable.
  ///
  /// In tr, this message translates to:
  /// **'Masa'**
  String get categoryTable;

  /// No description provided for @categoryBed.
  ///
  /// In tr, this message translates to:
  /// **'Yatak Odası'**
  String get categoryBed;

  /// No description provided for @categoryWardrobe.
  ///
  /// In tr, this message translates to:
  /// **'Dolap'**
  String get categoryWardrobe;

  /// No description provided for @categoryWhite.
  ///
  /// In tr, this message translates to:
  /// **'Beyaz Eşya'**
  String get categoryWhite;

  /// No description provided for @categoryOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get categoryOther;

  /// No description provided for @condition.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get condition;

  /// No description provided for @conditionAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get conditionAll;

  /// No description provided for @conditionNew.
  ///
  /// In tr, this message translates to:
  /// **'Sıfır'**
  String get conditionNew;

  /// No description provided for @conditionUsed.
  ///
  /// In tr, this message translates to:
  /// **'İkinci El'**
  String get conditionUsed;

  /// No description provided for @priceRange.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat Aralığı'**
  String get priceRange;

  /// No description provided for @clear.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get clear;

  /// No description provided for @filter.
  ///
  /// In tr, this message translates to:
  /// **'Filtrele'**
  String get filter;

  /// No description provided for @apply.
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get apply;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get cancel;

  /// No description provided for @newSeason.
  ///
  /// In tr, this message translates to:
  /// **'YENİ SEZON'**
  String get newSeason;

  /// No description provided for @heroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Minimalist\nKonforun Zirvesi'**
  String get heroTitle;

  /// No description provided for @viewCollection.
  ///
  /// In tr, this message translates to:
  /// **'KOLEKSİYONU GÖR'**
  String get viewCollection;

  /// No description provided for @featureArtisan.
  ///
  /// In tr, this message translates to:
  /// **'Samimi Esnaflık'**
  String get featureArtisan;

  /// No description provided for @featureDelivery.
  ///
  /// In tr, this message translates to:
  /// **'Güvenli Teslimat'**
  String get featureDelivery;

  /// No description provided for @featureService.
  ///
  /// In tr, this message translates to:
  /// **'Güler Yüzlü Hizmet'**
  String get featureService;

  /// No description provided for @featureShipping.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Nakliye'**
  String get featureShipping;

  /// No description provided for @newCollection.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Koleksiyon'**
  String get newCollection;

  /// No description provided for @newCollectionSub.
  ///
  /// In tr, this message translates to:
  /// **'En yeni ürünler'**
  String get newCollectionSub;

  /// No description provided for @spotProducts.
  ///
  /// In tr, this message translates to:
  /// **'Spot Ürünler'**
  String get spotProducts;

  /// No description provided for @spotProductsSub.
  ///
  /// In tr, this message translates to:
  /// **'Fırsat Ürünleri'**
  String get spotProductsSub;

  /// No description provided for @spotProductsDesc.
  ///
  /// In tr, this message translates to:
  /// **'Kaliteli ürünlerde inanılmaz fiyatlar'**
  String get spotProductsDesc;

  /// No description provided for @currentCollection.
  ///
  /// In tr, this message translates to:
  /// **'MEVCUT KOLEKSİYON'**
  String get currentCollection;

  /// No description provided for @soldProducts.
  ///
  /// In tr, this message translates to:
  /// **'SATILMIŞ ÜRÜNLER'**
  String get soldProducts;

  /// No description provided for @pieces.
  ///
  /// In tr, this message translates to:
  /// **'{count} Parça'**
  String pieces(int count);

  /// No description provided for @inStock.
  ///
  /// In tr, this message translates to:
  /// **'STOKTA'**
  String get inStock;

  /// No description provided for @sold.
  ///
  /// In tr, this message translates to:
  /// **'SATILDI'**
  String get sold;

  /// No description provided for @byRoom.
  ///
  /// In tr, this message translates to:
  /// **'Yaşam Alanına Göre'**
  String get byRoom;

  /// No description provided for @byRoomSub.
  ///
  /// In tr, this message translates to:
  /// **'Evinizin her köşesi için özel seçimler'**
  String get byRoomSub;

  /// No description provided for @roomLivingRoom.
  ///
  /// In tr, this message translates to:
  /// **'Salon'**
  String get roomLivingRoom;

  /// No description provided for @roomLivingRoomSub.
  ///
  /// In tr, this message translates to:
  /// **'Konforun Merkezi'**
  String get roomLivingRoomSub;

  /// No description provided for @roomBedroom.
  ///
  /// In tr, this message translates to:
  /// **'Yatak'**
  String get roomBedroom;

  /// No description provided for @roomBedroomSub.
  ///
  /// In tr, this message translates to:
  /// **'Huzurlu Uykular'**
  String get roomBedroomSub;

  /// No description provided for @roomKitchen.
  ///
  /// In tr, this message translates to:
  /// **'Mutfak'**
  String get roomKitchen;

  /// No description provided for @roomKitchenSub.
  ///
  /// In tr, this message translates to:
  /// **'Pratik Çözümler'**
  String get roomKitchenSub;

  /// No description provided for @roomOffice.
  ///
  /// In tr, this message translates to:
  /// **'Ofis'**
  String get roomOffice;

  /// No description provided for @roomOfficeSub.
  ///
  /// In tr, this message translates to:
  /// **'Verimli Çalışma'**
  String get roomOfficeSub;

  /// No description provided for @whoWeAre.
  ///
  /// In tr, this message translates to:
  /// **'BİZ KİMİZ?'**
  String get whoWeAre;

  /// No description provided for @artisanTitle.
  ///
  /// In tr, this message translates to:
  /// **'20 Yıllık Samimi Esnaflık,\nModern Hizmet.'**
  String get artisanTitle;

  /// No description provided for @artisanDesc.
  ///
  /// In tr, this message translates to:
  /// **'Mağazamıza gelin, bir çayımızı için; size en uygun mobilyayı birlikte seçelim.'**
  String get artisanDesc;

  /// No description provided for @visitUsButton.
  ///
  /// In tr, this message translates to:
  /// **'BİZİ ZİYARET EDİN'**
  String get visitUsButton;

  /// No description provided for @statHappyCustomer.
  ///
  /// In tr, this message translates to:
  /// **'Mutlu Müşteri'**
  String get statHappyCustomer;

  /// No description provided for @statExperience.
  ///
  /// In tr, this message translates to:
  /// **'Tecrübe'**
  String get statExperience;

  /// No description provided for @statDelivery.
  ///
  /// In tr, this message translates to:
  /// **'Teslimat'**
  String get statDelivery;

  /// No description provided for @statTrust.
  ///
  /// In tr, this message translates to:
  /// **'Güven'**
  String get statTrust;

  /// No description provided for @explore.
  ///
  /// In tr, this message translates to:
  /// **'KEŞFET'**
  String get explore;

  /// No description provided for @collections.
  ///
  /// In tr, this message translates to:
  /// **'Koleksiyonlar'**
  String get collections;

  /// No description provided for @corporate.
  ///
  /// In tr, this message translates to:
  /// **'KURUMSAL'**
  String get corporate;

  /// No description provided for @aboutUs.
  ///
  /// In tr, this message translates to:
  /// **'Hakkımızda'**
  String get aboutUs;

  /// No description provided for @contact.
  ///
  /// In tr, this message translates to:
  /// **'İletişim'**
  String get contact;

  /// No description provided for @contactUs.
  ///
  /// In tr, this message translates to:
  /// **'BİZE ULAŞIN'**
  String get contactUs;

  /// No description provided for @sss.
  ///
  /// In tr, this message translates to:
  /// **'SSS'**
  String get sss;

  /// No description provided for @qualityFurniture.
  ///
  /// In tr, this message translates to:
  /// **'\'Kaliteli mobilyanın adresi Sağlam Spot\''**
  String get qualityFurniture;

  /// No description provided for @footerDesc.
  ///
  /// In tr, this message translates to:
  /// **'20 yılı aşkın tecrübemizle İstanbul\'un her noktasına kaliteyi ve güveni taşıyoruz.'**
  String get footerDesc;

  /// No description provided for @allRightsReserved.
  ///
  /// In tr, this message translates to:
  /// **'© 2026 SAĞLAM SPOT TİCARET. TÜM HAKLARI SAKLIDIR.'**
  String get allRightsReserved;

  /// No description provided for @errorOccurred.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu'**
  String get errorOccurred;

  /// No description provided for @productNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Ürün bulunamadı'**
  String get productNotFound;

  /// No description provided for @noImages.
  ///
  /// In tr, this message translates to:
  /// **'Görsel Yok'**
  String get noImages;

  /// No description provided for @error_check_connection.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantınızı kontrol edin.'**
  String get error_check_connection;

  /// No description provided for @error_server_no_response.
  ///
  /// In tr, this message translates to:
  /// **'Sunucu şu an yanıt vermiyor.'**
  String get error_server_no_response;

  /// No description provided for @error_critical.
  ///
  /// In tr, this message translates to:
  /// **'Kritik bir hata oluştu.'**
  String get error_critical;

  /// No description provided for @error_connection.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı hatası'**
  String get error_connection;

  /// No description provided for @error_connection_lost.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı Kesildi'**
  String get error_connection_lost;

  /// No description provided for @status_waiting_connection.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantı bekleniyor...'**
  String get status_waiting_connection;

  /// No description provided for @error_no_internet_auto_retry.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantınız yok.\nBağlantı sağlandığında otomatik olarak devam edeceksiniz.'**
  String get error_no_internet_auto_retry;

  /// No description provided for @goBack.
  ///
  /// In tr, this message translates to:
  /// **'Geri Dön'**
  String get goBack;

  /// No description provided for @galleryEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Galeri boş'**
  String get galleryEmpty;

  /// No description provided for @month_1.
  ///
  /// In tr, this message translates to:
  /// **'Ocak'**
  String get month_1;

  /// No description provided for @month_2.
  ///
  /// In tr, this message translates to:
  /// **'Şubat'**
  String get month_2;

  /// No description provided for @month_3.
  ///
  /// In tr, this message translates to:
  /// **'Mart'**
  String get month_3;

  /// No description provided for @month_4.
  ///
  /// In tr, this message translates to:
  /// **'Nisan'**
  String get month_4;

  /// No description provided for @month_5.
  ///
  /// In tr, this message translates to:
  /// **'Mayıs'**
  String get month_5;

  /// No description provided for @month_6.
  ///
  /// In tr, this message translates to:
  /// **'Haziran'**
  String get month_6;

  /// No description provided for @month_7.
  ///
  /// In tr, this message translates to:
  /// **'Temmuz'**
  String get month_7;

  /// No description provided for @month_8.
  ///
  /// In tr, this message translates to:
  /// **'Ağustos'**
  String get month_8;

  /// No description provided for @month_9.
  ///
  /// In tr, this message translates to:
  /// **'Eylül'**
  String get month_9;

  /// No description provided for @month_10.
  ///
  /// In tr, this message translates to:
  /// **'Ekim'**
  String get month_10;

  /// No description provided for @month_11.
  ///
  /// In tr, this message translates to:
  /// **'Kasım'**
  String get month_11;

  /// No description provided for @month_12.
  ///
  /// In tr, this message translates to:
  /// **'Aralık'**
  String get month_12;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_zh.dart';

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
    Locale('ar'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('it'),
    Locale('ky'),
    Locale('ru'),
    Locale('tr'),
    Locale('uk'),
    Locale('uz'),
    Locale('zh')
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

  /// No description provided for @price.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat'**
  String get price;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @explanation.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get explanation;

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

  /// No description provided for @quickOptions.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Seçenekler'**
  String get quickOptions;

  /// No description provided for @easyFind.
  ///
  /// In tr, this message translates to:
  /// **'Aradığınız ürünü kolayca bulun'**
  String get easyFind;

  /// No description provided for @mottoBrand.
  ///
  /// In tr, this message translates to:
  /// **'Eskiyi Yeniler, Yeniyi Değerlendirir'**
  String get mottoBrand;

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

  /// No description provided for @stock.
  ///
  /// In tr, this message translates to:
  /// **'STOKTA'**
  String get stock;

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

  /// No description provided for @noProductFoundTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aradığınız Kriterde Ürün Bulunamadı'**
  String get noProductFoundTitle;

  /// No description provided for @noProductFoundDescription.
  ///
  /// In tr, this message translates to:
  /// **'Farklı filtreler deneyebilir veya arama teriminizi değiştirebilirsiniz'**
  String get noProductFoundDescription;

  /// No description provided for @adminPanelTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici Paneli'**
  String get adminPanelTitle;

  /// No description provided for @totalCount.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get totalCount;

  /// No description provided for @productAddedSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Ürün başarıyla eklendi'**
  String get productAddedSuccess;

  /// No description provided for @authOrConnectionError.
  ///
  /// In tr, this message translates to:
  /// **'Yetki veya bağlantı hatası oluştu'**
  String get authOrConnectionError;

  /// No description provided for @fillRequiredFields.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen ürün adı, fiyat ve en az bir görsel ekleyin!'**
  String get fillRequiredFields;

  /// No description provided for @sessionClosed.
  ///
  /// In tr, this message translates to:
  /// **'Oturum kapalı'**
  String get sessionClosed;

  /// No description provided for @addNewProduct.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ürün Ekle'**
  String get addNewProduct;

  /// No description provided for @productImages.
  ///
  /// In tr, this message translates to:
  /// **'Ürün Görselleri'**
  String get productImages;

  /// No description provided for @generalInfo.
  ///
  /// In tr, this message translates to:
  /// **'Genel Bilgiler'**
  String get generalInfo;

  /// No description provided for @productNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ürün Adı'**
  String get productNameLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get descriptionLabel;

  /// No description provided for @statusLabel.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get statusLabel;

  /// No description provided for @spotSecondHand.
  ///
  /// In tr, this message translates to:
  /// **'Spot / İkinci El'**
  String get spotSecondHand;

  /// No description provided for @secondHandHint.
  ///
  /// In tr, this message translates to:
  /// **'Tek parça — renk seçeneği gösterilmeyecek'**
  String get secondHandHint;

  /// No description provided for @newProductHint.
  ///
  /// In tr, this message translates to:
  /// **'Sıfır ürün — renk seçeneği ekleyebilirsin'**
  String get newProductHint;

  /// No description provided for @colorOptionsOptional.
  ///
  /// In tr, this message translates to:
  /// **'Renk Seçenekleri (opsiyonel)'**
  String get colorOptionsOptional;

  /// No description provided for @noImagesYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz görsel eklenmedi'**
  String get noImagesYet;

  /// No description provided for @addImage.
  ///
  /// In tr, this message translates to:
  /// **'Görsel Ekle'**
  String get addImage;

  /// No description provided for @editProductTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ürünü Düzenle'**
  String get editProductTitle;

  /// No description provided for @changeImages.
  ///
  /// In tr, this message translates to:
  /// **'Görselleri Değiştir'**
  String get changeImages;

  /// No description provided for @saveChanges.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikleri Kaydet'**
  String get saveChanges;

  /// No description provided for @deleteProductTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ürünü Sil'**
  String get deleteProductTitle;

  /// No description provided for @deleteProductConfirmSuffix.
  ///
  /// In tr, this message translates to:
  /// **'silinecek. Emin misiniz?'**
  String get deleteProductConfirmSuffix;

  /// No description provided for @yesDelete.
  ///
  /// In tr, this message translates to:
  /// **'Evet, Sil'**
  String get yesDelete;

  /// No description provided for @emptyCategoryProducts.
  ///
  /// In tr, this message translates to:
  /// **'Bu kategoride ürün bulunamadı'**
  String get emptyCategoryProducts;

  /// No description provided for @adminLoginSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici Paneline Giriş'**
  String get adminLoginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get loginButton;

  /// No description provided for @sponsored.
  ///
  /// In tr, this message translates to:
  /// **'Sponsorlu'**
  String get sponsored;

  /// No description provided for @addProductFab.
  ///
  /// In tr, this message translates to:
  /// **'Ürün Ekle'**
  String get addProductFab;

  /// No description provided for @singlePieceNotice.
  ///
  /// In tr, this message translates to:
  /// **'Bu, ikinci el / spot bir üründür — stokta tek parça vardır, renk ve görsel tamamen fotoğraflardaki gibidir.'**
  String get singlePieceNotice;

  /// No description provided for @colorOptionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Renk Seçenekleri'**
  String get colorOptionsTitle;

  /// No description provided for @newProductBadge.
  ///
  /// In tr, this message translates to:
  /// **'SIFIR ÜRÜN'**
  String get newProductBadge;

  /// No description provided for @usedProductBadge.
  ///
  /// In tr, this message translates to:
  /// **'İKİNCİ EL'**
  String get usedProductBadge;

  /// No description provided for @readMore.
  ///
  /// In tr, this message translates to:
  /// **'Devamını oku'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In tr, this message translates to:
  /// **'Daha az göster'**
  String get readLess;

  /// No description provided for @specDelivery.
  ///
  /// In tr, this message translates to:
  /// **'Teslimat'**
  String get specDelivery;

  /// No description provided for @specDeliveryValue.
  ///
  /// In tr, this message translates to:
  /// **'1-2 Gün İçinde'**
  String get specDeliveryValue;

  /// No description provided for @specLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get specLocation;

  /// No description provided for @sellerTrustLine.
  ///
  /// In tr, this message translates to:
  /// **'20 yıllık esnaf güvencesi · İçerenköy'**
  String get sellerTrustLine;

  /// No description provided for @whatsappCta.
  ///
  /// In tr, this message translates to:
  /// **'WhatsApp\'tan Yaz'**
  String get whatsappCta;

  /// No description provided for @callCta.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get callCta;

  /// No description provided for @similarProducts.
  ///
  /// In tr, this message translates to:
  /// **'Benzer Ürünler'**
  String get similarProducts;

  /// No description provided for @conditionShowcase.
  ///
  /// In tr, this message translates to:
  /// **'Vitrin'**
  String get conditionShowcase;

  /// No description provided for @productDescriptionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get productDescriptionTitle;

  /// No description provided for @loginBrand.
  ///
  /// In tr, this message translates to:
  /// **'Sağlam Spot'**
  String get loginBrand;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Oturumu Kapat'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınızdan güvenli bir şekilde çıkış yapmak istediğinize emin misiniz?'**
  String get logoutConfirm;

  /// No description provided for @testimonialsHeading.
  ///
  /// In tr, this message translates to:
  /// **'Müşterilerimiz Ne Diyor?'**
  String get testimonialsHeading;

  /// No description provided for @testimonialsSubheading.
  ///
  /// In tr, this message translates to:
  /// **'20 yılı aşkın süredir İçerenköy ve çevresinde binlerce eve dokunduk'**
  String get testimonialsSubheading;

  /// No description provided for @testimonial1Comment.
  ///
  /// In tr, this message translates to:
  /// **'Koltuk takımını çok uygun fiyata aldık, hem de sıfır gibi. Teslimat aynı gün elden ele yapıldı, esnaf usulü güven tam anlamıyla buradaydı.'**
  String get testimonial1Comment;

  /// No description provided for @testimonial2Comment.
  ///
  /// In tr, this message translates to:
  /// **'Yatak odası takımını spot fiyatına buradan aldım. Ürün açıklamasıyla birebir aynıydı, hiçbir sürpriz yaşamadım. Kesinlikle tavsiye ederim.'**
  String get testimonial2Comment;

  /// No description provided for @testimonial3Comment.
  ///
  /// In tr, this message translates to:
  /// **'Ofis için toplu mobilya alımı yaptık, hem fiyat hem kalite beklentimizin üzerindeydi. İlgili ve sabırlı bir ekip, teşekkürler Sağlam Spot.'**
  String get testimonial3Comment;

  /// No description provided for @testimonial4Comment.
  ///
  /// In tr, this message translates to:
  /// **'Yemek masası setini pazarlıksız, dürüst bir fiyata satın aldık. Nakliye konusunda da yardımcı oldular, gönül rahatlığıyla alışveriş yaptık.'**
  String get testimonial4Comment;

  /// No description provided for @testimonial5Comment.
  ///
  /// In tr, this message translates to:
  /// **'İkinci el gardırop aradık, hem sağlam hem şık bir ürün bulduk. Fiyat/performans olarak piyasadaki en iyi seçenekti.'**
  String get testimonial5Comment;

  /// No description provided for @testimonial6Comment.
  ///
  /// In tr, this message translates to:
  /// **'Showroom ziyaretimizde ürünleri yerinde görme şansımız oldu, bu güveni artırdı. Satış sonrası da bize her zaman ulaşılabilir oldular.'**
  String get testimonial6Comment;

  /// No description provided for @howItWorksHeading.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl Çalışır?'**
  String get howItWorksHeading;

  /// No description provided for @step1Title.
  ///
  /// In tr, this message translates to:
  /// **'Gözat & Filtrele'**
  String get step1Title;

  /// No description provided for @step1Desc.
  ///
  /// In tr, this message translates to:
  /// **'Kategoriler ve fiyat aralığına göre binlerce ürün arasından beğendiğini bul.'**
  String get step1Desc;

  /// No description provided for @step2Title.
  ///
  /// In tr, this message translates to:
  /// **'Bizimle İletişime Geç'**
  String get step2Title;

  /// No description provided for @step2Desc.
  ///
  /// In tr, this message translates to:
  /// **'Ürün sayfasından tek tıkla WhatsApp veya telefonla ekibimize ulaş.'**
  String get step2Desc;

  /// No description provided for @step3Title.
  ///
  /// In tr, this message translates to:
  /// **'Fiyatı Netleştir'**
  String get step3Title;

  /// No description provided for @step3Desc.
  ///
  /// In tr, this message translates to:
  /// **'Ürünü showroomda gör veya fotoğraflarla teyit et, esnaf usulü net fiyat al.'**
  String get step3Desc;

  /// No description provided for @step4Title.
  ///
  /// In tr, this message translates to:
  /// **'Kapına Teslim'**
  String get step4Title;

  /// No description provided for @step4Desc.
  ///
  /// In tr, this message translates to:
  /// **'İçerenköy ve Anadolu Yakası\'na hızlı, sigortalı taşıma ile mobilyan güvenle evine gelsin.'**
  String get step4Desc;

  /// No description provided for @tipsEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'İPUÇLARI'**
  String get tipsEyebrow;

  /// No description provided for @tipsHeading.
  ///
  /// In tr, this message translates to:
  /// **'Uzmanından Bakım Önerileri'**
  String get tipsHeading;

  /// No description provided for @tip1Title.
  ///
  /// In tr, this message translates to:
  /// **'Oturma Odasını Sevilesi Hale Getirin'**
  String get tip1Title;

  /// No description provided for @tip1Desc.
  ///
  /// In tr, this message translates to:
  /// **'Koltuk yerleşimini duvardan 1-2 cm boşluk bırakarak yapın; hem hava sirkülasyonu sağlar hem de odayı ferahlatır.'**
  String get tip1Desc;

  /// No description provided for @tip1Category.
  ///
  /// In tr, this message translates to:
  /// **'Yerleştirme'**
  String get tip1Category;

  /// No description provided for @tip2Title.
  ///
  /// In tr, this message translates to:
  /// **'Temiz Görünen Bir Çalışma Alanı'**
  String get tip2Title;

  /// No description provided for @tip2Desc.
  ///
  /// In tr, this message translates to:
  /// **'Kabloları toplayıcılarla düzenleyin, mikrofiber bezle dairesel hareketlerle silin — masanız hep yeni gibi kalsın.'**
  String get tip2Desc;

  /// No description provided for @tip2Category.
  ///
  /// In tr, this message translates to:
  /// **'Temizlik'**
  String get tip2Category;

  /// No description provided for @tip3Title.
  ///
  /// In tr, this message translates to:
  /// **'Mutfakta Keyifli Bir Kurulum'**
  String get tip3Title;

  /// No description provided for @tip3Desc.
  ///
  /// In tr, this message translates to:
  /// **'Ağır malzemeleri alt raflara, sık kullandıklarınızı göz hizasına yerleştirin — hem pratik hem güvenli.'**
  String get tip3Desc;

  /// No description provided for @tip3Category.
  ///
  /// In tr, this message translates to:
  /// **'Düzen'**
  String get tip3Category;

  /// No description provided for @tip4Title.
  ///
  /// In tr, this message translates to:
  /// **'Rahat Bir Uyku Köşesi Kurun'**
  String get tip4Title;

  /// No description provided for @tip4Desc.
  ///
  /// In tr, this message translates to:
  /// **'Yatak başlığını pencereden uzağa, ışığı en aza indirecek şekilde konumlandırın — daha derin bir uyku için küçük ama etkili bir değişiklik.'**
  String get tip4Desc;

  /// No description provided for @tip4Category.
  ///
  /// In tr, this message translates to:
  /// **'Konfor'**
  String get tip4Category;

  /// No description provided for @tip5Title.
  ///
  /// In tr, this message translates to:
  /// **'Dolabınızı Ferahlatın'**
  String get tip5Title;

  /// No description provided for @tip5Desc.
  ///
  /// In tr, this message translates to:
  /// **'Sezonluk kıyafetleri ayırın, askı yönünü tek taraflı tutun — hem yer kazanır hem de her sabah seçim yapmak kolaylaşır.'**
  String get tip5Desc;

  /// No description provided for @tip5Category.
  ///
  /// In tr, this message translates to:
  /// **'Organizasyon'**
  String get tip5Category;

  /// No description provided for @tip6Title.
  ///
  /// In tr, this message translates to:
  /// **'Ahşap Mobilyaya Ömür Katın'**
  String get tip6Title;

  /// No description provided for @tip6Desc.
  ///
  /// In tr, this message translates to:
  /// **'Doğrudan güneş ışığından koruyun, yılda birkaç kez besleyici yağ ile silin — çizik ve solmaya karşı en etkili bakım budur.'**
  String get tip6Desc;

  /// No description provided for @tip6Category.
  ///
  /// In tr, this message translates to:
  /// **'Bakım'**
  String get tip6Category;

  /// No description provided for @tip7Title.
  ///
  /// In tr, this message translates to:
  /// **'Kumaş Koltukları Uzun Ömürlü Kılın'**
  String get tip7Title;

  /// No description provided for @tip7Desc.
  ///
  /// In tr, this message translates to:
  /// **'Haftada bir vakumlayın, lekeleri hemen nemli bezle tamponlayın — beklemek lekenin kumaşa işlemesine sebep olur.'**
  String get tip7Desc;

  /// No description provided for @tip7Category.
  ///
  /// In tr, this message translates to:
  /// **'Bakım'**
  String get tip7Category;

  /// No description provided for @tip8Title.
  ///
  /// In tr, this message translates to:
  /// **'Doğru Aydınlatmayı Seçin'**
  String get tip8Title;

  /// No description provided for @tip8Desc.
  ///
  /// In tr, this message translates to:
  /// **'Tek bir tavan lambası yerine kat kat aydınlatma kullanın: genel, görev ve atmosfer ışığı bir arada odayı daha sıcak gösterir.'**
  String get tip8Desc;

  /// No description provided for @tip8Category.
  ///
  /// In tr, this message translates to:
  /// **'Aydınlatma'**
  String get tip8Category;

  /// No description provided for @tip9Title.
  ///
  /// In tr, this message translates to:
  /// **'Küçük Alanları Akıllıca Kullanın'**
  String get tip9Title;

  /// No description provided for @tip9Desc.
  ///
  /// In tr, this message translates to:
  /// **'Katlanabilir ve çok amaçlı mobilyalar tercih edin; duvara monte raflar zemin alanını özgür bırakır.'**
  String get tip9Desc;

  /// No description provided for @tip9Category.
  ///
  /// In tr, this message translates to:
  /// **'Düzen'**
  String get tip9Category;

  /// No description provided for @tip10Title.
  ///
  /// In tr, this message translates to:
  /// **'Balkonunuzu Yaşam Alanına Dönüştürün'**
  String get tip10Title;

  /// No description provided for @tip10Desc.
  ///
  /// In tr, this message translates to:
  /// **'Hava koşullarına dayanıklı bir koltuk takımı ve birkaç saksı bitkiyle balkon, evin en sevilen köşesi haline gelir.'**
  String get tip10Desc;

  /// No description provided for @tip10Category.
  ///
  /// In tr, this message translates to:
  /// **'Dış Mekan'**
  String get tip10Category;

  /// No description provided for @popularCategoriesHeading.
  ///
  /// In tr, this message translates to:
  /// **'Popüler Kategoriler'**
  String get popularCategoriesHeading;

  /// No description provided for @popularCategoriesSub.
  ///
  /// In tr, this message translates to:
  /// **'İhtiyacına uygun mobilyayı tek tıkla bul'**
  String get popularCategoriesSub;

  /// No description provided for @categoryProductCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} ürün'**
  String categoryProductCount(int count);

  /// No description provided for @newsletterSubscribeSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Bültenimize başarıyla abone oldunuz!'**
  String get newsletterSubscribeSuccess;

  /// No description provided for @newsletterHeading.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Ürünlerden İlk Siz Haberdar Olun'**
  String get newsletterHeading;

  /// No description provided for @newsletterDesc.
  ///
  /// In tr, this message translates to:
  /// **'Spot fırsatlar, yeni koleksiyonlar ve kampanyalar e-posta kutunuza gelsin. Spam yok, sadece işinize yarayacak fırsatlar.'**
  String get newsletterDesc;

  /// No description provided for @emailHint.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresiniz'**
  String get emailHint;

  /// No description provided for @emailRequired.
  ///
  /// In tr, this message translates to:
  /// **'E-posta gerekli'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta girin'**
  String get emailInvalid;

  /// No description provided for @whyUsHeading.
  ///
  /// In tr, this message translates to:
  /// **'Neden Sağlam Spot?'**
  String get whyUsHeading;

  /// No description provided for @usp1Title.
  ///
  /// In tr, this message translates to:
  /// **'20 Yıllık Esnaf Güvencesi'**
  String get usp1Title;

  /// No description provided for @usp1Desc.
  ///
  /// In tr, this message translates to:
  /// **'İçerenköy\'de yirmi yılı aşan bir esnaflık geçmişi ve binlerce memnun müşteri.'**
  String get usp1Desc;

  /// No description provided for @usp2Title.
  ///
  /// In tr, this message translates to:
  /// **'Piyasanın Altında Fiyat'**
  String get usp2Title;

  /// No description provided for @usp2Desc.
  ///
  /// In tr, this message translates to:
  /// **'Aracısız çalışma modelimizle spot ve sıfır mobilyada en uygun fiyatlar bizde.'**
  String get usp2Desc;

  /// No description provided for @usp3Title.
  ///
  /// In tr, this message translates to:
  /// **'Kontrollü Ürün Kalitesi'**
  String get usp3Title;

  /// No description provided for @usp3Desc.
  ///
  /// In tr, this message translates to:
  /// **'Her ürün satışa çıkmadan önce yapısal ve kumaş/kaplama kontrolünden geçer.'**
  String get usp3Desc;

  /// No description provided for @usp4Title.
  ///
  /// In tr, this message translates to:
  /// **'Satış Sonrası Destek'**
  String get usp4Title;

  /// No description provided for @usp4Desc.
  ///
  /// In tr, this message translates to:
  /// **'Teslimat sonrası da ulaşabileceğin, sorununu çözen gerçek bir ekip.'**
  String get usp4Desc;

  /// No description provided for @socialShowcaseEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'PAYLAŞIN'**
  String get socialShowcaseEyebrow;

  /// No description provided for @socialShowcaseHeading.
  ///
  /// In tr, this message translates to:
  /// **'#SağlamSpot ile Kurulumunuzu Paylaşın'**
  String get socialShowcaseHeading;

  /// No description provided for @productsLoadError.
  ///
  /// In tr, this message translates to:
  /// **'Ürünler yüklenirken hata oluştu: {error}'**
  String productsLoadError(String error);

  /// No description provided for @viewAllButton.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Gör'**
  String get viewAllButton;

  /// No description provided for @showcaseEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'VİTRİN'**
  String get showcaseEyebrow;

  /// No description provided for @exploreButton.
  ///
  /// In tr, this message translates to:
  /// **'Keşfet'**
  String get exploreButton;

  /// No description provided for @visitUsEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'BİZE UĞRA'**
  String get visitUsEyebrow;

  /// No description provided for @visitUsHeading.
  ///
  /// In tr, this message translates to:
  /// **'Bir Selam Ver, Yeter'**
  String get visitUsHeading;

  /// No description provided for @visitUsOpenLine.
  ///
  /// In tr, this message translates to:
  /// **'Kapımız her zaman açık. {hours}'**
  String visitUsOpenLine(String hours);

  /// No description provided for @directionsButton.
  ///
  /// In tr, this message translates to:
  /// **'Yol Tarifi'**
  String get directionsButton;

  /// No description provided for @freeDeliveryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz Teslimat'**
  String get freeDeliveryLabel;

  /// No description provided for @busLinesLabel.
  ///
  /// In tr, this message translates to:
  /// **'Otobüs Hatları'**
  String get busLinesLabel;

  /// No description provided for @statYearsSuffix.
  ///
  /// In tr, this message translates to:
  /// **'+ Yıl'**
  String get statYearsSuffix;

  /// No description provided for @storeAddress.
  ///
  /// In tr, this message translates to:
  /// **'İçerenköy, Ataşehir/İstanbul'**
  String get storeAddress;

  /// No description provided for @stayUpdated.
  ///
  /// In tr, this message translates to:
  /// **'Güncel Kalın'**
  String get stayUpdated;

  /// No description provided for @viewButton.
  ///
  /// In tr, this message translates to:
  /// **'İncele'**
  String get viewButton;

  /// No description provided for @heroSlide2Eyebrow.
  ///
  /// In tr, this message translates to:
  /// **'İKİNCİ EL'**
  String get heroSlide2Eyebrow;

  /// No description provided for @heroSlide2Title.
  ///
  /// In tr, this message translates to:
  /// **'Öyküsü Olan Mobilyalar'**
  String get heroSlide2Title;

  /// No description provided for @heroSlide2Subtitle.
  ///
  /// In tr, this message translates to:
  /// **'Özenle seçilmiş, sağlam ve karakterli ikinci el parçalar.'**
  String get heroSlide2Subtitle;

  /// No description provided for @heroSlide3Title.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Koleksiyonu Keşfedin'**
  String get heroSlide3Title;

  /// No description provided for @aboutBadge.
  ///
  /// In tr, this message translates to:
  /// **'2012\'DEN BERİ SİZİNLE'**
  String get aboutBadge;

  /// No description provided for @aboutHeroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sağlam Spot\nBildiğiniz Güven'**
  String get aboutHeroTitle;

  /// No description provided for @aboutHeroSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'İşimizi sevgi ve titizlikle yaparak\nmahallemize hizmet veriyoruz.'**
  String get aboutHeroSubtitle;

  /// No description provided for @aboutStoryHeading.
  ///
  /// In tr, this message translates to:
  /// **'Biz Kimiz? (Hikayemiz)'**
  String get aboutStoryHeading;

  /// No description provided for @aboutStoryPara1.
  ///
  /// In tr, this message translates to:
  /// **'Amacımız, evinize sıcaklık katacak, kaliteli ve içinize sinen mobilyaları bulmanıza yardımcı olmak. Yaşam alanlarınızı güzelleştirmek bizim işimiz.'**
  String get aboutStoryPara1;

  /// No description provided for @aboutStoryPara2.
  ///
  /// In tr, this message translates to:
  /// **'Her şey 2012\'de, İçerenköy\'deki bu dükkanda başladı. O günden beri konuk olduğumuz ev sayısı daha da arttı.'**
  String get aboutStoryPara2;

  /// No description provided for @aboutStoryPara3.
  ///
  /// In tr, this message translates to:
  /// **'Bugün, hem sıfır hem de özenle seçtiğimiz ikinci el ürünlerimizle, binlerce komşumuzun evine konuk olduk. Sizin güveninizle büyüyoruz.'**
  String get aboutStoryPara3;

  /// No description provided for @aboutStoryStartLabel.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get aboutStoryStartLabel;

  /// No description provided for @aboutStoryExperienceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık Tecrübe'**
  String get aboutStoryExperienceLabel;

  /// No description provided for @aboutStorySmilesLabel.
  ///
  /// In tr, this message translates to:
  /// **'Gülen Yüz'**
  String get aboutStorySmilesLabel;

  /// No description provided for @aboutValuesHeading.
  ///
  /// In tr, this message translates to:
  /// **'İlkelerimiz'**
  String get aboutValuesHeading;

  /// No description provided for @aboutValuesSubheading.
  ///
  /// In tr, this message translates to:
  /// **'Esnaflıktan ödün vermediğimiz prensiplerimiz'**
  String get aboutValuesSubheading;

  /// No description provided for @aboutValue1Title.
  ///
  /// In tr, this message translates to:
  /// **'Kalite ve Titizlik'**
  String get aboutValue1Title;

  /// No description provided for @aboutValue1Desc.
  ///
  /// In tr, this message translates to:
  /// **'İster sıfır ister ikinci el olsun titizlikle seçer, size öyle sunarız.'**
  String get aboutValue1Desc;

  /// No description provided for @aboutValue2Title.
  ///
  /// In tr, this message translates to:
  /// **'Gülen Yüz'**
  String get aboutValue2Title;

  /// No description provided for @aboutValue2Desc.
  ///
  /// In tr, this message translates to:
  /// **'Bizim için en büyük kazanç, dükkandan mutlu ayrılan bir komşumuzdur. Memnuniyetiniz her şeyden önce gelir.'**
  String get aboutValue2Desc;

  /// No description provided for @aboutValue3Title.
  ///
  /// In tr, this message translates to:
  /// **'Emeğe Saygı'**
  String get aboutValue3Title;

  /// No description provided for @aboutValue3Desc.
  ///
  /// In tr, this message translates to:
  /// **'Mobilya kıymetli bir emektir. İkinci el ürünlere yeniden hayat vererek hem bütçenizi hem de doğayı koruruz.'**
  String get aboutValue3Desc;

  /// No description provided for @aboutValue4Title.
  ///
  /// In tr, this message translates to:
  /// **'Dürüstlük ve Güven'**
  String get aboutValue4Title;

  /// No description provided for @aboutValue4Desc.
  ///
  /// In tr, this message translates to:
  /// **'Şeffaf ve dürüst esnaflık en büyük değerimizdir. Yıllardır aynı konumumuzda sizlerle birlikteyiz.'**
  String get aboutValue4Desc;

  /// No description provided for @aboutMasterHeading.
  ///
  /// In tr, this message translates to:
  /// **'Ustamızı Tanıyın'**
  String get aboutMasterHeading;

  /// No description provided for @aboutMasterBody.
  ///
  /// In tr, this message translates to:
  /// **'Ustamız, 1995\'ten beri, yani çeyrek asırdan fazladır bu işin içinde. Sektörün tozunu yutmuş, en iyi markalarda (İstikbal) çalışarak mobilyanın \'püf noktalarını\' öğrenmiş biridir.\n\nSürücülükten montaja, müşteri karşılamadan taşımaya kadar her alanda bizzat çalışarak tam bir tecrübe kazanmıştır. 2012\'de ise \'artık kendi dükkanım\' diyerek bu tecrübesini Sağlam Spot\'a taşımıştır.\n\nAmacı, o büyük firmalarda öğrendiği kaliteyi, mahalle esnafının samimiyeti ve titizliğiyle birleştirip size en iyi hizmeti sunmaktır.'**
  String get aboutMasterBody;

  /// No description provided for @aboutDeliveryHeading.
  ///
  /// In tr, this message translates to:
  /// **'Nakliye ve Montaj Hizmetimiz'**
  String get aboutDeliveryHeading;

  /// No description provided for @aboutDeliveryFreeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz Nakliye ve Montaj'**
  String get aboutDeliveryFreeTitle;

  /// No description provided for @aboutDeliveryZonesLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz Hizmet Bölgelerimiz:'**
  String get aboutDeliveryZonesLabel;

  /// No description provided for @aboutDeliveryZonesList.
  ///
  /// In tr, this message translates to:
  /// **'• İçerenköy Mahallemiz\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• İnönü ve Bostancı Sanayi gibi yakın komşularımız'**
  String get aboutDeliveryZonesList;

  /// No description provided for @aboutDeliveryNote.
  ///
  /// In tr, this message translates to:
  /// **'Önemli Not: Ustamızın sağlığını korumak için, asansör olmayan binalarda yüksek katlara maalesef hizmet veremiyoruz. Anlayışınız için teşekkür ederiz.'**
  String get aboutDeliveryNote;

  /// No description provided for @aboutDeliveryPunctual.
  ///
  /// In tr, this message translates to:
  /// **'⏰ Sizinle sözleştiğimiz saatte kapınızdayız!'**
  String get aboutDeliveryPunctual;

  /// No description provided for @aboutTransportHeading.
  ///
  /// In tr, this message translates to:
  /// **'Dükkanımıza Nasıl Gelirsiniz?'**
  String get aboutTransportHeading;

  /// No description provided for @aboutTransportBusIntro.
  ///
  /// In tr, this message translates to:
  /// **'Otobüsle Gelirseniz:'**
  String get aboutTransportBusIntro;

  /// No description provided for @aboutBusStop1.
  ///
  /// In tr, this message translates to:
  /// **'Ziyapaşa Durağı (Kadıköy Yönü):'**
  String get aboutBusStop1;

  /// No description provided for @aboutBusStop2.
  ///
  /// In tr, this message translates to:
  /// **'İçerenköy Durağı (Kayışdağı Yönü):'**
  String get aboutBusStop2;

  /// No description provided for @aboutBusStop3.
  ///
  /// In tr, this message translates to:
  /// **'İçerenköy Durağı (Yeniyol):'**
  String get aboutBusStop3;

  /// No description provided for @aboutContactPhoneLabel.
  ///
  /// In tr, this message translates to:
  /// **'Telefon (Hızlı Çözüm)'**
  String get aboutContactPhoneLabel;

  /// No description provided for @aboutContactAddressLabel.
  ///
  /// In tr, this message translates to:
  /// **'Adres (Çaya Bekleriz)'**
  String get aboutContactAddressLabel;

  /// No description provided for @aboutContactAddressValue.
  ///
  /// In tr, this message translates to:
  /// **'İçerenköy Mahallesi\nBuket Sokak No:6'**
  String get aboutContactAddressValue;

  /// No description provided for @aboutContactHoursLabel.
  ///
  /// In tr, this message translates to:
  /// **'Çalışma Saatlerimiz'**
  String get aboutContactHoursLabel;

  /// No description provided for @aboutContactHoursValue.
  ///
  /// In tr, this message translates to:
  /// **'Pzt-Cmt: 09:00 - 22:00\nPazar: 10:00 - 20:00'**
  String get aboutContactHoursValue;

  /// No description provided for @aboutContactHeading.
  ///
  /// In tr, this message translates to:
  /// **'Bize Ulaşın'**
  String get aboutContactHeading;

  /// No description provided for @aboutCallNowButton.
  ///
  /// In tr, this message translates to:
  /// **'Hemen Ara'**
  String get aboutCallNowButton;

  /// No description provided for @aboutViewMapButton.
  ///
  /// In tr, this message translates to:
  /// **'Haritada Gör'**
  String get aboutViewMapButton;

  /// No description provided for @aboutMapHeading.
  ///
  /// In tr, this message translates to:
  /// **'Dükkanımız Tam Burada'**
  String get aboutMapHeading;

  /// No description provided for @aboutMapSubtext.
  ///
  /// In tr, this message translates to:
  /// **'Yol tarifi almak için haritaya dokunun'**
  String get aboutMapSubtext;

  /// No description provided for @newProductsBadgeEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'NEW COLLECTION'**
  String get newProductsBadgeEyebrow;

  /// No description provided for @newProductsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni\nKoleksiyon'**
  String get newProductsTitle;

  /// No description provided for @productsBadgeLabel.
  ///
  /// In tr, this message translates to:
  /// **'ÜRÜN'**
  String get productsBadgeLabel;

  /// No description provided for @breadcrumbHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get breadcrumbHome;

  /// No description provided for @statTotalProducts.
  ///
  /// In tr, this message translates to:
  /// **'TOPLAM ÜRÜN'**
  String get statTotalProducts;

  /// No description provided for @statCategoryLabel.
  ///
  /// In tr, this message translates to:
  /// **'KATEGORİ'**
  String get statCategoryLabel;

  /// No description provided for @statConditionValueNew.
  ///
  /// In tr, this message translates to:
  /// **'YENİ'**
  String get statConditionValueNew;

  /// No description provided for @statConditionLabel.
  ///
  /// In tr, this message translates to:
  /// **'DURUM'**
  String get statConditionLabel;

  /// No description provided for @statRatingLabel.
  ///
  /// In tr, this message translates to:
  /// **'PUAN'**
  String get statRatingLabel;

  /// No description provided for @searchBarRichPrefix.
  ///
  /// In tr, this message translates to:
  /// **'Detaylı ürün araması için '**
  String get searchBarRichPrefix;

  /// No description provided for @searchBarRichOr.
  ///
  /// In tr, this message translates to:
  /// **' yapın ya da '**
  String get searchBarRichOr;

  /// No description provided for @searchBarRichHereLink.
  ///
  /// In tr, this message translates to:
  /// **'BURADAKİ'**
  String get searchBarRichHereLink;

  /// No description provided for @searchBarRichSuffix.
  ///
  /// In tr, this message translates to:
  /// **' yazıya tıklayın.'**
  String get searchBarRichSuffix;

  /// No description provided for @sortNewProductsDefault.
  ///
  /// In tr, this message translates to:
  /// **'Yeniler'**
  String get sortNewProductsDefault;

  /// No description provided for @sortSpotProductsDefault.
  ///
  /// In tr, this message translates to:
  /// **'En Yeni'**
  String get sortSpotProductsDefault;

  /// No description provided for @sortPriceLowHigh.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat: Düşük-Yüksek'**
  String get sortPriceLowHigh;

  /// No description provided for @sortPriceHighLow.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat: Yüksek-Düşük'**
  String get sortPriceHighLow;

  /// No description provided for @sortMostPopular.
  ///
  /// In tr, this message translates to:
  /// **'En Popüler'**
  String get sortMostPopular;

  /// No description provided for @spotBadgeEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'SPOT ÜRÜNLER'**
  String get spotBadgeEyebrow;

  /// No description provided for @spotHeroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Fırsat\nÜrünleri'**
  String get spotHeroTitle;

  /// No description provided for @spotDiscountLabel.
  ///
  /// In tr, this message translates to:
  /// **'İNDİRİM'**
  String get spotDiscountLabel;

  /// No description provided for @statSpotProductLabel.
  ///
  /// In tr, this message translates to:
  /// **'Spot Ürün'**
  String get statSpotProductLabel;

  /// No description provided for @statDiscountLabel.
  ///
  /// In tr, this message translates to:
  /// **'İndirim'**
  String get statDiscountLabel;

  /// No description provided for @statSupportLabel.
  ///
  /// In tr, this message translates to:
  /// **'Destek'**
  String get statSupportLabel;

  /// No description provided for @statFreeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz'**
  String get statFreeLabel;

  /// No description provided for @statFreeShippingNote.
  ///
  /// In tr, this message translates to:
  /// **'Maalesef Yakın Çevrelerimize, Kargo'**
  String get statFreeShippingNote;

  /// No description provided for @statFreeShippingShort.
  ///
  /// In tr, this message translates to:
  /// **'Kargo'**
  String get statFreeShippingShort;

  /// No description provided for @filtersPanelTitle.
  ///
  /// In tr, this message translates to:
  /// **'FİLTRELER'**
  String get filtersPanelTitle;

  /// No description provided for @priceRangeSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'FİYAT ARALIĞI'**
  String get priceRangeSectionTitle;

  /// No description provided for @clearFiltersButton.
  ///
  /// In tr, this message translates to:
  /// **'FİLTRELERİ TEMİZLE'**
  String get clearFiltersButton;

  /// No description provided for @tryDifferentFiltersShort.
  ///
  /// In tr, this message translates to:
  /// **'Farklı filtreler deneyebilirsiniz'**
  String get tryDifferentFiltersShort;

  /// No description provided for @spotBadgeTag.
  ///
  /// In tr, this message translates to:
  /// **'SPOT'**
  String get spotBadgeTag;

  /// No description provided for @productLoadError.
  ///
  /// In tr, this message translates to:
  /// **'Ürün yüklenemedi: {error}'**
  String productLoadError(String error);

  /// No description provided for @productSpecConditionNew.
  ///
  /// In tr, this message translates to:
  /// **'Sıfır Ürün'**
  String get productSpecConditionNew;

  /// No description provided for @productLocationValue.
  ///
  /// In tr, this message translates to:
  /// **'İçerenköy, İstanbul'**
  String get productLocationValue;

  /// No description provided for @sortFeatured.
  ///
  /// In tr, this message translates to:
  /// **'Öne Çıkanlar'**
  String get sortFeatured;

  /// No description provided for @sortPriceAsc.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat: Artan'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat: Azalan'**
  String get sortPriceDesc;

  /// No description provided for @languageSelectorTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dil Seçimi'**
  String get languageSelectorTitle;

  /// No description provided for @languageTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get languageTooltip;

  /// No description provided for @galleryEmptyMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bu ürüne ait henüz fotoğraf eklenmemiş.'**
  String get galleryEmptyMessage;

  /// No description provided for @productCardNewBadge.
  ///
  /// In tr, this message translates to:
  /// **'SIFIR'**
  String get productCardNewBadge;

  /// No description provided for @sssHelpCenterBadge.
  ///
  /// In tr, this message translates to:
  /// **'YARDIM MERKEZİ'**
  String get sssHelpCenterBadge;

  /// No description provided for @sssHeroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sıkça Sorulan\nSorular'**
  String get sssHeroTitle;

  /// No description provided for @sssHeroSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Merak ettiğiniz her şeyin cevabı burada'**
  String get sssHeroSubtitle;

  /// No description provided for @sssCategoryAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get sssCategoryAll;

  /// No description provided for @sssCategoryGeneral.
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get sssCategoryGeneral;

  /// No description provided for @sssCategoryProductService.
  ///
  /// In tr, this message translates to:
  /// **'Ürün & Hizmet'**
  String get sssCategoryProductService;

  /// No description provided for @sssCategoryDelivery.
  ///
  /// In tr, this message translates to:
  /// **'Teslimat & Montaj'**
  String get sssCategoryDelivery;

  /// No description provided for @sssCategoryPayment.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme & Sipariş'**
  String get sssCategoryPayment;

  /// No description provided for @sssCategoryReturns.
  ///
  /// In tr, this message translates to:
  /// **'İade & Garanti'**
  String get sssCategoryReturns;

  /// No description provided for @sssCategorySecondHandBuying.
  ///
  /// In tr, this message translates to:
  /// **'İkinci El Alım Süreci'**
  String get sssCategorySecondHandBuying;

  /// No description provided for @sssPhoneSupportTitle.
  ///
  /// In tr, this message translates to:
  /// **'Telefon Desteği'**
  String get sssPhoneSupportTitle;

  /// No description provided for @sssWorkingHoursTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çalışma Saatleri'**
  String get sssWorkingHoursTitle;

  /// No description provided for @sssWorkingHoursValue.
  ///
  /// In tr, this message translates to:
  /// **'09:00 - 22:00'**
  String get sssWorkingHoursValue;

  /// No description provided for @sssStoreAddressTitle.
  ///
  /// In tr, this message translates to:
  /// **'Mağaza Adresi'**
  String get sssStoreAddressTitle;

  /// No description provided for @sssStoreAddressValue.
  ///
  /// In tr, this message translates to:
  /// **'İçerenköy Mahallesi Buket Sok. No:6'**
  String get sssStoreAddressValue;

  /// No description provided for @sssNoAnswerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sorunuz Yanıt Bulamadı mı?'**
  String get sssNoAnswerTitle;

  /// No description provided for @sssNoAnswerSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bize Ulaşabilirsiniz'**
  String get sssNoAnswerSubtitle;

  /// No description provided for @sssVisitStoreButton.
  ///
  /// In tr, this message translates to:
  /// **'Mağazaya Gel'**
  String get sssVisitStoreButton;

  /// No description provided for @sssQ1.
  ///
  /// In tr, this message translates to:
  /// **'Ustanın çalışma hayatı ve tecrübesi hakkında bilgi verebilir misiniz?'**
  String get sssQ1;

  /// No description provided for @sssA1.
  ///
  /// In tr, this message translates to:
  /// **'Ustamız, 1995 yılından beri bu sektörde aktif olarak çalışmaktadır. Kariyerine ilk adımlarını attığı günden itibaren sürekli bir gelişim göstermiştir. Çalışma hayatı boyunca, teslimatlar için sürücülük, taşıma, montaj, müşteri karşılama gibi birçok iş pozisyonunda görev alarak çok yönlü bir deneyim kazanmıştır. Özellikle 2010 yılına kadar İstikbal\'de çalışmış ve bu süreçte ürünlerin özellikleri, parçaları ve püf noktaları hakkında derinlemesine bilgi sahibi olmuştur. 2010\'dan sonra, yakın civardaki Işık Çeyiz\'de çalışarak sektördeki yetkinliğini artırmıştır. 2012 yılında ise kendi esnaf dükkanını açma kararı almış ve bu süreçte kaliteli hizmet anlayışını ön planda tutarak, sektördeki deneyimlerini müşterilerine en iyi şekilde aktarmayı hedeflemiştir.'**
  String get sssA1;

  /// No description provided for @sssQ2.
  ///
  /// In tr, this message translates to:
  /// **'Sağlam Spot güvenilir mi?'**
  String get sssQ2;

  /// No description provided for @sssA2.
  ///
  /// In tr, this message translates to:
  /// **'2012 yılından beri İçerenköy\'de, komşularımıza hizmet veriyoruz. Sayısızca evlere konuk olduk ve hâlâ konuk olmaya devam ediyoruz.'**
  String get sssA2;

  /// No description provided for @sssQ3.
  ///
  /// In tr, this message translates to:
  /// **'Ürünleri incelemek için mağazanıza gelebilir miyim?'**
  String get sssQ3;

  /// No description provided for @sssA3.
  ///
  /// In tr, this message translates to:
  /// **'Elbette! Hatta biz de özellikle bunu tavsiye ediyoruz. Çayımızı içerken ürünleri canlı canlı görmeniz, dokunmanız ve içinize sinmesi en sağlıklısı. İçerenköy Mahallesi\'ndeki dükkanımıza her zaman bekleriz.'**
  String get sssA3;

  /// No description provided for @sssQ4.
  ///
  /// In tr, this message translates to:
  /// **'İkinci el ürünlerin durumu nasıl kontrol ediliyor?'**
  String get sssQ4;

  /// No description provided for @sssA4.
  ///
  /// In tr, this message translates to:
  /// **'Bizim için ikinci el, \'ikinci kalite\' demek değildir. Her ürün ustamızın titiz kontrolünden geçer; temizliği, bakımı ve gerekli onarımları eksiksiz yapılır. Fotoğraflarda ne görüyorsanız o, ama biz yine de \'gelin, bir de siz görün\' deriz. Gözünüzle görmeniz her zaman en iyisidir.'**
  String get sssA4;

  /// No description provided for @sssQ5.
  ///
  /// In tr, this message translates to:
  /// **'Mobilyaların malzeme kalitesi nedir?'**
  String get sssQ5;

  /// No description provided for @sssA5.
  ///
  /// In tr, this message translates to:
  /// **'Şeffaflığı önemsiyoruz. Her ürünün kendine ait bir hikayesi ve malzemesi var. Bu yüzden tüm detayları, malzeme kalitesini ve özelliklerini ürün açıklama bölümlerine net bir şekilde yazıyoruz. Aklınıza takılan bir şey olursa sormaktan çekinmeyin.'**
  String get sssA5;

  /// No description provided for @sssQ6.
  ///
  /// In tr, this message translates to:
  /// **'Ürün fiyatları nasıl belirleniyor?'**
  String get sssQ6;

  /// No description provided for @sssA6.
  ///
  /// In tr, this message translates to:
  /// **'Fiyatlarımızı belirlerken hem ürünün kalitesine hem de piyasa koşullarına adil bir şekilde bakıyoruz. Amacımız, bütçenizi zorlamadan, kaliteli ve uzun ömürlü ürünlere ulaşmanızı sağlamaktır. Hakkı neyse, o.'**
  String get sssA6;

  /// No description provided for @sssQ7.
  ///
  /// In tr, this message translates to:
  /// **'Ürünlerinizde renk seçenekleri var mı?'**
  String get sssQ7;

  /// No description provided for @sssA7.
  ///
  /// In tr, this message translates to:
  /// **'Ürünlerimiz genellikle anlık ve tek parçalar olduğu için, mevcut renkleri neyse o şekilde sunuyoruz. Maalesef farklı renk seçenekleri yapamıyoruz. Beğendiğiniz ürünün rengi, gördüğünüz renktir.'**
  String get sssA7;

  /// No description provided for @sssQ8.
  ///
  /// In tr, this message translates to:
  /// **'Özel sipariş alıyor musunuz?'**
  String get sssQ8;

  /// No description provided for @sssA8.
  ///
  /// In tr, this message translates to:
  /// **'Keşke yapabilsek! Ancak biz daha çok mevcut, özenle seçilmiş ürünlerimize odaklanıyoruz. Özel üretim veya tasarım siparişi şu an için maalesef alamıyoruz. Hazırdaki ürünlerimizi incelemenizi öneririz.'**
  String get sssA8;

  /// No description provided for @sssQ9.
  ///
  /// In tr, this message translates to:
  /// **'Ürün açıklamalarında nelere dikkat etmeliyim?'**
  String get sssQ9;

  /// No description provided for @sssA9.
  ///
  /// In tr, this message translates to:
  /// **'En önemli tavsiyemiz: Mezura! Lütfen ürün açıklamasındaki ölçüleri, evinize koyacağınız yerle dikkatlice karşılaştırın. \'Acaba sığar mı?\' sorusunu en başta çözmek, sonradan yaşanacak sıkıntıları önler. Ayrıca ölçü Alırken Koridoru Unutmayın: Sadece mobilyayı koyacağınız yeri değil, o mobilyanın kapıdan, koridordan ve merdivenden nasıl geçeceğini de ölçün. Malzeme ve durum bilgilerini de mutlaka okuyun.'**
  String get sssA9;

  /// No description provided for @sssQ10.
  ///
  /// In tr, this message translates to:
  /// **'Asansör olmayan binalara veya yüksek katlara teslimat yapıyor musunuz?'**
  String get sssQ10;

  /// No description provided for @sssA10.
  ///
  /// In tr, this message translates to:
  /// **'Bu, bizim için en hassas ve önemli konulardan biri. Biz, işini bizzat yapan küçük bir esnafız. Ustamız, yılların tecrübesiyle birlikte artık genç olmadığı için sağlığını da düşünmek zorundayız. Anlayışınıza sığınarak, asansör olmayan binalarda yüksek katlara (örneğin 2. kat ve üzeri) eşya çıkarma ve indirme hizmeti kesinlikle veremiyoruz. Lütfen siparişinizi vermeden önce bu konuyu netleştirelim, size mahcup olmak istemeyiz.'**
  String get sssA10;

  /// No description provided for @sssQ11.
  ///
  /// In tr, this message translates to:
  /// **'Taşıma hizmeti sağlıyor musunuz?'**
  String get sssQ11;

  /// No description provided for @sssA11.
  ///
  /// In tr, this message translates to:
  /// **'Elbette, komşularımıza yardımcı oluyoruz. İçerenköy başta olmak üzere Fındıklı, Kayışdağı, Küçükbakkalköy, İnönü ve Bostancı Sanayi gibi yakın çevremize ücretsiz nakliye hizmetimiz var. (Bostancı ve Kozyatağı\'nın bazı bölgeleri hariç, ve yaşlılık açısından yüksek katlara asansörsüz taşıyamıyoruz, onu ayrıca konuşuruz).'**
  String get sssA11;

  /// No description provided for @sssQ12.
  ///
  /// In tr, this message translates to:
  /// **'Teslimat süresi ne kadar?'**
  String get sssQ12;

  /// No description provided for @sssA12.
  ///
  /// In tr, this message translates to:
  /// **'Siparişi verdiğiniz an sizinle iletişime geçeriz. \'Ne zaman müsaitsiniz?\' diye sorarız. Hem size hem bize uyan en yakın vakit için sözleşiriz. Genellikle 1-3 gün içinde, anlaştığımız saatte teslimatı ve montajı tamamlamış oluruz.'**
  String get sssA12;

  /// No description provided for @sssQ13.
  ///
  /// In tr, this message translates to:
  /// **'Montaj hizmeti veriyor musunuz?'**
  String get sssQ13;

  /// No description provided for @sssA13.
  ///
  /// In tr, this message translates to:
  /// **'Tabii ki. Mobilyayı alıp kapıya bırakmak bizim tarzımız değil. Büyük ürünlerin hepsini ustamız bizzat kurar ve bu hizmet için ekstra bir ücret talep etmeyiz. Siz sadece yerini gösterin, gerisi bizde.'**
  String get sssA13;

  /// No description provided for @sssQ14.
  ///
  /// In tr, this message translates to:
  /// **'Mobilya siparişi ne kadar sürede teslim edilir?'**
  String get sssQ14;

  /// No description provided for @sssA14.
  ///
  /// In tr, this message translates to:
  /// **'Ürün hazırsa, sizinle ortak belirlediğimiz bir zamanda en kısa sürede kapınızdayız. Montajı da dert etmeyin; getirdiğimiz gibi kurar, öyle teslim ederiz. Genellikle aynı gün içinde her şey biter.'**
  String get sssA14;

  /// No description provided for @sssQ15.
  ///
  /// In tr, this message translates to:
  /// **'Veresiye sipariş verebilir miyim?'**
  String get sssQ15;

  /// No description provided for @sssA15.
  ///
  /// In tr, this message translates to:
  /// **'Bu konuda anlayışınızı rica ediyoruz. Bir esnaf olarak ayakta kalabilmemiz için \'veresiye\' veya \'sonra ödeme\' gibi yöntemlerle maalesef çalışamıyoruz. Anlaştığımız ücreti, ürünü teslim ederken peşin olarak almamız gerekiyor. Size mahcup olmamak için bu kuralımızı baştan belirtmeyi tercih ediyoruz.'**
  String get sssA15;

  /// No description provided for @sssQ16.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl sipariş verebilirim?'**
  String get sssQ16;

  /// No description provided for @sssA16.
  ///
  /// In tr, this message translates to:
  /// **'En sağlıklı yöntem, her zaman yüz yüze olandır. Siteden beğendiğiniz ürünü not edin, sonra dükkanımıza gelin. Ürünü canlı görün, aklınızdaki soruları sorun, içinize sinerse siparişinizi orada tamamlayalım. Böylece hiçbir şüphe kalmaz.'**
  String get sssA16;

  /// No description provided for @sssQ17.
  ///
  /// In tr, this message translates to:
  /// **'Ürün iade politikası nedir?'**
  String get sssQ17;

  /// No description provided for @sssA17.
  ///
  /// In tr, this message translates to:
  /// **'İkinci el ürünlerin doğası gereği ve esnaf usulü çalıştığımız için maalesef iade kabul edemiyoruz. Bu yüzden \'gelin, görün, çayımızı için\' diye ısrar ediyoruz. Almadan önce ürünü detaylıca incelemeniz, ölçüp biçmeniz en doğrusu. Emin olmadan alışverişi tamamlamayalım.'**
  String get sssA17;

  /// No description provided for @sssQ18.
  ///
  /// In tr, this message translates to:
  /// **'Ürünlerin garanti süresi var mı?'**
  String get sssQ18;

  /// No description provided for @sssA18.
  ///
  /// In tr, this message translates to:
  /// **'Ürünlerimiz ikinci el olduğu için, bir markanın sunduğu gibi resmi bir garanti süremiz maalesef yok. Ancak biz \'sattık, bitti\' diyenlerden değiliz. Teslimat ve montaj sırasında her şeyin düzgün çalıştığından emin oluruz.'**
  String get sssA18;

  /// No description provided for @sssQ19.
  ///
  /// In tr, this message translates to:
  /// **'Evimdeki eşyaları satmak istiyorum, ikinci el alımı yapıyor musunuz?'**
  String get sssQ19;

  /// No description provided for @sssA19.
  ///
  /// In tr, this message translates to:
  /// **'Evet, dükkanımızda sergileyebileceğimize inandığımız, temiz ve yeniden satılabilir durumdaki seçili ürünleri alıyoruz. Ancak, dükkanımızın yeri gerçekten çok küçük olduğu için bu konuda maalesef çok seçici davranmak zorundayız.\n\nBu konuda baştan dürüst olmayı severiz: Bizden alacağınız teklif, muhtemelen Letgo gibi platformlarda kendinizin satabileceğiniz rakamdan biraz daha düşük olabilir. Bunun sebebi şudur: Biz esnaf olarak o eşyayı almak için benzin yakıyor, taşıma için emek harcıyor ve en önemlisi, onu satmak için dükkanımızda sergileyip tüm müşteri süreciyle (pazarlık, sorular vs.) biz ilgileniyoruz.\n\nSiz o platformlarda satarken bu süreçlerin tamamını kendiniz üstlenirsiniz. Biz ise sizden bu zahmeti de devralmış oluyoruz. Teklifimizi bu hizmeti de içerecek şekilde veriyoruz. Anlayışınız için teşekkür ederiz.'**
  String get sssA19;

  /// No description provided for @sssQ20.
  ///
  /// In tr, this message translates to:
  /// **'Komple takım mobilyaları (Yatak odası, salon takımı vb.) alıyor musunuz?'**
  String get sssQ20;

  /// No description provided for @sssA20.
  ///
  /// In tr, this message translates to:
  /// **'Dükkanımızın küçük olmasından dolayı, maalesef komple yatak odası, koltuk takımı gibi büyük setleri alamıyoruz. Yerimiz çok kısıtlı. Biz daha çok tek parça, satışı daha kolay olan (konsol, dolap, masa, sandalye gibi) ürünlere odaklanıyoruz.'**
  String get sssA20;

  /// No description provided for @sssQ21.
  ///
  /// In tr, this message translates to:
  /// **'Eşyalarım yüksek katta ve binada asansör yok. Alım yapar mısınız?'**
  String get sssQ21;

  /// No description provided for @sssA21.
  ///
  /// In tr, this message translates to:
  /// **'Tıpkı teslimat konusunda olduğu gibi, bu bizim için en net kuralımız. Ustamızın sağlık durumu nedeniyle, asansör olmayan binalarda yüksek katlardan eşya indirme işlemi kesinlikle yapamıyoruz. Eşyalarınız zemin/giriş kata yakın ise veya binada yük asansörü varsa ancak o zaman değerlendirebiliriz.'**
  String get sssA21;

  /// No description provided for @sssQ22.
  ///
  /// In tr, this message translates to:
  /// **'Her zaman eşya alımı yapıyor musunuz?'**
  String get sssQ22;

  /// No description provided for @sssA22.
  ///
  /// In tr, this message translates to:
  /// **'Bu tamamen dükkanımızdaki boşluğa bağlı. Dükkanımız küçük olduğu için, \'sat-al\' dengesiyle çalışıyoruz. Bazen bir ürünü çok beğensek de yerimiz olmadığı için alamayabiliyoruz. En sağlıklısı, bize satmak istediğiniz ürünün fotoğraflarını göndermenizdir. Size dürüstçe \'şu an yerimiz var\' veya \'maalesef bu ara doluyuz\' diye bilgi veririz.'**
  String get sssA22;

  /// No description provided for @navDiscover.
  ///
  /// In tr, this message translates to:
  /// **'Keşfet'**
  String get navDiscover;

  /// No description provided for @navCart.
  ///
  /// In tr, this message translates to:
  /// **'Sepet'**
  String get navCart;

  /// No description provided for @navProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @storeHeroEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'YENİ KOLEKSİYON'**
  String get storeHeroEyebrow;

  /// No description provided for @storeHeroTitle.
  ///
  /// In tr, this message translates to:
  /// **'Evinize Yakışan\nMobilyaları Keşfedin'**
  String get storeHeroTitle;

  /// No description provided for @storeHeroSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaliteli sıfır ve ikinci el mobilyalar, cebinize uygun fiyatlarla kapınızda.'**
  String get storeHeroSubtitle;

  /// No description provided for @storeHeroCta.
  ///
  /// In tr, this message translates to:
  /// **'Alışverişe Başla'**
  String get storeHeroCta;

  /// No description provided for @sectionCategories.
  ///
  /// In tr, this message translates to:
  /// **'Kategoriler'**
  String get sectionCategories;

  /// No description provided for @sectionBestSellers.
  ///
  /// In tr, this message translates to:
  /// **'Çok Satanlar'**
  String get sectionBestSellers;

  /// No description provided for @sectionNewArrivals.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Gelenler'**
  String get sectionNewArrivals;

  /// No description provided for @seeAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Gör'**
  String get seeAll;

  /// No description provided for @cartTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sepetim'**
  String get cartTitle;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sepetiniz Boş'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Beğendiğiniz ürünleri sepete ekleyin, sonra tek mesajla bize sorun.'**
  String get cartEmptyDesc;

  /// No description provided for @cartTotalLabel.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get cartTotalLabel;

  /// No description provided for @cartWhatsappCta.
  ///
  /// In tr, this message translates to:
  /// **'Sepeti WhatsApp\'tan Gönder'**
  String get cartWhatsappCta;

  /// No description provided for @cartItemRemoved.
  ///
  /// In tr, this message translates to:
  /// **'Sepetten kaldırıldı'**
  String get cartItemRemoved;

  /// No description provided for @addToCartCta.
  ///
  /// In tr, this message translates to:
  /// **'Sepete Ekle'**
  String get addToCartCta;

  /// No description provided for @addedToCartMessage.
  ///
  /// In tr, this message translates to:
  /// **'Sepete eklendi'**
  String get addedToCartMessage;

  /// No description provided for @alreadyInCartMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bu ürün zaten sepette'**
  String get alreadyInCartMessage;

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsAccountSection.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get settingsAccountSection;

  /// No description provided for @settingsGeneralSection.
  ///
  /// In tr, this message translates to:
  /// **'Genel'**
  String get settingsGeneralSection;

  /// No description provided for @settingsContact.
  ///
  /// In tr, this message translates to:
  /// **'İletişim'**
  String get settingsContact;

  /// No description provided for @settingsCallUs.
  ///
  /// In tr, this message translates to:
  /// **'Bizi Arayın'**
  String get settingsCallUs;

  /// No description provided for @settingsAdminLogin.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici Girişi'**
  String get settingsAdminLogin;

  /// No description provided for @settingsAppVersion.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama Sürümü'**
  String get settingsAppVersion;

  /// No description provided for @cartItemsCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Sepet boş} =1{1 ürün} other{{count} ürün}}'**
  String cartItemsCount(int count);

  /// No description provided for @settingsRateApp.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamayı Değerlendir'**
  String get settingsRateApp;

  /// No description provided for @settingsShareApp.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamayı Paylaş'**
  String get settingsShareApp;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTerms.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşulları'**
  String get settingsTerms;

  /// No description provided for @legalContentTurkishOnly.
  ///
  /// In tr, this message translates to:
  /// **'Bu içerik şu anda yalnızca Türkçe olarak sunulmaktadır.'**
  String get legalContentTurkishOnly;

  /// No description provided for @doubleBackToExit.
  ///
  /// In tr, this message translates to:
  /// **'Çıkmak için tekrar geri tuşuna basın'**
  String get doubleBackToExit;

  /// No description provided for @productLinkLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ürün linki'**
  String get productLinkLabel;

  /// No description provided for @settingsAppSection.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama'**
  String get settingsAppSection;

  /// No description provided for @settingsLegalSection.
  ///
  /// In tr, this message translates to:
  /// **'Yasal'**
  String get settingsLegalSection;

  /// No description provided for @recentlyViewedTitle.
  ///
  /// In tr, this message translates to:
  /// **'Son Görüntülenenler'**
  String get recentlyViewedTitle;

  /// No description provided for @productTrustBadgeVerified.
  ///
  /// In tr, this message translates to:
  /// **'Satıcı Onaylı'**
  String get productTrustBadgeVerified;

  /// No description provided for @productTrustBadgeNegotiate.
  ///
  /// In tr, this message translates to:
  /// **'WhatsApp\'tan Pazarlık'**
  String get productTrustBadgeNegotiate;

  /// No description provided for @productTrustBadgeDelivery.
  ///
  /// In tr, this message translates to:
  /// **'Yerinde Teslim'**
  String get productTrustBadgeDelivery;

  /// No description provided for @howToBuyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl Satın Alırım?'**
  String get howToBuyTitle;

  /// No description provided for @howToBuyStep1Title.
  ///
  /// In tr, this message translates to:
  /// **'WhatsApp\'tan Yaz'**
  String get howToBuyStep1Title;

  /// No description provided for @howToBuyStep1Desc.
  ///
  /// In tr, this message translates to:
  /// **'Ürünü beğendiyseniz WhatsApp üzerinden bize ulaşın.'**
  String get howToBuyStep1Desc;

  /// No description provided for @howToBuyStep2Title.
  ///
  /// In tr, this message translates to:
  /// **'Fiyatı Konuş'**
  String get howToBuyStep2Title;

  /// No description provided for @howToBuyStep2Desc.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat ve teslimat detaylarını birlikte görüşelim.'**
  String get howToBuyStep2Desc;

  /// No description provided for @howToBuyStep3Title.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Alın'**
  String get howToBuyStep3Title;

  /// No description provided for @howToBuyStep3Desc.
  ///
  /// In tr, this message translates to:
  /// **'Anlaştıktan sonra ürününüzü güvenle teslim alın.'**
  String get howToBuyStep3Desc;

  /// No description provided for @listedToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün eklendi'**
  String get listedToday;

  /// No description provided for @listedDaysAgo.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün önce eklendi'**
  String listedDaysAgo(int days);

  /// No description provided for @listedWeeksAgo.
  ///
  /// In tr, this message translates to:
  /// **'{weeks} hafta önce eklendi'**
  String listedWeeksAgo(int weeks);

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsThemeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get settingsThemeDark;

  /// No description provided for @notificationsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bildirim yok'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyDesc.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kampanya ve duyurular burada görünecek'**
  String get notificationsEmptyDesc;

  /// No description provided for @markAllReadAction.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü okundu işaretle'**
  String get markAllReadAction;

  /// No description provided for @clearAllAction.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü temizle'**
  String get clearAllAction;

  /// No description provided for @timeJustNow.
  ///
  /// In tr, this message translates to:
  /// **'Az önce'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In tr, this message translates to:
  /// **'{minutes} dakika önce'**
  String timeMinutesAgo(int minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In tr, this message translates to:
  /// **'{hours} saat önce'**
  String timeHoursAgo(int hours);

  /// No description provided for @timeDaysAgoGeneric.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün önce'**
  String timeDaysAgoGeneric(int days);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'el',
        'en',
        'it',
        'ky',
        'ru',
        'tr',
        'uk',
        'uz',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'uz':
      return AppLocalizationsUz();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

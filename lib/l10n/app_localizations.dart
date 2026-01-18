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
  /// **'Ürün, kategori arayın...'**
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

  /// No description provided for @ourStoryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Biz Kimiz? (Hikayemiz)'**
  String get ourStoryTitle;

  /// No description provided for @ourStoryDesc1.
  ///
  /// In tr, this message translates to:
  /// **'Amacımız, evinize sıcaklık katacak, kaliteli ve içinize sinen mobilyaları bulmanıza yardımcı olmak. Yaşam alanlarınızı güzelleştirmek bizim işimiz.'**
  String get ourStoryDesc1;

  /// No description provided for @ourStoryDesc2.
  ///
  /// In tr, this message translates to:
  /// **'Her şey 2012\'de, İçerenköy\'deki bu dükkanda başladı. O günden beri konuk olduğumuz ev sayısı daha da arttı.'**
  String get ourStoryDesc2;

  /// No description provided for @ourStoryDesc3.
  ///
  /// In tr, this message translates to:
  /// **'Bugün, hem sıfır hem de özenle seçtiğimiz ikinci el ürünlerimizle, binlerce komşumuzun evine konuk olduk. Sizin güveninizle büyüyoruz.'**
  String get ourStoryDesc3;

  /// No description provided for @storyHighlightStart.
  ///
  /// In tr, this message translates to:
  /// **'Başlangıç'**
  String get storyHighlightStart;

  /// No description provided for @storyHighlightExperience.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık Tecrübe'**
  String get storyHighlightExperience;

  /// No description provided for @storyHighlightSmiles.
  ///
  /// In tr, this message translates to:
  /// **'Gülen Yüz'**
  String get storyHighlightSmiles;

  /// No description provided for @ourPrinciples.
  ///
  /// In tr, this message translates to:
  /// **'İlkelerimiz'**
  String get ourPrinciples;

  /// No description provided for @principlesSub.
  ///
  /// In tr, this message translates to:
  /// **'Esnaflıktan ödün vermediğimiz prensiplerimiz'**
  String get principlesSub;

  /// No description provided for @valueQualityTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kalite ve Titizlik'**
  String get valueQualityTitle;

  /// No description provided for @valueQualityDesc.
  ///
  /// In tr, this message translates to:
  /// **'İster sıfır ister ikinci el olsun titizlikle seçer, size öyle sunarız.'**
  String get valueQualityDesc;

  /// No description provided for @valueSmileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gülen Yüz'**
  String get valueSmileTitle;

  /// No description provided for @valueSmileDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bizim için en büyük kazanç, dükkandan mutlu ayrılan bir komşumuzdur.'**
  String get valueSmileDesc;

  /// No description provided for @valueLaborTitle.
  ///
  /// In tr, this message translates to:
  /// **'Emeğe Saygı'**
  String get valueLaborTitle;

  /// No description provided for @valueLaborDesc.
  ///
  /// In tr, this message translates to:
  /// **'İkinci el ürünlere yeniden hayat vererek hem bütçenizi hem de doğayı koruruz.'**
  String get valueLaborDesc;

  /// No description provided for @valueTrustTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dürüstlük ve Güven'**
  String get valueTrustTitle;

  /// No description provided for @valueTrustDesc.
  ///
  /// In tr, this message translates to:
  /// **'Şeffaf ve dürüst esnaflık en büyük değerimizdir. Yıllardır aynı konumdayız.'**
  String get valueTrustDesc;

  /// No description provided for @masterHistoryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ustamızı Tanıyın'**
  String get masterHistoryTitle;

  /// No description provided for @masterHistoryDesc.
  ///
  /// In tr, this message translates to:
  /// **'Ustamız, 1995\'ten beri bu işin içinde. Sektörün tozunu yutmuş, İstikbal gibi markalarda mobilyanın püf noktalarını öğrenmiştir. Sürücülükten montaja her alanda kazanılan tecrübeyi 2012\'de Sağlam Spot\'a taşımıştır. Amacı, kurumsal kaliteyi esnaf samimiyetiyle birleştirmektir.'**
  String get masterHistoryDesc;

  /// No description provided for @deliveryServiceTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nakliye ve Montaj Hizmetimiz'**
  String get deliveryServiceTitle;

  /// No description provided for @freeShipping.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz Nakliye ve Montaj'**
  String get freeShipping;

  /// No description provided for @deliveryServiceSub.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz Hizmet Bölgelerimiz:'**
  String get deliveryServiceSub;

  /// No description provided for @deliveryRegions.
  ///
  /// In tr, this message translates to:
  /// **'• İçerenköy Mahallemiz\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• İnönü ve Bostancı Sanayi'**
  String get deliveryRegions;

  /// No description provided for @deliveryWarning.
  ///
  /// In tr, this message translates to:
  /// **'Önemli Not: Ustamızın sağlığını korumak için, asansör olmayan binalarda yüksek katlara hizmet veremiyoruz.'**
  String get deliveryWarning;

  /// No description provided for @deliveryOnTime.
  ///
  /// In tr, this message translates to:
  /// **'⏰ Sizinle sözleştiğimiz saatte kapınızdayız!'**
  String get deliveryOnTime;

  /// No description provided for @transportationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dükkanımıza Nasıl Gelirsiniz?'**
  String get transportationTitle;

  /// No description provided for @busArrival.
  ///
  /// In tr, this message translates to:
  /// **'Otobüsle Gelirseniz:'**
  String get busArrival;

  /// No description provided for @busStopZiyapasa.
  ///
  /// In tr, this message translates to:
  /// **'Ziyapaşa Durağı (Kadıköy Yönü):'**
  String get busStopZiyapasa;

  /// No description provided for @busStopIcerenkoyKayisdagi.
  ///
  /// In tr, this message translates to:
  /// **'İçerenköy Durağı (Kayışdağı Yönü):'**
  String get busStopIcerenkoyKayisdagi;

  /// No description provided for @busStopIcerenkoyYeniyol.
  ///
  /// In tr, this message translates to:
  /// **'İçerenköy Durağı (Yeniyol):'**
  String get busStopIcerenkoyYeniyol;

  /// No description provided for @callNow.
  ///
  /// In tr, this message translates to:
  /// **'Hemen Ara'**
  String get callNow;

  /// No description provided for @seeOnMap.
  ///
  /// In tr, this message translates to:
  /// **'Haritada Gör'**
  String get seeOnMap;

  /// No description provided for @phoneQuickSolution.
  ///
  /// In tr, this message translates to:
  /// **'Telefon (Hızlı Çözüm)'**
  String get phoneQuickSolution;

  /// No description provided for @addressTeaInvitation.
  ///
  /// In tr, this message translates to:
  /// **'Adres (Çaya Bekleriz)'**
  String get addressTeaInvitation;

  /// No description provided for @workingHours.
  ///
  /// In tr, this message translates to:
  /// **'Çalışma Saatlerimiz'**
  String get workingHours;

  /// No description provided for @workingDays.
  ///
  /// In tr, this message translates to:
  /// **'Pzt-Cmt: 09:00 - 22:00\nPazar: 10:00 - 20:00'**
  String get workingDays;

  /// No description provided for @shopLocationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dükkanımız Tam Burada'**
  String get shopLocationTitle;

  /// No description provided for @getDirectionsDesc.
  ///
  /// In tr, this message translates to:
  /// **'Yol tarifi almak için haritaya dokunun'**
  String get getDirectionsDesc;

  /// No description provided for @similarProducts.
  ///
  /// In tr, this message translates to:
  /// **'BENZER ÜRÜNLER'**
  String get similarProducts;

  /// No description provided for @customerReviews.
  ///
  /// In tr, this message translates to:
  /// **'MÜŞTERİ GÖRÜŞLERİ'**
  String get customerReviews;

  /// No description provided for @viewAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Gör'**
  String get viewAll;

  /// No description provided for @features.
  ///
  /// In tr, this message translates to:
  /// **'ÖZELLİKLER'**
  String get features;

  /// No description provided for @description.
  ///
  /// In tr, this message translates to:
  /// **'AÇIKLAMA'**
  String get description;

  /// No description provided for @detailsTab.
  ///
  /// In tr, this message translates to:
  /// **'DETAYLAR'**
  String get detailsTab;

  /// No description provided for @shippingTab.
  ///
  /// In tr, this message translates to:
  /// **'TESLİMAT'**
  String get shippingTab;

  /// No description provided for @reviewsTab.
  ///
  /// In tr, this message translates to:
  /// **'DEĞERLENDİRMELER'**
  String get reviewsTab;

  /// No description provided for @readMore.
  ///
  /// In tr, this message translates to:
  /// **'DEVAMINI OKU'**
  String get readMore;

  /// No description provided for @showLess.
  ///
  /// In tr, this message translates to:
  /// **'DAHA AZ GÖSTER'**
  String get showLess;

  /// No description provided for @buyNow.
  ///
  /// In tr, this message translates to:
  /// **'ŞİMDİ SATIN AL'**
  String get buyNow;

  /// No description provided for @addToCart.
  ///
  /// In tr, this message translates to:
  /// **'SEPETE EKLE'**
  String get addToCart;

  /// No description provided for @sendMessage.
  ///
  /// In tr, this message translates to:
  /// **'MESAJ GÖNDER'**
  String get sendMessage;

  /// No description provided for @guaranteeNone.
  ///
  /// In tr, this message translates to:
  /// **'Garantimiz Yoktur'**
  String get guaranteeNone;

  /// No description provided for @assemblyFree.
  ///
  /// In tr, this message translates to:
  /// **'Ücretsiz Montaj'**
  String get assemblyFree;

  /// No description provided for @returnNone.
  ///
  /// In tr, this message translates to:
  /// **'İade Yoktur'**
  String get returnNone;

  /// No description provided for @supportFull.
  ///
  /// In tr, this message translates to:
  /// **'16/6 Destek'**
  String get supportFull;

  /// No description provided for @confirmedSeller.
  ///
  /// In tr, this message translates to:
  /// **'Onaylı Satıcı'**
  String get confirmedSeller;

  /// No description provided for @productName.
  ///
  /// In tr, this message translates to:
  /// **'Ürün Adı'**
  String get productName;

  /// No description provided for @price.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat'**
  String get price;

  /// No description provided for @addProduct.
  ///
  /// In tr, this message translates to:
  /// **'Ürün Ekle'**
  String get addProduct;

  /// No description provided for @editProduct.
  ///
  /// In tr, this message translates to:
  /// **'Ürünü Düzenle'**
  String get editProduct;

  /// No description provided for @saveChanges.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikleri Kaydet'**
  String get saveChanges;

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

  /// No description provided for @statusAndCategory.
  ///
  /// In tr, this message translates to:
  /// **'Durum ve Kategori'**
  String get statusAndCategory;

  /// No description provided for @isSold.
  ///
  /// In tr, this message translates to:
  /// **'Ürün Satıldı'**
  String get isSold;

  /// No description provided for @isSpot.
  ///
  /// In tr, this message translates to:
  /// **'Spot / İkinci El'**
  String get isSpot;

  /// No description provided for @deleteProduct.
  ///
  /// In tr, this message translates to:
  /// **'Ürünü Sil'**
  String get deleteProduct;

  /// No description provided for @deleteConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Bu ürün silinecek. Emin misiniz?'**
  String get deleteConfirm;

  /// No description provided for @yesDelete.
  ///
  /// In tr, this message translates to:
  /// **'Evet, Sil'**
  String get yesDelete;

  /// No description provided for @productNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Ürün bulunamadı'**
  String get productNotFound;

  /// No description provided for @errorOccurred.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu'**
  String get errorOccurred;

  /// No description provided for @noImages.
  ///
  /// In tr, this message translates to:
  /// **'Görsel Yok'**
  String get noImages;

  /// No description provided for @furnitureTipsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Uzmanından Püf Noktaları'**
  String get furnitureTipsTitle;

  /// No description provided for @tipBalanceTitle.
  ///
  /// In tr, this message translates to:
  /// **'Terazi Kontrolü Yapın'**
  String get tipBalanceTitle;

  /// No description provided for @tipBalanceDesc.
  ///
  /// In tr, this message translates to:
  /// **'Mobilyanızın ayaklarının zemine tam bastığından emin olun. Eğimli zeminlerde keçe kullanın.'**
  String get tipBalanceDesc;

  /// No description provided for @tipWallGapTitle.
  ///
  /// In tr, this message translates to:
  /// **'Duvarla Mesafe Bırakın'**
  String get tipWallGapTitle;

  /// No description provided for @tipWallGapDesc.
  ///
  /// In tr, this message translates to:
  /// **'Hava sirkülasyonu için 1-2 cm boşluk bırakın. Rutubeti engeller.'**
  String get tipWallGapDesc;

  /// No description provided for @tipHeatTitle.
  ///
  /// In tr, this message translates to:
  /// **'Isıdan Uzak Tutun'**
  String get tipHeatTitle;

  /// No description provided for @tipHeatDesc.
  ///
  /// In tr, this message translates to:
  /// **'Soba ve kaloriferden 30 cm uzak tutun. Ahşap çatlamasını önler.'**
  String get tipHeatDesc;

  /// No description provided for @tipSunTitle.
  ///
  /// In tr, this message translates to:
  /// **'Güneşten Koruyun'**
  String get tipSunTitle;

  /// No description provided for @tipSunDesc.
  ///
  /// In tr, this message translates to:
  /// **'Direkt güneş ışığı renk soldurur. Perdelerle filtreleyin.'**
  String get tipSunDesc;

  /// No description provided for @tipCleaningTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nemli Temizlik'**
  String get tipCleaningTitle;

  /// No description provided for @sessionClosed.
  ///
  /// In tr, this message translates to:
  /// **'Oturum kapalı'**
  String get sessionClosed;

  /// No description provided for @authDeniedAdminOnly.
  ///
  /// In tr, this message translates to:
  /// **'Yetki Reddedildi: Bu e-posta yönetici listesinde bulunamadı.'**
  String get authDeniedAdminOnly;

  /// No description provided for @fillRequiredFields.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen ürün adı, fiyat ve en az bir görsel ekleyin!'**
  String get fillRequiredFields;

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

  /// No description provided for @accountDisabled.
  ///
  /// In tr, this message translates to:
  /// **'Bu kullanıcı hesabı devre dışı bırakılmış.'**
  String get accountDisabled;

  /// No description provided for @adminNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta ile kayıtlı yönetici bulunamadı.'**
  String get adminNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre hatalı, lütfen kontrol edin.'**
  String get wrongPassword;

  /// No description provided for @invalidEmailOrPassword.
  ///
  /// In tr, this message translates to:
  /// **'E-posta veya şifre hatalı.'**
  String get invalidEmailOrPassword;

  /// No description provided for @tooManyAttempts.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla deneme yaptınız. Lütfen sonra tekrar deneyin.'**
  String get tooManyAttempts;

  /// No description provided for @loginFailed.
  ///
  /// In tr, this message translates to:
  /// **'Giriş başarısız'**
  String get loginFailed;

  /// No description provided for @adminPanel.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici Paneli'**
  String get adminPanel;

  /// No description provided for @adminLogin.
  ///
  /// In tr, this message translates to:
  /// **'Yönetici Paneli Girişi'**
  String get adminLogin;

  /// No description provided for @quickOptions.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı Seçenekler'**
  String get quickOptions;

  /// No description provided for @addImages.
  ///
  /// In tr, this message translates to:
  /// **'Görsel Ekle'**
  String get addImages;

  /// No description provided for @changeImages.
  ///
  /// In tr, this message translates to:
  /// **'Görselleri Değiştir'**
  String get changeImages;

  /// No description provided for @noImagesFound.
  ///
  /// In tr, this message translates to:
  /// **'Görsel yok'**
  String get noImagesFound;

  /// No description provided for @tipCleaningDesc.
  ///
  /// In tr, this message translates to:
  /// **'Hafif nemli bezle silip kurulayın. Islak bez ahşabı şişirir.'**
  String get tipCleaningDesc;

  /// No description provided for @helpCenter.
  ///
  /// In tr, this message translates to:
  /// **'YARDIM MERKEZİ'**
  String get helpCenter;

  /// No description provided for @faqTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sıkça Sorulan Sorular'**
  String get faqTitle;

  /// No description provided for @faqSub.
  ///
  /// In tr, this message translates to:
  /// **'Merak ettiğiniz her şeyin cevabı burada'**
  String get faqSub;
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

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

  /// No description provided for @searchHint.
  ///
  /// In tr, this message translates to:
  /// **'Ürün, kategori veya stil arayın...'**
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
  /// **'Yemek Odası'**
  String get categoryTable;

  /// No description provided for @categoryBed.
  ///
  /// In tr, this message translates to:
  /// **'Yatak Odası'**
  String get categoryBed;

  /// No description provided for @categoryWardrobe.
  ///
  /// In tr, this message translates to:
  /// **'Gardırop'**
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

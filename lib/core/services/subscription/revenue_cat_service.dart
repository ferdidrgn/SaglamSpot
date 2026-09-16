import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../config/revenue_cat_config.dart';

/// RevenueCat entegrasyonu — uygulamada satılan TEK dijital ürün olan
/// "6 Aylık Reklamsız Üyelik" aboneliğinin satın alma/durum takibi bu
/// servisten yürütülür.
///
/// ANONİM KULLANICI MODELİ: Uygulamanın normal müşteriler için bir hesap
/// sistemi YOK (sepet/favoriler zaten cihaz bazlı SharedPreferences'ta
/// tutuluyor — bkz. ilgili cache sınıfları; Firebase Auth SADECE admin
/// girişi için var). Bu yüzden [Purchases.configure] çağrısında BİLEREK
/// `appUserID` VERİLMİYOR: RevenueCat SDK'sı kendi rastgele anonim
/// (`$RCAnonymousID:...`) kimliğini üretir ve cihaza (Keychain/SharedPrefs
/// altyapısı üzerinden) kalıcı olarak saklar. Böylece aynı cihazdaki
/// tekrar açılışlarda RevenueCat aynı anonim kullanıcıyı tanır ve
/// satın alma/entitlement durumunu ona bağlı tutar — bizim tarafımızda
/// (kendi backend'imizde) HİÇBİR satın alma durumu tutulmaz, tek doğru
/// kaynak RevenueCat'in customerInfo/entitlement mekanizmasıdır. İleride
/// gerçek bir müşteri hesap sistemi eklenirse, o hesabın kimliğiyle
/// [Purchases.logIn] çağrılarak bu anonim kullanıcı gerçek kullanıcıya
/// RevenueCat tarafında birleştirilebilir (bkz. RevenueCat "Identifying
/// Users" dokümantasyonu) — bugün için buna gerek yok.
///
/// WEB DESTEĞİ YOK: RevenueCat'in mobil SDK'sı (App Store/Play Store
/// faturalandırması) web'de ANLAMSIZDIR — web'de gerçek bir "satın alma"
/// zaten yok (sepet = WhatsApp'a istek listesi göndermek). Bu yüzden
/// [init] `kIsWeb` durumunda hiçbir şey yapmadan (no-op) döner; diğer
/// tüm metotlar da web'de çağrılırsa güvenli şekilde boş/null döner.
abstract final class RevenueCatService {
  static bool _configured = false;

  /// SDK'yı başlatır. `main`/`AppInitializer` içinde, uygulamanın geri
  /// kalan başlatma sırasını BOZMADAN en sonda, `!kIsWeb` koşuluyla
  /// çağrılması beklenir (bkz. AppInitializer._safeInitializeRevenueCat).
  ///
  /// TODO(RevenueCat dashboard): `RevenueCatConfig` içindeki
  /// `iosApiKey` / `androidApiKey` sabitleri gerçek anahtarlarla
  /// doldurulmadan bu çağrı `PurchasesErrorCode.invalidCredentialsError`
  /// ile başarısız olur (try/catch ile yutulur, uygulama çökmez —
  /// sadece reklamsız üyelik özelliği pasif kalır).
  static Future<void> init() async {
    if (kIsWeb) return; // Web'de RevenueCat SDK'sı desteklenmez/no-op.
    try {
      final String apiKey = Platform.isIOS
          ? RevenueCatConfig.iosApiKey
          : RevenueCatConfig.androidApiKey;

      if (apiKey.startsWith('TODO_')) {
        debugPrint(
            '💳 RevenueCat: API key henüz ayarlanmadı (RevenueCatConfig), '
            'başlatma atlandı.');
        return;
      }

      await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.warn);

      // appUserID BİLEREK verilmiyor -> RevenueCat anonim kullanıcı kimliği
      // üretip cihaza kalıcı olarak bağlar (yukarıdaki sınıf yorumuna bkz.).
      final configuration = PurchasesConfiguration(apiKey);
      await Purchases.configure(configuration);
      _configured = true;
      debugPrint('💳 RevenueCat hazır (anonim kullanıcı modu).');
    } catch (e) {
      debugPrint('💳 RevenueCat başlatma hatası: $e');
    }
  }

  /// RevenueCat dashboard'ında tanımlı offering'leri getirir. Dashboard'da
  /// "6 Aylık Reklamsız Üyelik" ürününü içeren bir Offering (ör. "default")
  /// ve bunun içinde `packageType: sixMonth` (ya da eşdeğer bir custom
  /// identifier) ile tanımlı bir Package OLDUĞU varsayılır — bu, kod
  /// tarafında OLUŞTURULMAZ, kullanıcının kendi RevenueCat hesabında
  /// kurması gerekir (bkz. RevenueCatConfig dosya başı yorumu).
  static Future<Offerings?> getOfferings() async {
    if (kIsWeb || !_configured) return null;
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('💳 RevenueCat getOfferings hatası: $e');
      return null;
    }
  }

  /// "6 Aylık Reklamsız Üyelik" paketini mevcut (current) offering'den,
  /// orada yoksa tüm offering'leri gezerek bulur. Önce dashboard'ın
  /// standart "six month" package type alanına, bulunamazsa
  /// `availablePackages` içinde `PackageType.sixMonth` olan ilk pakete
  /// bakar (dashboard'da custom bir identifier ile kurulmuş olabilir).
  static Future<Package?> getSixMonthRemoveAdsPackage() async {
    final offerings = await getOfferings();
    if (offerings == null) return null;

    final current = offerings.current;
    if (current?.sixMonth != null) return current!.sixMonth;

    for (final offering in offerings.all.values) {
      if (offering.sixMonth != null) return offering.sixMonth;
      for (final package in offering.availablePackages) {
        if (package.packageType == PackageType.sixMonth) return package;
      }
    }
    return null;
  }

  /// Satın alma akışını başlatır (native mağaza ödeme diyaloğunu açar).
  /// Kullanıcı iptal ederse [PurchasesErrorCode.purchaseCancelledError]
  /// fırlatır; çağıran taraf (UI) bunu yakalayıp sessizce yutmalı, diğer
  /// hataları kullanıcıya snackbar ile göstermelidir.
  static Future<CustomerInfo> purchasePackage(final Package package) async {
    final result = await Purchases.purchase(PurchaseParams.package(package));
    return result.customerInfo;
  }

  /// Bir [PlatformException]'ın "kullanıcı satın almayı iptal etti"
  /// durumunu temsil edip etmediğini söyler — UI bu durumda hata
  /// göstermek yerine sessiz kalmalı.
  static bool isUserCancelledError(final Object error) {
    if (error is! PlatformException) return false;
    try {
      return PurchasesErrorHelper.getErrorCode(error) ==
          PurchasesErrorCode.purchaseCancelledError;
    } catch (_) {
      return false;
    }
  }

  /// Güncel müşteri bilgisini (customerInfo) sorgular. Reklamsız üyeliğin
  /// aktif olup olmadığı ve ne zaman sona ereceği BURADAN, yani doğrudan
  /// RevenueCat'ten okunur — kendi backend'imizde ayrıca bir kayıt YOKTUR.
  static Future<CustomerInfo?> getCustomerInfo() async {
    if (kIsWeb || !_configured) return null;
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      debugPrint('💳 RevenueCat getCustomerInfo hatası: $e');
      return null;
    }
  }

  /// [customerInfo] içinden "remove_ads" entitlement'ının aktif olup
  /// olmadığını döner.
  static bool isRemoveAdsActive(final CustomerInfo? customerInfo) =>
      customerInfo
          ?.entitlements.active[RevenueCatConfig.removeAdsEntitlementId] !=
      null;

  /// [customerInfo] içindeki "remove_ads" entitlement'ının bitiş tarihini
  /// (varsa) [DateTime] olarak döner.
  static DateTime? removeAdsExpirationDate(final CustomerInfo? customerInfo) {
    final entitlement = customerInfo
        ?.entitlements.active[RevenueCatConfig.removeAdsEntitlementId];
    final raw = entitlement?.expirationDate;
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }
}

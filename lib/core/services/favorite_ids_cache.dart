import 'package:shared_preferences/shared_preferences.dart';

/// Favori ürün ID'lerinin cihazda kalıcı (SharedPreferences) önbelleği —
/// `CategoryWatchCache` ile AYNI desen.
///
/// `FavoritesNotifier` (bkz. favorites_provider.dart) favori listesini
/// SADECE bellekte tutuyordu ("oturum boyunca yaşar") — bu önbellek
/// olmadan uygulama her yeniden açılışta favori listesini [] ile
/// başlatıyor, ama bu sıfırlanma Firestore'a HİÇ yansımıyordu (yalnızca
/// add()/remove() çağrıldığında senkron tetiklenir). Sonuç: bir cihaz bir
/// kez herhangi bir ürünü favorileyip uygulamayı kapattığında,
/// `notification_subscriptions/{fcmToken}` dokümanı o cihaz için
/// SONSUZA DEK (kullanıcı tüm favorilerini tekrar açıp elle kaldırana
/// kadar) asılı kalıyordu — admin panelindeki "Favorisi Olanlar"
/// kampanya segmenti, aslında "şu an favorisi olan" yerine "bir gün
/// herhangi bir şeyi favorilemiş ve hâlâ unutmamış/kaldırmamış HERKES"
/// anlamına geliyordu; zamanla neredeyse tüm aktif kullanıcı tabanına
/// yaklaşıp "herkese gitmiş gibi" görünüyordu.
final class FavoriteIdsCache {
  FavoriteIdsCache._();

  static const String _key = 'favorite_product_ids';
  static List<String> _saved = const [];

  static List<String> get saved => _saved;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _saved = prefs.getStringList(_key) ?? const [];
  }

  static Future<void> setSaved(final List<String> ids) async {
    _saved = ids;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids);
  }
}

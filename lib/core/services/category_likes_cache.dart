import 'package:shared_preferences/shared_preferences.dart';
import '../common/enum/enums.dart';
import '../common/extentions/product_category_ex.dart';

/// "Kategori beğenme" için beğenilen kategorilerin cihazda kalıcı
/// (SharedPreferences) önbelleği — `CategoryWatchCache` ile AYNI desen.
/// Uygulama açılışında yüklenir ki `CategoryLikesNotifier.build()` ilk
/// kareden itibaren doğru beğeni durumunu gösterebilsin.
final class CategoryLikesCache {
  CategoryLikesCache._();

  static const String _key = 'category_likes';
  static Set<ProductCategory> _saved = {};

  static Set<ProductCategory> get saved => _saved;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final names = prefs.getStringList(_key) ?? const [];
    _saved = names.map((final n) => n.toProductCategory()).toSet();
  }

  static Future<void> setSaved(final Set<ProductCategory> value) async {
    _saved = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _key, value.map((final c) => c.toFirestore()).toList());
  }
}

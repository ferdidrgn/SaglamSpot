import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/enum/enums.dart';
import '../common/extentions/product_category_ex.dart';
import '../services/category_likes_cache.dart';

/// "Kategori beğenme" — kullanıcının "bunu seviyorum" dediği kategoriler.
/// `category_watch_subscriptions`'tan (bkz. category_watch_sync.dart)
/// KASITLI olarak ayrı bir kavram: o "bu kategoride yeni ürün eklenince
/// bana bildirim gönder" aboneliği — push izni ve bir FCM token'ı
/// gerektirir, web'de hiç çalışmaz. Beğenme ise push'tan tamamen
/// bağımsız basit bir İLGİ (affinity) sinyali — hem web hem mobilde
/// çalışır, hiçbir bildirim TETİKLEMEZ; sadece (a) cihazda kalıcı tutulup
/// Ana sayfadaki kategori çiplerini kişiselleştirmek, (b) Firestore'daki
/// `CategoryMeta/{kategori}.likeCount` sayacını artırıp/azaltarak admin'e
/// GERÇEK "en çok beğenilen kategori" verisi sağlamak için kullanılır —
/// `Product.viewCountWeb/Mobile`'daki AYNI "basit, dürüst, anonim ham
/// sayaç" felsefesi (bkz. firestore.rules > isValidLikeDelta/isValidLikeCreate).
class CategoryLikesNotifier extends Notifier<Set<ProductCategory>> {
  @override
  Set<ProductCategory> build() => CategoryLikesCache.saved;

  bool isLiked(final ProductCategory category) => state.contains(category);

  void toggle(final ProductCategory category) {
    final liked = !state.contains(category);
    final next = {...state};
    if (liked) {
      next.add(category);
    } else {
      next.remove(category);
    }
    state = next;
    CategoryLikesCache.setSaved(next);
    _syncLikeCount(category, liked ? 1 : -1);
  }

  // Firestore sayacı best-effort — UI state değişikliğini ASLA bloklamaz
  // veya hataya düşürmez (favorite_notification_sync.dart'taki AYNI desen).
  // `SetOptions(merge: true)` ile: doküman hiç yoksa SADECE likeCount
  // alanıyla oluşturulur (CategoryMeta.fromFirestore her alanı kendi
  // başına fallback'lediği için ikon/renk/sıra admin varsayılanında kalır,
  // bkz. category_meta.dart), varsa admin'in diğer alanlarına DOKUNMAZ.
  Future<void> _syncLikeCount(final ProductCategory category, final int delta) async {
    try {
      await FirebaseFirestore.instance
          .collection('CategoryMeta')
          .doc(category.toFirestore())
          .set({'likeCount': FieldValue.increment(delta)}, SetOptions(merge: true));
    } catch (e) {
      debugPrint('⚠️ Kategori beğeni sayacı senkronizasyonu başarısız: $e');
    }
  }
}

final categoryLikesProvider =
    NotifierProvider<CategoryLikesNotifier, Set<ProductCategory>>(
        CategoryLikesNotifier.new);

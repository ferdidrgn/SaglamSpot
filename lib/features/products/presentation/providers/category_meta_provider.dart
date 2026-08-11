import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/services/firestore_provider.dart';
import '../../data/models/category_meta.dart';

/// 'CategoryMeta' koleksiyonunu dinlemeye çalışır; doküman ID'si
/// ProductCategory.name ile eşleşmelidir (örn: 'sofa', 'chair'...).
/// Koleksiyon boşsa/yoksa veya bir hata olursa sabit varsayılanlara döner —
/// yani bu provider'ı kimse Firestore'da hiçbir şey oluşturmasa bile
/// uygulama olduğu gibi, hatasız çalışmaya devam eder.
final categoryMetaProvider =
    StreamProvider<Map<ProductCategory, CategoryMeta>>((final ref) {
  final firestore = ref.watch(firestoreProvider);

  try {
    return firestore.collection('CategoryMeta').snapshots().map((final snapshot) {
      final Map<ProductCategory, CategoryMeta> merged =
          Map.of(defaultCategoryMeta);

      for (final doc in snapshot.docs) {
        ProductCategory? category;
        for (final c in ProductCategory.values) {
          if (c.name == doc.id) {
            category = c;
            break;
          }
        }
        if (category == null) continue; // Bilinmeyen doküman ID'si -> yok say

        merged[category] =
            CategoryMeta.fromFirestore(doc.data(), merged[category]!);
      }

      return merged;
    }).handleError((final error) {
      debugPrint('⚠️ CategoryMeta akışı okunamadı, varsayılanlar kullanılıyor: $error');
      return defaultCategoryMeta;
    });
  } catch (e) {
    debugPrint('⚠️ CategoryMeta bağlantısı kurulamadı, varsayılanlar kullanılıyor: $e');
    return Stream.value(defaultCategoryMeta);
  }
});

/// Aktif (isActive) kategorileri sıraya göre dizilmiş halde döndüren
/// kolaylık provider'ı — chip listeleri doğrudan bunu kullanabilir.
final orderedActiveCategoriesProvider = Provider<List<CategoryMeta>>((final ref) {
  final metaAsync = ref.watch(categoryMetaProvider);

  final Map<ProductCategory, CategoryMeta> meta =
      metaAsync.value ?? defaultCategoryMeta;

  final list = meta.values.where((final m) => m.isActive).toList()
    ..sort((final a, final b) => a.order.compareTo(b.order));

  return list;
});

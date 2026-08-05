import 'package:flutter/material.dart';
import '../../../../core/common/enum/enums.dart';

/// Bir kategori için GÖRSEL meta veri (ikon, renk, sıralama, özel etiket).
///
/// ÖNEMLİ TASARIM KARARI: Filtreleme mantığı hâlâ [ProductCategory] enum'una
/// dayanıyor (Firestore'daki mevcut ürün dokümanlarıyla birebir uyumlu kalması,
/// hiçbir veri taşıma/migration gerekmemesi için). Bu sınıf sadece o enum'un
/// NASIL GÖRÜNECEĞİNİ Firestore'dan dinamik olarak besler — admin panelden
/// yeni bir "CategoryMeta" dokümanı eklersen, kod değişmeden ikon/renk/sıra/
/// özel isim anında güncellenir. Firestore'da hiç doküman yoksa uygulama
/// [defaults] listesindeki sabit değerlerle sorunsuz çalışmaya devam eder.
@immutable
class CategoryMeta {
  final ProductCategory category;
  final String? customLabel;
  final IconData icon;
  final Color color;
  final int order;
  final bool isActive;

  const CategoryMeta({
    required this.category,
    required this.icon,
    required this.color,
    required this.order,
    this.customLabel,
    this.isActive = true,
  });

  CategoryMeta copyWith({
    final String? customLabel,
    final IconData? icon,
    final Color? color,
    final int? order,
    final bool? isActive,
  }) =>
      CategoryMeta(
        category: category,
        customLabel: customLabel ?? this.customLabel,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        order: order ?? this.order,
        isActive: isActive ?? this.isActive,
      );

  /// Firestore dokümanından gelen alan isimleri: icon, colorHex, order,
  /// label, isActive — hepsi opsiyonel, eksik olan alan varsayılanı korur.
  factory CategoryMeta.fromFirestore(
    final Map<String, dynamic> data,
    final CategoryMeta fallback,
  ) {
    return fallback.copyWith(
      customLabel: data['label'] as String?,
      icon: _iconRegistry[data['icon'] as String?] ?? fallback.icon,
      color: data['colorHex'] != null
          ? Color(int.parse((data['colorHex'] as String).replaceFirst('#', '0xFF')))
          : fallback.color,
      order: (data['order'] as num?)?.toInt(),
      isActive: data['isActive'] as bool?,
    );
  }
}

/// Firestore'da string olarak saklanan ikon isimlerini gerçek [IconData]'ya
/// çeviren küçük bir kayıt defteri. Admin panelden yeni ikon eklemek
/// istersen sadece burayı büyütmen yeterli.
const Map<String, IconData> _iconRegistry = {
  'weekend': Icons.weekend_rounded,
  'chair': Icons.chair_rounded,
  'table_restaurant': Icons.table_restaurant_rounded,
  'bed': Icons.bed_rounded,
  'door_sliding': Icons.door_sliding_rounded,
  'checkroom': Icons.checkroom_rounded,
  'kitchen': Icons.kitchen_rounded,
  'category': Icons.category_rounded,
  'lightbulb': Icons.lightbulb_rounded,
  'yard': Icons.yard_rounded,
  'living': Icons.living_rounded,
  'meeting_room': Icons.meeting_room_rounded,
};

/// Firestore'a hiç dokunulmadıysa kullanılacak, canlı ve şık renklerle
/// tasarlanmış varsayılan kategori paleti.
final Map<ProductCategory, CategoryMeta> defaultCategoryMeta = {
  ProductCategory.sofa: const CategoryMeta(
    category: ProductCategory.sofa,
    icon: Icons.weekend_rounded,
    color: Color(0xFF2E7D6B), // Zümrüt yeşili
    order: 0,
  ),
  ProductCategory.chair: const CategoryMeta(
    category: ProductCategory.chair,
    icon: Icons.chair_rounded,
    color: Color(0xFFC5A358), // Marka altını
    order: 1,
  ),
  ProductCategory.table: const CategoryMeta(
    category: ProductCategory.table,
    icon: Icons.table_restaurant_rounded,
    color: Color(0xFFB2673E), // Sıcak ahşap tonu
    order: 2,
  ),
  ProductCategory.bed: const CategoryMeta(
    category: ProductCategory.bed,
    icon: Icons.bed_rounded,
    color: Color(0xFF6B5CA5), // Lila-indigo
    order: 3,
  ),
  ProductCategory.wardrobe: const CategoryMeta(
    category: ProductCategory.wardrobe,
    icon: Icons.door_sliding_rounded,
    color: Color(0xFF3E6B8A), // Petrol mavisi
    order: 4,
  ),
  ProductCategory.white: const CategoryMeta(
    category: ProductCategory.white,
    icon: Icons.kitchen_rounded,
    color: Color(0xFF5A8A6B), // Adaçayı yeşili
    order: 5,
  ),
  ProductCategory.other: const CategoryMeta(
    category: ProductCategory.other,
    icon: Icons.category_rounded,
    color: Color(0xFF7A7F87), // Nötr gri
    order: 6,
  ),
};

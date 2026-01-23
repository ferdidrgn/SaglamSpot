import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/common/enum/enums.dart';

part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product extends Equatable {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String soldAt;
  final String name;
  final String desc;

  /// 🏷️ Enum otomatik olarak String <-> Enum dönüşümü yapar
  final ProductCategory category;

  final double price;

  @JsonKey(defaultValue: [])
  final List<String> imagesUrl;

  @JsonKey(defaultValue: false)
  final bool isSold;

  @JsonKey(defaultValue: false)
  final bool isSpotProduct;

  const Product({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.soldAt,
    required this.name,
    required this.desc,
    required this.category,
    required this.price,
    required this.imagesUrl,
    required this.isSold,
    required this.isSpotProduct,
  });

  /// 🏭 BOŞ / BAŞLANGIÇ NESNESİ (Loading durumları için)
  factory Product.empty() => const Product(
        id: '',
        createdAt: '',
        updatedAt: '',
        soldAt: '',
        name: '',
        desc: '',
        category: ProductCategory.other,
        price: 0.0,
        imagesUrl: [],
        isSold: false,
        isSpotProduct: false,
      );

  /// 🧱 JSON'dan Nesne Üretme (Otomatik)
  factory Product.fromJson(final Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// 📦 Nesneyi JSON'a Çevirme (Otomatik)
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  /// 📋 CopyWith (State yönetimi için manuel kalması daha sağlıklıdır veya freezed kullanılabilir)
  Product copyWith({
    final String? id,
    final String? createdAt,
    final String? updatedAt,
    final String? soldAt,
    final String? name,
    final String? desc,
    final ProductCategory? category,
    final double? price,
    final List<String>? imagesUrl,
    final bool? isSold,
    final bool? isSpotProduct,
  }) =>
      Product(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        soldAt: soldAt ?? this.soldAt,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        category: category ?? this.category,
        price: price ?? this.price,
        imagesUrl: imagesUrl ?? this.imagesUrl,
        isSold: isSold ?? this.isSold,
        isSpotProduct: isSpotProduct ?? this.isSpotProduct,
      );

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        soldAt,
        name,
        desc,
        category,
        price,
        imagesUrl,
        isSold,
        isSpotProduct,
      ];
}

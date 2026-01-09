import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String soldAt;
  final String name;
  final String desc;
  final String category;
  final double price;
  final List<String> imagesUrl;
  final bool isSold;
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
    required this.isSold,
    required this.isSpotProduct,
    required this.imagesUrl,
  });

  Product copyWith({
    final String? id,
    final String? createdAt,
    final String? updatedAt,
    final String? soldAt,
    final String? name,
    final String? desc,
    final String? category,
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
        isSold,
        isSpotProduct,
        imagesUrl,
      ];

  // Firestore'dan gelen veriyi Entity'e çevirmek için (Opsiyonel ama kullanışlı)
  factory Product.fromMap(final Map<String, dynamic> data) => Product(
        id: data['id'] ?? '',
        createdAt: data['createdAt'] ?? '',
        updatedAt: data['updatedAt'] ?? '',
        soldAt: data['soldAt'] ?? '',
        name: data['name'] ?? '',
        desc: data['desc'] ?? '',
        category: data['category'] ?? '',
        price: (data['price'] as num?)?.toDouble() ?? 0.0,
        isSold: data['isSold'] ?? false,
        isSpotProduct: data['isSpotProduct'] ?? false,
        imagesUrl: List<String>.from(data['imagesUrl'] ?? []),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'soldAt': soldAt,
        'name': name,
        'desc': desc,
        'category': category,
        'price': price,
        'isSold': isSold,
        'isSpotProduct': isSpotProduct,
        'imagesUrl': imagesUrl,
      };
}

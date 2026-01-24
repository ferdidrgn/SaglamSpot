import 'package:equatable/equatable.dart';
import '../../../../core/common/enum/enums.dart';

class Product extends Equatable {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String soldAt;
  final String name;
  final String desc;
  final ProductCategory category;
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
    required this.imagesUrl,
    required this.isSold,
    required this.isSpotProduct,
  });

  factory Product.empty() => Product(
        id: '',
        createdAt: '',
        updatedAt: '',
        soldAt: '',
        name: '',
        desc: '',
        category: ProductCategory.other,
        // Varsayılan enum
        price: 0.0,
        imagesUrl: const [],
        isSold: false,
        isSpotProduct: false,
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
        isSpotProduct
      ];

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
}

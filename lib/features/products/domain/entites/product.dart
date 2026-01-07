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

  factory Product.fromMap(final Map<String, dynamic> data) {
    return Product(
      id: data['id'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      soldAt: data['soldAt'],
      name: data['name'],
      desc: data['desc'],
      category: data['category'],
      price: (data['price'] as num).toDouble(),
      isSold: data['isSold'],
      isSpotProduct: data['isSpotProduct'],
      imagesUrl: List<String>.from(data['imagesUrl'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
}

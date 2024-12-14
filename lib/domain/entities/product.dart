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
  final List<String> imageUrl;
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
    required this.imageUrl,
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
        imageUrl,
      ];

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      soldAt: map['soldAt'],
      name: map['name'],
      desc: map['desc'],
      category: map['category'],
      price: (map['price'] as num).toDouble(),
      isSold: map['isSold'],
      isSpotProduct: map['isSpotProduct'],
      imageUrl: List<String>.from(map['imageUrl'] ?? []),
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
      'imageUrl': imageUrl,
    };
  }
}
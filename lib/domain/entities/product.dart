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
}

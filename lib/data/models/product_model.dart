import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product.dart';

class ProductModel {
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

  const ProductModel({
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

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: data['_id'] ?? '',
      createdAt: data['_createdAt'] ?? '',
      updatedAt: data['_updatedAt'] ?? '',
      soldAt: data['_soldAt'] ?? '',
      name: data['name'] ?? '',
      desc: data['desc'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] as num).toDouble(),
      isSold: data['isSold'] ?? false,
      isSpotProduct: data['isSpotProduct'] ?? false,
      imageUrl: (data['imageUrl'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      '_id': id,
      '_createdAt': createdAt,
      '_updatedAt': updatedAt,
      '_soldAt': soldAt,
      'name': name,
      'desc': desc,
      'category': category,
      'price': price,
      'isSold': isSold,
      'isSpotProduct': isSpotProduct,
      'imageUrl': imageUrl,
    };
  }

  ProductModel copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    String? soldAt,
    String? name,
    String? desc,
    String? category,
    double? price,
    List<String>? imageUrl,
    bool? isSold,
    bool? isSpotProduct,
  }) {
    return ProductModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      soldAt: soldAt ?? this.soldAt,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      category: category ?? this.category,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isSold: isSold ?? this.isSold,
      isSpotProduct: isSpotProduct ?? this.isSpotProduct,
    );
  }

  Product toEntity() {
    return Product(
      createdAt: createdAt,
      updatedAt: updatedAt,
      soldAt: soldAt,
      id: id,
      name: name,
      desc: desc,
      category: category,
      price: price,
      isSpotProduct: isSpotProduct,
      isSold: isSold,
      imageUrl: imageUrl.isNotEmpty ? imageUrl : [],
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      soldAt: product.soldAt,
      name: product.name,
      desc: product.desc,
      category: product.category,
      price: product.price,
      imageUrl: product.imageUrl,
      isSold: product.isSold,
      isSpotProduct: product.isSpotProduct,
    );
  }
}

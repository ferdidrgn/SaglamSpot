import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
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

  Product({
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

  // Firestore'dan veri çekerken kullanılır
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: data['_id'] ?? '',
      createdAt: data['_createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
      soldAt: data['_soldAt'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      desc: data['desc'] ?? '',
      isSold: data['isSold'] ?? false,
      isSpotProduct: data['isSpotProduct'] ?? false,
      price: (data['price'] as num).toDouble(),
      imageUrl: (data['imageUrl'] as List<dynamic>)
          .map((item) => item as String)
          .toList(),
    );
  }

  // Firestore'a veri gönderirken kullanılır
  Map<String, dynamic> toFirestore() {
    return {
      '_id': id,
      '_createdAt': createdAt,
      '_updatedAt': updatedAt,
      '_soldAt': soldAt,
      'name': name,
      'desc': desc,
      'category': category,
      'isSold': isSold,
      'isSpotProduct': isSpotProduct,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}

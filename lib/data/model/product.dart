import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String desc;
  final String category;
  final double price;
  final List<String> imageUrl;
  final bool isSold;
  final bool isSpotProduct;

  Product({
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
      'name': name,
      'desc': desc,
      'category':category,
      'isSold': isSold,
      'isSpotProduct': isSpotProduct,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}

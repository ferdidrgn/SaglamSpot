import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String soldDate;
  final double price;
  final List<String> imageUrl;
  final bool isSold;

  Product({
    required this.name,
    required this.price,
    required this.soldDate,
    required this.isSold,
    required this.imageUrl,
  });

  // Firestore'dan veri çekerken kullanılır
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      name: data['name'] ?? '',
      soldDate: data['soldDate'] ?? '',
      isSold: data['isSold'] ?? false,
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
      'soldDate': soldDate,
      'isSold': isSold,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}

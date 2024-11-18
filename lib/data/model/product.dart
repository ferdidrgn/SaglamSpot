import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String soldDate;
  final String description;
  final double price;
  final String imageUrl;
  final bool isSold;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.soldDate,
    required this.imageUrl,
  required this.isSold,
  });

  // Firestore'dan veri çekerken kullanılır
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      soldDate: data['soldDate'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      isSold: data['isSold'] ?? false,
    );
  }

  // Firestore'a veri gönderirken kullanılır
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'soldDate': soldDate,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isSold': isSold,
    };
  }
}

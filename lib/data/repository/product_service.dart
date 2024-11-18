import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> fetchProducts() async {
    try {
      final querySnapshot = await _firestore.collection('Product').get();
      return querySnapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Ürünler yüklenirken hata oluştu: $e');
    }
  }

}

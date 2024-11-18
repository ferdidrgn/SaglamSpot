import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('Product').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSoldProducts(DateTime since) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('soldDate', isGreaterThanOrEqualTo: since.toIso8601String())
          .get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Error fetching sold products: $e');
    }
  }
}

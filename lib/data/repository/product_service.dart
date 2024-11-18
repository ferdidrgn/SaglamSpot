import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/util/date_formatter.dart';
import '../model/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ürünleri Fetch Etme
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

  // Ürün Ekleme
  Future<void> addProduct(Product product) async {
    try {
      // Tarih formatlama
      final nowDateTime = DateFormatter.nowFormatDateTime();
      final nowDate = DateFormatter.parseFormattedDateTime(nowDateTime,
          formatWithMonthName: false);

      // Ürüne oluşturulma tarihi ekleniyor
      final Product newProduct = Product(
        id: _firestore.collection('Product').doc().id,
        // Otomatik ID oluşturma
        createdAt: nowDate['date'].toString() ?? '',
        updatedAt: nowDate['date'].toString() ?? '',
        soldAt: '',
        // Varsayılan olarak boş
        name: product.name,
        desc: product.desc,
        category: product.category,
        price: product.price,
        isSold: product.isSold,
        isSpotProduct: product.isSpotProduct,
        imageUrl: product.imageUrl,
      );

      // Firestore'a ekleme
      await _firestore
          .collection('Product')
          .doc(newProduct.id)
          .set(newProduct.toFirestore());
    } catch (e) {
      throw Exception('Ürün eklenirken hata oluştu: $e');
    }
  }
}

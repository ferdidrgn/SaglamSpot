import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../../core/util/date_formatter.dart';
import '../model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Ürünleri getirme
  Future<List<Product>> fetchProducts() async {
    try {
      final querySnapshot = await _firestore.collection('Product').get();
      return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Ürünler yüklenirken hata oluştu: $e');
    }
  }

  /// Ürün Ekleme
  Future<void> addProductWithImages(Product product, List<Uint8List> images) async {
    try {
      // Görselleri Firebase'e yükle
      final imageUrls = await uploadProductImages(images);

      // Tarihleri ayarla
      final nowDateTime = DateFormatter.nowFormatDateTime();
      final nowDate = DateFormatter.parseFormattedDateTime(nowDateTime, formatWithMonthName: false);
      final newProduct = Product(
        id: _firestore.collection('Product').doc().id,
        // Otomatik ID oluşturma
        createdAt: nowDate['date'].toString() ?? '',
        updatedAt: nowDate['date'].toString() ?? '',
        soldAt: '',
        name: product.name,
        desc: product.desc,
        category: product.category,
        price: product.price,
        isSold: product.isSold,
        isSpotProduct: product.isSpotProduct,
        imageUrl: imageUrls,
      );

      // Firestore'a kaydet
      await _firestore.collection('Product').doc(newProduct.id).set(newProduct.toFirestore());
    } catch (e) {
      throw Exception('Ürün eklenirken hata oluştu: $e');
    }
  }

  /// Görselleri Firebase Storage'a yükle
  Future<List<String>> uploadProductImages(List<Uint8List> images) async {
    if (images.isEmpty) throw Exception('Yüklenecek görsel bulunamadı.');

    List<String> downloadUrls = [];
    try {
      for (var image in images) {
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef = _storage.ref().child('product_images/$fileName');

        // Uint8List'i yükle
        final uploadTask = await storageRef.putData(image);

        // Download URL'yi al ve listeye ekle
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      return downloadUrls;
    } catch (e) {
      throw Exception('Görseller yüklenirken hata oluştu: $e');
    }
  }
}
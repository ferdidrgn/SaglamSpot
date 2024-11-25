import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import '../../core/util/date_formatter.dart';
import '../model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('Product');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Ürünleri getirme
  Future<List<Product>> fetchProducts() async {
    try {
      final querySnapshot = await _firestore.get();
      return querySnapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Ürünler yüklenirken hata oluştu: $e');
    }
  }

  // Ürün Ekleme
  Future<void> addProductWithImages(
      Product product, List<dynamic> images) async {
    try {
      // Görselleri Firebase'e yükle
      final imageUrls = await uploadProductImages(images);

      // Tarihleri ayarla
      final nowDateTime = DateFormatter.nowFormatDateTime();
      final nowDate = DateFormatter.parseFormattedDateTime(nowDateTime,
          formatWithMonthName: false);
      final newProduct = Product(
        id: _firestore.doc().id,
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
      await _firestore.doc(newProduct.id).set(newProduct.toFirestore());
    } catch (e) {
      throw Exception('Ürün eklenirken hata oluştu: $e');
    }
  }

  Future<List<Product>> fetchFilteredProducts({
    String? condition,
    double? minPrice,
    double? maxPrice,
  }) async {
    Query query = _firestore;

    try {
      if (condition != null) {
        query =
            query.where('isSpotProduct', isEqualTo: condition == 'İkinci El');
      }
      if (minPrice != null) {
        query = query.where('price', isGreaterThanOrEqualTo: minPrice);
      }
      if (maxPrice != null) {
        query = query.where('price', isLessThanOrEqualTo: maxPrice);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      // Hata durumunda bir hata fırlat
      throw Exception('Ürünler filtrelenirken hata oluştu: $e');
    }
  }

  /// Görselleri Firebase Storage'a yükle
  Future<List<String>> uploadProductImages(List<dynamic> images) async {
    if (images.isEmpty) throw Exception('Yüklenecek görsel bulunamadı.');

    List<String> downloadUrls = [];
    try {
      for (var image in images) {
        String fileName;

        if (image is File) {
          fileName =
              '${DateTime.now().millisecondsSinceEpoch}_${image.uri.pathSegments.last}';
          final storageRef = _storage.ref().child('product_images/$fileName');

          // File'i yükle
          final uploadTask = await storageRef.putFile(image);

          // Download URL'yi al ve listeye ekle
          final downloadUrl = await uploadTask.ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
        } else if (image is Uint8List) {
          fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
          final storageRef = _storage.ref().child('product_images/$fileName');

          // Uint8List'i yükle
          final uploadTask = await storageRef.putData(image);

          // Download URL'yi al ve listeye ekle
          final downloadUrl = await uploadTask.ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
        }
      }
      return downloadUrls;
    } catch (e) {
      throw Exception('Görseller yüklenirken hata oluştu: $e');
    }
  }
}

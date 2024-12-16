import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/util/date_formatter.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<void> addProduct(ProductModel product, List<dynamic> images);
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getFilteredProducts({
    String? condition,
    double? minPrice,
    double? maxPrice,
  });
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProductRemoteDataSourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final querySnapshot = await firestore.collection('Product').get();
      return querySnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Ürünler yüklenirken hata oluştu: $e');
    }
  }

  @override
  Future<List<ProductModel>> getFilteredProducts({
    String? condition,
    double? minPrice,
    double? maxPrice,
  }) async {
    Query<Map<String, dynamic>> query = firestore.collection('Product');

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
      return snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Ürünler filtrelenirken hata oluştu: $e');
    }
  }

  @override
  Future<void> addProduct(ProductModel product, List<dynamic> images) async {
    if (images.isEmpty) throw Exception('Yüklenecek görsel bulunamadı.');

    try {
      final imageUrls = await _uploadImages(images);
      final nowDateTime = DateFormatter.nowFormatDateTime();
      final nowDate = DateFormatter.parseFormattedDateTime(
        nowDateTime,
        formatWithMonthName: false,
      );

      final newProduct = product.copyWith(
        id: firestore.collection('Product').doc().id,
        createdAt: nowDate['date'].toString(),
        updatedAt: nowDate['date'].toString(),
        soldAt: '',
        name: product.name,
        desc: product.desc,
        category: product.category,
        price: product.price,
        isSold: product.isSold,
        isSpotProduct: product.isSpotProduct,
        imageUrl: imageUrls,
      );

      await firestore
          .collection('Product')
          .doc(newProduct.id)
          .set(newProduct.toFirestore());
    } catch (e) {
      throw Exception('Ürün eklenirken hata oluştu: $e');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    try {
      await firestore
          .collection('Product')
          .doc(product.id)
          .update(product.toFirestore());
    } catch (e) {
      throw Exception('Ürün güncellenirken hata oluştu: $e');
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await firestore.collection('Product').doc(productId).delete();
    } catch (e) {
      throw Exception('Ürün silinirken hata oluştu: $e');
    }
  }

  Future<List<String>> _uploadImages(List<dynamic> images) async {
    if (images.isEmpty) throw Exception('Yüklenecek görsel bulunamadı.');

    List<String> downloadUrls = [];
    try {
      for (var image in images) {
        final String fileName =
            'product_images/${DateTime.now().millisecondsSinceEpoch}';
        final Reference ref = storage.ref().child(fileName);

        if (image is File) {
          await ref.putFile(image);
        } else if (image is Uint8List) {
          await ref.putData(image);
        } else {
          throw Exception('Geçersiz görsel türü.');
        }

        final String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      return downloadUrls;
    } catch (e) {
      throw Exception('Görseller yüklenirken hata oluştu: $e');
    }
  }
}

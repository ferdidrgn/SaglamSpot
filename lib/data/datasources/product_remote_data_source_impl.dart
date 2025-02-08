import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/util/date_formatter.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

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
      return _mapQuerySnapshotToProducts(querySnapshot);
    } catch (e) {
      throw Exception('Ürünler yüklenirken hata oluştu: $e');
    }
  }

  @override
  Future<List<ProductModel>> filterProducts({
    final String? condition,
    final double? minPrice,
    final double? maxPrice,
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
      return _mapQuerySnapshotToProducts(snapshot);
    } catch (e) {
      throw Exception('Ürünler filtrelenirken hata oluştu: $e');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts({
    final String? searchQueryText,
  }) async {
    Query<Map<String, dynamic>> query = firestore.collection('Product');

    try {
      query = query
          .where('name', isGreaterThanOrEqualTo: searchQueryText)
          .where('name', isLessThan: searchQueryText)
          .where('description', isGreaterThanOrEqualTo: searchQueryText)
          .where('description', isLessThan: searchQueryText);

      final snapshot = await query.get();
      return _mapQuerySnapshotToProducts(snapshot);
    } catch (e) {
      throw Exception('Ürünler arama sırasında hata oluştu: $e');
    }
  }

  @override
  Future<void> addProduct(
      final ProductModel product, final List<dynamic> images) async {
    if (images.isEmpty) {
      throw Exception('Yüklenecek görsel bulunamadı.');
    }

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
  Future<void> updateProduct(final ProductModel product) async {
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
  Future<void> deleteProduct(final String productId) async {
    try {
      await firestore.collection('Product').doc(productId).delete();
    } catch (e) {
      throw Exception('Ürün silinirken hata oluştu: $e');
    }
  }

  Future<List<String>> _uploadImages(final List<dynamic> images) async {
    if (images.isEmpty) {
      throw Exception('Yüklenecek görsel bulunamadı.');
    }

    final List<String> downloadUrls = [];
    try {
      for (final image in images) {
        final String fileName =
            'product_images/${DateTime.now().millisecondsSinceEpoch}';
        final Reference ref = storage.ref().child(fileName);

        if (image is File) {
          await ref.putFile(image);
        } else if (image is Uint8List) {
          await ref.putData(image);
        } else {
          throw Exception('Geçersiz görsel türü: ${image.runtimeType}');
        }

        final String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      return downloadUrls;
    } catch (e) {
      throw Exception('Görseller yüklenirken hata oluştu: $e');
    }
  }

  List<ProductModel> _mapQuerySnapshotToProducts(
      final QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((final doc) => ProductModel.fromFirestore(doc))
        .toList();
  }
}

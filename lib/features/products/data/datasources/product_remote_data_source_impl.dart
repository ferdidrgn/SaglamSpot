import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../../../core/util/date_formatter.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProductRemoteDataSourceImpl({required this.firestore, required this.storage});

  // ---------------------------------------------------------------------------
  // GET
  // ---------------------------------------------------------------------------

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await firestore.collection('Product').get();
      return _mapQuerySnapshotToProducts(snapshot);
    } catch (e) {
      throw Exception('Ürünler yüklenirken hata oluştu: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // FILTER
  // ---------------------------------------------------------------------------

  @override
  Future<List<ProductModel>> filterProducts({
    final String? condition,
    final double? minPrice,
    final double? maxPrice,
  }) async {
    Query<Map<String, dynamic>> query = firestore.collection('Product');

    try {
      if (condition != null)
        query =
            query.where('isSpotProduct', isEqualTo: condition == 'İkinci El');

      if (minPrice != null)
        query = query.where('price', isGreaterThanOrEqualTo: minPrice);

      if (maxPrice != null)
        query = query.where('price', isLessThanOrEqualTo: maxPrice);

      final snapshot = await query.get();
      return _mapQuerySnapshotToProducts(snapshot);
    } catch (e) {
      throw Exception('Ürünler filtrelenirken hata oluştu: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------------------

  @override
  Future<List<ProductModel>> searchProducts(
      final String searchQueryText) async {
    try {
      final snapshot = await firestore
          .collection('Product')
          .where('name', isGreaterThanOrEqualTo: searchQueryText)
          .where('name', isLessThan: '$searchQueryText\uf8ff')
          .get();

      return _mapQuerySnapshotToProducts(snapshot);
    } catch (e) {
      throw Exception('Ürünler arama sırasında hata oluştu: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // ADD
  // ---------------------------------------------------------------------------

  @override
  Future<void> addProduct(
    final ProductModel product,
    final List<dynamic> images,
  ) async {
    if (images.isEmpty) throw Exception('Yüklenecek görsel bulunamadı.');

    try {
      // 1️⃣ ID üret
      final productId = firestore.collection('Product').doc().id;

      // 2️⃣ Görselleri yükle
      final imageUrls = await _uploadImages(images, productId);

      // 3️⃣ Tarih
      final now = DateFormatter.parseFormattedDateTime(
          DateFormatter.nowFormatDateTime(),
          formatWithMonthName: false);

      // 4️⃣ Model
      final newProduct = product.copyWith(
        id: productId,
        imagesUrl: imageUrls,
        createdAt: now['date'].toString(),
        updatedAt: now['date'].toString(),
        soldAt: '',
      );

      // 5️⃣ Firestore
      await firestore
          .collection('Product')
          .doc(productId)
          .set(newProduct.toFirestore());
    } catch (e) {
      throw Exception('Ürün eklenirken hata oluştu: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE
  // ---------------------------------------------------------------------------
  @override
  Future<void> updateProduct(
    final ProductModel product,
    final List<dynamic>? newImages,
  ) async {
    try {
      List<String> imageUrls = product.imagesUrl;

      if (newImages != null && newImages.isNotEmpty) {
        await _deleteImagesFromStorage(product.imagesUrl);
        imageUrls = await _uploadImages(newImages, product.id);
      }

      await firestore.collection('Product').doc(product.id).update(
            product
                .copyWith(
                    imagesUrl: imageUrls,
                    updatedAt: DateFormatter.nowFormatDateTime())
                .toFirestore(),
          );
    } catch (e) {
      throw Exception('Ürün güncellenirken hata oluştu: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------

  @override
  Future<void> deleteProduct(final String productId) async {
    try {
      await firestore.collection('Product').doc(productId).delete();
    } catch (e) {
      throw Exception('Ürün silinirken hata oluştu: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // STORAGE
  // ---------------------------------------------------------------------------

  Future<List<String>> _uploadImages(
    final List<dynamic> images,
    final String productId,
  ) async {
    final List<String> urls = [];

    for (int i = 0; i < images.length; i++) {
      final ref = storage.ref().child('product_images/$productId/$i.jpg');

      final image = images[i];

      if (image is File) {
        await ref.putFile(image);
      } else if (image is Uint8List) {
        await ref.putData(image);
      } else {
        throw Exception('Geçersiz görsel türü: ${image.runtimeType}');
      }

      urls.add(await ref.getDownloadURL());
    }

    return urls;
  }

  Future<void> _deleteImagesFromStorage(final List<String> imageUrls) async {
    for (final url in imageUrls) {
      try {
        await storage.refFromURL(url).delete();
      } catch (_) {}
    }
  }

  // ---------------------------------------------------------------------------
  // MAPPER
  // ---------------------------------------------------------------------------

  List<ProductModel> _mapQuerySnapshotToProducts(
    final QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return snapshot.docs
        .map((final doc) => ProductModel.fromFirestore(doc.data()))
        .toList();
  }
}

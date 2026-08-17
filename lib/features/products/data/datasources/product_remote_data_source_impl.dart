import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../../../core/util/date_formatter.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProductRemoteDataSourceImpl({
    required final FirebaseFirestore firestore,
    required final FirebaseStorage storage,
  })  : _firestore = firestore,
        _storage = storage;

  // ---------------------------------------------------------------------------
  // COLLECTION REF
  // ---------------------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> get _productRef =>
      _firestore.collection('Product');

  // ---------------------------------------------------------------------------
  // GET
  // ---------------------------------------------------------------------------

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await _productRef.get();
      return _mapSnapshot(snapshot);
    } catch (e) {
      _throwError('Ürünler yüklenirken hata oluştu', e);
    }
  }

  @override
  Future<ProductModel> getProductById(final String id) async {
    try {
      final doc = await _productRef.doc(id).get();

      if (!doc.exists) throw Exception('Ürün bulunamadı');

      return ProductModel.fromFirestore(doc.data()!);
    } catch (e) {
      _throwError('Ürün getirilirken hata oluştu', e);
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
    try {
      Query<Map<String, dynamic>> query = _productRef;

      if (condition != null)
        query =
            query.where('isSpotProduct', isEqualTo: condition == 'İkinci El');

      if (minPrice != null)
        query = query.where('price', isGreaterThanOrEqualTo: minPrice);

      if (maxPrice != null)
        query = query.where('price', isLessThanOrEqualTo: maxPrice);

      final snapshot = await query.get();
      return _mapSnapshot(snapshot);
    } catch (e) {
      _throwError('Ürünler filtrelenirken hata oluştu', e);
    }
  }

  // ---------------------------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------------------------

  @override
  Future<List<ProductModel>> searchProducts(final String queryText) async {
    try {
      final snapshot = await _productRef
          .where('name', isGreaterThanOrEqualTo: queryText)
          .where('name', isLessThan: '$queryText\uf8ff')
          .get();

      return _mapSnapshot(snapshot);
    } catch (e) {
      _throwError('Ürün araması sırasında hata oluştu', e);
    }
  }

  // ---------------------------------------------------------------------------
  // ADD
  // ---------------------------------------------------------------------------

  @override
  Future<void> addProduct(
      final ProductModel product, final List<dynamic> images) async {
    if (images.isEmpty) throw Exception('Yüklenecek görsel bulunamadı');

    try {
      final productId = _productRef.doc().id;
      final imageUrls = await _uploadImages(images, productId);
      final now = _formattedNow();

      final data = product.toFirestore();
      data['_id'] = productId;
      data['imagesUrl'] = imageUrls;
      // Stüdyo (arka plansız) görsel — admin panelinde fotoğraf SEÇİLİR
      // seçilmez, henüz buraya gelmeden ÖNCE üretilip product.studioImagesUrl
      // alanına yazılmış oluyor (bkz. add_product_page.dart /
      // edit_product_page.dart). Burada sadece yükleme sayısıyla aynı
      // uzunluğa hizalanıp olduğu gibi kaydediliyor.
      data['studioImagesUrl'] = _alignStudioUrls(product.studioImagesUrl, imageUrls.length);
      data['_createdAt'] = now;
      data['_updatedAt'] = now;
      data['_soldAt'] = '';

      // 3. Firestore'a yazma
      await _productRef.doc(productId).set(data);
    } catch (e) {
      _throwError('Ürün eklenirken hata oluştu', e);
    }
  }

  @override
  Future<void> updateProduct(
    final ProductModel product,
    final List<dynamic>? newImages,
  ) async {
    try {
      final imageUrls = await _handleImageUpdate(product, newImages);
      final now = _formattedNow();

      final updateData = {
        'imagesUrl': imageUrls,
        'studioImagesUrl': _alignStudioUrls(product.studioImagesUrl, imageUrls.length),
        '_updatedAt': now,
      };

      final fullData = product.toFirestore();
      fullData.addAll(updateData);

      await _productRef.doc(product.id).update(fullData);
    } catch (e) {
      _throwError('Ürün güncellenirken hata oluştu', e);
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------

  @override
  Future<void> deleteProduct(final String productId) async {
    try {
      await _productRef.doc(productId).delete();
    } catch (e) {
      _throwError('Ürün silinirken hata oluştu', e);
    }
  }

  // ---------------------------------------------------------------------------
  // IMAGE HELPERS
  // ---------------------------------------------------------------------------

  Future<List<String>> _handleImageUpdate(
    final ProductModel product,
    final List<dynamic>? newImages,
  ) async {
    if (newImages == null || newImages.isEmpty) return product.imagesUrl;

    await _deleteImages([...product.imagesUrl, ...product.studioImagesUrl]);
    return _uploadImages(newImages, product.id);
  }

  Future<List<String>> _uploadImages(
    final List<dynamic> images,
    final String productId,
  ) async {
    final List<String> urls = [];

    for (int i = 0; i < images.length; i++) {
      final ref = _storage.ref('product_images/$productId/$i.jpg');

      final image = images[i];

      if (image is File)
        await ref.putFile(image);
      else if (image is Uint8List)
        await ref.putData(image);
      else
        throw Exception('Geçersiz görsel türü');

      urls.add(await ref.getDownloadURL());
    }

    return urls;
  }

  /// [studio] dizisini [length] uzunluğa hizalar — eksik slotlar boş
  /// string ile doldurulur, fazlaları atılır. imagesUrl ile studioImagesUrl
  /// HER ZAMAN aynı uzunlukta olmalı (bkz. Product.studioImagesUrl doc'u).
  List<String> _alignStudioUrls(final List<String> studio, final int length) =>
      List.generate(length, (final i) => i < studio.length ? studio[i] : '');

  Future<void> _deleteImages(final List<String> imageUrls) async {
    for (final url in imageUrls) {
      if (url.isEmpty) continue;
      try {
        await _storage.refFromURL(url).delete();
      } catch (_) {}
    }
  }

  // ---------------------------------------------------------------------------
  // UTIL
  // ---------------------------------------------------------------------------

  List<ProductModel> _mapSnapshot(
          final QuerySnapshot<Map<String, dynamic>> snapshot) =>
      snapshot.docs
          .map((final doc) => ProductModel.fromFirestore(doc.data()))
          .toList();

  String _formattedNow() =>
      DateFormatter.parseFormattedDateTime(DateFormatter.nowFormatDateTime(),
              formatWithMonthName: false)['date']
          .toString();

  Never _throwError(final String message, final Object error) =>
      throw Exception('$message: $error');
}

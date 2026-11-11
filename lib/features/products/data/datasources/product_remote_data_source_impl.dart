import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    List<String> uploadedUrls = const [];
    try {
      final productId = _productRef.doc().id;
      final uploaded = await _uploadImages(images, productId);
      uploadedUrls = uploaded;
      // remove.bg ile üretilen "stüdyo" (arka plansız) görsel — admin
      // panelinde fotoğraf SEÇİLİR seçilmez, buraya gelmeden ÖNCE üretilip
      // product.studioImagesUrl alanına GEÇİCİ olarak taşınmış oluyor (bkz.
      // add_product_page.dart). Artık ayrı, gizli bir Firestore alanında
      // SAKLANMIYOR — doğrudan normal fotoğraf şeridine bir fotoğraf daha
      // olarak ekleniyor (Storage'daki dosya adı "studio-" ile başladığı
      // için hangisinin remove.bg çıktısı olduğu ayırt edilebiliyor).
      final imageUrls = [
        ...uploaded,
        ...product.studioImagesUrl.where((final u) => u.isNotEmpty),
      ];
      final now = _formattedNow();

      final data = product.toFirestore();
      data['_id'] = productId;
      data['imagesUrl'] = imageUrls;
      data['studioImagesUrl'] = const <String>[];
      data['_createdAt'] = now;
      data['_updatedAt'] = now;
      data['_soldAt'] = '';
      data['lastModifiedBy'] = FirebaseAuth.instance.currentUser?.email ?? '';

      // 3. Firestore'a yazma
      await _productRef.doc(productId).set(data);
    } catch (e) {
      // Firestore yazılamadıysa başarılı Storage yüklemeleri yetim kalmasın.
      if (uploadedUrls.isNotEmpty) await _deleteImages(uploadedUrls);
      _throwError('Ürün eklenirken hata oluştu', e);
    }
  }

  @override
  Future<void> updateProduct(
    final ProductModel product,
    final List<dynamic>? newImages,
  ) async {
    List<String> newlyUploadedUrls = const [];
    try {
      // Düzenlemeden ÖNCEKİ (canlıdaki) foto listesini oku — admin'in bu
      // turda GERÇEKTEN kaldırdığı dosyaları bulmanın tek yolu bu
      // (product.imagesUrl bu noktada zaten UI'da kalan/silinmemiş
      // listeyi taşıyor, "önce ne vardı" bilgisi başka yerde yok).
      final beforeSnap = await _productRef.doc(product.id).get();
      final beforeData = beforeSnap.data();
      final List<String> previousImageUrls = beforeData == null
          ? const []
          : List<String>.from(
              (beforeData['imagesUrl'] as List?) ?? const []);
      final List<String> previousStudioUrls = beforeData == null
          ? const []
          : List<String>.from(
              (beforeData['studioImagesUrl'] as List?) ?? const []);

      // Stüdyo görseli yalnızca YENİ fotoğraflarla birlikte imagesUrl'e
      // katılır (bkz. _handleImageUpdate) — bu turda katılım olduysa ayrı
      // alan boşaltılır, olmadıysa (fotoğraf değişmediyse) hiç dokunulmaz.
      final bool mergingNewStudio = newImages != null && newImages.isNotEmpty;
      final imageUrls = await _handleImageUpdate(product, newImages);
      final finalStudioUrls =
          mergingNewStudio ? const <String>[] : product.studioImagesUrl;
      if (newImages != null && newImages.isNotEmpty) {
        final int keptCount = product.imagesUrl.length;
        final int uploadedEnd = imageUrls.length -
            (mergingNewStudio ? product.studioImagesUrl.length : 0);
        if (uploadedEnd > keptCount) {
          newlyUploadedUrls = imageUrls.sublist(keptCount, uploadedEnd);
        }
      }
      final now = _formattedNow();

      // GÜVENLİK/VERİ KAYBI DÜZELTMESİ: eskiden burada, yeni fotoğraf
      // eklenirken admin'in KORUDUĞU mevcut fotoğraflar da Storage'dan
      // (ve nihai listeden) silinip sadece yeni seçilenler kalıyordu
      // (bkz. _handleImageUpdate'in eski hâli). Şimdi sadece gerçekten
      // kaldırılmış (önceden vardı, artık ne ana listede ne stüdyo
      // listesinde olan) dosyalar siliniyor — "bir foto kaldır"
      // kaldırılanı hem kayıttan hem depodan temizliyor, "yeni foto
      // ekle" eskileri yok etmiyor.
      final removed = [...previousImageUrls, ...previousStudioUrls]
          .where((final u) =>
              u.isNotEmpty &&
              !imageUrls.contains(u) &&
              !finalStudioUrls.contains(u))
          .toList();
      final updateData = {
        'imagesUrl': imageUrls,
        'studioImagesUrl': finalStudioUrls,
        '_updatedAt': now,
      };

      final fullData = product.toFirestore();
      fullData.addAll(updateData);
      fullData['lastModifiedBy'] = FirebaseAuth.instance.currentUser?.email ?? '';

      await _productRef.doc(product.id).update(fullData);

      // Eski dosyaları ancak Firestore kaydı başarıyla güncellendikten sonra
      // sil. Böylece kayıt başarısız olduğunda mevcut ürün fotoğrafsız kalmaz.
      if (removed.isNotEmpty) await _deleteImages(removed);
    } catch (e) {
      // Yeni yüklemeler kayda alınamadıysa Storage'da yetim bırakma.
      if (newlyUploadedUrls.isNotEmpty) {
        await _deleteImages(newlyUploadedUrls);
      }
      _throwError('Ürün güncellenirken hata oluştu', e);
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------

  @override
  Future<void> deleteProduct(final String productId) async {
    try {
      // Kalıcı silme yerine Cloud Function arşivler ve audit kaydı üretir.
      // Böylece ürün ve görseller geri yüklenebilir kalır.
      await FirebaseFunctions.instance.httpsCallable('archiveProduct').call({
        'productId': productId,
        'reason': 'admin_archive',
      });
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

    // `product.imagesUrl` bu noktada admin'in KORUDUĞU (X ile silmediği)
    // mevcut fotoğrafları taşır — eskiden burada hepsi silinip sadece
    // yeni seçilenler kalıyordu (admin "bir foto daha ekle" deyip eski
    // fotoğrafları hiç silmek istemese bile hepsi kayboluyordu). Şimdi
    // eskiler KORUNUYOR, yeni seçilenler dosya adı çakışmasın diye mevcut
    // sayıdan devam eden indekslerle yükleniyor.
    final uploaded = await _uploadImages(newImages, product.id,
        startIndex: product.imagesUrl.length);
    return [
      ...product.imagesUrl,
      ...uploaded,
      ...product.studioImagesUrl.where((final u) => u.isNotEmpty),
    ];
  }

  Future<List<String>> _uploadImages(
    final List<dynamic> images,
    final String productId, {
    final int startIndex = 0,
  }) async {
    final List<String> urls = [];

    for (int i = 0; i < images.length; i++) {
      final ref = _storage.ref('product_images/$productId/${startIndex + i}.jpg');

      final image = images[i];
      const maxImageBytes = 10 * 1024 * 1024;
      final int imageBytes = image is File
          ? await image.length()
          : image is Uint8List
              ? image.length
              : 0;
      if (imageBytes == 0 || imageBytes > maxImageBytes) {
        throw Exception('Görsel 10 MB sınırını aşamaz');
      }
      const metadata = SettableMetadata(contentType: 'image/jpeg');

      if (image is File)
        await ref.putFile(image, metadata);
      else if (image is Uint8List)
        await ref.putData(image, metadata);
      else
        throw Exception('Geçersiz görsel türü');

      urls.add(await ref.getDownloadURL());
    }

    return urls;
  }

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

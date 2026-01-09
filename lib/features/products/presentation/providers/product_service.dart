import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // kIsWeb için gerekli
import '../../domain/entites/product.dart';

class ProductService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadProduct(
      final Product product, final List<dynamic> images) async {
    final List<String> imageUrls = [];

    // 1. Görselleri Storage'a yükle
    for (int i = 0; i < images.length; i++) {
      if (i >= 8) break; // Maksimum 8 görsel sınırı

      // images listesindeki her bir elemanı alıyoruz
      final dynamic imageSource = images[i];

      // Dosya yolunu oluştur: products/benzersiz_id/img_0.jpg
      final String fileName = 'products/${product.id}/img_$i.jpg';
      final Reference ref = _storage.ref().child(fileName);

      final UploadTask uploadTask;

      // Platform kontrolü ve yükleme
      if (kIsWeb) // Web tarafında görüntüler genelde Uint8List veya XFile olarak gelir
        // Eğer images listesine XFile paslıyorsan:
        uploadTask = ref.putData(await imageSource.readAsBytes());
      else // Mobil tarafında File nesnesi kullanıyoruz
        uploadTask = ref.putFile(imageSource as File);

      // Yüklemenin tamamlanmasını bekle ve snapshot'ı al
      final TaskSnapshot snapshot = await uploadTask;

      // Linki al ve listeye ekle
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    // 2. Firestore kaydını güncelle/oluştur
    // Product entity'sinde copyWith metodu olduğundan emin olmalısın
    final finalProduct = product.copyWith(imagesUrl: imageUrls);

    // Koleksiyon isminin 'Product' (Rules'da büyük harf vermiştik) olduğuna dikkat et!
    await _firestore
        .collection('Product')
        .doc(product.id)
        .set(finalProduct.toMap());
  }
}

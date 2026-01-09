import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../domain/entites/product.dart';

class ProductService {
  // Firebase servislerini tanımlıyoruz
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadProduct(
      final Product product, final List<dynamic> images) async {
    final List<String> imageUrls = [];

    // 1. GÖRSELLERİ STORAGE'A YÜKLE
    for (int i = 0; i < images.length; i++) {
      if (i >= 8) break; // Endüstriyel sınır: Maksimum 8 görsel

      final dynamic imageSource = images[i];

      // Dosya yolunu oluşturuyoruz: products/benzersiz_id/img_0.jpg
      final String fileName = 'products/${product.id}/img_$i.jpg';
      final Reference ref = _storage.ref().child(fileName);

      final UploadTask uploadTask;

      // PLATFORM KONTROLÜ: Web ve Mobil farklı yöntemler kullanır
      if (kIsWeb)
        // Web tarafında dosyayı bytes (Uint8List) olarak yüklüyoruz
        uploadTask = ref.putData(await imageSource.readAsBytes());
      else
        // Mobil tarafında doğrudan File nesnesi kullanıyoruz
        uploadTask = ref.putFile(imageSource as File);

      // KRİTİK NOKTA: Yüklemenin tamamlanmasını bekle ve sonucu (snapshot) al
      final TaskSnapshot snapshot = await uploadTask;

      // Yüklenen dosyanın internet üzerinden erişilebilir linkini al
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // Linki listeye ekle
      imageUrls.add(downloadUrl);
    }

    // 2. FIRESTORE KAYDINI OLUŞTUR/GÜNCELLE
    // Görsel linklerini ürün nesnesine ekliyoruz
    final finalProduct = product.copyWith(imagesUrl: imageUrls);

    // Firestore'da 'Product' koleksiyonuna kaydediyoruz
    // Not: Rules'da koleksiyon adını 'Product' olarak belirlediysen burası uyumlu olmalı.
    await _firestore
        .collection('Product')
        .doc(product.id)
        .set(finalProduct.toMap());
  }
}

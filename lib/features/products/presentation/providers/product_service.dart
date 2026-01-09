import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/entites/product.dart';

class ProductService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadProduct(
      final Product product, final List<File> images) async {
    final List<String> imageUrls = [];

    // 1. Görselleri Storage'a yükle
    for (int i = 0; i < images.length; i++) {
      if (i >= 8) break; // Maksimum 8 görsel sınırı

      // Dosya yolunu oluştur: products/benzersiz_id/resim_0.jpg
      final String fileName = 'products/${product.id}/img_$i.jpg';
      final Reference ref = _storage.ref().child(fileName);

      // Yükleme işlemi
      final UploadTask uploadTask = ref.putFile(images[i]);
      final TaskSnapshot snapshot = await uploadTask;

      // Linki al ve listeye ekle
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    // 2. Firestore kaydını güncelle/oluştur
    final finalProduct = product.copyWith(imagesUrl: imageUrls);
    await _firestore
        .collection('products')
        .doc(product.id)
        .set(finalProduct.toMap());
  }
}

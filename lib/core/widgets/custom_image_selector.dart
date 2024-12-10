import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class ImageSelector {
  final ImagePicker _picker = ImagePicker();

  /// Görsel Seçimi
  Future<List<dynamic>> pickImages({bool allowMultiple = true}) async {
    List<dynamic> selectedFiles = [];

    if (kIsWeb) {
      // Pc den Web için dosya seçme işlemi
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        for (var file in pickedFiles) {
          // Web üzerinde Uint8List kullanıyoruz
          final byteData = await file.readAsBytes();
          selectedFiles.add(byteData); // Uint8List olarak ekle
        }
      }
    } else {
      // Mobilden web için dosya seçme
      final pickedFiles = allowMultiple
          ? await _picker.pickMultiImage()
          : [await _picker.pickImage(source: ImageSource.gallery)];
      if (pickedFiles != null) {
        selectedFiles.addAll(
          pickedFiles
              .map((file) => File(file!.path)), // File nesneleri olarak ekle
        );
      }
    }

    return selectedFiles;
  }
}

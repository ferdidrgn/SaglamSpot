import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class ImageSelector {
  final ImagePicker _picker = ImagePicker();

  /// Görsel Seçimi
  Future<List<dynamic>> pickImages({final bool allowMultiple = true}) async {
    final List<dynamic> selectedFiles = [];

    if (kIsWeb) {
      // Web üzerinde dosya seçme işlemi
      final pickedFiles = await _picker.pickMultiImage();
      for (final file in pickedFiles) {
        // Web üzerinde Uint8List kullanıyoruz
        final byteData = await file.readAsBytes();
        selectedFiles.add(byteData); // Uint8List olarak ekle
      }
        } else {
      // Mobil platformlarda dosya seçme işlemi
      final pickedFiles = allowMultiple
          ? await _picker.pickMultiImage()
          : [await _picker.pickImage(source: ImageSource.gallery)];

      selectedFiles.addAll(
        pickedFiles.map((final file) => File(file!.path)), // File nesneleri olarak ekle
      );
        }

    return selectedFiles;
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class ImageSelector {
  final ImagePicker _picker = ImagePicker();

  /// Görsel Seçimi
  Future<List<Uint8List>> pickImages({bool allowMultiple = true}) async {
    List<Uint8List> selectedFiles = [];

    if (kIsWeb) {
      // Web için dosya seçme işlemi
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        for (var file in pickedFiles) {
          final byteData = await file.readAsBytes();
          selectedFiles.add(byteData);
        }
      }
    } else {
      // Mobil için dosya seçme
      final pickedFiles = allowMultiple
          ? await _picker.pickMultiImage()
          : [await _picker.pickImage(source: ImageSource.gallery)];
      if (pickedFiles != null) {
        for (var file in pickedFiles) {
          if (file != null) {
            final byteData = await File(file.path).readAsBytes();
            selectedFiles.add(byteData);
          }
        }
      }
    }
    return selectedFiles;
  }
}
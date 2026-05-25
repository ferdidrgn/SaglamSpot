import 'package:flutter/foundation.dart';

abstract final class SeoServiceImplementation {
  /// Mobil cihazlarda tarayıcı başlığı olmadığı için sistemi yormadan boş döner.
  static void set({
    required final String title,
    final String? description,
    final String? currentUrl,
  }) {
    // Mobil platform performansı için log dışında işlem yapılmaz.
    debugPrint('📱 SEO Düzenleyici: Mobil platform modu aktif.');
  }

  static void updateDocumentHead({
    required final String title,
    required final String description,
    required final String currentUrl,
    final String? imageUrl,
  }) {
    debugPrint('📱 SEO Düzenleyici: Mobil platform arayüz modu aktif.');
  }
}

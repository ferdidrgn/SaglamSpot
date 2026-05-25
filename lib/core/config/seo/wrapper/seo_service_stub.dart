abstract final class SeoServiceImplementation {
  static void set({
    required final String title,
    final String? description,
    final String? currentUrl,
  }) {
    throw UnsupportedError('SEO Servisi başlatılamadı: Platform algılanamadı.');
  }

  static void updateDocumentHead({
    required final String title,
    required final String description,
    required final String currentUrl,
    final String? imageUrl,
  }) {
    throw UnsupportedError('SEO Servisi başlatılamadı: Platform algılanamadı.');
  }
}

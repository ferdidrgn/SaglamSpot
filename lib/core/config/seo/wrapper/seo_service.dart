import 'seo_service_stub.dart'
if (dart.library.html) 'seo_service_web.dart'
if (dart.library.io) 'seo_service_mobile.dart';

/// Tüm tarayıcılar ve mobil platformlar için platform bağımsız SEO köprüsü.
/// Derleyici derleme anında platforma göre doğru alt dosyayı otomatik yükler.
abstract class SeoService {
  static void set({
    required final String title,
    final String? description,
    final String? currentUrl,
  }) {
    // Platforma göre yönlendirilen alt sınıfın 'set' metodunu tetikler.
    SeoServiceImplementation.set(
      title: title,
      description: description,
      currentUrl: currentUrl,
    );
  }

  static void updateDocumentHead({
    required final String title,
    required final String description,
    required final String currentUrl,
    final String? imageUrl,
  }) {
    SeoServiceImplementation.updateDocumentHead(
      title: title,
      description: description,
      currentUrl: currentUrl,
      imageUrl: imageUrl,
    );
  }
}

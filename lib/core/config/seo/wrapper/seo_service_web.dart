import 'dart:html'
    as html; // Sadece web ortamında yükleneceği kesinleştiği için artık güvenlidir
import 'package:flutter/foundation.dart';

abstract final class SeoServiceImplementation {
  /// Web tarayıcılarında HTML DOM ağacına dinamik enjeksiyon yapar.
  static void set({
    required final String title,
    final String? description,
    final String? currentUrl,
  }) {
    try {
      // 1. Tarayıcı Sekme Başlığı Güncellemesi
      html.document.title = title;

      // 2. Arama Motoru Robot Açıklamaları (Google, Yandex, Opera, Firefox)
      if (description != null) {
        _executeMetaEnjection('name', 'description', description);
      }
      _executeMetaEnjection('name', 'keywords',
          'sağlam spot, modern mobilya, ikinci el mobilya, lüks tasarım, koltuk takımı');

      // 3. OpenGraph Protokol Verileri (Safari ve Sosyal Medya Paylaşım Botları İçin)
      _executeMetaEnjection('property', 'og:title', title);
      if (description != null) {
        _executeMetaEnjection('property', 'og:description', description);
      }

      final String safeUrl = currentUrl ?? 'https://saglamspotcu.web.app/';
      _executeMetaEnjection('property', 'og:url', safeUrl);
      _executeMetaEnjection('property', 'og:type', 'website');

      // 4. Yinelenen içerik (Duplicate Content) hatasını engellemek için Canonical Link güncellemesi
      _injectCanonicalLink(safeUrl);
    } catch (e) {
      debugPrint('⚠️ Web SEO DOM Enjeksiyon Hatası: $e');
    }
  }

  static void updateDocumentHead({
    required final String title,
    required final String description,
    required final String currentUrl,
    final String? imageUrl,
  }) {
    set(title: title, description: description, currentUrl: currentUrl);
    if (imageUrl != null) {
      _executeMetaEnjection('property', 'og:image', imageUrl);
    }
  }

  static void _executeMetaEnjection(
      final String type, final String value, final String content) {
    final html.Element? existingTag =
        html.document.head?.querySelector('meta[$type="$value"]');
    if (existingTag != null) {
      existingTag.setAttribute('content', content);
    } else {
      final html.MetaElement newTag = html.MetaElement()
        ..setAttribute(type, value)
        ..content = content;
      html.document.head?.append(newTag);
    }
  }

  static void _injectCanonicalLink(final String url) {
    final html.Element? existingLink =
        html.document.head?.querySelector('link[rel="canonical"]');
    if (existingLink != null) {
      existingLink.setAttribute('href', url);
    } else {
      final html.LinkElement newLink = html.LinkElement()
        ..rel = 'canonical'
        ..href = url;
      html.document.head?.append(newLink);
    }
  }
}

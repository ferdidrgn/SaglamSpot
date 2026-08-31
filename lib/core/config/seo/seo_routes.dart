import 'package:flutter/widgets.dart';
import '../../common/extentions/app_context_ui_extension.dart';
import 'wrapper/seo_service.dart';

/// Canlı sitenin gerçek domaini — index.html, sitemap.xml, robots.txt ve
/// FurnitureShareService (deep link imzalama) ile AYNI olmalı. Farklı bir
/// domain kullanmak canonical/OpenGraph URL'lerini gerçek siteden koparır.
const String _domain = 'https://saglamspotcu.web.app';

/// Sayfa geçişlerinde tarayıcı sekmesi başlığını, meta açıklamasını ve
/// canonical/OpenGraph URL'ini günceller — Google, Yandex, Bing dahil tüm
/// arama motorları ve Safari/WhatsApp/Facebook gibi paylaşım botları için.
///
/// [routeName], GoRouter'daki `GoRoute(name: ...)` değeriyle birebir
/// eşleşir (bkz. app_router.dart) — rota YOLU değil, rota ADI kullanılıyor
/// çünkü bu, bir NavigatorObserver içinden güvenle okunabilen tek bilgi
/// (GoRouterState.of(context), henüz o rotanın alt ağacında olmayan bir
/// context'ten güvenilir şekilde okunamıyor).
final class SeoRoutes {
  const SeoRoutes._();

  static void update(final BuildContext context, final String? routeName) {
    final l10n = context.l10n;

    switch (routeName) {
      case 'home':
        SeoService.set(
            title: l10n.seoHomeTitle,
            description: l10n.seoHomeDesc,
            currentUrl: '$_domain/');
        break;
      case 'new-products':
        SeoService.set(
            title: l10n.seoNewTitle,
            description: l10n.seoNewDesc,
            currentUrl: '$_domain/new');
        break;
      case 'spot-products':
        SeoService.set(
            title: l10n.seoSpotTitle,
            description: l10n.seoSpotDesc,
            currentUrl: '$_domain/spot');
        break;
      case 'about':
        SeoService.set(
            title: l10n.seoAboutTitle,
            description: l10n.seoAboutDesc,
            currentUrl: '$_domain/about');
        break;
      case 'sss':
        SeoService.set(
            title: l10n.seoSssTitle,
            description: l10n.seoSssDesc,
            currentUrl: '$_domain/sss');
        break;
      case 'search':
        SeoService.set(
            title: l10n.seoSearchTitle,
            description: l10n.seoSearchDesc,
            currentUrl: '$_domain/search');
        break;
      case 'privacy':
        SeoService.set(
            title: l10n.seoPrivacyTitle,
            description: l10n.seoHomeDesc,
            currentUrl: '$_domain/privacy');
        break;
      case 'terms':
        SeoService.set(
            title: l10n.seoTermsTitle,
            description: l10n.seoHomeDesc,
            currentUrl: '$_domain/terms');
        break;
      case 'productDetail':
        // Ürün detay sayfası kendi (gerçek ürün adı/fiyatı/görseliyle)
        // SEO güncellemesini kendi içinde yapar (bkz. ProductDetailPage) —
        // burada genel bir yer tutucuya gerek yok, o zaten daha isabetli.
        break;
      default:
        // /admin, /cart, /favorites, /settings, /notifications, /login,
        // /onboarding gibi özel/indekslenmemesi gereken sayfalar — bunlar
        // zaten robots.txt üzerinden taranmaktan muaf tutuluyor, burada
        // meta etiketlerine dokunmuyoruz.
        break;
    }
  }
}

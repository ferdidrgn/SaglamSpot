import 'package:flutter/material.dart';
import 'wrapper/seo_service.dart';

class SeoRouteObserver extends NavigatorObserver {
  @override
  void didPush(final Route<dynamic> route, final Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _evaluateSEOData(route);
  }

  @override
  void didPop(final Route<dynamic> route, final Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null)
      _evaluateSEOData(previousRoute);
  }

  void _evaluateSEOData(final Route<dynamic> route) {
    final String? currentRouteName = route.settings.name;

    switch (currentRouteName) {
      case 'home':
        SeoService.updateDocumentHead(
          title: 'Sağlam Spot | Modern Mobilya ve Lüks Yaşam Alanları',
          description: 'Sağlam Spot ile evinizde rafine çizgiler oluşturun. İkinci el ve modern mobilyada lider tasarım showroomu.',
          currentUrl: 'https://saglamspot.com/',
        );
        break;
      case 'new-products':
        SeoService.updateDocumentHead(
          title: 'Yeni Gelenler | Sağlam Spot Editoryal Koleksiyonu',
          description: 'En son eklenen mimari mobilya tasarımlarını ve spot lüks koleksiyon ürünlerini inceleyin.',
          currentUrl: 'https://saglamspot.com/new',
        );
        break;
      case 'spot-products':
        SeoService.updateDocumentHead(
          title: 'Spot Mobilya Vitrini | Sağlam Spot Avantajları',
          description: 'Kalite ve minimalist estetiği bir arada sunan kurumsal spot mobilya listesi.',
          currentUrl: 'https://saglamspot.com/spot',
        );
        break;
      default:
        break;
    }
  }
}

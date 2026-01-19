import 'package:flutter/widgets.dart';
import '../../common/extentions/app_context_ui_extension.dart';
import 'seo_service.dart';

final class SeoRoutes {
  const SeoRoutes._();

  static void update(final BuildContext context, final String location) {
    final l10n = context.l10n;

    // Dinamik Ürün Detay SEO
    if (location.startsWith('/product/')) {
      SeoService.set(
          title: l10n.seoProductDetailSuffix, description: l10n.seoHomeDesc);
      return;
    }

    // Statik Sayfa SEO
    switch (location) {
      case '/':
        SeoService.set(title: l10n.seoHomeTitle, description: l10n.seoHomeDesc);
        break;
      case '/new':
        SeoService.set(title: l10n.seoNewTitle, description: l10n.seoNewDesc);
        break;
      case '/spot':
        SeoService.set(title: l10n.seoSpotTitle, description: l10n.seoSpotDesc);
        break;
      case '/about':
        SeoService.set(
            title: l10n.seoAboutTitle, description: l10n.seoAboutDesc);
        break;
      default:
        SeoService.set(title: 'Sağlam Spot');
    }
  }
}

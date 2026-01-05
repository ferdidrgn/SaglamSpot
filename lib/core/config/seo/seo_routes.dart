import 'seo_service.dart';

final class SeoRoutes {
  const SeoRoutes._();

  static void update(final String location) {
    switch (location) {
      case '/':
        SeoService.set(
          title: 'Sağlam Spot | Spot & Sıfır Mobilya',
          description: 'Spot ve sıfır mobilyalarda en uygun fiyatlar',
        );
        break;

      case '/new':
        SeoService.set(
          title: 'Sıfır Ürünler | Sağlam Spot',
          description: 'Garantili sıfır mobilya ürünleri',
        );
        break;

      case '/spot':
        SeoService.set(
          title: 'Spot Ürünler | Sağlam Spot',
          description: 'Uygun fiyatlı spot mobilya ürünleri',
        );
        break;

      case '/about':
        SeoService.set(
          title: 'Hakkımızda | Sağlam Spot',
          description: '20 yıllık esnaf tecrübesi',
        );
        break;

      case '/sss':
        SeoService.set(
          title: 'SSS | Sağlam Spot',
          description: 'Sıkça sorulan sorular',
        );
        break;

      default:
        SeoService.set(title: 'Sağlam Spot');
    }
  }
}

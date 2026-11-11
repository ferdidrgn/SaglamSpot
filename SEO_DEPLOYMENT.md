# Sağlam Spot web SEO ve reklam yayını

## Kod tarafında tamamlananlar

- Canlı `web-genesis` HTML şablonuna Google Search Console doğrulama etiketi,
  Analytics, AdSense publisher scripti, manifest, canonical, Open Graph,
  Twitter card ve WebSite/SearchAction JSON-LD eklendi.
- Home sayfasında FurnitureStore JSON-LD; ürün detaylarında Product JSON-LD
  korunuyor.
- `/robots.txt` gerçek canlı rotalarla güncellendi.
- `/sitemap.xml` ve `/sitemap-products.xml` aynı dinamik, aktif ürün sitemap'ini
  sunuyor.
- `ads.txt` ve `app-ads.txt` publisher kimliğiyle canlı hosting klasöründe.
- Android `assetlinks.json` yayında.

## Google Search Console'da yapılacaklar

1. Search Console'a `https://saglamspotcu.web.app` alanını ekleyin.
2. Mülkiyet doğrulaması için mevcut HTML meta etiketini seçin veya DNS kaydı ekleyin.
3. Sitemap olarak şu iki adresi gönderin:
   - `https://saglamspotcu.web.app/sitemap.xml`
   - `https://saglamspotcu.web.app/sitemap-products.xml`
4. URL Inspection ile ana sayfa, `/sifir`, `/spot` ve bir ürün URL'sini test edin.
5. İlk taramadan sonra Coverage/Pages, Enhancements ve Core Web Vitals raporlarını
   kontrol edin.

## AdSense'de yapılacaklar

1. AdSense Sites bölümüne `saglamspotcu.web.app` ekleyin.
2. `ads.txt` durumunun Authorized/Yetkili olduğunu bekleyin.
3. Site incelemesi tamamlandıktan sonra Auto ads veya manuel reklam birimlerini
   açın.
4. Reklamları yalnızca gerçek içerik bulunan sayfalarda kullanın; admin, login,
   boş durum ve hata sayfalarında reklam göstermeyin.

## Manuel kalan deeplink ayarı

`apple-app-site-association` içindeki `TODO_APPLE_TEAM_ID` yerine Apple Developer
hesabındaki gerçek Team ID yazılmalı. Bu bilgi repo/Firebase'den güvenilir şekilde
çıkarılamaz; Apple Developer hesabından alınmalıdır. Android assetlinks parmak izi
mevcut release sertifikasıyla eşleşmelidir.

# web-genesis

SaglamSpot'un yeni web vitrini — sıfırdan HTML/CSS/JS, mevcut Flutter web
uygulamasından (`web/`, `lib/`, ana `functions/`) tamamen ayrı. Mimari: her
istek Node.js/Express ile sunucu tarafında (SSR) gerçek HTML olarak render
edilir (bkz. `functions/src/app.js`), aynı Firebase projesindeki (ve aynı
Firestore `Product` koleksiyonundaki) veriyle. Ayrıntılı yol haritası ve
mimari gerekçe için oturum geçmişine bakın.

## Yerel geliştirme

```
cd web-genesis/functions && npm install
cd ../..
firebase emulators:start --only functions,hosting --project saglamspotflutter-2a1a8
```

Site `http://127.0.0.1:5005` adresinde (hosting target: `genesis`) açılır.
Firestore emulator'ı çalıştırılmadığı için bu, GERÇEK (production) Firestore
verisini OKUR — bilerek: Faz 0/1'de ayrı bir emulator veri seti kurmak yerine
gerçek ürün verisiyle çalışmak daha basit. Hiçbir yazma işlemi yapılmıyor.

## Deploy — tek seferlik kurulum gerekir

Bu branch main'deki hosting site'ına (`saglamspotcu`) veya functions
codebase'ine (`default`) HİÇ dokunmaz; ayrı bir hosting site + ayrı bir
functions codebase (`genesis`) kullanır. İlk deploy'dan önce, Firebase'e
giriş yapmış biri (bu repoda zaten `firebase login` yapılmış durumda) BİR
KEREYE MAHSUS şu site'ı oluşturmalı:

```
firebase hosting:sites:create saglamspot-genesis --project saglamspotflutter-2a1a8
```

Bundan sonra deploy:

```
firebase deploy --only hosting:genesis,functions:genesis --project saglamspotflutter-2a1a8
```

Bu site oluşturma adımı canlı/paylaşılan bir altyapı değişikliği olduğu için
otomatik yapılmadı — kullanıcı onayı/komutu gerekiyor.

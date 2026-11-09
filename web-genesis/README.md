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

## Deploy

GÜNCELLEME: Bu bölüm önceden "ayrı bir `saglamspot-genesis` site'ı kur,
`saglamspotcu`'ya hiç dokunma" planını anlatıyordu — bu artık DOĞRU DEĞİL.
web-genesis o ayrı deneme aşamasından sonra canlıya ALINDI: `firebase.json`
şu an `saglamspotcu` sitesinin TEK hosting girdisini (tüm istekler) bu
klasördeki `genesisApp` fonksiyonuna (codebase: `genesis`) yönlendiriyor —
yani `saglamspotcu.web.app` bugün GERÇEKTEN web-genesis'i sunuyor, eski
Flutter web/`functions` (root) pipeline'ı artık orphan (bkz. ana
`README.md`'nin "🌐 Web" bölümündeki güncel not). Ayrı bir
`saglamspot-genesis` site'ı hiç oluşturulmadı/kullanılmadı.

Canlı deploy (main veya `web-genesis` dalına push'ta GitHub Actions
`.github/workflows/deploy-web.yml` ile otomatik):

```
firebase deploy --only hosting:saglamspotcu,functions:genesis:genesisApp --project saglamspotflutter-2a1a8
```

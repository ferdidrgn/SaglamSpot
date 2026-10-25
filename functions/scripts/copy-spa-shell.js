/**
 * `prerender` Cloud Function'ının insan ziyaretçilere döndürdüğü SPA
 * kabuğunu (functions/public/index.html) GERÇEK Flutter web derlemesinin
 * çıktısından (build/web/index.html) kopyalar.
 *
 * Her `firebase deploy` öncesi (önce `flutter build web --release`, SONRA
 * bu script) çalıştırılmalı — aksi halde fonksiyon eski/güncel olmayan bir
 * kabuk döndürür (yeni Flutter sürümü yayınlanmış olsa bile ziyaretçiler
 * eski derlemeyi görmeye devam eder).
 *
 * Çalıştırma: `node scripts/copy-spa-shell.js` (functions/ klasöründen)
 * veya firebase.json'daki functions "predeploy" kancasından otomatik.
 */
const fs = require("fs");
const path = require("path");

const SOURCE = path.join(__dirname, "..", "..", "build", "web", "index.html");
const DEST_DIR = path.join(__dirname, "..", "public");
const DEST = path.join(DEST_DIR, "index.html");

if (!fs.existsSync(SOURCE)) {
  console.error(
      "copy-spa-shell: build/web/index.html bulunamadı.\n" +
      "Önce `flutter build web --release` çalıştırın, sonra bu scripti tekrar çalıştırın.",
  );
  process.exit(1);
}

fs.mkdirSync(DEST_DIR, {recursive: true});
fs.copyFileSync(SOURCE, DEST);
console.log(`copy-spa-shell: ${SOURCE} -> ${DEST} kopyalandı.`);

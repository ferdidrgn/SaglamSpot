/**
 * Cloud Functions'a deploy edilen paket SADECE "web-genesis/functions"
 * klasörünü içerir (bkz. firebase.json -> functions[].source) — repo
 * kökündeki `lib/l10n/*.arb` dosyaları (i18n.js'in tek çeviri kaynağı)
 * canlıda HİÇ yok, bu yüzden `t()` her zaman anahtarın kendisine düşer
 * (ör. anasayfada "heroTitle" yazar, "Minimalist Konforun Zirvesi" değil).
 *
 * Bu script ARB dosyalarını deploy paketinin İÇİNE (functions/l10n/) her
 * `firebase deploy`'dan ÖNCE kopyalar — firebase.json'daki "predeploy"
 * kancasından otomatik çalışır. Yerel emülatörde (predeploy çalışmaz)
 * i18n.js yine de repo kökündeki orijinal dosyaya düşebiliyor (bkz.
 * i18n.js'teki iki adaylı okuma), bu yüzden burayı atlamak yerel
 * geliştirmeyi bozmaz.
 *
 * Çalıştırma: `node web-genesis/functions/scripts/copy-arb.js` (repo
 * kökünden) veya firebase.json'daki predeploy kancasından otomatik.
 */
const fs = require("fs");
const path = require("path");

const SOURCE_DIR = path.join(__dirname, "..", "..", "..", "lib", "l10n");
const DEST_DIR = path.join(__dirname, "..", "l10n");

if (!fs.existsSync(SOURCE_DIR)) {
  console.error(`copy-arb: kaynak klasör bulunamadı: ${SOURCE_DIR}`);
  process.exit(1);
}

fs.mkdirSync(DEST_DIR, {recursive: true});

const files = fs.readdirSync(SOURCE_DIR).filter((f) => f.endsWith(".arb"));
if (!files.length) {
  console.error(`copy-arb: ${SOURCE_DIR} içinde .arb dosyası bulunamadı.`);
  process.exit(1);
}

for (const file of files) {
  fs.copyFileSync(path.join(SOURCE_DIR, file), path.join(DEST_DIR, file));
}

console.log(`copy-arb: ${files.length} .arb dosyası ${SOURCE_DIR} -> ${DEST_DIR} kopyalandı.`);

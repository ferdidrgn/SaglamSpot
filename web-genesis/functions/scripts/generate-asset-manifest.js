/**
 * Cloud Functions'a deploy edilen paket SADECE "web-genesis/functions"
 * klasörünü içerir (bkz. firebase.json -> functions[].source) —
 * "web-genesis/public" (Hosting'in sunduğu statik dosyalar) canlıda bu
 * paketin İÇİNDE DEĞİL. render/layout.js'teki versionedAsset() statik
 * dosyaların içerik hash'ini URL'e (?v=hash) eklemek için o dosyaları
 * DİREKT OKUMAYA çalışıyordu — canlıda bu okuma hep başarısız oluyor,
 * sessizce "v=0" sabit değerine düşüyordu. Sonuç: her deploy'dan sonra
 * `/static/**`'in `Cache-Control: immutable` başlığıyla önbelleğe alınan
 * eski CSS/JS, URL'si HİÇ değişmediği için tarayıcıda SONSUZA KADAR
 * kalıyordu — yeni bir CSS/JS deploy edilse bile kullanıcılar eskisini
 * görmeye devam ediyordu.
 *
 * Bu script, hash'leri ÖNCEDEN (deploy zamanında) hesaplayıp deploy
 * paketinin İÇİNE (functions/assetManifest.json) yazıyor — firebase.json
 * "predeploy" kancasından otomatik çalışır. versionedAsset() artık önce
 * bu manifesti okuyor, sadece o yoksa (yerel emülatör gibi repo'nun
 * tamamı diskte olan ortamlarda) doğrudan dosya okumaya düşüyor.
 *
 * Çalıştırma: `node web-genesis/functions/scripts/generate-asset-manifest.js`
 * (repo kökünden) veya firebase.json'daki predeploy kancasından otomatik.
 */
const fs = require("fs");
const path = require("path");
const crypto = require("crypto");

const PUBLIC_DIR = path.join(__dirname, "..", "..", "public");
const OUT_FILE = path.join(__dirname, "..", "assetManifest.json");

function walk(dir, baseDir, out) {
  for (const entry of fs.readdirSync(dir, {withFileTypes: true})) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      walk(fullPath, baseDir, out);
      continue;
    }
    const relativePath = path.relative(baseDir, fullPath).split(path.sep).join("/");
    const content = fs.readFileSync(fullPath);
    out[relativePath] = crypto.createHash("sha256").update(content).digest("hex").slice(0, 10);
  }
}

if (!fs.existsSync(PUBLIC_DIR)) {
  console.error(`generate-asset-manifest: kaynak klasör bulunamadı: ${PUBLIC_DIR}`);
  process.exit(1);
}

const manifest = {};
walk(PUBLIC_DIR, PUBLIC_DIR, manifest);
fs.writeFileSync(OUT_FILE, JSON.stringify(manifest));

console.log(`generate-asset-manifest: ${Object.keys(manifest).length} dosya hash'lendi -> ${OUT_FILE}`);

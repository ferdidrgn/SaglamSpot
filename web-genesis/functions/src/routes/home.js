const {renderLayout, escapeHtml} = require("../render/layout");
const {renderProductGrid} = require("../render/productCard");
const {listActiveProducts, countSoldProducts} = require("../productRepo");
const {CATEGORY_LABELS, categoryPhoto} = require("../categories");
const {ICONS} = require("../render/icons");
const business = require("../businessInfo");
const {t} = require("../i18n");
const {NEW_BADGE_GREEN, SPOT_ACCENT} = require("../catalogTheme");
const {renderTicker} = require("../render/trustTicker");

// home_page_web.dart'taki _heroImages ile AYNI 3 fotoğraf.
const HERO_IMAGES = [
  "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=1600",
  "https://images.unsplash.com/photo-1581539250439-c96689b516dd?q=80&w=1600",
  "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=1600",
];

function renderHero(locale, products) {
  const slidesHtml = HERO_IMAGES.map((url, i) => `
    <div class="hero-slide${i === 0 ? " is-active" : ""}"><img src="${escapeHtml(url)}" alt="" loading="${i === 0 ? "eager" : "lazy"}"></div>`).join("");
  const dotsHtml = HERO_IMAGES.map((_, i) => `<button type="button" class="hero-dot${i === 0 ? " is-active" : ""}" aria-label="${i + 1}"></button>`).join("");

  const featured = products.slice(0, 2);
  const featuredHtml = featured.length ? `<div class="hero-featured-stack">${featured.map((p, i) => `
    <a class="hero-featured-card" href="${escapeHtml(p.path)}">
      <span class="hero-featured-thumb">${p.image ? `<img src="${escapeHtml(p.image)}" alt="" loading="lazy">` : ""}</span>
      <span class="hero-featured-info">
        <p class="hero-featured-num">${i + 1}.</p>
        <p class="hero-featured-name">${escapeHtml(p.name)}</p>
        <p class="hero-featured-meta" dir="ltr">${escapeHtml(p.priceLabel)}</p>
      </span>
    </a>`).join("")}</div>` : "";

  return `
<section class="hero-banner" data-hero-carousel>
  ${slidesHtml}
  <div class="hero-banner-scrim" aria-hidden="true"></div>
  <div class="hero-content">
    <span class="hero-eyebrow-pill">${escapeHtml(t(locale, "newSeason"))}</span>
    <h1>${escapeHtml(t(locale, "heroTitle")).replace(/\n/g, "<br>")}</h1>
    <p>${escapeHtml(t(locale, "featureArtisan"))}</p>
    <div class="hero-pill-row">
      <a class="hero-pill hero-pill-light" href="/sifir">${ICONS.newReleases} ${escapeHtml(t(locale, "conditionNew"))}</a>
      <a class="hero-pill hero-pill-accent" href="/spot">${ICONS.history} ${escapeHtml(t(locale, "conditionUsed"))}</a>
      <a class="hero-pill hero-pill-outline" href="/arama">${ICONS.explore} ${escapeHtml(t(locale, "exploreButton"))}</a>
    </div>
  </div>
  <button type="button" class="hero-arrow hero-arrow-prev" aria-label="${escapeHtml(t(locale, "exploreButton"))}">${ICONS.chevronLeft}</button>
  <button type="button" class="hero-arrow hero-arrow-next" aria-label="${escapeHtml(t(locale, "exploreButton"))}">${ICONS.chevronRight}</button>
  <div class="hero-dots">${dotsHtml}</div>
  ${featuredHtml}
</section>`;
}

function renderCategoryRail(locale) {
  const allChip = `<a class="category-chip" href="/arama">
    <span class="category-chip-avatar is-all">${ICONS.grid}</span>
    <span class="category-chip-label">${escapeHtml(t(locale, "conditionAll"))}</span>
  </a>`;
  const chips = Object.keys(CATEGORY_LABELS).map((key) => {
    const label = t(locale, "category" + key.charAt(0).toUpperCase() + key.slice(1));
    return `<a class="category-chip" href="/arama?category=${encodeURIComponent(key)}">
      <span class="category-chip-avatar"><img src="${escapeHtml(categoryPhoto(key))}" alt="" loading="lazy"></span>
      <span class="category-chip-label">${escapeHtml(label)}</span>
    </a>`;
  }).join("");
  return `<nav class="category-rail" aria-label="${escapeHtml(t(locale, "category"))}">${allChip}${chips}</nav>`;
}

function renderGatewayCards(locale, newProducts, spotProducts) {
  function card({eyebrow, title, subtitle, count, accent, glowVar, icon, button, href}) {
    return `
<a class="gateway-card gateway-card-${glowVar}" href="${href}" style="--glow-color:${accent}">
  <div class="gateway-glow" aria-hidden="true"></div>
  <div class="gateway-icon" aria-hidden="true">${icon}</div>
  <p class="gateway-eyebrow" style="--eyebrow-color:${accent}">${escapeHtml(eyebrow)}</p>
  <h3 class="gateway-title">${escapeHtml(title)}</h3>
  <p class="gateway-sub">${escapeHtml(subtitle)}</p>
  <div class="gateway-row">
    <span class="gateway-count">${escapeHtml(t(locale, "gatewayProductCount", {count}))}</span>
    <span class="gateway-cta">${escapeHtml(button)} ${ICONS.chevronRight}</span>
  </div>
</a>`;
  }

  return `<div class="gateway-grid">
    ${card({
    eyebrow: t(locale, "gatewayNewEyebrow"),
    title: t(locale, "gatewayNewTitle"),
    subtitle: t(locale, "gatewayNewSubtitle"),
    count: newProducts.length,
    accent: NEW_BADGE_GREEN,
    glowVar: "new",
    icon: ICONS.chair,
    button: t(locale, "gatewayNewButton"),
    href: "/sifir",
  })}
    ${card({
    eyebrow: t(locale, "gatewaySpotEyebrow"),
    title: t(locale, "gatewaySpotTitle"),
    subtitle: t(locale, "gatewaySpotSubtitle"),
    count: spotProducts.length,
    accent: SPOT_ACCENT,
    glowVar: "spot",
    icon: ICONS.tag,
    button: t(locale, "gatewaySpotButton"),
    href: "/spot",
  })}
  </div>`;
}

function renderBentoGrid(locale) {
  const items = [
    {icon: ICONS.handshake, label: t(locale, "featureArtisan"), color: "var(--color-accent)", cls: "bento-tile-1"},
    {icon: ICONS.shieldCheck, label: t(locale, "featureDelivery"), color: "var(--color-success)", cls: "bento-tile-2"},
    {icon: ICONS.smile, label: t(locale, "featureService"), color: "var(--color-warning)", cls: "bento-tile-3"},
    {icon: ICONS.truck, label: t(locale, "featureShipping"), color: "var(--color-info)", cls: "bento-tile-4"},
  ];
  return `<div class="bento-grid">${items.map((it) => `
    <div class="bento-tile ${it.cls}" style="--tile-color:${it.color}">
      <span class="bento-tile-icon">${it.icon}</span>
      <span class="bento-tile-label">${escapeHtml(it.label)}</span>
    </div>`).join("")}</div>`;
}

function renderRoomsPanel(locale) {
  const cards = Object.keys(CATEGORY_LABELS).filter((k) => k !== "other").map((key) => {
    const label = t(locale, "category" + key.charAt(0).toUpperCase() + key.slice(1));
    return `
    <a class="room-card" href="/arama?category=${encodeURIComponent(key)}">
      <img src="${escapeHtml(categoryPhoto(key))}" alt="" loading="lazy">
      <div class="room-card-overlay">
        <span class="room-card-eyebrow">${escapeHtml(t(locale, "byRoomSub"))}</span>
        <span class="room-card-title">${escapeHtml(label)}</span>
      </div>
    </a>`;
  }).join("");

  return `
<div class="rooms-panel">
  <div class="rooms-text">
    <h2>${escapeHtml(t(locale, "byRoom"))}</h2>
    <p>${escapeHtml(t(locale, "byRoomSub"))}</p>
    <a class="hero-pill hero-pill-accent" style="align-self:flex-start" href="/arama">${ICONS.explore} ${escapeHtml(t(locale, "exploreButton"))}</a>
  </div>
  <div class="rooms-collage">${cards}</div>
</div>`;
}

// lib/core/widgets/business_info_showcase.dart'taki canlı harita +
// "şu an açık/kapalı" göstergesinin web karşılığı. "Şu an Açık/Kapalı"
// için ARB'de bağımsız bir anahtar yok (brief: yeniden çeviri yok) —
// "Rezerve"/"SATILDI" emsaliyle aynı gerekçeyle Türkçe literal.
function renderStoreInfo(locale) {
  const openNow = business.isOpenNow;
  const mapSrc = `https://www.google.com/maps?q=${business.geo.latitude},${business.geo.longitude}&z=16&output=embed`;
  return `
<div class="store-info-panel">
  <div class="store-info-map">
    <iframe src="${escapeHtml(mapSrc)}" loading="lazy" referrerpolicy="no-referrer-when-downgrade" title="${escapeHtml(business.brandName)} konum haritası"></iframe>
  </div>
  <div class="store-info-card">
    <span class="store-status-pill ${openNow ? "is-open" : "is-closed"}">
      <span class="store-status-dot"></span>${openNow ? "Şu an Açık" : "Şu an Kapalı"}
    </span>
    <p class="store-info-address">${escapeHtml(business.address.line)}<br>${escapeHtml(business.address.district)}/${escapeHtml(business.address.city)}</p>
    <p class="store-info-hours">${escapeHtml(business.workingHours).replace(/\n/g, "<br>")}</p>
    <div class="hero-pill-row">
      <a class="hero-pill hero-pill-accent" href="${escapeHtml(business.googleMapsUrl)}" target="_blank" rel="noopener">${ICONS.map} ${escapeHtml(t(locale, "aboutViewMapButton"))}</a>
      <a class="hero-pill hero-pill-outline" style="color:var(--color-text-primary);border-color:var(--color-border)" href="tel:+${business.phoneNumberIntl}">${ICONS.explore} ${escapeHtml(business.displayPhone)}</a>
    </div>
  </div>
</div>`;
}

// "Uzmanından Bakım Önerileri" — saglamspotcu.web.app ana sayfasının
// (bu projenin KENDİ Flutter web derlemesi) karşılığı: kısa, pratik
// mobilya bakım tüyoları. İlk 10'u ARB'deki GERÇEK, 11 dile çevrilmiş
// tip1..tip10 anahtarlarından (lib/l10n/app_*.arb) — önceden bu 4 kart
// bu anahtarları HİÇ kullanmıyor, kendi başına yazılmış (ve ARB'dekiyle
// örtüşen ama birebir aynı olmayan) Türkçe literal metin taşıyordu.
// Kalan 15'i ("en az 15 tane daha ekle, kimsenin bilmediği pratik
// ipuçları" — kullanıcı isteği) ARB'de karşılığı yok, "Rezerve"/admin
// paneli emsaliyle AYNI gerekçeyle bilerek Türkçe literal. Görseller
// CATEGORY_PHOTOS'taki (zaten doğrulanmış) fotoğraflar — kart sayısı
// artık viewport'a sığandan fazla olduğu için .care-tips-row'daki
// (zaten var olan, hiç tetiklenmemiş) yatay scroll/snap devreye giriyor.
function renderCareTips(locale) {
  const arbTipMeta = [
    {icon: ICONS.sofaCare, image: categoryPhoto("sofa")},
    {icon: ICONS.sparkle, image: categoryPhoto("officeFurniture")},
    {icon: ICONS.archiveBox, image: categoryPhoto("white")},
    {icon: ICONS.moonComfort, image: categoryPhoto("bed")},
    {icon: ICONS.inventory, image: categoryPhoto("wardrobe")},
    {icon: ICONS.shieldCheck, image: categoryPhoto("table")},
    {icon: ICONS.heartOutline, image: categoryPhoto("homeTextile")},
    {icon: ICONS.sparkle, image: categoryPhoto("lighting")},
    {icon: ICONS.grid, image: categoryPhoto("decor")},
    {icon: ICONS.leafOutline, image: categoryPhoto("outdoorGarden")},
  ];
  const arbTips = arbTipMeta.map((meta, i) => {
    const n = i + 1;
    return {
      ...meta,
      eyebrow: t(locale, `tip${n}Category`),
      title: t(locale, `tip${n}Title`),
      desc: t(locale, `tip${n}Desc`),
    };
  });

  const extraTips = [
    {icon: ICONS.leafOutline, eyebrow: "Koku", title: "Kumaşlardaki Kokuyu Yok Edin", desc: "Kabartma tozunu kumaşın üzerine serpip 20 dakika bekletin, sonra vakumlayın; nemli/hayvan kokusunu kimyasal kullanmadan çeker.", image: categoryPhoto("sofa")},
    {icon: ICONS.shieldCheck, eyebrow: "Metal Bakımı", title: "Metal Ayaklarda Pas Önleme", desc: "Metal mobilya ayaklarının altına keçe veya plastik taban koyun; hem zemin çizilmez hem nem birikip paslanma riski azalır.", image: categoryPhoto("officeFurniture")},
    {icon: ICONS.sparkle, eyebrow: "Cam", title: "Cam Yüzeyleri Buğusuz Parlatın", desc: "Cam sehpaları gazeteyle silmek eski bir usta hilesidir; kağıt lifleri cam üzerinde iz bırakmadan pürüzsüz bir parlaklık bırakır.", image: categoryPhoto("table")},
    {icon: ICONS.sofaCare, eyebrow: "Deri Bakımı", title: "Deri Koltuğu Çatlamadan Koruyun", desc: "Deri koltuklara 3-4 ayda bir az miktarda deri bakım kremi uygulayın; kaloriferin/sobanın yakınına yerleştirmekten kaçının, aksi hâlde deri hızla çatlar.", image: categoryPhoto("sofa")},
    {icon: ICONS.history, eyebrow: "Halı", title: "Halıdaki Mobilya İzlerini Giderin", desc: "Mobilyanın bıraktığı çukur halı izine birkaç buz küpü koyup eriyene kadar bekleyin, sonra ipleri fırçayla kabartın; halı eski hâline döner.", image: categoryPhoto("homeTextile")},
    {icon: ICONS.inventory, eyebrow: "Çekmece", title: "Sıkışan Çekmeceyi Kolay Açılır Yapın", desc: "Çekmece raylarına az miktarda mum veya sabun sürün; kayma anındaki sürtünmeyi azaltıp can sıkıcı gıcırtıyı da keser.", image: categoryPhoto("wardrobe")},
    {icon: ICONS.archiveBox, eyebrow: "Nem Önleme", title: "Dolap İçi Nem ve Küfü Önleyin", desc: "Dolabın bir köşesine silika jel paketi veya kömür parçası koyun; nemi çeker, küf ve kötü kokuyu daha oluşmadan engeller.", image: categoryPhoto("wardrobe")},
    {icon: ICONS.clockOutline, eyebrow: "Renk Koruma", title: "Mobilya Rengini Soldurmayın", desc: "Ahşap mobilyaları doğrudan güneş alan pencere önüne koymayın; UV ışığı birkaç ay içinde rengi gözle görülür şekilde soldurur.", image: categoryPhoto("table")},
    {icon: ICONS.chair, eyebrow: "Onarım", title: "Gevşeyen Vidaları Kalıcı Sıkın", desc: "Gevşeyen ahşap vida yuvasını kürdan veya ahşap macunuyla doldurup kuruduktan sonra tekrar vidalayın; vida bir daha gevşemez.", image: categoryPhoto("chair")},
    {icon: ICONS.sparkle, eyebrow: "Çizik Onarımı", title: "Küçük Çizikleri Görünmez Edin", desc: "Ahşap üzerindeki ince çizikleri aynı renk tonundaki ceviz içiyle ovarak kapatabilirsiniz; profesyonel bakım kadar etkili ve dakikalar sürer.", image: categoryPhoto("decor")},
    {icon: ICONS.truck, eyebrow: "Taşıma", title: "Mobilya Taşırken Zeminde İz Bırakmayın", desc: "Ağır mobilyaları kaydırmadan önce altına eski bir battaniye veya halı parçası serin; hem zemin çizilmez hem taşıma çok daha kolaylaşır.", image: categoryPhoto("officeFurniture")},
    {icon: ICONS.sofaCare, eyebrow: "Minder Bakımı", title: "Minderlerin Şeklini Koruyun", desc: "Koltuk minderlerini haftada bir ters çevirip kabartın; hep aynı yönde oturmak minderin bir tarafını kalıcı olarak çökertir.", image: categoryPhoto("sofa")},
    {icon: ICONS.sparkle, eyebrow: "Toz Alma", title: "Tozu Havaya Değil Beze Hapsedin", desc: "Tüy alırken kuru bez yerine hafif nemli mikrofiber kullanın; kuru bez tozu havaya kaldırıp kısa süre sonra aynı yüzeye tekrar kondurur.", image: categoryPhoto("white")},
    {icon: ICONS.leafOutline, eyebrow: "Doğal Koruma", title: "Güve ve Böceklerden Doğal Koruma", desc: "Dolap raflarına birkaç defne yaprağı veya lavanta kesesi koyun; güveleri kimyasal kullanmadan uzak tutar, kıyafetlere hoş bir koku bırakır.", image: categoryPhoto("wardrobe")},
    {icon: ICONS.clockOutline, eyebrow: "Mevsimsel Bakım", title: "Mevsim Geçişinde Mobilya Bakımı", desc: "Kışın kuru ısıtılmış hava ahşabı çatlatır; odaya küçük bir nemlendirici veya su dolu bir kap koymak nem dengesini korumaya yeter.", image: categoryPhoto("bed")},
  ];

  const tips = [...arbTips, ...extraTips];
  return `
<div class="care-tips-row">${tips.map((tip) => `
    <article class="care-tip-card">
      <div class="care-tip-media"><img src="${escapeHtml(tip.image)}" alt="" loading="lazy"></div>
      <span class="care-tip-icon">${tip.icon}</span>
      <p class="care-tip-eyebrow">${escapeHtml(tip.eyebrow)}</p>
      <h3 class="care-tip-title">${escapeHtml(tip.title)}</h3>
      <p class="care-tip-desc">${escapeHtml(tip.desc)}</p>
    </article>`).join("")}</div>`;
}

// "#SağlamSpot ile Kurulumunuzu Paylaşın" — mozaik (Pinterest tarzı,
// değişken yükseklikli) galeri. CSS `columns` ile satır/sütun hesabı
// olmadan doğal mozaik görünümü; JS gerekmiyor. Aynı (zaten doğrulanmış)
// kategori fotoğrafları, burada küçük kare/dikdörtgen kartlar olarak.
//
// ÖNCEDEN bu kartlar/butonlar business.instagramUrl'e (instagram.com/
// saglamspot) gidiyordu — kullanıcı geri bildirimi: "buradaki instagram
// hesabı bize ait değil, bizim sadece facebook sayfamız var". Yani bu
// hesaba YÖNLENDİRMEK yanlış/yabancı bir hesaba trafik gönderiyordu.
// Buradaki asıl niyet zaten "ziyaret et" değil "#SağlamSpot ile KENDİ
// kurulumunu paylaş" — artık gerçekten bunu yapıyor: tıklanınca (mobilde)
// native paylaşım sayfası açılıyor (wireShareButtons'taki navigator.share
// ile AYNI yöntem, data-share-instagram), kullanıcı istediği uygulamayı
// (Instagram dahil) seçip paylaşabiliyor; hesap sahipliği hiç gerekmiyor
// çünkü bir profile değil, kullanıcının KENDİ paylaşımına #SağlamSpot
// etiketi öneriliyor (@mention DEĞİL — o hesap bizim değil).
function renderShareGallery(locale) {
  const photos = Object.keys(CATEGORY_LABELS).filter((k) => k !== "other").map((key) => categoryPhoto(key));
  const shareText = "Sağlam Spot'tan aldığım mobilyalarla evim yenilendi! #SağlamSpot";
  return `
<div class="share-mosaic">${photos.map((url) => `
    <button type="button" class="share-mosaic-item" data-share-instagram data-share-text="${escapeHtml(shareText)}">
      <img src="${escapeHtml(url)}" alt="" loading="lazy">
    </button>`).join("")}</div>
<div class="share-cta-row">
  <button type="button" class="hero-pill hero-pill-accent" data-share-instagram data-share-text="${escapeHtml(shareText)}">${ICONS.explore} Instagram'da Paylaş</button>
</div>`;
}

function renderStatsBand(locale, productCount, categoryCount, soldCount) {
  const stats = [
    {icon: ICONS.inventory, value: productCount, suffix: "", label: t(locale, "statProducts")},
    {icon: ICONS.grid, value: categoryCount, suffix: "", label: t(locale, "sectionCategories")},
    {icon: ICONS.award, value: 20, suffix: t(locale, "statYearsSuffix"), label: t(locale, "statExperience")},
    {icon: ICONS.truck, value: soldCount, suffix: "", label: t(locale, "statDelivery")},
  ];
  return `<section class="stats-band"><div class="stats-grid">${stats.map((s) => `
    <div class="stat-card">
      <span class="stat-card-icon">${s.icon}</span>
      <strong data-count-to="${s.value}" data-count-suffix="${escapeHtml(s.suffix)}">0</strong>
      <span>${escapeHtml(s.label)}</span>
    </div>`).join("")}</div></section>`;
}

module.exports = async function homeRoute(req, res) {
  const locale = req.locale;
  let products = [];
  let soldCount = 0;
  let firestoreError = null;

  try {
    [products, soldCount] = await Promise.all([
      listActiveProducts({limit: 200}),
      countSoldProducts(),
    ]);
  } catch (err) {
    firestoreError = err.message;
  }

  const newProducts = products.filter((p) => !p.isSpotProduct);
  const spotProducts = products.filter((p) => p.isSpotProduct);
  const categoryCount = new Set(products.map((p) => p.category)).size;
  const gridProducts = products.slice(0, 8);

  const gridHtml = firestoreError
    ? `<p class="status status-error">${escapeHtml(firestoreError)}</p>`
    : renderProductGrid(gridProducts, locale);

  const bodyHtml = firestoreError ? `
<section class="section"><p class="status status-error">${escapeHtml(firestoreError)}</p></section>` : `
${renderHero(locale, products)}

<section class="section">
  ${renderTicker(locale)}
</section>

<section class="section">
  ${renderCategoryRail(locale)}
</section>

<section class="section">
  ${renderGatewayCards(locale, newProducts, spotProducts)}
</section>

<section class="section">
  ${renderBentoGrid(locale)}
</section>

<section class="section">
  <h2>${escapeHtml(t(locale, "newCollectionSub"))}</h2>
  ${gridHtml}
</section>

<section class="section">
  ${renderRoomsPanel(locale)}
</section>

<section class="section">
  ${renderStoreInfo(locale)}
</section>

<section class="section care-tips-section">
  <p class="eyebrow">İpuçları</p>
  <h2>Uzmanından Bakım Önerileri</h2>
  ${renderCareTips(locale)}
</section>

<section class="section share-gallery-section">
  <p class="eyebrow">Paylaşın</p>
  <h2>#SağlamSpot ile Kurulumunuzu Paylaşın</h2>
  ${renderShareGallery(locale)}
</section>

<section class="section">
  <h2>${escapeHtml(t(locale, "aboutValuesHeading"))}</h2>
  <p class="lede">${escapeHtml(t(locale, "aboutValuesSubheading"))}</p>
  <div class="value-grid">${[1, 2, 3, 4].map((i) => `
    <div class="value-card">
      <h3>${escapeHtml(t(locale, `aboutValue${i}Title`))}</h3>
      <p>${escapeHtml(t(locale, `aboutValue${i}Desc`))}</p>
    </div>`).join("")}</div>
</section>

${renderStatsBand(locale, products.length, categoryCount, soldCount)}`;

  res.set("Cache-Control", "public, max-age=60");
  res.status(200).send(renderLayout({
    req,
    title: null,
    description: t(locale, "seoHomeDesc"),
    path: "/",
    bodyHtml,
    locale,
    jsonLd: {
      "@context": "https://schema.org",
      "@type": "FurnitureStore",
      "name": business.brandName,
      "image": `${businessUrl(req)}/icons/Icon-512.png`,
      "url": businessUrl(req),
      "telephone": `+${business.phoneNumberIntl}`,
      "email": business.email,
      "priceRange": "₺₺",
      "address": {
        "@type": "PostalAddress",
        "streetAddress": business.address.line,
        "addressLocality": business.address.district,
        "addressRegion": business.address.city,
        "addressCountry": business.address.country,
      },
      "geo": {
        "@type": "GeoCoordinates",
        "latitude": business.geo.latitude,
        "longitude": business.geo.longitude,
      },
      "openingHoursSpecification": business.openingHoursSpecification.map((spec) => ({
        "@type": "OpeningHoursSpecification",
        ...spec,
      })),
      "sameAs": [business.instagramUrl, business.facebookUrl],
    },
  }));
};

function businessUrl(req) {
  const forwarded = req.get("x-forwarded-proto");
  const protocol = forwarded ? forwarded.split(",")[0].trim() : req.protocol;
  return `${protocol}://${req.get("host")}`;
}

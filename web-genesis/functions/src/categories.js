const {t} = require("./i18n");

// lib/core/common/enum/enums.dart'taki (ProductCategory) enum değerleriyle
// AYNI sırada. Admin paneli (Türkçe-only) için sabit Türkçe harita; genel
// vitrin sayfaları için aşağıdaki localizedCategoryLabel() kullanılır
// (ARB'deki categorySofa/categoryChair/... anahtarlarından, dile göre).
const CATEGORY_LABELS = {
  sofa: "Oturma Grupları",
  chair: "Sandalye",
  table: "Masa",
  bed: "Yatak Odası",
  wardrobe: "Dolap",
  white: "Beyaz Eşya",
  lighting: "Aydınlatma",
  homeTextile: "Ev Tekstili",
  decor: "Dekorasyon & Aksesuar",
  officeFurniture: "Ofis Mobilyası",
  outdoorGarden: "Bahçe & Balkon",
  kidsFurniture: "Bebek & Çocuk",
  other: "Diğer",
};

// lib/core/common/extentions/product_wear_tier_ex.dart ile aynı.
const WEAR_TIER_LABELS = {
  likeNew: "Az Kullanılmış",
  good: "İyi Durumda",
  wellLoved: "Kullanılmış, Sağlam",
};

// lib/features/products/data/models/category_meta.dart'taki defaultCategoryMeta
// ile AYNI hex'ler — kategori rozetlerinin/çiplerinin rengi. Yeni renk İCAT
// EDİLMEDİ, sadece Flutter tarafındaki mevcut kategori vurgu renkleri buraya
// taşındı (marka ana paleti CLAUDE.md'ye göre sabit kalıyor, bu sadece
// kategori bazlı bir vurgu/etiket rengi).
const CATEGORY_COLORS = {
  sofa: "#2E7D6B",
  chair: "#C5A358",
  table: "#B2673E",
  bed: "#6B5CA5",
  wardrobe: "#3E6B8A",
  white: "#5A8A6B",
  lighting: "#E0A458",
  homeTextile: "#C97B84",
  decor: "#8A5A7A",
  officeFurniture: "#43536B",
  outdoorGarden: "#4FA8D8",
  kidsFurniture: "#E0724A",
  other: "#7A7F87",
};

function categoryColor(category) {
  return CATEGORY_COLORS[category] || CATEGORY_COLORS.other;
}

function categoryLabel(category) {
  return CATEGORY_LABELS[category] || CATEGORY_LABELS.other;
}

/** ARB anahtarı: "category" + Key (örn. homeTextile -> categoryHomeTextile). */
function localizedCategoryLabel(locale, category) {
  const key = category || "other";
  const arbKey = "category" + key.charAt(0).toUpperCase() + key.slice(1);
  return t(locale, arbKey);
}

// wearTier etiketleri ARB'de yok (Flutter'ın kendisi de bunu
// lokalize ETMİYOR — bkz. product_wear_tier_ex.dart, literal Türkçe
// string döndürüyor) — bu yüzden burada da bilerek sadece Türkçe.
function wearTierLabel(wearTier) {
  return wearTier ? WEAR_TIER_LABELS[wearTier] || null : null;
}

module.exports = {CATEGORY_LABELS, WEAR_TIER_LABELS, CATEGORY_COLORS, categoryLabel, localizedCategoryLabel, wearTierLabel, categoryColor};

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

module.exports = {CATEGORY_LABELS, WEAR_TIER_LABELS, categoryLabel, localizedCategoryLabel, wearTierLabel};

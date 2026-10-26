// lib/core/common/enum/enums.dart (ProductCategory) ve
// lib/l10n/app_tr.arb'daki TR etiketlerle BİREBİR aynı tutulmalı.
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

function wearTierLabel(wearTier) {
  return wearTier ? WEAR_TIER_LABELS[wearTier] || null : null;
}

module.exports = {CATEGORY_LABELS, WEAR_TIER_LABELS, categoryLabel, wearTierLabel};

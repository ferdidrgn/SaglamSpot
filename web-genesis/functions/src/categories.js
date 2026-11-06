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

// lib/features/home/presentation/page/home_page_web.dart'taki
// _categoryPhotos ile AYNI Unsplash URL'leri — kategori dairesel rayı ve
// "Yaşam Alanına Göre" panelinde Flutter ile birebir aynı görseller.
const CATEGORY_PHOTOS = {
  sofa: "https://images.unsplash.com/photo-1550254478-ead40cc54513?q=80&w=800",
  chair: "https://images.unsplash.com/photo-1592078615290-033ee584e267?q=80&w=800",
  table: "https://images.unsplash.com/photo-1617806118233-18e1de247200?q=80&w=800",
  bed: "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=800",
  wardrobe: "https://images.unsplash.com/photo-1595428774223-ef52624120d2?q=80&w=800",
  white: "https://images.unsplash.com/photo-1556911220-bff31c812dba?q=80&w=800",
  lighting: "https://images.unsplash.com/photo-1517991104123-1d56a6e81ed9?q=80&w=800",
  homeTextile: "https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?q=80&w=800",
  decor: "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=800",
  officeFurniture: "https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?q=80&w=800",
  outdoorGarden: "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?q=80&w=800",
  kidsFurniture: "https://images.unsplash.com/photo-1522771930-78848d9293e8?q=80&w=800",
  other: "https://images.unsplash.com/photo-1524758631624-e2822e304c36?q=80&w=800",
};

function categoryPhoto(category) {
  return CATEGORY_PHOTOS[category] || CATEGORY_PHOTOS.other;
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

module.exports = {CATEGORY_LABELS, WEAR_TIER_LABELS, CATEGORY_COLORS, CATEGORY_PHOTOS, categoryLabel, localizedCategoryLabel, wearTierLabel, categoryColor, categoryPhoto};

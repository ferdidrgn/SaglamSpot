const {renderLayout, escapeHtml} = require("../render/layout");
const {renderProductGrid} = require("../render/productCard");
const {listActiveProducts} = require("../productRepo");
const {t} = require("../i18n");

/**
 * `isSpotProduct` ile aynı iki değer: false = sıfır ürün, true = ikinci
 * el/spot ürün (bkz. lib/features/products/domain/entites/product.dart).
 * Metinler ARB'den geliyor (yeniden çeviri yok) — anahtarlar her iki sayfa
 * için de gerçekten var (bkz. spotProducts/newCollection/seoNewTitle vb.).
 */
function makeListingRoute({isSpotProduct, path, titleKey, eyebrowKey, ledeKey, seoTitleKey, seoDescKey}) {
  return async function listingRoute(req, res) {
    const locale = req.locale;
    let products = [];
    let firestoreError = null;

    try {
      products = await listActiveProducts({isSpotProduct});
    } catch (err) {
      firestoreError = err.message;
    }

    const gridHtml = firestoreError
      ? `<p class="status status-error">${escapeHtml(firestoreError)}</p>`
      : renderProductGrid(products, locale);

    const bodyHtml = `
<section class="section-header">
  <p class="eyebrow">${escapeHtml(t(locale, eyebrowKey))}</p>
  <h1>${escapeHtml(t(locale, titleKey))}</h1>
  <p class="lede">${escapeHtml(t(locale, ledeKey))}</p>
</section>
<section class="section">
  ${gridHtml}
</section>`;

    res.set("Cache-Control", "no-cache, no-store, must-revalidate");
    res.status(200).send(renderLayout({
    req,
      title: t(locale, seoTitleKey).split(" | ")[0],
      description: t(locale, seoDescKey),
      path,
      bodyHtml,
      locale,
    }));
  };
}

const newProductsRoute = makeListingRoute({
  isSpotProduct: false,
  path: "/sifir",
  titleKey: "newCollection",
  eyebrowKey: "newProductsBadgeEyebrow",
  ledeKey: "seoNewDesc",
  seoTitleKey: "seoNewTitle",
  seoDescKey: "seoNewDesc",
});

const spotProductsRoute = makeListingRoute({
  isSpotProduct: true,
  path: "/spot",
  titleKey: "spotProducts",
  eyebrowKey: "spotProductsSub",
  ledeKey: "spotProductsDesc",
  seoTitleKey: "seoSpotTitle",
  seoDescKey: "seoSpotDesc",
});

module.exports = {newProductsRoute, spotProductsRoute};

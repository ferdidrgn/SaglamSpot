const {renderLayout, escapeHtml} = require("../render/layout");
const {renderProductGrid} = require("../render/productCard");
const {listActiveProducts} = require("../productRepo");

/**
 * `isSpotProduct` ile aynı iki değer: false = sıfır ürün, true = ikinci
 * el/spot ürün (bkz. lib/features/products/domain/entites/product.dart).
 */
function makeListingRoute({isSpotProduct, path, title, eyebrow, description}) {
  return async function listingRoute(req, res) {
    let products = [];
    let firestoreError = null;

    try {
      products = await listActiveProducts({isSpotProduct});
    } catch (err) {
      firestoreError = err.message;
    }

    const gridHtml = firestoreError
      ? `<p class="status status-error">Ürünler yüklenemedi: ${escapeHtml(firestoreError)}</p>`
      : renderProductGrid(products);

    const bodyHtml = `
<section class="section-header">
  <p class="eyebrow">${escapeHtml(eyebrow)}</p>
  <h1>${escapeHtml(title)}</h1>
  <p class="lede">${escapeHtml(description)}</p>
</section>
<section class="section">
  ${gridHtml}
</section>`;

    res.set("Cache-Control", "no-cache, no-store, must-revalidate");
    res.status(200).send(renderLayout({title, path, bodyHtml}));
  };
}

const newProductsRoute = makeListingRoute({
  isSpotProduct: false,
  path: "/sifir",
  title: "Sıfır Ürünler",
  eyebrow: "Sıfır Mobilya",
  description: "Hiç kullanılmamış, sıfır mobilya ürünlerimiz.",
});

const spotProductsRoute = makeListingRoute({
  isSpotProduct: true,
  path: "/spot",
  title: "Spot Ürünler",
  eyebrow: "İkinci El / Spot",
  description: "Uygun fiyatlı, kontrol edilmiş ikinci el spot ürünlerimiz.",
});

module.exports = {newProductsRoute, spotProductsRoute};

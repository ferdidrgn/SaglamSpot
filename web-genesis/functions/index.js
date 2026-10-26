/**
 * Sağlam Spot — web-genesis SSR fonksiyonu (giriş noktası).
 *
 * Bu, ana (Flutter) web uygulamasının `functions/index.js`'inden tamamen
 * ayrı bir Cloud Functions codebase'idir (firebase.json → functions[]
 * içinde codebase: "genesis"). Firebase Hosting'deki ayrı "genesis"
 * hedefi (site: saglamspot-genesis) tüm istekleri buraya yönlendirir;
 * her istek burada gerçek, botların JS çalıştırmadan okuyabileceği HTML
 * olarak render edilir (bkz. src/app.js).
 */
const {onRequest} = require("firebase-functions/v2/https");
const app = require("./src/app");

exports.genesisApp = onRequest({cors: false, memory: "256MiB"}, app);

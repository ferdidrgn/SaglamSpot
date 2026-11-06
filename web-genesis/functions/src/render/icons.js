/**
 * Küçük, tek renkli (currentColor) SVG ikonlar — harici bir ikon fontu/paket
 * eklemeden ana sayfanın görsel bölümleri (bento ızgara, istatistik
 * kartları, hero okları, kategori rayı) için. Yalnızca çizgi/şekil, metin
 * yok; anlam taşıyan yerlerde çağıran taraf aria-label ekler.
 */
const ICONS = {
  handshake: "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><path d=\"M2 12l4-4 4 2 4-3 3 2 5-3\"/><path d=\"M7 10l4 4 3-2 3 3\"/><path d=\"M2 12v4l4 3\"/><path d=\"M22 10v4l-4 4\"/></svg>",
  shieldCheck: "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><path d=\"M12 3l7 3v6c0 4.5-3 7.5-7 9-4-1.5-7-4.5-7-9V6l7-3z\"/><path d=\"M9 12l2 2 4-4\"/></svg>",
  smile: "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><circle cx=\"12\" cy=\"12\" r=\"9\"/><path d=\"M8 14s1.5 2 4 2 4-2 4-2\"/><circle cx=\"9\" cy=\"10\" r=\"0.8\" fill=\"currentColor\"/><circle cx=\"15\" cy=\"10\" r=\"0.8\" fill=\"currentColor\"/></svg>",
  truck: "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><rect x=\"1.5\" y=\"7\" width=\"13\" height=\"9\" rx=\"1\"/><path d=\"M14.5 10h4l3.5 3.5V16h-7.5z\"/><circle cx=\"6\" cy=\"18\" r=\"1.6\"/><circle cx=\"17.5\" cy=\"18\" r=\"1.6\"/></svg>",
  inventory: "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><rect x=\"3\" y=\"8\" width=\"18\" height=\"13\" rx=\"1.5\"/><path d=\"M3 8l2-5h14l2 5\"/><path d=\"M9 12h6\"/></svg>",
  grid: "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><rect x=\"3\" y=\"3\" width=\"8\" height=\"8\" rx=\"1.5\"/><rect x=\"13\" y=\"3\" width=\"8\" height=\"8\" rx=\"1.5\"/><rect x=\"3\" y=\"13\" width=\"8\" height=\"8\" rx=\"1.5\"/><rect x=\"13\" y=\"13\" width=\"8\" height=\"8\" rx=\"1.5\"/></svg>",
  award: "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><circle cx=\"12\" cy=\"9\" r=\"5.5\"/><path d=\"M9 13.5L7.5 21 12 18.5 16.5 21 15 13.5\"/></svg>",
  explore: "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><circle cx=\"12\" cy=\"12\" r=\"9\"/><path d=\"M15 9l-2 6-6 2 2-6z\"/></svg>",
  chevronLeft: "<svg width=\"20\" height=\"20\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\"><path d=\"M15 5l-7 7 7 7\"/></svg>",
  chevronRight: "<svg width=\"20\" height=\"20\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2.2\"><path d=\"M9 5l7 7-7 7\"/></svg>",
  chair: "<svg width=\"120\" height=\"120\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M6 3h2v8h8V3h2v10h-2v2h2v6h-2v-4H8v4H6v-6h2v-2H6V3z\"/></svg>",
  tag: "<svg width=\"110\" height=\"110\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M20 12.5L12.5 20 3 10.5V3h7.5L20 12.5z\"/><circle cx=\"7.5\" cy=\"7.5\" r=\"1.5\" fill=\"#fff\"/></svg>",
  newReleases: "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M12 2l2 3 3.4-1 .3 3.5 3.3.9-1.8 3 1.8 3-3.3.9-.3 3.5-3.4-1-2 3-2-3-3.4 1-.3-3.5-3.3-.9 1.8-3-1.8-3 3.3-.9.3-3.5 3.4 1z\"/></svg>",
  history: "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M3 12a9 9 0 1 0 3-6.7\"/><path d=\"M3 4v4h4\"/><path d=\"M12 7v5l3 2\"/></svg>",
  verified: "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M12 2l2.4 1.2 2.6-.6 1.2 2.4 2.4 1.2-.6 2.6L21 11l-1.2 2.4.6 2.6-2.4 1.2-1.2 2.4-2.6-.6L12 20l-2.4-1.2-2.6.6-1.2-2.4-2.4-1.2.6-2.6L3 11l1.2-2.4-.6-2.6 2.4-1.2 1.2-2.4 2.6.6z\"/><path d=\"M9 12l2 2 4-4\"/></svg>",
  storefront: "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M3 9l1-5h16l1 5\"/><path d=\"M4 9v10h16V9\"/><path d=\"M9 19v-5h6v5\"/><path d=\"M3 9a2 2 0 0 0 4 0 2 2 0 0 0 4 0 2 2 0 0 0 4 0 2 2 0 0 0 4 0\"/></svg>",
  map: "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\"><path d=\"M9 4l-6 2v14l6-2 6 2 6-2V4l-6 2-6-2z\"/><path d=\"M9 4v14M15 6v14\"/></svg>",
  sparkle: "<svg width=\"16\" height=\"16\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M12 2l1.8 5.6L19 9l-5.2 1.8L12 16l-1.8-5.2L5 9l5.2-1.4z\"/></svg>",
  // "Uzmanından Bakım Önerileri" bölümü ikonları (yerleştirme/düzen/konfor).
  sofaCare: "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><path d=\"M5 11V8a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v3\"/><path d=\"M3 13a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v3a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1z\"/><path d=\"M4 17v2M20 17v2\"/></svg>",
  archiveBox: "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"1.8\"><rect x=\"3\" y=\"4\" width=\"18\" height=\"5\" rx=\"1.2\"/><path d=\"M4 9v9a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9\"/><path d=\"M10 13h4\"/></svg>",
  moonComfort: "<svg width=\"22\" height=\"22\" viewBox=\"0 0 24 24\" fill=\"currentColor\"><path d=\"M20 14.5A8.5 8.5 0 1 1 9.5 4a7 7 0 0 0 10.5 10.5z\"/></svg>",
};

module.exports = {ICONS};

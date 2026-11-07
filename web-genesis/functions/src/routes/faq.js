const {renderLayout, escapeHtml} = require("../render/layout");
const {ICONS} = require("../render/icons");
const {t} = require("../i18n");
const business = require("../businessInfo");

/**
 * lib/features/sss/presentation/pages/sss_page.dart'taki _FaqCategory +
 * _faqs() listesiyle AYNI 6 kategori/22 soru eşlemesi — önceden burada
 * sadece 15 soru (sssQ1-15) vardı, sssQ16-22 ve kategori filtreleri hiç
 * yoktu ("SSS test ettim çalışmıyor" geri bildirimi: kategori çipleri
 * hiç render edilmiyordu, tıklayınca haliyle hiçbir şey olmuyordu).
 * Tüm soru/cevaplar lib/l10n/app_*.arb'deki sssQ1..sssQ22/sssA1..sssA22
 * anahtarlarından (yeniden çeviri yok, 11 dilin hepsinde zaten var).
 */
const CATEGORIES = [
  {key: "general", labelKey: "sssCategoryGeneral", color: "var(--color-primary)", questions: [1, 2, 3]},
  {key: "productService", labelKey: "sssCategoryProductService", color: "var(--color-info)", questions: [4, 5, 6, 7, 8, 9]},
  {key: "delivery", labelKey: "sssCategoryDelivery", color: "var(--color-success)", questions: [10, 11, 12, 13, 14]},
  {key: "payment", labelKey: "sssCategoryPayment", color: "var(--color-warning)", questions: [15, 16]},
  // Flutter'da bu kategorinin rengi AppColors.secondary (çok soluk bej) —
  // web'de aynı ton bir rozet metninde okunaksız kalıyor, bu yüzden
  // palette İÇİNDEN daha okunaklı var(--color-accent-dark) seçildi (yeni
  // hex İCAT edilmedi, sadece var olan tonlardan biri tercih edildi).
  {key: "returns", labelKey: "sssCategoryReturns", color: "var(--color-accent-dark)", questions: [17, 18]},
  {key: "secondHandBuying", labelKey: "sssCategorySecondHandBuying", color: "var(--color-text-primary)", questions: [19, 20, 21, 22]},
];

function categoryOf(n) {
  return CATEGORIES.find((c) => c.questions.includes(n));
}

module.exports = function faqRoute(req, res) {
  const locale = req.locale;
  const allNumbers = Array.from({length: 22}, (_, i) => i + 1);

  const chipsHtml = [
    `<button type="button" class="faq-chip is-active" data-faq-chip="all">${escapeHtml(t(locale, "sssCategoryAll"))} <span>${allNumbers.length}</span></button>`,
    ...CATEGORIES.map((cat) => `<button type="button" class="faq-chip" data-faq-chip="${cat.key}" style="--chip-color:${cat.color}">${escapeHtml(t(locale, cat.labelKey))} <span>${cat.questions.length}</span></button>`),
  ].join("");

  const itemsHtml = allNumbers.map((n) => {
    const cat = categoryOf(n);
    return `
    <details class="faq-item" data-faq-category="${cat.key}">
      <summary>
        <span class="faq-item-cat" style="--chip-color:${cat.color}">${escapeHtml(t(locale, cat.labelKey))}</span>
        <span class="faq-item-q">${escapeHtml(t(locale, `sssQ${n}`))}</span>
      </summary>
      <p>${escapeHtml(t(locale, `sssA${n}`))}</p>
    </details>`;
  }).join("");

  const quickHelpHtml = `
<div class="faq-quick-help">
  <div class="faq-quick-card">
    <span class="faq-quick-icon" style="--quick-color:var(--color-success)">${ICONS.phoneOutline}</span>
    <p class="faq-quick-title">${escapeHtml(t(locale, "sssPhoneSupportTitle"))}</p>
    <p class="faq-quick-value" dir="ltr">${escapeHtml(business.displayPhone)}</p>
  </div>
  <div class="faq-quick-card">
    <span class="faq-quick-icon" style="--quick-color:var(--color-info)">${ICONS.clockOutline}</span>
    <p class="faq-quick-title">${escapeHtml(t(locale, "sssWorkingHoursTitle"))}</p>
    <p class="faq-quick-value">${escapeHtml(business.workingHours).replace(/\n/g, "<br>")}</p>
  </div>
  <div class="faq-quick-card">
    <span class="faq-quick-icon" style="--quick-color:var(--color-accent)">${ICONS.map}</span>
    <p class="faq-quick-title">${escapeHtml(t(locale, "sssStoreAddressTitle"))}</p>
    <p class="faq-quick-value">${escapeHtml(t(locale, "sssStoreAddressValue"))}</p>
  </div>
</div>`;

  const bodyHtml = `
<section class="section-header">
  <p class="eyebrow">${escapeHtml(t(locale, "sssHelpCenterBadge"))}</p>
  <h1>${escapeHtml(t(locale, "sssHeroTitle")).replace(/\n/g, "<br>")}</h1>
  <p class="lede">${escapeHtml(t(locale, "sssHeroSubtitle"))}</p>
</section>

<section class="section">
  ${quickHelpHtml}
</section>

<section class="section">
  <div class="faq-chip-row" data-faq-chip-row>${chipsHtml}</div>
  <div class="faq-list" data-faq-list>${itemsHtml}</div>
</section>

<section class="section about-panel">
  <h2>${escapeHtml(t(locale, "sssNoAnswerTitle"))}</h2>
  <p class="lede">${escapeHtml(t(locale, "sssNoAnswerSubtitle"))}</p>
  <dl class="spec-list">
    <dt>${escapeHtml(t(locale, "sssPhoneSupportTitle"))}</dt>
    <dd dir="ltr">${escapeHtml(business.displayPhone)}</dd>
    <dt>${escapeHtml(t(locale, "sssWorkingHoursTitle"))}</dt>
    <dd>${escapeHtml(business.workingHours)}</dd>
    <dt>${escapeHtml(t(locale, "sssStoreAddressTitle"))}</dt>
    <dd>${escapeHtml(t(locale, "sssStoreAddressValue"))}</dd>
  </dl>
  <a class="whatsapp-link" href="${business.whatsappUrl(undefined, locale)}" rel="noopener">${escapeHtml(t(locale, "sssVisitStoreButton"))}</a>
</section>`;

  res.set("Cache-Control", "public, max-age=300");
  res.status(200).send(renderLayout({
    req,
    title: t(locale, "sss"),
    path: "/sss",
    bodyHtml,
    locale,
  }));
};

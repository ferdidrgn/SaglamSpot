const {renderLayout, escapeHtml} = require("../render/layout");
const {t} = require("../i18n");
const business = require("../businessInfo");

/**
 * Tüm soru/cevaplar lib/l10n/app_*.arb'deki sssQ1..sssQ15/sssA1..sssA15
 * anahtarlarından (yeniden çeviri yok, 11 dilin hepsinde zaten var).
 * <details>/<summary> ile JS olmadan da tam açılır/kapanır çalışır.
 */
const QUESTION_COUNT = 15;

module.exports = function faqRoute(req, res) {
  const locale = req.locale;

  const itemsHtml = Array.from({length: QUESTION_COUNT}, (_, i) => i + 1).map((n) => `
    <details class="faq-item">
      <summary>${escapeHtml(t(locale, `sssQ${n}`))}</summary>
      <p>${escapeHtml(t(locale, `sssA${n}`))}</p>
    </details>`).join("");

  const bodyHtml = `
<section class="section-header">
  <p class="eyebrow">${escapeHtml(t(locale, "sssHelpCenterBadge"))}</p>
  <h1>${escapeHtml(t(locale, "sssHeroTitle")).replace(/\n/g, "<br>")}</h1>
  <p class="lede">${escapeHtml(t(locale, "sssHeroSubtitle"))}</p>
</section>

<section class="section">
  <div class="faq-list">${itemsHtml}</div>
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
  <a class="whatsapp-link" href="${business.whatsappUrl()}" rel="noopener">${escapeHtml(t(locale, "sssVisitStoreButton"))}</a>
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

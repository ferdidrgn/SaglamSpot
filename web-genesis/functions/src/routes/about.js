const {renderLayout, escapeHtml} = require("../render/layout");
const {t} = require("../i18n");
const business = require("../businessInfo");

/** Tüm metin lib/l10n/app_*.arb'deki "about*" anahtarlarından (yeniden çeviri yok). */
module.exports = function aboutRoute(req, res) {
  const locale = req.locale;

  const values = [1, 2, 3, 4].map((i) => ({
    title: t(locale, `aboutValue${i}Title`),
    desc: t(locale, `aboutValue${i}Desc`),
  }));

  const valuesHtml = values.map((v) => `
    <div class="value-card">
      <h3>${escapeHtml(v.title)}</h3>
      <p>${escapeHtml(v.desc)}</p>
    </div>`).join("");

  const busLinesHtml = business.busLines.map((group) => `
    <div class="bus-group">
      <p class="bus-stop">${escapeHtml(group.stop)}</p>
      <p class="bus-lines">${group.lines.map((l) => `<span class="badge badge-new">${escapeHtml(l)}</span>`).join(" ")}</p>
    </div>`).join("");

  const bodyHtml = `
<section class="hero about-hero">
  <p class="eyebrow">${escapeHtml(t(locale, "aboutBadge"))}</p>
  <h1>${escapeHtml(t(locale, "aboutHeroTitle")).replace(/\n/g, "<br>")}</h1>
  <p class="lede">${escapeHtml(t(locale, "aboutHeroSubtitle")).replace(/\n/g, "<br>")}</p>
</section>

<section class="section about-story">
  <h2>${escapeHtml(t(locale, "aboutStoryHeading"))}</h2>
  <p>${escapeHtml(t(locale, "aboutStoryPara1"))}</p>
  <p>${escapeHtml(t(locale, "aboutStoryPara2"))}</p>
  <p>${escapeHtml(t(locale, "aboutStoryPara3"))}</p>
</section>

<section class="section">
  <h2>${escapeHtml(t(locale, "aboutValuesHeading"))}</h2>
  <p class="lede">${escapeHtml(t(locale, "aboutValuesSubheading"))}</p>
  <div class="value-grid">${valuesHtml}</div>
</section>

<section class="section">
  <h2>${escapeHtml(t(locale, "aboutMasterHeading"))}</h2>
  <p class="detail-desc">${escapeHtml(t(locale, "aboutMasterBody"))}</p>
</section>

<section class="section about-panel">
  <h2>${escapeHtml(t(locale, "aboutDeliveryHeading"))}</h2>
  <p><strong>${escapeHtml(t(locale, "aboutDeliveryFreeTitle"))}</strong></p>
  <p>${escapeHtml(t(locale, "aboutDeliveryZonesLabel"))}</p>
  <p class="detail-desc">${escapeHtml(t(locale, "aboutDeliveryZonesList"))}</p>
  <p class="status">${escapeHtml(t(locale, "aboutDeliveryPunctual"))}</p>
  <p class="status status-error">${escapeHtml(t(locale, "aboutDeliveryNote"))}</p>
</section>

<section class="section about-panel">
  <h2>${escapeHtml(t(locale, "aboutTransportHeading"))}</h2>
  <p>${escapeHtml(t(locale, "aboutTransportBusIntro"))}</p>
  ${busLinesHtml}
</section>

<section class="section about-panel">
  <h2>${escapeHtml(t(locale, "aboutContactHeading"))}</h2>
  <dl class="spec-list">
    <dt>${escapeHtml(t(locale, "aboutContactPhoneLabel"))}</dt>
    <dd dir="ltr">${escapeHtml(business.displayPhone)}</dd>
    <dt>${escapeHtml(t(locale, "aboutContactAddressLabel"))}</dt>
    <dd>${escapeHtml(business.address.line)}, ${escapeHtml(business.address.district)}/${escapeHtml(business.address.city)}</dd>
    <dt>${escapeHtml(t(locale, "aboutContactHoursLabel"))}</dt>
    <dd>${escapeHtml(business.workingHours)}</dd>
  </dl>
  <div class="detail-actions">
    <a class="whatsapp-link" href="tel:+${business.phoneNumberIntl}">${escapeHtml(t(locale, "aboutCallNowButton"))}</a>
    <a class="cart-add-btn" href="${escapeHtml(business.googleMapsUrl)}" target="_blank" rel="noopener">${escapeHtml(t(locale, "aboutViewMapButton"))}</a>
  </div>
</section>`;

  res.set("Cache-Control", "public, max-age=300");
  res.status(200).send(renderLayout({
    title: t(locale, "seoAboutTitle").split(" | ")[0],
    description: t(locale, "seoAboutDesc"),
    path: "/hakkimizda",
    bodyHtml,
    locale,
  }));
};

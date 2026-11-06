const {renderLayout, escapeHtml} = require("../render/layout");
const {ICONS} = require("../render/icons");
const {t} = require("../i18n");
const business = require("../businessInfo");

/**
 * "Biz Kimiz" (foto+metin+istatistik) ve "İlkelerimiz" (ikonlu değer
 * kartları) bölümlerinin görsel tasarımı lib/features/info/presentation/
 * pages/about_page.dart'taki _buildOurStory()/_buildOurValues() ile AYNI
 * — metinler zaten lib/l10n/app_*.arb'de vardı (yeniden çeviri yok),
 * sadece bu iki bölümün HTML/CSS karşılığı saglamspotcu.web.app'teki
 * (bu projenin kendi Flutter web derlemesi) görünümüyle eşleşecek
 * şekilde yeniden kuruldu. Fotoğraf home.js'teki HERO_IMAGES'teki ile
 * AYNI (zaten doğrulanmış) Unsplash görseli, rakamlar (2012/30+/5K+)
 * Dart'taki _buildStoryHighlight() çağrılarıyla birebir aynı.
 */
module.exports = function aboutRoute(req, res) {
  const locale = req.locale;

  const storyHighlightsHtml = [
    ["2012", t(locale, "aboutStoryStartLabel")],
    ["30+", t(locale, "aboutStoryExperienceLabel")],
    ["5K+", t(locale, "aboutStorySmilesLabel")],
  ].map(([number, label]) => `
    <div class="story-highlight">
      <strong>${escapeHtml(number)}</strong>
      <span>${escapeHtml(label)}</span>
    </div>`).join("");

  // AppColors.secondary gerçekte çok soluk bir bej (bkz. tokens.css
  // --color-secondary) — ikon + %10 opak zemin kombinasyonunda neredeyse
  // görünmez kalıyordu (kullanıcının ekran görüntüsündeki "Gülen Yüz"
  // kartında tam da bu görülüyor). Palette İÇİNDEN daha okunaklı
  // var(--color-accent) seçildi, yeni hex İCAT edilmedi.
  const values = [
    {icon: ICONS.verifiedBadge, color: "var(--color-primary)"},
    {icon: ICONS.heartOutline, color: "var(--color-accent)"},
    {icon: ICONS.leafOutline, color: "var(--color-success)"},
    {icon: ICONS.handshake, color: "var(--color-info)"},
  ].map((v, i) => ({
    ...v,
    title: t(locale, `aboutValue${i + 1}Title`),
    desc: t(locale, `aboutValue${i + 1}Desc`),
  }));

  const valuesHtml = values.map((v) => `
    <div class="value-card">
      <span class="value-card-icon" style="--value-color:${v.color}">${v.icon}</span>
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
  <div class="about-story-media">
    <img src="https://images.unsplash.com/photo-1581539250439-c96689b516dd?q=80&w=1200" alt="" loading="lazy">
  </div>
  <div class="about-story-text">
    <h2>${escapeHtml(t(locale, "aboutStoryHeading"))}</h2>
    <p>${escapeHtml(t(locale, "aboutStoryPara1"))}</p>
    <p>${escapeHtml(t(locale, "aboutStoryPara2"))}</p>
    <p>${escapeHtml(t(locale, "aboutStoryPara3"))}</p>
    <div class="story-highlight-row">${storyHighlightsHtml}</div>
  </div>
</section>

<section class="section about-values-panel">
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
    req,
    title: t(locale, "seoAboutTitle").split(" | ")[0],
    description: t(locale, "seoAboutDesc"),
    path: "/hakkimizda",
    bodyHtml,
    locale,
  }));
};

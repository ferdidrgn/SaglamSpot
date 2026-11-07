// Admin "İstatistikler" sekmesi için el yapımı, bağımlılıksız SVG
// grafikler — proje zaten build adımı olmayan, CDN'siz bir yapı
// kullanıyor (bkz. layout.js versionedAsset() notu), bu yüzden burada
// da harici bir chart kütüphanesi eklemek yerine aynı felsefeyle küçük,
// Atölye renk paletine uyan iki genel grafik türü (halka + çubuk)
// yazıldı. Her ikisi de giriş animasyonlu (requestAnimationFrame ile
// iki adımlı — admin-dashboard.js'teki modal açılış deseniyle aynı).

const SVG_NS = "http://www.w3.org/2000/svg";

function svgEl(tag, attrs = {}) {
  const el = document.createElementNS(SVG_NS, tag);
  for (const [k, v] of Object.entries(attrs)) el.setAttribute(k, String(v));
  return el;
}

/**
 * segments: [{label, value, color}]
 */
export function renderDonutChart(container, segments, {size = 168, thickness = 26, centerLabel = "toplam"} = {}) {
  container.innerHTML = "";
  const total = segments.reduce((s, x) => s + x.value, 0);
  const r = (size - thickness) / 2;
  const cx = size / 2;
  const cy = size / 2;
  const circumference = 2 * Math.PI * r;

  const wrap = document.createElement("div");
  wrap.className = "achart-donut-wrap";
  const svg = svgEl("svg", {viewBox: `0 0 ${size} ${size}`, width: size, height: size, class: "achart-donut"});

  const track = svgEl("circle", {cx, cy, r, fill: "none", stroke: "var(--color-divider)", "stroke-width": thickness});
  svg.appendChild(track);

  const segEls = [];
  if (total > 0) {
    let offset = 0;
    segments.forEach((seg) => {
      if (!seg.value) return;
      const dash = (seg.value / total) * circumference;
      const circle = svgEl("circle", {
        cx, cy, r, fill: "none",
        stroke: seg.color,
        "stroke-width": thickness,
        "stroke-linecap": "butt",
        "stroke-dasharray": `0 ${circumference}`,
        "stroke-dashoffset": -offset,
        transform: `rotate(-90 ${cx} ${cy})`,
        class: "achart-donut-seg",
      });
      circle.dataset.finalDash = `${dash} ${circumference - dash}`;
      svg.appendChild(circle);
      segEls.push(circle);
      offset += dash;
    });
  }

  const center = document.createElement("div");
  center.className = "achart-donut-center";
  center.innerHTML = `<strong>${total.toLocaleString("tr-TR")}</strong><span>${centerLabel}</span>`;

  wrap.appendChild(svg);
  wrap.appendChild(center);

  const legend = document.createElement("div");
  legend.className = "achart-legend";
  legend.innerHTML = segments.map((seg) => `
    <div class="achart-legend-item">
      <span class="achart-legend-dot" style="background:${seg.color}"></span>
      <span class="achart-legend-label">${seg.label}</span>
      <span class="achart-legend-value">${seg.value.toLocaleString("tr-TR")}${total ? ` · %${Math.round((seg.value / total) * 100)}` : ""}</span>
    </div>`).join("") || "<p class=\"achart-empty\">Veri yok</p>";

  container.appendChild(wrap);
  container.appendChild(legend);

  requestAnimationFrame(() => {
    segEls.forEach((el) => { el.setAttribute("stroke-dasharray", el.dataset.finalDash); });
  });
}

/**
 * bars: [{label, value, color}]
 */
export function renderBarChart(container, bars, {height = 160, valueFormatter = (v) => v.toLocaleString("tr-TR")} = {}) {
  container.innerHTML = "";
  if (!bars.length) {
    container.innerHTML = "<p class=\"achart-empty\">Veri yok</p>";
    return;
  }
  const max = Math.max(1, ...bars.map((b) => b.value));
  const chart = document.createElement("div");
  chart.className = "achart-bars";
  chart.style.setProperty("--achart-height", `${height}px`);

  const fills = [];
  chart.innerHTML = bars.map((b, i) => `
    <div class="achart-bar-col" title="${b.label}: ${valueFormatter(b.value)}">
      <span class="achart-bar-value">${valueFormatter(b.value)}</span>
      <div class="achart-bar-track">
        <div class="achart-bar-fill" data-bar-fill data-index="${i}" style="background:${b.color || "var(--color-accent)"}"></div>
      </div>
      <span class="achart-bar-label">${b.label}</span>
    </div>`).join("");

  container.appendChild(chart);
  chart.querySelectorAll("[data-bar-fill]").forEach((el, i) => {
    const pct = Math.max(2, Math.round((bars[i].value / max) * 100));
    fills.push([el, pct]);
  });

  requestAnimationFrame(() => {
    fills.forEach(([el, pct], i) => {
      el.style.transitionDelay = `${i * 35}ms`;
      el.style.height = `${pct}%`;
    });
  });
}

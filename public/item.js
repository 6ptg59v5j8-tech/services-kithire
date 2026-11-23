const root = document.querySelector('#item-content');
const slug = new URLSearchParams(location.search).get('slug') || decodeURIComponent(location.pathname.split('/').filter(Boolean).pop() || '');
const money = n => new Intl.NumberFormat('en-GB', { style: 'currency', currency: 'GBP' }).format(Number(n) || 0);
const esc = s => String(s || '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

async function run() {
  try {
    const response = await fetch('/api/equipment/slug/' + encodeURIComponent(slug), { cache: 'no-store' });
    if (!response.ok) throw new Error('Equipment not found');
    const payload = await response.json();
    const item = payload.equipment;
    if (!item) throw new Error('Equipment not found');

    let gallery = [];
    try {
      const parsed = JSON.parse(item.gallery_json || '[]');
      if (Array.isArray(parsed)) gallery = parsed.filter(value => typeof value === 'string' && value.trim());
    } catch (_) { gallery = []; }

    const images = [...new Set([item.image_url, ...gallery].filter(value => typeof value === 'string' && value.trim()))];
    const firstImage = images[0] || '';

    root.innerHTML = `
      <div class="item-layout">
        <div class="item-media-column">
          <div class="item-image-stage">
            ${firstImage
              ? `<img class="item-main-image" id="main-image" src="${esc(firstImage)}" alt="${esc(item.name)}" decoding="async">`
              : `<div class="image-placeholder item-main-image is-empty">DBAVL<span>.</span></div>`}
          </div>
          ${images.length > 1 ? `<div class="item-gallery" aria-label="More product images">${images.map((url, index) => `
            <button type="button" data-image="${esc(url)}" aria-label="Show product image ${index + 1}" aria-pressed="${index === 0 ? 'true' : 'false'}">
              <img src="${esc(url)}" alt="" loading="lazy" decoding="async">
            </button>`).join('')}</div>` : ''}
        </div>
        <div class="item-details-column">
          <div class="eyebrow">${esc(item.category)}</div>
          <h1>${esc(item.name)}</h1>
          <div class="item-price">${money(item.price_per_week)} / week</div>
          <p>${esc(item.description).replace(/\n/g, '<br>')}</p>
          ${item.specifications ? `<p>${esc(item.specifications).replace(/\n/g, '<br>')}</p>` : ''}
          <p class="muted">Availability is confirmed manually when we respond to your enquiry.</p>
          <button class="button button-dark" id="add-item" type="button">Add to enquiry list <span>↗</span></button>
        </div>
      </div>`;

    root.querySelectorAll('[data-image]').forEach(button => {
      button.addEventListener('click', () => {
        const main = root.querySelector('#main-image');
        if (!main) return;
        main.src = button.dataset.image;
        root.querySelectorAll('[data-image]').forEach(other => other.setAttribute('aria-pressed', String(other === button)));
      });
    });

    root.querySelector('#add-item').addEventListener('click', () => {
      const cart = JSON.parse(localStorage.getItem('dbavl_cart') || '[]');
      const row = cart.find(entry => entry.id === item.id);
      if (row) row.quantity++;
      else cart.push({ id: item.id, name: item.name, price: Number(item.price_per_week), quantity: 1 });
      localStorage.setItem('dbavl_cart', JSON.stringify(cart));
      location.href = '/?enquiry=1';
    });
  } catch (_) {
    root.innerHTML = '<div class="empty-state">We couldn’t find that item. <a href="/">Return to equipment</a>.</div>';
  }
}

run();

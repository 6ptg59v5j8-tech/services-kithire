const root = document.querySelector('#item-content');

const pathParts = location.pathname.split('/').filter(Boolean);
const itemIndex = pathParts.indexOf('item');
const slug = itemIndex >= 0 ? decodeURIComponent(pathParts[itemIndex + 1] || '') : '';

const money = value => new Intl.NumberFormat('en-GB', {
  style: 'currency',
  currency: 'GBP'
}).format(Number(value) || 0);

const esc = value => String(value ?? '').replace(/[&<>"']/g, char => ({
  '&': '&amp;',
  '<': '&lt;',
  '>': '&gt;',
  '"': '&quot;',
  "'": '&#39;'
}[char]));

function showMessage(title, message) {
  root.innerHTML = `
    <div class="empty-state">
      <h1>${esc(title)}</h1>
      <p>${esc(message)}</p>
      <a class="text-link" href="/#equipment">Browse equipment</a>
    </div>
  `;
}

async function loadItem() {
  if (!root) return;

  if (!slug) {
    showMessage('Equipment details', 'Choose an item from the equipment catalogue to view its details.');
    return;
  }

  try {
    const response = await fetch('/api/equipment/slug/' + encodeURIComponent(slug), {
      headers: { 'Accept': 'application/json' }
    });

    let data = {};
    try {
      data = await response.json();
    } catch {
      throw new Error('The equipment service returned an invalid response.');
    }

    if (!response.ok || !data.equipment) {
      throw new Error(data.error || 'This equipment item could not be found.');
    }

    const item = data.equipment;
    let gallery = [];

    try {
      const parsed = JSON.parse(item.gallery_json || '[]');
      if (Array.isArray(parsed)) gallery = parsed.filter(url => typeof url === 'string' && url);
    } catch {
      gallery = [];
    }

    root.innerHTML = `
      <div class="item-layout">
        <div>
          <img class="item-main-image" id="main-image" src="${esc(item.image_url || '')}" alt="${esc(item.name)}">
          ${gallery.length ? `
            <div class="item-gallery">
              ${gallery.map(url => `<img src="${esc(url)}" data-image="${esc(url)}" alt="Additional view of ${esc(item.name)}" loading="lazy">`).join('')}
            </div>
          ` : ''}
        </div>
        <div>
          <div class="eyebrow">${esc(item.category)}</div>
          <h1>${esc(item.name)}</h1>
          <div class="item-price">${money(item.price_per_week)} / week</div>
          <p class="item-description">${esc(item.description || '')}</p>
          ${item.specifications ? `<p class="item-specifications">${esc(item.specifications).replace(/\n/g, '<br>')}</p>` : ''}
          <p class="muted">Availability is confirmed manually when we respond to your enquiry.</p>
          <button class="button button-dark" id="add-item" type="button">Add to enquiry list <span>↗</span></button>
        </div>
      </div>
    `;

    root.querySelectorAll('[data-image]').forEach(image => {
      image.addEventListener('click', () => {
        const mainImage = root.querySelector('#main-image');
        if (mainImage) mainImage.src = image.dataset.image;
      });
    });

    root.querySelector('#add-item').addEventListener('click', () => {
      let cart = [];
      try {
        cart = JSON.parse(localStorage.getItem('dbavl_cart') || '[]');
        if (!Array.isArray(cart)) cart = [];
      } catch {
        cart = [];
      }

      const existing = cart.find(row => row.id === item.id);
      if (existing) {
        existing.quantity = Number(existing.quantity || 0) + 1;
      } else {
        cart.push({
          id: item.id,
          name: item.name,
          price: Number(item.price_per_week) || 0,
          quantity: 1
        });
      }

      localStorage.setItem('dbavl_cart', JSON.stringify(cart));
      location.href = '/?enquiry=1';
    });
  } catch (error) {
    showMessage('Item unavailable', error.message || 'We could not load this equipment item. Please try again.');
  }
}

loadItem();

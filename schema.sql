PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS equipment (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  category TEXT NOT NULL DEFAULT '',
  description TEXT NOT NULL DEFAULT '',
  specifications TEXT NOT NULL DEFAULT '',
  image_url TEXT NOT NULL DEFAULT '',
  gallery_json TEXT NOT NULL DEFAULT '[]',
  price_per_week REAL NOT NULL DEFAULT 0,
  quantity_available INTEGER NOT NULL DEFAULT 0,
  is_visible INTEGER NOT NULL DEFAULT 1,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS site_settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS enquiries (
  id TEXT PRIMARY KEY,
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  customer_phone TEXT NOT NULL DEFAULT '',
  event_date TEXT NOT NULL DEFAULT '',
  message TEXT NOT NULL DEFAULT '',
  items_json TEXT NOT NULL DEFAULT '[]',
  estimated_total REAL NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'New',
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS admin_sessions (
  token_hash TEXT PRIMARY KEY,
  expires_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL DEFAULT (unixepoch())
);

CREATE INDEX IF NOT EXISTS idx_equipment_visible_order ON equipment(is_visible, sort_order);
CREATE INDEX IF NOT EXISTS idx_enquiries_created ON enquiries(created_at DESC);

INSERT OR IGNORE INTO categories(id,name,sort_order) VALUES
('cat-audio','Audio',1),('cat-lighting','Lighting',2),('cat-video','Video',3),('cat-staging','Staging',4),('cat-other','Other',5);

INSERT OR IGNORE INTO site_settings(key,value) VALUES
('business_name','DBAVL'),
('tagline','Professional AV equipment hire'),
('hero_title','The right kit. Ready for your next production.'),
('hero_text','Professional audio, lighting and visual equipment hire for productions, venues and events.'),
('about_title','Straightforward kit hire.'),
('about_text','DBAVL provides dependable audio, lighting and AV equipment for productions and events. Tell us what you need and when you need it, and we’ll come back to you with availability and a clear weekly hire price.'),
('contact_email','enquiries@dbavl.co.uk'),
('phone',''),
('location','Birmingham, UK'),
('announcement_text','Professional AV equipment hire — enquire for your dates.'),
('announcement_enabled','1'),
('logo_url',''),
('favicon_url',''),
('about_image_url',''),
('instagram_url',''),
('facebook_url',''),
('footer_text','DBAVL · Professional AV equipment hire');

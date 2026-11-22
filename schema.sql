PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS equipment (
 id TEXT PRIMARY KEY, name TEXT NOT NULL, slug TEXT NOT NULL UNIQUE,
 category TEXT NOT NULL DEFAULT '', description TEXT NOT NULL DEFAULT '',
 specifications TEXT NOT NULL DEFAULT '', image_url TEXT NOT NULL DEFAULT '',
 price TEXT NOT NULL DEFAULT '', price_per_week REAL NOT NULL DEFAULT 0,
 quantity_available INTEGER NOT NULL DEFAULT 1, gallery_json TEXT NOT NULL DEFAULT '[]',
 is_available INTEGER NOT NULL DEFAULT 1, sort_order INTEGER NOT NULL DEFAULT 0,
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS admin_sessions(token_hash TEXT PRIMARY KEY,expires_at INTEGER NOT NULL,created_at INTEGER NOT NULL DEFAULT (unixepoch()));
CREATE TABLE IF NOT EXISTS site_settings(key TEXT PRIMARY KEY,value TEXT NOT NULL DEFAULT '');
CREATE TABLE IF NOT EXISTS enquiries(id TEXT PRIMARY KEY,customer_name TEXT NOT NULL,customer_email TEXT NOT NULL,customer_phone TEXT NOT NULL DEFAULT '',start_date TEXT NOT NULL,end_date TEXT NOT NULL,items_json TEXT NOT NULL,weekly_total REAL NOT NULL DEFAULT 0,message TEXT NOT NULL DEFAULT '',status TEXT NOT NULL DEFAULT 'New',created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE INDEX IF NOT EXISTS idx_equipment_visible ON equipment(is_available,sort_order);
CREATE INDEX IF NOT EXISTS idx_enquiries_created ON enquiries(created_at DESC);

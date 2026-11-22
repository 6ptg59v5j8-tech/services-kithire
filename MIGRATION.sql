-- Run once in the dbavl-db D1 console. Existing equipment records are preserved.
ALTER TABLE equipment ADD COLUMN price_per_week REAL NOT NULL DEFAULT 0;
ALTER TABLE equipment ADD COLUMN quantity_available INTEGER NOT NULL DEFAULT 1;
CREATE TABLE IF NOT EXISTS site_settings (setting_key TEXT PRIMARY KEY, setting_value TEXT NOT NULL DEFAULT '');

-- Run once in the existing dbavl-db D1 database.
-- This preserves all existing equipment rows.
-- The earlier DBAVL setup added price_per_week and quantity_available.
-- If either column is missing, add it separately using the optional statements at the bottom.
ALTER TABLE equipment ADD COLUMN gallery_json TEXT NOT NULL DEFAULT '[]';
CREATE TABLE IF NOT EXISTS site_settings(key TEXT PRIMARY KEY,value TEXT NOT NULL DEFAULT '');
CREATE TABLE IF NOT EXISTS enquiries(
 id TEXT PRIMARY KEY, customer_name TEXT NOT NULL, customer_email TEXT NOT NULL,
 customer_phone TEXT NOT NULL DEFAULT '', start_date TEXT NOT NULL, end_date TEXT NOT NULL,
 items_json TEXT NOT NULL, weekly_total REAL NOT NULL DEFAULT 0, message TEXT NOT NULL DEFAULT '',
 status TEXT NOT NULL DEFAULT 'New', created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_enquiries_created ON enquiries(created_at DESC);

-- ONLY if these columns do not already exist, run these separately:
-- ALTER TABLE equipment ADD COLUMN price_per_week REAL NOT NULL DEFAULT 0;
-- ALTER TABLE equipment ADD COLUMN quantity_available INTEGER NOT NULL DEFAULT 1;

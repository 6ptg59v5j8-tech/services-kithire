# DBAVL Equipment Hire Website

Separate Cloudflare Pages website for DBAVL. It is independent from the Daniel Burden portfolio.

## Included
- Premium responsive equipment catalogue and individual equipment pages
- Private `/admin` dashboard (no public admin link)
- Editable branding, logo, favicon, About photo, social links, homepage copy, section visibility and announcement banner
- Equipment management: weekly price, manual stock quantity, category, description, specifications, main image, multiple gallery images, visibility and display order
- Category list editor and customer enquiry management
- Inquiry basket with weekly estimate only; no online booking, payment or stock reservation
- D1 storage and R2 image uploads

## Deploy
1. Upload the contents of this folder to your existing DBAVL GitHub repository.
2. Use your existing DBAVL Cloudflare Pages project, with build output directory `public` and no build command.
3. Keep your real working `wrangler.toml` database ID. Do not deploy a placeholder UUID.
4. Confirm Cloudflare Pages has D1 binding `DB` pointing to your existing `dbavl-db`, and R2 binding `MEDIA` pointing to `dbavl-media`.
5. Keep `ADMIN_EMAIL` and `ADMIN_PASSWORD` set as Pages environment variables/secrets.
6. Redeploy, then visit `https://dbavl.co.uk/admin`.

## Existing database compatibility
The API now checks the existing D1 schema and safely adds missing DBAVL fields (`price_per_week`, `quantity_available`, `gallery_json`) plus the settings and enquiries tables. It does not delete or recreate existing equipment rows. No manual SQL update is required. The first API request after deployment performs this compatibility check.

## Enquiries and email
Enquiries are saved in the dashboard. Email notifications require `RESEND_API_KEY` and a verified `EMAIL_FROM` sender. `ENQUIRY_EMAIL` defaults to `enquiries@dbavl.co.uk`. Without email configuration, the enquiry is still saved and the customer sees that email delivery is not configured. A hire is only confirmed after DBAVL replies.

## Important
- Do not connect this project to the portfolio database or bucket.
- Do not replace your working `wrangler.toml` with a file containing `REPLACE_WITH_YOUR_NEW_D1_DATABASE_ID`.

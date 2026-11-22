# DBAVL Equipment Hire Website

A separate Cloudflare Pages site for DBAVL. It does not connect to or modify the Daniel Burden portfolio project or database.

## Included
- Public equipment catalogue and individual equipment pages
- Enquiry form that opens a pre-addressed email to enquiries@dbavl.co.uk (no online payment or automatic booking)
- Private admin at `/admin` (served from `public/admin/index.html`) with equipment create/edit/delete, pricing, specs, availability and image uploads
- D1 inventory/session database and R2 image storage
- Original portfolio visual styling: Manrope + DM Mono, paper background, dark ink and lime accent
- No admin link or admin button on the public website

## Cloudflare setup (new project only)
1. Create a NEW GitHub repository for this site and upload the contents of this folder.
2. Create a NEW Cloudflare Pages project connected to that repository. Build output directory: `public`. No build command is required.
3. Create a NEW D1 database named `dbavl-db`. Run `schema.sql` once in that database's Console.
4. Copy the new database ID into `wrangler.toml`, replacing `REPLACE_WITH_YOUR_NEW_D1_DATABASE_ID`.
5. Create a NEW R2 bucket named `dbavl-media`.
6. In Cloudflare Pages project settings, add bindings: D1 database binding `DB` -> `dbavl-db`; R2 bucket binding `MEDIA` -> `dbavl-media`. Redeploy after adding bindings.
7. Add environment variables/secrets for the Pages project: `ADMIN_EMAIL` = your chosen admin email; `ADMIN_PASSWORD` = a strong unique password. Do not use your portfolio admin password.
8. Add `dbavl.co.uk` as a custom domain to this NEW Pages project after deployment. Follow Cloudflare's domain verification instructions.

## Admin
Visit `https://dbavl.co.uk/admin`. The public website intentionally has no admin link.

## Enquiries
The item enquiry form uses a `mailto:` link addressed to `enquiries@dbavl.co.uk`. It opens the visitor's configured email app; it does not silently send email from the server. The visitor must send the email. A hire is not confirmed until you reply.

## Important
- Never connect this project to the portfolio D1 database or R2 bucket.
- Do not copy the portfolio `wrangler.toml` database ID or bindings.
- Do not upload this repository into the existing portfolio GitHub repository.

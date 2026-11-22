# DBAVL — complete equipment hire website

A standalone Cloudflare Pages website for DBAVL. It includes a public equipment catalogue, weekly hire pricing, enquiry list, enquiry submission, a private admin dashboard, equipment and category management, image uploads, site content/branding controls, and enquiry management.

## Important behaviour

- Hire pricing is **weekly**.
- Availability is controlled manually by the quantity field in the admin dashboard.
- Enquiries are not bookings and do not reserve stock.
- The estimated weekly total is an estimate only.
- New enquiries are saved in D1. Email notifications to DBAVL and the customer require the Resend settings below.
- The public site contains no admin link. Open `/admin` directly.

## 1. Create Cloudflare resources

Create a Cloudflare Pages project connected to this repository, with the build output directory set to `public`. No build command is required.

Create:
- A D1 database (for example `dbavl-db`)
- An R2 bucket (for example `dbavl-media`)

In Cloudflare Pages → Settings → Functions → Bindings, add:
- D1 database binding: variable name `DB`, select your D1 database
- R2 bucket binding: variable name `MEDIA`, select your R2 bucket

## 2. Create the database tables

For a **new empty D1 database**, open D1 → Console and run the complete contents of `schema.sql`.

If you are reusing a database that contains the older DBAVL `equipment` and `admin_sessions` tables, do not drop or replace it. Run `MIGRATION-OLDER-DBAVL.sql` instead. It adds the new columns and tables while retaining existing equipment rows. Back up the database first.

## 3. Set admin and email secrets

In Cloudflare Pages → Settings → Variables and Secrets, add these as encrypted secrets where appropriate:

- `ADMIN_EMAIL` — your admin login email
- `ADMIN_PASSWORD` — a strong unique admin password
- `RESEND_API_KEY` — Resend API key (needed for email notifications)
- `EMAIL_FROM` — a sender address verified with Resend, e.g. `DBAVL <enquiries@dbavl.co.uk>`
- `ENQUIRY_EMAIL` — `enquiries@dbavl.co.uk`

Redeploy after changing environment variables. The admin credentials are not stored in the website database.

## 4. Domain

In Cloudflare Pages → Custom domains, add `dbavl.co.uk` and follow the DNS instructions shown by Cloudflare. Also add `www.dbavl.co.uk` if you want the www version.

## 5. Admin dashboard

Visit `https://dbavl.co.uk/admin`. There is deliberately no public navigation link to the dashboard.

The dashboard lets you:
- Add, edit, hide and delete equipment
- Set category, weekly price, quantity, sort order, description and specifications
- Upload a main image and multiple gallery images to R2
- Manage equipment categories
- Edit homepage and About text, contact details, logo, favicon URL, About image, social links and announcement banner
- Review enquiries and update their status

## 6. Email delivery

Enquiries are saved in D1 even if email delivery is not configured. To send notifications to both DBAVL and the customer, configure Resend and verify the sender domain. The app uses `ENQUIRY_EMAIL` (default `enquiries@dbavl.co.uk`) for the business notification.

## 7. Existing data

The migration file is additive and does not delete existing equipment records. Review it before running against a production database. Keep a backup before applying any schema change.

## Notes

- This is an enquiry-led hire catalogue, not an online booking or payment platform.
- Stock quantities are manually maintained by DBAVL.
- The public catalogue only displays items marked visible.
- Uploaded images are stored in R2 and served through the Pages Function.

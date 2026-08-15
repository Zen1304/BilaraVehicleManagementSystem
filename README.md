# Bilara Vehicle Management — Cloudflare Web App

This is the parallel replacement for the Apps Script/Google Sheets application.

## Local development

1. Install Node.js and Wrangler.
2. From this directory run `wrangler d1 create bilara-vms` and place the returned database ID in `wrangler.toml`.
3. Run `wrangler d1 execute bilara-vms --local --file=schema.sql`.
4. Run `wrangler dev`.

To prepare an import from a read-only Sheets snapshot, save the workbook tabs as a JSON object keyed by tab name and run `node scripts/convert-snapshot.mjs snapshot.json migration.sql`. The importer intentionally starts with users, vehicles, and washing logs; the remaining relationship-heavy tables will be added after the first reconciliation pass.

The existing Apps Script application remains the production system until the new app passes migration reconciliation and end-to-end testing.

## Target hosting

- Cloudflare Pages serves the static frontend.
- Cloudflare Workers provides the API.
- Cloudflare D1 provides the transactional database.
- The free `pages.dev` address is used initially; a custom domain is optional.

## Migration rule

Do not delete or modify the existing Google Sheet during migration. Import a snapshot, compare counts and relationships, then run controlled parallel validation before cutover.

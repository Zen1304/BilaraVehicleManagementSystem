# Migration plan

## First release scope

The replacement must preserve the existing identifiers and business rules for users, vehicles, bookings, trips, inspections, damages, maintenance, insurance claims, washing, files, notifications, and audit history.

## Current progress

- Cloudflare Worker/D1 project scaffold created.
- Relational schema created with foreign keys, uniqueness constraints, indexes, and booking/odometer checks.
- Static frontend shell created with the existing Bilara visual language and a dedicated Washing section.
- Read-only bootstrap endpoint created for the local D1 preview.

## Next implementation gates

1. Export a snapshot from the Google Sheets workbook.
2. Build a deterministic importer with row counts, ID preservation, and reconciliation output.
3. Add Google OAuth/Workspace identity and server-side role policies.
4. Implement transactional booking, checkout, check-in, inspection, maintenance, insurance, incident, and washing commands.
5. Add private file storage and signed download URLs.
6. Run the full critical and adversarial test suite against D1.
7. Deploy to a temporary Cloudflare Pages/Workers URL and run a parallel acceptance test.

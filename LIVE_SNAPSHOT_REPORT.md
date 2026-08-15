# Live workbook snapshot — migration baseline

Read-only inspection of workbook `1cCU1DvV7s4g0_6bej1A8Num0l9es_WJF0Iw4PXz-eQM` on 2026-08-14.

| Tab | Records observed | Migration note |
|---|---:|---|
| USERS | 6 | Four Super Admins and two Drivers; email uniqueness must be case-insensitive. |
| VEHICLES | 2 | Both vehicle records have names and registrations; operational status is stored outside the first legacy columns. |
| BOOKINGS | 3 | All observed records are `COMPLETED`; Google Sheets date serials require conversion to ISO timestamps. |
| TRIPS | 3 | All observed records have checkout/check-in odometer data. |
| INSPECTIONS | 3 | Legacy inspection columns are present; status fields need explicit mapping during import. |
| DAMAGES | 3 | Incident rows include both “No Damage” and “One Damage” descriptions. |
| MAINTENANCE | 0 | No records observed. |
| INSURANCE_CLAIMS | 1 | One claim observed with `SETTLED` status. |
| WASHING_LOG | 0 | Washing table exists and is ready for new records. |

The live workbook was not modified. The migration importer must preserve IDs and convert Sheets serial dates before insertion. Rows are not copied into source control because the workbook contains personal contact data.

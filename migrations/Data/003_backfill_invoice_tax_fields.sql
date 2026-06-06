-- Backfills SubTotal, TaxRate, TaxAmount from legacy "Tax (X%)" line items,
-- then removes those line items now that the values are stored as columns.
-- Requires Schema/013_add_invoice_tax_fields.sql to have been run first.
-- Run once on existing data before deploying the corresponding API change.

-- Backfill TaxAmount from Tax line items
UPDATE "Invoices" i
SET "TaxAmount" = (
    SELECT COALESCE(SUM(ii."Quantity" * ii."UnitPrice"), 0)
    FROM "InvoiceItems" ii
    WHERE ii."InvoiceId" = i."Id"
      AND ii."Description" ~* '^Tax(\s*\(\d+(\.\d+)?%\))?$'
);

-- Backfill TaxRate from the percentage embedded in "Tax (12%)" descriptions
UPDATE "Invoices" i
SET "TaxRate" = (
    SELECT (regexp_match(ii."Description", '\((\d+(?:\.\d+)?)%\)'))[1]::numeric
    FROM "InvoiceItems" ii
    WHERE ii."InvoiceId" = i."Id"
      AND ii."Description" ~* '^Tax\s*\(\d+(?:\.\d+)?%\)$'
    LIMIT 1
)
WHERE EXISTS (
    SELECT 1
    FROM "InvoiceItems" ii
    WHERE ii."InvoiceId" = i."Id"
      AND ii."Description" ~* '^Tax\s*\(\d+(?:\.\d+)?%\)$'
);

-- Backfill SubTotal = sum of all non-tax line items
UPDATE "Invoices" i
SET "SubTotal" = (
    SELECT COALESCE(SUM(ii."Quantity" * ii."UnitPrice"), 0)
    FROM "InvoiceItems" ii
    WHERE ii."InvoiceId" = i."Id"
      AND ii."Description" !~* '^Tax(\s*\(\d+(\.\d+)?%\))?$'
);

-- Remove legacy Tax line items now stored as columns
DELETE FROM "InvoiceItems"
WHERE "Description" ~* '^Tax(\s*\(\d+(\.\d+)?%\))?$';

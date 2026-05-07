-- Add SubTotal, TaxRate, TaxAmount as first-class columns on Invoices.
-- Backfills from existing "Tax (X%)" line items, then removes those items.
-- Run this before deploying the corresponding API change.

ALTER TABLE "Invoices"
  ADD COLUMN IF NOT EXISTS "SubTotal"  numeric(18,2) NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS "TaxRate"   numeric(5,2)  NULL,
  ADD COLUMN IF NOT EXISTS "TaxAmount" numeric(18,2) NOT NULL DEFAULT 0;

-- Backfill TaxAmount from Tax line items
UPDATE "Invoices" i
SET "TaxAmount" = (
    SELECT COALESCE(SUM(ii."Quantity" * ii."UnitPrice"), 0)
    FROM "InvoiceItems" ii
    WHERE ii."InvoiceId" = i."Id"
      AND ii."Description" ~* '^Tax(\s*\(\d+(\.\d+)?%\))?$'
);

-- Backfill TaxRate from the rate embedded in "Tax (12%)" descriptions
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

-- Backfill SubTotal = sum of all non-tax items
UPDATE "Invoices" i
SET "SubTotal" = (
    SELECT COALESCE(SUM(ii."Quantity" * ii."UnitPrice"), 0)
    FROM "InvoiceItems" ii
    WHERE ii."InvoiceId" = i."Id"
      AND ii."Description" !~* '^Tax(\s*\(\d+(\.\d+)?%\))?$'
);

-- Remove Tax line items — now stored as fields
DELETE FROM "InvoiceItems"
WHERE "Description" ~* '^Tax(\s*\(\d+(\.\d+)?%\))?$';

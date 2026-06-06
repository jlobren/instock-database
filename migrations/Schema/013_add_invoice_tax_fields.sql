-- Adds SubTotal, TaxRate, TaxAmount as first-class columns on Invoices.
-- Backfill and cleanup of legacy Tax line items is in Data/003_backfill_invoice_tax_fields.sql.

ALTER TABLE "Invoices"
    ADD COLUMN IF NOT EXISTS "SubTotal"  numeric(18,2) NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS "TaxRate"   numeric(5,2)  NULL,
    ADD COLUMN IF NOT EXISTS "TaxAmount" numeric(18,2) NOT NULL DEFAULT 0;

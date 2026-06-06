-- Plan invoices use the PL-INV- number format and are excluded from the client invoice list.
-- Backfill of existing plan invoices is in Data/005_backfill_plan_invoice_flag.sql.

ALTER TABLE "Invoices"
    ADD COLUMN IF NOT EXISTS "IsPlanInvoice" boolean NOT NULL DEFAULT false;

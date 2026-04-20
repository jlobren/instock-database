-- Add tax rate and inclusive flag to Companies, and tax fields to Orders.
-- Run this once against the production database.

ALTER TABLE "Companies"
  ADD COLUMN IF NOT EXISTS "TaxRate"     numeric(5,2)  NULL,
  ADD COLUMN IF NOT EXISTS "TaxInclusive" boolean      NOT NULL DEFAULT false;

ALTER TABLE "Orders"
  ADD COLUMN IF NOT EXISTS "TaxRate"    numeric(5,2)  NULL,
  ADD COLUMN IF NOT EXISTS "TaxAmount"  numeric(18,2) NOT NULL DEFAULT 0;

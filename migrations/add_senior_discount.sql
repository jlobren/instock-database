-- Add senior discount percentage to Companies.
-- Run this once against the production database.

ALTER TABLE "Companies"
  ADD COLUMN IF NOT EXISTS "SeniorDiscountPercentage" numeric(5,2) NULL;

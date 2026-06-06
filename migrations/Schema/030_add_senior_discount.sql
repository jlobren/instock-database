ALTER TABLE "Companies"
    ADD COLUMN IF NOT EXISTS "SeniorDiscountPercentage" numeric(5,2) NULL;

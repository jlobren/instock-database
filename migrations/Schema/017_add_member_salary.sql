ALTER TABLE "CompanyMembers"
    ADD COLUMN IF NOT EXISTS "PayPeriod"  text,
    ADD COLUMN IF NOT EXISTS "SalaryRate" numeric(18,2);

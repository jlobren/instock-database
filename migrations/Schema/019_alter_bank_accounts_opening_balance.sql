ALTER TABLE "BankAccounts"
    ADD COLUMN IF NOT EXISTS "OpeningBalance" numeric(18,2) NOT NULL DEFAULT 0;

-- Add OpeningBalance to BankAccounts so users can set a starting balance for cash-flow tracking

ALTER TABLE "BankAccounts" ADD COLUMN IF NOT EXISTS "OpeningBalance" NUMERIC(18,2) NOT NULL DEFAULT 0;

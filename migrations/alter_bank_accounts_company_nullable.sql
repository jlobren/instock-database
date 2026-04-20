-- Make BankAccount.CompanyId nullable to support admin platform payment accounts (no company)
ALTER TABLE "BankAccounts" ALTER COLUMN "CompanyId" DROP NOT NULL;

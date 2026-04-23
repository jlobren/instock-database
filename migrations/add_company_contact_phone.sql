-- Add contact phone to Companies
ALTER TABLE "Companies"
    ADD COLUMN IF NOT EXISTS "ContactPhone" TEXT;

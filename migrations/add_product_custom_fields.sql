ALTER TABLE "Products"
    ADD COLUMN IF NOT EXISTS "CustomFields" jsonb NOT NULL DEFAULT '{}';

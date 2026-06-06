ALTER TABLE "DayCloseRecords"
    ADD COLUMN IF NOT EXISTS "StartingCash" numeric(18,2) NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS "OpenedByName" text,
    ADD COLUMN IF NOT EXISTS "OpenedAt"     timestamptz;

-- Add opening-of-day fields to DayCloseRecords
ALTER TABLE "DayCloseRecords" ADD COLUMN IF NOT EXISTS "StartingCash" NUMERIC(18,2) NOT NULL DEFAULT 0;
ALTER TABLE "DayCloseRecords" ADD COLUMN IF NOT EXISTS "OpenedByName" TEXT;
ALTER TABLE "DayCloseRecords" ADD COLUMN IF NOT EXISTS "OpenedAt"     TIMESTAMPTZ;

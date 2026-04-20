-- Add AI analysis usage tracking columns to AppUsers
-- Run this once against the production database.

ALTER TABLE "AppUsers"
  ADD COLUMN IF NOT EXISTS "AiAnalysisCount"   integer                  NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS "AiAnalysisResetAt"  timestamp with time zone NOT NULL
    DEFAULT (date_trunc('month', now() AT TIME ZONE 'UTC') + interval '1 month');

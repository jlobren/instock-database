-- Add Shopee integration fields to AppUsers
ALTER TABLE "AppUsers"
    ADD COLUMN IF NOT EXISTS "ShopeeShopId"                BIGINT,
    ADD COLUMN IF NOT EXISTS "ShopeeShopName"              TEXT,
    ADD COLUMN IF NOT EXISTS "ShopeeAccessToken"           TEXT,
    ADD COLUMN IF NOT EXISTS "ShopeeRefreshToken"          TEXT,
    ADD COLUMN IF NOT EXISTS "ShopeeAccessTokenExpiresAt"  TIMESTAMP WITH TIME ZONE,
    ADD COLUMN IF NOT EXISTS "ShopeeRefreshTokenExpiresAt" TIMESTAMP WITH TIME ZONE;

-- Add Shopee feature flag to PlanConfigs
ALTER TABLE "PlanConfigs"
    ADD COLUMN IF NOT EXISTS "HasShopeeIntegration" BOOLEAN NOT NULL DEFAULT FALSE;

-- Enable Shopee for Pro and Business tiers (if rows already exist)
UPDATE "PlanConfigs"
SET "HasShopeeIntegration" = TRUE
WHERE "Name" IN ('Pro', 'Business');

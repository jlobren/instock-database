-- Adds Shopee OAuth fields to AppUsers and the feature flag column to PlanConfigs.
-- Plan tier data update is in Data/004_seed_plan_configs_shopee.sql.

ALTER TABLE "AppUsers"
    ADD COLUMN IF NOT EXISTS "ShopeeShopId"                bigint,
    ADD COLUMN IF NOT EXISTS "ShopeeShopName"              text,
    ADD COLUMN IF NOT EXISTS "ShopeeAccessToken"           text,
    ADD COLUMN IF NOT EXISTS "ShopeeRefreshToken"          text,
    ADD COLUMN IF NOT EXISTS "ShopeeAccessTokenExpiresAt"  timestamptz,
    ADD COLUMN IF NOT EXISTS "ShopeeRefreshTokenExpiresAt" timestamptz;

ALTER TABLE "PlanConfigs"
    ADD COLUMN IF NOT EXISTS "HasShopeeIntegration" boolean NOT NULL DEFAULT false;

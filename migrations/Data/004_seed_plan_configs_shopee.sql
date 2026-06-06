-- Enables the Shopee integration feature for Pro and Business tiers.
-- Requires Schema/024_add_shopee_integration.sql to have been run first.

UPDATE "PlanConfigs"
SET "HasShopeeIntegration" = true
WHERE "Name" IN ('Pro', 'Business');

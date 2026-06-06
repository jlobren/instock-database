-- Creates ProductVariations table and adds the feature flag to PlanConfigs.
-- Plan tier data update is in Data/002_seed_plan_configs_product_variations.sql.

CREATE TABLE IF NOT EXISTS "ProductVariations" (
    "Id"            uuid          NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "ProductId"     uuid          NOT NULL,
    "ClientId"      text          NOT NULL,
    "Name"          text          NOT NULL,
    "Price"         numeric(18,2) NOT NULL,
    "SupplierPrice" numeric(18,2),
    "SortOrder"     integer       NOT NULL DEFAULT 0,
    CONSTRAINT "FK_ProductVariations_Products_ProductId"
        FOREIGN KEY ("ProductId") REFERENCES "Products" ("Id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "IX_ProductVariations_ProductId" ON "ProductVariations" ("ProductId");

ALTER TABLE "PlanConfigs"
    ADD COLUMN IF NOT EXISTS "HasProductVariations" boolean NOT NULL DEFAULT false;

-- Create ProductVariations table
CREATE TABLE IF NOT EXISTS "ProductVariations" (
    "Id"            UUID                     NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "ProductId"     UUID                     NOT NULL,
    "ClientId"      TEXT                     NOT NULL,
    "Name"          TEXT                     NOT NULL,
    "Price"         NUMERIC(18,2)            NOT NULL,
    "SupplierPrice" NUMERIC(18,2),
    "SortOrder"     INTEGER                  NOT NULL DEFAULT 0,
    CONSTRAINT "FK_ProductVariations_Products_ProductId"
        FOREIGN KEY ("ProductId") REFERENCES "Products" ("Id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "IX_ProductVariations_ProductId"
    ON "ProductVariations" ("ProductId");

-- Add HasProductVariations feature flag to PlanConfigs
ALTER TABLE "PlanConfigs"
    ADD COLUMN IF NOT EXISTS "HasProductVariations" BOOLEAN NOT NULL DEFAULT FALSE;

-- Enable Product Variations for Pro and Business tiers (if rows already exist)
UPDATE "PlanConfigs"
SET "HasProductVariations" = TRUE
WHERE "Name" IN ('Pro', 'Business');

-- Add ProductCapacities table to store multiple weight/volume measurements per product.
-- Run this once against the production database.

CREATE TABLE IF NOT EXISTS "ProductCapacities" (
    "Id"        uuid            NOT NULL DEFAULT gen_random_uuid(),
    "ProductId" uuid            NOT NULL,
    "ClientId"  text            NOT NULL,
    "Value"     numeric(18,4)   NOT NULL,
    "Unit"      text            NOT NULL,
    "SortOrder" integer         NOT NULL DEFAULT 0,
    CONSTRAINT "PK_ProductCapacities" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_ProductCapacities_Products_ProductId"
        FOREIGN KEY ("ProductId") REFERENCES "Products" ("Id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "IX_ProductCapacities_ProductId" ON "ProductCapacities" ("ProductId");

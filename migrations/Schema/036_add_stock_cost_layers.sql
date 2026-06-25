-- FIFO cost layers + per-movement price snapshots.
--
-- Stock movements now snapshot the cost/selling price effective at the time, and each stock-in
-- opens a FIFO "cost layer" that later stock-outs consume oldest-first. Inventory valuation and
-- COGS read these captured prices instead of the product's current price, so historical numbers
-- stay stable when a product's price later changes.

-- ── Per-movement price snapshot columns ──────────────────────────────────────────────────────
ALTER TABLE "StockMovements"
    ADD COLUMN IF NOT EXISTS "UnitCost"  numeric(18,2);
ALTER TABLE "StockMovements"
    ADD COLUMN IF NOT EXISTS "UnitPrice" numeric(18,2);

-- ── FIFO cost layers table ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS "StockCostLayers" (
    "Id"                uuid          NOT NULL PRIMARY KEY,
    "ProductId"         uuid          NOT NULL,
    "ClientId"          text          NOT NULL,
    "UnitCost"          numeric(18,2) NOT NULL DEFAULT 0,
    "UnitPrice"         numeric(18,2) NOT NULL DEFAULT 0,
    "OriginalQuantity"  numeric       NOT NULL DEFAULT 0,
    "QuantityRemaining" numeric       NOT NULL DEFAULT 0,
    "SourceMovementId"  uuid          NULL,
    "CreatedAt"         timestamptz   NOT NULL DEFAULT now(),
    CONSTRAINT "FK_StockCostLayers_Products_ProductId"
        FOREIGN KEY ("ProductId") REFERENCES "Products" ("Id") ON DELETE CASCADE
);

-- FIFO consumption reads the oldest open layers for a product.
CREATE INDEX IF NOT EXISTS "IX_StockCostLayers_ProductId_CreatedAt"
    ON "StockCostLayers" ("ProductId", "CreatedAt")
    WHERE "QuantityRemaining" > 0;

-- ── Backfill ─────────────────────────────────────────────────────────────────────────────────
-- 1. Seed one opening layer per product that currently has stock but no layers yet, valued at
--    the product's current supplier/selling price. Guarded so re-running is a no-op.
INSERT INTO "StockCostLayers"
    ("Id", "ProductId", "ClientId", "UnitCost", "UnitPrice",
     "OriginalQuantity", "QuantityRemaining", "SourceMovementId", "CreatedAt")
SELECT gen_random_uuid(), p."Id", p."ClientId",
       COALESCE(p."SupplierPrice", 0), p."Price",
       p."Stock", p."Stock", NULL, now()
FROM   "Products" p
WHERE  p."Stock" > 0
  AND  NOT EXISTS (SELECT 1 FROM "StockCostLayers" l WHERE l."ProductId" = p."Id");

-- 2. Backfill existing movements' price snapshots from the product's current prices, so historical
--    reports keep working. Only fills rows not yet stamped.
UPDATE "StockMovements" sm
SET    "UnitCost"  = COALESCE(p."SupplierPrice", 0),
       "UnitPrice" = p."Price"
FROM   "Products" p
WHERE  sm."ProductId" = p."Id"
  AND  sm."UnitCost" IS NULL;

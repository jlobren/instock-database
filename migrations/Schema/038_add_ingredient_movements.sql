-- IngredientMovements — a lean mirror of "StockMovements" for ingredients. Each movement snapshots
-- the ingredient's unit cost at the time, so changes in ingredient cost over time can be monitored.
--
-- Unlike "StockMovements" there is no "UnitPrice" (ingredients aren't sold) and no FIFO cost layers
-- (cost history is captured by the per-movement "UnitCost" snapshot + the ingredient's SupplierPrice).

CREATE TABLE IF NOT EXISTS "IngredientMovements" (
    "Id"              uuid          NOT NULL DEFAULT gen_random_uuid(),
    "IngredientId"    uuid          NOT NULL,
    "ClientId"        text          NOT NULL,
    "StockBefore"     numeric       NOT NULL,
    "Change"          numeric       NOT NULL,
    "UnitCost"        numeric(18,2) NULL,
    "Reason"          text          NOT NULL,
    "Note"            text          NULL,
    "CreatedByDevice" text          NOT NULL DEFAULT '',
    "CreatedAt"       timestamptz   NOT NULL DEFAULT now(),
    "OrderId"         uuid          NULL,
    CONSTRAINT "PK_IngredientMovements" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_IngredientMovements_Ingredients_IngredientId"
        FOREIGN KEY ("IngredientId") REFERENCES "Ingredients" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_IngredientMovements_Orders_OrderId"
        FOREIGN KEY ("OrderId") REFERENCES "Orders" ("Id") ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS "IX_IngredientMovements_IngredientId_CreatedAt"
    ON "IngredientMovements" ("IngredientId", "CreatedAt");

CREATE INDEX IF NOT EXISTS "IX_IngredientMovements_OrderId" ON "IngredientMovements" ("OrderId");

-- ── Backfill ─────────────────────────────────────────────────────────────────────────────────
-- Carry over the movement history of products that became ingredients, preserving each movement's
-- cost snapshot ("UnitCost") so historical cost-change reporting keeps working. Ids are preserved
-- so "IngredientId" equals the old "StockMovements"."ProductId". Guarded for idempotency.
INSERT INTO "IngredientMovements"
    ("Id", "IngredientId", "ClientId", "StockBefore", "Change", "UnitCost", "Reason", "Note",
     "CreatedByDevice", "CreatedAt", "OrderId")
SELECT sm."Id", sm."ProductId", sm."ClientId", sm."StockBefore", sm."Change", sm."UnitCost",
       sm."Reason", sm."Note", sm."CreatedByDevice", sm."CreatedAt", sm."OrderId"
FROM   "StockMovements" sm
JOIN   "Products" p ON p."Id" = sm."ProductId" AND p."IsIngredient" = true
WHERE  NOT EXISTS (SELECT 1 FROM "IngredientMovements" im WHERE im."Id" = sm."Id");

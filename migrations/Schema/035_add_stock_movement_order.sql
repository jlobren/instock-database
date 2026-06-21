-- Links stock movements to the order that caused them (Sale, Return, Order fulfillment),
-- so the movement history can show the order number, customer name and address.
-- Manual adjustments leave "OrderId" NULL.

ALTER TABLE "StockMovements"
    ADD COLUMN IF NOT EXISTS "OrderId" uuid;

-- FK to Orders; when an order is deleted the movement is kept but unlinked.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'FK_StockMovements_Orders_OrderId'
    ) THEN
        ALTER TABLE "StockMovements"
            ADD CONSTRAINT "FK_StockMovements_Orders_OrderId"
            FOREIGN KEY ("OrderId") REFERENCES "Orders" ("Id") ON DELETE SET NULL;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS "IX_StockMovements_OrderId" ON "StockMovements" ("OrderId");

-- Backfill historical rows. Order-driven movements stored the order number in the note as
-- "Order {OrderNumber}" (Sale / Order fulfillment) or "Order {OrderNumber} cancelled" (Return).
-- Scoped by ClientId so order numbers can't collide across tenants.
UPDATE "StockMovements" sm
SET    "OrderId" = o."Id"
FROM   "Orders" o
WHERE  sm."OrderId" IS NULL
  AND  sm."ClientId" = o."ClientId"
  AND  sm."Note" IS NOT NULL
  AND  (sm."Note" = 'Order ' || o."OrderNumber"
        OR sm."Note" = 'Order ' || o."OrderNumber" || ' cancelled');

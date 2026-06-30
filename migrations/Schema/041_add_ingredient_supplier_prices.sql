-- Ingredient supplier prices + weighted-average costing.
--
-- An ingredient can now hold MULTIPLE supplier prices (purchase options), each a price for a pack
-- quantity in a unit — e.g. water at ₱50 / 20 L and ₱100 / 45 L. Stock additions choose a unit and
-- may override the price, recording their own unit cost; the ingredient tracks a moving
-- weighted-average cost ("AverageUnitCost", per base unit) which recipes use for costing.

-- ── IngredientSupplierPrices ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS "IngredientSupplierPrices" (
    "Id"           uuid          NOT NULL DEFAULT gen_random_uuid(),
    "IngredientId" uuid          NOT NULL,
    "Label"        text          NULL,
    "Price"        numeric(18,2) NOT NULL,
    "Quantity"     numeric       NOT NULL,
    "UnitType"     text          NOT NULL DEFAULT 'pcs',
    "SortOrder"    integer       NOT NULL DEFAULT 0,
    "CreatedAt"    timestamptz   NOT NULL DEFAULT now(),
    CONSTRAINT "PK_IngredientSupplierPrices" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_IngredientSupplierPrices_Ingredients_IngredientId"
        FOREIGN KEY ("IngredientId") REFERENCES "Ingredients" ("Id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "IX_IngredientSupplierPrices_IngredientId"
    ON "IngredientSupplierPrices" ("IngredientId");

-- ── Ingredients.AverageUnitCost ────────────────────────────────────────────────────────────────
-- Moving weighted-average cost per base unit ("UnitType"). Source of truth for recipe costing.
ALTER TABLE "Ingredients" ADD COLUMN IF NOT EXISTS "AverageUnitCost" numeric(18,2) NULL;

-- Best-effort seed: where stock exists and no average is set yet, fall back to the old SupplierPrice.
UPDATE "Ingredients"
SET    "AverageUnitCost" = "SupplierPrice"
WHERE  "AverageUnitCost" IS NULL
  AND  "SupplierPrice"   IS NOT NULL
  AND  "Stock" > 0;

-- ── IngredientMovements: what the user actually entered ─────────────────────────────────────────
-- "Change" is stored in the ingredient's base unit; these capture the originally entered amount/unit
-- (e.g. "added 20 L") for display in stock history.
ALTER TABLE "IngredientMovements" ADD COLUMN IF NOT EXISTS "EnteredQuantity" numeric NULL;
ALTER TABLE "IngredientMovements" ADD COLUMN IF NOT EXISTS "EnteredUnit"     text    NULL;

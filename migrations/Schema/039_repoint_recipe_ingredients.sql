-- Repoint recipe ingredients from "Products" to the new "Ingredients" table. Ids were preserved
-- when products were copied into "Ingredients" (script 037), so existing "ProductId" values are
-- already valid "IngredientId" values — this is a column swap, not a value remap.
--
-- Must run AFTER 037 (ingredients backfilled) and BEFORE 040 (ingredient-products deleted).

-- 1. Add the new column (nullable, mirrors the old SetNull semantics).
ALTER TABLE "RecipeIngredients" ADD COLUMN IF NOT EXISTS "IngredientId" uuid;

-- 2. Copy values across (only fill rows not yet migrated).
UPDATE "RecipeIngredients"
SET    "IngredientId" = "ProductId"
WHERE  "IngredientId" IS NULL
  AND  "ProductId" IS NOT NULL;

-- 3. Point the FK at "Ingredients" (SetNull: removing an ingredient keeps the recipe row, unlinked).
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'FK_RecipeIngredients_Ingredients_IngredientId'
    ) THEN
        ALTER TABLE "RecipeIngredients"
            ADD CONSTRAINT "FK_RecipeIngredients_Ingredients_IngredientId"
            FOREIGN KEY ("IngredientId") REFERENCES "Ingredients" ("Id") ON DELETE SET NULL;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS "IX_RecipeIngredients_IngredientId"
    ON "RecipeIngredients" ("IngredientId");

-- 4. Drop the old column (its FK to "Products" + any index are dropped with it).
ALTER TABLE "RecipeIngredients" DROP COLUMN IF EXISTS "ProductId";

-- Links products to a recipe for automated ingredient deduction on stock adjustment.
ALTER TABLE "Products"
    ADD COLUMN IF NOT EXISTS "RecipeId" uuid NULL
        REFERENCES "Recipes" ("Id") ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS "IX_Products_RecipeId" ON "Products" ("RecipeId") WHERE "RecipeId" IS NOT NULL;

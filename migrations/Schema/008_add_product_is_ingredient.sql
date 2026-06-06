ALTER TABLE "Products"
    ADD COLUMN IF NOT EXISTS "IsIngredient" boolean NOT NULL DEFAULT false;

CREATE INDEX IF NOT EXISTS "IX_Products_IsIngredient" ON "Products" ("IsIngredient") WHERE "IsIngredient" = true;

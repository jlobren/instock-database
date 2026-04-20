-- Add RecipeYields table to store how many units a recipe produces.
-- Run this once against the production database.

CREATE TABLE IF NOT EXISTS "RecipeYields" (
    "Id"        uuid           NOT NULL DEFAULT gen_random_uuid(),
    "RecipeId"  uuid           NOT NULL,
    "ClientId"  text           NOT NULL,
    "Quantity"  numeric(18,4)  NOT NULL,
    "Value"     numeric(18,4)  NULL,
    "Unit"      text           NULL,
    "SortOrder" integer        NOT NULL DEFAULT 0,
    CONSTRAINT "PK_RecipeYields" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_RecipeYields_Recipes_RecipeId"
        FOREIGN KEY ("RecipeId") REFERENCES "Recipes" ("Id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "IX_RecipeYields_RecipeId" ON "RecipeYields" ("RecipeId");

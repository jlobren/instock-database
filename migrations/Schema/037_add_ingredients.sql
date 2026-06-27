-- Ingredients table — a stripped-down sibling of "Products" (matching column names) for raw
-- materials consumed by recipes. Kept separate so an ingredient can later be promoted to a full
-- product, and so ingredient stock/cost can be tracked independently of saleable products.
--
-- Replaces the old "Products"."IsIngredient" flag (migrated then dropped in later scripts).

CREATE TABLE IF NOT EXISTS "Ingredients" (
    "Id"            uuid          NOT NULL DEFAULT gen_random_uuid(),
    "ClientId"      text          NOT NULL,
    "Name"          text          NOT NULL,
    "SKU"           text          NULL,
    "Description"   text          NULL,
    "SupplierPrice" numeric(18,2) NULL,
    "Stock"         numeric       NOT NULL DEFAULT 0,
    "UnitType"      text          NOT NULL DEFAULT 'pcs',
    "ThumbnailUrl"  text          NULL,
    "CardUrl"       text          NULL,
    "FullUrl"       text          NULL,
    "CreatedAt"     timestamptz   NOT NULL DEFAULT now(),
    "UpdatedAt"     timestamptz   NOT NULL DEFAULT now(),
    CONSTRAINT "PK_Ingredients" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_Ingredients_AppUsers_ClientId"
        FOREIGN KEY ("ClientId") REFERENCES "AppUsers" ("Id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "IX_Ingredients_ClientId" ON "Ingredients" ("ClientId");

-- Barcode is unique per tenant when present (nullable allows duplicates/blank barcodes).
CREATE UNIQUE INDEX IF NOT EXISTS "IX_Ingredients_ClientId_SKU"
    ON "Ingredients" ("ClientId", "SKU")
    WHERE "SKU" IS NOT NULL;

-- ── Backfill ─────────────────────────────────────────────────────────────────────────────────
-- Copy existing ingredient-products into the new table, PRESERVING the Id so that
-- "RecipeIngredients"."ProductId" values stay valid as "IngredientId" (repointed in script 039).
-- Picks the product's default image (falling back to its first image). Guarded so re-running is a
-- no-op.
INSERT INTO "Ingredients"
    ("Id", "ClientId", "Name", "SKU", "Description", "SupplierPrice", "Stock", "UnitType",
     "ThumbnailUrl", "CardUrl", "FullUrl", "CreatedAt", "UpdatedAt")
SELECT p."Id", p."ClientId", p."Name", p."SKU", p."Description", p."SupplierPrice", p."Stock",
       p."UnitType", img."ThumbnailUrl", img."CardUrl", img."FullUrl", p."CreatedAt", p."UpdatedAt"
FROM   "Products" p
LEFT JOIN LATERAL (
    SELECT pi."ThumbnailUrl", pi."CardUrl", pi."FullUrl"
    FROM   "ProductImages" pi
    WHERE  pi."ProductId" = p."Id"
    ORDER BY pi."IsDefault" DESC, pi."SortOrder" ASC
    LIMIT 1
) img ON true
WHERE  p."IsIngredient" = true
  AND  NOT EXISTS (SELECT 1 FROM "Ingredients" i WHERE i."Id" = p."Id");

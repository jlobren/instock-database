-- Final step of the ingredients switch: remove the now-duplicated ingredient rows from "Products"
-- and retire the "IsIngredient" flag. Their "StockMovements", "ProductImages" and "StockCostLayers"
-- are removed by ON DELETE CASCADE; their recipe links were already repointed in script 039.
--
-- Must run AFTER 037–039.

DELETE FROM "Products" WHERE "IsIngredient" = true;

DROP INDEX IF EXISTS "IX_Products_IsIngredient";

ALTER TABLE "Products" DROP COLUMN IF EXISTS "IsIngredient";

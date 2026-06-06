-- Enables the Product Variations feature for Pro and Business tiers.
-- Requires Schema/009_add_product_variations.sql to have been run first.

UPDATE "PlanConfigs"
SET "HasProductVariations" = true
WHERE "Name" IN ('Pro', 'Business');

-- Adds VariationName and PackageName to OrderItems so variation/package selection is preserved on orders.
ALTER TABLE "OrderItems"
    ADD COLUMN IF NOT EXISTS "VariationName" TEXT,
    ADD COLUMN IF NOT EXISTS "PackageName"   TEXT;

-- Product Packages: quantity-bundle pricing per product (e.g. "3 pcs for ₱150")
CREATE TABLE IF NOT EXISTS "ProductPackages" (
    "Id"            UUID          NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "ProductId"     UUID          NOT NULL REFERENCES "Products"("Id") ON DELETE CASCADE,
    "ClientId"      TEXT          NOT NULL,
    "Name"          TEXT          NOT NULL,
    "Quantity"      NUMERIC(18,4) NOT NULL DEFAULT 1,
    "Price"         NUMERIC(18,2) NOT NULL,
    "SupplierPrice" NUMERIC(18,2),
    "SortOrder"     INT           NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS ix_product_packages_product ON "ProductPackages" ("ProductId");
CREATE INDEX IF NOT EXISTS ix_product_packages_client  ON "ProductPackages" ("ClientId");

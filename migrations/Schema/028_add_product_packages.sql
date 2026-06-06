CREATE TABLE IF NOT EXISTS "ProductPackages" (
    "Id"            uuid          NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "ProductId"     uuid          NOT NULL REFERENCES "Products" ("Id") ON DELETE CASCADE,
    "ClientId"      text          NOT NULL,
    "Name"          text          NOT NULL,
    "Quantity"      numeric(18,4) NOT NULL DEFAULT 1,
    "Price"         numeric(18,2) NOT NULL,
    "SupplierPrice" numeric(18,2),
    "SortOrder"     integer       NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS "IX_ProductPackages_ProductId" ON "ProductPackages" ("ProductId");
CREATE INDEX IF NOT EXISTS "IX_ProductPackages_ClientId"  ON "ProductPackages" ("ClientId");

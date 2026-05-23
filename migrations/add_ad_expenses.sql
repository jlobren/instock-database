CREATE TABLE IF NOT EXISTS "AdExpenses" (
    "Id"          UUID             NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "ClientId"    TEXT             NOT NULL,
    "Description" TEXT             NOT NULL,
    "Amount"      NUMERIC(18,2)    NOT NULL,
    "Date"        TIMESTAMPTZ      NOT NULL,
    "ProductId"   UUID,
    "CreatedAt"   TIMESTAMPTZ      NOT NULL DEFAULT now(),
    CONSTRAINT "FK_AdExpenses_Products_ProductId"
        FOREIGN KEY ("ProductId") REFERENCES "Products" ("Id") ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS "IX_AdExpenses_ClientId_Date"
    ON "AdExpenses" ("ClientId", "Date");

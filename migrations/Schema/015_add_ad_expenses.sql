CREATE TABLE IF NOT EXISTS "AdExpenses" (
    "Id"          uuid          NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "ClientId"    text          NOT NULL,
    "Description" text          NOT NULL,
    "Amount"      numeric(18,2) NOT NULL,
    "Date"        timestamptz   NOT NULL,
    "ProductId"   uuid,
    "CreatedAt"   timestamptz   NOT NULL DEFAULT now(),
    CONSTRAINT "FK_AdExpenses_Products_ProductId"
        FOREIGN KEY ("ProductId") REFERENCES "Products" ("Id") ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS "IX_AdExpenses_ClientId_Date" ON "AdExpenses" ("ClientId", "Date");

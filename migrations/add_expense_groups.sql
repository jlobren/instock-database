CREATE TABLE IF NOT EXISTS "ExpenseGroups" (
    "Id"          UUID         NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "ClientId"    TEXT         NOT NULL,
    "Name"        TEXT         NOT NULL,
    "Description" TEXT,
    "CreatedAt"   TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS "IX_ExpenseGroups_ClientId"
    ON "ExpenseGroups" ("ClientId");

CREATE TABLE IF NOT EXISTS "ExpenseGroups" (
    "Id"          uuid        NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "ClientId"    text        NOT NULL,
    "Name"        text        NOT NULL,
    "Description" text,
    "CreatedAt"   timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS "IX_ExpenseGroups_ClientId" ON "ExpenseGroups" ("ClientId");

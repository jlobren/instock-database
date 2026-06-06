CREATE TABLE IF NOT EXISTS "GroupExpenses" (
    "Id"            UUID          NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "GroupId"       UUID          NOT NULL,
    "Name"          TEXT          NOT NULL,
    "CostType"      TEXT          NOT NULL,
    "Amount"        NUMERIC(18,2),
    "Frequency"     TEXT,
    "VariableType"  TEXT,
    "VariableValue" NUMERIC(18,4),
    "Notes"         TEXT,
    "CreatedAt"     TIMESTAMPTZ   NOT NULL DEFAULT now(),
    CONSTRAINT "FK_GroupExpenses_ExpenseGroups_GroupId"
        FOREIGN KEY ("GroupId") REFERENCES "ExpenseGroups" ("Id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "IX_GroupExpenses_GroupId"
    ON "GroupExpenses" ("GroupId");

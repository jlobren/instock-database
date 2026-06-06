CREATE TABLE IF NOT EXISTS "GroupExpenses" (
    "Id"            uuid          NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "GroupId"       uuid          NOT NULL,
    "Name"          text          NOT NULL,
    "CostType"      text          NOT NULL,
    "Amount"        numeric(18,2),
    "Frequency"     text,
    "VariableType"  text,
    "VariableValue" numeric(18,4),
    "Notes"         text,
    "CreatedAt"     timestamptz   NOT NULL DEFAULT now(),
    CONSTRAINT "FK_GroupExpenses_ExpenseGroups_GroupId"
        FOREIGN KEY ("GroupId") REFERENCES "ExpenseGroups" ("Id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "IX_GroupExpenses_GroupId" ON "GroupExpenses" ("GroupId");

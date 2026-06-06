CREATE TABLE IF NOT EXISTS "DayCloseRecords" (
    "Id"           uuid          NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "ClientId"     text          NOT NULL,
    "Date"         timestamptz   NOT NULL,
    "CashIn"       numeric(18,2) NOT NULL DEFAULT 0,
    "PhysicalCash" numeric(18,2) NOT NULL DEFAULT 0,
    "Variance"     numeric(18,2) NOT NULL DEFAULT 0,
    "Notes"        text,
    "ClosedByName" text          NOT NULL DEFAULT '',
    "ClosedAt"     timestamptz   NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS "IX_DayCloseRecords_ClientId_Date"
    ON "DayCloseRecords" ("ClientId", "Date");

-- Day Close Records: end-of-day cash reconciliation per client per date
CREATE TABLE IF NOT EXISTS "DayCloseRecords" (
    "Id"           UUID          NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "ClientId"     TEXT          NOT NULL,
    "Date"         TIMESTAMPTZ   NOT NULL,
    "CashIn"       NUMERIC(18,2) NOT NULL DEFAULT 0,
    "PhysicalCash" NUMERIC(18,2) NOT NULL DEFAULT 0,
    "Variance"     NUMERIC(18,2) NOT NULL DEFAULT 0,
    "Notes"        TEXT,
    "ClosedByName" TEXT          NOT NULL DEFAULT '',
    "ClosedAt"     TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS ix_day_close_records_client_date
    ON "DayCloseRecords" ("ClientId", "Date");

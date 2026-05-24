-- SalaryDisbursements: records of actual salary payments to team members

CREATE TABLE IF NOT EXISTS "SalaryDisbursements" (
    "Id"         UUID             NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "ClientId"   TEXT             NOT NULL,
    "MemberId"   UUID             NULL,
    "MemberName" TEXT             NOT NULL DEFAULT '',
    "Amount"     NUMERIC(18,2)    NOT NULL,
    "PeriodFrom" TIMESTAMPTZ      NOT NULL,
    "PeriodTo"   TIMESTAMPTZ      NOT NULL,
    "PaidAt"     TIMESTAMPTZ      NOT NULL,
    "Notes"      TEXT             NULL,
    "CreatedAt"  TIMESTAMPTZ      NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS "IX_SalaryDisbursements_ClientId" ON "SalaryDisbursements" ("ClientId");
CREATE INDEX IF NOT EXISTS "IX_SalaryDisbursements_PaidAt"   ON "SalaryDisbursements" ("PaidAt");

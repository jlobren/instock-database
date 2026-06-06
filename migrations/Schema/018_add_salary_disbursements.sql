CREATE TABLE IF NOT EXISTS "SalaryDisbursements" (
    "Id"         uuid          NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "ClientId"   text          NOT NULL,
    "MemberId"   uuid          NULL,
    "MemberName" text          NOT NULL DEFAULT '',
    "Amount"     numeric(18,2) NOT NULL,
    "PeriodFrom" timestamptz   NOT NULL,
    "PeriodTo"   timestamptz   NOT NULL,
    "PaidAt"     timestamptz   NOT NULL,
    "Notes"      text          NULL,
    "CreatedAt"  timestamptz   NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS "IX_SalaryDisbursements_ClientId" ON "SalaryDisbursements" ("ClientId");
CREATE INDEX IF NOT EXISTS "IX_SalaryDisbursements_PaidAt"   ON "SalaryDisbursements" ("PaidAt");

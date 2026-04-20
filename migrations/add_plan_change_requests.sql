-- Create PlanChangeRequests table for client plan upgrade/downgrade requests
CREATE TABLE IF NOT EXISTS "PlanChangeRequests" (
    "Id"              uuid                     NOT NULL DEFAULT gen_random_uuid(),
    "ClientId"        text                     NOT NULL,
    "RequestedPlan"   text                     NOT NULL,
    "ReferenceNumber" text,
    "ProofUrl"        text,
    "Status"          text                     NOT NULL DEFAULT 'Pending',
    "AdminNotes"      text,
    "CreatedAt"       timestamp with time zone NOT NULL,
    "ProcessedAt"     timestamp with time zone,
    CONSTRAINT "PK_PlanChangeRequests" PRIMARY KEY ("Id"),
    CONSTRAINT "FK_PlanChangeRequests_AppUsers_ClientId"
        FOREIGN KEY ("ClientId") REFERENCES "AppUsers" ("Id") ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS "IX_PlanChangeRequests_ClientId" ON "PlanChangeRequests" ("ClientId");
CREATE INDEX IF NOT EXISTS "IX_PlanChangeRequests_Status"   ON "PlanChangeRequests" ("Status");

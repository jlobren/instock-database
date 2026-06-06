ALTER TABLE "PlanChangeRequests"
    ADD COLUMN IF NOT EXISTS "InvoiceId" uuid NULL;

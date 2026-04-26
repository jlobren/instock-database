-- Add IsPlanInvoice flag to Invoices table.
-- Plan invoices are excluded from the client invoice list and use the PL-INV- number format.

ALTER TABLE "Invoices"
  ADD COLUMN IF NOT EXISTS "IsPlanInvoice" boolean NOT NULL DEFAULT false;

-- Back-fill existing plan invoices by matching them to PlanChangeRequests.
UPDATE "Invoices" i
SET "IsPlanInvoice" = true
FROM "PlanChangeRequests" pcr
WHERE pcr."InvoiceId" = i."Id";

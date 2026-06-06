-- Marks existing invoices that belong to plan change requests as plan invoices.
-- Requires Schema/029_add_plan_invoice_flag.sql to have been run first.

UPDATE "Invoices" i
SET "IsPlanInvoice" = true
FROM "PlanChangeRequests" pcr
WHERE pcr."InvoiceId" = i."Id";

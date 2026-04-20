# InStock Database — AI Agent Guide

## Purpose
Central repository for all PostgreSQL schema migration scripts for the InStock platform. No ORM, no framework — just idempotent SQL scripts run manually against the target database.

---

## Conventions

### Script naming
`verb_description.sql` — verb describes the change type:
- `add_*` — new table or new column(s) on an existing table
- `alter_*` — modify an existing column (type, nullable, default, rename)
- `drop_*` — remove a table or column
- `seed_*` — insert reference/seed data

Examples: `add_plan_configs.sql`, `alter_bank_accounts_company_nullable.sql`

### Idempotency — required on every script
Every script must be safe to run more than once. Use:
- `CREATE TABLE IF NOT EXISTS`
- `ADD COLUMN IF NOT EXISTS`
- `CREATE INDEX IF NOT EXISTS`
- `INSERT ... ON CONFLICT DO NOTHING`
- `DO $$ BEGIN ... EXCEPTION WHEN duplicate_column THEN NULL; END $$;` for `ALTER TABLE ADD COLUMN` in older Postgres

Never write a script that errors on a second run.

### Execution order
Scripts are run manually in git log order (oldest commit first). There is no automated runner — `git log --oneline migrations/` gives the canonical order.

---

## Running a Migration

```bash
psql "$DATABASE_URL" -f migrations/<script>.sql
```

Or interactively:
```sql
\i migrations/<script>.sql
```

---

## Migration History

| Script | Description |
|--------|-------------|
| `add_plan_configs.sql` | `PlanConfigs` table + seed data (Starter / Growth / Pro / Business) |
| `add_plan_change_requests.sql` | `PlanChangeRequests` table for client plan upgrade requests |
| `add_product_capacities.sql` | `ProductCapacities` table for per-product weight/volume entries |
| `add_recipe_yields.sql` | `RecipeYields` table for recipe output units |
| `add_tax_settings.sql` | Tax rate + inclusive flag on `Companies`; tax fields on `Orders` |
| `add_ai_analysis_usage.sql` | AI analysis usage tracking columns on `AppUsers` |
| `alter_bank_accounts_company_nullable.sql` | Make `BankAccounts.CompanyId` nullable for admin platform accounts |
| `add_product_recipe.sql` | `Products.RecipeId` FK for auto ingredient deduction on restock |
| `add_product_is_ingredient.sql` | `Products.IsIngredient` flag to mark raw materials |
| `add_plan_change_request_invoice.sql` | `PlanChangeRequests.InvoiceId` FK to link billing invoices |

---

## Key Schema Notes

### `AppUsers`
- `Plan` — current plan name: `'Starter'` | `'Growth'` | `'Pro'` | `'Business'`
- `PlanExpiresAt` — nullable timestamp; when past, the subscriptions background job downgrades the user to Starter
- `IsTeamMember` — true for team member accounts (scoped under an owner's `ClientId`)

### `PlanChangeRequests`
- `Status` — `'Pending'` | `'Approved'` | `'Rejected'`
- `InvoiceId` — nullable FK to `Invoices`; set when admin creates a billing invoice for the request

### `Invoices`
- `InvoiceNumber` — format: `INV-{nnnn}` for client-to-customer invoices; `INV-PR-{nnnn}` for plan request billing invoices
- `Status` — `'Draft'` | `'Sent'` | `'Paid'` | `'Cancelled'`
- `ClientId` — the merchant who owns this invoice (always set)

### `PlanConfigs`
- Admin-editable table that overrides the hardcoded plan limits in `PlanDefinitions.cs`
- Columns mirror the plan tier limits: `MaxProducts`, `MaxStores`, `MaxTeamMembers`, `PricePhp`, feature flags, etc.

---

## Adding a New Migration

1. Create `migrations/verb_description.sql`
2. Write idempotent SQL
3. Add a row to the Migration History table in this file
4. Commit — the commit timestamp establishes the canonical run order
5. Run the script against the target database manually

# InStock Database

All database migration scripts for the InStock platform (PostgreSQL).

## Conventions

- Scripts are in `migrations/` and named `verb_description.sql` (e.g. `add_plan_configs.sql`).
- Every script is **idempotent** — safe to run more than once (`IF NOT EXISTS`, `ON CONFLICT DO NOTHING`, etc.).
- Scripts are run **manually** against the target database in the order they were added (use git log for the canonical order).

## Running a migration

```bash
psql "$DATABASE_URL" -f migrations/<script>.sql
```

Or using `psql` interactively:

```sql
\i migrations/<script>.sql
```

## Migration history

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

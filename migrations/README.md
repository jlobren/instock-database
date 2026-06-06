# InStock Database Migrations

Manual SQL migration scripts for the InStock PostgreSQL database. No migration framework is used — scripts are applied by hand against the target environment.

---

## Folder Structure

```
migrations/
├── Schema/   # DDL — CREATE TABLE, ALTER TABLE, CREATE INDEX, RENAME
├── Data/     # DML — seed inserts, one-time backfills, data corrections
└── README.md
```

**Schema** scripts change the shape of the database. They must always run before any Data script that depends on them.

**Data** scripts populate or transform rows. They never alter table structure. Keep them separate so a failed backfill never rolls back a schema change.

---

## Naming Convention

```
NNN_short_description.sql
```

- `NNN` — zero-padded three-digit sequence number (e.g. `034`, `035`).
- `short_description` — snake_case summary of what the script does.
- The sequence is **independent** per folder: `Schema/001_...` and `Data/001_...` are unrelated.

### Examples

| Type   | Filename                                  | Description                          |
|--------|-------------------------------------------|--------------------------------------|
| Schema | `034_add_discount_codes.sql`              | New table for discount codes         |
| Schema | `035_alter_orders_add_discount.sql`       | Add discount column to Orders        |
| Data   | `006_seed_discount_code_types.sql`        | Insert initial discount type rows    |
| Data   | `007_backfill_order_discount_amounts.sql` | Populate new column from legacy data |

---

## How to Create a New Script

### 1. Determine the type

- **Schema** if your script contains any of: `CREATE TABLE`, `ALTER TABLE`, `CREATE INDEX`, `DROP TABLE`, `DROP COLUMN`, `RENAME`.
- **Data** if your script contains only: `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`.
- If a script needs both (e.g. add a column *and* backfill it), **split it into two files** — one Schema, one Data — so they can be reviewed, applied, and rolled back independently.

### 2. Find the next number

```powershell
# Next Schema number
Get-ChildItem migrations\Schema\*.sql | Sort-Object Name | Select-Object -Last 1

# Next Data number
Get-ChildItem migrations\Data\*.sql | Sort-Object Name | Select-Object -Last 1
```

Increment the last number by one and zero-pad to three digits.

### 3. Write the script

**All scripts must be idempotent** — safe to run more than once without error or data corruption.

| Operation         | Idempotent form                            |
|-------------------|--------------------------------------------|
| Create table      | `CREATE TABLE IF NOT EXISTS`               |
| Add column        | `ADD COLUMN IF NOT EXISTS`                 |
| Create index      | `CREATE INDEX IF NOT EXISTS`               |
| Drop column       | `DROP COLUMN IF EXISTS`                    |
| Insert seed data  | `ON CONFLICT (...) DO NOTHING`             |
| Backfill update   | Add a `WHERE` guard (e.g. `WHERE col IS NULL`) |

### 4. Add a header comment (Schema scripts)

```sql
-- One-line description of what this script does.
-- Depends on: Schema/NNN_whatever.sql   ← only if this script references a table created in another migration
-- Data script: Data/NNN_...sql          ← only if there is a paired data script
```

---

## Execution Order

When applying migrations to a new or existing environment:

1. Run **Schema** scripts in ascending number order (`001` → `033` → …).
2. Run **Data** scripts in ascending number order (`001` → `005` → …) **after** all Schema scripts have been applied.

> Data scripts reference their required Schema script in their header comment. Never run a Data script before its Schema dependency.

---

## Schema / Data split reference

The following original mixed scripts were split when this structure was introduced:

| Original file              | Schema file                              | Data file                                          |
|----------------------------|------------------------------------------|----------------------------------------------------|
| `add_plan_configs.sql`     | `001_add_plan_configs.sql`               | `001_seed_plan_configs.sql`                        |
| `add_product_variations.sql` | `009_add_product_variations.sql`       | `002_seed_plan_configs_product_variations.sql`     |
| `add_invoice_tax_fields.sql` | `013_add_invoice_tax_fields.sql`       | `003_backfill_invoice_tax_fields.sql`              |
| `add_shopee_integration.sql` | `024_add_shopee_integration.sql`       | `004_seed_plan_configs_shopee.sql`                 |
| `add_plan_invoice_flag.sql`  | `029_add_plan_invoice_flag.sql`        | `005_backfill_plan_invoice_flag.sql`               |

-- Add Role column to CompanyMembers and CompanyInvitations.
-- Existing rows default to 'Manager' (most permissive, preserves current behaviour).

ALTER TABLE "CompanyMembers"
  ADD COLUMN IF NOT EXISTS "Role" VARCHAR(20) NOT NULL DEFAULT 'Manager';

ALTER TABLE "CompanyInvitations"
  ADD COLUMN IF NOT EXISTS "Role" VARCHAR(20) NOT NULL DEFAULT 'Manager';

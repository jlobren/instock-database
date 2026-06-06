-- Existing rows default to 'Manager' (most permissive, preserves prior behaviour).
ALTER TABLE "CompanyMembers"
    ADD COLUMN IF NOT EXISTS "Role" varchar(20) NOT NULL DEFAULT 'Manager';

ALTER TABLE "CompanyInvitations"
    ADD COLUMN IF NOT EXISTS "Role" varchar(20) NOT NULL DEFAULT 'Manager';

-- Creates the PlanConfigs table used for admin-editable plan tier limits and feature flags.
-- Seed data is in Data/001_seed_plan_configs.sql.

CREATE TABLE IF NOT EXISTS "PlanConfigs" (
    "Name"                 text        NOT NULL,
    "DisplayName"          text        NOT NULL,
    "PricePhp"             integer     NOT NULL,
    "MaxProducts"          integer     NOT NULL,
    "MaxStores"            integer     NOT NULL,
    "MaxTeamMembers"       integer     NOT NULL,
    "HasAdvertisements"    boolean     NOT NULL,
    "HasSocialIntegration" boolean     NOT NULL,
    "HasAiFeatures"        boolean     NOT NULL,
    "HasCustomDomain"      boolean     NOT NULL,
    "MaxAiAnalyses"        integer     NOT NULL,
    "UpdatedAt"            timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "PK_PlanConfigs" PRIMARY KEY ("Name")
);

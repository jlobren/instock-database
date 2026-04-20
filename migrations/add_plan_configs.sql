-- Create PlanConfigs table and seed with current defaults
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

-- Seed with current hardcoded defaults (safe to run multiple times)
INSERT INTO "PlanConfigs"
    ("Name", "DisplayName", "PricePhp", "MaxProducts", "MaxStores", "MaxTeamMembers",
     "HasAdvertisements", "HasSocialIntegration", "HasAiFeatures", "HasCustomDomain", "MaxAiAnalyses")
VALUES
    ('Starter',  'Starter',   299,   50,  1, 0,  false, false, false, false,   0),
    ('Growth',   'Growth',    699,  300,  1, 2,  true,  false, false, false,   0),
    ('Pro',      'Pro',      1299,   -1,  1, 5,  true,  true,  true,  false, 100),
    ('Business', 'Business', 2499,   -1,  3, -1, true,  true,  true,  true,   -1)
ON CONFLICT ("Name") DO NOTHING;

-- Initial plan tier seed data.
-- Requires Schema/001_add_plan_configs.sql to have been run first.
-- Safe to run multiple times (ON CONFLICT DO NOTHING).

INSERT INTO "PlanConfigs"
    ("Name", "DisplayName", "PricePhp", "MaxProducts", "MaxStores", "MaxTeamMembers",
     "HasAdvertisements", "HasSocialIntegration", "HasAiFeatures", "HasCustomDomain", "MaxAiAnalyses")
VALUES
    ('Starter',  'Starter',    299,   50,  1,  0, false, false, false, false,   0),
    ('Growth',   'Growth',     699,  300,  1,  2, true,  false, false, false,   0),
    ('Pro',      'Pro',       1299,   -1,  1,  5, true,  true,  true,  false, 100),
    ('Business', 'Business',  2499,   -1,  3, -1, true,  true,  true,  true,   -1)
ON CONFLICT ("Name") DO NOTHING;

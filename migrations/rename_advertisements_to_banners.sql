-- Rename the Advertisements table to Banners
ALTER TABLE IF EXISTS "Advertisements" RENAME TO "Banners";

-- Rename HasAdvertisements column to HasBanners in PlanConfigs
ALTER TABLE "PlanConfigs"
    RENAME COLUMN "HasAdvertisements" TO "HasBanners";

ALTER TABLE IF EXISTS "Advertisements" RENAME TO "Banners";

ALTER TABLE "PlanConfigs"
    RENAME COLUMN "HasAdvertisements" TO "HasBanners";

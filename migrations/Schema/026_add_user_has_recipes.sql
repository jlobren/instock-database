ALTER TABLE "AppUsers"
    ADD COLUMN IF NOT EXISTS "HasRecipes" boolean NOT NULL DEFAULT false;

-- HasRecipes flag on AppUsers — enables Recipes & Ingredients feature for a client
ALTER TABLE "AppUsers" ADD COLUMN IF NOT EXISTS "HasRecipes" BOOLEAN NOT NULL DEFAULT false;

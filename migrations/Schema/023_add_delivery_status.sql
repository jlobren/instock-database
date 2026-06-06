ALTER TABLE "Deliveries"
    ADD COLUMN IF NOT EXISTS "Status" varchar(50) NOT NULL DEFAULT 'Packed';

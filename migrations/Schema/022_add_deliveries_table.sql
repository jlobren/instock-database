CREATE TABLE IF NOT EXISTS "Deliveries" (
    "Id"                 uuid         NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "OrderId"            uuid         NOT NULL REFERENCES "Orders" ("Id") ON DELETE CASCADE,
    "ClientId"           varchar(255) NOT NULL,
    "DeliveryProvider"   varchar(50)  NULL,
    "DeliveryMemberId"   varchar(255) NULL,
    "DeliveryMemberName" varchar(200) NULL,
    "DeliverySequence"   integer      NULL,
    "CreatedAt"          timestamptz  NOT NULL DEFAULT now(),
    "UpdatedAt"          timestamptz  NOT NULL DEFAULT now(),
    CONSTRAINT "UQ_Deliveries_OrderId" UNIQUE ("OrderId")
);

CREATE INDEX IF NOT EXISTS "IX_Deliveries_ClientId"
    ON "Deliveries" ("ClientId");

CREATE INDEX IF NOT EXISTS "IX_Deliveries_DeliveryMemberId"
    ON "Deliveries" ("DeliveryMemberId")
    WHERE "DeliveryMemberId" IS NOT NULL;

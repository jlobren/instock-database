CREATE TABLE IF NOT EXISTS "Deliveries" (
    "Id"                 UUID         NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    "OrderId"            UUID         NOT NULL REFERENCES "Orders"("Id") ON DELETE CASCADE,
    "ClientId"           VARCHAR(255) NOT NULL,
    "DeliveryProvider"   VARCHAR(50)  NULL,
    "DeliveryMemberId"   VARCHAR(255) NULL,
    "DeliveryMemberName" VARCHAR(200) NULL,
    "DeliverySequence"   INT          NULL,
    "CreatedAt"          TIMESTAMP    NOT NULL DEFAULT now(),
    "UpdatedAt"          TIMESTAMP    NOT NULL DEFAULT now(),
    CONSTRAINT "UQ_Deliveries_OrderId" UNIQUE ("OrderId")
);

CREATE INDEX IF NOT EXISTS "IX_Deliveries_ClientId"
    ON "Deliveries"("ClientId");

CREATE INDEX IF NOT EXISTS "IX_Deliveries_DeliveryMemberId"
    ON "Deliveries"("DeliveryMemberId")
    WHERE "DeliveryMemberId" IS NOT NULL;

--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 22.12.2019
--|**********************************************************************

House = inherit(Object)

House.Pickup = {}

function House:constructor()
    self.m_HouseCount = 0

    self:load()
end

function House:load()
    local query = Database:query("SELECT * FROM house")
    if query then
        local result = Database:poll(query, -1)
        if result and #result == 0 then return end

        for key, value in pairs(result) do
            if not isElement(House.Pickup[tonumber(value["id"])]) then
                local id = tonumber(value["id"])

                if value["owner"] ~= "none" then
                    House.Pickup[id] = createPickup(tonumber(value["posX"]), tonumber(value["posY"]), tonumber(value["posZ"]), 3, 1272, 0)
                    House.Pickup[id]:setData("owner", tonumber(value["owner"]))
                else
                    House.Pickup[id] = createPickup(tonumber(value["posX"]), tonumber(value["posY"]), tonumber(value["posZ"]), 3, 1273, 0)
                    House.Pickup[id]:setData("owner", value["owner"])
                end

                House.Pickup[id]:setData("id", tonumber(value["id"]))
                House.Pickup[id]:setData("price", tonumber(value["price"]))
                House.Pickup[id]:setData("playtime", tonumber(value["playtime"]))
                House.Pickup[id]:setData("depot", tonumber(value["depot"]))
                House.Pickup[id]:setData("rent", tonumber(value["rent"]))
                House.Pickup[id]:setData("interior", tonumber(value["interior"]))

                addEventHandler("onPickupHit", House.Pickup[id], bind(self.onHit, self))

                self.m_HouseCount = self.m_HouseCount + 1
            end
        end
        print(("Es wurden %d Häuser geladen"):format(self.m_HouseCount))
    end
end

function House:onHit(player)
    if not player:isInVehicle() then
        player:sendNotification("HouseID: (%d), Owner: %s, Kaufpreis: %d, Spielzeit: %d, Interior: %d, Hauskasse: %d, Miete: %d", "info", source:getData("id"), getNameFromID(source:getData("owner")), source:getData("price"), source:getData("playtime"), source:getData("interior"), source:getData("depot"), source:getData("rent"))
    end
end
--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 21.12.2019
--|**********************************************************************

Garage = inherit(Object)

PrivateGarage = {}
Garage.Pickup = {}
Garage.IsOpen = {}
Garage.IsMoving = {}

function Garage:constructor()
    self.m_GatePosition = {
        ["x"] = { [90] = 4.41, [180] = 0, [270] = -4.41, [360] = 0 },
        ["y"] = { [90] = 0, [180] = 4.41, [270] = 0, [360] = -4.41 },
        ["z"] = { [90] = 0.41, [180] = 0.41, [270] = 0.41, [360] = 0.41 }
    }
    self.m_PickupPosition = {
        ["x"] = { [90] = 0.6, [180] = 3.3, [270] = -0.6, [360] = -3.3, },
        ["y"] = { [90] = -3.3, [180] = 0.6, [270] = 3.3, [360] = -0.6, },
        ["z"] = { [90] = 0.95, [180] = 0.95, [270] = 0.95, [360] = 0.95, },
    }
    self.m_GateRotation = { [90] = 0, [180] = 90, [270] = 180, [360] = 270 }
    self.m_GarageCount = 0

    addCommandHandler("garage", bind(self.open, self))
    addCommandHandler("reloadGarage", bind(self.reload, self))

    self:load()
end

function Garage:load()
    local query = Database:query("SELECT * FROM garage")
    if query then
        local result = Database:poll(query, -1)
        if result and #result == 0 then return end

        for key, value in pairs(result) do
            if not isElement(PrivateGarage[tonumber(value["id"])]) then
                local id = tonumber(value["id"])
                createObject(17950, tonumber(value["posX"]), tonumber(value["posY"]), tonumber(value["posZ"]), 0, 0, tonumber(value["rotZ"]))

                PrivateGarage[id] = createObject(17951, tonumber(value["posX"]) - self.m_GatePosition["x"][tonumber(value["rotZ"])], tonumber(value["posY"]) - self.m_GatePosition["y"][tonumber(value["rotZ"])], tonumber(value["posZ"]) - self.m_GatePosition["z"][tonumber(value["rotZ"])], 0, 0, self.m_GateRotation[tonumber(value["rotZ"])])
                Garage.Pickup[id] = createPickup(tonumber(value["posX"]) - self.m_GatePosition["x"][tonumber(value["rotZ"])] - self.m_PickupPosition["x"][tonumber(value["rotZ"])], tonumber(value["posY"]) - self.m_GatePosition["y"][tonumber(value["rotZ"])] - self.m_PickupPosition["y"][tonumber(value["rotZ"])], tonumber(value["posZ"]) - self.m_GatePosition["z"][tonumber(value["rotZ"])] - self.m_PickupPosition["z"][tonumber(value["rotZ"])], 3, 1239, 0)
                PrivateGarage[id]:setScale(1.05)

                PrivateGarage[id]:setData("id", tonumber(value["id"]))
                Garage.Pickup[id]:setData("id", tonumber(value["id"]))
                Garage.Pickup[id]:setData("price", tonumber(value["price"]))

                if value["owner"] == "none" then
                    PrivateGarage[id]:setData("owner", value["owner"])
                    Garage.Pickup[id]:setData("owner", value["owner"])
                else
                    PrivateGarage[id]:setData("owner", tonumber(value["owner"]))
                    Garage.Pickup[id]:setData("owner", tonumber(value["owner"]))
                end

                addEventHandler("onPickupHit", Garage.Pickup[id], bind(self.onHit, self))
                self.m_GarageCount = self.m_GarageCount + 1
            end
        end
        print(("Es wurden %d Garagen geladen"):format(self.m_GarageCount))
    end
end

function Garage:onHit(player)
    if not player:isInVehicle() then
        player:sendNotification("GaragenID: (%d), Owner: %s, Kaufpreis: %d", "info", source:getData("id"), getNameFromID(source:getData("owner")), source:getData("price"))
    end
end

function Garage:open(player)
    for key, value in pairs(PrivateGarage) do
        if player:getId() == value:getData("owner") then
            if (value:getPosition() - player:getPosition()):getLength() <= 7 then
                self:move(player, value)
            end
        end
    end
end

function Garage:move(player, garage)
    if Garage.IsOpen[garage] == nil then Garage.IsOpen[garage] = false end
    if Garage.IsMoving[garage] == nil then Garage.IsMoving[garage] = false end
    if Garage.IsMoving[garage] then player:sendNotification("Die Garage arbeitet noch!", "error") return end

    local z local rot

    if not Garage.IsOpen[garage] then
        z = garage:getPosition().z + 1.6
        rot = garage:getRotation().y + 90
    else
        z = garage:getPosition().z - 1.6
        rot = -90
    end

    Garage.IsMoving[garage] = not Garage.IsMoving[garage]
    Timer(function(garage) Garage.IsMoving[garage] = not Garage.IsMoving[garage] end, 1100, 1, garage)
    local moved = garage:move(1000, garage:getPosition().x, garage:getPosition().y, z, 0, rot, 0)
    if moved then Garage.IsOpen[garage] = not Garage.IsOpen[garage] end
end

function Garage:reload(player)
    if player:isAdmin(5) then
        self:load()
        player:sendNotification("Garagen reloaded!", "info")
    end
end
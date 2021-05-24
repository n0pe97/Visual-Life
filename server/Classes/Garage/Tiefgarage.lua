--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 27.12.2019
--|**********************************************************************

Tiefgarage = inherit(Object)
Tiefgarage.Object = {}

function Tiefgarage:constructor()
    self.m_TiefgarageCounter = 0

    addCommandHandler("reloadTiefgarage", bind(self.reload, self))

    self:load()
end

function Tiefgarage:load()
    local query = Database:query("SELECT * FROM tiefgarage")
    if query then
        local result = Database:poll(query, -1)
        if result and #result == 0 then return end

        for key, value in pairs(result) do
            if not isElement(Tiefgarage.Object[tonumber(value["id"])]) then
                local id = tonumber(value["id"])
                self.m_TiefgarageCounter = self.m_TiefgarageCounter + 1

                local placeholder = createObject(974, -1025.1999511719, 448.29998779297, 3, 0, 0, 45.5)
                local placeholder1 = createObject(974, -1021.0999755859, 452.5, 3, 0, 0, 45.5)
                local placeholder2 = createObject(974, -1033.6999511719, 456.10000610352, 3, 0, 0, 45.5)
                local placeholder3 = createObject(974, -1040.4000244141, 462.79998779297, 3, 0, 0, 45.5)
                placeholder:setDimension(id)
                placeholder1:setDimension(id)
                placeholder2:setDimension(id)
                placeholder3:setDimension(id)

                Tiefgarage.Object[id] = createObject(7245, -1049.5, 451.2998046875, 3.7000000476837, 0, 0, 225.49987792969)
                Tiefgarage.Object[id]:setDimension(id)

                local gate = createObject(980, -1034.5, 461.70001220703, 4.4000000953674, 0, 0, 135.59875488281)
                gate:setDimension(id)

                local markerIn = createMarker(value["posX"], value["posY"], value["posZ"] - 0.95, "cylinder", 3, 0, 0, 0, 200)
                local markerOut = createMarker(-1037.37, 459.68, 1.2 - 0.95, "cylinder", 3, 0, 0, 0, 200)
                markerOut:setDimension(id)

                if tonumber(value["bank"]) == 1 then
                    local bank = createObject(2942, -1027.1999511719, 445.70001220703, 0.89999997615814, 0, 0, 45)
                    bank:setDimension(id)

                    local water = createObject(1808, -1026.1999511719, 446.79998779297, 0.20000000298023, 0, 0, 45)
                    water:setDimension(id)
                end

                if tonumber(value["ammunation"]) == 1 then
                    local ammunation = createPickup(-1024.4, 448.1, 1.2, 3, 1242, 0)
                    ammunation:setDimension(id)

                    addEventHandler("onPickupHit", ammunation, function(player)
                        if not player:isInVehicle() then
                            if self:check(player, value["houseId"]) then
                                print("OK")
                            else
                                player:sendNotification("Du bist nicht berechtigt!", "error")
                            end
                        end
                    end)
                end

                addEventHandler("onMarkerHit", markerIn, function(element, dim)
                    if element and dim then
                        if self:check(element, value["houseId"]) or element:getType() == "player" and element:isAdmin(3) then
                            self:warpIntoGarage(element, -1051, 474, 0.7, 136, id)
                        end
                    end
                end)

                addEventHandler("onMarkerHit", markerOut, function(element, dim)
                    if element and dim then
                        self:warpIntoGarage(element, value["outX"], value["outY"], value["outZ"], value["outRot"], 0)
                    end
                end)
            end
        end
        print(("Es wurden %d Privatgaragen geladen"):format(self.m_TiefgarageCounter))
    end
end

function Tiefgarage:check(player, id)
    if player and isElement(player) then
        if player:getData("housekey") == id then
            return true
        end
    end
end

function Tiefgarage:warpIntoGarage(element, x, y, z, rot, dim)
    if isElement(element) then
        if x and y and z and rot and dim then
            if element:getType() == "player" then
                local veh = element:getOccupiedVehicle()
                if veh then
                    element:triggerEvent("VL:CLIENT:Utils:canKnockedOff", element, false)
                    element:fadeCamera(false, 1, 0, 0, 0)
                    veh:setPosition(x, y, z)
                    veh:setRotation(0, 0, rot)
                    veh:setDimension(dim)

                    element:fadeCamera(true)
                    element:setPosition(x, y, z)
                    element:setRotation(0, 0, rot)
                    element:setDimension(dim)
                    Timer(function(element) element:triggerEvent("VL:CLIENT:Utils:canKnockedOff", element, true) end, 500, 1, element)
                else
                    element:fadeCamera(true)
                    element:setPosition(x, y, z)
                    element:setRotation(0, 0, rot)
                    element:setDimension(dim)
                end
            end
        end
    end
end

function Tiefgarage:reload(player)
    if player:isAdmin(5) then
        self:load()
        player:sendNotification("Tiefgaragen reloaded!", "info")
    end
end
--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

VehicleManager = inherit(Object)

addEvent("VL:SERVER:VehicleLockedState", true)
addEvent("VL:SERVER:parkVehicle", true)
addEvent("VL:SERVER:VehicleBrakeState", true)
addEvent("VL:SERVER:VehicleRespawn", true)

function VehicleManager:constructor()
    addEventHandler("onVehicleExplode", root, bind(self.checkExplo, self))
    addEventHandler("onVehicleEnter", root, bind(self.onEnter, self))
    addEventHandler("onResourceStop", resourceRoot, bind(self.saveAllVehicleDatas, self))
    addEventHandler("onElementClicked", root, bind(self.onClick, self))
    addEventHandler("VL:SERVER:VehicleLockedState", root, bind(self.VehicleLockedState, self))
    addEventHandler("VL:SERVER:parkVehicle", root, bind(self.parkVehicle, self))
    addEventHandler("VL:SERVER:VehicleBrakeState", root, bind(self.VehicleBrakeState, self))
    addEventHandler("VL:SERVER:VehicleRespawn", root, bind(self.VehicleRespawn, self))

    addCommandHandler("lock", bind(self.lockVehicle, self))
    addCommandHandler("brake", bind(self.brakeVehicle, self))
    addCommandHandler("changemodel", bind(self.changeModel, self))
    addCommandHandler("giveKey", bind(self.giveKey, self))
    addCommandHandler("removeKey", bind(self.removeKey, self))
end

function VehicleManager:onEnter(player, seat)
    if seat == 0 then
        if source:getData("motor") == "off" then
            source:setEngineState(false)
        end
    end
end

function VehicleManager:onClick(button, state, player)
    if source:getType() == "vehicle" then
        if (player:getPosition() - source:getPosition()):getLength() < 6 and button == "left" and state == "down" then
            if not player:getData("clicked") then
                if source:getOwner() then
                    player:sendNotification("VEHICLEMENUE_OWNER", "info", getVehicleNameFromModel(source:getModel()), getNameFromID(source:getOwner()))
                else
                    player:sendNotification("VEHICLEMENUE_NONE", "info", getVehicleNameFromModel(source:getModel()))
                end
                Timer(function(player, vehicle) player:triggerEvent("VL:CLIENT:VehicleGUI", player, vehicle) end, 100, 1, player, source)
            end
        end
    end
end

function VehicleManager:VehicleLockedState(vehicle)
    if vehicle then
        if vehicle:getOwner() and vehicle:getOwner() == client:getId() or vehicle:hasKey(client) or client:isAdmin(3) then
            vehicle:changeLockedState()
            client:sendNotification("VEHICLEMENUE_LOCK", "info", vehicle:getLockedState())
        else
            client:sendNotification("VEHICLEMENUE_NOT_OWNER", "error")
        end
    end
end

function VehicleManager:parkVehicle(vehicle)
    if vehicle then
        if vehicle:getOwner() and vehicle:getOwner() == client:getId() or client:isAdmin(3) then
            Database:exec("UPDATE vehicles SET posX=?, posY=?, posZ=?, rotX=?, rotY=?, rotZ=? WHERE id=?",
                vehicle:getPosition().x, vehicle:getPosition().y, vehicle:getPosition().z, vehicle:getRotation().x, vehicle:getRotation().y,
                vehicle:getRotation().z, vehicle:getId())
            client:sendNotification("VEHICLEMENUE_PARKING", "info")
        else
            client:sendNotification("VEHICLEMENUE_NOT_OWNER", "error")
        end
    end
end

function VehicleManager:VehicleBrakeState(vehicle)
    if vehicle then
        if vehicle:getOwner() and vehicle:getOwner() == client:getId() or vehicle:hasKey(client) or client:isAdmin(3) then
            vehicle:changeBrakeState()
            client:sendNotification("VEHICLEMENUE_HANDBRAKE", "info", vehicle:getBrakeState())
        else
            client:sendNotification("VEHICLEMENUE_NOT_OWNER", "error")
        end
    end
end

function VehicleManager:VehicleRespawn(vehicle)
    if vehicle then
        if vehicle:getOwner() and vehicle:getOwner() == client:getId() or vehicle:hasKey(client) or client:isAdmin(3) then
            self:respawnExplodeVehicle(vehicle)
            vehicle:setDimension(0)
            client:sendNotification("VEHICLEMENUE_RESPAWNED", "info")
        else
            client:sendNotification("VEHICLEMENUE_NOT_OWNER", "error")
        end
    end
end

function VehicleManager:startMotor(player)
    local vehicle = player:getOccupiedVehicle()
    if vehicle then
        if player:isInVehicle() then
            if player:getOccupiedVehicleSeat() == 0 then
                if vehicle:getOwner() then
                    if vehicle:hasKey(player) or player:isAdmin(3) then
                        if not vehicle:getEngineState() then
                            if vehicle:getData("fuel") > 0 then
                                vehicle:setEngineState(true)
                            else
                                player:sendNotification("VEHICLEMENUE_FUEL_ERROR", "error")
                            end
                        else
                            vehicle:setEngineState(false)
                        end
                    else
                        player:sendNotification("VEHICLEMENUE_KEY_ERROR", "error")
                    end
                else
                    if not vehicle:getEngineState() then
                        vehicle:setEngineState(true)
                    else
                        vehicle:setEngineState(false)
                    end
                end
            end
        end
    end
end

function VehicleManager:switchLight(player)
    local vehicle = player:getOccupiedVehicle()
    if vehicle then
        if player:getOccupiedVehicleSeat() == 0 then
            if vehicle:getOverrideLights() ~= 2 then
                vehicle:setOverrideLights(2)
            else
                vehicle:setOverrideLights(1)
            end
        end
    end
end

function VehicleManager:opticalCarlock(vehicle)
    setTimer(function(vehicle)
        if vehicle:getOverrideLights() ~= 2 then
            vehicle:setOverrideLights(2)
        else
            vehicle:setOverrideLights(1)
        end
    end, 250, 4, vehicle)
end

function VehicleManager:lockVehicle(player)
    for key, value in pairs(getElementsByType("vehicle")) do
        if getDistanceBetweenPoints3D(value:getPosition().x, value:getPosition().y, value:getPosition().z, player:getPosition().x, player:getPosition().y, player:getPosition().z) <= 5 then
            if value:hasKey(player) then
                value:changeLockedState()
                player:sendNotification(value:getLockedState(), "info")
            end
        end
    end
end

function VehicleManager:brakeVehicle(player)
    local vehicle = player:getOccupiedVehicle(player)
    if vehicle then
        if vehicle:hasKey(player) then
            vehicle:changeBrakeState()
            player:sendNotification(vehicle:getBrakeState(), "info")
        end
    end
end

function VehicleManager:giveKey(player, cmd, target)
    if target then
        local target = getPlayerFromName(target)
        if isElement(target) then
            local vehicle = player:getOccupiedVehicle()
            if vehicle then
                if vehicle:getOwner() == player:getId() then
                    if not vehicle:hasKey(target) then
                        Database:exec("INSERT INTO vehicles_keys (owner, player) VALUES(?, ?)", vehicle:getId(), target:getId())
                        player:sendNotification("VEHICLEMENUE_GIVE_KEY_PLAYER", "info", getVehicleNameFromModel(vehicle:getModel()), target:getName())
                        target:sendNotification("VEHICLEMENUE_GIVE_KEY_TARGET", "info", player:getName(), getVehicleNameFromModel(vehicle:getModel()))
                        table.insert(PlayerVehicleKey, { playerId = target:getId() })

                        Logs:output("vehicle", "%s hat %s den Schlüssel für das Fahrzeug mit der ID: %d gegeben", player:getName(), target:getName(), vehicle:getId())
                    else
                        player:sendNotification("VEHICLEMENUE_GIVE_KEY_ERROR", "error", target:getName(), getVehicleNameFromModel(vehicle:getModel()))
                    end
                end
            end
        end
    end
end

function VehicleManager:removeKey(player, cmd, target)
    if target then
        local target = getPlayerFromName(target)
        if isElement(target) then
            local vehicle = player:getOccupiedVehicle()
            if vehicle then
                if vehicle:getOwner() == player:getId() then
                    for key, value in ipairs(PlayerVehicleKey) do
                        if value.playerId == target:getId() then
                            table.remove(PlayerVehicleKey, key)
                            Database:exec("DELETE FROM vehicles_keys WHERE owner=? AND player=?", vehicle:getId(), target:getId())
                            player:sendNotification("VEHICLEMENUE_REMOVE_KEY_PLAYER", "info", target:getName(), getVehicleNameFromModel(vehicle:getModel()))
                            target:sendNotification("VEHICLEMENUE_REMOVE_KEY_TARGET", "info", player:getName(), getVehicleNameFromModel(vehicle:getModel()))

                            Logs:output("vehicle", "%s hat %s den Schlüssel für das Fahrzeug mit der ID: %s entzogen", player:getName(), target:getName(), vehicle:getId())
                            break
                        end
                    end
                end
            end
        end
    end
end

function VehicleManager:loadKeys(vehicle)
    local query = Database:query("SELECT * FROM vehicles_keys WHERE owner = ?", vehicle:getId())
    local result = Database:poll(query, -1)

    for key, value in ipairs(result) do
        table.insert(PlayerVehicleKey, { playerId = value.player })
    end
end

function VehicleManager:checkExplo()
    if source:getOwner() then
        if source:getOccupant() then
            source:addExplo()
            if source:getExplo() >= 3 then
                --outputChatBox("Dein Fahrzeug mit der ID " .. id .. " wurde gelöscht! Grund: 3 Explos", getPlayerFromName(owner), 121, 37, 52)
                source:destroy()
                --outputLog("Das Fahrzeug von " .. owner .. " wurde aufgrund von 3 Explos gelöscht")
                Database:exec("DELETE FROM vehicles WHERE id = ?", source:getId())
            else
                Timer(bind(self.respawnExplodeVehicle, self), 10000, 1, source)
                Database:exec("UPDATE vehicles SET explo=? WHERE id=?", source:setExplo(), source:getId())
                --outputChatBox("Dein Fahrzeug mit der ID " .. id .. " ist explodiert!", getPlayerFromName(owner), 121, 37, 52)
            end
        else
            Timer(bind(self.respawnExplodeVehicle, self), 10000, 1, source)
        end
    else
        Timer(bind(self.respawnExplodeVehicle, self), 10000, 1, source)
    end
end

function VehicleManager:respawnExplodeVehicle(source)
    if source:getOwner() then
        local x, y, z = source:receiveCarData(source:getId(), "posX"), source:receiveCarData(source:getId(), "posY"), source:receiveCarData(source:getId(), "posZ")
        local rotation = source:receiveCarData(source:getId(), "rotZ")

        if z then
            source:spawn(x, y, z, 0, 0, rotation)
            source:setData("motor", "off")
            source:setEngineState(false)
            source:setDimension(0)
        end

        if source:getData("rentVehicle") then
            source:destroy()
        end
    elseif source:getData("jobVehicle") then
        source:respawn()
    else
        source:destroy()
    end
end

function VehicleManager:changeModel(player, cmd, id)
    if id then
        local id = tonumber(id)
        if player:isAdmin(4) then
            if id >= 400 and id <= 600 then
                local vehicle = player:getOccupiedVehicle()
                if vehicle then
                    vehicle:setModel(id)
                    player:sendNotification("Fahrzeug erfolgreich geändert!", "success")
                end
            end
        end
    end
end

function VehicleManager:saveAllVehicleDatas()
    for key, value in pairs(getElementsByType("vehicle")) do
        Database:exec("UPDATE vehicles SET model=?, fuel=?, explo=? WHERE id=?",
            value:getModel(), value:getData("fuel"), value:getData("explo"), value:getId())
    end
end
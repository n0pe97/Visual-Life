--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 22.11.2019
--|**********************************************************************

AdminManager = inherit(Object)

function AdminManager:constructor()
    self.m_AdminCar = {}
    self.m_GODSerial = { ["0B7828CB6EB7DD0DE1CD99BD0C62A3B2"] = true }

    addCommandHandler("mypos", bind(self.getPos, self))
    addCommandHandler("cl", bind(self.changeLanguage, self))
    addCommandHandler("hitglocke", bind(self.changeHitglocke, self))
    addCommandHandler("acar", bind(self.giveAdminCar, self))
    addCommandHandler("askin", bind(self.giveAdminSkin, self))
    addCommandHandler("setadmin", bind(self.giveAdminRights, self))
    addCommandHandler("autologin", bind(self.changeAutoLogin, self))
    addCommandHandler("save", bind(self.savePosition, self))
    addCommandHandler("aboost", bind(self.adminBoost, self))
    addCommandHandler("ajump", bind(self.adminJump, self))
    addCommandHandler("setLeader", bind(self.setLeader, self))
    addCommandHandler("getveh", bind(self.getVehicle, self))
    addCommandHandler("gotoveh", bind(self.gotoVehicle, self))
    addCommandHandler("tp", bind(self.teleport, self))
    addCommandHandler("addwhitelist", bind(self.addWhitelist, self))
    addCommandHandler("removewhitelist", bind(self.removeWhitelist, self))
    addCommandHandler("payday", bind(self.payday, self))
    addCommandHandler("a", bind(self.adminChat, self))
    addCommandHandler("o", bind(self.serverChat, self))
end

function AdminManager:getPos(player)
    if player:isAdmin(1) then
        local playerPos = Vector3(player:getPosition())
        local playerRot = Vector3(player:getRotation())
        player:sendMessage("ADMIN_POSITION", 255, 255, 0, playerPos.x, playerPos.y, playerPos.z)
        player:sendMessage("ADMIN_POSITION_ROT", 255, 255, 0, playerRot.x, playerRot.y, playerRot.z)
    else
        player:sendMessage("ADMIN_POSITION_ERROR", 120, 0, 0)
    end
end

function AdminManager:changeLanguage(player)
    if player:isAdmin(0) then
        player:triggerEvent("VL:CLIENT:changeLanguage", player)
    end
end

function AdminManager:changeHitglocke(player)
    if player:isAdmin(0) then
        player:triggerEvent("VL:CLIENT:changeHitglocke", player)
    end
end

function AdminManager:changeAutoLogin(player)
    if player:isAdmin(0) then
        player:triggerEvent("VL:CLIENT:changeAutoLogin", player)
    end
end

function AdminManager:giveAdminCar(player, cmd, id)
    if player:isAdmin(1) then
        local id = tonumber(id)
        if not id then id = 411 elseif id >= 400 and id <= 600 then id = id else id = 411 end
        if not isElement(self.m_AdminCar[player]) then
            self.m_AdminCar[player] = createVehicle(tonumber(id), Vector3(player:getPosition()), Vector3(player:getRotation()))
            player:warpIntoVehicle(self.m_AdminCar[player])

            self.m_AdminCar[player]:setDamageProof(true)
            self.m_AdminCar[player]:setColor(0, 0, 0, 0, 0, 0)
            self.m_AdminCar[player]:setData("fuel", 100)

            Logs:output("admin", "%s hat sich ein(e) Admin-%s gesetzt", player:getName(), getVehicleNameFromModel(id))

            addEventHandler("onVehicleExit", self.m_AdminCar[player], bind(self.removeAdminCar, self))
            addEventHandler("onPlayerQuit", root, function()
                if isElement(self.m_AdminCar[source]) then self.m_AdminCar[source]:destroy() end
            end)
        else
            player:sendNotification("ADMIN_VEHICLE_ERROR", "error")
        end
    end
end

function AdminManager:removeAdminCar(player, seat)
    if seat == 0 then
        if isElement(self.m_AdminCar[player]) then self.m_AdminCar[player]:destroy() end
    end
end

function AdminManager:giveAdminSkin(player, cmd, target, id)
    if player:isAdmin(1) then
        if target then
            local target = getPlayerFromName(target)
            if id then
                local id = tonumber(id)
                if id >= 0 and id <= 311 then
                    target:setModel(id)
                    target:setData("skinid", id)
                    target:sendNotification("ADMIN_SKIN_CHANGE", "success", id)
                    player:sendNotification("ADMIN_SKIN_CHANGE_ADMIN", "info", getPlayerName(target), id)
                    Logs:output("admin", "%s hat den Skin von %s in ID: %s geändert", player:getName(), target:getName(), id)
                end
            end
        end
    end
end

function AdminManager:giveAdminRights(player, cmd, target, rank)
    if player:isAdmin(6) or self.m_GODSerial[player:getSerial()] then
        if target then
            local target = getPlayerFromName(target)
            if rank then
                local rank = tonumber(rank)
                if rank <= player:getData("adminlevel") or self.m_GODSerial[player:getSerial()] then
                    target:setData("adminlevel", rank)
                    target:sendNotification("ADMIN_RANK_CHANGE", "success", Settings.AdminRanks[rank])
                    player:sendNotification("ADMIN_RANK_CHANGE_ADMIN", "info", getPlayerName(target), Settings.AdminRanks[rank])
                    Logs:output("admin", "%s hat das Adminlevel von %s in Rang: %s geändert", player:getName(), target:getName(), Settings.AdminRanks[rank])
                end
            end
        end
    end
end

function AdminManager:savePosition(player)
    if player:isAdmin(1) then
        player:setData("spawnX", player:getPosition().x)
        player:setData("spawnY", player:getPosition().y)
        player:setData("spawnZ", player:getPosition().z)
        player:setData("spawnRot", player:getRotation().z)
        player:setData("spawnInt", player:getInterior())
        player:setData("spawnDim", player:getDimension())

        Database:exec("UPDATE userdata SET spawnX=?, spawnY=?, spawnZ=?, spawnRot=?, spawnInt=?, spawnDim=? WHERE uid=?",
            player:getPosition().x, player:getPosition().y, player:getPosition().z, player:getRotation().z, player:getInterior(), player:getDimension(), player:getId())
        player:sendNotification("Position saved!", "info")
    end
end

function AdminManager:adminBoost(player)
    if player:isAdmin(4) then
        local vehicle = player:getOccupiedVehicle()
        if vehicle then
            local vehicleVelocity = Vector3(vehicle:getVelocity())
            local speedup1 = math.abs(vehicleVelocity.x / 100 * 30)
            local speedup2 = math.abs(vehicleVelocity.y / 100 * 30)
            if vehicleVelocity.x >= 0 and vehicleVelocity.y >= 0 then
                vehicle:setVelocity(vehicleVelocity.x + speedup1, vehicleVelocity.y + speedup2, vehicleVelocity.z)
            end
            if vehicleVelocity.x <= 0 and vehicleVelocity.y <= 0 then
                vehicle:setVelocity(vehicleVelocity.x - speedup1, vehicleVelocity.y - speedup2, vehicleVelocity.z)
            end
            if vehicleVelocity.x >= 0 and vehicleVelocity.y <= 0 then
                vehicle:setVelocity(vehicleVelocity.x + speedup1, vehicleVelocity.y - speedup2, vehicleVelocity.z)
            end
            if vehicleVelocity.x <= 0 and vehicleVelocity.y >= 0 then
                vehicle:setVelocity(vehicleVelocity.x - speedup1, vehicleVelocity.y + speedup2, vehicleVelocity.z)
            end
        end
    end
end

function AdminManager:adminJump(player)
    if player:isAdmin(4) then
        local vehicle = player:getOccupiedVehicle()
        if vehicle then
            local vehicleVelocity = Vector3(vehicle:getVelocity())
            vehicle:setVelocity(vehicleVelocity.x, vehicleVelocity.y, vehicleVelocity.z + 0.3)
        end
    end
end

function AdminManager:setLeader(player, cmd, targetName, faction)
    if player:isAdmin(4) then
        if targetName then
            local target = getPlayerFromName(targetName)
            if isElement(target) then
                if faction then
                    local faction = tonumber(faction)
                    if faction >= 0 and faction <= #Settings.Faction.Names then
                        if faction == 0 then
                            target:setData("factionrank", 0)
                        else
                            target:setData("factionrank", 5)
                        end

                        target:setData("faction", faction)
                        target:setFactionSkin()
                        target:sendNotification("ADMIN_LEADER_CHANGE", "success", player:getName(), Settings.Faction.Names[faction])
                        player:sendNotification("ADMIN_LEADER_CHANGE_PLAYER", "info", target:getName(), Settings.Faction.Names[faction])

                        Logs:output("admin", "%s hat %s zum Leader von %s gemacht", player:getName(), target:getName(), Settings.Faction.Names[faction])
                    end
                end
            end
        end
    end
end

function AdminManager:getVehicle(player, cmd, id)
    if player:isAdmin(3) then
        if not id then return end
        local id = tonumber(id)

        if isElement(PlayerVehicle[id]) then
            if player:getDimension() == 0 and player:getInterior() == 0 then
                PlayerVehicle[id]:setPosition(player:getPosition().x + 2, player:getPosition().y, player:getPosition().z)
                PlayerVehicle[id]:setDimension(0)
                PlayerVehicle[id]:setInterior(0)
                player:sendNotification("ADMIN_GET_VEHICLE_TELEPORT", "info", getNameFromID(PlayerVehicle[id]:getOwner()))

                Logs:output("admin", "%s hat das Fahrzeug von %s zu sich teleportiert", player:getName(), getNameFromID(PlayerVehicle[id]:getOwner()))
            end
        end
    end
end

function AdminManager:gotoVehicle(player, cmd, id)
    if player:isAdmin(3) then
        if not id then return end
        local id = tonumber(id)

        if isElement(PlayerVehicle[id]) then
            if player:getDimension() == 0 and player:getInterior() == 0 then
                player:setPosition(PlayerVehicle[id]:getPosition().x, PlayerVehicle[id]:getPosition().y, PlayerVehicle[id]:getPosition().z + 2)
                player:setDimension(PlayerVehicle[id]:getDimension())
                player:setInterior(PlayerVehicle[id]:getInterior())
                player:sendNotification("ADMIN_GOTO_VEHICLE_TELEPORT", "info", getNameFromID(PlayerVehicle[id]:getOwner()))

                Logs:output("admin", "%s hat sich zu dem Fahrzeug von %s teleportiert", player:getName(), getNameFromID(PlayerVehicle[id]:getOwner()))
            end
        end
    end
end

function AdminManager:teleport(player, cmd, warpedName, targetName)
    if player:isAdmin(2) then
        if warpedName and targetName then
            local warped = getPlayerFromName(warpedName)
            local target = getPlayerFromName(targetName)
            if warped:loggedIn() and target:loggedIn() then
                if warped ~= target then
                    if (warped:getPosition() - target:getPosition()):getLength() > 10 then
                        warped:setPosition(target:getPosition().x, target:getPosition().y + 1, target:getPosition().z)
                        warped:setDimension(target:getDimension())
                        warped:setInterior(target:getInterior())
                        warped:sendNotification("Du wurdest zu %s teleportiert", "info", target:getName())
                        target:sendNotification("ADMIN_PLAYER_TELEPORT_TARGET", "info", warped:getName())

                        Logs:output("admin", "%s hat sich zu %s teleportiert", player:getName(), target:getName())
                    else
                        player:sendNotification("ADMIN_PLAYER_TELEPORT_ERROR", "error", warped:getName(), target:getName())
                    end
                end
            end
        end
    end
end

function AdminManager:addWhitelist(player, cmd, targetName, serial)
    if player:isAdmin(5) then
        if targetName and serial then
            Database:exec("INSERT INTO whitelist (username, serial) VALUES (?, ?)", targetName, serial)
            player:sendNotification("%s wurde auf die Whitelist gesetzt!", "info", targetName)

            Logs:output("admin", "%s hat %s mit der Serial: %s auf die Whitelist gesetzt", player:getName(), targetName, serial)
        end
    end
end

function AdminManager:removeWhitelist(player, cmd, targetName)
    if player:isAdmin(5) then
        if targetName then
            Database:exec("DELETE FROM whitelist WHERE username=?", targetName)
            player:sendNotification("%s wurde auf die Whitelist gesetzt!", "info", targetName)

            Logs:output("admin", "%s hat %s von der Whitelist entfernt", player:getName(), targetName)
        end
    end
end

function AdminManager:payday(player, cmd, targetName)
    if player:isAdmin(7) then
        if not targetName then
            player:setData("playtime", 59)
            player:payday()
        else
            local target = getPlayerFromName(targetName)
            target:setData("playtime", 59)
            target:payday()
        end
    end
end

function AdminManager:adminChat(player, cmd, ...)
    if player:isAdmin(1) then
        local msg = table.concat({ ... }, " ")
        if #msg > 0 then
            for key, value in pairs(getElementsByType("player")) do
                if value:loggedIn() then
                    if value:isAdmin(1) then
                        value:sendMessage("#2fa4c4[Intern] %s %s: %s", 255, 255, 255, Settings.AdminRanks[player:getData("adminlevel")], player:getName(), msg)
                    end
                end
            end
        end
    end
end

function AdminManager:serverChat(player, cmd, ...)
    if player:isAdmin(3) then
        local msg = table.concat({ ... }, " ")
        if #msg > 0 then
            for key, value in pairs(getElementsByType("player")) do
                if value:loggedIn() then
                    value:sendMessage("#f03e4d[Servernachricht] %s", 255, 255, 255, msg)
                end
            end
        end
    end
end
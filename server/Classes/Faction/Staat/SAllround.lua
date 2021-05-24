--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 22.12.2019
--|**********************************************************************

SAllround = inherit(Object)

addEvent("VL:SERVER:SAllround:grab", true)
addEvent("VL:SERVER:SAllround:ungrab", true)

function SAllround:constructor()
    self.m_RequestBlip = {}
    self.m_RequestBlipTime = 2
    self.m_Grabbed = {}

    addEventHandler("VL:SERVER:SAllround:grab", root, bind(self.grab, self))
    addEventHandler("VL:SERVER:SAllround:ungrab", root, bind(self.setUngrabbed, self))

    addCommandHandler("requestHelp", bind(self.requestHelp, self))
    addCommandHandler("cancelHelp", bind(self.cancelHelp, self))
    addCommandHandler("leash", bind(self.leash, self))
    addCommandHandler("unleash", bind(self.unleash, self))
    addCommandHandler("s", bind(self.sChat, self))
end

function SAllround:requestHelp(player)
    if Settings.Faction.Staat[player:getData("faction")] then
        if player:isDuty() then
            if not self.m_RequestBlip[player] then
                for key, value in pairs(getElementsByType("player")) do
                    if value:loggedIn() and value:isDuty() then
                        if Settings.Faction.Staat[value:getData("faction")] then
                            self.m_RequestBlip[player] = createBlipAttachedTo(player, 0, 2, 255, 255, 0, 255, 0, 16383.0, value)
                            player:sendNotification("SFPD_REQUEST_PLAYER", "info", self.m_RequestBlipTime)
                            value:sendNotification("SFPD_REQUEST_FACTION", "info", player:getName())
                            Timer(bind(self.cancelHelp, self), self.m_RequestBlipTime * 60000, 1, player)
                        end
                    end
                end
            else
                player:sendNotification("SFPD_REQUEST_PLAYER_ERROR", "error")
            end
        else
            player:sendNotification("SFPD_REQUEST_DUTY_ERROR", "error")
        end
    end
end

function SAllround:cancelHelp(player)
    assert(type(player) == "userdata", "Bad argument @ SFPD:cancelHelp #1")
    if isElement(self.m_RequestBlip[player]) then
        self.m_RequestBlip[player]:destroy()
    end
end

function SAllround:triggerTazer(player, target)
    if Settings.Faction.Staat[player:getData("faction")] and player:isDuty() then
        if not target:isTazered() then
            if (player:getPosition() - target:getPosition()):getLength() <= 7 then
                if not target:isInVehicle() and not player:isInVehicle() then
                    target:sendNotification("SFPD_TAZERED_TARGET", "info", player:getName())
                    player:sendNotification("SFPD_TAZERED_PLAYER", "info", target:getName())

                    target:setTazered()
                end
            end
        end
    end
end

function SAllround:leash(player, cmd, targetName)
    if targetName and getPlayerFromName(targetName) then
        if Settings.Faction.Staat[player:getData("faction")] and player:isDuty() then
            if player:isInVehicle() and player:getOccupiedVehicleSeat() == 0 then
                local target = getPlayerFromName(targetName)
                if target and target ~= player then
                    if target:isInVehicle() and target:getOccupiedVehicle() == player:getOccupiedVehicle() then
                        if not target:isLeashed() then
                            self:setLeashed(target, true)
                            player:sendNotification("SFPD_LEASHED_PLAYER", "info", target:getName())
                            target:sendNotification("SFPD_LEASHED_TARGET", "info", player:getName())
                        end
                    end
                end
            end
        end
    end
end

function SAllround:unleash(player, cmd, targetName)
    if targetName and getPlayerFromName(targetName) then
        if Settings.Faction.Staat[player:getData("faction")] and player:isDuty() then
            local target = getPlayerFromName(targetName)
            if target and target ~= player then
                if (target:getPosition() - player:getPosition()):getLength() < 5 then
                    if target:isLeashed() then
                        self:setLeashed(target, false)
                        player:sendNotification("SFPD_UNLEASHED_PLAYER", "info", target:getName())
                        target:sendNotification("SFPD_UNLEASHED_TARGET", "info", player:getName())
                    end
                end
            end
        end
    end
end

function SAllround:setLeashed(target, boolean)
    toggleAllControls(target, not boolean)
    target:setFrozen(boolean)
    target:setData("leashed", boolean)
end

function SAllround:grab(grabbedPlayer)
    if Settings.Faction.Staat[client:getData("faction")] and client:isDuty() then
        if grabbedPlayer:isTazered() then
            self:setGrabbed(client, grabbedPlayer, true)
        end
    end
end

function SAllround:setGrabbed(player, target, boolean)
    if isElement(target) then
        if not boolean then
            if self.m_Grabbed[player] and target:getData("grabbed") then
                if target:isTazered() then target:unTazer() end
                toggleAllControls(target, not boolean)
                target:setFrozen(boolean)
                target:setData("grabbed", boolean)

                target:detach(player)
                target:setCollisionsEnabled(true)
                self.m_Grabbed[player] = false
            end
        else
            if not self.m_Grabbed[player] and not target:getData("grabbed") then
                if target:isTazered() then target:unTazer() end
                toggleAllControls(target, not boolean)
                target:setFrozen(boolean)
                target:setData("grabbed", boolean)

                target:attach(player, 0, 0.6, 0)
                target:setCollisionsEnabled(false)
                self.m_Grabbed[player] = target

                bindKey(client, "F4", "down", bind(self.setUngrabbed, self), player)
                player:sendNotification("Du kannst den Spieler %s mit der Taste F4 wieder entfesseln!", "info", target:getName())
            end
        end
    end
end

function SAllround:setUngrabbed(player)
    if self.m_Grabbed[player] then
        player:sendNotification("Spieler %s entfesselt!", "info", self.m_Grabbed[player]:getName())
        self:setGrabbed(player, self.m_Grabbed[player], false)
    end
end

function SAllround:sChat(player, cmd, ...)
    if Settings.Faction.Staat[player:getData("faction")] then
        local text = table.concat({ ... }, " ")
        if text and #text > 0 then
            for key, value in pairs(getElementsByType("player")) do
                if value:loggedIn() then
                    if Settings.Faction.Staat[value:getData("faction")] then
                        value:sendMessage("[%s] %s: %s", 210, 90, 100, Settings.Faction.Names[player:getData("faction")], player:getName(), text)
                    end
                end
            end
        else
            player:sendNotification("Gib einen Text ein!", "error")
        end
    end
end
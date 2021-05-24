--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 24.11.2019
--|**********************************************************************

FactionManager = inherit(Object)

addEvent("VL:SERVER:FactionManager:setDuty", true)
addEvent("VL:SERVER:FactionManager:setOffDuty", true)

function FactionManager:constructor()
    self.m_DutyPickups = {
        { 258.4931640625, 109.24609375, 1003.21875, 10, 1 }
    }

    addEventHandler("VL:SERVER:FactionManager:setDuty", root, bind(self.setDuty, self))
    addEventHandler("VL:SERVER:FactionManager:setOffDuty", root, bind(self.setOffDuty, self))

    self:loadPickups()
end

function FactionManager:loadPickups()
    for key, value in pairs(self.m_DutyPickups) do
        local pickup = createPickup(value[1], value[2], value[3], 3, 1239, 0)
        pickup:setInterior(value[4])

        addEventHandler("onPickupHit", pickup, function(player)
            if player:getData("faction") == value[5] then
                player:triggerEvent("VL:CLIENT:DutyGUI:show", player)
            end
        end)
    end
end

function FactionManager:getOnlineFactionMembers(id)
    assert(type(id) == "number", "Bad argument @ FactionManager:getFactionMember")
    self.m_Counter = 0
    for key, value in pairs(getElementsByType("player")) do
        if value:loggedIn() then
            if value:getData("faction") == id then
                self.m_Counter = self.m_Counter + 1
            end
        end
    end
    return self.m_Counter
end

function FactionManager:setFactionSkin(player, duty)
    if player:getData("faction") > 0 then
        if Settings.Faction.Duty[player:getData("faction")] and duty then
            player:setData("duty", true)
            player:setModel(Settings.Faction.Skins[player:getData("faction")][player:getData("factionrank") + 1])
        else
            player:setModel(player:getData("skinid"))
        end
    else
        player:setModel(player:getData("skinid"))
    end
end

function FactionManager:sendFactionMessage(id, msg, r, g, b, ...)
    assert(type(id) == "number", "Bad argument @ FactionManager:sendFactionMessage #1")
    local msg = self:tryToGetLocalization(msg)

    for key, value in pairs(getElementsByType("player")) do
        if value:loggedIn() then
            if value:getData("faction") == id and value:isDuty() then
                value:outputChat((msg):format(...), r or 255, g or 255, b or 255, true)
            end
        end
    end
end

function FactionManager:setDuty()
    if not client:isDuty() then
        self:setFactionSkin(client, true)
        client:sendNotification("Du hast den Dienst begonnen!", "info")
    else
        client:sendNotification("Du bist bereits im Dienst!", "error")
    end
end

function FactionManager:setOffDuty()
    if client:isDuty() then
        self:setFactionSkin(client)
        client:setData("duty", false)
        client:sendNotification("Du hast den Dienst beendet!", "info")
    end
end
--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

PlayerManager = inherit(Singleton)

addEvent("VL:SERVER:isRegistered", true)

function PlayerManager:constructor()
    self.m_IsRegistered = {}

    addEventHandler("onResourceStop", resourceRoot, bind(self.onResourceStop, self))
    addEventHandler("onPlayerConnect", resourceRoot, bind(self.onPlayerConnect, self))
    addEventHandler("VL:SERVER:isRegistered", root, bind(self.checkAfterDownload, self))
    addEventHandler("onPlayerWasted", root, bind(self.onDie, self))
end

function PlayerManager:checkAfterDownload()
    self.m_UID = client:receiveDatas("userdata", "serial", client:getSerial(), "uid")
    if self.m_UID then
        client:triggerEvent("VL:CLIENT:checkAutologin", client)
    else
        client:triggerEvent("VL:CLIENT:openRegister", client)
    end
end

function PlayerManager:onResourceStop()
    for key, value in ipairs(getElementsByType("player")) do
        Player.destructor(value)
    end
end

function PlayerManager:onPlayerConnect(nick, ip, username, serial)
    if Settings.Whitelist then
        self:checkWhitelist(serial, nick)
    end
end

function PlayerManager:checkWhitelist(serial, name)
    assert(type(serial) == "string", "Bad argument @ PlayerManager:checkWhitelist #1")
    local query = Database:query("SELECT * FROM whitelist WHERE serial=?", serial)
    if query then
        local result = Database:poll(query, -1)
        if result[1] then
            return true
        else
            cancelEvent(true, ("Hey %s, you are currently not whitelisted. Sorry :>"):format(name))
        end
    end
end

function PlayerManager:onDie()
    source:setSpawn()
end

function PlayerManager:giveLoginInfos(player)

    for i = 1, 50 do
        outputChatBox(" ")
    end

    if player:getQuestStep() <= Quest:getMaxQuests() then
        player:sendHint("TIP_QUEST", 255, 255, 0)
    end

    if player:getData("playtime") < 180 then
        player:sendHint("TIP_HELPME", 255, 255, 0)
        player:sendHint("TIP_HELPMENUE", 255, 255, 0)
        player:sendHint("TIP_TICKET", 255, 255, 0)
    end

    if player:getData("lastlogin") ~= "0000-00-00" then
        player:sendMessage("#d19f15[Letzer Login]#ffffff %s", 255, 255, 255, player:getData("lastlogin"))
    end
end
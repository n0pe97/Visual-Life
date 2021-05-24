--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

LocalPlayer = inherit(Singleton)

addEvent("VL:CLIENT:changeLanguage", true)
addEvent("VL:CLIENT:changeHitglocke", true)
addEvent("VL:CLIENT:changeAutoLogin", true)

function LocalPlayer:constructor()

    addEventHandler("VL:CLIENT:changeLanguage", root, bind(self.changeLanguage, self))
    addEventHandler("VL:CLIENT:changeHitglocke", root, bind(self.changeHitglocke, self))
    addEventHandler("VL:CLIENT:changeAutoLogin", root, bind(self.changeAutoLogin, self))
end

function LocalPlayer:checkOnResourceStart()
    triggerServerEvent("VL:SERVER:onPlayerJoin")
end

function LocalPlayer:tryToGetLocalization(string)
    local tryResult = loc(string, self)
    if tryResult == string then
        return string
    else
        return tryResult
    end
end

function LocalPlayer:sendMessage(msg, r, g, b, ...)
    local msg = self:tryToGetLocalization(msg)
    if not r then
        r, g, b = 255, 255, 255
    end
    Chat:sendMessage((msg):format(...), r, g, b, true)
end

function LocalPlayer:sendNotification(msg, type, ...)
    local msg = self:tryToGetLocalization(msg)
    if not r then
        r, g, b = 255, 255, 255
    end
    NotificationGUI.new((msg):format(...), type)
end

function LocalPlayer:changeLanguage()
    if config:get("language") == "DE" then
        config:set("language", "EN")
        self:setData("language", "EN")
    elseif config:get("language") == "EN" then
        config:set("language", "DE")
        self:setData("language", "DE")
    end
    self:sendNotification("ADMIN_CHANGE_LANGUAGE", "info", self:getData("language"))
end

function LocalPlayer:changeHitglocke()
    if config:get("hitglocke") == "1" then
        config:set("hitglocke", "0")
        self:setData("hitglocke", 0)
        self:sendNotification("Hitglocke deactivated", "info")
    elseif config:get("hitglocke") == "0" then
        config:set("hitglocke", "1")
        self:setData("hitglocke", 1)
        self:sendNotification("Hitglocke activated", "info")
    end
end

function LocalPlayer:changeAutoLogin(password)
    if password then
        if config:get("autologin") == "0" then
            config:set("autologin", "1")
            config:set("password", password)
        else
            self:sendNotification("ADMIN_CHANGE_AUTOLOGIN_DEACTIVATE", "error")
        end
    else
        if config:get("autologin") == "1" then
            config:set("autologin", "0")
            self:sendNotification("ADMIN_CHANGE_AUTOLOGIN_OFF", "success")
        else
            self:sendNotification("ADMIN_CHANGE_AUTOLOGIN_OFF_ERROR", "error")
        end
    end
end

function LocalPlayer:loggedIn()
    if self:getData("loggedin") then
        return true
    else
        return false
    end
end

function LocalPlayer:getId()
    if self:getData("uid") then
        return self:getData("uid")
    end
end

function LocalPlayer:clicked()
    if not self:getData("clicked") then
        return false
    else
        return true
    end
end

function LocalPlayer:getHungry()
    return tonumber(self:getData("hungry"))
end

function LocalPlayer:isDuty()
    if self:getData("duty") then
        return true
    end
end
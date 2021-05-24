--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

setGameType(Settings.GameSettings.Type)
setFPSLimit(Settings.GameSettings.FPS)

addEventHandler("onPlayerJoin", root, function()
    setPlayerNametagShowing(source, false)
    setPlayerHudComponentVisible(source, "area_name", false)
end)

addEventHandler("onPlayerChangeNick", root, function()
    cancelEvent()
    source:sendNotification("", "error")
end)

addEvent("toggleServersideControl", true)
addEventHandler("toggleServersideControl", root, function(control, boolean)
    client:toggleControl(control, boolean)
end)

function checkAFK()
    for key, value in pairs(getElementsByType("player")) do
        if value:loggedIn() then
            if value:getIdleTime() > 60000 * 5 then
                if not value:isAfk() then
                    value:setAfk(true)
                end
            end
        end
    end
end

setTimer(checkAFK, 60000 * 5, 0)

function getNameFromID(id)
    if id and tonumber(id) then
        local query = Database:query("SELECT username FROM userdata WHERE uid=?", id)
        if query then
            local result = Database:poll(query, -1)
            if result then
                for key, value in pairs(result) do
                    return value["username"]
                end
            end
        end
    else
        return "none"
    end
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle)
    local dx = math.cos(a) * dist
    local dy = math.sin(a) * dist
    return x + dx, y + dy
end
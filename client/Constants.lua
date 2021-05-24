--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

screenWidth, screenHeight = guiGetScreenSize()
local font = dxCreateFont("res/Fonts/nunito-regular.ttf", 11)

setTimer(function()
    if localPlayer:getHungry() >= 3 then
        localPlayer:setData("hungry", localPlayer:getHungry() - 2)
    elseif localPlayer:getHungry() > 0 and localPlayer:getHungry() <= 2 then
        localPlayer:setData("hungry", localPlayer:getHungry() - 1)
    elseif localPlayer:getHungry() <= 0 then
        localPlayer:sendNotification("HUNGRY_DEATH", "info")
        localPlayer:setData("hungry", 100)
        --triggerServerEvent("killUserHunger", getLocalPlayer())
    end

    if localPlayer:getHungry() <= 8 and localPlayer:getHungry() > 0 then
        localPlayer:sendNotification("HUNGRY_NOTIFY", "info")
    end
end, 6 * 60000, 0)

addEventHandler("onClientRender", root, function()
    dxDrawText(Settings.GameSettings.Version, screenWidth - 87, screenHeight - 25, 0, 0, tocolor(255, 255, 255, 100), 1, "default")

    if localPlayer:loggedIn() then
        dxDrawText(("UID: %d | %s"):format(localPlayer:getId(), localPlayer:getName()), 18, screenHeight - 30, 0, 0, tocolor(255, 255, 255, 100), 1, font)
    end
end)

addEventHandler("onClientKey", root, function()
    if localPlayer:getData("afk") then
        localPlayer:setData("afk", false)
    end
end)
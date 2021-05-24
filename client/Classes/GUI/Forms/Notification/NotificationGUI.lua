--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 23.11.2019
--|**********************************************************************

local screenWidth, screenHeight = guiGetScreenSize()

NotificationGUI = {}
NotificationGUI.boxes = {}

NotificationGUI.START_POSX = 25 * (screenWidth / 1920)
NotificationGUI.START_POSY = 725 * (screenHeight / 1080)
NotificationGUI.OFFSET_PER_ENTRY = 70
NotificationGUI.HEIGHT = 60
NotificationGUI.WIDTH = 370
NotificationGUI.NEW_WIDTH = 0
NotificationGUI.HEADER_TEXT = ""
NotificationGUI.HEADER_FONT = dxCreateFont("res/Fonts/nunito-semibold.ttf", 11)
NotificationGUI.FONT = dxCreateFont("res/Fonts/nunito-regular.ttf", 11)

NotificationGUI.DEFAULT_EXPIRE_TIME = 6500
NotificationGUI.FADE_OFFSET_BACK = 1500
NotificationGUI.FADE_OFFSET_IN = 1000

function NotificationGUI.new(text, type, expire)
    if type == "error" then
        r, g, b = 183, 28, 28
    elseif type == "success" then
        r, g, b = 46, 125, 50
    else
        r, g, b = 69, 39, 160
    end

    table.insert(NotificationGUI.boxes,
        {
            Text = text,
            Time = getTickCount(),
            Expire = expire or NotificationGUI.DEFAULT_EXPIRE_TIME,
            ExpireTime = getTickCount() + (expire or NotificationGUI.DEFAULT_EXPIRE_TIME),
            Type = type,
            Red = r,
            Green = g,
            Blue = b,
            CurrentOffset = NotificationGUI.OFFSET_PER_ENTRY * (#NotificationGUI.boxes),
            CurrentFade = 1
        })

    if type == "error" then
        playSoundFrontEnd(13)
    else
        playSoundFrontEnd(11)
    end
end

addEvent("VL:CLIENT:sendNotification", true)
addEventHandler("VL:CLIENT:sendNotification", root, NotificationGUI.new)

function NotificationGUI.render()
    for key, value in ipairs(NotificationGUI.boxes) do

        if value.Type == "error" then
            NotificationGUI.HEADER_TEXT = loc("NOTIFICATION_ERROR")
        elseif value.Type == "success" then
            NotificationGUI.HEADER_TEXT = loc("NOTIFICATION_SUCCESS")
        else
            value.Type = "info"
            NotificationGUI.HEADER_TEXT = loc("NOTIFICATION_INFO")
        end

        local totalWidth = dxGetTextWidth(value.Text, 1, "default-bold") + 150

        if totalWidth > NotificationGUI.WIDTH then
            NotificationGUI.NEW_WIDTH = totalWidth
        else
            NotificationGUI.NEW_WIDTH = NotificationGUI.WIDTH
        end

        if getTickCount() >= value.ExpireTime - NotificationGUI.FADE_OFFSET_BACK then
            local easingValue = (getTickCount() - (value.ExpireTime - NotificationGUI.FADE_OFFSET_BACK)) / NotificationGUI.FADE_OFFSET_BACK

            easingValue = getEasingValue(easingValue, "InBack")


            dxDrawRectangle(NotificationGUI.START_POSX, NotificationGUI.START_POSY - value.CurrentOffset, NotificationGUI.NEW_WIDTH, NotificationGUI.HEIGHT, tocolor(value.Red, value.Green, value.Blue, 255))
            dxDrawImage(NotificationGUI.START_POSX + 20, NotificationGUI.START_POSY - value.CurrentOffset + 13, 34, 34, "res/Images/GUI/Notification/" .. value.Type .. ".png")

            dxDrawText(NotificationGUI.HEADER_TEXT,
                NotificationGUI.START_POSX + 65,
                NotificationGUI.START_POSY - 15 - value.CurrentOffset,
                NotificationGUI.START_POSX + NotificationGUI.NEW_WIDTH,
                NotificationGUI.START_POSY - value.CurrentOffset + NotificationGUI.HEIGHT,
                tocolor(255, 255, 255),
                1,
                NotificationGUI.HEADER_FONT,
                "left",
                "center",
                true)

            dxDrawText(value.Text,
                NotificationGUI.START_POSX + 65,
                NotificationGUI.START_POSY + 20 - value.CurrentOffset,
                NotificationGUI.START_POSX + NotificationGUI.NEW_WIDTH,
                NotificationGUI.START_POSY - value.CurrentOffset + NotificationGUI.HEIGHT,
                tocolor(255, 255, 255),
                1,
                NotificationGUI.FONT,
                "left",
                "center",
                true)
        else
            local easingValue = math.min(1, (getTickCount() - (value.Time)) / NotificationGUI.FADE_OFFSET_IN)

            easingValue = getEasingValue(easingValue, "OutBack")


            dxDrawRectangle(NotificationGUI.START_POSX, NotificationGUI.START_POSY - value.CurrentOffset, NotificationGUI.NEW_WIDTH, NotificationGUI.HEIGHT, tocolor(value.Red, value.Green, value.Blue, 255))
            dxDrawImage(NotificationGUI.START_POSX + 20, NotificationGUI.START_POSY - value.CurrentOffset + 13, 34, 34, "res/Images/GUI/Notification/" .. value.Type .. ".png")

            dxDrawText(NotificationGUI.HEADER_TEXT,
                NotificationGUI.START_POSX + 65,
                NotificationGUI.START_POSY - 15 - value.CurrentOffset,
                NotificationGUI.START_POSX + NotificationGUI.NEW_WIDTH,
                NotificationGUI.START_POSY - value.CurrentOffset + NotificationGUI.HEIGHT,
                tocolor(255, 255, 255),
                1,
                NotificationGUI.HEADER_FONT,
                "left",
                "center",
                true)

            dxDrawText(value.Text,
                NotificationGUI.START_POSX + 65,
                NotificationGUI.START_POSY + 20 - value.CurrentOffset,
                NotificationGUI.START_POSX + NotificationGUI.NEW_WIDTH,
                NotificationGUI.START_POSY - value.CurrentOffset + NotificationGUI.HEIGHT,
                tocolor(255, 255, 255),
                1,
                NotificationGUI.FONT,
                "left",
                "center",
                true)
        end




        local shouldOffset = NotificationGUI.OFFSET_PER_ENTRY * (key - 1)

        if value.CurrentOffset > shouldOffset then
            value.CurrentOffset = math.max(shouldOffset, value.CurrentOffset - 10)
        end

        if getTickCount() >= value.ExpireTime then
            table.remove(NotificationGUI.boxes, key)
            NotificationGUI.NEW_WIDTH = 0
        end
    end
end

addEventHandler("onClientRender", root, NotificationGUI.render)
--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 23.11.2019
--|**********************************************************************

ScoreboardGUI = inherit(Object)

function ScoreboardGUI:constructor()
    self.m_ScreenX, self.m_ScreenY = screenWidth, screenHeight
    self.m_PlayerX, self.m_PlayerY = self.m_ScreenX / 1440, self.m_ScreenY / 900
    self.m_Size = interpolateBetween(8, 0, 0, 10, 0, 0, ((self.m_ScreenX - 1280) / (1920 - 1280)), "Linear")
    self.m_Font = dxCreateFont("res/Fonts/nunito-regular.ttf", 12)
    self.m_FontLegende = dxCreateFont("res/Fonts/nunito-regular.ttf", 11)

    self.m_Index = 1
    self.m_FactionColors = Settings.Faction.Colors
    self.m_StartTick, self.m_Duration, self.m_EndTick = nil, 600, nil
    self.m_Debounce = false
    self.m_IsAllowed = true

    self.m_Show = bind(self.show, self)
    self.m_Render = bind(self.render, self)
    self.m_ScrollDown = bind(self.scrollDown, self)
    self.m_ScrollUp = bind(self.scrollUp, self)

    bindKey("tab", "both", self.m_Show)
end


function ScoreboardGUI:show(key, state)
    if localPlayer:loggedIn() then
        if key ~= "tab" then return end

        if state == "down" then
            if self.m_IsAllowed then
                if not self.m_Debounce then
                    self.m_IsAllowed = false
                    self.m_Debounce = true
                    self.m_StartTick = getTickCount()
                    self.m_EndTick = self.m_StartTick + self.m_Duration
                    addEventHandler("onClientRender", root, self.m_Render)
                    localPlayer:setData("clicked", true)
                    bindKey("mouse_wheel_down", "down", self.m_ScrollDown)
                    bindKey("mouse_wheel_up", "down", self.m_ScrollUp)
                    showChat(false)
                end
            end
        else
            if self.m_Debounce then
                self.m_Debounce = false
                self.m_StartTick = getTickCount()
                self.m_EndTick = self.m_StartTick + self.m_Duration
                Timer(function()
                    localPlayer:setData("clicked", false)
                    removeEventHandler("onClientRender", root, self.m_Render)
                    self.m_IsAllowed = true
                    unbindKey("mouse_wheel_down", "down", self.m_ScrollDown)
                    unbindKey("mouse_wheel_up", "down", self.m_ScrollUp)
                    showChat(true)
                end, self.m_Duration, 1)
            end
        end
    end
end

function ScoreboardGUI:scrollDown()
    if #getElementsByType("player") > 20 then
        if #getElementsByType("player") > self.m_Index then
            self.m_Index = self.m_Index + 1
        end
    end
end

function ScoreboardGUI:scrollUp()
    if #getElementsByType("player") > 20 then
        self.m_Index = self.m_Index - 1
        if self.m_Index == 0 then
            self.m_Index = 1
        end
    else
        self.m_Index = 1
    end
end

function ScoreboardGUI:getPlayTime(player)
    local ptime = tonumber(player:getData("playtime"))
    if not ptime then return "-" end
    local hour = math.floor(ptime / 60)
    local minute = ptime - hour * 60
    if hour < 10 then hour = "0" .. hour end
    if minute < 10 then minute = "0" .. minute end
    return hour .. ":" .. minute
end

function ScoreboardGUI:getPingColor(ping)
    if ping < 100 then
        return 67, 160, 71
    elseif ping > 100 and ping < 200 then
        return 255, 179, 0
    elseif ping >= 200 then
        return 211, 47, 47
    end
end

function ScoreboardGUI:getFaction(id)
    return Settings.Faction.Names[id]
end

function ScoreboardGUI:countFactionMember(id)
    return FactionManager:getOnlineFactionMembers(id)
end

function ScoreboardGUI:render()
    self.m_CurrentTick = getTickCount()
    self.m_Progress = (self.m_CurrentTick - self.m_StartTick) / self.m_Duration

    if not self.m_Debounce then
        self.m_Alpha = interpolateBetween(self.m_Alpha, 0, 0, 0, 0, 0, self.m_Progress, "Linear")
    else
        self.m_Alpha = interpolateBetween(0, 0, 0, 255, 0, 0, self.m_Progress, "Linear")
    end

    dxDrawImage(self.m_ScreenX / 2 - 700 / 2 * self.m_PlayerX, self.m_ScreenY / 2 - 450 / 2 * self.m_PlayerY, 700 * self.m_PlayerX, 450 * self.m_PlayerY, "res/Images/GUI/Scoreboard/scoreboard.png", 0, 0, 0, tocolor(255, 255, 255, self.m_Alpha))
    dxDrawText(loc("SCOREBOARD_USERNAME"), 370 * self.m_PlayerX, 265 * self.m_PlayerY, 500 * self.m_PlayerX, 270 * self.m_PlayerY, tocolor(117, 71, 255, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_FACTION"), 515 * self.m_PlayerX, 265 * self.m_PlayerY, 592 * self.m_PlayerX, 270 * self.m_PlayerY, tocolor(117, 71, 255, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_PLAYTIME"), 635 * self.m_PlayerX, 265 * self.m_PlayerY, 680 * self.m_PlayerX, 270 * self.m_PlayerY, tocolor(117, 71, 255, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_LEVEL"), 810 * self.m_PlayerX, 265 * self.m_PlayerY, 680 * self.m_PlayerX, 270 * self.m_PlayerY, tocolor(117, 71, 255, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_PHONENUMBER"), 865 * self.m_PlayerX, 265 * self.m_PlayerY, 798 * self.m_PlayerX, 270 * self.m_PlayerY, tocolor(117, 71, 255, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_JOB"), 990 * self.m_PlayerX, 265 * self.m_PlayerY, 888 * self.m_PlayerX, 270 * self.m_PlayerY, tocolor(117, 71, 255, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_PING"), 1015 * self.m_PlayerX, 265 * self.m_PlayerY, 1047 * self.m_PlayerX, 270 * self.m_PlayerY, tocolor(117, 71, 255, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)

    dxDrawImage(390 * self.m_PlayerX, 233 * self.m_PlayerY, 26, 19, "res/Images/GUI/Scoreboard/left_icon.png", 0, 0, 0, tocolor(255, 255, 255, self.m_Alpha))
    dxDrawImage(1030 * self.m_PlayerX, 233 * self.m_PlayerY, 21, 21, "res/Images/GUI/Scoreboard/right_icon.png", 0, 0, 0, tocolor(255, 255, 255, self.m_Alpha))
    dxDrawText(loc("SCOREBOARD_WELCOME_BACK"):format(localPlayer:getName()), 420 * self.m_PlayerX, 232 * self.m_PlayerY, 380 * self.m_PlayerX, 270 * self.m_PlayerY, tocolor(255, 255, 255, self.m_Alpha), 1, self.m_Font, "left", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_ONLINE"):format(#getElementsByType("player")), 420 * self.m_PlayerX, 232 * self.m_PlayerY, 1020 * self.m_PlayerX, 270 * self.m_PlayerY, tocolor(255, 255, 255, self.m_Alpha), 1, self.m_Font, "right", "top", false, false, false, false, false)

    local players = getElementsByType("player")

    table.sort(players, function(a, b)
        local temp_a = -1
        local temp_b = -1
        if a:getData("loggedin") then
            temp_a = a:getData("faction")
        end
        if b:getData("loggedin") then
            temp_b = b:getData("faction")
        end
        return temp_a < temp_b
    end)

    for i = self.m_Index, self.m_Index + 20 do

        if not players[i] then break end
        local v = players[i]
        local name = v:getName()

        if v:getData("loggedin") then
            if v:getData("adminlevel") >= 1 then
                name = "[VL]" .. name
            else
                name = name
            end

            self.m_GetFactionName = v:getData("faction")
            local fr, fg, fb = self.m_FactionColors[self.m_GetFactionName][1], self.m_FactionColors[self.m_GetFactionName][2], self.m_FactionColors[self.m_GetFactionName][3]
            local pr, pg, pb = self:getPingColor(v.ping)

            dxDrawText(string.gsub(name, "#%x%x%x%x%x%x", ""), 404 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) * 20 + 9, tocolor(fr, fg, fb, self.m_Alpha), 1, self.m_Font, "left", "top", false, false, false, false, false)
            dxDrawText(self:getFaction(v:getData("faction")), 610 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) + 9, tocolor(fr, fg, fb, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
            dxDrawText(self:getPlayTime(v), 818 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) + 9, tocolor(fr, fg, fb, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
            dxDrawText(v:getData("level"), 990 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) + 9, tocolor(fr, fg, fb, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
            dxDrawText(v:getData("phonenumber"), 1165 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) + 9, tocolor(fr, fg, fb, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
            dxDrawText(v:getData("job"), 1380 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) + 9, tocolor(fr, fg, fb, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
            dxDrawText(getPlayerPing(v), 1560 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) + 9, tocolor(pr, pg, pb, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
        else
            dxDrawText(string.gsub(name, "#%x%x%x%x%x%x", ""), 404 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) * 20 + 9, tocolor(255, 255, 255, self.m_Alpha), 1, self.m_Font, "left", "top", false, false, false, false, false)
            dxDrawText("-", 610 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) + 9, tocolor(255, 255, 255, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
            dxDrawText("-", 818 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) + 9, tocolor(255, 255, 255, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
            dxDrawText("-", 990 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) + 9, tocolor(255, 255, 255, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
            dxDrawText("-", 1165 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) + 9, tocolor(255, 255, 255, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
            dxDrawText("-", 1380 * self.m_PlayerX, 291 * self.m_PlayerY + (i - self.m_Index) * 20 + 9, 500 * self.m_PlayerX, 292 * self.m_PlayerY + (i - 1) + 9, tocolor(255, 255, 255, self.m_Alpha), 1, self.m_Font, "center", "top", false, false, false, false, false)
        end
    end

    dxDrawText(loc("SCOREBOARD_FACTION_SFPD"):format(self:countFactionMember(1)), 310 * self.m_PlayerX, 650 * self.m_PlayerY, 500 * self.m_PlayerX, 292 * self.m_PlayerY, tocolor(self.m_FactionColors[1][1], self.m_FactionColors[1][2], self.m_FactionColors[1][3], self.m_Alpha), 1, self.m_FontLegende, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_FACTION_NORDIC"):format(self:countFactionMember(9)), 480 * self.m_PlayerX, 650 * self.m_PlayerY, 500 * self.m_PlayerX, 292 * self.m_PlayerY, tocolor(self.m_FactionColors[9][1], self.m_FactionColors[9][2], self.m_FactionColors[9][3], self.m_Alpha), 1, self.m_FontLegende, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_FACTION_MAFIA"):format(self:countFactionMember(2)), 655 * self.m_PlayerX, 650 * self.m_PlayerY, 500 * self.m_PlayerX, 292 * self.m_PlayerY, tocolor(self.m_FactionColors[2][1], self.m_FactionColors[2][2], self.m_FactionColors[2][3], self.m_Alpha), 1, self.m_FontLegende, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_FACTION_RIFA"):format(self:countFactionMember(7)), 785 * self.m_PlayerX, 650 * self.m_PlayerY, 500 * self.m_PlayerX, 292 * self.m_PlayerY, tocolor(self.m_FactionColors[7][1], self.m_FactionColors[7][2], self.m_FactionColors[7][3], self.m_Alpha), 1, self.m_FontLegende, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_FACTION_EMERGENCY"):format(self:countFactionMember(10)), 950 * self.m_PlayerX, 650 * self.m_PlayerY, 500 * self.m_PlayerX, 292 * self.m_PlayerY, tocolor(self.m_FactionColors[10][1], self.m_FactionColors[10][2], self.m_FactionColors[10][3], self.m_Alpha), 1, self.m_FontLegende, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_FACTION_MECH"):format(self:countFactionMember(11)), 1165 * self.m_PlayerX, 650 * self.m_PlayerY, 500 * self.m_PlayerX, 292 * self.m_PlayerY, tocolor(self.m_FactionColors[11][1], self.m_FactionColors[11][2], self.m_FactionColors[11][3], self.m_Alpha), 1, self.m_FontLegende, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_FACTION_NEWS"):format(self:countFactionMember(5)), 1385 * self.m_PlayerX, 650 * self.m_PlayerY, 500 * self.m_PlayerX, 292 * self.m_PlayerY, tocolor(self.m_FactionColors[5][1], self.m_FactionColors[5][2], self.m_FactionColors[5][3], self.m_Alpha), 1, self.m_FontLegende, "center", "top", false, false, false, false, false)
    dxDrawText(loc("SCOREBOARD_FACTION_CIVILIAN"):format(self:countFactionMember(0)), 1555 * self.m_PlayerX, 650 * self.m_PlayerY, 500 * self.m_PlayerX, 292 * self.m_PlayerY, tocolor(self.m_FactionColors[0][1], self.m_FactionColors[0][2], self.m_FactionColors[0][3], self.m_Alpha), 1, self.m_FontLegende, "center", "top", false, false, false, false, false)
end
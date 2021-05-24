--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 03.01.2020
--|**********************************************************************

PaydayGUI = inherit(Object)

addEvent("VL:CLIENT:PaydayGUI:activate", true)

function PaydayGUI:constructor()
    self.m_Debounce = false
    self.m_IsMoving = false
    self.m_StartTick = 0
    self.m_Duration = 500
    self.m_EndTick = nil
    self.m_Width = 440
    self.m_ColumnHeight = 25
    self.m_Font = dxCreateFont("res/Fonts/nunito-regular.ttf", 15)
    self.m_Font1 = dxCreateFont("res/Fonts/nunito-regular.ttf", 11)

    self.m_Renderer = bind(self.draw, self)

    addEventHandler("VL:CLIENT:PaydayGUI:activate", root, bind(self.activate, self))
end

function PaydayGUI:activate(tbl, total)
    self.m_PaydayTable = tbl
    self.m_TotalMoney = total
    self.m_Hide = false
    self.m_Sound = playSound("res/Sounds/payday.mp3")
    self.m_Sound:setVolume(0.5)
    self.m_Timer = Timer(function() if not self.m_Hide then self:hide() end end, 10000, 1)

    addEventHandler("onClientRender", root, self.m_Renderer)

    bindKey("space", "down", bind(self.hide, self))

    self:move()
end

function PaydayGUI:move()
    if not self.m_IsMoving then
        self.m_Debounce = not self.m_Debounce
        self.m_StartTick = getTickCount()
        self.m_EndTick = self.m_StartTick + self.m_Duration
        self.m_IsMoving = not self.m_IsMoving
        Timer(function() self.m_IsMoving = not self.m_IsMoving end, self.m_Duration, 1)
    end
end

function PaydayGUI:hide()
    if not self.m_IsMoving and not self.m_Hide then
        self.m_Debounce = not self.m_Debounce
        self.m_StartTick = getTickCount()
        self.m_EndTick = self.m_StartTick + self.m_Duration
        self.m_IsMoving = not self.m_IsMoving
        Timer(function()
            self.m_IsMoving = not self.m_IsMoving
            self.m_Hide = true
            if isElement(self.m_Sound) then self.m_Sound:destroy() end
            removeEventHandler("onClientRender", root, self.m_Renderer)
        end, self.m_Duration, 1)
    end
end

function PaydayGUI:draw()
    self.m_CurrentTick = getTickCount()
    self.m_ProgressMove = (self.m_CurrentTick - self.m_StartTick) / self.m_Duration

    if not self.m_Debounce then
        self.m_NewPosition = interpolateBetween(0, 0, 0, -250, 0, 0, self.m_ProgressMove, "InQuad")
    else
        self.m_NewPosition = interpolateBetween(-250, 0, 0, 0, 0, 0, self.m_ProgressMove, "OutQuad")
    end

    dxDrawRectangle(screenWidth / 2 - self.m_Width / 2, self.m_NewPosition, self.m_Width, 30, tocolor(29, 29, 29, 255))
    dxDrawText("Payday", screenWidth / 2 - self.m_Width / 2, self.m_NewPosition + 1, self.m_Width + screenWidth / 2 - self.m_Width / 2, 20, Settings.Color.White, 1, self.m_Font, "center", "top", false, false, false, true)

    if self.m_PaydayTable then
        for key, value in ipairs(self.m_PaydayTable) do
            dxDrawRectangle(screenWidth / 2 - self.m_Width / 2, self.m_NewPosition + 5 + key * self.m_ColumnHeight, self.m_Width, self.m_ColumnHeight, tocolor(29, 29, 29, value.alpha))
            dxDrawText(("%s: " .. value.hex .. "%s€"):format(value.name, comma_value(value.amount)), screenWidth / 2 - self.m_Width / 2 + 10, self.m_NewPosition + key * self.m_ColumnHeight + 8, self.m_Width + screenWidth / 2 - self.m_Width / 2, 20, Settings.Color.White, 1, self.m_Font1, "left", "top", false, false, false, true)
        end

        dxDrawRectangle(screenWidth / 2 - self.m_Width / 2, self.m_NewPosition + 5 + 7.3 * self.m_ColumnHeight, self.m_Width, self.m_ColumnHeight + 5, tocolor(29, 29, 29, 220))
        dxDrawText(("#cfa202%s#ffffff: %s€"):format("Total", comma_value(self.m_TotalMoney)), screenWidth / 2 - self.m_Width / 2 + 10, self.m_NewPosition + 7.2 * self.m_ColumnHeight + 8, self.m_Width + screenWidth / 2 - self.m_Width / 2, 20, Settings.Color.White, 1, self.m_Font, "left", "top", false, false, false, true)
    end

    dxDrawText("Drücke [Leertaste] zum schließen", screenWidth / 2 - self.m_Width / 2, self.m_NewPosition + 5 + 8.6 * self.m_ColumnHeight, self.m_Width + screenWidth / 2 - self.m_Width / 2, 20, Settings.Color.White, 1, self.m_Font1, "center", "top", false, false, false, true)
end

--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 16.12.2019
--|**********************************************************************

GUIGridlist = inherit(GUIElement)

function GUIGridlist:constructor(posX, posY, width, height, color, col, tbl, parent)
    GUIElement.constructor(self, posX, posY, width, height, parent)

    self.m_Font = dxCreateFont("res/Fonts/nunito-regular.ttf", 12)
    self.m_RowHeight = dxGetFontHeight(1.4, self.m_Font)
    self.m_Columns = col
    self.m_Table = tbl
    self.m_MaxRow = math.floor(height / self.m_RowHeight) - 1
    self.m_Selected = 0
    self.m_Scroll = 1
    self.m_Color = color

    bindKey("mouse_wheel_up", "down", bind(self.scroll, self))
    bindKey("mouse_wheel_down", "down", bind(self.scroll, self))
    addEventHandler("onClientClick", root, bind(self.onClick, self))
end

function GUIGridlist:scroll(key)
    local cx, cy = getCursorPosition()
    local cx = cx and cx * screenWidth or 0
    local cy = cy and cy * screenHeight or 0

    if cx >= self.m_AbsX and cx <= self.m_AbsX + self.m_Width and cy >= self.m_AbsY and cy <= self.m_AbsY + self.m_Height then
        local s = key == "mouse_wheel_up" and -1 or 1
        local scr = self.m_Scroll + s
        if s == -1 and scr >= 1 then
            self.m_Scroll = scr
        elseif s == 1 and self.m_Scroll + self.m_MaxRow <= #self.m_Table then
            self.m_Scroll = scr
        end
    end
end

function GUIGridlist:onClick(btn, state, cx, cy)
    if btn == "left" and state == "down" then
        if cx >= self.m_AbsX and cx <= self.m_AbsX + self.m_Width and cy >= self.m_AbsY and cy <= self.m_AbsY + self.m_Height then
            for i = self.m_Scroll, self.m_Scroll + self.m_MaxRow - 1 do
                if cx >= self.m_AbsX and cx <= self.m_AbsX + self.m_Width and cy >= self.m_AbsY + self.m_RowHeight * (1 + i - self.m_Scroll) and cy <= self.m_AbsY + self.m_RowHeight * (1 + i - self.m_Scroll) + self.m_RowHeight then
                    self.m_Selected = i
                    break
                else
                    self.m_Selected = 0
                end
            end
        end
    end
end

function GUIGridlist:drawThis()
    dxDrawRectangle(self.m_AbsX, self.m_AbsY, self.m_Width, self.m_Height, tocolor(29, 29, 29, 255))
    dxDrawRectangle(self.m_AbsX + 4, self.m_AbsY + 4, self.m_Width - 8, self.m_Height - 8, tocolor(29, 29, 29, 150))
    dxDrawRectangle(self.m_AbsX + 10, self.m_AbsY + 26, self.m_Width - 20, 1, self.m_Color)

    local cpos = { [1] = self.m_AbsX + 10 }

    for i, c in ipairs(self.m_Columns) do
        cpos[i + 1] = cpos[i] + c[2]
        dxDrawText(string.upper(c[1]), cpos[i], self.m_AbsY, cpos[i] + c[2], self.m_AbsY + self.m_RowHeight, self.m_Color, 1, self.m_Font, "left", "center", true)
    end

    for i = self.m_Scroll, self.m_Scroll + self.m_MaxRow - 1 do
        if self.m_Table[i] then
            if self.m_Selected == i then
                dxDrawRectangle(self.m_AbsX + 4, self.m_AbsY + self.m_RowHeight * (1 + i - self.m_Scroll), self.m_Width - 8, self.m_RowHeight, self.m_Color)
            end
            for c, t in ipairs(self.m_Table[i]) do
                local txt = t
                local color = {}

                if string.sub(txt, 1, 1) == "-" then
                    color[txt] = tocolor(255, 0, 0, 255)
                elseif string.sub(txt, 1, 1) == "+" then
                    color[txt] = tocolor(0, 255, 0, 255)
                else
                    color[txt] = tocolor(255, 255, 255, 255)
                end

                dxDrawText(txt, cpos[c], self.m_AbsY + self.m_RowHeight * (1 + i - self.m_Scroll), cpos[c + 1], self.m_AbsY + self.m_RowHeight * (2 + i - self.m_Scroll), color[txt], 1, self.m_Font, "left", "center", true)
            end
        else
            break
        end
    end

    if #self.m_Table > self.m_MaxRow then
        local y = self.m_AbsY + self.m_RowHeight
        local sy = self.m_MaxRow * self.m_RowHeight
        local y = y + 1
        local sy = sy - 2
        local y = y + (sy) / #self.m_Table * (self.m_Scroll - 1)
        local sy = (sy) / #self.m_Table * self.m_MaxRow
        dxDrawRectangle(self.m_AbsX + self.m_Width - 10 + 7, y, 2, sy, self.m_Color)
        local cx, cy = getCursorPosition()
        if cx and cy then
            local cx = screenWidth * cx
            local cy = screenHeight * cy
            if cx >= self.m_AbsX + self.m_Width - 10 + 1 and cx <= self.m_AbsX + self.m_Width and cy >= self.m_AbsY + self.m_RowHeight and cy <= self.m_AbsY + self.m_Height then
                if getKeyState("mouse1") then
                    if y > cy then
                        self:scroll("mouse_wheel_up")
                    elseif y + sy < cy then
                        self:scroll("mouse_wheel_down")
                    end
                end
            end
        end
    end
end

function GUIGridlist:getSelectedRow(row)
    if self.m_Selected > 0 then
        return self.m_Table[self.m_Selected][row]
    end
end
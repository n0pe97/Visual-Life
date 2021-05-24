GUIButton = inherit(GUIElement)

GUIButton.HOVERCOLOR = {
    [-16745216] = { 0, 90, 0, 255 },
    [-12245088] = { 54, 30, 128, 255 },
    [-15790321] = { 5, 5, 5, 255 },
}

local BUTTON_BORDER_MARGIN = 5

function GUIButton:constructor(posX, posY, width, height, text, color, parent)
    GUIElement.constructor(self, posX, posY, width, height, parent)

    -- Color
    self.m_NormalColor = tocolor(255, 255, 255, 255)
    self.m_HoverColor = tocolor(255, 255, 255, 255)
    self.m_BackgroundColor = color
    self.m_BackgroundNormalColor = color
    self.m_Color = self.m_NormalColor

    if GUIButton.HOVERCOLOR[color] then
        self.m_BackgroundHoverColor = tocolor(GUIButton.HOVERCOLOR[color][1], GUIButton.HOVERCOLOR[color][2], GUIButton.HOVERCOLOR[color][3], GUIButton.HOVERCOLOR[color][4])
    end

    -- States
    self.m_Text = text
    self.m_Enabled = true
end

function GUIButton:drawThis()
    dxDrawRectangle(self.m_AbsX, self.m_AbsY, self.m_Width, self.m_Height, self.m_BackgroundColor)
    dxDrawText(string.upper(self:getText()), self.m_AbsX + BUTTON_BORDER_MARGIN, self.m_AbsY + BUTTON_BORDER_MARGIN,
        self.m_AbsX + self.m_Width - BUTTON_BORDER_MARGIN, self.m_AbsY + self.m_Height - BUTTON_BORDER_MARGIN, self.m_Color, 1, FONT_ARIAL, "center", "center", false, true)
end

function GUIButton:performChecks(...)
    if self.m_Enabled then
        GUIElement.performChecks(self, ...)
    end
end

function GUIButton:onInternalHover()
    if self.m_Enabled then
        self.m_Color = self.m_HoverColor
        self.m_BackgroundColor = self.m_BackgroundHoverColor
    end
end

function GUIButton:onInternalUnhover()
    if self.m_Enabled then
        self.m_Color = self.m_NormalColor
        self.m_BackgroundColor = self.m_BackgroundNormalColor
    end
end

function GUIButton:getText()
    return self.m_Text
end

function GUIButton:setEnabled(state)
    if state then

    else
    end
    self.m_Enabled = state
end

function GUIButton:isEnabled()
    return self.m_Enabled
end
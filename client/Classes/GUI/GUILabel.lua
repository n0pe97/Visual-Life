GUILabel = inherit(GUIElement)

function GUILabel:constructor(posX, posY, width, height, text, color, size, parent, alignX, alignY)
    GUIElement.constructor(self, posX, posY, width, height, parent)
    self.m_Text = text
    self.m_AlignX = alignX or "left"
    self.m_AlignY = alignY or "center"
    self.m_Rotatiton = 0
    self.m_Color = color or Settings.Color.White
    self.m_Size = size * 10 or 10
    self.m_Font = dxCreateFont("res/Fonts/nunito-regular.ttf", self.m_Size)
end

function GUILabel:drawThis()
    dxDrawText(self.m_Text, self.m_AbsX, self.m_AbsY, self.m_AbsX + self.m_Width, self.m_AbsY + self.m_Height, self.m_Color, 1, self.m_Font, self.m_AlignX, self.m_AlignY)
end
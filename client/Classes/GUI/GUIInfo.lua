--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 25.11.2019
--|**********************************************************************

GUIInfo = inherit(GUIElement)

function GUIInfo:constructor(posX, posY, width, height, infoText, infoColor, text, textColor, parent)
    GUIElement.constructor(self, posX, posY, width, height, parent)

    self.m_InfoText = infoText
    self.m_InfoColor = infoColor
    self.m_Text = text
    self.m_TextColor = textColor
    self.m_Font = dxCreateFont("res/Fonts/nunito-semibold.ttf", 12)
end

function GUIInfo:destructor()
end

function GUIInfo:drawThis()
    dxDrawRectangle(self.m_AbsX, self.m_AbsY, self.m_Width, self.m_Height, tocolor(29, 29, 29, 255))
    dxDrawText(string.upper(self.m_InfoText), self.m_AbsX, self.m_AbsY - 25, self.m_Width, self.m_Height, self.m_InfoColor, 1, self.m_Font)
    dxDrawText(self.m_Text, self.m_AbsX + 5, self.m_AbsY + 5, self.m_AbsX + self.m_Width, self.m_Height, self.m_TextColor, 1, self.m_Font, "center", "top", false, true)
end
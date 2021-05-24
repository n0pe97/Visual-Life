--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 24.11.2019
--|**********************************************************************

GUIRadioButton = inherit(GUIElement)

function GUIRadioButton:constructor(posX, posY, type, parent)
    GUIElement.constructor(self, posX, posY, 18, 18, parent)

    self.m_Type = type
    self.m_Clicked = false
end

function GUIRadioButton:destructor()
end

function GUIRadioButton:drawThis()
    dxDrawImage(self.m_AbsX, self.m_AbsY, self.m_Width, self.m_Height, "res/Images/GUI/RadioButton/unselected" .. self.m_Type .. ".png")

    if self.m_Clicked then
        dxDrawImage(self.m_AbsX, self.m_AbsY, self.m_Width, self.m_Height, "res/Images/GUI/RadioButton/selected" .. self.m_Type .. ".png")
    end
end

function GUIRadioButton:onInternalLeftClick()
    self.m_Clicked = not self.m_Clicked
end

function GUIRadioButton:getState()
    return self.m_Clicked
end
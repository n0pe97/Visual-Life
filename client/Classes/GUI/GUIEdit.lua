GUIEdit = inherit(GUIElement)

local GUI_EDITBOX_BORDER_MARGIN = 6

function GUIEdit:constructor(posX, posY, width, height, parent)
    -- Call constructors
    GUIElement.constructor(self, posX, posY, width, height, parent)

    -- Variables
    self.m_MaxLength = math.huge
    self.m_MaxValue = math.huge
    self.m_Caret = 0
    self.m_DrawCursor = false
    self.m_Text = ""
    self.m_Font = dxCreateFont("res/Fonts/nunito-light.ttf", 11)
end

function GUIEdit:destructor()
end

function GUIEdit:drawThis()
    dxDrawRectangle(self.m_AbsX, self.m_AbsY, self.m_Width, self.m_Height, tocolor(29, 29, 29, 255))


    local text = self:getDrawnText()
    local aliginX = "left"
    local textBeforeCursor = utfSub(text, 0, self.m_Caret)

    if dxGetTextWidth(textBeforeCursor, 1, self.m_Font) >= self.m_Width - 2 * GUI_EDITBOX_BORDER_MARGIN - 2 then
        aliginX = "right"
    end

    dxDrawText(text, self.m_AbsX + GUI_EDITBOX_BORDER_MARGIN, self.m_AbsY,
        self.m_AbsX + self.m_Width - 2 * GUI_EDITBOX_BORDER_MARGIN, self.m_AbsY + self.m_Height,
        tocolor(116, 116, 116, 255), 1, self.m_Font, aliginX, "center", true, false, false, false)

    if self.m_DrawCursor then
        local textBeforeCursor = utfSub(text, 0, self.m_Caret)
        if dxGetTextWidth(textBeforeCursor, 1, self.m_Font) < self.m_Width - 2 * GUI_EDITBOX_BORDER_MARGIN then
            if getTickCount() % 1000 <= 500 then
                dxDrawRectangle(self.m_AbsX + GUI_EDITBOX_BORDER_MARGIN + dxGetTextWidth(textBeforeCursor, 1, self.m_Font), self.m_AbsY + 6, 2, self.m_Height - 12, tocolor(116, 116, 116, 255))
            end
        end
    end
end

function GUIEdit:getDrawnText()
    local text = #self.m_Text > 0 and self:getText() or self.m_Caption or ""
    if text ~= self.m_Caption and self.m_MaskChar then
        text = self.m_MaskChar:rep(#text)
    end
    return text
end

function GUIEdit:onInternalEditInput(caret)
    self.m_Caret = caret

    if self.onChange then
        self.onChange(self:getDrawnText())
    end
end

function GUIEdit:onInternalLeftClick(absoluteX, absoluteY)
    local posX, posY = self:getPosition(true)
    local relativeX, relativeY = absoluteX - posX, absoluteY - posY
    local index = self:getIndexFromPixel(relativeX, relativeY)
    self:setCaretPosition(index)

    GUIInput.setFocus(self, index)
end

function GUIEdit:getText()
    return self.m_Text
end

function GUIEdit:setText(str)
    self.m_Text = str
end

function GUIEdit:onInternalFocus()
    self:setCursorDrawingEnabled(true)
end

function GUIEdit:onInternalLooseFocus()
    self:setCursorDrawingEnabled(false)
end

function GUIEdit:setCaretPosition(pos)
    self.m_Caret = math.min(math.max(pos, 0), utfLen(self:getDrawnText()) + 1)
    return self
end

function GUIEdit:getCaretPosition(pos)
    return self.m_Caret
end

function GUIEdit:setCaption(caption)
    assert(type(caption) == "string", "Bad argument @ GUIEdit.setCaption")

    self.m_Caption = caption
    return self
end

function GUIEdit:setMasked(maskChar)
    self.m_MaskChar = maskChar or "*"
    return self
end

function GUIEdit:setCursorDrawingEnabled(state)
    self.m_DrawCursor = state
    return self
end

function GUIEdit:getIndexFromPixel(posX, posY)
    local text = self:getDrawnText()
    local size = 1
    local font = FONT_ARIAL

    for i = 0, utfLen(text) do
        local extent = dxGetTextWidth(utfSub(text, 0, i), size, font)
        if extent > posX then
            return i - 1
        end
    end
    return utfLen(text)
end

function GUIEdit:setNumeric(numeric, integerOnly)
    self.m_Numeric = numeric
    self.m_IntegerOnly = integerOnly or false
    return self
end

function GUIEdit:setMaxLength(length)
    self.m_MaxLength = length
    return self
end

function GUIEdit:setMaxValue(value)
    self.m_MaxValue = value
    return self
end

function GUIEdit:isNumeric()
    return self.m_Numeric
end

function GUIEdit:isIntegerOnly()
    return self.m_IntegerOnly
end

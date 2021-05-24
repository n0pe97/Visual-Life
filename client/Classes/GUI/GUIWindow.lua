GUIWindow = inherit(GUIElement)
inherit(GUIMoveable, GUIWindow)

local CLOSE_BTN_PADDING = 15
local CLOSE_BTN_SIZE = { 18, 18 }

-- ToDo: Create Font class
FONT_ARIAL = dxCreateFont("res/Fonts/arial.ttf", 10)

function GUIWindow:constructor(posX, posY, width, height, title, color, parent, hasCloseBtn, isMoveable)
    assert(type(posX) == "number" and type(posY) == "number" and type(width) == "number" and type(height) == "number" and type(title) == "string", "Bad arguments @ GUIWindow:constructor")
    GUIElement.constructor(self, posX, posY, width, height, parent)
    GUIRenderer:getSingleton():addRef(self)

    self.m_Title = title
    self.m_HeaderColor = color or Settings.Color.Visual
    self.m_BodyColor = tocolor(23, 23, 23, 255)

    self.m_Body = GUIRectangle:new(0, 35, self.m_Width, self.m_Height - 35, self.m_BodyColor, self)
    self.m_TitleBar = GUIRectangle:new(0, 0, self.m_Width, 50, self.m_HeaderColor, self)
    self.m_LabelText = GUILabel:new(25, 10, self.m_Width, 30, self.m_Title, Settings.Color.White, 1.5, self)

    localPlayer:setData("clicked", true)
    showCursor(true)

    -- CLOSE BUTTON
    self.m_HasCloseBtn = hasCloseBtn
    if hasCloseBtn then
        -- Create close button
        self.m_CloseBtn = GUIImage:new("res/Images/GUI/close_btn.png", self.m_Width - CLOSE_BTN_PADDING - CLOSE_BTN_SIZE[1], 15, CLOSE_BTN_SIZE[1], CLOSE_BTN_SIZE[2], self)

        -- Define hover function
        function self.m_CloseBtn.onHover()
            self.m_CloseBtn:setPath("res/Images/GUI/close_btn_hover.png")
        end

        function self.m_CloseBtn.onUnhover()
            self.m_CloseBtn:setPath("res/Images/GUI/close_btn.png")
        end

        function self.m_CloseBtn.onLeftClickDown()
            self:close()
        end
    end


    -- MOVING STUFF
    self:setMoveable(isMoveable)
    self.m_TitleBar.onLeftClickDown = function(me, curX, curY)
        if self.m_HasCloseBtn then
            local offsetX, offsetY = self.m_AbsX + self.m_Width - CLOSE_BTN_PADDING - CLOSE_BTN_SIZE[1], self.m_AbsY + 15
            local insideOfClose = (curX >= offsetX and curX < offsetX + CLOSE_BTN_SIZE[1] and curY >= offsetY and curY < offsetY + CLOSE_BTN_SIZE[2])
            if insideOfClose then
                return
            end
        end

        -- Normal checks
        if (GUIWindowFocusManager:getSingleton():getCurrentWindow() == self or GUIWindowFocusManager:getSingleton():getCurrentWindow() == nil) and not GUIMoveable.ms_CurrentlyMoving then
            if self:getMoveable() then
                GUIWindowFocusManager:getSingleton():setCurrentFocus(self)
                self:startMoving()
            end
        end
    end

    self.m_TitleBar.onLeftClick = function()
        if GUIMoveable.ms_CurrentlyMoving and GUIWindowFocusManager:getSingleton():getCurrentWindow() == self then
            if self:getMoveable() then
                GUIWindowFocusManager:getSingleton():setCurrentFocus(nil)
                self:stopMoving()
            end
        end
    end
end

function GUIWindow:destructor()
    GUIElement.destructor(self)
end

function GUIWindow:close()
    showCursor(false)
    Timer(function() localPlayer:setData("clicked", false) end, 500, 1)
    GUIInput.checkFocus(self)
    delete(self)
end
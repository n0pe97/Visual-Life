--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 22.11.2019
--|**********************************************************************

LoginGUI = inherit(Object)

addEvent("VL:CLIENT:checkAutologin", true)
addEvent("VL:CLIENT:closeLogin", true)

function LoginGUI:constructor()
    self.m_Font = dxCreateFont("res/Fonts/nunito-semibold.ttf", 10)

    addEventHandler("VL:CLIENT:checkAutologin", root, bind(self.checkAutologin, self))
    addEventHandler("VL:CLIENT:closeLogin", root, bind(self.closeLogin, self))
end

function LoginGUI:openLogin()
    local width, height = 400, 350
    local x, y = screenWidth / 2 - width / 2, screenHeight / 2 - height / 2

    self.m_LoginWindow = GUIWindow:new(x, y, width, height, loc("LOGIN_WINDOW_TEXT"), Settings.Color.Visual, false, false, false)

    GUILabel:new(25, 60, 130, 30, string.upper(loc("LOGIN_WINDOW_USERNAME")), Settings.Color.White, 1.09, self.m_LoginWindow)
    self.m_UsernameEdit = GUIEdit:new(25, 95, 350, 35, self.m_LoginWindow)
    self.m_UsernameEdit:setText(localPlayer:getName())

    GUILabel:new(25, 140, 130, 30, string.upper(loc("LOGIN_WINDOW_PASSWORD")), Settings.Color.White, 1.09, self.m_LoginWindow)
    self.m_PasswordEdit = GUIEdit:new(25, 175, 350, 35, self.m_LoginWindow)
    self.m_PasswordEdit:setMasked("*")

    self.m_Autologin = GUIRadioButton:new(25, 225, 1, self.m_LoginWindow)
    GUILabel:new(50, 218, 130, 30, string.upper(loc("LOGIN_WINDOW_AUTOLOGIN")), Settings.Color.White, 1.09, self.m_LoginWindow)

    self.m_LoginButton = GUIButton:new(width - 300, 280, 200, 40, loc("LOGIN_WINDOW_BUTTON"), Settings.Color.Visual, self.m_LoginWindow)
    self.m_LoginButton.onLeftClick = bind(self.triggerLogin, self)
end

function LoginGUI:triggerLogin()
    if #self.m_PasswordEdit:getText() >= 4 then
        triggerServerEvent("VL:SERVER:checkPassword", localPlayer, hash("sha512", self.m_PasswordEdit:getText()), self.m_Autologin:getState())
    else
        localPlayer:sendMessage("LOGIN_WINDOW_BUTTON_ERROR", 120, 0, 0)
    end
end

function LoginGUI:checkAutologin()
    if config:get("autologin") == "1" then self:triggerAutoLogin() else self:openLogin() end
end

function LoginGUI:triggerAutoLogin()
    triggerServerEvent("VL:SERVER:checkPassword", localPlayer, config:get("password"))
end

function LoginGUI:closeLogin()
    if self.m_LoginWindow then self.m_LoginWindow:close() end
end
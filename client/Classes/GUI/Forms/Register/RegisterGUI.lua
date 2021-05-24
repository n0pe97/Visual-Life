--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 22.11.2019
--|**********************************************************************

RegisterGUI = inherit(Object)

addEvent("VL:CLIENT:openRegister", true)
addEvent("VL:CLIENT:closeRegister", true)

function RegisterGUI:constructor()
    self.m_Font = dxCreateFont("res/Fonts/nunito-semibold.ttf", 10)

    addEventHandler("VL:CLIENT:openRegister", root, bind(self.openRegister, self))
    addEventHandler("VL:CLIENT:closeRegister", root, bind(self.closeRegister, self))
end

function RegisterGUI:openRegister()
    local width, height = 800, 450
    local x, y = screenWidth / 2 - width / 2, screenHeight / 2 - height / 2

    self.m_RegisterWindow = GUIWindow:new(x, y, width, height, loc("REGISTER_WINDOW_TEXT"), Settings.Color.Visual, false, false, false)

    GUILabel:new(25, 60, 130, 30, string.upper(loc("REGISTER_WINDOW_USERNAME")), Settings.Color.White, 1.09, self.m_RegisterWindow)
    self.m_UsernameEdit = GUIEdit:new(25, 95, 350, 35, self.m_RegisterWindow)
    self.m_UsernameEdit:setText(localPlayer:getName())

    GUILabel:new(25, 140, 130, 30, string.upper(loc("REGISTER_WINDOW_PASSWORD")), Settings.Color.White, 1.09, self.m_RegisterWindow)
    self.m_PasswordEdit = GUIEdit:new(25, 175, 350, 35, self.m_RegisterWindow)
    self.m_PasswordEdit:setMasked("*")

    GUILabel:new(25, 220, 130, 30, string.upper(loc("REGISTER_WINDOW_PASSWORD_REPEAT")), Settings.Color.White, 1.09, self.m_RegisterWindow)
    self.m_PasswordEditRepeat = GUIEdit:new(25, 255, 350, 35, self.m_RegisterWindow)
    self.m_PasswordEditRepeat:setMasked("*")

    GUILabel:new(25, 300, 130, 30, string.upper(loc("REGISTER_WINDOW_LANGUAGE")), Settings.Color.White, 1.09, self.m_RegisterWindow)

    self.m_German = GUIRadioButton:new(25, 335, 0, self.m_RegisterWindow)
    GUILabel:new(50, 328, 130, 30, string.upper(loc("REGISTER_WINDOW_LANGUAGE_GERMAN")), Settings.Color.White, 1.09, self.m_RegisterWindow)

    self.m_English = GUIRadioButton:new(130, 335, 0, self.m_RegisterWindow)
    GUILabel:new(155, 328, 130, 30, string.upper(loc("REGISTER_WINDOW_LANGUAGE_ENGLISH")), Settings.Color.White, 1.09, self.m_RegisterWindow)

    GUIInfo:new(x - 100, 95, 310, 250, "Information", Settings.Color.Visual, "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.", Settings.Color.White, self.m_RegisterWindow)

    self.m_RegisterButton = GUIButton:new(x - 250, 380, 200, 40, loc("REGISTER_WINDOW_BUTTON"), Settings.Color.Visual, self.m_RegisterWindow)
    self.m_RegisterButton.onLeftClick = bind(self.triggerRegister, self)
end

function RegisterGUI:triggerRegister()
    if #self.m_PasswordEdit:getText() >= 4 then
        if #self.m_PasswordEditRepeat:getText() >= 4 then
            if self.m_PasswordEdit:getText() == self.m_PasswordEditRepeat:getText() then
                if self.m_German:getState() ~= self.m_English:getState() then
                    if self.m_German:getState() then
                        self.m_Language = "DE"
                    else
                        self.m_Language = "EN"
                    end
                    triggerServerEvent("VL:SERVER:registerAccount", localPlayer, self.m_PasswordEdit:getText(), self.m_Language)
                else
                    localPlayer:sendNotification("REGISTER_WINDOW_LANGUAGE_ERROR", "error")
                end
            else
                localPlayer:sendNotification("REGISTER_WINDOW_PASSWORD_MATCHING_ERROR", "error")
            end
        else
            localPlayer:sendNotification("REGISTER_WINDOW_PASSWORD_ERROR", "error")
        end
    else
        localPlayer:sendNotification("REGISTER_WINDOW_PASSWORD_ERROR", "error")
    end
end

function RegisterGUI:closeRegister()
    self.m_RegisterWindow:close()
end
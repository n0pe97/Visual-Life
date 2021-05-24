--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 24.12.2019
--|**********************************************************************

DutyGUI = inherit(Object)

addEvent("VL:CLIENT:DutyGUI:show", true)

local width, height = 400 * (screenWidth / 1920), 300 * (screenHeight / 1080)
local x, y = screenWidth - width, screenHeight - height

function DutyGUI:constructor()
    self.m_ImagePath = {
        [1] = "res/Images/GUI/Faction/sfpd.png",
        [5] = "res/Images/GUI/Faction/vnews.png",
        [6] = "res/Images/GUI/Faction/fbi.png",
        [10] = "res/Images/GUI/Faction/emergency.png",
        [11] = "res/Images/GUI/Faction/mechanic.png",
    }

    addEventHandler("VL:CLIENT:DutyGUI:show", root, bind(self.show, self))
end

function DutyGUI:show()
    if not localPlayer:clicked() then
        self.m_Path = self.m_ImagePath[localPlayer:getData("faction")]

        self.m_Window = GUIWindow:new(x, y, width, height, "Duty", Settings.Color.Visual, false, true, true)

        GUIImage:new(self.m_Path, 35 * screenWidth / 1920, 60 * screenHeight / 1080, 128, 128, self.m_Window)
        GUILabel:new(220, 60, 150, 30, ("Fraktion: %s"):format(Settings.Faction.Names[localPlayer:getData("faction")]), Settings.Color.White, 1.4, self.m_Window)
        GUILabel:new(220, 80, 150, 30, ("Rang: %d"):format(localPlayer:getData("factionrank")), Settings.Color.White, 1.4, self.m_Window)

        self.m_Duty = GUIButton:new(25 * screenWidth / 1920, 220 * screenHeight / 1080, 160, 40, "Dienst beginnen", Settings.Color.Visual, self.m_Window)
        self.m_OffDuty = GUIButton:new(215 * screenWidth / 1920, 220 * screenHeight / 1080, 160, 40, "Dienst beenden", Settings.Color.Visual, self.m_Window)

        self.m_Duty.onLeftClickDown = bind(self.duty, self)
        self.m_OffDuty.onLeftClickDown = bind(self.offDuty, self)
    end
end

function DutyGUI:duty()
    triggerServerEvent("VL:SERVER:FactionManager:setDuty", localPlayer)
end

function DutyGUI:offDuty()
    triggerServerEvent("VL:SERVER:FactionManager:setOffDuty", localPlayer)
end
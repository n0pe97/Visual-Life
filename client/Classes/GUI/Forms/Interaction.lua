--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 21.12.2019
--|**********************************************************************

Interaction = inherit(Object)

function Interaction:constructor()
    addEventHandler("onClientClick", root, bind(self.onClick, self))
end

function Interaction:onClick(btn, state, _, _, _, _, _, clickedElement)
    if btn == "left" and state == "down" then
        if clickedElement and isElement(clickedElement) then
            if clickedElement:getType() == "player" then
                if clickedElement ~= localPlayer then
                    if (clickedElement:getPosition() - localPlayer:getPosition()):getLength() < 7 then
                        self:show(clickedElement)
                    end
                end
            end
        end
    end
end

function Interaction:show(player)
    if not localPlayer:clicked() then
        if Settings.Faction.Staat[localPlayer:getData("faction")] and localPlayer:isDuty() then
            local width, height = 445 * (screenWidth / 1920), 165 * (screenHeight / 1080)
            local x, y = screenWidth / 2 - width / 2, screenHeight / 2 - height / 2

            self.m_ClickedPlayer = player

            self.m_Window = GUIWindow:new(x, y, width, height, "Interaction mit " .. player:getName(), Settings.Color.Visual, false, true, true)

            self.m_Grab = GUIButton:new(25 * screenWidth / 1920, 60 * screenHeight / 1080, 125 * screenWidth / 1920, 40 * screenHeight / 1080, "Fesseln", Settings.Color.Visual, self.m_Window)
            self.m_Ungrab = GUIButton:new(25 * screenWidth / 1920, 110 * screenHeight / 1080, 125 * screenWidth / 1920, 40 * screenHeight / 1080, "Entfesseln", Settings.Color.Visual, self.m_Window)
            self.m_Search = GUIButton:new(160 * screenWidth / 1920, 60 * screenHeight / 1080, 125 * screenWidth / 1920, 40 * screenHeight / 1080, "Durchsuchen", Settings.Color.Visual, self.m_Window)
            self.m_License = GUIButton:new(160 * screenWidth / 1920, 110 * screenHeight / 1080, 125 * screenWidth / 1920, 40 * screenHeight / 1080, "Lizenzen", Settings.Color.Visual, self.m_Window)
            self.m_Trade = GUIButton:new(295 * screenWidth / 1920, 60 * screenHeight / 1080, 125 * screenWidth / 1920, 40 * screenHeight / 1080, "Handeln", Settings.Color.Visual, self.m_Window)
            self.m_Close = GUIButton:new(295 * screenWidth / 1920, 110 * screenHeight / 1080, 125 * screenWidth / 1920, 40 * screenHeight / 1080, "Schließen", Settings.Color.Visual, self.m_Window)

            self.m_Grab.onLeftClickDown = bind(self.grab, self)
            self.m_Close.onLeftClickDown = bind(self.close, self)
        else
            local width, height = 300 * (screenWidth / 1920), 165 * (screenHeight / 1080)
            local x, y = screenWidth / 2 - width / 2, screenHeight / 2 - height / 2

            self.m_Window = GUIWindow:new(x, y, width, height, loc("INTERACTION_WITH"):format(player:getName()), Settings.Color.Visual, false, true, true)

            self.m_License = GUIButton:new(25 * screenWidth / 1920, 60 * screenHeight / 1080, 250 * screenWidth / 1920, 40 * screenHeight / 1080, "Lizenzen", Settings.Color.Visual, self.m_Window)
            self.m_Trade = GUIButton:new(25 * screenWidth / 1920, 110 * screenHeight / 1080, 250 * screenWidth / 1920, 40 * screenHeight / 1080, "Handeln", Settings.Color.Visual, self.m_Window)
        end
    end
end

function Interaction:grab()
    triggerServerEvent("VL:SERVER:SAllround:grab", localPlayer, self.m_ClickedPlayer)
end

function Interaction:ungrab()
    triggerServerEvent("VL:SERVER:SAllround:ungrab", localPlayer, localPlayer)
end

function Interaction:close()
    self.m_Window:close()
end
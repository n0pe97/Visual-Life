--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 16.12.2019
--|**********************************************************************

VehiclerentGUI = inherit(Object)

addEvent("VL:CLIENT:VehiclerentGUI:show", true)

function VehiclerentGUI:constructor()
    self.m_WindowWidth = 600 * (screenWidth / 1920)
    self.m_WindowHeight = 350 * (screenHeight / 1080)
    self.m_WindowX, self.m_WindowY = screenWidth / 2 - self.m_WindowWidth / 2, screenHeight / 2 - self.m_WindowHeight / 2

    addEventHandler("VL:CLIENT:VehiclerentGUI:show", root, bind(self.show, self))
end

function VehiclerentGUI:show(row, tbl, amount)
    if not localPlayer:clicked() then
        self.m_RentWindow = GUIWindow:new(self.m_WindowX, self.m_WindowY, self.m_WindowWidth, self.m_WindowHeight, loc("VEHICLERENT_HEADER"), Settings.Color.Visual, false, true, true)
        self.m_Grid = GUIGridlist:new(25 * screenWidth / 1920, 90 * screenHeight / 1080, self.m_WindowWidth - 50, self.m_WindowHeight - 160, Settings.Color.Visual, row, tbl, self.m_RentWindow)
        self.m_RentButton = GUIButton:new(25 * screenWidth / 1920, 295 * screenHeight / 1080, 250, 40, loc("VEHICLERENT_RENT"), Settings.Color.Visual, self.m_RentWindow)
        self.m_CloseButton = GUIButton:new(325 * screenWidth / 1920, 295 * screenHeight / 1080, 250, 40, loc("VEHICLERENT_CLOSE"), Settings.Color.Visual, self.m_RentWindow)
        GUILabel:new(25 * screenWidth / 1920, 60 * screenHeight / 1080, 250, 20, loc("VEHICLERENT_AVAILABLE_VEHICLES"):format(amount), Settings.Color.White, 1.2, self.m_RentWindow)

        self.m_RentButton.onLeftClickDown = bind(self.rent, self)
        self.m_CloseButton.onLeftClickDown = bind(self.close, self)
    end
end

function VehiclerentGUI:rent()
    if self.m_Grid:getSelectedRow(1) then
        triggerServerEvent("VL:SERVER:Vehiclerent:rent", localPlayer, tonumber(self.m_Grid:getSelectedRow(1)), tonumber(self.m_Grid:getSelectedRow(3)))
        self:close()
    else
        localPlayer:sendNotification("VEHICLERENT_CHOOSE_ERROR", "error")
    end
end

function VehiclerentGUI:close()
    self.m_RentWindow:close()
end
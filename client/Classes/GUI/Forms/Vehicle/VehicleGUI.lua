--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 10.12.2019
--|**********************************************************************

VehicleGUI = inherit(Object)

addEvent("VL:CLIENT:VehicleGUI", true)

function VehicleGUI:constructor()
    addEventHandler("VL:CLIENT:VehicleGUI", root, bind(self.show, self))
end

function VehicleGUI:show(vehicle)
    if not localPlayer:clicked() then
        local width, height = 400, 240
        local x, y = screenWidth / 2 - width / 2, screenHeight / 2 - height / 2

        if vehicle and isElement(vehicle) then self.m_Vehicle = vehicle end

        self.m_VehicleWindow = GUIWindow:new(x, y, width, height, loc("VEHICLEMENUE_HEADER"), Settings.Color.Visual, false, true, true)

        self.m_LockedButton = GUIButton:new(25, 80, 150, 50, loc("VEHICLEMENUE_OPEN_CLOSE"), Settings.Color.Visual, self.m_VehicleWindow)
        self.m_ParkButton = GUIButton:new(225, 80, 150, 50, loc("VEHICLEMENUE_PARK"), Settings.Color.Visual, self.m_VehicleWindow)
        self.m_BrakeButton = GUIButton:new(25, 155, 150, 50, loc("VEHICLEMENUE_BRAKE"), Settings.Color.Visual, self.m_VehicleWindow)
        self.m_RespawnButton = GUIButton:new(225, 155, 150, 50, loc("VEHICLEMENUE_RESPAWN"), Settings.Color.Visual, self.m_VehicleWindow)

        self.m_LockedButton.onLeftClickDown = bind(self.setVehicleLockedState, self)
        self.m_ParkButton.onLeftClickDown = bind(self.parkVehicle, self)
        self.m_BrakeButton.onLeftClickDown = bind(self.setVehicleBrakeState, self)
        self.m_RespawnButton.onLeftClickDown = bind(self.respawnVehicle, self)
    end
end

function VehicleGUI:setVehicleLockedState()
    triggerServerEvent("VL:SERVER:VehicleLockedState", root, self.m_Vehicle)
end

function VehicleGUI:parkVehicle()
    triggerServerEvent("VL:SERVER:parkVehicle", root, self.m_Vehicle)
end

function VehicleGUI:setVehicleBrakeState()
    triggerServerEvent("VL:SERVER:VehicleBrakeState", root, self.m_Vehicle)
end

function VehicleGUI:respawnVehicle()
    triggerServerEvent("VL:SERVER:VehicleRespawn", root, self.m_Vehicle)
end

function VehicleGUI:hide()
    self.m_VehicleWindow:close()
end
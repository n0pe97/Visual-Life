--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 27.11.2019
--|***********************************************************************

CarhouseGUI = inherit(Object)

addEvent("VL:CLIENT:openCarhouseWindow", true)
addEvent("VL:CLIENT:closeCarhouseWindow", true)

function CarhouseGUI:constructor()
    self.m_Font = dxCreateFont("res/Fonts/nunito-regular.ttf", 10)
    self.m_LicenseNames = {
        ["Automobile"] = "carlicense",
        ["Plane"] = "planelicense",
        ["Bike"] = "bikelicense",
        ["Helicopter"] = "helicopterlicense",
        ["Boat"] = "boatlicense",
        ["Quad"] = "bikelicense",
    }

    addEventHandler("VL:CLIENT:openCarhouseWindow", root, bind(self.openCarhouseWindow, self))
    addEventHandler("VL:CLIENT:closeCarhouseWindow", root, bind(self.closeCarhouseWindow, self))
end

function CarhouseGUI:openCarhouseWindow(marker, id, price, license)
    if id then
        if not localPlayer:clicked() then
            local width, height = 800, 400
            local x, y = screenWidth / 2 - width / 2, screenHeight / 2 - height / 2

            self.m_CorrectLicenseNames = {
                ["carlicense"] = loc("VEHICLE_CARHOUSE_CAR_LICENSE"),
                ["planelicense"] = loc("VEHICLE_CARHOUSE_PLANE_LICENSE"),
                ["bikelicense"] = loc("VEHICLE_CARHOUSE_BIKE_LICENSE"),
                ["helicopterlicense"] = loc("VEHICLE_CARHOUSE_HELICOPTER_LICENSE"),
                ["boatlicense"] = loc("VEHICLE_CARHOUSE_BOAT_LICENSE"),
            }

            self.m_ChoosenMarker = marker
            self.m_ChoosenVehicleID = id
            self.m_ChoosenVehiclePrice = price
            self.m_ChoosenVehicleLicense = self.m_LicenseNames[license]

            self.m_CarhouseWindow = GUIWindow:new(x, y, width, height, loc("VEHICLE_CARHOUSE_TEXT"), Settings.Color.Visual, false, true, true)

            GUILabel:new(25, 60, 350, 30, loc("VEHICLE_CARHOUSE_INFORMATION"), Settings.Color.Visual, 1.2, self.m_CarhouseWindow)
            GUILabel:new(450, 60, 350, 30, loc("VEHICLE_CARHOUSE_VEHICLE_INFORMATION"), Settings.Color.Visual, 1.2, self.m_CarhouseWindow)

            GUIRectangle:new(25, 95, 380, 200, tocolor(29, 29, 29, 200), self.m_CarhouseWindow)

            GUIImage:new("res/Images/GUI/Carhouse/" .. id .. ".png", 40, 80, 350, 200, self.m_CarhouseWindow)
            GUIImage:new("res/Images/GUI/Carhouse/icons.png", 450, 100, 34, 187, self.m_CarhouseWindow)

            GUILabel:new(500, 93, 100, 30, getVehicleNameFromModel(self.m_ChoosenVehicleID), Settings.Color.White, 1.5, self.m_CarhouseWindow)
            GUILabel:new(500, 113, 100, 30, loc("VEHICLE_CARHOUSE_VEHICLE_NAME"), Settings.Color.Visual, 1.1, self.m_CarhouseWindow)

            GUILabel:new(500, 170, 100, 30, self.m_CorrectLicenseNames[self.m_ChoosenVehicleLicense], Settings.Color.White, 1.5, self.m_CarhouseWindow)
            GUILabel:new(500, 190, 100, 30, loc("VEHICLE_CARHOUSE_LICENSE"), Settings.Color.Visual, 1.1, self.m_CarhouseWindow)

            GUILabel:new(500, 247, 100, 30, comma_value(string.upper(self.m_ChoosenVehiclePrice)) .. "$", Settings.Color.White, 1.5, self.m_CarhouseWindow)
            GUILabel:new(500, 267, 100, 30, loc("VEHICLE_CARHOUSE_VEHICLE_PRICE"), Settings.Color.Visual, 1.1, self.m_CarhouseWindow)

            self.m_BuyVehicle = GUIButton:new(175, 330, 200, 40, loc("VEHICLE_CARHOUSE_BUY"), Settings.Color.Visual, self.m_CarhouseWindow)
            self.m_TestVehicle = GUIButton:new(425, 330, 200, 40, loc("VEHICLE_CARHOUSE_TEST"), Settings.Color.Visual, self.m_CarhouseWindow)

            self.m_BuyVehicle.onLeftClickDown = bind(self.buyVehicle, self)
            self.m_TestVehicle.onLeftClickDown = bind(self.testVehicle, self)
        end
    end
end

function CarhouseGUI:buyVehicle()
    triggerServerEvent("VL:SERVER:buyVehicle", localPlayer, self.m_ChoosenMarker, self.m_ChoosenVehicleID, self.m_ChoosenVehiclePrice, self.m_ChoosenVehicleLicense)
end

function CarhouseGUI:testVehicle()
    triggerServerEvent("VL:SERVER:testVehicle", localPlayer, self.m_ChoosenMarker, self.m_ChoosenVehicleID, self.m_ChoosenVehicleLicense)
end

function CarhouseGUI:closeCarhouseWindow()
    self.m_CarhouseWindow:close()
end
--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 24.12.2019
--|**********************************************************************

SpeedoGUI = inherit(Object)

function SpeedoGUI:constructor()
    self.m_Font = dxCreateFont("res/Fonts/nunito-italic.ttf", 50)
    self.m_Font1 = dxCreateFont("res/Fonts/nunito-italic.ttf", 10.9)
    self._EngineColor = tocolor(255, 255, 255, 255)
    self.m_MaxSpeed = 270

    self.m_Draw = bind(self.draw, self)

    addEventHandler("onClientVehicleEnter", root, bind(self.onEnter, self))
    addEventHandler("onClientVehicleExit", root, bind(self.onExit, self))

    addCommandHandler("limit", bind(self.limit, self))
end

function SpeedoGUI:draw()
    local veh = localPlayer:getOccupiedVehicle()
    if veh and veh:getOccupant() == localPlayer then
        dxDrawImage(screenWidth - 300, screenHeight - 290, 256, 256, "res/Images/GUI/Vehicle/disc.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
        dxDrawText(math.floor(getElementSpeed(veh, "km/h")), screenWidth - 160, screenHeight - 137, screenWidth, screenHeight, tocolor(255, 255, 255, 255), 1, self.m_Font)
        dxDrawText("KM/H", screenWidth - 100, screenHeight - 150, screenWidth, screenHeight, tocolor(255, 255, 255, 255), 0.3, self.m_Font)
        dxDrawRectangle(screenWidth - 160, screenHeight - 40, 118, 5, tocolor(255, 255, 255, 100))
        dxDrawRectangle(screenWidth - 160, screenHeight - 40, 118 * self:getFuelState(veh) / 100, 5, tocolor(255, 255, 255, 255))

        if self:getFuelState(veh) < 20 then
            dxDrawImage(screenWidth - 160, screenHeight - 60, 16, 16, "res/Images/GUI/Vehicle/fuel.png", 0, 0, 0, tocolor(121, 37, 52, 255), false)
            self._EngineColor = tocolor(121, 37, 52, 255)
        else
            dxDrawImage(screenWidth - 160, screenHeight - 60, 16, 16, "res/Images/GUI/Vehicle/fuel.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
            self._EngineColor = tocolor(255, 255, 255, 255)
        end

        dxDrawText(self:getFuelState(veh) .. " %", screenWidth - 142, screenHeight - 60, screenWidth, screenHeight, self._EngineColor, 1, self.m_Font1)

        if veh:getEngineState() then
            dxDrawImage(screenWidth - 100, screenHeight - 60, 16, 16, "res/Images/GUI/Vehicle/engine_on.png")
        else
            dxDrawImage(screenWidth - 100, screenHeight - 60, 16, 16, "res/Images/GUI/Vehicle/engine_off.png")
        end

        local lights = veh:getOverrideLights()
        if lights then
            if lights ~= 2 then
                dxDrawImage(screenWidth - 80, screenHeight - 60, 16, 16, "res/Images/GUI/Vehicle/lights_off.png")
            else
                dxDrawImage(screenWidth - 80, screenHeight - 60, 16, 16, "res/Images/GUI/Vehicle/lights_on.png")
            end
        end

        if veh:isFrozen() then
            dxDrawImage(screenWidth - 60, screenHeight - 60, 16, 16, "res/Images/GUI/Vehicle/brake_on.png")
        else
            dxDrawImage(screenWidth - 60, screenHeight - 60, 16, 16, "res/Images/GUI/Vehicle/brake_off.png")
        end

        local speed = getElementSpeed(veh, "km/h")
        local npos = 0
        if (speed > 270) then
            npos = 270 + ((getTickCount() % 2) - 1)
        else
            npos = speed
        end
        dxDrawImage(screenWidth - 300, screenHeight - 290, 256, 256, "res/Images/GUI/Vehicle/needle.png", npos, 0, 0, tocolor(255, 255, 255, 255), false)
    else
        removeEventHandler("onClientRender", root, self.m_Draw)
    end
end

function SpeedoGUI:onEnter(player)
    if player == localPlayer then
        addEventHandler("onClientRender", root, self.m_Draw)
    end
end

function SpeedoGUI:onExit(player)
    if player == localPlayer then
        removeEventHandler("onClientRender", root, self.m_Draw)
    end
end

function SpeedoGUI:getFuelState(vehicle)
    if vehicle and isElement(vehicle) then
        local fuel = vehicle:getData("fuel")
        if not fuel then
            vehicle:setData("fuel", 100)
            fuel = 100
        end
        return tonumber(fuel)
    end
end

function SpeedoGUI:limit(cmd, tempo)
    if not localPlayer:getOccupiedVehicle() then return end

    if tempo and tonumber(tempo) > 0 and tonumber(tempo) <= self.m_MaxSpeed then
        local tempo = math.floor(tonumber(tempo))
        if isTimer(limitCheck) then killTimer(limitCheck) end
        if not isTimer(limitCheck) then
            limitCheck = setTimer(function()
                local vehicle = localPlayer:getOccupiedVehicle()
                if vehicle then
                    if vehicle:isOnGround() and vehicle:getOccupant() == localPlayer then
                        local speed = getElementSpeed(vehicle, "km/h")
                        if speed > tempo then
                            setElementSpeed(vehicle, "km/h", tempo)
                        end
                    end
                end
            end, 50, 0)

            localPlayer:sendNotification("Limit gesetzt auf: %d km/h! Du kannst es mit /limit zurücksetzen!", "info", tempo)
        end
    elseif not tempo and isTimer(limitCheck) then
        killTimer(limitCheck)
        localPlayer:sendNotification("Limit wurde entfernt!", "info")
    else
        localPlayer:sendNotification("Ungültiger Betrag!", "error")
    end
end
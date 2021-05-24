--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 01.01.2020
--|**********************************************************************

Mechanic = inherit(Object)

function Mechanic:constructor()
    self.m_TowedFactions = { [1] = true, [11] = true }
    self.m_Marker = createMarker(-2052.9052734375, 146.2431640625, 28.8359375 - 0.95, "cylinder", 4, 0, 0, 0, 200)

    addEventHandler("onMarkerHit", self.m_Marker, bind(self.towVehicle, self))
    addEventHandler("onTrailerAttach", root, bind(self.checkTow, self))
end

function Mechanic:towVehicle(element, dim)
    if element:getType() == "vehicle" and dim then
        if self.m_TowedFactions[element:getData("faction")] and element:getModel() == 525 then
            self.m_TowedVehicle = element:getTowedByVehicle()

            if self.m_TowedVehicle and self.m_TowedVehicle:getOwner() and not self.m_TowedVehicle:isFactionCar() then
                outputChatBox(getVehicleNameFromModel(self.m_TowedVehicle:getModel()))
            end
        end
    end
end

function Mechanic:checkTow(vehicle)
    if self.m_TowedFactions[vehicle:getData("faction")] and vehicle:getModel() == 525 then
        local towedVehicle = vehicle:getTowedByVehicle()
        if towedVehicle then
            if towedVehicle:isFrozen() then
                towedVehicle:setFrozen(false)
            end
        end
    end
end
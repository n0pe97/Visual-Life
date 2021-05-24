--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 19.12.2019
--|**********************************************************************

Gasstation = inherit(Object)

function Gasstation:constructor()
    self.m_Positions = {
        { -1677.9462890625, 410.98828125, 7.1796875 },
    }

    self:load()
end

function Gasstation:load()
    for key, value in pairs(self.m_Positions) do
        local marker = createMarker(value[1], value[2], value[3] - 0.95, "cylinder", 3.5, 15, 213, 219)

        addEventHandler("onMarkerHit", marker, bind(self.onHit, self))
    end
end

function Gasstation:onHit(element, dim)
    if element:getType() == "player" and dim then
        local vehicle = element:getOccupiedVehicle()

        if vehicle then
            outputChatBox(getVehicleNameFromModel(vehicle:getModel()))
        end
    end
end
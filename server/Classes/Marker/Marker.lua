--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 29.11.2019
--|**********************************************************************

Marker = inherit(Object)

function Marker:constructor()
    self.m_MarkerPositions = {
        --> markerX, markerY, markerZ, markerInt, markerDim, playerX, playerY, playerZ, playerRotZ, playerInt, playerDim
        ["CarschoolIn"] = { -2026.59375, -101.4580078125, 35.1640625, 0, 0, -2029.798339, -106.675910, 1035.171875, 180, 3, 0 },
        ["CarschoolOut"] = { -2026.83984375, -104.4384765625, 1035.171875, 3, 0, -2026.5634765625, -98.8056640625, 35.1640625, 360, 0, 0 },
        ["SFPDIn"] = { -1605.5078125, 710.8, 13.8671875, 0, 0, 246.5, 112.5, 1003.200012207, 360, 10, 0 },
        ["SFPDOut"] = { 246.3994140625, 107.7, 1003.21875, 10, 0, -1605.5537109375, 714.5576171875, 12.822162628174, 360, 0, 0 },
    }

    self:createStuff()
end

function Marker:createStuff()
    --> Portmarker
    for key, value in pairs(self.m_MarkerPositions) do
        local portMarker = createMarker(value[1], value[2], value[3] - 0.95, "cylinder", 1.4, 69, 39, 160, 255)
        portMarker:setInterior(value[4])
        portMarker:setDimension(value[5])

        addEventHandler("onMarkerHit", portMarker, function(element, dim)
            if element:getType() == "player" and dim then
                if not element:isInVehicle() then
                    element:doWarp(value[6], value[7], value[8], value[9], value[10], value[11])
                end
            end
        end)
    end

    --> Bankmarker
    for key, value in pairs(getElementsByType("object")) do
        if value:getModel() == 2942 then
            local bankMarker = createMarker(value:getPosition().x, value:getPosition().y, value:getPosition().z, "cylinder", 1.5, 0, 0, 0, 0)
            bankMarker:attach(value, 0, bankMarker:getRotation().z - 0.8)
            bankMarker:setDimension(value:getDimension())

            addEventHandler("onMarkerHit", bankMarker, function(element, dim)
                if element:getType() == "player" and dim then
                    if not element:isInVehicle() then
                        element:triggerEvent("VL:CLIENT:showBank", element)
                    end
                end
            end)
        end
    end
end
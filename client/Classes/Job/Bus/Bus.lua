--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 01.01.2020
--|**********************************************************************

Bus = inherit(Object)

addEvent("VL:CLIENT:BUS:showMarker", true)
addEvent("VL:CLIENT:BUS:hideMarker", true)

function Bus:constructor()
    self.m_MarkerCount = 0
    self.m_Positions = {
        [1] = {
            { -2007.822265625, 433.146484375, 35.148941040039, "Test" },
            { -2038.998046875, 322.7744140625, 35.147369384766, "Test 1" },
            { -2144.3369140625, 360.125, 35.30517578125, "Test 2" },
            { -2099.7783203125, 502.2421875, 35.149326324463, "Test 3" },
            { -2007.4013671875, 498.240234375, 35.073696136475, "Test 4" },
        },
        [2] = {
            {},
        }
    }

    addEventHandler("VL:CLIENT:BUS:showMarker", root, bind(self.showMarker, self))
    addEventHandler("VL:CLIENT:BUS:hideMarker", root, bind(self.hideMarker, self))
end

function Bus:showMarker(route)
    if isElement(self.m_Marker) then self.m_Marker:destroy() end
    if isElement(self.m_Blip) then self.m_Blip:destroy() end
    self.m_MarkerCount = self.m_MarkerCount + 1

    if route then self.m_Route = route end

    if self.m_MarkerCount <= #self.m_Positions[self.m_Route] then
        self.m_Marker = createMarker(self.m_Positions[self.m_Route][self.m_MarkerCount][1], self.m_Positions[self.m_Route][self.m_MarkerCount][2], self.m_Positions[self.m_Route][self.m_MarkerCount][3], "checkpoint", 4, 255, 255, 0, 200)
        self.m_Blip = createBlip(self.m_Positions[self.m_Route][self.m_MarkerCount][1], self.m_Positions[self.m_Route][self.m_MarkerCount][2], self.m_Positions[self.m_Route][self.m_MarkerCount][3], 0, 2, 255, 255, 0)

        addEventHandler("onClientMarkerHit", self.m_Marker, bind(self.onHit, self))

        localPlayer:sendNotification("Nächster Halt: %s", "info", self.m_Positions[self.m_Route][self.m_MarkerCount][4])
    else
        triggerServerEvent("VL:SERVER:Bus:reward", localPlayer)
        self.m_MarkerCount = 0
        self:showMarker()
    end
end

function Bus:hideMarker()
    if isElement(self.m_Marker) then self.m_Marker:destroy() end
    if isElement(self.m_Blip) then self.m_Blip:destroy() end
    if self.m_Route then self.m_Route = nil end
    self.m_MarkerCount = 0
end

function Bus:onHit(element, dim)
    if element == localPlayer and dim then
        self:showMarker()
    end
end
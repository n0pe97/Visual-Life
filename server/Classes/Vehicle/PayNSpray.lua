--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 13.12.2019
--|**********************************************************************

PayNSpray = inherit(Object)

function PayNSpray:constructor()
    self.m_GaragenID = {}
    self.m_AirportMarker = {}
    self.m_AirportVehicles = { ["Plane"] = true, ["Helicopter"] = true }
    self.m_NormalVehicles = { ["Automobile"] = true, ["Bike"] = true, ["BMX"] = true, ["Monster Truck"] = true, ["Quad"] = true }
    self.m_PayNSprayMarker = {
        { -1904.380859375, 285.783203125, 41.046875, 19 }, --> Wangcars SF
        { -2425.73046875, 1018.923828125, 50.397659301758, 27 }, --> Juniper Hollow SF
        { 1977.212890625, 2162.3916015625, 11.0703125, 36 }, --> Redsands East LV
        { -99.92578125, 1119.482421875, 19.74169921875, 41 }, --> Fort Carson BC
        { 2062.9296875, -1831.4599609375, 13.546875, 8 }, --> Idlewood LS
        { 720.11328125, -453.677734375, 16.3359375, 47 }, --> Dillimore RC
        { 1025.0185546875, -1023.099609375, 32.1015625, 11 }, --> Temple LS
        { 487.2333984375, -1742.3681640625, 11.128698348999, 12 }, --> Santa Maria Beach LS
        { -1160.236328125, -179.34375, 13.719036102295 - 0.95 }, --> Airport SF
    }

    self:createStuff()
end

function PayNSpray:createStuff()
    for key, value in pairs(self.m_PayNSprayMarker) do
        local marker = createMarker(value[1], value[2], value[3], "cylinder", 4, 0, 0, 0, 0)

        addEventHandler("onMarkerHit", marker, bind(self.onHit, self))

        if value[4] then
            setGarageOpen(value[4], true)
            self.m_GaragenID[marker] = value[4]
        else
            self.m_AirportMarker[marker] = true
        end
    end
end

function PayNSpray:onHit(element, dim)
    if element:getType() == "vehicle" and dim then
        local driver = element:getOccupant(0)
        if driver and isElement(driver) then
            if self.m_AirportMarker[source] then
                if self.m_AirportVehicles[element:getVehicleType()] then
                    self:checkRepair(element, source, true)
                else
                    driver:sendNotification("PAYNSPRAY_WRONG_GARAGE", "error")
                end
            else
                if self.m_NormalVehicles[element:getVehicleType()] then
                    self:checkRepair(element, source, false)
                else
                    driver:sendNotification("PAYNSPRAY_WRONG_GARAGE", "error")
                end
            end
        end
    end
end

function PayNSpray:checkRepair(vehicle, id, airport)
    if vehicle and isElement(vehicle) and id then
        local driver = vehicle:getOccupant(0)
        if driver and isElement(driver) then
            if vehicle:getHealth() < 1000 then
                local price = math.floor(math.abs(1000 - vehicle:getHealth()) * 0.25)
                if driver:getData("money") >= price then
                    vehicle:setFrozen(true)
                    if not airport then if isGarageOpen(self.m_GaragenID[id]) then setGarageOpen(self.m_GaragenID[id], false) end end
                    Timer(bind(self.doRepair, self), 2000 + 15 * math.abs(1000 - vehicle:getHealth()), 1, vehicle, driver, price, id, airport)
                else
                    driver:sendNotification("PAYNSPRAY_AMOUNT_ERROR", "error", price - driver:getData("money"))
                end
            else
                driver:sendNotification("PAYNSPRAY_ERROR", "error")
            end
        end
    end
end

function PayNSpray:doRepair(vehicle, driver, price, id, airport)
    if vehicle and isElement(vehicle) and id then
        if driver and isElement(driver) then
            if price then
                driver:takeCash(price, "PayNSpray")
                driver:sendNotification("PAYNSPRAY_SUCCES", "success", getVehicleNameFromModel(vehicle:getModel()), price)
                vehicle:fix()
                vehicle:setFrozen(false)
                playSoundFrontEnd(driver, 46)
                if not airport then if not isGarageOpen(self.m_GaragenID[id]) then setGarageOpen(self.m_GaragenID[id], true) end end
                Business:addCash(2, price, "Fahrzeugreparatur von %s (%s) für %d€", driver:getName(), getVehicleNameFromModel(vehicle:getModel()), price)
            end
        else
            vehicle:respawn()
            if not isGarageOpen(self.m_GaragenID[id]) then setGarageOpen(self.m_GaragenID[id], true) end
        end
    end
end
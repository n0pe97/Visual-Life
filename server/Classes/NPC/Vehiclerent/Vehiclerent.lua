--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 18.12.2019
--|**********************************************************************

Vehiclerent = inherit(Object)

Vehiclerent.Stock = 20
Vehiclerent.GridColumns = { { "ID", 50 }, { "Fahrzeugname", 250 }, { "Preis in €", 45 }, { "", 20 } }
Vehiclerent.RentVehicles = {
    { name = "Quadbike", id = 471, price = 200 },
    { name = "Faggio", id = 462, price = 150 },
    { name = "Bike", id = 509, price = 100 },
    { name = "Mountainbike", id = 510, price = 100 },
    { name = "BMX", id = 481, price = 100 },
}

addEvent("VL:SERVER:Vehiclerent:rent", true)

function Vehiclerent:constructor()
    self.m_RentVehicle = {}
    self.m_RentTimer = {}
    self.m_RentTime = 15

    addEventHandler("VL:SERVER:Vehiclerent:rent", root, bind(self.rent, self))
    addEventHandler("onPlayerQuit", root, bind(self.onQuit, self))
    addEventHandler("onVehicleExplode", root, bind(self.onExplode, self))

    addCommandHandler("rentvehicles", bind(self.checkVehicles, self))
end

function Vehiclerent:triggerRent(player)
    local tbl = {}

    for key, value in pairs(Vehiclerent.RentVehicles) do
        table.insert(tbl, { value.id, value.name, value.price, "€" })
    end

    player:triggerEvent("VL:CLIENT:VehiclerentGUI:show", player, Vehiclerent.GridColumns, tbl, Vehiclerent.Stock)
end

function Vehiclerent:rent(id, price)
    if id and price then
        if Vehiclerent.Stock > 0 then
            if not isElement(self.m_RentVehicle[client:getId()]) then
                if client:getData("money") >= price then
                    self.m_RentVehicle[client:getId()] = createVehicle(id, -2010.33984375, 473.6328125, 34.695323944092, 0, 0, 179.56042480469, client:getName())
                    self.m_RentVehicle[client:getId()]:setData("owner", client:getId())
                    self.m_RentVehicle[client:getId()]:setData("fuel", 100)
                    self.m_RentVehicle[client:getId()]:setData("rentVehicle", true)

                    client:warpIntoVehicle(self.m_RentVehicle[client:getId()])
                    client:takeCash(price, "Fahrzeugverleih")
                    client:sendNotification("VEHICLERENT_SUCCESS", "info", getVehicleNameFromModel(id), self.m_RentTime)
                    client:setQuestStep(2)

                    self.m_RentTimer[client:getId()] = Timer(bind(self.deleteVehicle, self), self.m_RentTime * 60000, 1, client)

                    Vehiclerent.Stock = Vehiclerent.Stock - 1
                else
                    client:sendNotification("VEHICLERENT_CASH_ERROR", "error", price - client:getData("money"))
                end
            else
                client:sendNotification("VEHICLERENT_RENT_ERROR", "error")
            end
        else
            client:sendNotification("VEHICLERENT_STOCK_ERROR", "error")
        end
    end
end

function Vehiclerent:deleteVehicle(player)
    if isElement(self.m_RentVehicle[player:getId()]) then self.m_RentVehicle[player:getId()]:destroy() end
    if isTimer(self.m_RentTimer[player:getId()]) then self.m_RentTimer[player:getId()]:destroy() end

    Vehiclerent.Stock = Vehiclerent.Stock + 1
end

function Vehiclerent:onQuit()
    self:deleteVehicle(source)
end

function Vehiclerent:onExplode()
    if source:getData("rentVehicle") then
        local owner = getPlayerFromName(getNameFromID(source:getOwner()))
        if owner then
            if isTimer(self.m_RentTimer[owner]) then self.m_RentTimer[owner]:destroy() end

            Vehiclerent.Stock = Vehiclerent.Stock + 1
        end
    end
end

function Vehiclerent:checkVehicles(player, cmd, state, amount)
    if not state then return end
    if state == "check" then
        if player:isAdmin(2) then
            player:sendNotification("Aktuelle Fahrzeuge zum ausleihen: (%d)", "info", Vehiclerent.Stock)
        end
    elseif state == "add" then
        if player:isAdmin(4) then
            if amount then
                local amount = tonumber(amount)
                if amount > 0 then
                    player:sendNotification("Aktuelle Fahrzeuge zum ausleihen: (%d+%d)", "info", Vehiclerent.Stock, amount)

                    Vehiclerent.Stock = Vehiclerent.Stock + amount
                end
            end
        end
    end
end
--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 18.12.2019
--|**********************************************************************

Drivingschool = inherit(Object)

addEvent("VL:SERVER:Drivingschool:check", true)
addEvent("VL:SERVER:Drivingschool:giveLicense", true)

function Drivingschool:constructor()
    self.m_Pickup = Pickup(-2033.22265625, -117.4755859375, 1035.171875, 3, 1239, 0)
    self.m_Pickup:setInterior(3)

    self.m_Vehicle = {}
    self.m_Ped = {}
    self.m_Mistakes = {}
    self.m_ExitTimer = {}
    self.m_SpeedTimer = {}
    self.m_Columns = { { "Lizenz", 200 }, { "Preis", 55 }, { "", 100 }, { "Vorhanden", 200 } }
    self.m_Reasons = { ["speed"] = "Geschwindigkeit überschritten!", ["damage"] = "Fahrzeug beschädigt!" }
    self.m_VehicleSpawns = {
        ["carlicense"] = { 561, -2034.779296875, -74.205078125, 34.985687255859, 270 },
        ["bikelicense"] = { 581, -2035.9267578125, -74.458984375, 34.770526885986, 270 },
        ["planelicense"] = { 593, -1653.712890625, -161.05078125, 14.607712745667, 315 },
        ["helicopterlicense"] = { 487, -1652.93359375, -160.0439453125, 14.325154304504, 315 },
        ["boatlicense"] = { 453, -1471.5546875, 686.9755859375, -0.35862317681313, 356 },
    }
    self.m_Licenses = {
        { license = "carlicense", price = 5000, name = "Autoführerschein" },
        { license = "bikelicense", price = 3500, name = "Motorradführerschein" },
        { license = "planelicense", price = 25000, name = "Flugschein" },
        { license = "helicopterlicense", price = 20000, name = "Helikopterschein" },
        { license = "boatlicense", price = 2000, name = "Bootschein" },
    }

    addEventHandler("onPickupHit", self.m_Pickup, bind(self.onHit, self))
    addEventHandler("VL:SERVER:Drivingschool:check", root, bind(self.check, self))
    addEventHandler("VL:SERVER:Drivingschool:giveLicense", root, bind(self.giveLicense, self))
end

function Drivingschool:onHit(player)
    player:triggerEvent("VL:CLIENT:DrivingschoolGUI:show", player, self.m_Columns, self:hasLicense(player))
end

function Drivingschool:giveLicense(license)
    if license == "carlicense" then
        client:setQuestStep(3)
    end

    client:setData(license, 1)
    client:sendNotification("DRIVINGSCHOOL_SUCCESS", "success")

    self:destroyStuff()
end

function Drivingschool:check(license, price)
    if license and price then
        local price = tonumber(price)
        if client:getData("money") >= price then
            if client:getData(self:getCorrectLicense(license)) == 0 then
                self:startLesson(client, self:getCorrectLicense(license))
                client:takeCash(price)
                Business:addCash(1, price / 5, "%s von %s für %d€", license, client:getName(), price)
            else
                client:sendNotification("DRIVINGSCHOOL_ALREADY_LICENSE", "error")
            end
        else
            client:sendNotification("DRIVINGSCHOOL_ERROR_MONEY", "error", price - client:getData("money"))
        end
    end
end

function Drivingschool:startLesson(player, license)
    if player and license then
        self.m_SpawnData = self.m_VehicleSpawns[license]

        local rndmDimension = math.random(1337, 13337)

        self.m_Vehicle[player] = createVehicle(self.m_SpawnData[1], self.m_SpawnData[2], self.m_SpawnData[3], self.m_SpawnData[4], 0, 0, self.m_SpawnData[5], player:getName())
        self.m_Ped[player] = Ped(17, 0, 0, 0)

        player:warpIntoVehicle(self.m_Vehicle[player])
        self.m_Ped[player]:warpIntoVehicle(self.m_Vehicle[player], 1)

        self:setDim(player, rndmDimension)

        player:triggerEvent("VL:CLIENT:DrivingschoolGUI:startLesson", player, license, rndmDimension)

        if not self.m_Mistakes[player] then self.m_Mistakes[player] = 0 end

        self.m_SpeedTimer[player] = Timer(bind(self.checkSpeed, self), 5000, 0, player, self.m_Vehicle[player])

        player:sendNotification("In der Stadt gilt eine Geschwindigkeit von 80 KM/H - Mit /limit 80 kannst du das Limit festlegen", "info")

        addEventHandler("onVehicleExit", self.m_Vehicle[player], bind(self.onExit, self))
        addEventHandler("onVehicleExplode", self.m_Vehicle[player], bind(self.onExplode, self))
        addEventHandler("onVehicleDamage", self.m_Vehicle[player], bind(self.onDamage, self))
        addEventHandler("onPlayerQuit", root, bind(self.onQuit, self))
        addEventHandler("onPlayerWasted", root, bind(self.onQuit, self))
    end
end

function Drivingschool:checkSpeed(player, vehicle)
    if getElementSpeed(vehicle, "km/h") > 90 then
        self:addMistake(player, "speed")
    end
end

function Drivingschool:addMistake(player, reason)
    if self.m_Mistakes[player] < 3 then
        self.m_Mistakes[player] = self.m_Mistakes[player] + 1
        player:sendMessage("DRIVINGSCHOOL_MISTAKE", 255, 255, 255, self.m_Reasons[reason], self.m_Mistakes[player])
    else
        self:destroyStuff(player)
        player:sendNotification("DRIVINGSCHOOL_CANCEL", "error")
    end
end

function Drivingschool:onDamage()
    local driver = source:getOccupant(0)
    if driver then
        self:addMistake(driver, "damage")
    end
end

function Drivingschool:onExit(player, seat)
    if seat == 0 then
        if not isTimer(self.m_ExitTimer[player]) then
            player:sendNotification("DRIVINGSCHOOL_EXIT", "error")
            self.m_ExitTimer[player] = Timer(function(player)
                if not player:isInVehicle() then
                    self:destroyStuff(player)
                    player:sendNotification("DRIVINGSCHOOL_CANCEL", "error")
                end
            end, 10000, 1, player)
        end
    end
end

function Drivingschool:onExplode()
    self:destroyStuff(getPlayerFromName(source:getPlateText()))
    source:sendNotification("DRIVINGSCHOOL_CANCEL", "error")
end

function Drivingschool:onQuit()
    self:destroyStuff(source)
end

function Drivingschool:destroyStuff(player)
    if player then player = player else player = client end
    if isElement(self.m_Vehicle[player]) then self.m_Vehicle[player]:destroy() end
    if isElement(self.m_Ped[player]) then self.m_Ped[player]:destroy() end
    if isTimer(self.m_ExitTimer[player]) then self.m_ExitTimer[player]:destroy() end
    if isTimer(self.m_SpeedTimer[player]) then self.m_SpeedTimer[player]:destroy() end

    self.m_Mistakes[player] = 0

    player:triggerEvent("VL:CLIENT:DrivingschoolGUI:destroyStuff", player)
    player:doWarp(-2029.7041015625, -117.6552734375, 1035.171875, 90, 3, 0)
end

function Drivingschool:getCorrectLicense(license)
    assert(type(license) == "string", "Bad argument @ Drivingschool:getCorrectLicense #1")
    local correctLicense
    for key, value in pairs(self.m_Licenses) do
        if value.name == license then
            correctLicense = value.license
            break
        end
    end
    return correctLicense
end

function Drivingschool:getLicensePrice(license)
    assert(type(license) == "string", "Bad argument @ Drivingschool:getLicensePrice #1")
    local licensePrice
    for key, value in pairs(self.m_Licenses) do
        if value.license == license then
            licensePrice = value.price
            break
        end
    end
    return licensePrice
end

function Drivingschool:hasLicense(player)
    assert(type(player) == "userdata", "Bad argument @ Drivingschool:hasLicense #1")
    local tbl = {}
    local hasLicense

    for key, value in pairs(self.m_Licenses) do
        if player:getData(value.license) == 1 then hasLicense = "✓" else hasLicense = "X" end
        table.insert(tbl, { value.name, value.price, "€", hasLicense })
    end
    return tbl
end

function Drivingschool:setDim(player, dim)
    assert(type(dim) == "number", "Bad argument @ Drivingschool:setDim #1")
    if isElement(player) then player:setDimension(dim) player:setInterior(0) end
    if isElement(self.m_Vehicle[player]) then self.m_Vehicle[player]:setDimension(dim) self.m_Vehicle[player]:setInterior(0) end
    if isElement(self.m_Ped[player]) then self.m_Ped[player]:setDimension(dim) self.m_Ped[player]:setInterior(0) end
end
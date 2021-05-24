--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 27.11.2019
--|**********************************************************************

Vehicle = inherit(Object)

PlayerVehicle = {}
PlayerVehicleID = 0
PlayerVehicleKey = {}

registerElementClass("vehicle", Vehicle)

function Vehicle:constructor()
    self:load()
end

function Vehicle:load()
    local query = Database:query("SELECT * FROM vehicles")
    if query then
        local result = Database:poll(query, -1)
        if result and #result >= 1 then
            for key, value in pairs(result) do
                if not isElement(PlayerVehicle[value["id"]]) then
                    PlayerVehicle[value["id"]] = createVehicle(value["model"], value["posX"], value["posY"], value["posZ"], value["rotX"], value["rotY"], value["rotZ"], getNameFromID(value["owner"]))

                    PlayerVehicle[value["id"]]:setData("id", value["id"])
                    PlayerVehicle[value["id"]]:setData("fuel", value["fuel"])
                    PlayerVehicle[value["id"]]:setData("locked", value["locked"])
                    PlayerVehicle[value["id"]]:setData("brake", value["brake"])
                    PlayerVehicle[value["id"]]:setData("explo", value["explo"])
                    PlayerVehicle[value["id"]]:setData("motor", "off")


                    PlayerVehicle[value["id"]]:setOwner(value["owner"])
                    PlayerVehicle[value["id"]]:setLocked(true)
                    PlayerVehicle[value["id"]]:setEngineState(false)
                    PlayerVehicle[value["id"]]:setFrozen(true)
                    PlayerVehicle[value["id"]]:setDimension(1337, 13337)

                    PlayerVehicle[value["id"]]:setColor(tonumber(gettok(value["color"], 1, "|")), tonumber(gettok(value["color"], 2, "|")), tonumber(gettok(value["color"], 3, "|")),
                        tonumber(gettok(value["color"], 4, "|")), tonumber(gettok(value["color"], 5, "|")), tonumber(gettok(value["color"], 6, "|")))

                    PlayerVehicle[value["id"]]:setAlpha(150)

                    PlayerVehicleID = value["id"]

                    VehicleManager:loadKeys(PlayerVehicle[value["id"]])

                    Timer(function() PlayerVehicle[value["id"]]:setAlpha(255) end, 5000, 1)
                end
            end
        end
    end
end

function Vehicle:receiveCarData(id, data)
    local query = Database:query("SELECT * FROM vehicles WHERE id=?", id)
    if query then
        local result = Database:poll(query, -1)
        for _, v in pairs(result) do
            return v[data]
        end
    end
end

function Vehicle:setOwner(id)
    self:setData("owner", id)
end

function Vehicle:getOwner()
    if self:getData("owner") then
        return self:getData("owner")
    end
end

function Vehicle:isFactionCar()
    if self:getData("faction") and tonumber(self:getData("faction")) > 0 then
        return true
    end
end

function Vehicle:isLocked()
    if self:getData("locked") == 1 then
        return true
    else
        return false
    end
end

function Vehicle:changeLockedState()
    if self:isLocked() then
        self:setData("locked", 0)
        self:setLocked(false)
    else
        self:setData("locked", 1)
        self:setLocked(true)
    end
    VehicleManager:opticalCarlock(self)
end

function Vehicle:getLockedState()
    if self:isLocked() then
        return "abgeschlossen"
    else
        return "aufgeschlossen"
    end
end

function Vehicle:isBraked()
    if self:getData("brake") == 1 then
        return true
    else
        return false
    end
end

function Vehicle:changeBrakeState()
    if getElementSpeed(self, "km/h") < 2 then
        if self:isBraked() then
            self:setData("brake", 0)
            self:setFrozen(false)
        else
            self:setData("brake", 1)
            self:setFrozen(true)
        end
    end
end

function Vehicle:getBrakeState()
    if self:isBraked() then
        return "gezogen"
    else
        return "gelöst"
    end
end

function Vehicle:hasKey(player)
    if self:getOwner() == player:getId() then
        return true
    else
        for key, value in ipairs(PlayerVehicleKey) do
            if value.playerId == player:getId() then
                return true
            else
                return false
            end
        end
    end
end

function Vehicle:getId()
    if self:getOwner() then
        return self:getData("id")
    end
end

function Vehicle:addExplo()
    if self:getOwner() then
        self:setData("explo", self:getData("explo") + 1)
    end
end

function Vehicle:getExplo()
    return self:getData("explo")
end

function Vehicle:destructor()
end
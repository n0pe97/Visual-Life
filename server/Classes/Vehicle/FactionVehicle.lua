--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 30.12.2019
--|**********************************************************************

FactionVehicleClass = inherit(Object)

FactionVehicle = {}

function FactionVehicleClass:constructor()
    self.m_FactionVehicleCounter = 0

    addEventHandler("onVehicleStartEnter", root, bind(self.onStartEnter, self))

    self:load()
end

function FactionVehicleClass:load()
    local query = Database:query("SELECT * FROM vehicles_faction")
    if query then
        local result = Database:poll(query, -1)
        if result and #result >= 1 then
            for key, value in pairs(result) do
                if not isElement(FactionVehicle[value["id"]]) then
                    local id = tonumber(value["id"])

                    FactionVehicle[id] = createVehicle(value["model"], value["posX"], value["posY"], value["posZ"], 0, 0, value["rotZ"], Settings.Faction.Names[tonumber(value["faction"])])
                    FactionVehicle[id]:setColor(gettok(value["color"], 1, "|"), gettok(value["color"], 2, "|"), gettok(value["color"], 3, "|"), gettok(value["color"], 4, "|"), gettok(value["color"], 5, "|"), gettok(value["color"], 6, "|"))

                    FactionVehicle[id]:setData("id", tonumber(value["id"]))
                    FactionVehicle[id]:setData("faction", tonumber(value["faction"]))
                    FactionVehicle[id]:setData("rank", tonumber(value["rank"]))

                    self.m_FactionVehicleCounter = self.m_FactionVehicleCounter + 1
                end
            end
            print(("Es wurden %d Fraktionsfahrzeuge geladen"):format(self.m_FactionVehicleCounter))
        end
    end
end

function FactionVehicleClass:onStartEnter(player, seat)
    if seat == 0 then
        if source:getData("faction") and source:getData("faction") > 0 then
            if source:getData("faction") == player:getData("faction") then
                if not player:isDuty() then
                    cancelEvent()
                    player:sendNotification("Du musst im Dienst sein!", "error")
                end
            else
                cancelEvent()
                player:sendNotification("Du bist nicht in der richtigen Fraktion!", "error")
            end
        end
    end
end
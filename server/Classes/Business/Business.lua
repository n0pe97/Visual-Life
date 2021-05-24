--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 18.12.2019
--|**********************************************************************

Business = inherit(Object)

Business.Pickup = {}

function Business:constructor()
    self.m_Pickup = {}
    self.m_BusinessCount = 0

    addCommandHandler("reloadBusiness", bind(self.reload, self))

    addEventHandler("onResourceStop", resourceRoot, bind(self.saveData, self))

    self:load()
end

function Business:load()
    local query = Database:query("SELECT * FROM business")
    if query then
        local result = Database:poll(query, -1)
        if result then
            if result and #result == 0 then return end

            for key, value in pairs(result) do
                if not isElement(Business.Pickup[tonumber(value["id"])]) then
                    local id = tonumber(value["id"])

                    Business.Pickup[id] = Pickup(tonumber(value["posX"]), tonumber(value["posY"]), tonumber(value["posZ"]), 3, 1314, 0)

                    Business.Pickup[id]:setData("id", tonumber(value["id"]))
                    Business.Pickup[id]:setData("depot", tonumber(value["depot"]))
                    Business.Pickup[id]:setData("playtime", tonumber(value["playtime"]))
                    Business.Pickup[id]:setData("owner", value["owner"])
                    Business.Pickup[id]:setData("name", value["name"])

                    addEventHandler("onPickupHit", Business.Pickup[id], bind(self.onHit, self))
                    self.m_BusinessCount = self.m_BusinessCount + 1
                end
            end
            print(("Es wurden %d Business geladen"):format(self.m_BusinessCount))
        end
    end
end

function Business:reload(player)
    if player:isAdmin(5) then
        self:load()
        player:sendNotification("Business reloaded!", "info")
    end
end

function Business:onHit(player)
    if not player:isInVehicle() then
        player:sendNotification("Business: %s, Owner: %s, Spielzeit: %s std, Depot: %s €", "info",
            source:getData("name"), source:getData("owner"), source:getData("playtime"), source:getData("depot"))
    end
end

function Business:addCash(id, amount, reason, ...)
    assert(type(id) == "number", "Bad argument @ Business:addCash #1")
    assert(type(amount) == "number", "Bad argument @ Business:addCash #1")

    Business.Pickup[id]:setData("depot", Business.Pickup[id]:getData("depot") + math.floor(amount))

    Logs:output("business", "Es wurden %d€ in %s hinzugefügt. Grund: " .. reason:format(...), math.floor(amount), Business.Pickup[id]:getData("name"))
end

function Business:saveData()
    for i = 1, #Business.Pickup do
        Database:exec("UPDATE business SET owner=?, depot=? WHERE id=?", Business.Pickup[i]:getData("owner"), Business.Pickup[i]:getData("depot"), i)
    end
end
--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 01.01.2020
--|**********************************************************************

Bus = inherit(Object)

addEvent("VL:SERVER:Bus:reward", true)

function Bus:constructor()
    self.m_JobVehicle = {}
    self.m_Spawns = {
        { -2006.775390625, 484.0576171875, 35.148506164551, 180 },
    }

    addEventHandler("VL:SERVER:Bus:reward", root, bind(self.reward, self))

    self:load()
end

function Bus:load()
    for key, value in pairs(self.m_Spawns) do
        self.m_Vehicle = createVehicle(437, value[1], value[2], value[3], 0, 0, value[4], "Visual")
        self.m_Vehicle:setData("jobVehicle", true)
        self.m_Vehicle:setDamageProof(true)
        self.m_Vehicle:setEngineState(false)
        self.m_Vehicle:setOverrideLights(1)

        addEventHandler("onVehicleEnter", self.m_Vehicle, bind(self.onEnter, self))
        addEventHandler("onVehicleExit", self.m_Vehicle, bind(self.onExit, self))
    end
end

function Bus:onEnter(player, seat)
    if seat == 0 then
        if player:getData("job") == "busdriver" then
            self.m_JobVehicle[player] = source
            source:setDamageProof(false)
            player:triggerEvent("VL:CLIENT:BUS:showMarker", player, 1)
            addEventHandler("onVehicleExplode", source, bind(self.onExplode, self))
            addEventHandler("onPlayerWasted", player, bind(self.onDie, self))
            addEventHandler("onPlayerQuit", player, bind(self.onQuit, self))
        else
            player:exitVehicle()
            player:sendNotification("Du bist kein Busfahrer!", "error")
        end
    end
end

function Bus:onExit(player, seat)
    if seat == 0 then
        if self.m_JobVehicle[player] then
            source:respawn()
            source:setEngineState(false)
            source:setOverrideLights(1)
            source:setDamageProof(true)

            player:sendNotification("Du hast den Job beendet!", "error")
            player:doWarp(-2013.078125, 472.0888671875, 35.171875, 270, 0, 0)

            self:endJob(player)
        end
    end
end

function Bus:endJob(player)
    player:triggerEvent("VL:CLIENT:BUS:hideMarker", player)
    self.m_JobVehicle[player] = nil
end

function Bus:onExplode()
    if source:getOccupant() then
        self:endJob(source:getOccupant())
    end
end

function Bus:onQuit()
    if source:isInVehicle() then
        local vehicle = source:getOccupiedVehicle()
        if vehicle then
            vehicle:respawn()
            vehicle:setEngineState(false)
            vehicle:setOverrideLights(1)
            vehicle:setDamageProof(true)
        end
    end
end

function Bus:onDie()
    if self.m_JobVehicle[source] then
        self.m_JobVehicle[source]:respawn()
        self.m_JobVehicle[source]:setEngineState(false)
        self.m_JobVehicle[source]:setOverrideLights(1)
        self.m_JobVehicle[source]:setDamageProof(true)

        self:endJob(source)
    end
end

function Bus:reward()
    self.m_LineCash = { [1] = math.random(750, 1500), [2] = math.random(800, 1600) }
    self.m_Line = 1
    client:addJobMoney(self.m_LineCash[self.m_Line])
    client:sendNotification("Du hast %d€ verdient. Dieses Geld wird dir bei deinem nächsten Payday auf dein Konto überwiesen", "success", self.m_LineCash[self.m_Line])
end

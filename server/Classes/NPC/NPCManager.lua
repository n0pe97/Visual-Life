--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 27.11.2019
--|**********************************************************************

NPCManager = inherit(Object)

function NPCManager:constructor()
    self.m_NPCPeds = {
        ["NPC"] = {
            { 143, -2055.158203125, 464.6298828125, 35.171875, 283.01489257812, 0, 0, 1.5, "Matambo", "NPC_VEHICLERENT" },
            { 35, -1967.1875, 296.31640625, 35.263648986816, 88.262786865234, 0, 0, 1.5, "Udo", "NPC_UDOQUEST", "" },
            --        { 2, -1599.9775390625, 800.9150390625, 6.8203125, 229.03273010254, 0, 0, 1.5, "Amuk", "Waffendealer" },
            --        { 15, -1579.05078125, 807.525390625, 6.8203125, 268.67749023438, 0, 0, 1.5, "Ali", "Waffenhändler" },
            --        { 59, -1483.748046875, 760.865234375, 7.1778392791748, 88.147399902344, 0, 0, 1.5, "Dieter", "Verkehrsbetriebe" },
            --        { 158, -1060.5390625, -1198.341796875, 129.21875, 272, 0, 0, 1.5, "Klausi", "Farmer" },
            --        { 194, 1714.845703125, -1671.1142578125, 20.224201202393, 1, 18, 0, 1.5, "Emma", "Fahrzeugstelle" },
            { 309, -1608.2333984375, 792.12890625, 6.8203125, 132, 0, 0, 1.5, "Markus", "Abfallwirtschaft", "VL:CLIENT:JobGUI:show", "cleaner" },
            { 94, -1826.076171875, 42.228515625, 15.122790336609, 270, 0, 0, 1.5, "Detlef", "VL:CLIENT:JobGUI:show", "trucker" },
            { 20, -2227.103515625, 287.076171875, 35.3203125, 357, 0, 0, 1.5, "Herbert", "Taxifahrer", "VL:CLIENT:JobGUI:show", "taxidriver" },
            --        { 281, -1606.7373046875, 728.9951171875, -5.2421875, 358, 0, 0, 1.5, "Officer Smith", "Asservatenkammer" },
            --        { 249, -1604.8623046875, 783.7958984375, 6.8203125, 35, 0, 0, 1.5, "Skinner", "Auktionator" },
            --        { 281, -1572.431640625, 657.546875, 7.1875, 265, 0, 0, 1.5, "Officer Morgan", "Abschlepphof" },
            { 253, -2102.12109375, -12.3251953125, 35.3203125, 275, 0, 0, 1.5, "Alfred", "Straßenreinigung", "VL:CLIENT:JobGUI:show", "streetcleaner" },
            --        { 144, 1709.7275390625, 701.4765625, 10.8203125, 90, 0, 0, 1.5, "Dildo Beutlin", "Dealer" },
            { 161, -2579.4404296875, 310.095703125, 5.1796875, 90, 0, 0, 1.5, "Albert", "Landwirt", "VL:CLIENT:JobGUI:show", "farmer" },
            --        { 21, 161.8681640625, -18.5439453125, 1.578125, 270, 0, 0, 1.5, "Louis", "Hanfdealer" },
            { 21, -1412.2861328125, -299.2998046875, 6.203125, 137, 0, 0, 1.5, "Jeremy", "Pilot", "VL:CLIENT:JobGUI:show", "pilot" },
        },
        ["Homeless"] = {
            { -2025.4755859375, 454.5458984375, 35.172294616699, 1, "Haste mal nen Euro?" }
        },
    }

    self:createNPC()
end

function NPCManager:createNPC()
    self.m_PedCount = 0
    for _, v in ipairs(self.m_NPCPeds["NPC"]) do
        local sphere = {}
        local ped = createPed(v[1], v[2], v[3], v[4], v[5])
        sphere[ped] = createColSphere(v[2], v[3], v[4], v[8])

        ped:setInterior(v[6])
        ped:setDimension(v[7])
        ped:setFrozen(true)
        ped:setData("infoPed", true)
        ped:setData("pedName", v[9])
        ped:setData("pedInfo", v[10])
        ped:setData("pedFunction", v[11])

        addEventHandler("onColShapeHit", sphere[ped], function(element, dim)
            if element:getType() == "player" and dim then
                if not element:isInVehicle() then
                    if ped:getData("infoPed") then
                        if ped:getData("pedFunction") then
                            if ped:getData("pedFunction") == "VL:CLIENT:JobGUI:show" then
                                element:triggerEvent(ped:getData("pedFunction"), element, v[12])
                            else
                                element:triggerEvent(ped:getData("pedFunction"), elementl)
                            end
                        else
                            Vehiclerent:triggerRent(element)
                        end
                    end
                end
            end
        end)

        self.m_PedCount = self.m_PedCount + 1
    end

    for key, value in pairs(self.m_NPCPeds["Homeless"]) do
        local sphere = {}
        local ped = createPed(137, value[1], value[2], value[3], value[4])
        sphere[ped] = createColSphere(value[1], value[2], value[3], 1.5)

        ped:setData("homelessPed", true)
        ped:setFrozen(true)

        addEventHandler("onColShapeHit", sphere[ped], function(element, dim)
            if element:getType() == "player" and dim then
                if not element:isInVehicle() then
                    if ped:getData("homelessPed") then
                        element:sendMessage("#7cb2e6[Obdachloser Mann] #ffffff" .. value[5], 255, 255, 255)
                    end
                end
            end
        end)

        self.m_PedCount = self.m_PedCount + 1
    end


    outputDebugString("Es wurden " .. self.m_PedCount .. " InfoNPC's geladen")
end
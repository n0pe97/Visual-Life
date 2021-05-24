--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 27.11.2019
--|***********************************************************************

Carhouse = inherit(Object)

addEvent("VL:SERVER:buyVehicle", true)
addEvent("VL:SERVER:testVehicle", true)

function Carhouse:constructor()
    self.m_ColShape = {}
    self.m_CarhouseVehicleID = {}
    self.m_CarhouseVehiclePrice = {}
    self.m_Carhouses = {}
    self.m_CarhousePosition = { ["Ottos"] = { -1639.1005859375, 1212.9375, 6.7661437988281, 224.56672668457 }, ["Wang"] = { -1987.943359375, 274.2568359375, 35.263538360596, 270 }, }
    self.m_CarhouseVehicles = {
        { 522, -1653.712890625, 1215.4501953125, 6.8129162788391, 189.70108032227, -1652.6123046875, 1215.4130859375, 7.25, 30000, "Ottos" }, --> NRG 500
        { 581, -1657.2021484375, 1210.8291015625, 6.8508095741272, 246.69352722168, -1656.033203125, 1211.390625, 7.25, 20000, "Ottos" }, --> BF 400
        { 468, -1668.708984375, 1207.00390625, 6.9237542152405, 311.86813354492, -1669.1357421875, 1207.7021484375, 7.2546453475952, 25000, "Ottos" }, --> Sanchez
        { 471, -1669.115234375, 1216.15625, 6.7327771186829, 278.01052856445, -1669.1123046875, 1217.3935546875, 7.25, 15000, "Ottos" }, --> Quadbike
        { 411, -1674.126953125, 1205.7998046875, 13.399448394775, 282.68133544922, -1673.033203125, 1207.9990234375, 13.671875, 65000, "Ottos" }, --> Infernus
        { 451, -1664.34375, 1224.013671875, 13.302046775818, 193.23872375488, -1662.3154296875, 1223.357421875, 13.678089141846, 37000, "Ottos" }, --> Turismo
        { 565, -1650.7138671875, 1210.03125, 13.297058105469, 79.340667724609, -1652.0126953125, 1208.4609375, 13.671875, 30000, "Ottos" }, --> Flash
        { 560, -1656.9013671875, 1216.955078125, 13.37663936615, 95.780212402344, -1657.416015625, 1215.1142578125, 13.671875, 35000, "Ottos" }, --> Sultan
        { 402, -1647.5830078125, 1205.5322265625, 20.984003067017, 66.153869628906, -1649.4599609375, 1204.376953125, 21.148662567139, 15000, "Ottos" }, --> Bufallo
        { 415, -1664.791015625, 1223.71484375, 20.927360534668, 185.71429443359, -1662.90625, 1222.4580078125, 21.15625, 45000, "Ottos" }, --> Cheetah
        { 541, -1662.771484375, 1205.0546875, 20.848300933838, 41.949188232422, -1664.7939453125, 1204.6689453125, 21.15625, 50000, "Ottos" }, --> Bullet
        { 562, -1679.2431640625, 1208.9013671875, 20.752658843994, 242.33737182617, -1677.400390625, 1210.05859375, 21.148662567139, 30000, "Ottos" }, --> Elegy
        { 506, -1655.1708984375, 1215.1015625, 20.863084793091, 98.892181396484, -1655.9384765625, 1213.1630859375, 21.15625, 35000, "Ottos" }, --> Super GT

        { 549, -1944.5908203125, 273.0546875, 35.171077728271, 127.82513427734, -1944.7880859375, 270.6259765625, 35.473926544189, 1250, "Wang" }, --> Tampa
        { 475, -1946.3251953125, 256.427734375, 35.303077697754, 51.238250732422, -1948.908203125, 256.203125, 35.46875, 2500, "Wang" }, --> Sabre
        { 576, -1960.3212890625, 258.2919921875, 35.110893249512, 313.38705444336, -1960.2197265625, 260.9755859375, 35.473926544189, 3500, "Wang" }, --> Tornado
        { 507, -1961.9755859375, 271.8095703125, 35.325958251953, 306.49850463867, -1961.396484375, 274.6826171875, 35.46875, 3000, "Wang" }, --> Elegant
        { 400, -1959.2451171875, 305.107421875, 35.553642272949, 140.17944335938, -1958.8623046875, 302.9765625, 35.46875, 4000, "Wang" }, --> Landstriker
        { 554, -1953.7587890625, 298.7197265625, 35.582057952881, 135.40032958984, -1953.7451171875, 295.9521484375, 35.46875, 8000, "Wang" }, --> Yosemite
        { 558, -1944.55078125, 271.552734375, 40.686717987061, 56.610656738281, -1946.9951171875, 271.0634765625, 41.053413391113, 7000, "Wang" }, --> Uranus
        { 559, -1944.859375, 264.2490234375, 40.724716186523, 51.74365234375, -1947.6474609375, 264.1865234375, 41.047080993652, 40000, "Wang" }, --> Jester
        { 542, -1945.0810546875, 256.68359375, 40.819828033447, 53.572906494141, -1947.9638671875, 256.5244140625, 41.047080993652, 12000, "Wang" }, --> Clover
        { 589, -1952.6923828125, 296.0712890625, 40.698963165283, 138.08102416992, -1952.5576171875, 293.5927734375, 41.047080993652, 11000, "Wang" }, --> Club
        { 603, -1953.7177734375, 304.56640625, 40.940582275391, 139.82788085938, -1953.580078125, 301.9345703125, 41.047080993652, 25000, "Wang" }, --> Phönix
    }

    Timer(bind(self.createCarhouse, self), 500, 1)

    addEventHandler("VL:SERVER:buyVehicle", root, bind(self.buyVehicle, self))
    addEventHandler("VL:SERVER:testVehicle", root, bind(self.testVehicle, self))
end

function Carhouse:createCarhouse()
    for key, value in pairs(self.m_CarhouseVehicles) do
        self.m_Vehicle = createVehicle(value[1], value[2], value[3], value[4], 0, 0, value[5], "VISUAL")
        self.m_Vehicle:setFrozen(true)
        self.m_Vehicle:setLocked(true)
        self.m_Vehicle:setDamageProof(true)

        createMarker(value[6], value[7], value[8] - 0.95, "cylinder", 1, 69, 39, 160)

        self.m_ColShape[key] = createColSphere(value[6], value[7], value[8], 1)
        self.m_CarhouseVehicleID[self.m_ColShape[key]] = value[1]
        self.m_CarhouseVehiclePrice[self.m_ColShape[key]] = value[9]
        self.m_Carhouses[self.m_ColShape[key]] = value[10]

        addEventHandler("onColShapeHit", self.m_ColShape[key], bind(self.onHit, self))
    end
end

function Carhouse:onHit(element, dim)
    if element:getType() == "player" and dim then
        if not element:getOccupiedVehicle() then
            element:triggerEvent("VL:CLIENT:openCarhouseWindow", element, self.m_Carhouses[source], self.m_CarhouseVehicleID[source], self.m_CarhouseVehiclePrice[source], getVehicleType(self.m_CarhouseVehicleID[source]))
        end
    end
end

function Carhouse:buyVehicle(marker, id, price, license)
    if id then
        if client:getData(license) == 1 then
            if client:getData("money") >= price then
                if client:getVehicles() < client:getData("maxvehicles") then
                    client:takeCash(price, "Fahrzeugkauf")
                    PlayerVehicleClass:new(id, self.m_CarhousePosition[marker][1], self.m_CarhousePosition[marker][2], self.m_CarhousePosition[marker][3], self.m_CarhousePosition[marker][4], client:getId())
                    client:triggerEvent("VL:CLIENT:closeCarhouseWindow", client)
                    client:warpIntoVehicle(PlayerVehicle[PlayerVehicleID])
                    PlayerVehicle[PlayerVehicleID]:setDimension(0)
                    client:sendNotification("VEHICLE_CARHOUSE_BUY_INFO", "info")

                    if marker == "Wang" then
                        Business:addCash(3, price / 10, "Autokauf von %s (%s) für %d€", client:getName(), getVehicleNameFromModel(id), price)
                    elseif marker == "Ottos" then
                        Business:addCash(4, price / 10, "Autokauf von %s (%s) für %d€", client:getName(), getVehicleNameFromModel(id), price)
                    end

                    Logs:output("vehicle", "%s hat sich das Fahrzeug %s für %d€ gekauft", client:getName(), getVehicleNameFromModel(id), price)
                else
                    client:sendNotification("Du hast bereits %d/%d Fahrzeugen - Melde dich bei einem Admin für mehr Slots!", "error", client:getVehicles(), client:getData("maxvehicles"))
                end
            else
                client:sendNotification("VEHICLE_CARHOUSE_BUY_ERROR_MONEY", "error", price)
            end
        else
            client:sendNotification("VEHICLE_CARHOUSE_BUY_ERROR_LICENSE", "error", license)
        end
    end
end

function Carhouse:testVehicle(marker, id, license)
    if id then
        if client:getData(license) == 1 then
            client:sendNotification("worked", "success")
        else
            client:sendNotification("VEHICLE_CARHOUSE_BUY_ERROR_LICENSE", "error", license)
        end
    end
end
--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 13.12.2019
--|**********************************************************************

SFPD = inherit(Object)

function SFPD:constructor()
    self.m_SpeederCount = 0
    self.m_SpeederMaxCount = 10

    addCommandHandler("blitzer", bind(self.createSpeedCam, self))
    addCommandHandler("delblitzer", bind(self.deleteSpeedCam, self))
end

function SFPD:createSpeedCam(player, cmd, speed)
    if speed then
        local speed = math.floor(tonumber(speed))
        if speed >= 80 then
            if player:getData("faction") == 1 and player:getData("factionrank") >= 4 and player:isDuty() then
                if not player:isInVehicle() and player:isOnGround() and player:getInterior() == 0 and player:getDimension() == 0 then
                    if self.m_SpeederCount < 10 then
                        local object = createObject(1478, player:getPosition().x, player:getPosition().y, player:getPosition().z - 0.4, 0, 0, player:getRotation().z + 180)
                        local object1 = createObject(1886, Vector3(player:getPosition()))

                        object1:attach(object, 0.03, -0.1, 0.05, 0, 180)

                        local colShapeX, colShapeY = getPointFromDistanceRotation(player:getPosition().x, player:getPosition().y, 6, 360 - player:getRotation().z)
                        local speedCamColShape = createColSphere(colShapeX, colShapeY, player:getPosition().z, 5)
                        speedCamColShape:setData("speedLimit", speed)

                        object:setData("speedcam", true)
                        object:setData("speedcamObj", object1)
                        object:setData("speedcamCol", speedCamColShape)

                        addEventHandler("onColShapeHit", speedCamColShape, bind(self.onSpeedCamHit, self))
                        self.m_SpeederCount = self.m_SpeederCount + 1

                        player:sendNotification("SFPD_SPEEDCAM_PLACED", "info", speed, self.m_SpeederCount, self.m_SpeederMaxCount)
                    end
                end
            end
        end
    end
end

function SFPD:onSpeedCamHit(vehicle)
    if vehicle and isElement(vehicle) then
        if vehicle:getType() == "vehicle" and vehicle:getOccupant() and not vehicle:areSirensOn() then
            local driver = vehicle:getOccupant()
            if driver and isElement(driver) then
                if Settings.Faction.Staat[driver:getData("faction")] and driver:isDuty() then return end
                if not source:getData("damaged") then
                    if getElementSpeed(vehicle, "km/h") > source:getData("speedLimit") + 10 then
                        driver:addStvo(3)
                        driver:sendNotification("SFPD_SPEEDCAM_HIT", "info", getElementSpeed(vehicle, "km/h") - source:getData("speedLimit"), getElementSpeed(vehicle, "km/h"))

                        driver:fadeCamera(false, 1, 255, 255, 255)
                        Timer(function(driver) driver:fadeCamera(true, 1, 255, 255, 255) end, 750, 1, driver)
                    end
                end
            end
        end
    end
end

function SFPD:deleteSpeedCam(player)
    if player:getData("faction") == 1 and player:getData("factionrank") >= 4 and player:isDuty() then
        if not player:isInVehicle() and player:isOnGround() and player:getInterior() == 0 and player:getDimension() == 0 then
            local speedCam

            for key, value in pairs(getElementsByType("object")) do
                if (player:getPosition() - value:getPosition()):getLength() < 5 then
                    if value:getData("speedcam") then
                        speedCam = value
                        break
                    end
                end
            end

            if speedCam then
                removeEventHandler("onColShapeHit", speedCam:getData("speedcamCol"), bind(self.onSpeedCamHit, self))
                if isElement(speedCam:getData("speedcamCol")) then speedCam:getData("speedcamCol"):destroy() end
                if isElement(speedCam:getData("speedcamObj")) then speedCam:getData("speedcamObj"):destroy() end
                if isElement(speedCam) then speedCam:destroy() end
                self.m_SpeederCount = self.m_SpeederCount - 1

                player:sendNotification("SFPD_SPEEDCAM_DELETE", "info", self.m_SpeederCount, self.m_SpeederMaxCount)
            end
        end
    end
end
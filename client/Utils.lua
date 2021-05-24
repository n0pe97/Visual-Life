--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 23.11.2019
--|**********************************************************************

addEvent("VL:CLIENT:Utils:canKnockedOff", true)
addEventHandler("VL:CLIENT:Utils:canKnockedOff", root, function(boolean)
    localPlayer:setCanBeKnockedOffBike(boolean)
end)
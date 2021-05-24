--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

Main = inherit(Singleton)

function Main.Event_OnResourceStart()
    Core:new()
end

addEventHandler("onResourceStart", resourceRoot, Main.Event_OnResourceStart)

function Main.Event_OnResourceStop()
    Core:delete()
end

addEventHandler("onResourceStop", resourceRoot, Main.Event_OnResourceStop)
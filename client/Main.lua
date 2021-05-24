--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

Main = inherit(Singleton)

function Main.Event_OnResourceStart()
    Core:new()
end

addEventHandler("onClientResourceStart", resourceRoot, Main.Event_OnResourceStart)

function Main.Event_OnResourceStop()
    delete(core)
end

addEventHandler("onClientResourceStop", resourceRoot, Main.Event_OnResourceStop)
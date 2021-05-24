--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 30.12.2019
--|**********************************************************************

PlayerVehicleClass = inherit(Object)

function PlayerVehicleClass:constructor(model, posX, posY, posZ, rotZ, owner)
    assert(type(model) == "number", "Bad argument @ PlayerVehicle:constructor #1")
    assert(type(owner) == "number", "Bad argument @ PlayerVehicle:constructor #6")
    local r, g, b = math.random(0, 255), math.random(0, 255), math.random(0, 255)

    Database:exec("INSERT INTO vehicles (owner, model, posX, posY, posZ, rotX, rotY, rotZ, color) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        owner, model, posX, posY, posZ, 0, 0, rotZ, r .. "|" .. g .. "|" .. b .. "|" .. b .. "|" .. g .. "|" .. r)

    Vehicle:load()
end
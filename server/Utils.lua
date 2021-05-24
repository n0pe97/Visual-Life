--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 27.11.2019
--|**********************************************************************

Utils = inherit(Object)

function Utils:isNameAvailable(name)
    assert(type(name) == "string", "Bad argument @ isNameAvailable #1")
    local query = Database:query("SELECT username FROM userdata WHERE username = ?", name)
    local result = Database:poll(query, -1)

    if result and #result == 0 then
        return true
    else
        return false
    end
end

function Utils:isNumberAvailable(number)
    assert(type(number) == "string", "Bad argument @ isNumberAvailable #1")
    local query = Database:query("SELECT phonenumber FROM userdata WHERE phonenumber = ?", number)
    local result = Database:poll(query, -1)

    if result and #result == 0 then
        return true
    else
        return false
    end
end

function Utils:getHex(amount)
    assert(type(amount) == "number", "Bad argument @ Utils:getHex #1")
    if amount == 0 then
        return "#ffffff"
    elseif amount > 0 then
        return "#00ff00"
    else
        return "#ff0000"
    end
end
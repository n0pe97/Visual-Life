--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 22.11.2019
--|**********************************************************************

function dateString()
    local regtime = getRealTime()
    local year = regtime.year + 1900
    local month = regtime.month + 1
    local day = regtime.monthday
    local hour = regtime.hour
    if hour == 24 then hour = 0 end
    local minute = regtime.minute
    return tostring((day > 9 and day or "0" .. day) .. "." .. (month > 9 and month or "0" .. month) .. "." .. year .. " - " .. (hour > 9 and hour or "0" .. hour) .. ":" .. (minute > 9 and minute or "0" .. minute))
end

function table.find(tbl, value)
    for k, v in pairs(tbl) do
        if v == value then
            return k
        end
    end
    return false
end

function getTimestamp()
    local time = getRealTime()
    local year = tostring(time.year + 1900)
    local month = tostring(time.month + 1)
    local day = tostring(time.monthday)
    local hour = tostring(time.hour)
    local minute = tostring(time.minute)
    local second = tostring(time.second + 1)

    if #month == 1 then
        month = "0" .. month
    end
    if #day == 1 then
        day = "0" .. day
    end
    if #hour == 1 then
        hour = "0" .. hour
    end
    if #minute == 1 then
        minute = "0" .. minute
    end
    if #second == 1 then
        second = "0" .. second
    end

    return "[" .. day .. "-" .. month .. "-" .. year .. " " .. hour .. ":" .. minute .. ":" .. second .. "]"
end

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function setElementSpeed(element, unit, speed)
    local unit = unit or 0
    local speed = tonumber(speed) or 0
    local acSpeed = getElementSpeed(element, unit)
    if (acSpeed) then -- if true - element is valid, no need to check again
        local diff = speed / acSpeed
        if diff ~= diff then return false end -- if the number is a 'NaN' return false.
        local x, y, z = getElementVelocity(element)
        return setElementVelocity(element, x * diff, y * diff, z * diff)
    end

    return false
end

function comma_value(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end

function rgbToHex(rgb)
    local hexadecimal = '0X'

    for key, value in pairs(rgb) do
        local hex = ''

        while (value > 0) do
            local index = math.fmod(value, 16) + 1
            value = math.floor(value / 16)
            hex = string.sub('0123456789ABCDEF', index, index) .. hex
        end

        if (string.len(hex) == 0) then
            hex = '00'

        elseif (string.len(hex) == 1) then
            hex = '0' .. hex
        end

        hexadecimal = hexadecimal .. hex
    end

    return hexadecimal
end
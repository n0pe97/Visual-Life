--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 20.12.2019
--|**********************************************************************

Nametag = inherit(Object)

Nametag.Font = dxCreateFont("res/Fonts/nunito-regular.ttf", 15)

function Nametag:constructor()
    setPedTargetingMarkerEnabled(false)

    addEventHandler("onClientRender", root, bind(self.draw, self))
end

function Nametag:draw()
    local px, py, pz = getCameraMatrix()
    local players = getElementsByType("player")

    for i = 1, #players do
        local player = players[i]
        local playerName = player:getName()
        playerName = string.gsub(playerName, "#%x%x%x%x%x%x", "")

        if player:getData("loggedin") then
            if player ~= localPlayer then
                local x, y, z = getPedBonePosition(player, 8)
                local dist = math.sqrt((px - x) ^ 2 + (py - y) ^ 2 + (pz - z) ^ 2)

                if dist <= 30 then
                    if isLineOfSightClear(px, py, pz, x, y, z, true, false, false, true, false, false, false, localPlayer) then
                        local sx, sy = getScreenFromWorldPosition(x, y, z + 0.3 + dist * 0.013333)
                        if sx then

                            local health = getElementHealth(player)
                            if health < (50) then
                                red = 200
                                green = (health / 50) * ((health / 100) * 200 * 2)
                            else
                                green = 200
                                red = 200 - ((health - 50) / 50) * 200
                            end
                            local colour = tocolor(red, green, 0, 90)
                            if health == 0 then
                                colour = tocolor(0, 0, 0, 255)
                            elseif health >= 95 then
                                red = 200 - ((100 - 50) / 50) * 200
                                green = 200
                                colour = tocolor(red, green, 0, 255)
                            end
                            if getElementHealth(player) > 0.5 then
                                dxDrawRectangle(sx - 40, sy, 80,12, tocolor(0, 0, 0, 150))
                                dxDrawRectangle(sx - 38, sy + 2, getElementHealth(player) / 100 * 76, 4, colour)
                                if getPedArmor(player) > 0 then
                                    dxDrawRectangle ( sx - 38, sy + 6, getPedArmor(player)/100 * 76, 4, tocolor(120,120,120,255) )
                                end
                                dxDrawRectangle ( sx - 38, sy + 4, 76, 3, tocolor(0,0,0,150) )
                            end

                            local c1, c2, c3
                            c1, c2, c3 = 255, 255, 255

--                            if getElementData(player, "loggedin") and getElementData(player, "Wanteds") >= 1 and getElementData(player, "Wanteds") <= 6 then
--                                dxDrawImage(sx - 15, sy - 70, 30, 30, "res/images/wanteds/" .. getElementData(player, "Wanteds") .. ".png")
--                            end

--                            if getElementData(player,"loggedin") == 1 and getElementData(player,"Blacklist2") == 1 and getElementData(getLocalPlayer(),"Fraktion") == 2 or getElementData(player,"Blacklist3") == 1 and getElementData(getLocalPlayer(),"Fraktion") == 3 or getElementData(player,"Blacklist4") == 1 and getElementData(getLocalPlayer(),"Fraktion") == 4 or getElementData(player,"Blacklist7") == 1 and getElementData(getLocalPlayer(),"Fraktion") == 7 or getElementData(player,"Blacklist9") == 1 and getElementData(getLocalPlayer(),"Fraktion") == 9 or getElementData(player,"Blacklist11") == 1 and getElementData(getLocalPlayer(),"Fraktion") == 11 or getElementData(player,"Blacklist12") == 1 and getElementData(getLocalPlayer(),"Fraktion") == 12 or getElementData(player,"Blacklist13") == 1 and getElementData(getLocalPlayer(),"Fraktion") == 13 then
--                                c1, c2, c3 = 255, 0, 0
--                            end

                            local color = string.format("#%02X%02X%02X", c1, c2, c3)
                            if player:getData("adminlevel") > 0 then
                                playerName = "[#4527a0VL" .. color .. "]" .. playerName
                                elseif player:getData("afk") then
                                playerName = playerName .. "(AFK)"
                            else
                                playerName = playerName
                            end

                            dxDrawText(string.gsub(playerName, "#%x%x%x%x%x%x", ""), sx - 1, sy - 40, sx - 1, sy, tocolor(0, 0, 0, 255), 1.02, 1.02, Nametag.Font, "center", "center", false, false, false, true, true)
                            dxDrawText(playerName, sx - 1, sy - 40, sx - 1, sy, tocolor(c1, c2, c3, 255), 1, Nametag.Font, "center", "center", false, false, false, true, true)
                        end
                    end
                end
            end
        end
    end
end
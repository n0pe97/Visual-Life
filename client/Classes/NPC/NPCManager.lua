--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 27.11.2019
--|**********************************************************************

NPCManager = inherit(Object)

function NPCManager:constructor()
    self.m_Font = dxCreateFont("res/Fonts/nunito-regular.ttf", 17)

    addEventHandler("onClientRender", root, bind(self.renderNames, self))
    addEventHandler("onClientPedDamage", root, bind(self.cancelDamage, self))
end

function NPCManager:renderNames()
    local px, py, pz = getCameraMatrix()
    for key, value in pairs(getElementsByType("ped")) do
        if value:getData("infoPed") then
            local pos = value:getBonePosition(8)
            local dist = math.sqrt((px - pos.x) ^ 2 + (py - pos.y) ^ 2 + (pz - pos.z) ^ 2)
            if dist <= 15 then
                if isLineOfSightClear(px, py, pz, pos.x, pos.y, pos.z, true, false, false, true, false, false, false, localPlayer) and not localPlayer:getData("clicked") then
                    local sx, sy = getScreenFromWorldPosition(pos.x, pos.y, pos.z + 0.3 + dist * 0.01333)
                    if sx then
                        dxDrawText(string.gsub(value:getData("pedName"), "#%x%x%x%x%x%x", ""), sx - 1, sy - 0, sx - 1, sy, tocolor(25, 29, 32, 255), 1.01, 1.01, self.m_Font, "center", "center", false, false, false, true, true)
                        dxDrawText(string.gsub(value:getData("pedName"), "#%x%x%x%x%x%x", ""), sx - 1, sy - 0, sx - 1, sy, tocolor(25, 29, 32, 255), 1.01, self.m_Font, "center", "center", false, false, false, true, true)
                        dxDrawText(string.gsub(value:getData("pedName"), "#%x%x%x%x%x%x", ""), sx - 1, sy - 0, sx - 1, sy, tocolor(255, 255, 255, 255), 1, self.m_Font, "center", "center", false, false, false, true, true)

                        if value:getData("pedInfo") ~= nil then
                            dxDrawText(string.gsub(loc(value:getData("pedInfo")), "#%x%x%x%x%x%x", ""), sx - 1, sy + 35, sx - 1, sy, tocolor(25, 29, 32, 255), 0.8, 0.8, self.m_Font, "center", "center", false, false, false, true, true)
                            dxDrawText(string.gsub(loc(value:getData("pedInfo")), "#%x%x%x%x%x%x", ""), sx - 1, sy + 35, sx - 1, sy, tocolor(25, 29, 32, 255), 0.8, self.m_Font, "center", "center", false, false, false, true, true)
                            dxDrawText(string.gsub(loc(value:getData("pedInfo")), "#%x%x%x%x%x%x", ""), sx - 1, sy + 35, sx - 1, sy, Settings.Color.Visual, 0.8, self.m_Font, "center", "center", false, false, false, true, true)
                        end
                    end
                end
            end
        elseif value:getData("homelessPed") then
            local pos = value:getBonePosition(8)
            local dist = math.sqrt((px - pos.x) ^ 2 + (py - pos.y) ^ 2 + (pz - pos.z) ^ 2)
            if dist <= 15 then
                if isLineOfSightClear(px, py, pz, pos.x, pos.y, pos.z, true, false, false, true, false, false, false, localPlayer) and not localPlayer:getData("clicked") then
                    local sx, sy = getScreenFromWorldPosition(pos.x, pos.y, pos.z + 0.3 + dist * 0.01333)
                    if sx then
                        dxDrawText("Obdachloser Mann", sx - 1, sy - 0, sx - 1, sy, tocolor(25, 29, 32, 255), 0.81, self.m_Font, "center", "center", false, false, false, true, true)
                        dxDrawText("Obdachloser Mann", sx - 1, sy - 0, sx - 1, sy, tocolor(25, 29, 32, 255), 0.81, self.m_Font, "center", "center", false, false, false, true, true)
                        dxDrawText("Obdachloser Mann", sx - 1, sy - 0, sx - 1, sy, tocolor(255, 255, 255, 255), 0.8, self.m_Font, "center", "center", false, false, false, true, true)
                    end
                end
            end
        end
    end
end

function NPCManager:cancelDamage()
    if source:getData("infoPed") or source:getData("damageProof") or source:getData("infoPed") then
        cancelEvent()
    end
end
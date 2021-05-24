--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 15.12.2019
--|**********************************************************************

Damage = inherit(Object)

function Damage:constructor()
    self.m_WeaponDamages = {
        [0] = true,
        [4] = true,
        [8] = true,
        [22] = true,
        [23] = true,
        [24] = true,
        [25] = true,
        [28] = true,
        [29] = true,
        [32] = true,
        [30] = true,
        [31] = true,
        [33] = true,
        [34] = true,
        [51] = true
    }

    addEventHandler("onClientPlayerDamage", root, bind(self.onDamage, self))
end

function Damage:onDamage(attacker, weapon, bodypart, loss)
    if attacker and weapon and bodypart and loss then
        if attacker == localPlayer then
            if self.m_WeaponDamages[weapon] then
                if localPlayer:getData("hitglocke") == 1 then
                    local sound = playSound("res/Sounds/hitglocke.wav")
                    setSoundVolume(sound, 0.5)
                end

                cancelEvent()
                triggerServerEvent("VL:SERVER:DamageCalculate", source, source, weapon, bodypart, loss)
            end
        elseif source == localPlayer then
            if self.m_WeaponDamages[weapon] then
                cancelEvent()
            end
        end
    end
end
--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 15.12.2019
--|**********************************************************************

Damage = inherit(Object)

addEvent("VL:SERVER:DamageCalculate", true)

function Damage:constructor()
    self.m_WeaponDamages = {
        [0] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5 },
        [4] = { [3] = 10, [4] = 20, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 20 },
        [8] = { [3] = 20, [4] = 20, [5] = 20, [6] = 20, [7] = 20, [8] = 20, [9] = 25 },
        [22] = { [3] = 10, [4] = 10, [5] = 8, [6] = 8, [7] = 8, [8] = 8, [9] = 15 },
        [23] = { [3] = 0, [4] = 0, [5] = 0, [6] = 0, [7] = 0, [8] = 0, [9] = 0 },
        [24] = { [3] = 35, [4] = 35, [5] = 30, [6] = 30, [7] = 30, [8] = 30, [9] = 70 },
        [25] = { [3] = 25, [4] = 25, [5] = 20, [6] = 20, [7] = 20, [8] = 20, [9] = 35 },
        [26] = { [3] = 30, [4] = 30, [5] = 20, [6] = 20, [7] = 20, [8] = 20, [9] = 40 },
        [27] = { [3] = 30, [4] = 30, [5] = 20, [6] = 20, [7] = 20, [8] = 20, [9] = 40 },
        [28] = { [3] = 8, [4] = 8, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 10 },
        [29] = { [3] = 9, [4] = 9, [5] = 8, [6] = 8, [7] = 8, [8] = 8, [9] = 12 },
        [32] = { [3] = 8, [4] = 8, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 10 },
        [30] = { [3] = 10, [4] = 10, [5] = 8, [6] = 8, [7] = 8, [8] = 8, [9] = 14 },
        [31] = { [3] = 9, [4] = 9, [5] = 7, [6] = 7, [7] = 7, [8] = 7, [9] = 12 },
        [33] = { [3] = 15, [4] = 15, [5] = 12, [6] = 12, [7] = 12, [8] = 12, [9] = 20 },
        [34] = { [3] = 15, [4] = 15, [5] = 12, [6] = 12, [7] = 12, [8] = 12, [9] = 200 },
        [35] = { [3] = 80, [4] = 80, [5] = 50, [6] = 50, [7] = 50, [8] = 50, [9] = 130 },
        [36] = { [3] = 80, [4] = 80, [5] = 50, [6] = 50, [7] = 50, [8] = 50, [9] = 130 },
        [37] = { [3] = 8, [4] = 8, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 12 },
        [38] = { [3] = 8, [4] = 8, [5] = 6, [6] = 6, [7] = 6, [8] = 6, [9] = 12 },
        [16] = { [3] = 80, [4] = 80, [5] = 50, [6] = 50, [7] = 50, [8] = 50, [9] = 130 },
        [17] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5 },
        [18] = { [3] = 5, [4] = 5, [5] = 5, [6] = 5, [7] = 5, [8] = 5, [9] = 5 },
        [39] = { [3] = 100, [4] = 100, [5] = 100, [6] = 100, [7] = 100, [8] = 100, [9] = 100 }
    }

    self.m_BodyNames = {
        [3] = "Oberkörper",
        [4] = "Arsch",
        [5] = "Linker Arm",
        [6] = "Rechter Arm",
        [7] = "Linkes Bein",
        [8] = "Rechtes Bein",
        [9] = "Kopf",
    }

    setWeaponProperty("rifle", "pro", "weapon_range", 220)
    setWeaponProperty("rifle", "pro", "target_range", 220)
    setWeaponProperty(34, "pro", "weapon_range", 250)
    setWeaponProperty(34, "pro", "target_range", 250)
    setWeaponProperty(27, "pro", "weapon_range", 300)
    setWeaponProperty(27, "pro", "target_range", 300)
    setWeaponProperty(24, "pro", "weapon_range", 45)
    setWeaponProperty(24, "pro", "target_range", 45)

    setWeaponProperty(22, "pro", "accuracy", 1.25)
    setWeaponProperty(23, "pro", "accuracy", 1.5)
    setWeaponProperty(24, "pro", "accuracy", 0.95)
    setWeaponProperty(27, "pro", "accuracy", 2)
    setWeaponProperty(29, "pro", "accuracy", 1.2)
    setWeaponProperty(30, "pro", "accuracy", 0.6)
    setWeaponProperty(31, "pro", "accuracy", 0.8)
    setWeaponProperty(32, "pro", "accuracy", 1.1)

    addEventHandler("VL:SERVER:DamageCalculate", root, bind(self.calculate, self))
end

function Damage:add(player, amount, attacker, weapon)
    if player and isElement(player) then
        if player:loggedIn() then
            if player:getArmor() > 0 then
                if player:getArmor() >= amount then
                    player:setArmor(player:getArmor() - amount)
                else
                    player:setArmor(0)

                    amount = math.abs(player:getArmor() - amount)
                    player:setHealth(player:getHealth() - amount)

                    if (player:getHealth() - amount) <= 0 then
                        player:kill(attacker, weapon)
                    end
                end
            else
                if (player:getHealth() - amount) <= 0 then
                    player:kill(attacker, weapon)
                end
                player:setHealth(player:getHealth() - amount)
            end
        end
    end
end

function Damage:calculate(target, weapon, bodypart, loss)
    if client and isElement(client) then
        if client:loggedIn() then
            if weapon and bodypart and loss then

                if target:isTazered() then return end

                local damageAmount = self.m_WeaponDamages[weapon] and self.m_WeaponDamages[weapon][bodypart] or 1

                if weapon == 0 then
                    if client:getFightingStyle() == 7 or client:getFightingStyle() == 15 or client:getFightingStyle() == 16 then
                        loss = loss / 2
                    end
                elseif weapon == 23 then
                    StaatAllround:triggerTazer(client, target)
                end

                if Settings.Faction.Evil[client:getData("faction")] or Settings.Faction.Staat[client:getData("faction")] then
                    if (target:getPosition() - client:getPosition()):getLength() > 20 then
                        if client:getData("factionrank") == 5 and weapon == 34 and bodypart == 9 then
                            target:setHeadless(true)
                            target:kill(client, weapon, bodypart)
                            target:sendMessage("Du wurdest gesnipet!", 121, 37, 52)
                        end
                    end
                end

                if damageAmount then
                    self:add(target, damageAmount, client, weapon)
                else
                    self:add(target, loss, client, weapon)
                end

                Logs:output("damage", "%s hat %s %d Schaden mit %s an %s verursacht", client:getName(), target:getName(), damageAmount, getWeaponNameFromID(weapon), self.m_BodyNames[bodypart])
            end
        end
    end
end
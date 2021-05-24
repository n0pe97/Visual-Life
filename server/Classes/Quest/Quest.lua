--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 29.11.2019
--|**********************************************************************

Quest = inherit(Object)

function Quest:constructor()
    self.m_Quests = {
        [1] = { "Willkommen auf Visual Life, schön das du den Weg zu uns gefunden hast. Hole dir etwas Geld von der Bank ab, um das Tutorial zu starten!", "money", 2500 },
        [2] = { "Auf Visual Life wird KOMFORT groß geschrieben. Wir versuchen dir den Aufenthalt so angenehm wie möglich zu gestalten. Begib dich nun zum Fahrzeugverleih am Noobspawn.", "money", 500 },
        [3] = { "Wunderbar, dein Wunschfahrzeug hast du nun. Am besten machst du zuerst deinen Autoführerschein, um keinen Ärger mit der Polizei zu bekommen :)\n Begib dich zur Fahrschule (Doherty, San Fierro)", "money", 12500 },
        [4] = { "Den Führerschein hast du nun, lass uns sehen, ob wir ein passendes Fahrzeug für dich finden. Ich glaube Udo hat noch ein Fahrzeug für dich.\nBegib dich zu Wangcars (Downtown, San Fierro)", "vehicle", 411 },
    }
end

function Quest:loadPlayerQuests(player)
    if player then
        if player:getQuestStep() <= #self.m_Quests then
            self.m_CorrectQuestRewards = {
                ["money"] = "$",
                ["vehicle"] = "Fahrzeug: ",
            }

            if self.m_Quests[player:getQuestStep()][2] == "money" then
                player:triggerEvent("VL:CLIENT:showQuestWindow", player, self.m_Quests[player:getQuestStep()][1], self.m_CorrectQuestRewards[self.m_Quests[player:getQuestStep()][2]], self.m_Quests[player:getQuestStep()][3])
            else
                player:triggerEvent("VL:CLIENT:showQuestWindow", player, self.m_Quests[player:getQuestStep()][1], getVehicleNameFromModel(self.m_Quests[player:getQuestStep()][3]), self.m_CorrectQuestRewards[self.m_Quests[player:getQuestStep()][2]])
            end
        else
            player:triggerEvent("VL:CLIENT:hideQuestWindow", player)
        end
    end
end

function Quest:getMaxQuests()
    return #self.m_Quests
end

function Quest:getReward(id)
    assert(type(id) == "number", "Bad argument @ Quest:getReward #1")
    return self.m_Quests[id][2], self.m_Quests[id][3]
end
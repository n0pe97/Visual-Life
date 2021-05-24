--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 28.12.2019
--|**********************************************************************

EAllround = inherit(Object)

function EAllround:constructor()
    addCommandHandler("g", bind(self.gChat, self))
end

function EAllround:gChat(player, cmd, ...)
    if Settings.Faction.Evil[player:getData("faction")] then
        local text = table.concat({ ... }, " ")
        if text and #text > 0 then
            for key, value in pairs(getElementsByType("player")) do
                if value:loggedIn() then
                    if Settings.Faction.Evil[value:getData("faction")] then
                        value:sendMessage("[%s] %s: %s", 210, 90, 100, Settings.Faction.Names[player:getData("faction")], player:getName(), text)
                    end
                end
            end
        else
            player:sendNotification("Gib einen Text ein!", "error")
        end
    end
end
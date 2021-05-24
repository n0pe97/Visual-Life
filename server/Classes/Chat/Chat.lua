--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

Chat = inherit(Object)

function Chat:constructor()
    addEventHandler("onPlayerChat", root, bind(self.onChat, self))
    addEventHandler("onPlayerPrivateMessage", root, bind(self.onPrivateChat, self))
end

function Chat:onChat(message, messageTyp)
    if source:loggedIn() then
        local sourcePosition = Vector3(source:getPosition())
        local chatSphere = createColSphere(sourcePosition.x, sourcePosition.y, sourcePosition.z, 8)
        local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
        if messageTyp == 0 then
            for _, nearbyPlayer in ipairs(nearbyPlayers) do
                nearbyPlayer:sendMessage("CHAT_MESSAGE", 255, 255, 255,source:getName(), message)
                if isElement(chatSphere) then destroyElement(chatSphere) end
            end
        end
        Logs:output("chat", "%s: %s", source:getName(), message)
    end
    cancelEvent()
end

function Chat:onPrivateChat(msg, target)
    if source:isAdmin(1) then
        if target and target:loggedIn() then
            if target:loggedIn() then
                source:sendMessage("%s --> %s", 200, 255, 0, source:getName(), target:getName())
            end
        end
    else
        cancelEvent()
    end
end
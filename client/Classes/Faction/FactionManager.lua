--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 24.11.2019
--|**********************************************************************

FactionManager = inherit(Object)

function FactionManager:constructor()
end

function FactionManager:getOnlineFactionMembers(id)
    assert(type(id) == "number", "Bad argument @ FactionManager:getFactionMember")
    self.m_Counter = 0
    for key, value in pairs(getElementsByType("player")) do
        if value:getData("loggedin") then
            if value:getData("faction") == id then
                self.m_Counter = self.m_Counter + 1
            end
        end
    end
    return self.m_Counter
end
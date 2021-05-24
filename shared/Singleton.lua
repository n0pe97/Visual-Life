--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

Singleton = {}

function Singleton:getSingleton()
    if not self.ms_Instance then
        self.ms_Instance = self:new()
    end

    return self.ms_Instance
end

function Singleton:new(...)
    -- Rewrite new function
    self.new = function() end
    self.ms_Instance = new(self, ...)

    return self.ms_Instance
end
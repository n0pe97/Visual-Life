--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

Object = {}

function Object:new(...)
    return new(self, ...)
end

function Object:delete(...)
    return delete(self, ...)
end

function Object:load(...)
    return load(self, ...)
end

function Object:getId()
    return self.m_Id
end
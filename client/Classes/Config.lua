--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : revelse
--|* Date              : 22.11.2019
--|**********************************************************************

Config = inherit(Object)

Config.Path = "res/xml/Config.xml"

function Config:constructor()
    self.m_RootNode = false

    if not fileExists(Config.Path) then
        local rootNode = xmlCreateFile(Config.Path, "config")
        xmlSaveFile(rootNode)
        xmlUnloadFile(rootNode)
    end
end

function Config:get(key)
    local mainRoot = xmlLoadFile(Config.Path)
    if mainRoot:findChild(key, 0) then
        local child = (mainRoot:findChild(key, 0)):getValue()
        xmlUnloadFile(mainRoot)
        return child
    end
    xmlUnloadFile(mainRoot)
    return false
end

function Config:set(key, value)
    local mainRoot = xmlLoadFile(Config.Path)
    if mainRoot:findChild(key, 0) then
        (mainRoot:findChild(key, 0)):setValue(value)
    else
        (mainRoot:createChild(key)):setValue(value)
    end
    xmlSaveFile(mainRoot)
    xmlUnloadFile(mainRoot)
end
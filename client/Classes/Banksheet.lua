--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 20.12.2019
--|**********************************************************************

Banksheet = inherit(Object)

addEvent("VL:CLIENT:Banksheet:add", true)

Banksheet.Path = "res/xml/Banksheets.xml"

function Banksheet:constructor()
    self.m_RootNode = false

    if not fileExists(Banksheet.Path) then
        local rootNode = fileCreate(Banksheet.Path)
        fileClose(rootNode)
    end

    addEventHandler("VL:CLIENT:Banksheet:add", root, bind(self.add, self))
end

function Banksheet:get()
    local tbl = {}
    local f = fileOpen(Banksheet.Path)
    local txt = fileRead(f, fileGetSize(f))
    local spl = split(txt, "\n")

    for i, v in ipairs(spl) do
        local s = split(v, "|")
        tbl[#spl - i + 1] = { s[1], s[2], s[3] }
    end

    fileClose(f)

    return tbl
end

function Banksheet:add(key, value)
    local f = fileOpen(Banksheet.Path)
    local filesize = fileGetSize(f)
    fileSetPos(f, filesize)
    local datum = dateString()
    fileWrite(f, datum .. "|" .. value .. "|" .. key .. "\n")
    fileClose(f)
end
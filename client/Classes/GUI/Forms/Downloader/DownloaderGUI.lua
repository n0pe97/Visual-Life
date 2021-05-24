--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

DownloaderGUI = inherit(Object)

addEvent("cdn:receiveContent", true)
addEvent("cdn:receiveFile", true)
addEvent("cdn:onClientReady", true)
addEvent("cdn:hideFleight", true)

function DownloaderGUI:constructor()
    --// Content which the server requires to play
    self.m_HeaderFont = dxCreateFont("res/Fonts/nunito-regular.ttf", 15)
    self.m_Font = dxCreateFont("res/Fonts/nunito-regular.ttf", 11)
    self.m_Counter = 0
    self.m_Max = 0
    self.m_Content = {}
    self.m_Ready = false
    showChat(false)

    addEventHandler("cdn:receiveContent", root, bind(self.receiveContent, self))
    addEventHandler("cdn:receiveFile", root, bind(self.receiveFile, self))
    addEventHandler("cdn:hideFleight", root, bind(self.hideFleight, self))

    --// Rendering stuff
    self.m_Render = bind(self.renderMain, self)
    self.m_ScreenX, self.m_ScreenY = guiGetScreenSize()
    self.m_Width, self.m_Heigth = 700, 10

    --// Request server content
    triggerServerEvent("cdn:requireContent", localPlayer)
end

function DownloaderGUI:receiveContent(list)
    local demanded = {}

    --// Loop through the whole list
    for idx, content in pairs(list) do
        if fileExists(content[1]) then
            local file = fileOpen(content[1], true)
            if file then
                if md5(fileRead(file, fileGetSize(file))) ~= content[2] then
                    self.m_Max = self.m_Max + 1
                    demanded[self.m_Max] = content[1]
                    self._fileSize = fileGetSize(file)
                end

                --// Unreference
                fileClose(file)
            end
        else
            self.m_Max = self.m_Max + 1
            demanded[self.m_Max] = content[1]
        end
    end

    if self.m_Max > 0 then
        --// Launch download progress
        self.m_Content = demanded
        setElementData(getLocalPlayer(), "inDownload", true)
        self.m_Sound = playSound("res/Sounds/intro.mp3", true)
        setSoundVolume(self.m_Sound, 0.5)
        addEventHandler("onClientRender", root, self.m_Render)
        self.m_Fleight = CameraFleight:new(-2053.0390625, 457.4248046875, 50, 0, 1, 130, 180)

        --// Send required list
        triggerServerEvent("cdn:requireFiles", localPlayer, self.m_Content)

    else
        self:setReady()
    end
end

function DownloaderGUI:receiveFile(data, path, counter)
    local file = fileCreate(path)
    if file then
        fileWrite(file, data)

        --// Unreference
        fileClose(file)

        --// Update download progress
        self.m_Counter = counter

        --// Does the player download all files?
        if self.m_Counter == self.m_Max then
            self:setReady()
        else
            --// Request next file
            --// outputChatBox("REQUEST NEXT")
            triggerServerEvent("cdn:requestNextFile", localPlayer, localPlayer)
        end
    end
end

function DownloaderGUI:setReady()
    triggerEvent("cdn:onClientReady", root, resourceRoot)
    removeEventHandler("onClientRender", root, self.m_Render)
    setElementData(getLocalPlayer(), "inDownload", false)
    self.m_Ready = true
    showChat(true)
    triggerServerEvent("VL:SERVER:isRegistered", localPlayer)
end

function DownloaderGUI:getReady()
    return self.m_Ready
end

function DownloaderGUI:renderMain()
    if self.m_Counter > 0 then
        local x, y = self.m_ScreenX / 2 - 500 / 2, self.m_ScreenY / 2 - 160 / 2

        dxDrawRectangle(x, y, 500, 200, tocolor(23, 23, 23, 255))
        dxDrawRectangle(x, y, 500, 50, Settings.Color.Visual)
        dxDrawText("Downloader", x + 25, y + 10, x + 500, 50, Settings.Color.White, 1, self.m_HeaderFont)

        dxDrawText("File: " .. self.m_Counter .. "/" .. self.m_Max, x + 25, y + 70, x + 500, 50, Settings.Color.White, 1, self.m_Font)
        dxDrawText("Path: " .. self.m_Content[self.m_Counter], x + 25, y + 95, x + 500, 50, Settings.Color.White, 1, self.m_Font)

        dxDrawRectangle(x + 25, y + 125, 450, 40, tocolor(29, 29, 29, 255))
        dxDrawRectangle(x + 27, y + 127, (self.m_Counter * (444)) / self.m_Max, 36, Settings.Color.Visual)
    end
end

function DownloaderGUI:hideFleight()
    if self.m_Fleight then self.m_Fleight:hide() end
    if isElement(self.m_Sound) then self.m_Sound:destroy() end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    downloadmanager = DownloaderGUI:new()
end)

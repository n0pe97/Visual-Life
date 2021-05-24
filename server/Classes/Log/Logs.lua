--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

Logs = inherit(Object)

function Logs:constructor()
    self.m_AllLogs = {}
    self.m_saveTime = 20

    addCommandHandler("saveLogs", bind(self.saveLogs, self))

    addEventHandler("onResourceStop", resourceRoot, bind(self.saveLogs, self))

    setTimer(bind(self.saveLogs, self), self.m_saveTime * 60000, 0)
end

function Logs:output(type, text, ...)
    self.m_AllLogs[#self.m_AllLogs + 1] = { type, getTimestamp(), (text):format(...) }

    Database:exec("CREATE TABLE IF NOT EXISTS ?? (time VARCHAR(255), text VARCHAR(255))  ENGINE=INNODB", "log_" .. type)
end

function Logs:saveLogs(player)
    if player and isElement(player) then
        if player:isAdmin(5) then
            for i = 1, #self.m_AllLogs do
                Database:exec("INSERT INTO ?? (??, ??) VALUE (?, ?)", "log_" .. self.m_AllLogs[i][1], "time", "text", self.m_AllLogs[i][2], self.m_AllLogs[i][3])
            end
            self.m_AllLogs = {}
            player:sendNotification("Logs saved!", "info")
        end
    else
        for i = 1, #self.m_AllLogs do
            Database:exec("INSERT INTO ?? (??, ??) VALUE (?, ?)", "log_" .. self.m_AllLogs[i][1], "time", "text", self.m_AllLogs[i][2], self.m_AllLogs[i][3])
        end
        self.m_AllLogs = {}
    end
end
--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

Player = inherit(Object)

registerElementClass("player", Player)

addEvent("VL:SERVER:registerAccount", true)
addEvent("VL:SERVER:checkPassword", true)

function Player:constructor()
    self.m_PaydayTimer = {}
    self.m_PlayerDatas = {
        "uid", "playtime", "money", "bankmoney", "skinid", "faction", "factionrank", "job",
        "level", "adminlevel", "wanteds", "stvo", "spawnX", "spawnY", "spawnZ", "spawnRot", "spawnInt", "spawnDim",
        "hungry", "jailtime", "phonenumber", "language", "quest", "hitglocke", "housekey", "bonus", "jobMoney", "maxvehicles", "lastlogin"
    }

    self.m_PlayerLicenses = {
        "carlicense", "planelicense", "bikelicense", "helicopterlicense", "boatlicense", "weaponlicense",
    }

    self.m_AvailableSkins = {
        2, 7, 14, 15, 17, 18, 19, 20, 21, 22, 23, 24, 25,
        26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 51,
        52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 72, 78, 79, 80, 81, 82, 83, 84,
        94, 95, 96, 97, 98, 99, 101, 108, 109, 110, 128, 132, 133, 134, 135, 136,
        137, 143, 153, 154, 155, 156, 158, 159, 160, 161, 162, 167, 168, 170, 171,
        176, 177, 180, 182, 183, 184, 185, 189, 200, 202, 203, 204, 206, 209, 210,
        212, 213, 217, 221, 222, 223, 227, 228, 229, 230, 234, 235, 236, 239, 241,
        242, 249, 252, 253, 255, 258, 259, 261, 262, 269, 270, 271, 291, 302,
        303, 306, 307, 310
    }

    self.m_FactionMoneyTable = {
        [0] = 1000,
        [1] = 1450,
        [2] = 1900,
        [3] = 2350,
        [4] = 2800,
        [5] = 3250
    }

    addEventHandler("VL:SERVER:registerAccount", self, bind(self.registerAccount, self))
    addEventHandler("VL:SERVER:checkPassword", self, bind(self.checkPassword, self))
    addEventHandler("onPlayerQuit", self, bind(self.saveAllDatas, self))
end

function Player:setAllDatas()
    local data = self:receiveDatas("userdata", "serial", self:getSerial(), "uid")
    self:setId(data)

    for key, value in pairs(self.m_PlayerDatas) do
        self:setData(value, self:receiveDatas("userdata", "serial", self:getSerial(), value))
    end

    for key, value in pairs(self.m_PlayerLicenses) do
        self:setData(value, self:receiveDatas("licenses", "uid", self:getId(), value))
    end

    for _, stat in ipairs({ 69, 70, 71, 72, 73, 74, 76, 77, 78, 79 }) do
        setPedStat(self, stat, 1000)
    end

    self:triggerEvent("cdn:hideFleight", self)
    self:setSpawn()
    self:setLoggedIn()
    self:paydayTimer()
end

function Player:logIn()
    self:setAllDatas()
end

function Player:registerAccount(passwd, lang)
    local query = Database:query("SELECT * FROM userdata WHERE serial = ?", self:getSerial())
    if query then
        local result = Database:poll(query, -1)
        if #result == 0 then
            if Utils:isNameAvailable(self:getName()) then
                local rndm = math.random(1, #self.m_AvailableSkins)
                Database:exec("INSERT INTO userdata (username, password, serial, money, bankmoney, skinid, spawnX, spawnY, spawnZ, spawnRot, phonenumber, language) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    self:getName(), hash("sha512", passwd), self:getSerial(), "2500", "15000", self.m_AvailableSkins[rndm], "-2052.69531", "458.28101", "35.17188", "320", math.random(100000, 999999), lang)

                local data = self:receiveDatas("userdata", "serial", self:getSerial(), "uid")
                self:setId(data)

                Database:exec("INSERT INTO licenses (uid) VALUES (?)", self:getId())

                self:triggerEvent("VL:CLIENT:closeRegister", self)
                self:sendNotification("REGISTER_SUCCESS", "success")
                self:setAllDatas()
            else
                self:sendNotification("REGISTER_ERROR", "error")
            end
        else
            self:sendNotification("REGISTER_ERROR", "error")
        end
    end
end

function Player:checkPassword(password, autologin)
    if password then
        local dbPassword = self:receiveDatas("userdata", "serial", client:getSerial(), "password")
        local dbUsername = self:receiveDatas("userdata", "serial", client:getSerial(), "username")
        if client:getName() == dbUsername then
            if password == dbPassword then
                if autologin then client:triggerEvent("VL:CLIENT:changeAutoLogin", client, password) end
                client:logIn()
                client:triggerEvent("VL:CLIENT:closeLogin", client)
            else
                client:sendNotification("LOGIN_WINDOW_WRONG_PASSWORD", "error")
            end
        else
            client:kick(("Your already have an account named: %s"):format(dbUsername))
        end
    end
end

function Player:setSpawn()
    self:setAlpha(100)
    self:spawn(self:getData("spawnX") + math.random(0.5, 2), self:getData("spawnY") + math.random(0.5, 2), self:getData("spawnZ"), self:getData("spawnRot"), self:getData("skinid"), self:getData("spawnInt"), self:getData("spawnDim"))
    self:setCameraTarget(self)
    self:fadeCamera(true)

    Timer(function(p) if p then p:setAlpha(255) end end, 3000, 1, self)
end

function Player:setLoggedIn()
    self:setData("loggedin", true)
    Quest:loadPlayerQuests(self)
    self:triggerEvent("VL:CLIENT:showHUD", self)
    self:sendNotification("LOGIN_SUCESS", "success")
    self:setFactionSkin()
    self:setAfk(false)
    self:setData("vehicleslots", self:getVehicles())

    PlayerManager:giveLoginInfos(self)

    Database:exec("UPDATE userdata SET lastlogin=? WHERE uid=?", dateString(), self:getId())

    bindKey(self, "X", "down", bind(VehicleManager.startMotor, self))
    bindKey(self, "L", "down", bind(VehicleManager.switchLight, self))

    print(("%s hat sich erfolgreich eingeloggt!"):format(self:getName()))
end

function Player:receiveDatas(from, where, name, data)
    self.m_Query = Database:query("SELECT * FROM ?? WHERE ?? = ?", from, where, name)
    if self.m_Query then
        self.m_Result = Database:poll(self.m_Query, -1)
        for _, v in pairs(self.m_Result) do
            return v[data]
        end
    end
end

function Player:tryToGetLocalization(string)
    local tryResult = loc(string, self)
    if tryResult == string then
        return string
    else
        return tryResult
    end
end

function Player:sendMessage(msg, r, g, b, ...)
    local msg = self:tryToGetLocalization(msg)
    self:outputChat((msg):format(...), r or 255, g or 255, b or 255, true)
end

function Player:sendNotification(msg, type, ...)
    local msg = self:tryToGetLocalization(msg)
    self:triggerEvent("VL:CLIENT:sendNotification", self, (msg):format(...), type)
end

function Player:sendHint(msg, ...)
    local msg = self:tryToGetLocalization(msg)
    self:outputChat(loc("NOTIFICATION_TIP", self) .. (msg:format(...)), 255, 255, 255, true)
end

function Player:setAdmin(rank)
    assert(type(rank) == "number", "Bad argument @ Player:setAdmin")
    self:setData("adminlevel", tonumber(rank))
end

function Player:isAdmin(rank)
    assert(type(rank) == "number", "Bad argument @ Player:getAdmin")
    if self:loggedIn() then
        if self:getData("adminlevel") >= rank then
            return true
        else
            return false
        end
    end
end

function Player:paydayTimer()
    if not isTimer(self.m_PaydayTimer[self]) then
        self.m_PaydayTimer[self] = Timer(function(self)
            self:payday()
        end, 60000, 0, self)
    end
end

function Player:payday()
    if self:loggedIn() then
        if not self:isAfk() then
            self:setData("playtime", self:getData("playtime") + 1)

            if self:getData("jailtime") > 0 then
                self:setData("jailtime", self:getData("jailtime") - 1)
            end

            if math.floor(self:getData("playtime") / 60) == self:getData("playtime") / 60 then
                self.m_PaydayTable = {}

                if self:getData("jobMoney") then
                    table.insert(self.m_PaydayTable, { name = "Gehalt", hex = Utils:getHex(self:getData("jobMoney")), amount = self:getData("jobMoney"), alpha = 220 })
                    self.m_JobMoney = self:getData("jobMoney")
                end

                if self:getData("faction") > 0 then
                    table.insert(self.m_PaydayTable, { name = "Fraktion", hex = Utils:getHex(self.m_FactionMoneyTable[self:getData("factionrank")]), amount = self.m_FactionMoneyTable[self:getData("factionrank")], alpha = 240 })
                    self.m_FactionMoney = self.m_FactionMoneyTable[self:getData("factionrank")]
                else
                    table.insert(self.m_PaydayTable, { name = "Hartz IV", hex = Utils:getHex(450), amount = 450, alpha = 240 })
                    self.m_FactionMoney = 450
                end

                if self:getData("housekey") > 0 then
                    table.insert(self.m_PaydayTable, { name = "Hauskasse", hex = Utils:getHex(0), amount = 0, alpha = 220 })
                    self.m_HouseDepot = 0
                elseif self:getData("housekey") < 0 then
                    table.insert(self.m_PaydayTable, { name = "Miete", hex = Utils:getHex(0), amount = 0, alpha = 220 })
                    self.m_Rent = 0
                else
                    table.insert(self.m_PaydayTable, { name = "Miete", hex = Utils:getHex(0), amount = 0, alpha = 240 })
                    self.m_Rent = 0
                end

                if self:getData("bankmoney") then
                    self.m_BankTax = self:getData("bankmoney") * 0.01
                    if self.m_BankTax > 5000 then
                        self.m_BankTax = 5000
					else
						self.m_BankTax = math.floor(self.m_BankTax)
                    end
                    table.insert(self.m_PaydayTable, { name = "Zinsen", hex = Utils:getHex(self.m_BankTax), amount = self.m_BankTax, alpha = 240 })
                end

                if self:getVehicles() then
                    table.insert(self.m_PaydayTable, { name = "Fahrzeugsteuern", hex = Utils:getHex(-self:getVehicles() * 250), amount = -self:getVehicles() * 250, alpha = 220 })
                    self.m_VehicleTax = (-self:getVehicles() * 250)
                end

                if self:getData("bonus") then
                    table.insert(self.m_PaydayTable, { name = "Bonus", hex = Utils:getHex(self:getData("bonus")), amount = self:getData("bonus"), alpha = 240 })
                    self.m_BonusMoney = self:getData("bonus")
                end

                if self.m_HouseDepot then
                    self.m_HouseDepot = self.m_HouseDepot
                else
                    self.m_HouseDepot = 0
                end

                if self.m_Rent then
                    self.m_Rent = self.m_Rent
                else
                    self.m_Rent = 0
                end

                self.m_TotalMoney = (self.m_JobMoney + self.m_FactionMoney + self.m_BankTax + self.m_BonusMoney + self.m_HouseDepot + self.m_VehicleTax + self.m_Rent)

                self:giveMoney(self.m_TotalMoney, "Payday")

                self:setData("bonus", 0)
                self:setData("jobMoney", 0)

                self:triggerEvent("VL:CLIENT:PaydayGUI:activate", self, self.m_PaydayTable, self.m_TotalMoney)
            end
        end
    end
end

function Player:giveMoney(amount, reason)
    assert(type(amount) == "number", "Bad argument @ Player:giveMoney")
    self:setData("bankmoney", self:getData("bankmoney") + amount)
    self:triggerEvent("VL:CLIENT:Banksheet:add", self, reason, "+ " .. comma_value(amount) .. "€")
end

function Player:takeMoney(amount, reason)
    assert(type(amount) == "number", "Bad argument @ Player:takeMoney")
    self:setData("bankmoney", self:getData("bankmoney") - amount)
    self:triggerEvent("VL:CLIENT:Banksheet:add", self, reason, "- " .. comma_value(amount) .. "€")
end

function Player:giveCash(amount, reason)
    assert(type(amount) == "number", "Bad argument @ Player:giveCash")
    self:setData("money", self:getData("money") + amount)
end

function Player:takeCash(amount, reason)
    assert(type(amount) == "number", "Bad argument @ Player:takeCash")
    self:setData("money", self:getData("money") - amount)
end

function Player:getId()
    return self:getData("uid")
end

function Player:setId(uid)
    uid = tonumber(uid)
    self:setData("uid", uid)
end

function Player:loggedIn()
    if self:getData("loggedin") then
        return true
    else
        return false
    end
end

function Player:isDuty()
    if self:getData("duty") then
        return true
    else
        return false
    end
end

function Player:getQuestStep()
    return tonumber(self:getData("quest"))
end

function Player:setQuestStep(step)
    assert(type(step) == "number", "Bad argument @ Player:setQuestStep #1")
    if self:getQuestStep() == step then
        local rewardItem, rewardAmount = Quest:getReward(step)
        if rewardItem and rewardAmount then
            if rewardItem == "money" then
                self:sendNotification("QUEST_REWARD_MONEY", "info", rewardAmount)
                self:giveCash(rewardAmount, "Questreward")

                Logs:output("quest", "%s hat die Quest %d beendet und hat %d€ bekommen", self:getName(), step, rewardAmount)
            else
                self:sendNotification("QUEST_REWARD_VEHICLE", "info", getVehicleNameFromModel(rewardAmount))

                Logs:output("quest", "%s hat die Quest %d beendet und hat das Fahrzeug %s bekommen", self:getName(), step, getVehicleNameFromModel(rewardAmount))
            end
        end

        self:setData("quest", self:getData("quest") + 1)
        Quest:loadPlayerQuests(self)
    end
end

function Player:doWarp(x, y, z, rotZ, int, dim)
    self:fadeCamera(false, 1, 0, 0, 0)

    Timer(function(player, x, y, z, rotZ, int, dim)
        if player and isElement(player) then
            player:fadeCamera(true)
            player:setPosition(x, y, z)
            player:setRotation(0, 0, rotZ)
            player:setInterior(int)
            player:setDimension(dim)
        end
    end, 1000, 1, self, x, y, z, rotZ, int, dim)
end

function Player:setFactionSkin()
    assert(type(self) == "userdata", "Bad argument @ Player:setFactionSkin #1")
    FactionManager:setFactionSkin(self)
end

function Player:addWanteds(amount)
    assert(type(amount) == "number", "Bad argument @ Player:addWanteds #1")
    self:setData("wanteds", self:getData("wanteds") + amount)
end

function Player:removeWanteds(amount)
    assert(type(amount) == "number", "Bad argument @ Player:removeWanteds #1")
    if self:getWanteds() - amount >= 0 then
        self:setData("wanteds", self:getData("wanteds") - amount)
    else
        self:setData("wanteds", 0)
    end
end

function Player:getWanteds()
    return self:getData("wanteds")
end

function Player:addStvo(amount)
    assert(type(amount) == "number", "Bad argument @ Player:addStvo #1")
    if self:getStvo() + amount <= 15 then
        self:setData("stvo", self:getData("stvo") + amount)
    else
        self:setData("stvo", 15)
    end
end

function Player:removeStvo(amount)
    assert(type(amount) == "number", "Bad argument @ Player:removeStvo #1")
    if self:getStvo() - amount >= 0 then
        self:setData("stvo", self:getData("stvo") - amount)
    else
        self:setData("stvo", 0)
    end
end

function Player:getStvo()
    return self:getData("stvo")
end

function Player:setTazered()
    self:setData("tazered", true)
    self:setAnimation("crack", "crckidle2")
    toggleAllControls(self, false, true, false)
    Timer(bind(self.unTazer, self), 10000, 1)
end

function Player:unTazer()
    if self:isTazered() then
        self:setData("tazered", false)
        self:setAnimation()
        toggleAllControls(self, true)
    end
end

function Player:isTazered()
    return self:getData("tazered")
end

function Player:isLeashed()
    return self:getData("leashed")
end

function Player:exitVehicle()
    if self:isInVehicle() then
        setControlState(self, "enter_exit", true)
    end
end

function Player:addBonus(amount)
    self:setData("bonus", self:getData("bonus") + math.floor(amount))
end

function Player:addJobMoney(amount)
    self:setData("jobMoney", self:getData("jobMoney") + math.floor(amount))
end

function Player:isAfk()
    return self:getData("afk")
end

function Player:setAfk(boolean)
    assert(type(boolean) == "boolean", "Bad argument @ Player:setAfk #1")
    self:setData("afk", boolean)
end

function Player:getVehicles()
    local counter = 0
    for key, value in pairs(getElementsByType("vehicle")) do
        if value:getOwner() == self:getId() then
            counter = counter + 1
        end
    end
    return counter
end

function Player:saveAllDatas()
    for key, value in pairs(self.m_PlayerDatas) do
        Database:exec("UPDATE ?? SET ?? = ? WHERE ?? = ?", "userdata", value, self:getData(value), "uid", self:getData("uid"))
    end

    for key, value in pairs(self.m_PlayerLicenses) do
        Database:exec("UPDATE ?? SET ?? = ? WHERE ?? = ?", "licenses", value, self:getData(value), "uid", self:getData("uid"))
    end

    if isTimer(self.m_PaydayTimer[self]) then self.m_PaydayTimer[self]:destroy() end
end

function Player:destructor()
end
--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 23.11.2019
--|***********************************************************************

HeadUpDisplayGUI = inherit(Object)

addEvent("VL:CLIENT:showQuestWindow", true)
addEvent("VL:CLIENT:hideQuestWindow", true)
addEvent("VL:CLIENT:showHUD", true)

function HeadUpDisplayGUI:constructor()
    self.m_PlayerX, self.m_PlayerY = guiGetScreenSize()
    self.m_QuestText = ""
    self.m_SmoothHealth = 0
    self.m_SmoothArmor = 0
    self.m_SmoothFood = 0
    self.m_SmoothSprint = 0
    self.m_SmoothMoney = 0
    self.m_Debounce = false
    self.m_IsMoving = false
    self.m_StartTick = 0
    self.m_Duration = 500
    self.m_EndTick = nil
    self.m_Sprinting = 1500
    self.m_Font = dxCreateFont("res/Fonts/nunito-regular.ttf", 12)
    self.m_MoneyFont = dxCreateFont("res/Fonts/nunito-regular.ttf", 15)

    self.m_HUDRender = bind(self.draw, self)
    self.m_QuestRender = bind(self.drawQuest, self)

    setPlayerHudComponentVisible("all", false)
    setPlayerHudComponentVisible("crosshair", true)
    setPlayerHudComponentVisible("radar", true)

    addEventHandler("VL:CLIENT:showQuestWindow", root, bind(self.showQuestWindow, self))
    addEventHandler("VL:CLIENT:hideQuestWindow", root, bind(self.hideQuestWindow, self))
    addEventHandler("VL:CLIENT:showHUD", root, bind(self.show, self))

    bindKey("B", "down", bind(self.move, self))
end

function HeadUpDisplayGUI:move()
    if not self.m_IsMoving then
        self.m_Debounce = not self.m_Debounce
        self.m_StartTick = getTickCount()
        self.m_EndTick = self.m_StartTick + self.m_Duration
        self.m_IsMoving = not self.m_IsMoving
        Timer(function() self.m_IsMoving = not self.m_IsMoving end, self.m_Duration, 1)
    end
end

function HeadUpDisplayGUI:getDate()
    local regtime = getRealTime()
    local year = regtime.year + 1900
    local month = regtime.month + 1
    local day = regtime.monthday
    return tostring((day > 9 and day or "0" .. day) .. "." .. (month > 9 and month or "0" .. month) .. "." .. year)
end

function HeadUpDisplayGUI:getTime()
    local regtime = getRealTime()
    local hour = regtime.hour
    if hour == 24 then hour = 0 end
    local minute = regtime.minute
    return tostring((hour > 9 and hour or "0" .. hour) .. ":" .. (minute > 9 and minute or "0" .. minute))
end

function HeadUpDisplayGUI:draw()
    if localPlayer:loggedIn() then
        if not localPlayer:clicked() then
            self.m_CurrentTick = getTickCount()
            self.m_ProgressMove = (self.m_CurrentTick - self.m_StartTick) / self.m_Duration
            self.m_NewPosition = self.m_PlayerX - 484

            if not self.m_Debounce then
                self.m_QuestPosition = interpolateBetween(self.m_PlayerX, 0, 0, self.m_PlayerX - 484, 0, 0, self.m_ProgressMove, "InQuad")
            else
                self.m_QuestPosition = interpolateBetween(self.m_PlayerX - 484, 0, 0, self.m_PlayerX, 0, 0, self.m_ProgressMove, "OutQuad")
            end

            --> Background
            dxDrawImage(self.m_NewPosition, 10, 474, 186, "res/Images/GUI/HUD/background.png")

            --> Armor
            self.m_PlayerArmor = localPlayer:getArmor()
            if self.m_SmoothArmor > self.m_PlayerArmor then
                self.m_SmoothArmor = self.m_SmoothArmor - 1
            end
            if self.m_SmoothArmor < self.m_PlayerArmor then
                self.m_SmoothArmor = self.m_SmoothArmor + 1
            end
            self.m_ArmorProgress = (self.m_SmoothArmor / 100) * 318
            dxDrawImageSection(self.m_NewPosition + 142, 26, self.m_ArmorProgress, 30, 0, 0, self.m_ArmorProgress, 30, "res/Images/GUI/HUD/armor.png", 0, 0, 0, tocolor(255, 255, 255), false)
            dxDrawText(math.ceil(self.m_SmoothArmor) .. " %", self.m_NewPosition, 40, self.m_NewPosition + 400, 40, tocolor(255, 255, 255, 255), 1, self.m_Font, "center", "center", false, false, false, true)
            dxDrawImage(self.m_NewPosition + 155, 35, 13, 13, "res/Images/GUI/HUD/armor_icon.png")

            --> Health
            self.m_PlayerHealth = localPlayer:getHealth()
            if self.m_SmoothHealth > self.m_PlayerHealth then
                self.m_SmoothHealth = self.m_SmoothHealth - 1
            end
            if self.m_SmoothHealth < self.m_PlayerHealth then
                self.m_SmoothHealth = self.m_SmoothHealth + 1
            end
            self.m_HealthProgress = (self.m_SmoothHealth / 100) * 318
            dxDrawImageSection(self.m_NewPosition + 142, 67, self.m_HealthProgress, 30, 0, 0, self.m_HealthProgress, 30, "res/Images/GUI/HUD/health.png", 0, 0, 0, tocolor(255, 255, 255), false)
            dxDrawText(math.ceil(self.m_SmoothHealth) .. " %", self.m_NewPosition, 81, self.m_NewPosition + 400, 81, tocolor(255, 255, 255, 255), 1, self.m_Font, "center", "center", false, false, false, true)
            dxDrawImage(self.m_NewPosition + 155, 75, 13, 13, "res/Images/GUI/HUD/health_icon.png")

            --> Food & Sprint
            if getPedMoveState(localPlayer) == "sprint" or getPedMoveState(localPlayer) == "jump" then
                if self.m_Sprinting > 0 then
                    self.m_Sprinting = self.m_Sprinting - 1
                else
                    triggerServerEvent("toggleServersideControl", localPlayer, "sprint", false)
                    triggerServerEvent("toggleServersideControl", localPlayer, "jump", false)
                end
            else
                if self.m_Sprinting < 1500 then
                    self.m_Sprinting = self.m_Sprinting + 1
                    if self.m_Sprinting > 1125 then
                        triggerServerEvent("toggleServersideControl", localPlayer, "sprint", true)
                        triggerServerEvent("toggleServersideControl", localPlayer, "jump", true)
                    end
                end
            end

            if self.m_Sprinting > 1125 then
                self.m_PlayerFood = localPlayer:getData("hungry")
                self.m_Path = "res/Images/GUI/HUD/food.png"
                self.m_IconPath = "res/Images/GUI/HUD/food_icon.png"

                if self.m_SmoothFood > self.m_PlayerFood then
                    self.m_SmoothFood = self.m_SmoothFood - 1
                end

                if self.m_SmoothFood < self.m_PlayerFood then
                    self.m_SmoothFood = self.m_SmoothFood + 1
                end

                self.m_FoodSprintProgress = (self.m_SmoothFood / 100) * 318

                dxDrawImageSection(self.m_NewPosition + 142, 108, self.m_FoodSprintProgress, 30, 0, 0, self.m_FoodSprintProgress, 30, self.m_Path, 0, 0, 0, tocolor(255, 255, 255), false)
                dxDrawText(math.ceil(self.m_SmoothFood) .. " %", self.m_NewPosition, 122, self.m_NewPosition + 400, 122, tocolor(255, 255, 255, 255), 1, self.m_Font, "center", "center", false, false, false, true)
                dxDrawImage(self.m_NewPosition + 155, 116, 13, 13, self.m_IconPath)
            else
                self.m_PlayerSprint = self.m_Sprinting / 15
                self.m_Path = "res/Images/GUI/HUD/sprint.png"
                self.m_IconPath = "res/Images/GUI/HUD/sprint_icon.png"

                if self.m_SmoothSprint > self.m_PlayerSprint then
                    self.m_SmoothSprint = self.m_PlayerSprint
                end

                if self.m_SmoothSprint < self.m_PlayerSprint then
                    self.m_SmoothSprint = self.m_PlayerSprint
                end

                self.m_FoodSprintProgress = (self.m_SmoothSprint / 100) * 318

                dxDrawImageSection(self.m_NewPosition + 142, 108, self.m_FoodSprintProgress, 30, 0, 0, self.m_FoodSprintProgress, 30, self.m_Path, 0, 0, 0, tocolor(255, 255, 255), false)
                dxDrawText(math.ceil(self.m_SmoothSprint) .. " %", self.m_NewPosition, 122, self.m_NewPosition + 400, 122, tocolor(255, 255, 255, 255), 1, self.m_Font, "center", "center", false, false, false, true)
                dxDrawImage(self.m_NewPosition + 155, 116, 13, 13, self.m_IconPath)
            end

            --> Weapon
            self.m_PlayerWeaponID = localPlayer:getWeapon()
            self.m_PlayerWeaponslot = localPlayer:getWeaponSlot()
            self.m_PlayerClip = localPlayer:getAmmoInClip(self.m_PlayerWeaponslot)
            self.m_PlayerClip1 = localPlayer:getTotalAmmo(self.m_PlayerWeaponslot)
            dxDrawImage(self.m_NewPosition + 15, 25, 90, 90, tostring("res/Images/GUI/HUD/Weapons/" .. self.m_PlayerWeaponID .. ".png"), 0, 0, 0, tocolor(255, 255, 255, 255))
            if self.m_PlayerClip == 0 and self.m_PlayerClip1 == 1 then
                dxDrawText("Melee", self.m_NewPosition, 128, self.m_NewPosition + 118, 128 + 24, tocolor(255, 255, 255, 255), 1, self.m_Font, "center", "center")
            else
                dxDrawText(self.m_PlayerClip .. "|" .. self.m_PlayerClip1, self.m_NewPosition, 128, self.m_NewPosition + 115, 128 + 24, tocolor(255, 255, 255, 255), 1, self.m_Font, "center", "center")
            end

            --> Date
            self.m_Date = self:getDate()
            dxDrawText(self.m_Date, self.m_NewPosition + 33, 167, self.m_NewPosition + 33, 167 + 24, tocolor(255, 255, 255, 255), 1, self.m_Font, "left", "center")
            dxDrawImage(self.m_NewPosition + 10, 171, 14, 15, "res/Images/GUI/HUD/calendar.png")

            --> Time
            self.m_Time = self.getTime()
            dxDrawText(self.m_Time .. " Uhr", self.m_NewPosition + 160, 166, self.m_NewPosition + 160, 166 + 24, tocolor(255, 255, 255, 255), 1, self.m_Font, "left", "center")
            dxDrawImage(self.m_NewPosition + 135, 171, 15, 15, "res/Images/GUI/HUD/time.png")

            --> Location
            self.m_City = getZoneName(Vector3(localPlayer:getPosition()), true)
            self.m_Location = getZoneName(Vector3(localPlayer:getPosition()), false)

            if self.m_Location == "Unknown" and self.m_City == "Unknown" then
                self.m_ZoneName = "Unknown location"
            else
                self.m_ZoneName = self.m_Location .. ", " .. self.m_City
            end

            dxDrawText(self.m_ZoneName, self.m_NewPosition + 435, 166, self.m_NewPosition + 435, 166 + 24, tocolor(255, 255, 255, 255), 1, self.m_Font, "right", "center")
            dxDrawImage(self.m_NewPosition + 445, 171, 15, 15, "res/Images/GUI/HUD/location.png")

            --> Money
            self.m_PlayerMoney = localPlayer:getData("money")
            if self.m_PlayerMoney ~= self.m_SmoothMoney then
                if self.m_PlayerMoney < self.m_SmoothMoney then
                    local moneydiff = self.m_SmoothMoney - self.m_PlayerMoney
                    local abzug = math.ceil(moneydiff / 100)
                    self.m_SmoothMoney = self.m_SmoothMoney - abzug
                else
                    local moneydiff = self.m_PlayerMoney - self.m_SmoothMoney
                    local abzug = math.ceil(moneydiff / 100)
                    self.m_SmoothMoney = self.m_SmoothMoney + abzug
                end
            end
            dxDrawImage(self.m_NewPosition + 5, 205, 28, 28, "res/Images/GUI/HUD/money.png")
            dxDrawText(loc("HUD_MONEY"):format(comma_value(self.m_SmoothMoney)), self.m_NewPosition + 45, 206, self.m_NewPosition - 352 + 355, 206 + 24, tocolor(255, 255, 255, 255), 1, self.m_MoneyFont, "left", "center")

            --> Wanteds
            self.m_PlayerWanteds = localPlayer:getData("wanteds")
            for i = 1, 6 do
                dxDrawImage((self.m_NewPosition + 200) + (40 * i), 200, 34, 31, "res/Images/GUI/HUD/Wanteds/wanted_inactive.png", 0, 0, 0, tocolor(255, 255, 255, 200))
            end

            if self.m_PlayerWanteds > 0 then
                for i = 1, self.m_PlayerWanteds do
                    dxDrawImage((self.m_NewPosition + 200) + (40 * i), 200, 34, 31, "res/Images/GUI/HUD/Wanteds/wanted_active.png", 0, 0, 0, tocolor(255, 255, 255, 200))
                end
            end

            --> AFK
            if localPlayer:getData("afk") then
                dxDrawRectangle(self.m_NewPosition, 250, 474, 35, tocolor(120, 0, 0, 200))
                dxDrawText("Du befindest dich im AFK Modus", self.m_NewPosition, 435, self.m_NewPosition + 474, 98, tocolor(255, 255, 255, 255), 1, self.m_Font, "center", "center")
            end

            --> Jailtime
            if localPlayer:getData("jailtime") > 0 then
                dxDrawRectangle(self.m_NewPosition, 300, 474, 35, tocolor(20, 20, 20, 200))
                dxDrawText(loc("HUD_JAILTIME_TEXT"):format(localPlayer:getData("jailtime")), self.m_NewPosition, 485, self.m_NewPosition + 474, 148, tocolor(255, 255, 255, 255), 1, self.m_Font, "center", "center")
            end
        end
    end
end

function HeadUpDisplayGUI:hide()
    removeEventHandler("onClientRender", root, self.m_HUDRender)
    removeEventHandler("onClientRender", root, self.m_QuestRender)
end

function HeadUpDisplayGUI:show()
    addEventHandler("onClientRender", root, self.m_HUDRender)
    addEventHandler("onClientRender", root, self.m_QuestRender)
end

function HeadUpDisplayGUI:drawQuest()
    if not localPlayer:clicked() then
        if self.m_QuestText ~= "" and self.m_QuestPosition then
            local offsetHeight = dxGetTextWidth(self.m_QuestText) / 400
            dxDrawRectangle(self.m_QuestPosition, screenHeight / 2 - (197 / 2), 474, 197 + 10 * offsetHeight / 2, tocolor(23, 23, 23, 255))
            dxDrawRectangle(self.m_QuestPosition, screenHeight / 2 - (197 / 2), 474, 47, Settings.Color.Visual)
            dxDrawText("Quest", self.m_QuestPosition, screenHeight / 2 - (197 / 2), self.m_QuestPosition + 474, screenHeight / 2 - (197 / 2) + 47, tocolor(255, 255, 255, 255), 1, self.m_MoneyFont, "center", "center")
            dxDrawRectangle(self.m_QuestPosition + 20, screenHeight / 2 - (197 / 2) + 67, 434, 107 + 10 * offsetHeight / 2, tocolor(29, 29, 29, 255))
            dxDrawText(self.m_QuestText .. "\nReward: (" .. self.m_QuestAmount .. self.m_QuestReward .. ")", self.m_QuestPosition + 60, screenHeight / 2 + 20 * offsetHeight / 2, self.m_QuestPosition + 424, screenHeight / 2 + 20 * offsetHeight / 2, tocolor(255, 255, 255, 255), 1, self.m_Font, "center", "center", false, true)
        end
    end
end

function HeadUpDisplayGUI:showQuestWindow(questText, reward, amount)
    self:hideQuestWindow()
    self.m_QuestText = questText
    self.m_QuestReward = reward
    self.m_QuestAmount = amount
    if self.m_QuestText ~= "" and self.m_QuestPosition then
        addEventHandler("onClientRender", root, self.m_QuestRender)
    end
end

function HeadUpDisplayGUI:hideQuestWindow()
    if self.m_QuestText ~= "" then
        removeEventHandler("onClientRender", root, self.m_QuestRender)
    end
end
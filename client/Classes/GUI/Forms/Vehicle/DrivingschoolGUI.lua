--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 18.12.2019
--|**********************************************************************

DrivingschoolGUI = inherit(Object)

addEvent("VL:CLIENT:DrivingschoolGUI:show", true)
addEvent("VL:CLIENT:DrivingschoolGUI:startLesson", true)
addEvent("VL:CLIENT:DrivingschoolGUI:destroyStuff", true)

function DrivingschoolGUI:constructor()
    self.m_WindowWidth = 600 * (screenWidth / 1920)
    self.m_WindowHeight = 350 * (screenHeight / 1080)
    self.m_WindowX, self.m_WindowY = screenWidth / 2 - self.m_WindowWidth / 2, screenHeight / 2 - self.m_WindowHeight / 2

    self.m_MarkerCount = 0

    self.m_Spawns = {
        ["carlicense"] = {
            { -1995.015625, -72.26953125, 34.5055809021, "checkpoint", 4 },
            { -1801.47265625, -130.7412109375, 5.3070006370544, "checkpoint", 4 },
            { -1831.9638671875, -575.2392578125, 16.275196075439, "checkpoint", 4 },
            { -2275.3642578125, -188.138671875, 34.746814727783, "checkpoint", 4 },
            { -2385.697265625, -68.083984375, 34.735980987549, "checkpoint", 4 },
            { -2498.853515625, -55.1953125, 25.049654006958, "checkpoint", 4 },
            { -2514.626953125, 41.443359375, 24.310503005981, "checkpoint", 4 },
            { -2601.896484375, 52.4091796875, 3.7524385452271, "checkpoint", 4 },
            { -2620.138671875, 159.7255859375, 3.7395942211151, "checkpoint", 4 },
            { -2704.1015625, 171.40234375, 3.7372758388519, "checkpoint", 4 },
            { -2693.193359375, 215.5634765625, 3.7484481334686, "checkpoint", 4 },
            { -2385.7646484375, 502.44140625, 28.787721633911, "checkpoint", 4 },
            { -2229.015625, 494.6630859375, 34.581275939941, "checkpoint", 4 },
            { -2274.0244140625, 380.0517578125, 33.82462310791, "checkpoint", 4 },
            { -2236.763671875, 317.9033203125, 34.732189178467, "checkpoint", 4 },
            { -2008.2919921875, 306.2734375, 34.438999176025, "checkpoint", 4 },
            { -2020.8798828125, -67.80078125, 34.746162414551, "checkpoint", 4 },
            { -2046.6845703125, -92.095703125, 34.726940155029, "checkpoint", 4 },
        },
        ["bikelicense"] = {
            { -1995.015625, -72.26953125, 34.5055809021, "checkpoint", 4 },
            { -1801.47265625, -130.7412109375, 5.3070006370544, "checkpoint", 4 },
            { -1831.9638671875, -575.2392578125, 16.275196075439, "checkpoint", 4 },
            { -2275.3642578125, -188.138671875, 34.746814727783, "checkpoint", 4 },
            { -2385.697265625, -68.083984375, 34.735980987549, "checkpoint", 4 },
            { -2498.853515625, -55.1953125, 25.049654006958, "checkpoint", 4 },
            { -2514.626953125, 41.443359375, 24.310503005981, "checkpoint", 4 },
            { -2601.896484375, 52.4091796875, 3.7524385452271, "checkpoint", 4 },
            { -2620.138671875, 159.7255859375, 3.7395942211151, "checkpoint", 4 },
            { -2704.1015625, 171.40234375, 3.7372758388519, "checkpoint", 4 },
            { -2693.193359375, 215.5634765625, 3.7484481334686, "checkpoint", 4 },
            { -2385.7646484375, 502.44140625, 28.787721633911, "checkpoint", 4 },
            { -2229.015625, 494.6630859375, 34.581275939941, "checkpoint", 4 },
            { -2274.0244140625, 380.0517578125, 33.82462310791, "checkpoint", 4 },
            { -2236.763671875, 317.9033203125, 34.732189178467, "checkpoint", 4 },
            { -2008.2919921875, 306.2734375, 34.438999176025, "checkpoint", 4 },
            { -2020.8798828125, -67.80078125, 34.746162414551, "checkpoint", 4 },
            { -2046.6845703125, -92.095703125, 34.726940155029, "checkpoint", 4 },
        },
        ["planelicense"] = {
            { -1513.6926269531, -25.541143417358, 72.68872833252, "ring", 4 },
            { -1013.6392822266, 504.8219909668, 141.30000305176, "ring", 4 },
            { -978.69647216797, 678.34234619141, 91.450759887695, "ring", 4 },
            { -667.83343505859, 863.02038574219, 224.86357116699, "ring", 4 },
            { -273.40802001953, 787.01080322266, 184.9462890625, "ring", 4 },
            { -1654.1771240234, -161.7660369873, 14.1484375, "ring", 4 },
        },
        ["helicopterlicense"] = {
            { -1513.6926269531, -25.541143417358, 72.68872833252, "ring", 4 },
            { -1013.6392822266, 504.8219909668, 141.30000305176, "ring", 4 },
            { -978.69647216797, 678.34234619141, 91.450759887695, "ring", 4 },
            { -667.83343505859, 863.02038574219, 224.86357116699, "ring", 4 },
            { -273.40802001953, 787.01080322266, 184.9462890625, "ring", 4 },
            { -1654.1771240234, -161.7660369873, 14.1484375, "ring", 4 },
        },
        ["boatlicense"] = {
            { -1590.2855224609, 240.48188781738, -0.55000001192093, "checkpoint", 4 },
            { -1386.7816162109, 266.3313293457, -0.55000001192093, "checkpoint", 4 },
            { -1234.6623535156, 383.83032226563, -0.55000001192093, "checkpoint", 4 },
            { -1209.7481689453, 674.76947021484, -0.55000001192093, "checkpoint", 4 },
            { -1345.4038085938, 1028.6354980469, -0.55000001192093, "checkpoint", 4 },
            { -1421.8055419922, 1248.8492431641, -0.55000001192093, "checkpoint", 4 },
            { -1658.3822021484, 247.34547424316, -0.55000001192093, "checkpoint", 4 },
        },
    }

    addEventHandler("VL:CLIENT:DrivingschoolGUI:show", root, bind(self.show, self))
    addEventHandler("VL:CLIENT:DrivingschoolGUI:startLesson", root, bind(self.startLesson, self))
    addEventHandler("VL:CLIENT:DrivingschoolGUI:destroyStuff", root, bind(self.destroyStuff, self))
end

function DrivingschoolGUI:show(row, tbl)
    if not localPlayer:clicked() then
        self.m_Window = GUIWindow:new(self.m_WindowX, self.m_WindowY, self.m_WindowWidth, self.m_WindowHeight, loc("DRIVINGSCHOOL_HEADER"), Settings.Color.Visual, false, true, true)
        self.m_Grid = GUIGridlist:new(25 * screenWidth / 1920, 90 * screenHeight / 1080, self.m_WindowWidth - 50, self.m_WindowHeight - 160, Settings.Color.Visual, row, tbl, self.m_Window)
        self.m_StartButton = GUIButton:new(25 * screenWidth / 1920, 295 * screenHeight / 1080, 250, 40, loc("DRIVINGSCHOOL_START"), Settings.Color.Visual, self.m_Window)
        self.m_CloseButton = GUIButton:new(325 * screenWidth / 1920, 295 * screenHeight / 1080, 250, 40, loc("DRIVINGSCHOOL_CLOSE"), Settings.Color.Visual, self.m_Window)
        GUILabel:new(25 * screenWidth / 1920, 60 * screenHeight / 1080, 250, 20, loc("DRIVINGSCHOOL_CHOOSE"), Settings.Color.White, 1.2, self.m_Window)

        self.m_StartButton.onLeftClickDown = bind(self.check, self)
        self.m_CloseButton.onLeftClickDown = bind(self.close, self)
    end
end

function DrivingschoolGUI:check()
    if self.m_Grid:getSelectedRow(1) then
        triggerServerEvent("VL:SERVER:Drivingschool:check", localPlayer, self.m_Grid:getSelectedRow(1), self.m_Grid:getSelectedRow(2))
        self:close()
    else
        localPlayer:sendNotification("DRIVINGSCHOOL_CHOOSE_LICENSE", "error")
    end
end

function DrivingschoolGUI:startLesson(license, dim)
    assert(type(license) == "string", "Bad argument @ DrivingschoolGUI:startLesson #1")
    assert(type(dim) == "number", "Bad argument @ DrivingschoolGUI:startLesson #2")

    self:createMarker(license, dim)
end

function DrivingschoolGUI:createMarker(license, dim)
    self.m_License = license
    self.m_Dimension = dim
    self.m_MarkerCount = self.m_MarkerCount + 1

    if isElement(self.m_LessonMarker) then self.m_LessonMarker:destroy() end
    if isElement(self.m_LessonBlip) then self.m_LessonBlip:destroy() end

    if self.m_MarkerCount <= #self.m_Spawns[self.m_License] then
        self.m_LessonMarker = Marker(self.m_Spawns[self.m_License][self.m_MarkerCount][1], self.m_Spawns[self.m_License][self.m_MarkerCount][2], self.m_Spawns[self.m_License][self.m_MarkerCount][3], self.m_Spawns[self.m_License][self.m_MarkerCount][4], self.m_Spawns[self.m_License][self.m_MarkerCount][5], 255, 0, 0)
        self.m_LessonBlip = createBlipAttachedTo(self.m_LessonMarker)

        self.m_LessonMarker:setDimension(self.m_Dimension)
        self.m_LessonBlip:setDimension(self.m_Dimension)

        addEventHandler("onClientMarkerHit", self.m_LessonMarker, bind(self.onHit, self))
    else
        triggerServerEvent("VL:SERVER:Drivingschool:giveLicense", localPlayer, self.m_License)
    end
end

function DrivingschoolGUI:onHit(element, dim)
    if element == localPlayer and dim then
        self:createMarker(self.m_License, self.m_Dimension)
    end
end

function DrivingschoolGUI:destroyStuff()
    if isElement(self.m_LessonMarker) then self.m_LessonMarker:destroy() end
    if isElement(self.m_LessonBlip) then self.m_LessonBlip:destroy() end

    self.m_License = nil
    self.m_Dimension = nil
    self.m_MarkerCount = 0
end

function DrivingschoolGUI:close()
    self.m_Window:close()
end
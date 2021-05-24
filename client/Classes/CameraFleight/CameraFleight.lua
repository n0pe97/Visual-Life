--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 16.12.2019
--|**********************************************************************

CameraFleight = inherit(Object)

function CameraFleight:constructor(posX, posY, posZ, width, circle, radius, rotation)
    self.m_PositionX = posX
    self.m_PositionY = posY
    self.m_PositionZ = posZ
    self.m_Width = width
    self.m_Circle = circle
    self.m_Radius = radius
    self.m_Rotation = rotation

    self.m_Render = bind(self.render, self)

    self:show()
end

function CameraFleight:show()
    fadeCamera(true)
    addEventHandler("onClientRender", root, self.m_Render)
end

function CameraFleight:hide()
    removeEventHandler("onClientRender", root, self.m_Render)
    delete(self)
end

function CameraFleight:render()
    self.m_Width = self.m_Width + 0.001
    local x = self.m_PositionX + math.cos(self.m_Width + (1 * self.m_Circle)) * self.m_Radius
    local y = self.m_PositionY + math.sin(self.m_Width + (1 * self.m_Circle)) * self.m_Radius
    setCameraMatrix(x, y, self.m_Rotation, self.m_PositionX, self.m_PositionY, self.m_PositionZ)
end
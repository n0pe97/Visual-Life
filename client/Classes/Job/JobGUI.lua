--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 04.01.2020
--|**********************************************************************

JobGUI = inherit(Object)

addEvent("VL:CLIENT:JobGUI:show", true)

function JobGUI:constructor()

    addEventHandler("VL:CLIENT:JobGUI:show", root, bind(self.show, self))
end

function JobGUI:show(jobName)
    self.m_JobName = jobName
    print(self.m_JobName)
end
--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

Core = inherit(Object)

function Core:constructor()
    print("Loading clientside-core...")

    core = self

    enew(localPlayer, LocalPlayer)

    config = Config:new()
    banksheet = Banksheet:new()
    GUIRenderer:new()
    GUIWindowFocusManager:new()
    GUICursor:new()
    Interaction:new()

    VehicleManager = VehicleManager:new()

    Localization:new()
    NPCManager:new()
    Damage:new()
    Nametag:new()

    FactionManager = FactionManager:new()

    --> GUI
    PaydayGUI:new()
    CarhouseGUI:new()
    LoginGUI:new()
    RegisterGUI:new()
    ScoreboardGUI:new()
    HUD = HeadUpDisplayGUI:new()
    BankGUI:new()
    VehicleGUI:new()
    VehiclerentGUI:new()
    DrivingschoolGUI:new()
    DutyGUI:new()
    SpeedoGUI:new()

    --> JOB
    JobGUI:new()
    Bus:new()


    local language = config:get("language")
    if not language then
        config:set("language", "EN")
    end

    local autologin = config:get("autologin")
    if not autologin then
        config:set("autologin", "0")
    end

    local hitglocke = config:get("hitglocke")
    if not hitglocke then
        config:set("hitglocke", "0")
    end

    print("Clientside-Core has been loaded.")
end

function Core:destructor()
    -- Release GUI system
    delete(GUIRenderer:getSingleton())
    delete(GUIWindowFocusManager:getSingleton())
    delete(GUICursor:getSingleton())
    GUIInput.destructor()

    delete(config)
end
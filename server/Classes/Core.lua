--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 22.11.2019
--|**********************************************************************

Core = inherit(Object)

function Core:constructor()
    print("Loading serverside-core...")

    core = self

    Database = Database:new()
    Logs = Logs:new()
    Utils = Utils:new()

    VehicleManager = VehicleManager:new()
    FactionVehicleClass = FactionVehicleClass:new()
    Quest = Quest:new()
    AdminManager = AdminManager:new()
    FactionManager = FactionManager:new()
    Business = Business:new()
    Garage = Garage:new()
    Tiefgarage = Tiefgarage:new()
    House = House:new()

    Localization:new()
    PlayerManager:new()
    NPCManager:new()
    Chat:new()
    Bank:new()
    PayNSpray:new()
    Carhouse:new()
    Marker:new()
    Damage:new()
    Vehiclerent:new()
    Drivingschool:new()
    Gasstation:new()

    --> Faction
    StaatAllround = SAllround:new()
    EvilAllround = EAllround:new()
    SFPD:new()
    Mechanic:new()

    --> JOB
    Bus:new()

    print("Serverside-Core has been loaded.")
end

function Core:destructor()

end
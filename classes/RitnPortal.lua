-- RitnPortal
----------------------------------------------------------------
local class = require(ritnlib.defines.class.core)
----------------------------------------------------------------
local pattern = "([^-]*)~?([^-]*)~?([^-]*)"
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
local RitnPortal = class.newclass(function(base, LuaEntity)
    if LuaEntity == nil then return end
    if LuaEntity.valid == false then return end
    if LuaEntity.object_name ~= "LuaEntity" then return end
    if LuaEntity.name ~= ritnlib.defines.portal.names.entity.portal then return end
    base.object_name = "RitnPortal"
    --------------------------------------------------
    log('> '..base.object_name..'() -> init ok !')
    base.entity = LuaEntity
    base.surface = LuaEntity.surface
    base.force = LuaEntity.force
    base.position = LuaEntity.position
    base.drive = LuaEntity.get_driver()
    ----
    base.name = LuaEntity.name
    base.id = LuaEntity.unit_number
    ----
    local surfaces = remote.call("RitnCoreGame", "get_surfaces")
    base.data = surfaces[base.surface.name].portals[base.id]
    --------------------------------------------------
end)
----------------------------------------------------------------


function RitnPortal:exist()
    if self.entity == nil then return false end 
    if self.name ~= ritnlib.defines.portal.names.entity.portal then return false end
    if self.data == nil then return false end

    return true
end

----------------------------------------------------------------
return RitnPortal
-- MODULE : SURFACE
---------------------------------------------------------------------------------------------



-- Suppresion d'une surface
local function on_pre_surface_deleted(e) 
    if storage.portal.modules.portal == false then return end
    local rEvent = RitnCoreEvent(e)
    RitnPortalSurface(rEvent.surface):delete()
end



---------------------------------------------------------------------------------------------
local module = {events = {}}
---------------------------------------------------------------------------------------------
module.events[defines.events.on_pre_surface_deleted] = on_pre_surface_deleted
---------------------------------------------------------------------------------------------
return module
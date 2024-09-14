-- MODULE : PORTAL
---------------------------------------------------------------------------------------------


-- Ouverture de l'interface RitnGuiPortal
local function on_gui_opened(e)
    if global.portal.modules.portal == false then return end
    local rPortal = RitnPortalPortal(RitnCoreEvent(e).entity)
    if rPortal ~= nil and rPortal:exist() then 
        RitnGuiPortal(e):action_open(rPortal)
    end
end



-- Déclenche les action selon le clique dans l'interface RitnGuiPortal
local function on_gui_click(e)
    if global.portal.modules.portal == false then return end
    RitnGuiPortal(e):on_gui_click()
end



-- Déclenche les actions selon le changement dans une liste de sélection de l'interface RitnGuiPortal
local function on_gui_selection_state_changed(e)
    if global.portal.modules.portal == false then return end
    RitnGuiPortal(e):on_gui_selection_state_changed()
end


---------------------------------------------------------------------------------------------
local module = {events = {}}
---------------------------------------------------------------------------------------------
module.events[defines.events.on_gui_opened] = on_gui_opened
module.events[defines.events.on_gui_click] = on_gui_click
module.events[defines.events.on_gui_selection_state_changed] = on_gui_selection_state_changed
---------------------------------------------------------------------------------------------
return module
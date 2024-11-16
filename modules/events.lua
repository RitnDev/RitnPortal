---------------------------------------------------------------------------------------------
-- EVENTS
---------------------------------------------------------------------------------------------  
local function on_init_mod(event)
    log('RitnPortal -> on_init !')
    ---------------------------------------------
    remote.call("RitnCoreGame", "init_data", "portal", {
        id = 0,         -- unit_number
        type = "player",
        destination = {
            id_portal = -1,
            surface = "",
        },
        request = "",
        surface_name = "",
        force_name = "",
        entity_type = "car",
        position = {x=0, y=0},
        render_id = -1,
        tag_number = -1,
        index = 0,
    })
    remote.call("RitnCoreGame", "init_data", "portal_request", {
        id = 0,         -- unit_number
        type = "player",
        surface_name = "",
    })
    remote.call("RitnCoreGame", "init_data", "portal_requester", {
        input = {},
        output = {},
    })
    remote.call("RitnCoreGame", "add_param_data", "surface", "portals", {})
    local options = remote.call("RitnCoreGame", "get_options")
    options.portal = {
        linkable = {},
        linked = {},
        requests = {},
    }
    remote.call("RitnCoreGame", "set_options", options)
    -------------------------------------------------------------
    log('on_init : RitnPortal -> finish !')
end

local function on_configuration_changed()
    log("on_configuration_changed()")
end


local function customInput_close_frame(event)
    remote.call("RitnPortal", "gui_action_portal", 
    ritnlib.defines.portal.gui_actions.portal.close, event)
end

---------------------------------------------------------------------------------------------
local module = {events = {}}
---------------------------------------------------------------------------------------------
-- event : custom-input
--module.events[ritnlib.defines.teleporter.names.customInput.frame_close1] = customInput_close_frame
--module.events[ritnlib.defines.teleporter.names.customInput.frame_close2]= customInput_close_frame
-------------------------------------------
module.on_init = on_init_mod
module.on_configuration_changed = on_configuration_changed
-------------------------------------------
return module
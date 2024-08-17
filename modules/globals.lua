---------------------------------------------------------------------------------------------
-- GLOBALS
---------------------------------------------------------------------------------------------
if global.portal == nil then
    global.portal = { 
        modules = {
            player = true,
            portal = true,
        },
        gui = {
            portal = require(ritnlib.defines.portal.gui.portal),
        },
        tileNoPortal = {
            ["out-of-map"] = true,
            ["deepwater"] = true,
            ["deepwater-green"] = true,
        }
    }
end
---------------------------------------------------------------------------------------------
-- REMOTE FUNCTIONS INTERFACE
---------------------------------------------------------------------------------------------
local stringUtils = require(ritnlib.defines.constants).strings
---------------------------------------------------------------------------------------------
local portal_interface = {
    ["gui_action_portal"] = function(action, event)
        if action == ritnlib.defines.portal.gui_actions.portal.open then 
            RitnGuiPortal(event):action_open()
        elseif action == ritnlib.defines.portal.gui_actions.portal.close then 
            RitnGuiPortal(event):action_close()
        elseif action == ritnlib.defines.portal.gui_actions.portal.list_select_change then 
            local rGuiPortal = RitnGuiPortal(event)
            local list = rGuiPortal.element
            rGuiPortal:selectListSurfacesChange(list)
        elseif action == ritnlib.defines.portal.gui_actions.portal.button_close then 
            RitnGuiPortal(event):action_close()
        elseif action == ritnlib.defines.portal.gui_actions.portal.button_request then 
            RitnGuiPortal(event):action_request()
        elseif action == ritnlib.defines.portal.gui_actions.portal.button_unrequest then 
            RitnGuiPortal(event):action_unrequest()
        elseif action == ritnlib.defines.portal.gui_actions.portal.button_link then 
            RitnGuiPortal(event):action_link()
        elseif action == ritnlib.defines.portal.gui_actions.portal.button_unlink then 
            RitnGuiPortal(event):action_unlink()
        end
    end,

    -- fermer un RitnGuiPortal pour un joueur et un portail précis
    ['gui_portal_close_filter'] = function(player_index, id_portal)
        local rGuiPortal = RitnGuiPortal({ player_index = player_index })
        -- on vérifie que l'id correspond à l'interface que l'on souhaite fermer
        if id_portal == rGuiPortal:getId() then 
            rGuiPortal:action_close()
        end
    end,

    --disable modules
    ["disable.module.player"] = function()
        global.portal.modules.player = false
    end,
    ["disable.module.portal"] = function()
        global.portal.modules.portal = false
    end,

    ["get_gui_portal"] = function()
        return global.portal.gui.portal
    end,
    -- create portal gui
    ["create_portal_gui"] = function(gui_start, elements) 
        local content = {}
        
        content["start"] = gui_start
    
        for i, element in pairs(elements) do 
            log("> add GuiElement : ".. element.name .. stringUtils.special["right-arrow-decorator"] .. element.parent)
            content[element.name] = content[element.parent].add(element.gui)
        end

        return content
    end
}

remote.add_interface("RitnPortal", portal_interface)
---------------------------------------------------------------------------------------------
return {}
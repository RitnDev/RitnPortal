---------------------------------------------------------------------------------------------
-- GLOBALS
---------------------------------------------------------------------------------------------
if global.portal == nil then
    global.portal = { 
        modules = {
            player = true,
            portal = true,
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
local RitnGuiPortal = require(ritnlib.defines.portal.class.guiPortal)
---------------------------------------------------------------------------------------------
local portal_interface = {
    ["gui_action_portal"] = function(action, event)
        if action == ritnlib.defines.portal.gui_actions.portal.open then 
            RitnGuiTeleporter(event):action_open()
        elseif action == ritnlib.defines.portal.gui_actions.portal.close then 
            RitnGuiTeleporter(event):action_close()
        elseif action == ritnlib.defines.portal.gui_actions.portal.teleport then 
            RitnGuiTeleporter(event):action_teleport()
        elseif action == ritnlib.defines.portal.gui_actions.portal.valid then 
            RitnGuiTeleporter(event):action_valid()
        elseif action == ritnlib.defines.portal.gui_actions.portal.edit then 
            RitnGuiTeleporter(event):action_edit()
        elseif action == ritnlib.defines.portal.gui_actions.portal.up then 
            RitnGuiTeleporter(event):action_up()
        elseif action == ritnlib.defines.portal.gui_actions.portal.down then 
            RitnGuiTeleporter(event):action_down()
        end
    end,
    --disable modules
    ["disable.module.player"] = function()
        global.portal.modules.player = false
    end,
    ["disable.module.portal"] = function()
        global.portal.modules.portal = false
    end,
}

remote.add_interface("RitnPortal", portal_interface)
---------------------------------------------------------------------------------------------
return {}
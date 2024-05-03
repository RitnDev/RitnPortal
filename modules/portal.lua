-- MODULE : TELEPORTER
---------------------------------------------------------------------------------------------
local RitnEvent = require(ritnlib.defines.core.class.event)
local RitnSurface = require(ritnlib.defines.portal.class.surface)
local RitnPortal = require(ritnlib.defines.portal.class.portal)
local RitnGuiPortal = require(ritnlib.defines.portal.class.guiPortal)
---------------------------------------------------------------------------------------------



local function on_player_driving_changed_state(e)
    if global.portal.modules.portal == false then return end
    local rEvent = RitnEvent(e)
    local rPlayer = rEvent:getPlayer()

    local LuaEntity = rEvent.entity 

    if LuaEntity then 
        local rPortal = RitnPortal(LuaEntity)
        if rPortal then 
            
            local driving = false
            if rPlayer.driving and rPortal.drive ~= nil then
                if rPortal.drive.name == rPlayer.name then 
                    driving = true
                elseif rPortal.drive.type == "character" then 
                    if rPortal.drive.player.name == rPlayer.name then 
                        driving = true
                    end
                end
            end

            if rPortal:exist() then 
                if driving then 
                    RitnGuiPortal(e):action_open(rPortal)
                else
                    RitnGuiPortal(e):action_close()
                end
            end
        end
    end
end


local function on_gui_opened(e)
    if global.portal.modules.portal == false then return end
    local rPortal = RitnPortal(RitnEvent(e).entity)
    if rPortal:exist() then 
        RitnGuiPortal(e):action_open(rPortal)
    end
end


local function on_gui_click(e)
    if global.portal.modules.portal == false then return end
    RitnGuiPortal(e):on_gui_click()
end


---------------------------------------------------------------------------------------------
local module = {events = {}}
---------------------------------------------------------------------------------------------
module.events[defines.events.on_player_driving_changed_state] = on_player_driving_changed_state
module.events[defines.events.on_gui_opened] = on_gui_opened
module.events[defines.events.on_gui_click] = on_gui_click
---------------------------------------------------------------------------------------------
return module
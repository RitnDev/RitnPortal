-- MODULE : PLAYER
---------------------------------------------------------------------------------------------
local util = require(ritnlib.defines.other)
---------------------------------------------------------------------------------------------

local function on_player_changed_surface(e)
    local rEvent = RitnCoreEvent(e)
    local rPlayer = RitnCoreEvent(e):getPlayer()

    if string.sub(rPlayer.surface.name, 1, string.len(rEvent.prefix_lobby)) ~= rEvent.prefix_lobby then
        RitnPortalSurface(rPlayer.surface):setupPortalSystem()
    end
end



local function on_player_used_capsule(e)
    if global.portal.modules.player == false then return end
    local rEvent = RitnCoreEvent(e)
    local rPlayer = rEvent:getPlayer()
    RitnPortalSurface(rPlayer.surface):createPortal(rEvent)
end



local function on_player_cursor_stack_changed(e) 
    if global.portal.modules.player == false then return end
    local rPlayer = RitnCoreEvent(e):getPlayer()
    rPlayer:clearCursor(ritnlib.defines.portal.names.item.capsule, ritnlib.defines.portal.names.caption.msg.cursor)
end



-- On retire un portail de la surface (minage)
local function on_player_mined_entity(e)
    if global.portal.modules.player == false then return end
    local rEvent = RitnCoreEvent(e)
    local LuaEntity = rEvent.entity 
    RitnPortalSurface(LuaEntity.surface):removePortal(rEvent)

    -- On actualise le RitnGuiPortal s'il y en a un d'ouvert
    local rPlayer = rEvent:getPlayer()
    local LuaEntity = rPlayer.vehicle 

    if LuaEntity then 
        local rPortal = RitnPortalPortal(LuaEntity)
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

            if driving then 
                if rPortal:exist() then 
                    RitnGuiPortal(e):action_open(rPortal)
                end
            end
        end
    end

end


-- On rentre dans le portail t-elle un vehicule
local function on_player_driving_changed_state(e) 
    if global.portal.modules.player == false then return end
    local rEvent = RitnCoreEvent(e)
    local rPlayer = rEvent:getPlayer()
    local LuaEntity = rEvent.entity 

    if LuaEntity then 
        -- On récupère l'objet RitnPortal à partir de l'entité (event)
        local rPortal = RitnPortalPortal(LuaEntity)

        if rPortal ~= nil or rPortal:exist() then -- si l'objet est bien un RitnPortal et non nil
            rPortal:teleport(rPlayer.player)
        end
        
    end

    RitnGuiPortal(rEvent.event):action_close()
end


---------------------------------------------------------------------------------------------
local module = {events = {}}
---------------------------------------------------------------------------------------------
-- Events Player
module.events[defines.events.on_player_changed_surface] = on_player_changed_surface
module.events[defines.events.on_player_cursor_stack_changed] = on_player_cursor_stack_changed
module.events[defines.events.on_player_used_capsule] = on_player_used_capsule
module.events[defines.events.on_player_mined_entity] = on_player_mined_entity
module.events[defines.events.on_player_driving_changed_state] = on_player_driving_changed_state
---------------------------------------------------------------------------------------------
return module
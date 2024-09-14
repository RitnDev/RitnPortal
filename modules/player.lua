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

    if rPlayer.player.cursor_stack.count == 0 then return end
    
    local LuaItemStack = rPlayer.player.cursor_stack
    if LuaItemStack == nil then return end
    if LuaItemStack.valid == false then return end

    if LuaItemStack.name == ritnlib.defines.portal.names.item.capsule then 
        -- Ne rien faire s'il est sur Nauvis ou sur sa map d'origine
        if (rPlayer:isOwner() and rPlayer:isOrigine()) or rPlayer:onNauvis() then return end 

        rPlayer.player.clear_cursor()
        log('player.clear_cursor()')

        util.tryCatch(
            function() 
                rPlayer.player.print(ritnlib.defines.portal.names.caption.msg.cursor)
            end
        )
    end

end


-- On rentre dans le portail t-elle un vehicule
local function on_player_driving_changed_state(e) 
    if global.portal.modules.player == false then return end
    local rEvent = RitnCoreEvent(e)
    local rPlayer = rEvent:getPlayer()
    local LuaEntity = rEvent.entity 

    -- si le joueur vient de sortir d'un vehicule, il n'y a rien à faire
    if rPlayer.player.driving == false then return end 

    if LuaEntity then 
        -- On récupère l'objet RitnPortal à partir de l'entité (event)
        local rPortal = RitnPortalPortal(LuaEntity)

        if rPortal ~= nil or rPortal:exist() then -- si l'objet est bien un RitnPortal et non nil

            -- le joueur n'est pas sur sa surface d'origine
            -- le joueur est sur la surface actuelle
            -- la surface d'origine est la destination du portail en suppression
            if ((rPlayer:isOrigine()) or 
                (rPlayer:getOrigine() == rPortal:getDestination())) then 
                    rPortal:teleport(rPlayer.player)
            else
                rPlayer.player.driving = false
            end
            
        end
        
    end

    RitnGuiPortal(rEvent.event):action_close()
end

---------------------------------------------------------------------------------------------
local module = {events = {}}
---------------------------------------------------------------------------------------------
-- events filters
--module.set_events_filters = set_events_filters
---------------------------------------------------------------------------------------------
-- Events Player
module.events[defines.events.on_player_changed_surface] = on_player_changed_surface
module.events[defines.events.on_player_cursor_stack_changed] = on_player_cursor_stack_changed
module.events[defines.events.on_player_used_capsule] = on_player_used_capsule
module.events[defines.events.on_player_driving_changed_state] = on_player_driving_changed_state
---------------------------------------------------------------------------------------------
return module
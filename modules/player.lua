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
    log("On retire un portail de la surface")
    
    -- on capture l'event pour tranformer en RitnEvent
    local rEvent = RitnCoreEvent(e)
    -- on récupère l'entité de l'event
    local LuaEntity = rEvent.entity 
    -- suppression du portail de la surface (dans les datas)
    local rSurface, id_portal, destination = RitnPortalSurface(LuaEntity.surface):removePortal(rEvent)

    -- on récupère la listes des joueurs et on boucle sur chacun
    local players = remote.call('RitnCoreGame', 'get_players')
    for _,player in pairs(players) do 
        remote.call('RitnPortal', 'gui_portal_close_filter', player.index, LuaEntity.unit_number)
        remote.call('RitnPortal', 'gui_portal_close_filter', player.index, id_portal)
    end


    --[[
    
    X il faut gerer le cas où l'un des joueurs est morts (dans le jeu). -> repose du portail

        passer LuaPlayer.ticks_to_respawn => nil = réapparition direct (pour tp direct)

    X il faut fermer les GUI des joueurs pour le portail miné (si ouvert).
    - il faut téléporter les joueurs qui ne proviennent pas de cette surface.

    - uniquement le propriétaire qui peux miné le portail, sinon on doit reconstruire le portail au meme endroit
    ]]
    
 

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


local function set_events_filters()
    script.set_event_filter(defines.events.on_player_mined_entity, {
        {filter = "type", type = "car"},
        {filter = "name", name = ritnlib.defines.portal.names.entity.portal}
    })
end

---------------------------------------------------------------------------------------------
local module = {events = {}}
---------------------------------------------------------------------------------------------
-- events filters
module.set_events_filters = set_events_filters
---------------------------------------------------------------------------------------------
-- Events Player
module.events[defines.events.on_player_changed_surface] = on_player_changed_surface
module.events[defines.events.on_player_cursor_stack_changed] = on_player_cursor_stack_changed
module.events[defines.events.on_player_used_capsule] = on_player_used_capsule
module.events[defines.events.on_player_mined_entity] = on_player_mined_entity
module.events[defines.events.on_player_driving_changed_state] = on_player_driving_changed_state
---------------------------------------------------------------------------------------------
return module
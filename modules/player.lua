-- MODULE : PLAYER
---------------------------------------------------------------------------------------------
local RitnEvent = require(ritnlib.defines.core.class.event)
local RitnSurface = require(ritnlib.defines.portal.class.surface)
local RitnPortal = require(ritnlib.defines.portal.class.portal)
local RitnGuiPortal = require(ritnlib.defines.portal.class.guiPortal)
---------------------------------------------------------------------------------------------


local function on_player_used_capsule(e)
    if global.portal.modules.player == false then return end
    local rEvent = RitnEvent(e)
    local rPlayer = rEvent:getPlayer()
    RitnSurface(rPlayer.surface):createPortal(rEvent)
end



local function on_player_cursor_stack_changed(e) 
    if global.portal.modules.player == false then return end
    local rEvent = RitnEvent(e)
    local rPlayer = rEvent:getPlayer()

    if rPlayer == nil then return end
    if rPlayer.player.cursor_stack.count == 0 then return end
    
    local LuaItemStack = rPlayer.player.cursor_stack
    if LuaItemStack == nil then return end
    if LuaItemStack.valid == false then return end
    
    if LuaItemStack.name == ritnlib.defines.portal.names.item.capsule then 
        local players = remote.call("RitnCoreGame", "get_players")
        if rPlayer.player.surface.name == players[rPlayer.player.index].origine or "nauvis" then return end 
        if rPlayer.player.cursor_stack.count == 0 then return end

        rPlayer.player.clear_cursor()
        rPlayer.player.print(ritnlib.defines.portal.names.caption.msg.cursor)
    end
end



local function on_player_mined_entity(e)
    if global.portal.modules.player == false then return end
    local rEvent = RitnEvent(e)
    local LuaEntity = rEvent.entity 
    RitnSurface(LuaEntity.surface):removePortal(rEvent)

    -- On actualise le RitnGuiPortal s'il y en a un d'ouvert
    local rPlayer = rEvent:getPlayer()
    local LuaEntity = rPlayer.vehicle 

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

            if driving then 
                if rPortal:exist() then 
                    RitnGuiPortal(e):action_open(rPortal)
                end
            end
        end
    end

end


---------------------------------------------------------------------------------------------
local module = {events = {}}
---------------------------------------------------------------------------------------------
-- Events Player
module.events[defines.events.on_player_cursor_stack_changed] = on_player_cursor_stack_changed
module.events[defines.events.on_player_used_capsule] = on_player_used_capsule
module.events[defines.events.on_player_mined_entity] = on_player_mined_entity
---------------------------------------------------------------------------------------------
return module
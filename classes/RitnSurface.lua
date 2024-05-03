-- RitnSurface
----------------------------------------------------------------
local class = require(ritnlib.defines.class.core)
local RitnCoreSurface = require(ritnlib.defines.core.class.surface)
----------------------------------------------------------------
local table = require(ritnlib.defines.table)
local constants = require(ritnlib.defines.constants)
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
local RitnSurface = class.newclass(RitnCoreSurface, function(base, LuaSurface)
    if LuaSurface == nil then return end
    if LuaSurface.valid == false then return end
    if LuaSurface.object_name ~= "LuaSurface" then return end
    RitnCoreSurface.init(base, LuaSurface)
    --------------------------------------------------
    base.data_portal = remote.call("RitnCoreGame", "get_data", "portal")
    --------------------------------------------------
    base.TOKEN_PORTAL_LINKED_SEPARATED = constants.strings.special["two-way-arrow-decorator"]
    base.TOKEN_PORTAL_NOT_LINKED = constants.strings.tilde3

    log('> [RitnPortal] > RitnSurface')
end)

----------------------------------------------------------------

-- Création du portail via la capsule
function RitnSurface:createPortal(rEvent)
    -- check capsule
    local LuaItem = rEvent.event.item
    local rPlayer = rEvent:getPlayer()
    local position = rEvent.position

    if LuaItem.name ~= ritnlib.defines.portal.names.item.capsule then return end
        
    -- check tile
    local LuaTile = self.surface.get_tile(position.x, position.y)
    if string.sub(LuaTile.name,1,string.len("water")) == "water" then return end 
    if global.portal.tileNoPortal[LuaTile.name] then return end 
    log("> "..self.object_name..":createPortal()")

    local tabEntities = self.surface.find_entities_filtered({
        name=ritnlib.defines.portal.names.entity.portal, 
        position=position,
        radius=3,
    })
    if table.length(tabEntities) > 0 then 
        rPlayer.player.insert({name=ritnlib.defines.portal.names.item.capsule, amount=1})
        return 
    end

    -- create entity
    local LuaEntity = self.surface.create_entity({ 
        name = ritnlib.defines.portal.names.entity.portal,
        position = position,
        force = rPlayer.force.name,
        raise_built = true,
        create_build_effect_smoke = true
    })
    local id_portal = LuaEntity.unit_number
    

    --create render text
    local renderId = rendering.draw_text{
        text=self.name .. self.TOKEN_PORTAL_LINKED_SEPARATED .. self.TOKEN_PORTAL_NOT_LINKED,
        surface=self.surface,
        target=LuaEntity,
        alignment = "center",
        target_offset={0, -2.0},
        color = {r = 0.64, g = 0.36, b = 0.965, a = 1},
        scale_with_zoom = true,
        scale = 1.5
    }

    local tag = rPlayer.force.add_chart_tag(self.surface, {
        position=position,
        icon= {type = "virtual", name = ritnlib.defines.portal.names.entity.portal},	
        text=self.name .. self.TOKEN_PORTAL_LINKED_SEPARATED .. self.TOKEN_PORTAL_NOT_LINKED,
        last_user = rPlayer.player
    })

    local nbPortal = table.length(self.data[self.name].portals)

    -- init data portal
    local data_portal = self.data_portal
    self.data[self.name].portals[id_portal] = data_portal
    self.data[self.name].portals[id_portal].id = id_portal
    self.data[self.name].portals[id_portal].name = self.name .. self.TOKEN_PORTAL_LINKED_SEPARATED .. self.TOKEN_PORTAL_NOT_LINKED
    self.data[self.name].portals[id_portal].position = position
    self.data[self.name].portals[id_portal].render_id = renderId
    self.data[self.name].portals[id_portal].tag_number = tag.tag_number
    self.data[self.name].portals[id_portal].destination = self.TOKEN_PORTAL_NOT_LINKED
    self.data[self.name].portals[id_portal].surface_name = self.surface.name
    self.data[self.name].portals[id_portal].force_name = rPlayer.force.name
    self.data[self.name].portals[id_portal].index = nbPortal + 1

    self:update()

end


-- Suppression du portail
function RitnSurface:removePortal(rEvent)
    local LuaEntity = rEvent.entity 
    local position = LuaEntity.position

    if LuaEntity == nil then return end 
    if LuaEntity.valid == false then return end
    if LuaEntity.name ~= ritnlib.defines.portal.names.entity.portal then return end
    log("> "..self.object_name..":removePortal()")

    local id_portal = LuaEntity.unit_number
    local tag_number = self.data[self.name].portals[id_portal].tag_number
    local index = self.data[self.name].portals[id_portal].index

    self.data[self.name].portals[id_portal] = nil
    
    local area = {
        {position.x - 0.5, position.y - 0.5},
        {position.x + 0.5, position.y + 0.5},
    }
    local tabTag = LuaEntity.force.find_chart_tags(LuaEntity.surface, area)

    if table.length(tabTag) > 0 then 
        tabTag[1].destroy()
    end

    -- mise à jour des index des portals
    local portals = self.data[self.name].portals
    for _,portal in pairs(portals) do 
        if (portal.index > index) then 
            portal.index = portal.index - 1
        end
    end
    self.data[self.name].portals = portals

    self:update()
end






return RitnSurface
-- RitnSurface
----------------------------------------------------------------
local flib = require(ritnlib.defines.other)
local table = require(ritnlib.defines.table)
local string = require(ritnlib.defines.string)
local stringUtils = require(ritnlib.defines.constants).strings
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnPortalSurface = ritnlib.classFactory.newclass(RitnCoreSurface, function(self, LuaSurface)
    RitnCoreSurface.init(self, LuaSurface)
    --------------------------------------------------
    self.data_portal = remote.call("RitnCoreGame", "get_data", "portal")
    --------------------------------------------------
    self.TOKEN_PORTAL_LINKED_SEPARATED = stringUtils.special["two-way-arrow-decorator"]
    self.TOKEN_PORTAL_NOT_LINKED = stringUtils.tilde3
    self.TOKEN_EMPTY_STRING = stringUtils.empty

    log('> [RitnPortal] > RitnSurface')
end)

----------------------------------------------------------------

-- Ajoute la surface le système de demande de liaison pour la surface
function RitnSurface:addRequester()
    if self.isNauvis then return end
    -- update du nombre de portail linkable
    local options = remote.call("RitnCoreGame", "get_options")

    if options.portal.requests[self.name] == nil then 
        options.portal.requests[self.name] = remote.call("RitnCoreGame", "get_data", "portal_requester")
    end
    if options.portal.linked[self.name] == nil then 
        options.portal.linked[self.name] = {}
    end

    remote.call("RitnCoreGame", "set_options", options)
end



-- Ajoute un portail dans la liste : core.options.portal.linkable
function RitnSurface:addLinkablePortal()
    -- update du nombre de portail linkable
    local options = remote.call("RitnCoreGame", "get_options")

    if options.portal.linkable[self.name] then 
        options.portal.linkable[self.name] = options.portal.linkable[self.name] + 1
    else
        options.portal.linkable[self.name] = 1
    end

    remote.call("RitnCoreGame", "set_options", options)
end


-- Retire un portail dans la liste : core.options.portal.linkable
function RitnSurface:removeLinkablePortal()
    log("> "..self.object_name..":removeLinkablePortal()")

    local options = remote.call("RitnCoreGame", "get_options")

    -- on décrémente un portail linkable des compteurs   
    if options.portal.linkable[self.name] ~= nil then 
        if options.portal.linkable[self.name] > 1 then 
            options.portal.linkable[self.name] = options.portal.linkable[self.name] - 1
        else
            options.portal.linkable[self.name] = nil
        end
    end
    
    remote.call("RitnCoreGame", "set_options", options)
end


-- Retire unun request input/output : core.options.portal.requests
function RitnSurface:removeRequestPortal(request)
    local options = remote.call("RitnCoreGame", "get_options")
    
    if (string.isNotEmptyString(request)) then 
        log("delete request: " .. flib.ifElse(request == nil, "nil", request))
        -- récupération de toutes les demandes de liaison
        local requests = options.portal.requests

        -- suppression des demandes entrantes/sortantes
        requests[request].input[self.name] = nil
        local output_requests = requests[self.name].output
        for index,output in pairs(output_requests) do 
            if output == request then 
                table.remove(output_requests, index)
            end
        end
        requests[self.name].output = output_requests
        options.portal.requests = requests
    end
    
    remote.call("RitnCoreGame", "set_options", options)
end


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
        text=self.TOKEN_PORTAL_NOT_LINKED,
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
        text=self.TOKEN_PORTAL_NOT_LINKED,
        last_user = rPlayer.player
    })

    local nbPortal = table.length(self.data[self.name].portals)

    -- init data portal
    local data_portal = self.data_portal
    self.data[self.name].portals[id_portal] = data_portal
    self.data[self.name].portals[id_portal].id = id_portal
    self.data[self.name].portals[id_portal].position = position
    self.data[self.name].portals[id_portal].render_id = renderId
    self.data[self.name].portals[id_portal].tag_number = tag.tag_number
    self.data[self.name].portals[id_portal].destination = self.TOKEN_PORTAL_NOT_LINKED
    self.data[self.name].portals[id_portal].surface_name = self.name
    self.data[self.name].portals[id_portal].force_name = rPlayer.force.name
    self.data[self.name].portals[id_portal].index = nbPortal + 1

    self:update()

    -- update du nombre de portail linkable
    self:addLinkablePortal()

end


-- Retourne un portail de la surface par son id
function RitnSurface:getPortal(id_portal)
    local portal = self.data[self.name].portals[id_portal]
    local LuaEntity = self:getEntity(portal.position, id_portal, ritnlib.defines.portal.names.entity.portal, 'car')
    return RitnPortalPortal(LuaEntity)
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
    local request = self.data[self.name].portals[id_portal].request

    self.data[self.name].portals[id_portal] = nil
    
    local area = {
        {position.x - 0.5, position.y - 0.5},
        {position.x + 0.5, position.y + 0.5},
    }
    local tabTag = LuaEntity.force.find_chart_tags(LuaEntity.surface, area)

    if table.length(tabTag) > 0 then 
        tabTag[1].destroy()
    end

    self:update()

    -- update du nombre de portail linkable
    self:removeRequestPortal(request)
    self:removeLinkablePortal()
end

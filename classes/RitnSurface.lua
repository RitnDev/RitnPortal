-- RitnPortalSurface
----------------------------------------------------------------
local util = require(ritnlib.defines.other)
local table = require(ritnlib.defines.table)
local string = require(ritnlib.defines.string)
local stringUtils = require(ritnlib.defines.constants).strings
local colors = require(ritnlib.defines.constants).color
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnPortalSurface = ritnlib.classFactory.newclass(RitnCoreSurface, function(self, LuaSurface)
    RitnCoreSurface.init(self, LuaSurface)
    self.object_name = "RitnPortalSurface"
    --------------------------------------------------
    self.data_portal = remote.call("RitnCoreGame", "get_data", "portal")
    --------------------------------------------------
    self.TOKEN_PORTAL_LINKED_SEPARATED = stringUtils.special["two-way-arrow-decorator"]
    self.TOKEN_PORTAL_NOT_LINKED = stringUtils.tilde3
    self.TOKEN_EMPTY_STRING = stringUtils.empty

    log('> [RitnPortal] > RitnPortalSurface')
end)

----------------------------------------------------------------

-- Initialise les options lié à la nouvelles surface
function RitnPortalSurface:setupPortalSystem()
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

    return self
end



-- Ajoute un portail dans la liste : core.options.portal.linkable
function RitnPortalSurface:addLinkablePortal()
    -- update du nombre de portail linkable
    local options = remote.call("RitnCoreGame", "get_options")

    if options.portal.linkable[self.name] then 
        options.portal.linkable[self.name] = options.portal.linkable[self.name] + 1
    else
        options.portal.linkable[self.name] = 1
    end

    remote.call("RitnCoreGame", "set_options", options)

    return self
end


-- Retire un portail dans la liste : core.options.portal.linkable
function RitnPortalSurface:removeLinkablePortal()
    log("> "..self.object_name..":removeLinkablePortal() : surface: " .. self.name)

    local options = remote.call("RitnCoreGame", "get_options")

    -- on décrémente un portail linkable des compteurs   
    if options.portal.linkable[self.name] ~= nil then 
        log("> linkable before = "..tostring(options.portal.linkable[self.name]))
        if options.portal.linkable[self.name] > 1 then 
            options.portal.linkable[self.name] = options.portal.linkable[self.name] - 1
            log("> linkable after = "..tostring(options.portal.linkable[self.name]))
        else
            options.portal.linkable[self.name] = nil
            log("> linkable after = 0 ")
        end
    else
        log("> options.portal.linkable[".. tostring(self.name) .."] non trouvable")
    end
    
    remote.call("RitnCoreGame", "set_options", options)

    return self
end


-- On créé la liaison avec l'autre surface dans : options.portal.linked
function RitnPortalSurface:addLinkedSurface(surface_linked)
    log("> "..self.object_name..":addLinkedSurface(".. tostring(surface_linked) ..")")
    -- récupération des options
    local options = remote.call("RitnCoreGame", "get_options")

    -- On ajoute le lien entre les 2 surfaces
    table.insert(options.portal.linked[self.surface.name], surface_linked)

    -- On enregistre les modifications des options portals
    remote.call("RitnCoreGame", "set_options", options)

    return self
end


-- On supprime la liaison avec l'autre surface dans : options.portal.linked
function RitnPortalSurface:removeLinkedSurface(surface_linked, output)
    local linked_input = self.TOKEN_EMPTY_STRING
    local linked_output = self.TOKEN_EMPTY_STRING

    if output == true then 
        linked_input = self.surface.name
        linked_output = surface_linked
    else
        linked_input = surface_linked
        linked_output = self.surface.name
    end

    log("> "..self.object_name..":removeLinkedSurface( " .. tostring(linked_output) .. ' --X--> ' .. tostring(linked_input) .." )")

    -- récupération des options
    local options = remote.call("RitnCoreGame", "get_options")

    table.removeByValue(options.portal.linked[linked_output], linked_input)

    -- On enregistre les modifications des options portals
    remote.call("RitnCoreGame", "set_options", options)

    return self
end


-- Retire unun request input/output : core.options.portal.requests
function RitnPortalSurface:removeRequestPortal(request, output)
    local requester_input = self.TOKEN_EMPTY_STRING
    local requester_output = self.TOKEN_EMPTY_STRING

    if output == true then 
        requester_input = self.name
        requester_output = request
    else
        self:addLinkablePortal()
        requester_input = request
        requester_output = self.name
    end

    local options = remote.call("RitnCoreGame", "get_options")

    log("delete request: " .. tostring(request))

    if (string.isNotEmptyString(request)) then 
        
        -- récupération de toutes les demandes de liaison
        local requests = options.portal.requests

        -- suppression des demandes entrantes/sortantes
        requests[requester_input].input[requester_output] = nil
        local output_requests = requests[requester_output].output
        for index,output in pairs(output_requests) do 
            if output == requester_input then 
                table.remove(output_requests, index)
            end
        end
        requests[requester_output].output = output_requests
        options.portal.requests = requests
    end
    
    remote.call("RitnCoreGame", "set_options", options)
    
    return self
end


-- Création du portail via la capsule
function RitnPortalSurface:createPortal(rEvent)
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
    LuaEntity.minable = false
    LuaEntity.destructible = false
    local id_portal = LuaEntity.unit_number
    

    --create render text
    local renderId = rendering.draw_text{
        text=self.TOKEN_PORTAL_NOT_LINKED,
        surface=self.surface,
        target=LuaEntity,
        alignment = "center",
        target_offset={0, -2.0},
        color = colors.mediumpurple,
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
    self.data[self.name].portals[id_portal].destination = {
        id_portal = -1,
        surface = self.TOKEN_PORTAL_NOT_LINKED,
    } 
    self.data[self.name].portals[id_portal].surface_name = self.name
    self.data[self.name].portals[id_portal].force_name = rPlayer.force.name
    self.data[self.name].portals[id_portal].index = nbPortal + 1

    self:update()

    -- update du nombre de portail linkable
    self:addLinkablePortal()

    return self
end


-- Retourne un portail de la surface par son id
function RitnPortalSurface:getPortal(id_portal, surface_name)
    if util.type(id_portal) ~= 'number' then return end
    if id_portal < 0 then return end

    local LuaEntity
    
    if string.isString(surface_name) == false then 
        log('> '.. self.object_name .. ':getPortal(id_portal: '.. tostring(id_portal) ..')')
        -- on récupère un portail de la surface actuel (RitnSurface)
        local portal = self.data[self.name].portals[id_portal]
        LuaEntity = self:getEntity(portal.position, id_portal, ritnlib.defines.portal.names.entity.portal, portal.entity_type)
    else
        log('> '.. self.object_name .. ':getPortal(id_portal: '.. tostring(id_portal) ..', surface_name: ' .. surface_name .. ')')
        if surface_name == self.TOKEN_PORTAL_NOT_LINKED then return end
        -- on récupère le portail sur la surface de destination
        local portal = self.data[surface_name].portals[id_portal]
        LuaEntity = RitnLibSurface(game.surfaces[surface_name]):getEntity(portal.position, id_portal, ritnlib.defines.portal.names.entity.portal, portal.entity_type)
    end

    return RitnPortalPortal(LuaEntity)
end


-- Retourne le RitnPortal auquel le portail id_portal est lié (ou nil si non lié)
function RitnPortalSurface:getIdPortalDestination(id_portal)
    if util.type(id_portal) ~= 'number' then return nil end

    return self.data[self.name].portals[id_portal].destination.id_portal
end


-- Suppression du portail
function RitnPortalSurface:removePortal(rPortal, LuaPlayer)

    --local rPortal = RitnPortalPortal(rEvent.entity)
    if util.type(rPortal) ~= "RitnPortalPortal" then return end 
    log("> "..self.object_name..":removePortal()")

    local requester, id_portal, destination = rPortal:remove()

    -- Suppression de la requête en cours
    if string.isNotEmptyString(requester) then 
        -- update du nombre de portail linkable
        self:removeRequestPortal(requester)
        self:removeLinkablePortal()
    end

    -- Suppression de la liaison en cours
    if id_portal > 0 then 
        -- suppression de la liaison en cours (coté origine)
        self:removeLinkedSurface(destination)

        -- on récupère le portail sur la surface de destination
        local rPortalDest = self:getPortal(id_portal, destination)

        -- suppression de la liaison en cours (coté destination)
        rPortalDest:removeLink(self.surface.name, LuaPlayer)
    else
        self:removeLinkablePortal()
    end

    return self, id_portal, destination
end



-- Suppression de surface
function RitnPortalSurface:delete()

    -- supression les liaisons déjà établit avec la surface chez les autres  
    for _,surface in pairs(self.data) do 
        if table.isNotEmpty(surface.portals) then 
            for _,portal in pairs(surface.portals) do 
                if portal.destination.surface == self.name then 
                    local rPortal = self:getPortal(portal.id, portal.surface_name)
                    rPortal:removeLink()
                    break
                end
            end
        end
    end
    


    -- supprime les requêtes en cours en destination de cette surface
    local options = remote.call("RitnCoreGame", "get_options")

    local requests_input = {}
    if table.isNotEmpty(options.portal.requests[self.name].input) then 
        requests_input = options.portal.requests[self.name].input
    end
    
    if table.isNotEmpty(requests_input) then 
        for _,input in pairs(requests_input) do 
            local rPortalDest = self:getPortal(input.id, input.surface_name)
            rPortalDest:removeRequest()
        end
    end


    -- Suppression des données lié à la surface supprimée
    options = remote.call("RitnCoreGame", "get_options")
    
    -- on supprime tous les portail linkable de cette surface
    if options.portal.linkable[self.name] ~= nil then 
        options.portal.linkable[self.name] = nil
    end

    -- on supprime tous les liens établit depuis cette surface
    if options.portal.linked[self.name] ~= nil then 
        options.portal.linked[self.name] = nil
    end

    -- On supprime toutes les requetes de cette surface
    if options.portal.requests[self.name] ~= nil then 
        options.portal.requests[self.name] = nil
    end
    
    -- on supprime les requete en cours vers cette surface chez les autres
    for _, request in pairs(options.portal.requests) do 
        
        -- supression des requetes sortantes
        local position = table.indexOf(request.output, self.name)
        if position >= 0 then 
            table.remove(request.output, position)
            position = -1
        end

        -- suppresion des requetes entrante
        if request.input[self.name] ~= nil then 
            local input = request.input[self.name]
            local rPortalDest = self:getPortal(input.id, input.surface_name)
            rPortalDest:removeRequest()
        end
    end

    remote.call("RitnCoreGame", "set_options", options)
end
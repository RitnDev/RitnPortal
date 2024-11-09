-- RitnPortalPortal
----------------------------------------------------------------
local table = require(ritnlib.defines.table)
local util = require(ritnlib.defines.other)
local stringUtils = require(ritnlib.defines.constants).strings
local colors = require(ritnlib.defines.constants).color
local string = require(ritnlib.defines.string)
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnPortalPortal = ritnlib.classFactory.newclass(RitnLibEntity, function(self, LuaEntity)
    RitnLibEntity.init(self, LuaEntity)
    --------------------------------------------------
    -- check entity
    local checkName = true
    local result = pcall(function() 
        if LuaEntity.name ~= ritnlib.defines.portal.names.entity.portal then 
            checkName = false 
        end
    end)
    if result == false or checkName == false then return end
    --------------------------------------------------
    self.object_name = "RitnPortalPortal"
    --------------------------------------------------
    log('> '..self.object_name..'() -> init ok !')
    --------------------------------------------------
    local surfaces = remote.call("RitnCoreGame", "get_surfaces")
    self.data = surfaces[self.surface.name].portals[self.id]
    --------------------------------------------------
    self.TOKEN_PORTAL_NOT_LINKED = stringUtils.tilde3
end)
----------------------------------------------------------------


--@Override
--Retourne l'objet RitnSurface d'où le portail est posé
function RitnPortalPortal:getSurface()
    return RitnPortalSurface(self.surface)
end



--@Override
--Retourne l'objet RitnForce du portail
function RitnPortalPortal:getForce()
    return RitnCoreForce(self.force)
end



--Retourne le nom de la surface où se trouve le portail
function RitnPortalPortal:getSurfaceName()
    return self.surface.name
end



--Retourne le nom de la force qui a créé ce portail
function RitnPortalPortal:getForceName()
    return self.force.name
end



-- Vérification de la présence de l'entité portail
function RitnPortalPortal:exist()
    if self.data == nil then return false end
    return self:existByName(ritnlib.defines.portal.names.entity.portal)
end


-- Suppression d'un portail (minage)
function RitnPortalPortal:remove()
    local requester = self.data.request
    local id_portal = self:getDestinationIdPortal()
    local destination = self:getDestination()

    -- suppression du tag gps
    self:deleteTag()
    -- suppression dans des données
    self.data = nil 
    self:update()

    return requester, id_portal, destination
end



function RitnPortalPortal:setRendering(value) 
    if self:exist() then
        if string.isNotEmptyString(value) then 
            -- set rendering
            local LuaRenders = rendering.get_all_objects(ritnlib.defines.portal.name)
            local index = table.index(LuaRenders, "id", self.data.render_id)
            if index > 0 then
                local LuaRender = LuaRenders[index]
                LuaRender.text = value
            end
        end
    end

    return self
end


-- récupération du tag gps du portail
function RitnPortalPortal:getTag()
    local tag

    if self:exist() then
        tag = RitnCoreForce(self.force):getChartTag(
            self.data.tag_number, 
            self.surface.name, 
            self.position)
    end

    return tag
end


-- Edition du tag gps du portail
function RitnPortalPortal:editTag(value, pLuaPlayer)
    local tag = self:getTag()

    if tag ~= nil then
        tag.text = value
        if util.type(pLuaPlayer) == 'LuaPlayer' then
            tag.last_user = pLuaPlayer
        end
    end

    return self
end


-- Suppression du tag gps du portail
function RitnPortalPortal:deleteTag()
    local tag = self:getTag()

    if tag ~= nil then
        tag.destroy()
    end

    return self
end


-- Retourne true si le portail est lié
function RitnPortalPortal:isLinked()
    local isLinked = false
    if self:exist() then
        if self.data.destination.id_portal > 0 then
            isLinked = true
        end
    end
    return isLinked
end



-- Retourne true si le type de liaison est identique au parametre 
function RitnPortalPortal:isLinkType(linkType)
    local isLinkType = false
    if self:exist() then
        if string.isNotEmptyString(linkType) then 
            if self.data.type == linkType then
                isLinkType = true
            end
        end
    end
    return isLinkType
end

-- Retourne true si le portail a une requete en cours
function RitnPortalPortal:isRequester(requester)
    local isRequester = false
    if self:exist() then
        if self.data.request ~= self.TOKEN_EMPTY_STRING then
            isRequester = true

            -- Vérifie que requester est identique à l'information enregistré sur le portail
            if requester ~= nil then 
                if self.data.request ~= requester then
                    isRequester = false
                end
            end
        end
    end
    return isRequester
end


-- Retourne la surface de destination du portail ou ~~~
function RitnPortalPortal:getDestination()
    return self.data.destination.surface
end

-- Retourne l'id du poratil de destination ou -1
function RitnPortalPortal:getDestinationIdPortal()
    return self.data.destination.id_portal
end


-- Retourne le Caption de la liaison ou "frame_portal.not_link" s'il n'est pas lié.
function RitnPortalPortal:getLinkDestination()
    local caption = ritnlib.defines.portal.names.caption.frame_portal.not_link
    if self:isLinked() then
        caption = {ritnlib.defines.portal.names.caption.frame_portal.link, self:getDestination()}
    end
    return caption
end


-- Retourne le Caption de la demande de liaison en cours
function RitnPortalPortal:getRequest()
    local caption = ""
    if self:isRequester() then
        caption = {ritnlib.defines.portal.names.caption.frame_portal.request, self.data.request}
    end
    return caption
end

-- Récupère la liste des surfaces avec lesquels on peut actuellement se lier.
function RitnPortalPortal:getListSurfaces()
    log("> "..self.object_name..":getListSurfaces()")
    local listSurfaces = {}
    local options = remote.call("RitnCoreGame", "get_options")
    local portals_linkable = options.portal.linkable
    local requests = options.portal.requests
    local linked = options.portal.linked
    local portal_requests_outputs = {}
    local portal_linked = {}

    -- récupération de la liste des demandes envoyés
    if requests[self.surface.name] ~= nil then 
        portal_requests_outputs = requests[self.surface.name].output
    end

    -- récupération de la liste des surfaces déja lié à cette surface
    if linked[self.surface.name] ~= nil then 
        portal_linked = linked[self.surface.name]
    end


    for surface,_ in pairs(portals_linkable) do 
        log("portals_linkable > surface : ".. surface)
        if surface ~= self.surface.name then 
            local insertSurface = true

            -- on retire les surfaces à qui ont a déjà envoyé une demande pour 
            -- éviter d'envoyé plusieurs demande à même surface)
            for _,output in pairs(portal_requests_outputs) do 
                if output == surface then 
                    insertSurface = false
                end
            end

            if insertSurface then 
                -- on retire les surfaces déjà lié car un seul lien n'est possible
                for _,surface_linked in pairs(portal_linked) do 
                    if surface_linked == surface then 
                        insertSurface = false
                    end
                end
            end

            -- si on a pas envoyé de demande à cette surface on peut donc l'ajouter à la liste
            if insertSurface then 
                log("insert on listSurfaces : ".. surface)
                table.insert(listSurfaces, surface)
            end
        end
    end

    return listSurfaces
end

-- Récupère la liste des demandes de liaisons avec nous.
function RitnPortalPortal:getListRequests()
    log("> "..self.object_name..":getListRequests()")
    local listRequests = {}
    local options = remote.call("RitnCoreGame", "get_options")
    local requests = options.portal.requests

    if requests[self.surface.name] ~= nil then 
        local portal_requests_inputs = requests[self.surface.name].input
        log("portal_requests > surface : ".. self.surface.name)
        
        for _,input in pairs(portal_requests_inputs) do
            log("insert on listRequests : ".. input.surface_name)
            table.insert(listRequests, input.surface_name)
        end
    else
        -- aucune demande de liaison.
    end

    return listRequests
end


-- Le portail est en attente de demande de liaison avec cette destination
function RitnPortalPortal:addRequest(destination)
    if string.isString(destination) == false then return end
    log("> " .. self.object_name .. ":addRequest(" .. destination ..")")

    -- récupération de la liste des surfaces destinations
    local listSurfaces = self:getListSurfaces()   
    log('liste des surfaces : ' .. tostring(helpers.table_to_json(listSurfaces)))

    -- On vérifie que la destination est présent dans la liste des surfaces joignables
    local check = false
    for _,surface in pairs(listSurfaces) do 
        if surface == destination then 
            check = true
        end
    end
    if check == false then return end

    ---- création de la demande de liaison
    local new_request = remote.call("RitnCoreGame", "get_data", "portal_request")
    new_request.id = self.id 
    new_request.surface_name = self.surface.name

    -- récupération des options
    local options = remote.call("RitnCoreGame", "get_options")
    -- récupération de toutes les demandes de liaison
    local requests = options.portal.requests

    -- création de la nouvelle demande
    requests[destination].input[self.surface.name] = new_request
    table.insert(requests[self.surface.name].output, destination)

    -- Mise à jour des options
    options.portal.requests = requests
    remote.call("RitnCoreGame", "set_options", options)

    self.data.request = destination
    self:getSurface():removeLinkablePortal()

    -- On envoie un message sur la surface de destination
    pcall(function() 
        log("> " .. self.object_name .. ":addRequest(" .. tostring(destination) ..") -> send print")
        game.surfaces[destination].print({'msg.new-request', self.surface.name}, colors.aqua)
        self.surface.print({'msg.send-request', destination}, colors.aqua)
    end)

    return self:update()
end


-- Le portail est en attente de demande de liaison avec cette destination
function RitnPortalPortal:removeRequest()
    self:getSurface():removeRequestPortal(self.data.request)
    self.data.request = self.TOKEN_EMPTY_STRING
    return self:update()
end


-- Ajout de la nouvelle liaison avec le portail
function RitnPortalPortal:checkBeforeAddLink(requester, requestType)
    log("> "..self.object_name..":checkBeforeAddLink(".. tostring(requester) .."," .. tostring(requestType) .. ")")

    -- vérification que le portail n'est pas déjà relié
    local checkLink = not self:isLinked()
    log('checkBeforeAddLink -> checkLink: ' .. tostring(checkLink))

    -- vérification que le portail n'a pas fait une autre demande depuis.
    local checkRequest = util.ifElse(requester == nil, true, self:isRequester(requester))
    log('checkBeforeAddLink -> checkRequest: ' .. tostring(checkRequest))
    
    -- vérification que le type de demande est identique
    local checkType = self:isLinkType(requestType)
    log('checkBeforeAddLink -> checkType: ' .. tostring(checkType))

    -- retourne le resultat
    return checkLink and checkRequest and checkType
end



-- Ajout de la nouvelle liaison avec le portail
function RitnPortalPortal:addLink(idPortalLink, surface, pLuaPlayer)
    self.data.destination.surface = surface
    self.data.destination.id_portal = idPortalLink
    self.data.request = self.TOKEN_EMPTY_STRING

    -- set rendering
    self:setRendering(surface)

    -- set chart_tag (gps)
    self:editTag(surface, pLuaPlayer)
    
    -- On créé la liaison avec l'autre surface dans : options.portal.linked
    self:getSurface():addLinkedSurface(surface)

    -- On envoie un message sur la surface de destination
    pcall(function() 
        log("> " .. self.object_name .. ":addLink(" .. tostring(surface) ..") -> send print")
        game.surfaces[surface].print({'msg.new-link', self.surface.name}, colors.aqua)
    end)

    return self:update()
end


-- Suppression de la liaison actuelle du portail
function RitnPortalPortal:removeLink(pLuaPlayer)
    log("> "..self.object_name..":removeLink() -> id_portal: " .. tostring(self.data.id))

    -- Suppression du lien entre portail
    self:getSurface():removeLinkedSurface(self.data.destination.surface):addLinkablePortal()

    self.data.destination.id_portal = -1
    self.data.destination.surface = self.TOKEN_PORTAL_NOT_LINKED

    -- set rendering
    self:setRendering(self.TOKEN_PORTAL_NOT_LINKED)

    -- set chart_tag (gps)
    self:editTag(self.TOKEN_PORTAL_NOT_LINKED, pLuaPlayer)
        
    return self:update()
end


function RitnPortalPortal:teleport(LuaPlayer, force_teleport) 
    local teleport_forced = false
    if util.type(force_teleport) == 'boolean' then teleport_forced = force_teleport end

    if util.type(LuaPlayer) == 'LuaPlayer' then
        -- le LuaPlayer est conducteur du portail et le portail est lié OU on force la téléportation 
        -- quelques soit l'endroit où se trouve le joueur (via : teleport_forced)
        if ( self:playerIsDriver(LuaPlayer) and self:isLinked() ) or teleport_forced then 
            local destination = self:getDestination()
            local rPortalDestination = self:getSurface():getPortal(self:getDestinationIdPortal(), destination)
            
            if rPortalDestination.allowsPassenger then 
                LuaPlayer.teleport(rPortalDestination.position, rPortalDestination.surface)
                rPortalDestination:setPassenger(LuaPlayer)
            end
            
        end
    end
end



-- Mise à jour de la structure de données
function RitnPortalPortal:update()
    local surfaces = remote.call("RitnCoreGame", "get_surfaces")
    surfaces[self.surface.name].portals[self.id] = self.data
    remote.call("RitnCoreGame", "set_surfaces", surfaces) 
    return self
end


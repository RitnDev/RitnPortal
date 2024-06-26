-- RitnPortalPortal
----------------------------------------------------------------
local table = require(ritnlib.defines.table)
----------------------------------------------------------------
local pattern = "([^-]*)~?([^-]*)~?([^-]*)"
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnPortalPortal = ritnlib.classFactory.newclass(function(self, LuaEntity)
    if LuaEntity == nil then return end
    if LuaEntity.valid == false then return end
    if LuaEntity.object_name ~= "LuaEntity" then return end
    if LuaEntity.name ~= ritnlib.defines.portal.names.entity.portal then return end
    self.object_name = "RitnPortalPortal"
    --------------------------------------------------
    log('> '..self.object_name..'() -> init ok !')
    self.entity = LuaEntity
    self.surface = LuaEntity.surface
    self.force = LuaEntity.force
    self.position = LuaEntity.position
    self.drive = LuaEntity.get_driver()
    self.passenger = LuaEntity.get_passenger()
    ----
    self.name = LuaEntity.name
    self.id = LuaEntity.unit_number
    ----
    local surfaces = remote.call("RitnCoreGame", "get_surfaces")
    self.data = surfaces[self.surface.name].portals[self.id]
    --------------------------------------------------
end)
----------------------------------------------------------------


--Retourne l'objet RitnSurface d'où le portail est posé
function RitnPortalPortal:getSurface()
    return RitnPortalSurface(self.surface)
end



-- Vérification de la présence de l'entité portail
function RitnPortalPortal:exist()
    if self.entity == nil then return false end 
    if self.name ~= ritnlib.defines.portal.names.entity.portal then return false end
    if self.data == nil then return false end

    return true
end


-- Retourne true si le portail est lié
function RitnPortalPortal:isLinked()
    local isLinked = false
    if self:exist() then
        if self.data.destination ~= "~~~" then
            isLinked = true
        end
    end
    return isLinked
end

-- Retourne true si le portail est lié
function RitnPortalPortal:isRequester()
    local isRequester = false
    if self:exist() then
        if self.data.request ~= "" then
            isRequester = true
        end
    end
    return isRequester
end


-- Retourne le Caption de la liaison ou "frame_portal.not_link" s'il n'est pas lié.
function RitnPortalPortal:getLinkDestination()
    local caption = ritnlib.defines.portal.names.caption.frame_portal.not_link
    if self:isLinked() then
        caption = {ritnlib.defines.portal.names.caption.frame_portal.link, self.data.destination}
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
                for _,linked in pairs(portal_linked) do 
                    if linked == surface then 
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
    self.data.request = destination
    self:getSurface():removeLinkablePortal()
    self:update()
end

-- Le portail est en attente de demande de liaison avec cette destination
function RitnPortalPortal:removeRequest()
    self.data.request = ""
    self:getSurface():addLinkablePortal()
    self:update()
end


-- Mise à jour de la structure de données
function RitnPortalPortal:update()
    local surfaces = remote.call("RitnCoreGame", "get_surfaces")
    surfaces[self.surface.name].portals[self.id] = self.data
    remote.call("RitnCoreGame", "set_surfaces", surfaces) 
    return self
end


----------------------------------------------------------------
--return RitnPortalPortal
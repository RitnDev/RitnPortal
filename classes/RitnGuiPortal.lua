-- RitnGuiPortal
----------------------------------------------------------------
----------------------------------------------------------------
local font = ritnlib.defines.names.font
local stringUtils = require(ritnlib.defines.constants).strings
local fGui = require(ritnlib.defines.portal.gui.portal)
local util = require(ritnlib.defines.other)
local table = require(ritnlib.defines.table)
local string = require(ritnlib.defines.string)
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
RitnGuiPortal = ritnlib.classFactory.newclass(RitnLibGui, function(self, event)
    RitnLibGui.init(self, event, ritnlib.defines.portal.name, "frame-main")
    self.object_name = "RitnGuiPortal"
    --------------------------------------------------
    self.gui_name = ritnlib.defines.portal.names.gui.portal
    self.gui_action = {
        [self.gui_name] = {
            [ritnlib.defines.portal.gui_actions.portal.open] = true,
            [ritnlib.defines.portal.gui_actions.portal.close] = true,
            [ritnlib.defines.portal.gui_actions.portal.list_select_change] = true,
            [ritnlib.defines.portal.gui_actions.portal.button_close] = true,
            [ritnlib.defines.portal.gui_actions.portal.button_request] = true,
            [ritnlib.defines.portal.gui_actions.portal.button_unrequest] = true,
            [ritnlib.defines.portal.gui_actions.portal.button_link] = true,
            [ritnlib.defines.portal.gui_actions.portal.button_unlink] = true,
        }
    }    
    --------------------------------------------------
    self.gui = { self.player.gui.screen }
    --------------------------------------------------
    self.content = remote.call("RitnPortal", "get_gui_portal").content
    --------------------------------------------------
    self.REQUEST_SEPARATOR = stringUtils.puce["triangular-decorator"]
    self.TOKEN_PORTAL_LINKED_SEPARATED = stringUtils.tilde3
end)

----------------------------------------------------------------


function RitnGuiPortal:create(...)
    if self.gui[1][self.gui_name.."-"..self.main_gui] then return self end
    local rPortal, selecter_index = ...
    if selecter_index == nil then selecter_index = 1 end
    
    local rPlayer = RitnCorePlayer(self.player)
    local isOwner = rPlayer:isOwner()


    local elements = remote.call("RitnPortal", "get_gui_portal").elements
    local content = remote.call("RitnPortal", "create_portal_gui", self.gui[1], elements)

    local isLinked = rPortal:isLinked()
    local isRequester = rPortal:isRequester()
    local isPassenger = rPortal.passenger

    log("> selecter_index: " .. tostring(selecter_index))
    log("> isOwner: " .. tostring(isOwner))
    log("> isLinked: " .. tostring(isLinked))
    log("> isRequester: " .. tostring(isRequester))
    log("> self.driving: " .. tostring(self.driving))
    log("> isPassenger: " .. tostring(isPassenger))

    if isLinked then
        content["enter"].visible = true
        content["enter"].caption = ritnlib.defines.portal.names.caption.frame_portal.label_enter
        content["flow-empty_surfaces"].visible = false
        content["flow-dialog"].visible = true

        if self.driving and util.ifElse(isPassenger == nil, false, isPassenger) then 
            content["enter"].visible = true
            content["enter"].caption = ritnlib.defines.portal.names.caption.frame_portal.label_passenger
        else 
            content["enter"].visible = false
        end
    else 
        content["enter"].visible = false
        content["flow-empty_surfaces"].visible = true
    end

    log("> content['enter'].visible = " .. tostring(content["enter"].visible))

    -- styles guiElement
    content["info"].caption = {rPortal.data.id, rPortal.data.surface_name, rPortal.data.type}
    content["namer"].caption = rPortal:getLinkDestination()
    content["main"].auto_center = true
    content["header"].drag_target = content["main"]
    content["title"].drag_target = content["main"]
    content["dragspace"].drag_target = content["main"]

    ----
    
    libStyle(content["frame-top"]):topPadding(4):rightPadding(8):leftPadding(8)
    libStyle(content["header"]):verticalStretch(false)
    libStyle(content["dragspace"]):stretchable():height(24):rightMargin(8)
    libStyle(content["flow-namer"]):padding(4)
    libStyle(content["namer"]):font(font.bold14):width(275)
    libStyle(content["submain"]):padding(4):margin(4):stretchable()
    libStyle(content["enter"]):padding(4)
    libStyle(content["flow-empty_surfaces"]):padding(4):height(40)
    libStyle(content["button-empty_surfaces"]):stretchable():fontColor("white", true, true)
    libStyle(content["flow-surfaces"]):padding(4):stretchable():bottomPadding(0)
    libStyle(content["list-surfaces"]):horizontalStretch():maxHeight(500)
    libStyle(content["empty-empty"]):stretchable()
    libStyle(content["flow-dialog_surfaces"]):padding(4)
    libStyle(content["button-request"]):align("right"):spriteButton()
    libStyle(content["button-link"]):align("right"):spriteButton()
    libStyle(content["flow-dialog"]):padding(4)
    libStyle(content["button-unlink"]):spriteButton()

    local listSurfacesNotEmpty = false
    
    -- Votre portail est en cours de demande de liaison avec une destination
    if isRequester == true then 
        content["flow-surfaces"].visible = false
        content["flow-empty_surfaces"].visible = false

        content["namer"].caption = rPortal:getRequest()
        content["button-unrequest"].visible = true

    else -- Votre portail n'a aucune demande en cours

        --Récupération de la liste des demandes de liaison
        local listRequests = rPortal:getListRequests()
        if table.isEmpty(listRequests) == false then
            log("> "..self.object_name.."create(...) > content.flow.linkable.visible = true")

            content["flow-empty_surfaces"].visible = false
            listSurfacesNotEmpty = true

            for _,surface in pairs(listRequests) do 
                content["list-surfaces"].add_item("[img=".. ritnlib.defines.portal.names.sprite.inbound_link ..
                "]".. self.REQUEST_SEPARATOR .. surface)
            end
        else
            log("> "..self.object_name.."create(...) > content.flow.linkable.visible = false") 
        end


        -- récupération de la liste des surfaces destinations
        local listSurfaces = rPortal:getListSurfaces()
        if table.isEmpty(listSurfaces) == false then
            log("> "..self.object_name.."create(...) > content.flow.surfaces.visible = true") 

            content["flow-empty_surfaces"].visible = false
            listSurfacesNotEmpty = true

            for _,surface in pairs(listSurfaces) do 
                local index = table.indexOf(listRequests, surface)
                if index < 0 then       
                    content["list-surfaces"].add_item(surface)
                end
            end
        else 
            log("> "..self.object_name.."create(...) > content.flow.surfaces.visible = false") 
        end

        -- si la liste n'est pas vide on selectionne l'index 'selecter_index' (par defaut le premier)
        if listSurfacesNotEmpty == true and isLinked == false then 
            content["flow-surfaces"].visible = true
            self:selectListSurfacesChange(content["list-surfaces"], selecter_index)
        end

    end

    return self
end

----------------------------------------------------------------


function RitnGuiPortal:closeGuiEntity()
    if self.player.opened ~= nil then
        if self.player.opened.name == ritnlib.defines.portal.names.entity.portal then
            self.player.opened = nil
        end
    end
end

-- Retourne la RitnSurface (surface) associé au GUI
function RitnGuiPortal:getSurface()
    log('> '..self.object_name..':getSurface()')
    ----
    local surface_name = self:getElement("label", "info").caption[2]
    if string.isNotEmptyString(surface_name) and type(game.surfaces[surface_name]) ~= 'nil' then 
        return ritnlib.classes.portal.surface(game.surfaces[surface_name])
    end
end


-- Action sur le GUI à faire lors de la selection dans la liste des surfaces
function RitnGuiPortal:selectListSurfacesChange(list, selecter_index)
    if list == nil then return end
    if list.valid == false then return end
    ----
    local button_request = self:getElement("button","request")
    local button_link = self:getElement("button","link")
    ----

    local item_select, iStart, iEnd = self:indexOfRequestSeparator(list, selecter_index)
    log("> item_select: " .. util.ifElse(item_select == nil, "nil", item_select))
    log("> iStart: " .. util.ifElse(iStart == nil, "nil", iStart))
    log("> iEnd: " .. util.ifElse(iEnd == nil, "nil", iEnd))

    -- On vérifie qu'il y a bien un élément sélectionné
    if item_select == nil then 
        button_request.enabled = false
        button_link.enabled = false
        log('> '..self.object_name..':selectListSurfacesChange() -> no selected item')
        return
    else
        log('> '..self.object_name..':selectListSurfacesChange() -> item selected : '.. item_select)
        button_request.enabled = true
        button_link.enabled = true
    end

    -- Gestion de visibilité des boutons
    if iStart == nil then 
        -- la selection n'est pas une demande entrante
        button_link.visible = false
        button_request.visible = true
        button_request.tooltip = {'tooltip.button-request', item_select}
    else 
        -- la selection est une demande entrante
        button_request.visible = false
        if string.length(item_select) > 0 then 
            local input_request_name = string.sub(item_select, iEnd + 1, string.len(item_select))
            button_link.visible = true
            button_link.tooltip = {'tooltip.button-link', input_request_name}
        end
    end
end



-- Retourne l'index de début et de fin du séparateur de demande s'il existe
-- S'il n'est pas présent ça retourne nil
-- @return selected_index, indexStart, indexEnd
function RitnGuiPortal:indexOfRequestSeparator(list, selecter_index)

    -- forcage de l'element selectionné si le paramètre est renseigné
    -- lavaleur doit-être dans l'intervalle de la taille de la liste
    if selecter_index ~= nil and selecter_index > 0 and selecter_index <= table.length(list.items) then 
        list.selected_index = selecter_index
        log("force selected index by : " .. selecter_index)
    end

    -- index de l'element sélectionné dans la liste
    local selected_index = list.selected_index

    -- On vérifie qu'il y a bien un élément sélectionné
    if selected_index == nil then return nil end 
    if selected_index == 0 then return nil end 

    -- On récupère la valeur se trouvant à cet index
    local item_select = list.get_item(selected_index)

    -- Onretourne le resultat avec le select_item en premier element
    return item_select, string.find(item_select, self.REQUEST_SEPARATOR)
end


----------------------------------------------------------------
-- ACTIONS --
----------------------------------------------------------------

function RitnGuiPortal:action_close()   
    local frame = self.gui[1][self.gui_name.."-"..self.main_gui]
    if frame then frame.destroy() end
    log('> '..self.object_name..':action_close()')
    return self
end

function RitnGuiPortal:action_open(...)
    self:closeGuiEntity()
    self:action_close()
    self:create(...)
    log('> '..self.object_name..':action_open()')
    return self
end


-- Demande de liaison à un portail non lié d'une autre map
function RitnGuiPortal:action_request()
    local info = self:getElement("label", "info")
    local list = self:getElement("list", "surfaces")
    ---- recupération des infos
    local id = tonumber(info.caption[1])
    local surface_name = info.caption[2]
    ---- récupération de la surface à qui ont envoie la demande
    local selected_index = list.selected_index
    local select_detination = list.get_item(selected_index)

    ---- création de la demande de liaison
    local new_request = remote.call("RitnCoreGame", "get_data", "portal_request")
    new_request.id = id 
    new_request.surface_name = surface_name
    
    -- récupération des options
    local options = remote.call("RitnCoreGame", "get_options")
    -- récupération de toutes les demandes de liaison
    local requests = options.portal.requests

    -- création de la nouvelle demande
    requests[select_detination].input[surface_name] = new_request
    table.insert(requests[surface_name].output, select_detination)

    util.tryCatch(
        function() self:getSurface():getPortal(id, surface_name):addRequest(select_detination) end
    )

    -- Mise à jour des options
    options.portal.requests = requests
    remote.call("RitnCoreGame", "set_options", options)

    log('> '..self.object_name..':action_request()')
    self:action_close()
end


-- Annule la demande de liaison à un portail en cours
function RitnGuiPortal:action_unrequest()
    -- TODO: Refait le code de l'action_link en utilisant RitnSurface et RitnPortal comme un peu l'action_request
    -- Sa sera plus propre avec du code réutilisable
    -- set_text_tag par exemple
    -- berf tu vois le truc.
end


-- Demande de liaison accepté
function RitnGuiPortal:action_link()
    local info = self:getElement("label", "info")
    local list = self:getElement("list", "surfaces")
    ---- recupération des infos
    local id = tonumber(info.caption[1])
    local surface_name = info.caption[2]

    -- récupération de l'identité du demandeur
    local item_select, iStart, iEnd = self:indexOfRequestSeparator(list)
    if string.isEmptyString(item_select) or iEnd == nil then
        log('item_select is nil or empty or iEnd == nil')
        return
    end 

    -- Récupération de la surface de destination
    local surface_destination = string.sub(item_select, iEnd + 1, string.len(item_select))
    if string.isEmptyString(surface_destination) then 
        log('surface_destination is nil or empty')
        return 
    end

    -- récupération des options
    local options = remote.call("RitnCoreGame", "get_options")
    -- récupération de toutes les demandes de liaison
    local requests = options.portal.requests
    -- récupération de la demande entrantes de la destination
    local input_request = requests[surface_name].input[surface_destination]
    -- vérification que la demande est toujours présente
    if input_request == nil then 
        log('input_request is nil')
        return 
    end

    -- récupération des surfaces 
    local surfaces = remote.call("RitnCoreGame", "get_surfaces")
    -- récupération du portail demandeur
    local portal_destination = surfaces[input_request.surface_name].portals[input_request.id]
    -- vérification que le portail demandeur n'est pas déjà relié
    if portal_destination.destination ~= self.TOKEN_PORTAL_LINKED_SEPARATED then 
        log('portal_destination.destination ~= ' .. self.TOKEN_PORTAL_LINKED_SEPARATED)
        return 
    end
    -- vérification que le portail demandeur n'a pas fait une autre demande depuis.
    if portal_destination.request ~= surface_name then
        log('portal_destination.request ~= ' .. surface_name)
        return 
    end
    -- vérification que le type de demande est identique
    if portal_destination.type ~= input_request.type then 
        log('portal_destination.type ~= ' .. input_request.type)
        return 
    end
     
    -- récupération du portail actuel
    local portal_origine = surfaces[surface_name].portals[id]
    -- vérification que le portail n'est pas déjà relié
    if portal_origine.destination ~= self.TOKEN_PORTAL_LINKED_SEPARATED then 
        log('portal_origine.destination ~= ' .. self.TOKEN_PORTAL_LINKED_SEPARATED)
        return 
    end
    -- vérification que le portail n'a pas fait une autre demande depuis.
    if string.isNotEmptyString(portal_origine.request) then 
        log('portal_origine.request is nil or empty')
        return 
    end
    -- vérification que le type de portail est identique à la demande
    if portal_origine.type ~= input_request.type then 
        log('portal_origine.type ~= ' .. input_request.type)
        return 
    end

    -- Liaison établi on enregistre les changements
    portal_destination.destination = surface_name
    portal_destination.request = stringUtils.empty
    portal_origine.destination = input_request.surface_name
    portal_origine.request = stringUtils.empty

    -- récupération des render_id (texte render) et tag_number (gps) pour modification
    local render_id_destination = portal_destination.render_id
    local render_id_origine = portal_origine.render_id
    
    -- enregistrement des infos surfaces (liaison établit)
    surfaces[input_request.surface_name].portals[input_request.id] = portal_destination
    surfaces[surface_name].portals[id] = portal_origine
    remote.call("RitnCoreGame", "set_surfaces", surfaces)

    -- suppression des demandes entrantes/sortantes
    requests[surface_name].input[surface_destination] = nil
    local output_requests = requests[surface_destination].output
    for index,output in pairs(output_requests) do 
        if output == surface_name then 
            table.remove(output_requests, index)
        end
    end
    requests[surface_destination].output = output_requests
    options.portal.requests = requests

    -- on décrémente un portail linkable des compteurs
    if options.portal.linkable[surface_name] ~= nil then 
        if options.portal.linkable[surface_name] > 1 then 
            options.portal.linkable[surface_name] = options.portal.linkable[surface_name] - 1
        else
            options.portal.linkable[surface_name] = nil
        end
    end

    -- On ajoute le lien entre les 2 surfaces
    table.insert(options.portal.linked[surface_name], surface_destination)
    table.insert(options.portal.linked[surface_destination], surface_name)

    -- On enregistre les modifications des options portals
    remote.call("RitnCoreGame", "set_options", options)

    -- set rendering
    rendering.set_text(render_id_origine, surface_destination)
    rendering.set_text(render_id_destination, surface_name)

    -- set chart_tag (gps)
    local tag_origine = RitnCoreForce(game.forces[portal_origine.force_name]):getChartTag(
                                        portal_origine.tag_number, 
                                        portal_origine.surface_name, 
                                        portal_origine.position)
    if tag_origine ~= nil then
        tag_origine.text = surface_destination
        tag_origine.last_user = self.player
    end

    local tag_destination = RitnCoreForce(game.forces[portal_destination.force_name]):getChartTag(
                                        portal_destination.tag_number, 
                                        portal_destination.surface_name, 
                                        portal_destination.position)

    if tag_destination ~= nil then
        tag_destination.text = surface_destination
        tag_destination.last_user = self.player
    end

    log('> '..self.object_name..':action_link()')
    self:action_close()
end


-- Coupe la liaison établi entre les 2 portails
function RitnGuiPortal:action_unlink()
    
end

----------------------------------------------------------------
--return RitnGuiPortal
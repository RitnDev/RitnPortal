-- RitnGuiPortal
----------------------------------------------------------------
----------------------------------------------------------------
local font = ritnlib.defines.names.font
local stringUtils = require(ritnlib.defines.constants).strings
local types = require(ritnlib.defines.constants).types
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
end)

----------------------------------------------------------------


function RitnGuiPortal:create(...)
    if self.gui[1][self.gui_name.."-"..self.main_gui] then return self end
    local rPortal, selecter_index = ...
    if selecter_index == nil then selecter_index = 1 end
    
    local rPlayer = RitnCorePlayer(self.player)
    local isOwner = rPlayer:isOwner()
    
    if isOwner ~= true then 
        return self 
    elseif rPlayer:isOrigine() == false then 
        return self 
    end

    local elements = remote.call("RitnPortal", "get_gui_portal").elements
    local content = remote.call("RitnPortal", "create_portal_gui", self.gui[1], elements)

    local isLinked = rPortal:isLinked()
    local isRequester = rPortal:isRequester()
    local isPassenger = rPortal:isPassenger()

    log("> selecter_index: " .. tostring(selecter_index))
    log("> isOwner: " .. tostring(isOwner))
    log("> isLinked: " .. tostring(isLinked))
    log("> isRequester: " .. tostring(isRequester))
    log("> self.driving: " .. tostring(self.driving))
    log("> isPassenger: " .. tostring(isPassenger))

    -- Le portail est lié à un autre portail
    if isLinked then
        -- Le label enter est visible et affiche le fait d'entrée dans le portail pour se téléporter
        content["enter"].visible = true
        content["enter"].caption = ritnlib.defines.portal.names.caption.frame_portal.label_enter
        -- On retire la liste des surfaces
        content["flow-empty_surfaces"].visible = false
        -- On affiche le bouton d'annulation de liaison
        content["button-unlink"].visible = true
        content["button-unlink"].tooltip = {'tooltip.button-unlink', string.defaultValue(rPortal.data.destination.surface)}
  
        -- Le joueur est passagé du Portail (il doit sortir)
        if self.driving and isPassenger then 
            -- on affiche un message qui l'invite à sortir
            content["enter"].caption = ritnlib.defines.portal.names.caption.frame_portal.label_passenger
        end
    else 
        -- Le portail n'est pas lié on affiche potentiellement la liste des surfaces 
        -- (ou le fait qu'il y en a pas de dispo)
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
    
    RitnLibStyle(content["frame-top"]):topPadding(4):rightPadding(8):leftPadding(8)
    RitnLibStyle(content["header"]):verticalStretch(false)
    RitnLibStyle(content["dragspace"]):stretchable():height(24):rightMargin(8)
    RitnLibStyle(content["flow-namer"]):padding(4)
    RitnLibStyle(content["namer"]):font(font.bold16):width(275)
    RitnLibStyle(content["submain"]):padding(4):margin(4):stretchable()
    RitnLibStyle(content["enter"]):padding(4)
    RitnLibStyle(content["flow-empty_surfaces"]):padding(4):height(40)
    RitnLibStyle(content["button-empty_surfaces"]):stretchable():fontColor("white", true, true)
    RitnLibStyle(content["flow-surfaces"]):padding(4):stretchable():bottomPadding(0)
    RitnLibStyle(content["list-surfaces"]):horizontalStretch():maxHeight(500)
    RitnLibStyle(content["empty-empty"]):stretchable()
    RitnLibStyle(content["flow-dialog_surfaces"]):padding(4)
    RitnLibStyle(content["button-request"]):align("right"):spriteButton()
    RitnLibStyle(content["button-link"]):align("right"):spriteButton()
    RitnLibStyle(content["button-unlink"]):spriteButton()
    RitnLibStyle(content["button-unrequest"]):spriteButton()

    local listSurfacesNotEmpty = false
    
    -- Votre portail est en cours de demande de liaison avec une destination
    if isRequester == true then 
        content["flow-surfaces"].visible = false
        content["flow-empty_surfaces"].visible = false

        content["namer"].caption = rPortal:getRequest()
        content["button-unrequest"].visible = true
        content["button-unrequest"].tooltip = {'tooltip.button-unrequest', string.defaultValue(rPortal.data.request)}
  
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



-- Retourne l'id enregistré dans l'interface graphique
function RitnGuiPortal:getId()
    log('> '..self.object_name..':getId()')
    ----
    local id_portal = tonumber(self:getElement("label", "info").caption[1]) -- id_portal
    return tonumber(id_portal)
end



-- Retourne le nom de la surface enregistré dans l'interface graphique
function RitnGuiPortal:getSurfaceName()
    log('> '..self.object_name..':getSurfaceName()')
    ----
    return self:getElement("label", "info").caption[2] -- surface_name
end



-- Retourne le nom de la surface enregistré dans l'interface graphique
function RitnGuiPortal:getPortalType()
    log('> '..self.object_name..':getPortalType()')
    ----
    return self:getElement("label", "info").caption[3] -- type_portal
end



-- Retourne la RitnSurface (surface) associé au GUI
function RitnGuiPortal:getSurface()
    log('> '..self.object_name..':getSurface()')
    ----
    local surface_name = self:getSurfaceName()
    if string.isNotEmptyString(surface_name) and type(game.surfaces[surface_name]) ~= 'nil' then 
        return RitnPortalSurface(game.surfaces[surface_name])
    end
end


-- Retourne le RitnPortal associé au GUI via le getSurface()
function RitnGuiPortal:getPortal()
    log('> '..self.object_name..':getPortal()')
    ----
    -- Récupération de la surface
    local rSurface = self:getSurface()

    -- si on a bien une RitnSurface, on peut utiliser la methode getPortal()
    if util.type(rSurface) ~= "RitnPortalSurface" then return end 
    local id_portal = self:getId()
    return rSurface:getPortal(id_portal)
end



-- Action sur le GUI à faire lors de la selection dans la liste des surfaces
function RitnGuiPortal:selectListSurfacesChange(list, selecter_index)
    if list == nil then return end
    if list.valid == false then return end
    ----
    local button_request = self:getElement("button","request")
    local button_link = self:getElement("button","link")
    ----

    -- retourne l'element selectionné dans la liste et les position d'extraction du demandeur si présent
    local item_select, iStart, iEnd = self:indexOfRequestSeparator(list, selecter_index)
    log("> item_select: " .. tostring(item_select))
    log("> iStart: " .. tostring(iStart))
    log("> iEnd: " .. tostring(iEnd))

    log("> fonction isNotNil(iEnd): " .. tostring(string.isNotNil(iEnd)))

    -- Extrait le nom du demandeur ou retourne une chaine vide
    local input_request_name = string.TOKEN_EMPTY_STRING
    local vResult = string.TOKEN_EMPTY_STRING

    util.tryCatch(
        function() 
            vResult = string.sub(item_select, iEnd + 1, string.len(item_select))
        end,
        function()
            vResult = string.TOKEN_EMPTY_STRING
        end
    )
    -- securité pour évité les problèmes
    input_request_name = string.defaultValue(vResult)

    
    -- On vérifie qu'il y a bien un élément sélectionné
    button_request.enabled = string.isNotNil(item_select)
    button_link.enabled = string.isNotNil(item_select)

    -- on stop ici si rien n'est sélectionné
    if string.isEmptyString(item_select) then return end 
    
    -- Gestion de visibilité des boutons
    button_request.visible = string.isNil(iStart)
    button_link.visible = string.isNotNil(iStart)
    -- on met à jour les tooltips
    button_request.tooltip = {'tooltip.button-request', string.defaultValue(item_select)}  
    button_link.tooltip = {'tooltip.button-link', string.defaultValue(input_request_name)}

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

-- Close the GUI
function RitnGuiPortal:action_close()   
    local frame = self.gui[1][self.gui_name.."-"..self.main_gui]
    if frame then frame.destroy() end
    log('> '..self.object_name..':action_close()')
    return self
end


-- open the GUI
function RitnGuiPortal:action_open(...)
    self:closeGuiEntity()
    self:action_close()
    self:create(...)
    log('> '..self.object_name..':action_open()')
    return self
end




-- Demande de liaison à un portail non lié d'une autre map
function RitnGuiPortal:action_request()
    log('> '..self.object_name..':action_request()')
    ----
    -- On récupère la destination, c'est a dire l'element selectionné dans la liste
    local select_destination = self:getListSelectedItem('list', 'surfaces')
    log('> RitnGuiPortal:action_request() => select_destination: ' .. tostring(select_destination))

    util.tryCatch(
        function() 
            local rPortal = self:getPortal()
            log('> RitnGuiPortal:action_request() => (try) : rPortal:addRequest(select_destination) ')
            rPortal:addRequest(select_destination)
        end
    )

    log('> '..self.object_name..':action_request()')
    self:action_close()
end




-- Annule la demande de liaison à un portail en cours
function RitnGuiPortal:action_unrequest()
    log('> '..self.object_name..':action_unrequest()')
    ----
    util.tryCatch(
        function() 
            local rPortal = self:getPortal()
            rPortal:removeRequest()
        end
    )
    ----
    self:action_close()
end



-- Demande de liaison accepté
function RitnGuiPortal:action_link()
    local list = self:getElement("list", "surfaces")

    if util.isType(self:getId(), types.number) == false then 
        log('id is nil')
        return self:action_close() 
    end

    if string.isEmptyString(self:getSurfaceName()) then 
        log('surface_name is nil or empty')
        return self:action_close() 
    end

    -- récupération de l'identité du demandeur
    local item_select, iStart, iEnd = self:indexOfRequestSeparator(list)
    if string.isEmptyString(item_select) or iEnd == nil then
        log('item_select is nil or empty or iEnd == nil')
        return self:action_close()
    end 

    -- Récupération de la surface de destination
    local surface_destination = string.sub(item_select, iEnd + 1, string.len(item_select))
    if string.isEmptyString(surface_destination) then 
        log('surface_destination is nil or empty')
        return self:action_close() 
    end

    -- récupération des options
    local options = remote.call("RitnCoreGame", "get_options")
    -- récupération de la demande entrantes de la destination
    local input_request = options.portal.requests[self:getSurfaceName()].input[surface_destination]
    -- vérification que la demande est toujours présente
    if input_request == nil then 
        log('input_request is nil')
        return self:action_close() 
    end

    -- Instanciation des portails d'origine et de destination
    local rPortalOrigine
    local rPortalDestination
    -- Instanciation de la surface actuelle (surface qui accepte une liaison exterieur)
    local rSurface

    -- Récupération du RitnPortal (origine)
    util.tryCatch(
        function() 
            rSurface = self:getSurface()
            rPortalOrigine = self:getPortal()
        end
    )
    if rSurface == nil then
        log('> RitnGuiPortal:action_link() => rSurface (origine) is nil') 
        return self:action_close() 
    end
    if rPortalOrigine == nil then
        log('> RitnGuiPortal:action_link() => RitnPortal (origine) is nil') 
        return self:action_close() 
    end

    -- Récupération du RitnPortal (destination)
    util.tryCatch(
        function() 
            local rSurfaceDestination = RitnPortalSurface(game.surfaces[surface_destination])
            rPortalDestination = rSurfaceDestination:getPortal(input_request.id)
            log('> RitnGuiPortal:action_link() => (try) id: ' .. input_request.id)
        end,
        function() log('RitnGuiPortal:action_link() => (CATCH) id: '..tostring(input_request.id)) end
    )
    if rPortalDestination == nil then 
        log('> RitnGuiPortal:action_link() => RitnPortal (destination) is nil') 
        return self:action_close() 
    end
    
    -- On check que la liaison est possible sur les 2 portails
    if rPortalOrigine:checkBeforeAddLink(nil, input_request.type) == false then return self:action_close() end
    if rPortalDestination:checkBeforeAddLink(self:getSurfaceName(), input_request.type) == false then return self:action_close() end

    -- Création de la liaison entre les deux portails
    rPortalOrigine:addLink(input_request.id, surface_destination, self.player)
    rPortalDestination:addLink(self:getId(), self:getSurfaceName(), self.player)

    -- on supprime la requete input/output en lien avec la liaison en cours
    -- on décrémente un portail linkable du compteur
    rSurface:removeRequestPortal(surface_destination, true):removeLinkablePortal()

    -- fermeture du gui_portal
    self:action_close()
end




-- Coupe la liaison établi entre les 2 portails
function RitnGuiPortal:action_unlink()
    log('> '..self.object_name..':action_unlink()')

    local rPortal = self:getPortal()
    local rSurface = self:getSurface()
    local destination = {
        id_portal = rPortal:getDestinationIdPortal(),
        surface_name = rPortal:getDestination()
    }

    log('destination = { id_portal: '.. tostring(destination.id_portal) .. ', surface_name: ' .. tostring(destination.surface_name) .. ' }')

    -- Suppression du lien sur le portail d'origine
    rPortal:removeLink(self.player)

    if destination.id_portal > 0 then 
        -- on récupère le portail sur la surface de destination
        local rPortalDest = rSurface:getPortal(destination.id_portal, destination.surface_name)
        
        -- suppression du lien sur le portail de destination
        rPortalDest:removeLink(self.player)

    end

    -- fermeture du gui_portal
    self:action_close()
end

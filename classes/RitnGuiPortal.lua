-- RitnGuiPortal
----------------------------------------------------------------
local class = require(ritnlib.defines.class.core)
local libStyle = require(ritnlib.defines.class.gui.style)
local libGui = require(ritnlib.defines.class.luaClass.gui)
----------------------------------------------------------------
local RitnPlayer = require(ritnlib.defines.core.class.player)
local RitnPortal = require(ritnlib.defines.portal.class.portal)
----------------------------------------------------------------
local font = ritnlib.defines.names.font
local fGui = require(ritnlib.defines.portal.gui.portal)
local table = require(ritnlib.defines.table)
----------------------------------------------------------------
--- CLASSE DEFINES
----------------------------------------------------------------
local RitnGuiPortal = class.newclass(libGui, function(base, event)
    libGui.init(base, event, ritnlib.defines.portal.name, "frame-main")
    base.object_name = "RitnGuiPortal"
    --------------------------------------------------
    base.gui_name = "portal"
    base.gui_action = {
        [base.gui_name] = {
            [ritnlib.defines.portal.gui_actions.portal.open] = true,
            [ritnlib.defines.portal.gui_actions.portal.close] = true,
            [ritnlib.defines.portal.gui_actions.portal.teleport] = true,
            [ritnlib.defines.portal.gui_actions.portal.edit] = true,
            [ritnlib.defines.portal.gui_actions.portal.valid] = true,
            [ritnlib.defines.portal.gui_actions.portal.up] = true,
            [ritnlib.defines.portal.gui_actions.portal.down] = true,
        }
    }    
    --------------------------------------------------
    base.gui = { base.player.gui.screen }
    --------------------------------------------------
    base.content = fGui.getContent()
    --------------------------------------------------
end)

----------------------------------------------------------------


function RitnGuiPortal:create(...)
    if self.gui[1][self.gui_name.."-"..self.main_gui] then return self end
    local rPortal, selecter = ...
    if selecter == nil then selecter = 1 end

    local element = fGui.getElement(self.gui_name)

    -- assembly gui elements
    local content = {
        flow = {},
        frame = {},
        label = {},
        button = {},
    }


    -- frame Portal
    content.frame.main =            self.gui[1].add(element.frame.main)
    content.frame.submain =         content.frame.main.add(element.frame.submain)
    -- label info
    content.label.info =            content.frame.submain.add(element.label.info)
    -- flow namer
    content.flow.namer =            content.frame.submain.add(element.flow.namer)
    -- label namer
    content.label.namer =           content.flow.namer.add(element.label.namer)
    -- button edit
    content.button.edit =           content.flow.namer.add(element.button.edit)
    -- flow namer
    content.flow.edit =             content.frame.submain.add(element.flow.edit)
    -- label namer
    content.text =                  content.flow.edit.add(element.text)
    -- button edit
    content.button.valid =          content.flow.edit.add(element.button.valid)
    -- line 
    content.line =                  content.frame.submain.add(element.line)

    -- label enter
    content.label.enter =           content.frame.submain.add(element.label.enter)

    -- empty list teleport
    content.flow.empty =            content.frame.submain.add(element.flow.empty)
    content.button.empty =          content.flow.empty.add(element.button.empty)

    -- flow teleport
    content.flow.teleport =         content.frame.submain.add(element.flow.teleport)
    -- list surfaces
    content.list =                  content.flow.teleport.add(element.list)
    -- flow dialog
    content.flow.dialog =           content.flow.teleport.add(element.flow.dialog)
    -- button edit
    content.button.down =           content.flow.dialog.add(element.button.down)
    -- button edit
    content.button.up =             content.flow.dialog.add(element.button.up)
    -- empty
    content.empty =                 content.flow.dialog.add(element.empty)
    -- button request
    content.button.teleport =       content.flow.dialog.add(element.button.teleport)
    


    local driving = false
    if self.driving and rPortal.drive ~= nil then
        if rPortal.drive.name == self.name then 
            content.label.enter.visible = false
            driving = true
        elseif rPortal.drive.type == "character" then 
            if rPortal.drive.player.name == self.name then 
                content.label.enter.visible = false
                driving = true
            end
        end
    elseif self.driving == false then 
        content.label.enter.caption = ritnlib.defines.portal.names.caption.frame_portal.label_enter
    end

    -- styles guiElement
    content.label.info.caption = {rPortal.data.id, rPortal.data.surface_name}
    content.label.namer.caption = rPortal.data.name
    content.text.text = rPortal.data.name
    content.frame.main.auto_center = true
    ----
    libStyle(content.frame.main):padding(4)
    libStyle(content.frame.submain):padding(4):stretchable()
    libStyle(content.flow.namer):padding(4)
    libStyle(content.label.namer):font(font.bold18):width(275)
    libStyle(content.button.edit):spriteButton(28)
    libStyle(content.flow.edit):padding(8)
    libStyle(content.text):font(font.default18):width(275)
    libStyle(content.button.valid):spriteButton(28)
    libStyle(content.label.enter):padding(4)
    libStyle(content.flow.teleport):padding(4):stretchable()
    libStyle(content.list):horizontalStretch():maxHeight(500)
    libStyle(content.flow.dialog):horizontalStretch():topPadding(4)
    libStyle(content.button.down):spriteButton(28)
    libStyle(content.button.up):spriteButton(28)
    libStyle(content.empty):stretchable()
    libStyle(content.button.teleport):height(30)
    libStyle(content.flow.empty):padding(4):height(80)
    libStyle(content.button.empty):stretchable():fontColor("white", true, true)

    
    if driving then

        local surfaces = remote.call('RitnCoreGame', 'get_surfaces')
        local portals = surfaces[rPortal.surface.name].portals
        local nbPortal = table.length(portals) - 1

        if nbPortal > 0 then 
            content.flow.teleport.visible = true

            local thisIndex = rPortal.data.index   
            -- temporary table portal sort by index
            local tabTemp = {}
            for i,value in pairs(portals) do 
                tabTemp[portals[i].index] = value
            end

            --> add portal on the list
            for _,portal in pairs(tabTemp) do 
                if portal.name ~= nil then
                    if thisIndex ~= portal.index then
                        content.list.add_item(portal.name)
                    end
                end
            end 
            content.list.selected_index = selecter
        else 
            content.flow.empty.visible = true
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



function RitnGuiPortal:action_teleport()
    local info = self:getElement("label", "info")
    local list = self:getElement("list")
    ----
    local surface_name = info.caption[2]
    local selected_index = list.selected_index
    local item_select = list.get_item(selected_index)
    ----
    local surfaces = remote.call("RitnCoreGame", "get_surfaces")
    local portals = surfaces[surface_name].portals
    local id = table.index(portals, 'name', item_select)
    local portal = portals[id]
    
    local tabEntities = game.surfaces[surface_name].find_entities_filtered({
        name=ritnlib.defines.portal.names.entity.portal, 
        type='car',
        position=portal.position,
    })
    if table.length(tabEntities) > 0 then 
        tabEntities[1].set_passenger(self.player)
    end
    log('> '..self.object_name..':action_teleport('.. self.player.name ..')')
    return self
end


function RitnGuiPortal:action_edit()
    local flow_edit = self:getElement("flow", "edit")
    local flow_namer = self:getElement("flow", "namer")
    local textfield = self:getElement("text")
    ----
    flow_namer.visible = false
    flow_edit.visible = true
    ----
    textfield.select_all()
    textfield.focus()
    ----
    log('> '..self.object_name..':action_edit('.. self.player.name ..')')
    return self
end


function RitnGuiPortal:action_valid()
    local textfield = self:getElement("text")
    local info = self:getElement("label", "info")
    ----
    local id = tonumber(info.caption[1])
    local surface_name = info.caption[2]
    ----
    local surfaces = remote.call("RitnCoreGame", "get_surfaces")
    local render_id = surfaces[surface_name].portals[id].render_id
    local position = surfaces[surface_name].portals[id].position
    local force_name = surfaces[surface_name].portals[id].force_name
    ----
    surfaces[surface_name].portals[id].name = textfield.text
    
    -- set rendering
    rendering.set_text(render_id, textfield.text)

    -- set tag map
    local area = {
        {position.x - 0.5, position.y - 0.5},
        {position.x + 0.5, position.y + 0.5},
    }
    local tabTag = game.forces[force_name].find_chart_tags(surface_name, area)

    if table.length(tabTag) > 0 then 
        tabTag[1].text = textfield.text
        tabTag[1].last_user = self.player
    end
    ----
    remote.call("RitnCoreGame", "set_surfaces", surfaces)
    ----
    self:action_close()
    log('> '..self.object_name..':action_valid('.. self.player.name ..')')
    return self
end


function RitnGuiPortal:action_up()
    local info = self:getElement("label", "info")
    local list = self:getElement("list")
    ----
    local id = tonumber(info.caption[1])
    local surface_name = info.caption[2]
    local selected_index = list.selected_index
    ----
    if selected_index == 0 then return self end
    ----
    local surfaces = remote.call("RitnCoreGame", "get_surfaces")
    local portals = surfaces[surface_name].portals
    local portal = portals[id]
    ----
    local item_select = list.get_item(selected_index)
    local id_select = table.index(portals, 'name', item_select)
    local portal_select = portals[id_select]
    ----
    local tabTemp = {}
    for i,value in pairs(portals) do 
        tabTemp[portals[i].index] = value
    end
    ----
    local pass = false
    local new_index = portal_select.index
    if portal_select.index - 1 == portal.index then 
        pass = true
        new_index = new_index - 2
    else 
        new_index = new_index - 1
    end
    -- check si pas déjà en haut de la liste
    if new_index == 0 then return self end
    ----
    table.remove(tabTemp, portal_select.index)
    table.insert(tabTemp, new_index, portal_select)
    tabTemp[new_index].index = new_index
    if pass then 
        tabTemp[new_index + 1].index = new_index + 1
        tabTemp[new_index + 2].index = new_index + 2
    else 
        tabTemp[new_index + 1].index = new_index+1
    end
    ----
    local tmp_portals = portals
    portals = {}
    for id,value in pairs(tmp_portals) do 
        portals[id] = value
        for y,_ in pairs(tabTemp) do 
            if tabTemp[y].id == id then 
                portals[id].index = tabTemp[y].index
            end
        end
    end
    ----
    surfaces[surface_name].portals = portals
    remote.call("RitnCoreGame", "set_surfaces" , surfaces)
    local rPortal = RitnPortal(self.vehicle)
    if rPortal.data.index < portal_select.index then 
        new_index = new_index - 1
    end
    self:action_open(rPortal, new_index)
    ----
    log('> '..self.object_name..':action_up('.. self.player.name ..')')
    return self
end

-- permet de descendre un element de la liste des portals
function RitnGuiPortal:action_down()
    -- recupere le label "info" (il est invisible sur l'interface et permet d'avoir des info sur le portal id + surface)
    local info = self:getElement("label", "info")
    local list = self:getElement("list")
    ----
    local id = tonumber(info.caption[1]) -- recuperation de l'id : unit_number de l'entité Portal
    local surface_name = info.caption[2] -- surface où se trouve l'entité Portal
    local selected_index = list.selected_index -- index selectionné dans la liste actuellement
    ----
    if selected_index == 0 then return self end
    ---- 
    local surfaces = remote.call("RitnCoreGame", "get_surfaces")
    local portals = surfaces[surface_name].portals
    local portal = portals[id]
    local nbPortal = table.length(portals)
    ----
    local item_select = list.get_item(selected_index)
    local id_select = table.index(portals, 'name', item_select)
    local portal_select = portals[id_select]
    ----
    local tabTemp = {}
    for i,value in pairs(portals) do 
        tabTemp[portals[i].index] = value
    end
    ----
    local pass = false
    local new_index = portal_select.index
    if portal_select.index + 1 == portal.index then 
        pass = true
        new_index = new_index + 2
    else 
        new_index = new_index + 1
    end
    -- check si pas déjà en bas de la liste
    if new_index == nbPortal + 1 then return self end
    ----
    table.remove(tabTemp, portal_select.index)
    portal_select.index = new_index
    if pass then 
        tabTemp[new_index] = portal_select
        tabTemp[new_index-1].index = new_index-1
        tabTemp[new_index-2].index = new_index-2
    else 
        tabTemp[new_index] = portal_select
        tabTemp[new_index-1].index = new_index-1
    end
    ----
    local tmp_portals = portals
    portals = {}
    for id,value in pairs(tmp_portals) do 
        portals[id] = value
        for y,_ in pairs(tabTemp) do 
            if tabTemp[y].id == id then 
                portals[id].index = tabTemp[y].index
            end
        end
    end
    ----
    surfaces[surface_name].portals = portals
    remote.call("RitnCoreGame", "set_surfaces" , surfaces)
    local rPortal = RitnPortal(self.vehicle)
    if rPortal.data.index < portal_select.index then 
        new_index = new_index - 1
    end
    self:action_open(rPortal, new_index)
    ----
    log('> '..self.object_name..':action_down('.. self.player.name ..')')
    return self
end


----------------------------------------------------------------
return RitnGuiPortal
-----------------------------------------
--               DEFINES               --
-----------------------------------------
if not ritnlib then require("__RitnLobbyGame__.core.defines") end
-----------------------------------------
local name = "RitnPortal"
local dir = "__".. name .."__"
local directory = dir .. "."
-----------------------------------------
local defines = {}

-- Mod ID.
defines.name = name
-- Path to the mod's directory.
defines.directory = dir

-- classes
defines.class = {
    surface = dir .. ".classes.RitnSurface",
    portal = dir .. ".classes.RitnPortal",
    ----
    guiPortal = dir .. ".classes.RitnGuiPortal",
}


-- Modules
defines.modules = {
    core = dir .. ".core.modules",
    globals = dir .. ".modules.globals",
    events = dir .. ".modules.events",
    ----
    player = dir .. ".modules.player",
    portal = dir .. ".modules.portal",
    ----
}


-- graphics
local graphics = dir .. "/graphics/"
local gui = graphics .. "gui/"
defines.graphics = {
    gui = {
        button_close = gui .. "close-white.png",
        button_link = gui .. "icon-link-white.png",
        button_unlink = gui .. "icon-unlink-white.png",
        inbound_link = gui .. "inbound-link-white.png",
        button_ask_link = gui .. "ask-link-white.png",
        button_unrequest = gui .. "ask-cancel-white.png"
    },
    entity = {
        portal = graphics .. "entity/ritn-portal/ritn-portal.png",
    },
    techno = {
        teleport = graphics .. "technology/portal-64.png",
        capsule = graphics .. "icons/portal-capsule.png",
    },
    icon = {
        portal = graphics .. "icons/portal-64.png",
        remote = graphics .. "icons/portal-remote.png",
        capsule = graphics .. "icons/portal-capsule.png",
    },
    empty = "__core__/graphics/empty.png",
}

-- sounds
local sounds = dir .. "/sounds/"
defines.sound = {
    none = sounds .. "none.ogg",
    open = sounds .. "portal_open.ogg",
    close = sounds .. "portal_close.ogg",
}


-- prototypes
local dir_proto = directory .. "prototypes."
defines.prototypes = {
    category = dir_proto .. "category",
    entity = dir_proto .. "entity.ritn-portal",
    item = dir_proto .. "items",
    technology = dir_proto .. "technology",
    styles = dir_proto .. "styles",
    inputs = dir_proto .. "custom-inputs",
}


-- Prefix
defines.prefix = {
    name = "ritnmods-",
    mod = "portal-",
}


-- gui
defines.gui = {}
local dir_gui = directory .. "gui."
---------------------------
defines.gui.portal = dir_gui .. "portal"
---------------------------


defines.gui_actions = {
    portal = {
        open = "open",
        close = "close",
        list_select_change = "listbox-surfaces-selection_state_changed",
        button_close = "button-close",
        button_unlink = "button-unlink",
        button_link = "button-link",
        button_request = "button-request",
        button_unrequest = "button-unrequest",
    },
}



--settings 
local settings_prefix = defines.prefix.name .. defines.prefix.mod
defines.settings = {
    prefix = settings_prefix,
    show_research = {
        name = settings_prefix .. "show-research",
        value = true, 
    }
}


-- Name and value
defines.names = {

    item_group = {
        teleport = "logistics",
    },
    item_subgroups = {
        teleport = "ritn-teleportation",
    },
    entity = {
        portal = "ritn-portal", 
    },
    item = {
        capsule = "ritn-portal-capsule", 
    },
    recipe = {
        capsule = "ritn-portal-capsule", 
    },
    technology = {
        teleport = "tech-ritn-portal-teleportation",
        capsule = "tech-ritn-portal-teleportation",
    },
    gui = {
        portal = "portal"
    },


    --GUI STYLES
    styles = {
        spriteButton = "style_sprite_button_ritn",
        ritnFrameButton = "ritn_frame_button"
    },
    sprite = {
        inbound_link = "sprite_inbound_link",
        button_ask_link = "sprite_button_ask_link",
        button_close = "sprite_button_close",
        button_link = "sprite_button_link",
        button_unlink = "sprite_button_unlink",
        button_unrequest = "sprite_button_unrequest",
    },
    customInput = {
        frame_close1 = defines.prefix.name .. "close-frame-portal1",
        frame_close2 = defines.prefix.name .. "close-frame-portal2",
    }
    
}


-- GUI element captions.
defines.names.caption = {

    msg = {       
        cursor = {"msg.cursor"},
    },

    frame_portal = {
        titre = {"entity-name.ritn-portal"},
        label_enter = {"frame-portal.label-enter"},
        label_passenger = {"frame-portal.label-passenger"},
        label_list_destinations = {"frame-portal.label-list-destinations"},
        button_teleport = {"frame-portal.teleport-button"},
        button_empty = {"frame-portal.button-empty"},
        button_request = {"frame-portal.button-request"},
        not_link = {"frame-portal.not_link"},
        link = "frame-portal.link",
        request = "frame-portal.request",
        dest_not_find = {"frame-portal.dest-not-find"},
        linkable_not_find = {"frame-portal.linkable-not-find"},
    }

}

----------------
ritnlib.defines.portal = defines
log('declare : ritnlib.defines.portal | '.. ritnlib.defines.portal.name ..' -> finish !')
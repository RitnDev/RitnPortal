-----------------------------------------
--               DEFINES               --
-----------------------------------------
if not ritnlib then require("__RitnBaseGame__.core.defines") end
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
        button_edit = gui .. "edit.png",
        button_up = gui .. "up.png",
        button_down = gui .. "down.png",
        button_valid = gui .. "valid.png",
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
        teleport = "button-teleport",
        edit = "button-edit",
        valid = "button-valid",
        up = "button-up",
        down = "button-down",
    },
}



--settings 
local settings_prefix = defines.prefix.name .. defines.prefix.mod
defines.settings = {
    portal_enable = {
        name = settings_prefix .. "portal-enable",
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
        remote = "ritn-portal-remote", 
        capsule = "ritn-portal-capsule", 
    },
    recipe = {
        remote = "ritn-portal-remote", 
        capsule = "ritn-portal-capsule", 
    },
    technology = {
        teleport = "tech-ritn-portal-teleportation",
        capsule = "tech-ritn-portal-teleportation",
    },


    --GUI STYLES
    styles = {
        spriteButton = "style_sprite_button_ritn",
        ritnFrameButton = "ritn_frame_button"
    },
    sprite = {
        button_edit = "sprite_button_edit",
        button_up = "sprite_button_up",
        button_down = "sprite_button_down",
        button_valid = "sprite_button_valid",
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
        button_teleport = {"frame-portal.teleport-button"},
        button_empty = {"frame-portal.button-empty"},
    }

}

----------------
ritnlib.defines.portal = defines
log('declare : ritnlib.defines.portal | '.. ritnlib.defines.portal.name ..' -> finish !')
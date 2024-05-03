local libGuiElement = require(ritnlib.defines.class.gui.element)
local captions = ritnlib.defines.portal.names.caption.frame_portal
local defines = ritnlib.defines.portal.names


local function getElement(gui_name)
    return {
        flow = {
            namer = libGuiElement(gui_name,"flow","namer"):horizontal():get(),
            edit = libGuiElement(gui_name,"flow","edit"):horizontal():visible(false):get(),
            teleport = libGuiElement(gui_name,"flow","teleport"):vertical():visible(false):get(),
            dialog = libGuiElement(gui_name,"flow","dialog"):horizontal():get(),
            empty = libGuiElement(gui_name,"flow","empty"):horizontal():visible(false):get(),
        },
        frame = {
            main = libGuiElement(gui_name,"frame","main"):caption(captions.titre):get(),
            submain = libGuiElement(gui_name,"frame","submain"):vertical():style("inside_shallow_frame"):get(),
        },
        label = {
            info = libGuiElement(gui_name,"label","info"):visible(false):get(),
            namer = libGuiElement(gui_name,"label","namer"):get(),
            enter = libGuiElement(gui_name,"label","enter"):caption(captions.label_passenger):get(),
        },
        button = {
            edit = libGuiElement(gui_name,"sprite-button","edit"):spritePath(defines.sprite.button_edit):style("frame_button"):get(),
            valid = libGuiElement(gui_name, "sprite-button", "valid"):spritePath(defines.sprite.button_valid):style("frame_button"):get(),
            down = libGuiElement(gui_name,"sprite-button","down"):spritePath(defines.sprite.button_down):style("frame_button"):get(),
            up = libGuiElement(gui_name,"sprite-button","up"):spritePath(defines.sprite.button_up):style("frame_button"):get(),
            teleport = libGuiElement(gui_name,"button","teleport"):style("confirm_button"):caption(captions.button_teleport):get(),
            empty = libGuiElement(gui_name, "button", "empty"):style(ritnlib.defines.portal.names.styles.ritnFrameButton):caption(captions.button_empty):enabled(false):get(),
        },
        line = libGuiElement(gui_name,"line","line"):horizontal():get(),
        text = libGuiElement(gui_name, "textfield", "namer"):get(),
        list = libGuiElement(gui_name,"list-box","portals"):get(),
        empty = libGuiElement(gui_name,"empty-widget","empty"):get(),
    }
end


local function getContent()
    return {
        flow = {
            namer = {
                "frame-main",
                "frame-submain",
                "flow-namer",
            },
            edit = {
                "frame-main",
                "frame-submain",
                "flow-edit",
            },
            teleport = {
                "frame-main",
                "frame-submain",
                "flow-teleport",
            },
            dialog = {
                "frame-main",
                "frame-submain",
                "flow-teleport",
                "flow-dialog",
            },
            empty = {
                "frame-main",
                "frame-submain",
                "flow-empty",
            },
        },
        frame = {
            main = {"frame-main"},
            submain = {
                "frame-main",
                "frame-submain",
            },
        },
        label = {
            info = {
                "frame-main",
                "frame-submain",
                "label-info",
            },
            namer = {
                "frame-main",
                "frame-submain",
                "flow-namer",
                "label-namer",
            },
            enter = {
                "frame-main",
                "frame-submain",
                "label-enter",
            },
        },
        button = {
            namer = {
                "frame-main",
                "frame-submain",
                "flow-namer",
                "button-namer",
            },
            edit = {
                "frame-main",
                "frame-submain",
                "flow-namer",
                "button-edit",
            },
            valid = {
                "frame-main",
                "frame-submain",
                "flow-edit",
                "button-valid",
            },
            empty = {
                "frame-main",
                "frame-submain",
                "flow-empty",
                "button-empty",
            },
            up = {
                "frame-main",
                "frame-submain",
                "flow-teleport",
                "flow-dialog",
                "button-up",
            },
            down = {
                "frame-main",
                "frame-submain",
                "flow-teleport",
                "flow-dialog",
                "button-down",
            },
            teleport = {
                "frame-main",
                "frame-submain",
                "flow-teleport",
                "flow-dialog",
                "button-teleport",
            },
        },
        text = {
            "frame-main",
            "frame-submain",
            "flow-edit",
            "textfield-namer"
        },
        list = {
            "frame-main",
            "frame-submain",
            "flow-teleport",
            "listbox-portals",
        },
    }
end


-----------------------------------------
return {
    getElement = getElement,
    getContent = getContent,
}
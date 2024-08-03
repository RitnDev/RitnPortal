local captions = ritnlib.defines.portal.names.caption.frame_portal
local defines = ritnlib.defines.portal.names
local gui_name = ritnlib.defines.portal.names.gui.portal

local element = {
    flow = {
        header = RitnLibGuiElement(gui_name,"flow","header"):horizontal():get(),
        namer = RitnLibGuiElement(gui_name,"flow","namer"):horizontal():get(),
        surfaces = RitnLibGuiElement(gui_name,"flow","surfaces"):vertical():visible(false):get(),
        dialog_surfaces = RitnLibGuiElement(gui_name,"flow","dialog_surfaces"):horizontal():get(),
        empty_surfaces = RitnLibGuiElement(gui_name,"flow","empty_surfaces"):horizontal():visible(false):get(),
    },
    frame = {
        main = RitnLibGuiElement(gui_name,"frame","main"):vertical():style("frame-ritngui"):get(),
        top = RitnLibGuiElement(gui_name,"frame","top"):style("frame-bg-ritngui"):get(),
        submain = RitnLibGuiElement(gui_name,"frame","submain"):vertical():style("inside_shallow_frame"):get(),
    },
    label = {
        title = RitnLibGuiElement(gui_name, "label", "title"):caption(captions.titre):style("frame_title"):get(),
        info = RitnLibGuiElement(gui_name,"label","info"):visible(false):get(),
        namer = RitnLibGuiElement(gui_name,"label","namer"):get(),
        enter = RitnLibGuiElement(gui_name,"label","enter"):caption(captions.label_passenger):get(),
        list_dest = RitnLibGuiElement(gui_name,"label","list_dest"):caption(captions.label_list_destinations):get(),
    },
    button = {
        close = RitnLibGuiElement(gui_name,"sprite-button","close"):spritePath('utility/close_white'):style("frame_action_button"):mouseButtonFilter():get(),
        valid = RitnLibGuiElement(gui_name, "sprite-button", "valid"):spritePath(defines.sprite.button_valid):style("frame_button"):get(),
        link = RitnLibGuiElement(gui_name,"sprite-button","link"):spritePath(defines.sprite.button_link):style("frame_action_button"):visible(false):get(),
        unlink = RitnLibGuiElement(gui_name,"sprite-button","unlink"):spritePath(defines.sprite.button_unlink):style("frame_action_button"):visible(false):get(),
        request = RitnLibGuiElement(gui_name,"sprite-button","request"):spritePath(defines.sprite.button_ask_link):style("frame_action_button"):get(),
        unrequest = RitnLibGuiElement(gui_name,"sprite-button","unrequest"):spritePath(defines.sprite.button_unrequest):style("frame_action_button"):visible(false):get(),
        empty_surfaces = RitnLibGuiElement(gui_name, "button", "empty_surfaces"):style(ritnlib.defines.portal.names.styles.ritnFrameButton):caption(captions.dest_not_find):enabled(false):get(),
    },
    line = RitnLibGuiElement(gui_name,"line","line"):horizontal():get(),
    list = {
        surfaces = RitnLibGuiElement(gui_name,"list-box","surfaces"):get(),
    },
    empty = {
        empty = RitnLibGuiElement(gui_name,"empty-widget","empty"):get(),
        dragspace = RitnLibGuiElement(gui_name,"empty-widget","dragspace"):style("draggable_space_header"):get(),
    }    
}


local content = {
    flow = {
        header = {
            "frame-main",
            "frame-top",
            "flow-header",
        },
        namer = {
            "frame-main",
            "frame-submain",
            "flow-namer",
        },
        surfaces = {
            "frame-main",
            "frame-submain",
            "flow-surfaces",
        },
        dialog = {
            "frame-main",
            "frame-submain",
            "flow-dialog",
        },
        dialog_surfaces = {
            "frame-main",
            "frame-submain",
            "flow-surfaces",
            "flow-dialog_surfaces",
        },
        empty_surfaces = {
            "frame-main",
            "frame-submain",
            "flow-empty_surfaces",
        },
    },
    frame = {
        main = {"frame-main"},
        top = {
            "frame-main",
            "frame-top",
        },
        submain = {
            "frame-main",
            "frame-submain",
        },
    },
    label = {
        title = {
            "frame-main",
            "frame-top",
            "flow-header",
            "label-title",
        },
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
        list_dest = {
            "frame-main",
            "frame-submain",
            "flow-surfaces",
            "label-list_dest",
        },
    },
    button = {
        close = {
            "frame-main",
            "frame-top",
            "flow-header",
            "button-close",
        },
        empty_surfaces = {
            "frame-main",
            "frame-submain",
            "flow-empty_surfaces",
            "button-empty_surfaces",
        },
        link = {
            "frame-main",
            "frame-submain",
            "flow-surfaces",
            "flow-dialog_surfaces",
            "button-link",
        },
        unlink = {
            "frame-main",
            "frame-submain",
            "flow-namer",
            "button-unlink",
        },
        request = {
            "frame-main",
            "frame-submain",
            "flow-surfaces",
            "flow-dialog_surfaces",
            "button-request",
        },
        unrequest = {
            "frame-main",
            "frame-submain",
            "flow-namer",
            "button-unrequest",
        },
    },
    list = {
        surfaces = {
            "frame-main",
            "frame-submain",
            "flow-surfaces",
            "listbox-surfaces",
        },
    },       
    empty = {
        empty = {
            "frame-main",
            "frame-submain",
            "flow-surfaces",
            "flow-dialog_surfaces",
        },
        dragspace = {
            "frame-main",
            "frame-top",
            "flow-header",
            "empty-dragspace",
        },
    }
}



local elements = {
    -- main start
    {
        parent = "start",
        name = "main",
        gui = element.frame.main
    },

        {
            parent = "main",
            name = "frame-top",
            gui = element.frame.top
        },
            {
                parent = "frame-top",
                name = "header",
                gui = element.flow.header
            },
                {
                    parent = "header",
                    name = "title",
                    gui = element.label.title
                },
                {
                    parent = "header",
                    name = "dragspace",
                    gui = element.empty.dragspace
                },
                {
                    parent = "header",
                    name = "close",
                    gui = element.button.close
                },

        -- submain
        {
            parent = "main",
            name = "submain",
            gui = element.frame.submain
        },
            {
                parent = "submain",
                name = "info",
                gui = element.label.info
            },
            {
                parent = "submain",
                name = "flow-namer",
                gui = element.flow.namer
            },
                {
                    parent = "flow-namer",
                    name = "namer",
                    gui = element.label.namer
                },
                {
                    parent = "flow-namer",
                    name = "button-unrequest",
                    gui = element.button.unrequest
                },
                {
                    parent = "flow-namer",
                    name = "button-unlink",
                    gui = element.button.unlink
                },

            {
                parent = "submain",
                name = "line",
                gui = element.line
            },
            {
                parent = "submain",
                name = "enter",
                gui = element.label.enter
            },
            
            {
                parent = "submain",
                name = "flow-empty_surfaces",
                gui = element.flow.empty_surfaces
            },
                {
                    parent = "flow-empty_surfaces",
                    name = "button-empty_surfaces",
                    gui = element.button.empty_surfaces
                },
                
            -- flow-surfaces
            {
                parent = "submain",
                name = "flow-surfaces",
                gui = element.flow.surfaces
            },
                {
                    parent = "flow-surfaces",
                    name = "label-list_dest",
                    gui = element.label.list_dest
                },
                {
                    parent = "flow-surfaces",
                    name = "list-surfaces",
                    gui = element.list.surfaces
                },
                {
                    parent = "flow-surfaces",
                    name = "flow-dialog_surfaces",
                    gui = element.flow.dialog_surfaces
                },
                    {
                        parent = "flow-dialog_surfaces",
                        name = "empty-empty",
                        gui = element.empty.empty
                    },
                    {
                        parent = "flow-dialog_surfaces",
                        name = "button-link",
                        gui = element.button.link
                    },
                    {
                        parent = "flow-dialog_surfaces",
                        name = "button-request",
                        gui = element.button.request
                    },
}

-----------------------------------------
return {
    elements = elements,
    content = content
}
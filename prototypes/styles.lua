-------------------------------------------------------------------------------
local RitnSprite = require(ritnlib.defines.class.prototype.sprite)
local RitnStyle = require(ritnlib.defines.class.prototype.style)
-------------------------------------------------------------------------------

-- STYLES
RitnStyle():extendButton(ritnlib.defines.portal.names.styles.spriteButton, "button")

local graphicalSet = {
	base = {position = {0, 0}, corner_size = 8},
	shadow = {position = {440, 24}, corner_size = 8, draw_type = "outer"}
}

data.raw["gui-style"]["default"][ritnlib.defines.portal.names.styles.ritnFrameButton] = {
	type = "button_style",
	parent = "button",
	padding = 0,
	default_graphical_set = graphicalSet,
	hovered_graphical_set = graphicalSet,
	clicked_graphical_set = graphicalSet,
	disabled_graphical_set = graphicalSet,
	selected_graphical_set = graphicalSet,
	selected_hovered_graphical_set = graphicalSet,
}



-- SPRITES
RitnSprite:extend(
	ritnlib.defines.portal.names.sprite.button_edit,
	ritnlib.defines.portal.graphics.gui.button_edit
)
RitnSprite:extend(
	ritnlib.defines.portal.names.sprite.button_up,
	ritnlib.defines.portal.graphics.gui.button_up
)
RitnSprite:extend(
	ritnlib.defines.portal.names.sprite.button_down,
	ritnlib.defines.portal.graphics.gui.button_down
)
RitnSprite:extend(
	ritnlib.defines.portal.names.sprite.button_valid,
	ritnlib.defines.portal.graphics.gui.button_valid
)

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
	ritnlib.defines.portal.names.sprite.inbound_link,
	ritnlib.defines.portal.graphics.gui.inbound_link,
	64	-- image size 64x64
)
RitnSprite:extend(
	ritnlib.defines.portal.names.sprite.button_ask_link,
	ritnlib.defines.portal.graphics.gui.button_ask_link,
	64	-- image size 64x64
)
RitnSprite:extend(
	ritnlib.defines.portal.names.sprite.button_close,
	ritnlib.defines.portal.graphics.gui.button_close
)
RitnSprite:extend(
	ritnlib.defines.portal.names.sprite.button_link,
	ritnlib.defines.portal.graphics.gui.button_link
)
RitnSprite:extend(
	ritnlib.defines.portal.names.sprite.button_unlink,
	ritnlib.defines.portal.graphics.gui.button_unlink
)
RitnSprite:extend(
	ritnlib.defines.portal.names.sprite.button_unrequest,
	ritnlib.defines.portal.graphics.gui.button_unrequest,
	64	-- image size 64x64
)
RitnSprite:extend(
	ritnlib.defines.portal.names.sprite.button_delete,
	ritnlib.defines.portal.graphics.gui.button_delete,
	64	-- image size 64x64
)
RitnSprite:extend(
	ritnlib.defines.portal.names.sprite.button_back,
	ritnlib.defines.portal.graphics.gui.button_back,
	64	-- image size 64x64
)
RitnSprite:extend(
	ritnlib.defines.portal.names.sprite.button_valid,
	ritnlib.defines.portal.graphics.gui.button_valid,
	64	-- image size 64x64
)

--INITIALIZE
--------------------------------------------------------------
if not ritnlib then require("__RitnLib__/defines") end
require("core.defines")
--------------------------------------------------------------
require(ritnlib.defines.portal.prototypes.category)
require(ritnlib.defines.portal.prototypes.entity)
require(ritnlib.defines.portal.prototypes.item)
require(ritnlib.defines.portal.prototypes.technology)
require(ritnlib.defines.portal.prototypes.styles)
require(ritnlib.defines.portal.prototypes.inputs)
require(ritnlib.defines.gui_styles)             -- gui_styles (RitnLib)
require(ritnlib.defines.fonts)                  -- FONTS (RitnLib)

-- get settings
local setting_value = true --settings.startup[ritnlib.defines.portal.settings.portal_enable.name].value

-- active portal
if setting_value then
    local tech = data.raw.technology[ritnlib.defines.portal.names.technology.teleport]
    tech.hidden = false
    tech.enabled = true
    ----
    tech = data.raw.technology[ritnlib.defines.portal.names.technology.capsule]
    tech.hidden = false
    tech.enabled = true
end

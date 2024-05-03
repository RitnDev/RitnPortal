--INITIALIZE
----------------------------------------------------------------------
require("core.defines")
----------------------------------------------------------------------
local RitnSetting = require(ritnlib.defines.class.ritnClass.setting)
----------------------------------------------------------------------
-- STARTUP SETTINGS
----------------------------------------------------------------------

--

----------------------------------------------------------------------
-- INGAME SETTINGS
----------------------------------------------------------------------

--

----------------------------------------------------------------------
-- BY PLAYER SETTINGS
----------------------------------------------------------------------

--[[
	{
		-- Envoie d'un message lorsqu'une recherche est terminé et que nous sommes pas sur notre surface
		type = "bool-setting",
		name = ritnlib.defines.lobby.names.settings.show_research,
		setting_type = "runtime-per-user",
		default_value = ritnlib.defines.lobby.value.settings.show_research,
		order = ritnlib.defines.lobby.name_prefix .. "lobby-02"
	},
]]

----------------------------------------------------------------------

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

-- Envoie d'un message lorsqu'une recherche est terminé et que nous sommes pas sur notre surface
local rSetting = RitnSetting(ritnlib.defines.portal.settings.show_research.name):setSettingPlayer()
rSetting:setDefaultValueBool(ritnlib.defines.portal.settings.show_research.value)
rSetting:setOrder(ritnlib.defines.portal.settings.prefix .. '01')
rSetting:new()


----------------------------------------------------------------------

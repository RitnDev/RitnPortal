local modules = {}
------------------------------------------------------------------------------

-- Inclus les events onInit et onLoad + les ajouts de commandes
modules.storage =               require(ritnlib.defines.portal.modules.storage)
modules.events =                require(ritnlib.defines.portal.modules.events)

---- Modules désactivable
modules.player =                require(ritnlib.defines.portal.modules.player) 
modules.portal =                require(ritnlib.defines.portal.modules.portal) 
modules.surface =               require(ritnlib.defines.portal.modules.surface) 
------------------------------------------------------------------------------
return modules
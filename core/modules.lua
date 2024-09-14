local modules = {}
------------------------------------------------------------------------------

-- Inclus les events onInit et onLoad + les ajouts de commandes
modules.globals =               require(ritnlib.defines.portal.modules.globals)
modules.events =                require(ritnlib.defines.portal.modules.events)

---- Modules désactivable
modules.player =                require(ritnlib.defines.portal.modules.player) 
modules.portal =                require(ritnlib.defines.portal.modules.portal) 
modules.surface =               require(ritnlib.defines.portal.modules.surface) 
------------------------------------------------------------------------------
return modules
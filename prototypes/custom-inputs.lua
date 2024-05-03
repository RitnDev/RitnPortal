local RitnInputCustom = require(ritnlib.defines.class.prototype.customInput)
------------------------------------------
-- TOUCHES DE RACCOURCIS CLAVIER DU MOD --
------------------------------------------

-- Ouverture/Fermeture du GUI :
RitnInputCustom:extend(ritnlib.defines.portal.names.customInput.frame_close1, '', 'none')
RitnInputCustom(ritnlib.defines.portal.names.customInput.frame_close1):linkedControl("open-character-gui")

RitnInputCustom:extend(ritnlib.defines.portal.names.customInput.frame_close2, '', 'none')
RitnInputCustom(ritnlib.defines.portal.names.customInput.frame_close2):linkedControl("toggle-menu")
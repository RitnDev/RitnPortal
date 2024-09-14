local RitnProtoRecipe = require(ritnlib.defines.class.prototype.recipe)
local RitnProtoTech = require(ritnlib.defines.class.prototype.technology)

if mods['RitnTeleporter'] then 
    RitnProtoRecipe(ritnlib.defines.portal.names.recipe.capsule):addNewIngredient(
        {name=ritnlib.defines.teleporter.names.item.capsule, amount=1}
    )

    local rTech = RitnProtoTech(ritnlib.defines.portal.names.technology.capsule)
    rTech:removePrerequisite("circuit-network")
    rTech:removePrerequisite("steel-processing")
    rTech:addPrerequisite(ritnlib.defines.teleporter.names.technology.capsule)
end
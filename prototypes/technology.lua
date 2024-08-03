data:extend({

    {
        --ritn-portal-capsule
        type = "technology",
        name = ritnlib.defines.portal.names.technology.capsule,
        icon = ritnlib.defines.portal.graphics.techno.capsule,
        icon_size = 64,
        hidden = false,
        enabled = true,
        effects = {
            {type = "unlock-recipe", recipe = ritnlib.defines.portal.names.recipe.capsule },
        },
        prerequisites = {"circuit-network", "steel-processing"},
        unit = {
            count = 200,
            ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1}
            },
            time = 30
        },
        order="a-d-e"
    }

})

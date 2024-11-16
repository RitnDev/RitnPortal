data:extend({

    {
        --item
        type = "capsule",
        name = ritnlib.defines.portal.names.item.capsule,
        icon = ritnlib.defines.portal.graphics.icon.capsule,
        icon_size = 64, icon_mipmaps = 4,
        stack_size = 10,
        subgroup = ritnlib.defines.portal.names.item_subgroups.teleport,
        order = "aaa[items]-aa[".. ritnlib.defines.portal.names.item.capsule .."]",      
        capsule_action =
        {
            type = "use-on-self",
            attack_parameters =
            {
                type = "stream",
                cooldown = 0,
                range = 0,
                sound = { filename = ritnlib.defines.portal.directory .. "/sounds/portal_open.ogg", volume = 0.5 },
                ammo_type =
                {
                    action = {
                        type = "direct"
                    },
                },
                ammo_category = "capsule"
            }
        },
    },
    {
        --recipe
        type = "recipe",
        name = ritnlib.defines.portal.names.recipe.capsule,
        icon = ritnlib.defines.portal.graphics.icon.capsule,
        icon_size = 64, icon_mipmaps = 4,
        energy_required = 17,
        enabled = false,
        ingredients =
        {
            {type="item", name="radar", amount=1},
            {type="item", name="steel-plate", amount=2},
            {type="item", name="electronic-circuit", amount=2},
            {type="item", name="copper-cable", amount=6},
            {type="item", name="arithmetic-combinator", amount=4},
            {type="item", name="power-switch", amount=2}
        },
        results = {
            {type = "item", name = ritnlib.defines.portal.names.item.capsule, amount = 1}
        },
        result_is_always_fresh = true
    },

    {
        --signal
        type = "virtual-signal",
        name = ritnlib.defines.portal.names.entity.portal,
        icon = ritnlib.defines.portal.graphics.icon.portal,
        icon_size = 64,
        stack_size = 1,
        subgroup = ritnlib.defines.portal.names.item_subgroups.teleport,
        order = "aaa[items]-ab[".. ritnlib.defines.portal.names.entity.portal .."]",
    }
})
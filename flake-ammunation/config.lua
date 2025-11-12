Config = {}

-- Marker settings
Config.MarkerType = 2 -- Bigger arrow marker (pointing down)
Config.MarkerSize = {x = 0.5, y = 0.5, z = 0.5}
Config.MarkerColor = {r = 0, g = 100, b = 255, a = 200} -- Blue color for all markers
Config.DrawDistance = 10.0
Config.InteractDistance = 2.0

-- Boss grades (grades that can access boss menu)
Config.BossGrades = {3, 4}


Config.Locations = {
    -- PILLBOX AMMUNATION (Main Store)
    {
        name = "Pillbox Ammunation",
        jobs = {'ammu', 'gunstore'}, -- Only these jobs can use this location
        blip = {
            enabled = true,
            sprite = 110,
            color = 1,
            scale = 0.8,
            label = "Ammunation"
        },

        -- Clock In/Out Points
        clockPoints = {
            {coords = vector3(18.6102, -1107.4122, 29.7972), heading = 160.0},
        },

        -- Boss Menu Points
        bossMenuPoints = {
            {coords = vector3(22.2305, -1107.6560, 29.7972)},
        },

        -- Wardrobe Points
        wardrobePoints = {
            {coords = vector3(11.6278, -1104.3796, 29.7971)},
        },

        -- Weapon Parts Store Points
        weaponPartsPoints = {
            {coords = vector3(9.5828, -1110.4293, 29.7972)},
        },

        -- Ammo Store Points
        ammoStorePoints = {
            {coords = vector3(13.7193, -1111.9468, 29.7972)},
        },

        -- Crafting Points
        craftingPoints = {
            {coords = vector3(4.5139, -1105.9982, 29.7972)},
        },

        -- Available items at this location (Pillbox - Full selection)
        availableParts = {
            {item = 'gunpowder', label = 'Gun Powder', price = 0, time = 5000},
            {item = 'screw', label = 'Screws', price = 0, time = 7000}
        },
        availableAmmo = {'ammo-9', 'ammo-rifle', 'ammo-45', 'ammo-shotgun'},
        availableRecipes = {'WEAPON_DVIPER', 'WEAPON_BH1301', 'WEAPON_TITAN22', 'WEAPON_BLUEARP'},
    },

    -- SANDY SHORES AMMUNATION
    {
        name = "Sandy Shores Ammunation",
        jobs = {'ammu', 'gunstore'}, -- Only these jobs can use this location
        blip = {
            enabled = true,
            sprite = 110,
            color = 1,
            scale = 0.8,
            label = "Ammunation - Sandy Shores"
        },

        clockPoints = {
            {coords = vector3(1692.41, 3759.50, 34.70), heading = 230.0},
        },

        bossMenuPoints = {
            {coords = vector3(1689.45, 3757.68, 34.70)},
        },

        wardrobePoints = {
            {coords = vector3(1686.92, 3755.44, 34.70)},
        },

        weaponPartsPoints = {
            {coords = vector3(1684.56, 3753.21, 34.70)},
        },

        ammoStorePoints = {
            {coords = vector3(1687.23, 3760.12, 34.70)},
        },

        craftingPoints = {
            {coords = vector3(1682.34, 3758.89, 34.70)},
        },

        -- Available items at this location (Sandy Shores - Pistols & Shotguns)
        availableParts = {
            {item = 'pistol_parts', label = 'Pistol Parts', price = 0, time = 5000},
            {item = 'shotgun_parts', label = 'Shotgun Parts', price = 0, time = 8000},
            {item = 'weapon_attachments', label = 'Weapon Attachments', price = 0, time = 6000}
        },
        availableAmmo = {'ammo-9', 'ammo-shotgun', 'ammo-45'},
        availableRecipes = {'WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_PUMPSHOTGUN'},
    },
}


Config.Uniforms = {
    -- Ammunation Job Uniform
    ['ammu'] = {
        male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 287, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 11,
            ['pants_1'] = 100, ['pants_2'] = 0,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0
        },
        female = {
            ['tshirt_1'] = 14, ['tshirt_2'] = 0,
            ['torso_1'] = 300, ['torso_2'] = 0,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 14,
            ['pants_1'] = 104, ['pants_2'] = 0,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0
        }
    },

    -- Gun Store Job Uniform
    ['gunstore'] = {
        male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 287, ['torso_2'] = 1,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 11,
            ['pants_1'] = 100, ['pants_2'] = 1,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0
        },
        female = {
            ['tshirt_1'] = 14, ['tshirt_2'] = 0,
            ['torso_1'] = 300, ['torso_2'] = 1,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 14,
            ['pants_1'] = 104, ['pants_2'] = 1,
            ['shoes_1'] = 25, ['shoes_2'] = 0,
            ['chain_1'] = 0, ['chain_2'] = 0
        }
    },

    -- Add more job uniforms here
}

-- Ammunition (for buying ammo)
Config.Ammunition = {
    {
        name = 'Pistol Ammo',
        item = 'ammo-9',
        price = 0,
        time = 3000,
        label = 'Pistol Ammo (9mm)',
        amount = 50 -- Amount per purchase
    },
    {
        name = 'Rifle Ammo',
        item = 'ammo-rifle',
        price = 0,
        time = 4000,
        label = 'Rifle Ammo (5.56mm)',
        amount = 50
    },
    {
        name = 'Shotgun Shells',
        item = 'ammo-shotgun',
        price = 0,
        time = 3500,
        label = 'Shotgun Shells (12 Gauge)',
        amount = 50
    },
    {
        name = 'SMG Ammo',
        item = 'ammo-45',
        price = 0,
        time = 3000,
        label = 'SMG Ammo (.45 ACP)',
        amount = 50
    },
    {
        name = 'Heavy Ammo',
        item = 'ammo-rifle2',
        price = 0,
        time = 5000,
        label = 'Heavy Rifle Ammo (7.62mm)',
        amount = 50
    }
}

-- Crafting Recipes
Config.CraftingRecipes = {
    {
        name = 'WEAPON_PISTOL',
        label = 'Pistol',
        time = 15000,
        requires = {
            {item = 'stone', count = 1},
            {item = 'money', count = 500}
        }
    },
    {
        name = 'WEAPON_BLUEARP',
        label = 'Blue ARP',
        time = 15000,
        requires = {
            {item = 'gunpowder', count = 1},
            {item = 'screw', count = 1}
        }
    },
    {
        name = 'WEAPON_DVIPER',
        label = 'DESERT VIPER',
        time = 15000,
        requires = {
            {item = 'gunpowder', count = 1},
            {item = 'screw', count = 1}
        }
    },
    {
        name = 'WEAPON_BH1301',
        label = 'BLACKHAWK 1301',
        time = 15000,
        requires = {
            {item = 'gunpowder', count = 1},
            {item = 'screw', count = 1}
        }
    },
    {
        name = 'WEAPON_TITAN22',
        label = 'TITAN 22',
        time = 15000,
        requires = {
            {item = 'gunpowder', count = 1},
            {item = 'screw', count = 1}
        }
    },
    {
        name = 'WEAPON_COMBATPISTOL',
        label = 'Combat Pistol',
        time = 18000,
        requires = {
            {item = 'pistol_parts', count = 4},
            {item = 'weapon_attachments', count = 2}
        }
    },
    {
        name = 'WEAPON_SMG',
        label = 'SMG',
        time = 25000,
        requires = {
            {item = 'smg_parts', count = 5},
            {item = 'weapon_attachments', count = 3}
        }
    },
    {
        name = 'WEAPON_ASSAULTRIFLE',
        label = 'Assault Rifle',
        time = 35000,
        requires = {
            {item = 'rifle_parts', count = 6},
            {item = 'weapon_attachments', count = 4}
        }
    },
    {
        name = 'WEAPON_PUMPSHOTGUN',
        label = 'Pump Shotgun',
        time = 30000,
        requires = {
            {item = 'shotgun_parts', count = 5},
            {item = 'weapon_attachments', count = 3}
        }
    }
}
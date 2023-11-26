-- chunkname: @scripts/settings/impact_fx/material/material_impact_fx_nurgle_flesh.lua

local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local hit_types = SurfaceMaterialSettings.hit_types
local stop = {
	vfx = {
		{
			normal_rotation = true,
			effects = {
				"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
			}
		},
		{
			effects = {
				"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_melee_01"
			}
		}
	}
}
local entry = {
	vfx = {
		{
			normal_rotation = true,
			effects = {
				"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
			}
		},
		{
			normal_rotation = true,
			effects = {
				"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_melee_01"
			}
		}
	},
	sfx = {
		{
			event = "wwise/events/weapon/play_projectile_cover_penetration_in"
		},
		normal_rotation = true
	}
}
local exit = {
	vfx = {
		{
			normal_rotation = true,
			effects = {
				"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01"
			}
		},
		{
			normal_rotation = true,
			effects = {
				"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_weakspot_melee_01"
			}
		}
	},
	sfx = {
		{
			event = "wwise/events/weapon/play_projectile_cover_penetration_out"
		},
		normal_rotation = true
	}
}

return {
	[hit_types.stop] = stop,
	[hit_types.penetration_entry] = entry,
	[hit_types.penetration_exit] = exit
}

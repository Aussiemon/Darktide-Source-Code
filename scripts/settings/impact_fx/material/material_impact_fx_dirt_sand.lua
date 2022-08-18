local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local hit_types = SurfaceMaterialSettings.hit_types
local stop = {
	vfx = {
		{
			normal_rotation = true,
			effects = {
				"content/fx/particles/impacts/surfaces/impact_sand"
			}
		}
	}
}
local entry = {
	vfx = {
		{
			normal_rotation = true,
			effects = {
				"content/fx/particles/impacts/surfaces/impact_sand"
			}
		},
		{
			effects = {
				"content/fx/particles/impacts/covers/cover_generic_penetration_01"
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
				"content/fx/particles/impacts/surfaces/impact_sand"
			}
		},
		{
			effects = {
				"content/fx/particles/impacts/covers/cover_generic_exit_01"
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

-- chunkname: @scripts/settings/impact_fx/material/material_impact_fx_psychic_shield.lua

local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local hit_types = SurfaceMaterialSettings.hit_types
local stop = {
	vfx = {
		{
			normal_rotation = true,
			effects = {
				"content/fx/particles/abilities/psyker_shield_block",
			},
		},
	},
}
local entry = {
	vfx = {
		{
			normal_rotation = true,
			effects = {
				"content/fx/particles/abilities/psyker_shield_block",
			},
		},
		{
			effects = {
				"content/fx/particles/impacts/covers/cover_generic_penetration_01",
			},
		},
	},
}
local exit = {
	vfx = {
		{
			normal_rotation = true,
			effects = {
				"content/fx/particles/abilities/psyker_shield_block",
			},
		},
		{
			effects = {
				"content/fx/particles/impacts/covers/cover_generic_exit_01",
			},
		},
	},
}

return {
	[hit_types.stop] = stop,
	[hit_types.penetration_entry] = entry,
	[hit_types.penetration_exit] = exit,
}

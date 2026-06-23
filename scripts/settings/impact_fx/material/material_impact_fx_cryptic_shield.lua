-- chunkname: @scripts/settings/impact_fx/material/material_impact_fx_cryptic_shield.lua

local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local hit_types = SurfaceMaterialSettings.hit_types
local stop = {
	vfx = {
		{
			normal_rotation = true,
			only_3p = true,
			effects = {
				"content/fx/particles/abilities/cryptic/cryptic_force_field_bullet_block",
			},
		},
		{
			normal_rotation = true,
			only_1p = true,
			effects = {
				"content/fx/particles/abilities/cryptic/cryptic_force_field_bullet_block_1p",
			},
		},
	},
	sfx = {
		{
			event = "wwise/events/player/play_ability_active_cryptic_forcefield_hit",
			hit_direction_interface = true,
		},
		{
			event = "wwise/events/player/play_ability_active_cryptic_forcefield_hit_husk",
			only_3p = true,
		},
	},
}
local entry = {
	sfx = nil,
	vfx = {
		{
			normal_rotation = true,
			only_3p = true,
			effects = {
				"content/fx/particles/abilities/cryptic/cryptic_force_field_bullet_block",
			},
		},
		{
			only_3p = true,
			effects = {
				"content/fx/particles/impacts/covers/cover_generic_penetration_01",
			},
		},
	},
}
local exit = {
	sfx = nil,
	vfx = {
		{
			normal_rotation = true,
			only_3p = true,
			effects = {
				"content/fx/particles/abilities/cryptic/cryptic_force_field_bullet_block",
			},
		},
		{
			only_3p = true,
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

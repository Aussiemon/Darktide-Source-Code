﻿-- chunkname: @scripts/settings/impact_fx/impact_fx_minion_large_caliber.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local hit_types = SurfaceMaterialSettings.hit_types
local default_armor_decal
local blood_ball = {
	"content/decals/blood_ball/blood_ball",
}
local disgusting_blood_ball = {
	"content/decals/blood_ball/blood_ball_poxwalker",
}
local unarmored = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated_husk",
				only_3p = true,
			},
		},
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_02",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_02",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_02",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_02",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_02",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/generic_dust_unarmored",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01",
				},
			},
		},
	},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
	},
}
local armored = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored_husk",
				only_3p = true,
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored_husk",
				only_3p = true,
			},
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated_husk",
				only_3p = true,
			},
		},
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/autogun/autogun_impact_armored",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_reduced_damage_01",
				},
			},
		},
	},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
	},
	blood_ball = {
		weakspot_died = blood_ball,
		died = blood_ball,
	},
}
local super_armor = table.clone(armored)
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
	},
	vfx = {
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_02",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_02",
				},
			},
		},
		weakspot_damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_02",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_02",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
		},
		dead = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_blood_splatter_small_01",
				},
			},
		},
	},
	linked_decal = {
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
	},
	blood_ball = {
		weakspot_died = disgusting_blood_ball,
		died = disgusting_blood_ball,
	},
}
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local player = {
	sfx = {
		damage = {
			{
				event = "wwise/events/player/play_player_get_hit_bullet_gen",
				hit_direction_interface = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/player/play_player_get_hit_bullet_gen",
				hit_direction_interface = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored_husk",
				only_3p = true,
			},
		},
		toughness_absorbed = {
			{
				event = "wwise/events/player/play_toughness_hits",
				hit_direction_interface = true,
			},
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated_husk",
				only_3p = true,
			},
		},
		shield_blocked = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated_husk",
				only_3p = true,
			},
		},
	},
	vfx = {
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_02",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/surfaces/impact_super_armor",
				},
			},
		},
	},
	linked_decal = {},
	blood_ball = {},
}
local surface_fx = {}
local default_surface_fx = {
	[hit_types.stop] = {
		sfx = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_minion_large",
				group = "surface_material",
				normal_rotation = true,
				only_3p = true,
			},
		},
		vfx = {
			{
				normal_rotation = true,
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_wall",
				},
			},
		},
	},
	[hit_types.penetration_entry] = {
		sfx = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_minion_large",
				group = "surface_material",
				normal_rotation = true,
				only_3p = true,
			},
		},
		vfx = {
			{
				normal_rotation = true,
				effects = {
					"content/fx/particles/impacts/weapons/autogun/autogun_impact_wall",
				},
			},
		},
	},
	[hit_types.penetration_exit] = nil,
}

ImpactFxHelper.create_missing_surface_fx(surface_fx, default_surface_fx)

local surface_decal = {
	brick = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.26,
				min = 0.22,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_medium_01",
				"content/fx/units/weapons/small_caliber_concrete_large_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.26,
				min = 0.22,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_medium_01",
				"content/fx/units/weapons/small_caliber_concrete_large_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.35,
				min = 0.3,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_large_01",
			},
		},
	},
	concrete = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.26,
				min = 0.22,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_medium_01",
				"content/fx/units/weapons/small_caliber_concrete_large_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.26,
				min = 0.22,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_medium_01",
				"content/fx/units/weapons/small_caliber_concrete_large_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.35,
				min = 0.3,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_large_01",
			},
		},
	},
	metal_solid = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.15,
				min = 0.15,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_large_01",
				"content/fx/units/weapons/small_caliber_metal_medium_01",
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.15,
				min = 0.15,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_large_01",
				"content/fx/units/weapons/small_caliber_metal_medium_01",
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.15,
				min = 0.15,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_large_01",
				"content/fx/units/weapons/small_caliber_metal_medium_01",
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
	},
	metal_sheet = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.15,
				min = 0.15,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_large_01",
				"content/fx/units/weapons/small_caliber_metal_medium_01",
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.15,
				min = 0.15,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_large_01",
				"content/fx/units/weapons/small_caliber_metal_medium_01",
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.15,
				min = 0.15,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_large_01",
				"content/fx/units/weapons/small_caliber_metal_medium_01",
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
	},
	metal_catwalk = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.15,
				min = 0.15,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_large_01",
				"content/fx/units/weapons/small_caliber_metal_medium_01",
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.15,
				min = 0.15,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_large_01",
				"content/fx/units/weapons/small_caliber_metal_medium_01",
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.15,
				min = 0.15,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_large_01",
				"content/fx/units/weapons/small_caliber_metal_medium_01",
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
	},
	cloth = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.2,
				min = 0.2,
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_large_01",
				"content/fx/units/weapons/small_caliber_cloth_medium_01",
				"content/fx/units/weapons/small_caliber_cloth_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.2,
				min = 0.2,
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_large_01",
				"content/fx/units/weapons/small_caliber_cloth_medium_01",
				"content/fx/units/weapons/small_caliber_cloth_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.2,
				min = 0.2,
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_large_01",
				"content/fx/units/weapons/small_caliber_cloth_medium_01",
				"content/fx/units/weapons/small_caliber_cloth_small_01",
			},
		},
	},
	glass_breakable = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.4,
				min = 0.4,
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.4,
				min = 0.4,
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.4,
				min = 0.4,
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
	},
	glass_unbreakable = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.2,
				min = 0.2,
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.2,
				min = 0.2,
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.2,
				min = 0.2,
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
	},
	nurgle_flesh = NO_SURFACE_DECAL,
	wood_solid = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.2,
				min = 0.2,
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.2,
				min = 0.2,
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.2,
				min = 0.2,
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
	},
	wood_plywood = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.2,
				min = 0.2,
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.2,
				min = 0.2,
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.2,
				min = 0.2,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_small_01",
				"content/fx/units/weapons/small_caliber_concrete_medium_01",
				"content/fx/units/weapons/small_caliber_concrete_large_01",
			},
		},
	},
}

ImpactFxHelper.create_missing_surface_decals(surface_decal)

return {
	armor = {
		[armor_types.armored] = armored,
		[armor_types.berserker] = berserker,
		[armor_types.disgustingly_resilient] = disgustingly_resilient,
		[armor_types.player] = player,
		[armor_types.resistant] = resistant,
		[armor_types.super_armor] = super_armor,
		[armor_types.unarmored] = unarmored,
	},
	surface = surface_fx,
	surface_decal = surface_decal,
}

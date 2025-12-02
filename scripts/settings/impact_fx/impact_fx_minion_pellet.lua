-- chunkname: @scripts/settings/impact_fx/impact_fx_minion_pellet.lua

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
		blocked = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
				only_3p = true,
			},
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
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
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
				only_3p = true,
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
				only_3p = true,
			},
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated_husk",
				only_3p = true,
			},
		},
		dead = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
				only_3p = true,
			},
		},
	},
	vfx = {
		blocked = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01",
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01",
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01",
				},
			},
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01",
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
	},
	linked_decal = {
		blocked = nil,
		damage_negated = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
	},
	blood_ball = {
		blocked = nil,
		damage = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = blood_ball,
		died = blood_ball,
	},
}
local armored = {
	sfx = {
		blocked = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
				only_3p = true,
			},
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
				only_3p = true,
			},
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
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
		dead = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_armored_husk",
				only_3p = true,
			},
		},
	},
	vfx = {
		blocked = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
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
	},
	linked_decal = {
		blocked = nil,
		damage_negated = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
	},
	blood_ball = {
		blocked = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = blood_ball,
		died = blood_ball,
		weakspot_damage = blood_ball,
		damage = blood_ball,
	},
}
local super_armor = table.clone(armored)
local disgustingly_resilient = {
	sfx = {
		blocked = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
				only_3p = true,
			},
		},
		died = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
				only_3p = true,
			},
		},
		weakspot_damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
				only_3p = true,
			},
		},
		damage = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
				only_3p = true,
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
				only_3p = true,
			},
		},
		damage_negated = {
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated_husk",
				only_3p = true,
			},
		},
		dead = {
			{
				event = "wwise/events/weapon/play_bullet_hits_large_gen_husk",
				only_3p = true,
			},
		},
	},
	vfx = {
		blocked = nil,
		damage_reduced = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_weakspot_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01",
				},
			},
		},
		died = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01",
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
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01",
				},
			},
		},
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_ranged_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01",
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
	},
	linked_decal = {
		blocked = nil,
		damage_negated = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = default_armor_decal,
		died = default_armor_decal,
		weakspot_damage = default_armor_decal,
		damage = default_armor_decal,
		damage_reduced = default_armor_decal,
	},
	blood_ball = {
		blocked = nil,
		damage = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = disgusting_blood_ball,
		died = disgusting_blood_ball,
	},
}
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local player = {
	sfx = {
		blocked = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
		damage = {
			{
				event = "wwise/events/player/play_player_get_hit_pellets",
				hit_direction_interface = true,
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_unarmored_husk",
				only_3p = true,
			},
		},
		damage_reduced = {
			{
				event = "wwise/events/player/play_player_get_hit_pellets",
				hit_direction_interface = true,
			},
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
		toughness_absorbed = {
			{
				event = "wwise/events/player/play_toughness_hits",
				hit_direction_interface = true,
			},
		},
	},
	vfx = {
		blocked = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/ripper_gun/ripper_gun_impact_01",
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
	linked_decal = {
		blocked = nil,
		damage = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
	},
	blood_ball = {
		blocked = nil,
		damage = nil,
		damage_negated = nil,
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
	},
}
local surface_fx = {}
local default_surface_fx = {
	[hit_types.stop] = {
		sfx = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_gen",
				group = "surface_material",
				normal_rotation = true,
			},
		},
		vfx = {
			{
				normal_rotation = true,
				effects = {
					"content/fx/particles/weapons/rifles/shotgun/combat_shotgun_ogryn_impact",
				},
			},
		},
	},
	[hit_types.penetration_entry] = {
		sfx = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_gen",
				group = "surface_material",
				normal_rotation = true,
			},
		},
		vfx = {
			{
				normal_rotation = true,
				effects = {
					"content/fx/particles/weapons/rifles/shotgun/combat_shotgun_ogryn_impact",
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
				max = 0.18,
				min = 0.12,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.18,
				min = 0.12,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.18,
				min = 0.12,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_small_01",
			},
		},
	},
	concrete = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.18,
				min = 0.12,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.18,
				min = 0.12,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.18,
				min = 0.12,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_small_01",
			},
		},
	},
	metal_solid = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.16,
				min = 0.14,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.16,
				min = 0.14,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.16,
				min = 0.14,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
	},
	metal_sheet = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.16,
				min = 0.14,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.16,
				min = 0.14,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.16,
				min = 0.14,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
	},
	metal_catwalk = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.16,
				min = 0.14,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.16,
				min = 0.14,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.16,
				min = 0.14,
			},
			units = {
				"content/fx/units/weapons/small_caliber_metal_small_01",
			},
		},
	},
	cloth = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17,
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17,
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17,
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_small_01",
			},
		},
	},
	glass_breakable = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.48,
				min = 0.32,
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.48,
				min = 0.32,
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.48,
				min = 0.32,
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
	},
	glass_unbreakable = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17,
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17,
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17,
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
	},
	nurgle_flesh = NO_SURFACE_DECAL,
	wood_solid = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17,
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17,
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17,
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
	},
	wood_plywood = {
		[hit_types.stop] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17,
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17,
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			uniform_extents = {
				max = 0.25,
				min = 0.17,
			},
			units = {
				"content/fx/units/weapons/small_caliber_concrete_small_01",
			},
		},
	},
}

ImpactFxHelper.create_missing_surface_decals(surface_decal)

return {
	surface_overrides = nil,
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

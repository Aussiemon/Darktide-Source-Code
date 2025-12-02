-- chunkname: @scripts/settings/impact_fx/impact_fx_plasma.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local ImpactFxHelper = require("scripts/utilities/impact_fx_helper")
local SurfaceMaterialSettings = require("scripts/settings/surface_material_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local hit_types = SurfaceMaterialSettings.hit_types
local default_armor_decal = {
	extents = {
		min = {
			x = 0.25,
			y = 0.25,
		},
		max = {
			x = 0.25,
			y = 0.25,
		},
	},
	units = {
		"content/fx/units/weapons/vfx_decal_plasma_scorchmark",
	},
}
local blood_ball = {
	"content/decals/blood_ball/blood_ball",
}
local disgusting_blood_ball = {
	"content/decals/blood_ball/blood_ball_poxwalker",
}
local unarmored = {
	sfx = {
		blocked = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true,
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_lasgun_ricochet",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
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
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot_armored",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot_armored",
				only_1p = true,
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
		},
		damage_reduced = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_lasgun_ricochet",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_gen_damage_negated",
				only_1p = true,
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
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
local super_armor = table.clone(armored)
local disgustingly_resilient = {
	sfx = {
		blocked = nil,
		damage_reduced = nil,
		dead = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true,
			},
		},
		died = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
			{
				event = "wwise/events/weapon/play_bullet_hits_large_death",
				only_1p = true,
			},
		},
		weakspot_damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
			{
				event = "wwise/events/weapon/play_indicator_weakspot",
				only_1p = true,
			},
		},
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_lasgun_ricochet",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
				},
			},
		},
		damage_negated = {
			{
				effects = {
					"content/fx/particles/impacts/armor_ricochet",
				},
			},
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
				},
			},
			{
				effects = {
					"content/fx/particles/impacts/flesh/poxwalker_maggots_small_01",
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
		damage_reduced = nil,
		dead = nil,
		died = nil,
		shield_blocked = nil,
		shove = nil,
		weakspot_damage = nil,
		weakspot_died = nil,
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_gen",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_combat_lasgun_ricochet",
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
					"content/fx/particles/impacts/weapons/plasma_gun/plasma_gun_impact_small",
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
local surface_fx = {
	snow = {
		[hit_types.stop] = {
			sfx = {
				{
					append_husk_to_event_name = true,
					event = "wwise/events/weapon/play_bullet_hits_lasgun",
					group = "surface_material",
					normal_rotation = true,
				},
			},
			vfx = {
				{
					normal_rotation = true,
					effects = {
						"content/fx/particles/impacts/surfaces/plasma_charged_explosion_small_snow",
					},
				},
			},
		},
		[hit_types.penetration_entry] = {
			sfx = {
				{
					append_husk_to_event_name = true,
					event = "wwise/events/weapon/play_bullet_hits_lasgun",
					group = "surface_material",
					normal_rotation = true,
				},
			},
			vfx = {
				{
					normal_rotation = true,
					effects = {
						"content/fx/particles/impacts/surfaces/plasma_charged_explosion_small_snow",
					},
				},
			},
		},
		[hit_types.penetration_exit] = nil,
	},
}
local default_surface_fx = {
	[hit_types.stop] = {
		sfx = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_surface_impact_gen",
				group = "surface_material",
				normal_rotation = true,
			},
		},
		vfx = {
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
				},
			},
		},
	},
	[hit_types.penetration_entry] = {
		sfx = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/weapon/play_bullet_hits_plasmagun_surface_impact_gen",
				group = "surface_material",
				normal_rotation = true,
			},
		},
		vfx = {
			{
				effects = {
					"content/fx/particles/weapons/rifles/plasma_gun/plasma_charged_explosion_small",
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
			extents = {
				min = {
					x = 0.5,
					y = 0.5,
				},
				max = {
					x = 0.6,
					y = 0.6,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_concrete_small_01",
				"content/fx/units/weapons/boltgun_concrete_medium_01",
				"content/fx/units/weapons/boltgun_concrete_large_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.5,
					y = 0.5,
				},
				max = {
					x = 0.6,
					y = 0.6,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_concrete_small_01",
				"content/fx/units/weapons/boltgun_concrete_medium_01",
				"content/fx/units/weapons/boltgun_concrete_large_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.5,
					y = 0.5,
				},
				max = {
					x = 0.6,
					y = 0.6,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_concrete_small_01",
				"content/fx/units/weapons/boltgun_concrete_medium_01",
				"content/fx/units/weapons/boltgun_concrete_large_01",
			},
		},
	},
	concrete = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.5,
					y = 0.5,
				},
				max = {
					x = 0.6,
					y = 0.6,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_concrete_small_01",
				"content/fx/units/weapons/boltgun_concrete_medium_01",
				"content/fx/units/weapons/boltgun_concrete_large_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.5,
					y = 0.5,
				},
				max = {
					x = 0.6,
					y = 0.6,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_concrete_small_01",
				"content/fx/units/weapons/boltgun_concrete_medium_01",
				"content/fx/units/weapons/boltgun_concrete_large_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.5,
					y = 0.5,
				},
				max = {
					x = 0.6,
					y = 0.6,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_concrete_small_01",
				"content/fx/units/weapons/boltgun_concrete_medium_01",
				"content/fx/units/weapons/boltgun_concrete_large_01",
			},
		},
	},
	metal_solid = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
	},
	metal_sheet = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
	},
	metal_catwalk = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.2,
					y = 0.2,
				},
				max = {
					x = 0.2,
					y = 0.2,
				},
			},
			units = {
				"content/fx/units/weapons/boltgun_metal_small_01",
				"content/fx/units/weapons/boltgun_metal_medium_01",
				"content/fx/units/weapons/boltgun_metal_large_01",
			},
		},
	},
	cloth = {
		[hit_types.stop] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_large_01",
				"content/fx/units/weapons/small_caliber_cloth_medium_01",
				"content/fx/units/weapons/small_caliber_cloth_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_cloth_large_01",
				"content/fx/units/weapons/small_caliber_cloth_medium_01",
				"content/fx/units/weapons/small_caliber_cloth_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
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
			extents = {
				min = {
					x = 0.8,
					y = 0.8,
				},
				max = {
					x = 0.8,
					y = 0.8,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.8,
					y = 0.8,
				},
				max = {
					x = 0.8,
					y = 0.8,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.8,
					y = 0.8,
				},
				max = {
					x = 0.8,
					y = 0.8,
				},
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
			extents = {
				min = {
					x = 0.8,
					y = 0.8,
				},
				max = {
					x = 0.8,
					y = 0.8,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.8,
					y = 0.8,
				},
				max = {
					x = 0.8,
					y = 0.8,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_glass_large_01",
				"content/fx/units/weapons/small_caliber_glass_medium_01",
				"content/fx/units/weapons/small_caliber_glass_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.8,
					y = 0.8,
				},
				max = {
					x = 0.8,
					y = 0.8,
				},
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
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
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
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_entry] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
		[hit_types.penetration_exit] = {
			extents = {
				min = {
					x = 0.4,
					y = 0.4,
				},
				max = {
					x = 0.4,
					y = 0.4,
				},
			},
			units = {
				"content/fx/units/weapons/small_caliber_wood_large_01",
				"content/fx/units/weapons/small_caliber_wood_medium_01",
				"content/fx/units/weapons/small_caliber_wood_small_01",
			},
		},
	},
	nurgle_flesh = NO_SURFACE_DECAL,
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
